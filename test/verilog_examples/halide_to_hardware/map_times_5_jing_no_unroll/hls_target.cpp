#include "hls_target.h"

#include "Linebuffer.h"
#include "halide_math.h"
void hls_target(
hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &hw_input,
hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &hw_output)
{
#pragma HLS DATAFLOW
#pragma HLS INLINE region
#pragma HLS INTERFACE s_axilite port=return bundle=config
#pragma HLS INTERFACE axis register port=hw_input
#pragma HLS INTERFACE axis register port=hw_output

 // alias the arguments
 hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &_hw_input_stencil_stream = hw_input;
 hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &_hw_output_stencil_stream = hw_output;

 // dispatch_stream(_hw_input_stencil_stream, 2, 1, 1, 32, 1, 1, 32, 1, "hw_output", 1, 0, 32, 0, 32);
 hls::stream<AxiPackedStencil<uint8_t, 1, 1> > _hw_input_stencil_stream_to_hw_output;
#pragma HLS STREAM variable=_hw_input_stencil_stream_to_hw_output depth=1
#pragma HLS RESOURCE variable=_hw_input_stencil_stream_to_hw_output core=FIFO_SRL

 for (int _dim_1 = 0; _dim_1 <= 31; _dim_1 += 1)
 for (int _dim_0 = 0; _dim_0 <= 31; _dim_0 += 1)
 {
#pragma HLS PIPELINE
  PackedStencil<uint8_t, 1, 1> _tmp_stencil = _hw_input_stencil_stream.read();
  if (_dim_0 >= 0 && _dim_0 <= 31 && _dim_1 >= 0 && _dim_1 <= 31)
  {
   _hw_input_stencil_stream_to_hw_output.write(_tmp_stencil);
  }
 }
 (void)0;
 // produce hw_output.stencil.stream
 for (int _hw_output_y___scan_dim_1 = 0; _hw_output_y___scan_dim_1 < 0 + 32; _hw_output_y___scan_dim_1++)
 {
  for (int _hw_output_x___scan_dim_0 = 0; _hw_output_x___scan_dim_0 < 0 + 32; _hw_output_x___scan_dim_0++)
  {
#pragma HLS PIPELINE II=1
   Stencil<uint8_t, 1, 1> _hw_input_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_input_stencil.value complete dim=0

   _hw_input_stencil = _hw_input_stencil_stream_to_hw_output.read();
   (void)0;
   Stencil<uint8_t, 1, 1> _hw_output_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_output_stencil.value complete dim=0

   uint8_t _258 = _hw_input_stencil(0, 0);
   uint8_t _259 = (uint8_t)(5);
   uint8_t _260 = _258 * _259;
   _hw_output_stencil(0, 0) = _260;
   AxiPackedStencil<uint8_t, 1, 1> _hw_output_stencil_packed = _hw_output_stencil;
   if (_hw_output_x___scan_dim_0 == 31 && _hw_output_y___scan_dim_1 == 31) {
    _hw_output_stencil_packed.last = 1;
   } else {
    _hw_output_stencil_packed.last = 0;
   }
   _hw_output_stencil_stream.write(_hw_output_stencil_packed);
   (void)0;
  } // for _hw_output_x___scan_dim_0
 } // for _hw_output_y___scan_dim_1
} // kernel hls_target_hls_target


