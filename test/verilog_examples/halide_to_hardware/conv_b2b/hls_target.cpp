#include "hls_target.h"

#include "Linebuffer.h"
#include "halide_math.h"
void hls_target(
hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &hw_input,
hls::stream<AxiPackedStencil<int32_t, 1, 1> > &hw_output)
{
#pragma HLS DATAFLOW
#pragma HLS INLINE region
#pragma HLS INTERFACE ap_hs port=hw_input
#pragma HLS INTERFACE ap_hs port=hw_output

 // alias the arguments
 hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &_hw_input_stencil_update_stream = hw_input;
 hls::stream<AxiPackedStencil<int32_t, 1, 1> > &_hw_output_stencil_stream = hw_output;

 int32_t _p2_kernela0[9];
 // produce p2:kernel
 _p2_kernela0[0] = 0;
 _p2_kernela0[1] = 0;
 _p2_kernela0[2] = 0;
 _p2_kernela0[3] = 0;
 _p2_kernela0[4] = 0;
 _p2_kernela0[5] = 0;
 _p2_kernela0[6] = 0;
 _p2_kernela0[7] = 0;
 _p2_kernela0[8] = 0;
 _p2_kernela0[0] = 0;
 _p2_kernela0[1] = 1;
 _p2_kernela0[2] = 0;
 _p2_kernela0[3] = 1;
 _p2_kernela0[4] = 2;
 _p2_kernela0[5] = 1;
 _p2_kernela0[6] = 0;
 _p2_kernela0[7] = 1;
 _p2_kernela0[8] = 0;
 // consume p2:kernel
 int32_t _p2_kernel1a1[4];
 // produce p2:kernel1
 _p2_kernel1a1[0] = 0;
 _p2_kernel1a1[1] = 0;
 _p2_kernel1a1[2] = 0;
 _p2_kernel1a1[3] = 0;
 _p2_kernel1a1[0] = 0;
 _p2_kernel1a1[1] = 2;
 _p2_kernel1a1[2] = 1;
 _p2_kernel1a1[3] = 0;
 // consume p2:kernel1
 hls::stream<PackedStencil<uint8_t, 3, 3> > _hw_input_stencil_stream;
#pragma HLS STREAM variable=_hw_input_stencil_stream depth=1
#pragma HLS RESOURCE variable=_hw_input_stencil_stream core=FIFO_SRL

 linebuffer<4, 4>(_hw_input_stencil_update_stream, _hw_input_stencil_stream);
 (void)0;
 // dispatch_stream(_hw_input_stencil_stream, 2, 3, 1, 4, 3, 1, 4, 1, "mul", 0, 0, 4, 0, 4);
 hls::stream<PackedStencil<uint8_t, 3, 3> > &_hw_input_stencil_stream_to_mul = _hw_input_stencil_stream;
 (void)0;
 hls::stream<PackedStencil<int32_t, 1, 1> > _mul_stencil_update_stream;
#pragma HLS STREAM variable=_mul_stencil_update_stream depth=1
#pragma HLS RESOURCE variable=_mul_stencil_update_stream core=FIFO_SRL

 // produce mul.stencil_update.stream
 for (int _mul_y___scan_dim_1 = 0; _mul_y___scan_dim_1 < 0 + 2; _mul_y___scan_dim_1++)
 {
  for (int _mul_x___scan_dim_0 = 0; _mul_x___scan_dim_0 < 0 + 2; _mul_x___scan_dim_0++)
  {
#pragma HLS PIPELINE II=1
   Stencil<uint8_t, 3, 3> _hw_input_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_input_stencil.value complete dim=0

   _hw_input_stencil = _hw_input_stencil_stream_to_mul.read();
   (void)0;
   Stencil<int32_t, 1, 1> _mul_stencil;
#pragma HLS ARRAY_PARTITION variable=_mul_stencil.value complete dim=0

   _mul_stencil(0, 0) = 0;
   int32_t _237 = _mul_stencil(0, 0);
   uint8_t _238 = _hw_input_stencil(0, 0);
   int32_t _239 = (int32_t)(_238);
   int32_t _240 = _p2_kernela0[0];
   int32_t _241 = _239 >> _240;
   int32_t _242 = _237 + _241;
   _mul_stencil(0, 0) = _242;
   int32_t _243 = _mul_stencil(0, 0);
   uint8_t _244 = _hw_input_stencil(1, 0);
   int32_t _245 = (int32_t)(_244);
   int32_t _246 = _p2_kernela0[1];
   int32_t _247 = _245 >> _246;
   int32_t _248 = _243 + _247;
   _mul_stencil(0, 0) = _248;
   int32_t _249 = _mul_stencil(0, 0);
   uint8_t _250 = _hw_input_stencil(2, 0);
   int32_t _251 = (int32_t)(_250);
   int32_t _252 = _p2_kernela0[2];
   int32_t _253 = _251 >> _252;
   int32_t _254 = _249 + _253;
   _mul_stencil(0, 0) = _254;
   int32_t _255 = _mul_stencil(0, 0);
   uint8_t _256 = _hw_input_stencil(0, 1);
   int32_t _257 = (int32_t)(_256);
   int32_t _258 = _p2_kernela0[3];
   int32_t _259 = _257 >> _258;
   int32_t _260 = _255 + _259;
   _mul_stencil(0, 0) = _260;
   int32_t _261 = _mul_stencil(0, 0);
   uint8_t _262 = _hw_input_stencil(1, 1);
   int32_t _263 = (int32_t)(_262);
   int32_t _264 = _p2_kernela0[4];
   int32_t _265 = _263 >> _264;
   int32_t _266 = _261 + _265;
   _mul_stencil(0, 0) = _266;
   int32_t _267 = _mul_stencil(0, 0);
   uint8_t _268 = _hw_input_stencil(2, 1);
   int32_t _269 = (int32_t)(_268);
   int32_t _270 = _p2_kernela0[5];
   int32_t _271 = _269 >> _270;
   int32_t _272 = _267 + _271;
   _mul_stencil(0, 0) = _272;
   int32_t _273 = _mul_stencil(0, 0);
   uint8_t _274 = _hw_input_stencil(0, 2);
   int32_t _275 = (int32_t)(_274);
   int32_t _276 = _p2_kernela0[6];
   int32_t _277 = _275 >> _276;
   int32_t _278 = _273 + _277;
   _mul_stencil(0, 0) = _278;
   int32_t _279 = _mul_stencil(0, 0);
   uint8_t _280 = _hw_input_stencil(1, 2);
   int32_t _281 = (int32_t)(_280);
   int32_t _282 = _p2_kernela0[7];
   int32_t _283 = _281 >> _282;
   int32_t _284 = _279 + _283;
   _mul_stencil(0, 0) = _284;
   int32_t _285 = _mul_stencil(0, 0);
   uint8_t _286 = _hw_input_stencil(2, 2);
   int32_t _287 = (int32_t)(_286);
   int32_t _288 = _p2_kernela0[8];
   int32_t _289 = _287 >> _288;
   int32_t _290 = _285 + _289;
   _mul_stencil(0, 0) = _290;
   _mul_stencil_update_stream.write(_mul_stencil);
   (void)0;
  } // for _mul_x___scan_dim_0
 } // for _mul_y___scan_dim_1
 // consume mul.stencil_update.stream
 hls::stream<PackedStencil<int32_t, 2, 2> > _mul_stencil_stream;
#pragma HLS STREAM variable=_mul_stencil_stream depth=1
#pragma HLS RESOURCE variable=_mul_stencil_stream core=FIFO_SRL

 linebuffer<2, 2>(_mul_stencil_update_stream, _mul_stencil_stream);
 (void)0;
 // dispatch_stream(_mul_stencil_stream, 2, 2, 1, 2, 2, 1, 2, 1, "p2:mul1", 0, 0, 2, 0, 2);
 hls::stream<PackedStencil<int32_t, 2, 2> > &_mul_stencil_stream_to_p2_mul1 = _mul_stencil_stream;
 (void)0;
 hls::stream<PackedStencil<int32_t, 1, 1> > _p2_mul1_stencil_stream;
#pragma HLS STREAM variable=_p2_mul1_stencil_stream depth=1
#pragma HLS RESOURCE variable=_p2_mul1_stencil_stream core=FIFO_SRL

 // produce p2:mul1.stencil.stream
 for (int _p2_mul1_y___scan_dim_1 = 0; _p2_mul1_y___scan_dim_1 < 0 + 1; _p2_mul1_y___scan_dim_1++)
 {
  for (int _p2_mul1_x___scan_dim_0 = 0; _p2_mul1_x___scan_dim_0 < 0 + 1; _p2_mul1_x___scan_dim_0++)
  {
#pragma HLS PIPELINE II=1
   Stencil<int32_t, 2, 2> _mul_stencil;
#pragma HLS ARRAY_PARTITION variable=_mul_stencil.value complete dim=0

   _mul_stencil = _mul_stencil_stream_to_p2_mul1.read();
   (void)0;
   Stencil<int32_t, 1, 1> _p2_mul1_stencil;
#pragma HLS ARRAY_PARTITION variable=_p2_mul1_stencil.value complete dim=0

   _p2_mul1_stencil(0, 0) = 0;
   int32_t _291 = _p2_mul1_stencil(0, 0);
   int32_t _292 = _mul_stencil(0, 0);
   int32_t _293 = _p2_kernel1a1[0];
   int32_t _294 = _292 >> _293;
   int32_t _295 = _291 + _294;
   _p2_mul1_stencil(0, 0) = _295;
   int32_t _296 = _p2_mul1_stencil(0, 0);
   int32_t _297 = _mul_stencil(1, 0);
   int32_t _298 = _p2_kernel1a1[1];
   int32_t _299 = _297 >> _298;
   int32_t _300 = _296 + _299;
   _p2_mul1_stencil(0, 0) = _300;
   int32_t _301 = _p2_mul1_stencil(0, 0);
   int32_t _302 = _mul_stencil(0, 1);
   int32_t _303 = _p2_kernel1a1[2];
   int32_t _304 = _302 >> _303;
   int32_t _305 = _301 + _304;
   _p2_mul1_stencil(0, 0) = _305;
   int32_t _306 = _p2_mul1_stencil(0, 0);
   int32_t _307 = _mul_stencil(1, 1);
   int32_t _308 = _p2_kernel1a1[3];
   int32_t _309 = _307 >> _308;
   int32_t _310 = _306 + _309;
   _p2_mul1_stencil(0, 0) = _310;
   _p2_mul1_stencil_stream.write(_p2_mul1_stencil);
   (void)0;
  } // for _p2_mul1_x___scan_dim_0
 } // for _p2_mul1_y___scan_dim_1
 // consume p2:mul1.stencil.stream
 // dispatch_stream(_p2_mul1_stencil_stream, 2, 1, 1, 1, 1, 1, 1, 1, "hw_output", 0, 0, 1, 0, 1);
 hls::stream<PackedStencil<int32_t, 1, 1> > &_p2_mul1_stencil_stream_to_hw_output = _p2_mul1_stencil_stream;
 (void)0;
 // produce hw_output.stencil.stream
 for (int _hw_output_y___scan_dim_1 = 0; _hw_output_y___scan_dim_1 < 0 + 1; _hw_output_y___scan_dim_1++)
 {
  for (int _hw_output_x___scan_dim_0 = 0; _hw_output_x___scan_dim_0 < 0 + 1; _hw_output_x___scan_dim_0++)
  {
#pragma HLS PIPELINE II=1
   Stencil<int32_t, 1, 1> _p2_mul1_stencil;
#pragma HLS ARRAY_PARTITION variable=_p2_mul1_stencil.value complete dim=0

   _p2_mul1_stencil = _p2_mul1_stencil_stream_to_hw_output.read();
   (void)0;
   Stencil<int32_t, 1, 1> _hw_output_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_output_stencil.value complete dim=0

   int32_t _311 = _p2_mul1_stencil(0, 0);
   _hw_output_stencil(0, 0) = _311;
   AxiPackedStencil<int32_t, 1, 1> _hw_output_stencil_packed = _hw_output_stencil;
   if (_hw_output_x___scan_dim_0 == 0 && _hw_output_y___scan_dim_1 == 0) {
    _hw_output_stencil_packed.last = 1;
   } else {
    _hw_output_stencil_packed.last = 0;
   }
   _hw_output_stencil_stream.write(_hw_output_stencil_packed);
   (void)0;
  } // for _hw_output_x___scan_dim_0
 } // for _hw_output_y___scan_dim_1
} // kernel hls_target_hls_target


