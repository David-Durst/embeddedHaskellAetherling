#include "Halide.h"
#include <stdio.h>

using namespace Halide;

Var x("x"), y("y"), c("c");
Var xo("xo"), yo("yo"), xi("xi"), yi("yi");

uint8_t phase = 3;

int windowR = 2;

Expr clampcast_u8(Expr in) {
    return cast<uint8_t>(clamp(in, 0, 255));
}

Expr clampcast_i8(Expr in) {
    return cast<int8_t>(clamp(in, -127, 127));
}

Expr clampcast_i16(Expr in) {
    return cast<int16_t>(clamp(in, -32767, 32767));
}

Func invert2x2 (Func matrix) {
    Func res("invert"), denorm, det;
    denorm(x, y) = matrix(x, y)[0] * matrix(x, y)[3] - matrix(x, y)[1] * matrix(x, y)[2];
    det(x, y) = select(denorm(x, y) != 0, 1/denorm(x, y), 0);
    res(x, y) = {det(x, y) * matrix(x, y)[3],
                 -det(x, y) * matrix(x, y)[1],
                 -det(x, y) * matrix(x, y)[2],
                 det(x, y) * matrix(x, y)[0]};
    return res;
}

Func invert2x2 (Func elem00, Func elem01, Func elem10, Func elem11) {
    Func res("invert"), denorm, det;
    denorm(x, y) = cast<float>(elem00(x, y) * elem11(x, y) - elem01(x, y) * elem01(x, y));
    det(x, y) = select(denorm(x, y) != 0, 1/denorm(x, y), 0);
    res(x, y) = {det(x, y) * elem11(x, y),
                 -det(x, y) * elem01(x, y),
                 -det(x, y) * elem10(x, y),
                 det(x, y) * elem00(x, y)};
    return res;
}

Func demosaic(Func raw) {
    Func rgb("rgb");

    Func raw16;
    Func neswNeighbors, diagNeighbors, vNeighbors, hNeighbors;
    Func green, red, blue;
    raw16(x, y) = cast<uint16_t>(raw(x, y));
    neswNeighbors(x, y) = cast<uint8_t>((raw16(x-1, y) + raw16(x+1, y) +
                                         raw16(x, y-1) + raw16(x, y+1))/4);
    diagNeighbors(x, y) = cast<uint8_t>((raw16(x-1, y-1) + raw16(x+1, y-1) +
                                         raw16(x-1, y+1) + raw16(x+1, y+1))/4);

    vNeighbors(x, y) = cast<uint8_t>((raw16(x, y-1) + raw16(x, y+1))/2);
    hNeighbors(x, y) = cast<uint8_t>((raw16(x-1, y) + raw16(x+1, y))/2);

    green(x, y) = select((y % 2) == (phase / 2),
                         select((x % 2) == (phase % 2), neswNeighbors(x, y), raw(x, y)), // First row, RG
                         select((x % 2) == (phase % 2), raw(x, y), neswNeighbors(x, y))); // Second row, GB

    red(x, y) = select((y % 2) == (phase / 2),
                       select((x % 2) == (phase % 2), raw(x, y), hNeighbors(x, y)), // First row, RG
                       select((x % 2) == (phase % 2), vNeighbors(x, y), diagNeighbors(x, y))); // Second row, GB

    blue(x, y) = select((y % 2) == (phase / 2),
                        select((x % 2) == (phase % 2), diagNeighbors(x, y), vNeighbors(x, y)), // First row, RG
                        select((x % 2) == (phase % 2), hNeighbors(x, y), raw(x, y))); // Second row, GB

    rgb(c, x, y) = cast<uint8_t>(select(c == 0, red(x, y),
                                        c == 1, green(x, y),
                                        blue(x, y)));

    return rgb;
}


Func downsample(Func input) {
    Func downsampled("downsampled");
    Func lowpass_y, lowpass_x;
    // lowpass filter before downsample
    lowpass_y(c, x, y) = cast<uint8_t>((cast<uint16_t>(input(c, x, y)) +
                                        cast<uint16_t>(input(c, x+1, y)))/2);
    lowpass_x(c, x, y) = cast<uint8_t>((cast<uint16_t>(lowpass_y(c, x, y)) +
                                        cast<uint16_t>(lowpass_y(c, x, y+1)))/2);

    // downsample
    downsampled(c, x, y) = lowpass_x(c, x*2, y*2);
    return downsampled;
}

Func gray(Func input) {
    Func func_gray("gray");
    func_gray(x, y) = cast<uint8_t>((77 * cast<uint16_t>(input(0, x, y))
                                     + 150 * cast<uint16_t>(input(1, x, y))
                                     + 29 * cast<uint16_t>(input(2, x, y))) >> 8);
    return func_gray;
}


class MyPipeline {
public:
    ImageParam input;
    Func output, hw_input, hw_output, mul;
    std::vector<Argument> args;


    MyPipeline()
        : input(UInt(8), 2),
          output("output"),
          hw_input("hw_input"),
          mul("mul"),
          hw_output("hw_output")
    {
      hw_input(x, y) = input(x, y);
      mul(x, y) = hw_input(x, y) + 5;
      hw_output(x, y) = mul(x, y);
      output(x, y) = hw_output(x, y);

      args = {input};
    }

    void compile_hls() {
        std::cout << "\ncompiling HLS code..." << std::endl;

        hw_input.compute_root();
        hw_output.compute_root();

        hw_output.tile(x, y, xo, yo, xi, yi, 200, 1);
          //.unroll(xi, 8);
           //unroll(xi, 8);
          //.reorder(xi, yi, xo, yo);
        hw_output.accelerate({hw_input}, xi, xo);

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
