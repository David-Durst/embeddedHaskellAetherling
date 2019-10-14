#include "vhls_target.h"

#include "Linebuffer.h"
#include "halide_math.h"
void vhls_target(
hls::stream<AxiPackedStencil<uint16_t, 1, 1> > &arg_0,
hls::stream<AxiPackedStencil<uint16_t, 1, 1> > &arg_1)
{
#pragma HLS DATAFLOW
#pragma HLS INLINE region
#pragma HLS INTERFACE s_axilite port=return bundle=config
#pragma HLS INTERFACE axis register port=arg_0
#pragma HLS INTERFACE axis register port=arg_1

 // alias the arguments
 hls::stream<AxiPackedStencil<uint16_t, 1, 1> > &_hw_input_stencil_stream = arg_0;
 hls::stream<AxiPackedStencil<uint16_t, 1, 1> > &_hw_output_stencil_stream = arg_1;

 // dispatch_stream(_hw_input_stencil_stream, 2, 1, 1, 100, 1, 1, 100, 1, "hw_output", 1, 0, 100, 0, 100);
 hls::stream<AxiPackedStencil<uint16_t, 1, 1> > _hw_input_stencil_stream_to_hw_output;
#pragma HLS STREAM variable=_hw_input_stencil_stream_to_hw_output depth=1
#pragma HLS RESOURCE variable=_hw_input_stencil_stream_to_hw_output core=FIFO_SRL

 for (int _dim_1 = 0; _dim_1 <= 99; _dim_1 += 1)
 for (int _dim_0 = 0; _dim_0 <= 99; _dim_0 += 1)
 {
#pragma HLS PIPELINE
  PackedStencil<uint16_t, 1, 1> _tmp_stencil = _hw_input_stencil_stream.read();
  if (_dim_0 >= 0 && _dim_0 <= 99 && _dim_1 >= 0 && _dim_1 <= 99)
  {
   _hw_input_stencil_stream_to_hw_output.write(_tmp_stencil);
  }
 }
 (void)0;
 // produce hw_output.stencil.stream
 for (int _hw_output_y___scan_dim_1 = 0; _hw_output_y___scan_dim_1 < 0 + 100; _hw_output_y___scan_dim_1++)
 {
  for (int _hw_output_x___scan_dim_0 = 0; _hw_output_x___scan_dim_0 < 0 + 100; _hw_output_x___scan_dim_0++)
  {
#pragma HLS PIPELINE II=1
   Stencil<uint16_t, 1, 1> _hw_input_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_input_stencil.value complete dim=0

_hw_input_stencil(0, 0, 0) = 0;
   // produce hw_input.stencil
   _hw_input_stencil = _hw_input_stencil_stream_to_hw_output.read();
   (void)0;
   // consume hw_input.stencil
   Stencil<uint16_t, 1, 1> _hw_output_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_output_stencil.value complete dim=0

_hw_output_stencil(0, 0, 0) = 0;
   // produce hw_output.stencil
   uint16_t _273 = _hw_input_stencil(0, 0);
   uint16_t _274 = (uint16_t)(5);
   uint16_t _275 = _273 * _274;
   _hw_output_stencil(0, 0) = _275;
   // consume hw_output.stencil
   AxiPackedStencil<uint16_t, 1, 1> _hw_output_stencil_packed = _hw_output_stencil;
   if (_hw_output_x___scan_dim_0 == 99 && _hw_output_y___scan_dim_1 == 99) {
    _hw_output_stencil_packed.last = 1;
   } else {
    _hw_output_stencil_packed.last = 0;
   }
   _hw_output_stencil_stream.write(_hw_output_stencil_packed);
   (void)0;
  } // for _hw_output_x___scan_dim_0
 } // for _hw_output_y___scan_dim_1
} // kernel hls_target_vhls_target


