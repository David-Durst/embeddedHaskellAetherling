#include "hls_target.h"

#include "Linebuffer.h"
#include "halide_math.h"
void hls_target(
hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &hw_input,
hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &hw_output)
{
#pragma HLS DATAFLOW
#pragma HLS INLINE region
#pragma HLS INTERFACE ap_hs port=hw_input
#pragma HLS INTERFACE ap_hs port=hw_output

 // alias the arguments
 hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &_hw_input_stencil_update_stream = hw_input;
 hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &_hw_output_stencil_stream = hw_output;

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
   int32_t _241 = _239 << _240;
   uint8_t _242 = (uint8_t)(_241);
   int32_t _243 = (int32_t)(_242);
   int32_t _244 = _237 + _243;
   _mul_stencil(0, 0) = _244;
   int32_t _245 = _mul_stencil(0, 0);
   uint8_t _246 = _hw_input_stencil(1, 0);
   int32_t _247 = (int32_t)(_246);
   int32_t _248 = _p2_kernela0[1];
   int32_t _249 = _247 << _248;
   uint8_t _250 = (uint8_t)(_249);
   int32_t _251 = (int32_t)(_250);
   int32_t _252 = _245 + _251;
   _mul_stencil(0, 0) = _252;
   int32_t _253 = _mul_stencil(0, 0);
   uint8_t _254 = _hw_input_stencil(2, 0);
   int32_t _255 = (int32_t)(_254);
   int32_t _256 = _p2_kernela0[2];
   int32_t _257 = _255 << _256;
   uint8_t _258 = (uint8_t)(_257);
   int32_t _259 = (int32_t)(_258);
   int32_t _260 = _253 + _259;
   _mul_stencil(0, 0) = _260;
   int32_t _261 = _mul_stencil(0, 0);
   uint8_t _262 = _hw_input_stencil(0, 1);
   int32_t _263 = (int32_t)(_262);
   int32_t _264 = _p2_kernela0[3];
   int32_t _265 = _263 << _264;
   uint8_t _266 = (uint8_t)(_265);
   int32_t _267 = (int32_t)(_266);
   int32_t _268 = _261 + _267;
   _mul_stencil(0, 0) = _268;
   int32_t _269 = _mul_stencil(0, 0);
   uint8_t _270 = _hw_input_stencil(1, 1);
   int32_t _271 = (int32_t)(_270);
   int32_t _272 = _p2_kernela0[4];
   int32_t _273 = _271 << _272;
   uint8_t _274 = (uint8_t)(_273);
   int32_t _275 = (int32_t)(_274);
   int32_t _276 = _269 + _275;
   _mul_stencil(0, 0) = _276;
   int32_t _277 = _mul_stencil(0, 0);
   uint8_t _278 = _hw_input_stencil(2, 1);
   int32_t _279 = (int32_t)(_278);
   int32_t _280 = _p2_kernela0[5];
   int32_t _281 = _279 << _280;
   uint8_t _282 = (uint8_t)(_281);
   int32_t _283 = (int32_t)(_282);
   int32_t _284 = _277 + _283;
   _mul_stencil(0, 0) = _284;
   int32_t _285 = _mul_stencil(0, 0);
   uint8_t _286 = _hw_input_stencil(0, 2);
   int32_t _287 = (int32_t)(_286);
   int32_t _288 = _p2_kernela0[6];
   int32_t _289 = _287 << _288;
   uint8_t _290 = (uint8_t)(_289);
   int32_t _291 = (int32_t)(_290);
   int32_t _292 = _285 + _291;
   _mul_stencil(0, 0) = _292;
   int32_t _293 = _mul_stencil(0, 0);
   uint8_t _294 = _hw_input_stencil(1, 2);
   int32_t _295 = (int32_t)(_294);
   int32_t _296 = _p2_kernela0[7];
   int32_t _297 = _295 << _296;
   uint8_t _298 = (uint8_t)(_297);
   int32_t _299 = (int32_t)(_298);
   int32_t _300 = _293 + _299;
   _mul_stencil(0, 0) = _300;
   int32_t _301 = _mul_stencil(0, 0);
   uint8_t _302 = _hw_input_stencil(2, 2);
   int32_t _303 = (int32_t)(_302);
   int32_t _304 = _p2_kernela0[8];
   int32_t _305 = _303 << _304;
   uint8_t _306 = (uint8_t)(_305);
   int32_t _307 = (int32_t)(_306);
   int32_t _308 = _301 + _307;
   _mul_stencil(0, 0) = _308;
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
   int32_t _309 = _p2_mul1_stencil(0, 0);
   int32_t _310 = _mul_stencil(0, 0);
   int32_t _311 = _310 >> 4;
   int32_t _312 = _p2_kernel1a1[0];
   int32_t _313 = _311 << _312;
   uint8_t _314 = (uint8_t)(_313);
   int32_t _315 = (int32_t)(_314);
   int32_t _316 = _309 + _315;
   _p2_mul1_stencil(0, 0) = _316;
   int32_t _317 = _p2_mul1_stencil(0, 0);
   int32_t _318 = _mul_stencil(1, 0);
   int32_t _319 = _318 >> 4;
   int32_t _320 = _p2_kernel1a1[1];
   int32_t _321 = _319 << _320;
   uint8_t _322 = (uint8_t)(_321);
   int32_t _323 = (int32_t)(_322);
   int32_t _324 = _317 + _323;
   _p2_mul1_stencil(0, 0) = _324;
   int32_t _325 = _p2_mul1_stencil(0, 0);
   int32_t _326 = _mul_stencil(0, 1);
   int32_t _327 = _326 >> 4;
   int32_t _328 = _p2_kernel1a1[2];
   int32_t _329 = _327 << _328;
   uint8_t _330 = (uint8_t)(_329);
   int32_t _331 = (int32_t)(_330);
   int32_t _332 = _325 + _331;
   _p2_mul1_stencil(0, 0) = _332;
   int32_t _333 = _p2_mul1_stencil(0, 0);
   int32_t _334 = _mul_stencil(1, 1);
   int32_t _335 = _334 >> 4;
   int32_t _336 = _p2_kernel1a1[3];
   int32_t _337 = _335 << _336;
   uint8_t _338 = (uint8_t)(_337);
   int32_t _339 = (int32_t)(_338);
   int32_t _340 = _333 + _339;
   _p2_mul1_stencil(0, 0) = _340;
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
   Stencil<uint8_t, 1, 1> _hw_output_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_output_stencil.value complete dim=0

   int32_t _341 = _p2_mul1_stencil(0, 0);
   int32_t _342 = _341 >> 3;
   uint8_t _343 = (uint8_t)(_342);
   _hw_output_stencil(0, 0) = _343;
   AxiPackedStencil<uint8_t, 1, 1> _hw_output_stencil_packed = _hw_output_stencil;
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


