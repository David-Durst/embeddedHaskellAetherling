#include "Halide.h"
#include <stdio.h>

using namespace Halide;

Var x("x"), y("y"), c("c");
Var xo("xo"), yo("yo"), xi("xi"), yi("yi"), xii("xii"), yii("yii");

class MyPipeline {
public:
    ImageParam input;
    Func output, hw_input, hw_output, mul, avg, kernel;
    RDom win;
    std::vector<Argument> args;

    MyPipeline()
        : input(UInt(8), 2),
          output("output"),
          hw_input("hw_input"),
          hw_output("hw_output"),
          mul("mul"),
          avg("avg"),
          win(0, 3, 0, 3)
    {

      kernel(x, y) = cast<uint8_t>(0);

      kernel(0, 0) = cast<uint8_t>(0);
      kernel(1, 0) = cast<uint8_t>(1);
      kernel(2, 0) = cast<uint8_t>(0);

      kernel(0, 1) = cast<uint8_t>(1);
      kernel(1, 1) = cast<uint8_t>(2);
      kernel(2, 1) = cast<uint8_t>(1);

      kernel(0, 2) = cast<uint8_t>(0);
      kernel(1, 2) = cast<uint8_t>(1);
      kernel(2, 2) = cast<uint8_t>(0);
      
      kernel.bound(x, 0, 3);
      kernel.bound(y, 0, 3);

      hw_input(x, y) = input(x, y);
      mul(x, y) = 0;
      mul(x, y) += cast<uint8_t>(hw_input(win.x + x, win.y + y)) << cast<uint8_t>(kernel(win.x, win.y));
      avg(x, y) = mul(x, y) >> 4;
      hw_output(x, y) = cast<uint8_t>(avg(x, y));
      output(x, y) = cast<uint8_t>(hw_output(x, y));

      args = {input};
    }

    void compile_hls() {
        std::cout << "\ncompiling HLS code..." << std::endl;

        hw_input.compute_root();
        hw_output.compute_root();

        //hw_input.unroll(x).unroll(y);
        //hw_output.tile(x, y, xo, yo, xi, yi, 4, 4)
          //.tile(xi, yi, xi, yi, xii, yii, 2, 2)
          //.unroll(xii)
          //.unroll(yii);

        //hw_output.accelerate({hw_input}, xi, xo);
        //.reorder(xi, yi, xo, yo)
          //.unroll(xi, 2)
          //.unroll(yi, 2);

        hw_output.tile(x, y, xo, yo, xi, yi, 2, 2)
          .reorder(xi, yi, xo, yo)
          .unroll(xi, 2)
          .unroll(yi, 2);
        hw_output.accelerate({hw_input}, yi, xo);
        kernel.compute_at(hw_output, xo).unroll(x).unroll(y);

        mul.update(0)
          .unroll(win.x).unroll(win.y);

          //.unroll(x, 2).unroll(y, 2);

        hw_input.bound(x, 0, 4);
        hw_input.bound(y, 0, 4);
        output.print_loop_nest();

        // Create the target for HLS simulation
        Target hls_target = get_target_from_environment();
        hls_target.set_feature(Target::CPlusPlusMangling);
        output.compile_to_lowered_stmt("pipeline_hls.ir.html", args, HTML, hls_target);
        output.compile_to_hls("pipeline_hls.cpp", args, "pipeline_hls", hls_target);
        output.compile_to_header("pipeline_hls.h", args, "pipeline_hls", hls_target);

        std::vector<Target::Feature> features({Target::Zynq});
        Target target(Target::Linux, Target::ARM, 32, features);
        output.compile_to_zynq_c("pipeline_zynq.c", args, "pipeline_zynq", target);
        output.compile_to_header("pipeline_zynq.h", args, "pipeline_zynq", target);
        output.compile_to_lowered_stmt("pipeline_zynq.ir.html", args, HTML, target);
    }
};

int main(int argc, char **argv) {
    MyPipeline p2;
    p2.compile_hls();

    return 0;
}
