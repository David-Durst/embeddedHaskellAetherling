#include "hls_target.h"

#include "Linebuffer.h"
#include "halide_math.h"
void hls_target(
hls::stream<AxiPackedStencil<int8_t, 1, 1> > &hw_input,
hls::stream<AxiPackedStencil<int8_t, 1, 1> > &hw_output)
{
#pragma HLS DATAFLOW
#pragma HLS INLINE region
#pragma HLS INTERFACE ap_hs port=hw_input
#pragma HLS INTERFACE ap_hs port=hw_output

 // alias the arguments
 hls::stream<AxiPackedStencil<int8_t, 1, 1> > &_hw_input_stencil_update_stream = hw_input;
 hls::stream<AxiPackedStencil<int8_t, 1, 1> > &_hw_output_stencil_stream = hw_output;

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
 hls::stream<PackedStencil<int8_t, 3, 3> > _hw_input_stencil_stream;
#pragma HLS STREAM variable=_hw_input_stencil_stream depth=1
#pragma HLS RESOURCE variable=_hw_input_stencil_stream core=FIFO_SRL

 linebuffer<4, 4>(_hw_input_stencil_update_stream, _hw_input_stencil_stream);
 (void)0;
 // dispatch_stream(_hw_input_stencil_stream, 2, 3, 1, 4, 3, 1, 4, 2, "hw_output", 0, 0, 4, 0, 4, "mul", 0, 0, 4, 0, 4);
 hls::stream<PackedStencil<int8_t, 3, 3> > _hw_input_stencil_stream_to_hw_output;
#pragma HLS STREAM variable=_hw_input_stencil_stream_to_hw_output depth=1
#pragma HLS RESOURCE variable=_hw_input_stencil_stream_to_hw_output core=FIFO_SRL

 hls::stream<PackedStencil<int8_t, 3, 3> > _hw_input_stencil_stream_to_mul;
#pragma HLS STREAM variable=_hw_input_stencil_stream_to_mul depth=1
#pragma HLS RESOURCE variable=_hw_input_stencil_stream_to_mul core=FIFO_SRL

 for (int _dim_1 = 0; _dim_1 <= 1; _dim_1 += 1)
 for (int _dim_0 = 0; _dim_0 <= 1; _dim_0 += 1)
 {
#pragma HLS PIPELINE
  PackedStencil<int8_t, 3, 3> _tmp_stencil = _hw_input_stencil_stream.read();
  if (_dim_0 >= 0 && _dim_0 <= 1 && _dim_1 >= 0 && _dim_1 <= 1)
  {
   _hw_input_stencil_stream_to_hw_output.write(_tmp_stencil);
  }
  if (_dim_0 >= 0 && _dim_0 <= 1 && _dim_1 >= 0 && _dim_1 <= 1)
  {
   _hw_input_stencil_stream_to_mul.write(_tmp_stencil);
  }
 }
 (void)0;
 hls::stream<PackedStencil<int32_t, 1, 1> > _mul_stencil_stream;
#pragma HLS STREAM variable=_mul_stencil_stream depth=1
#pragma HLS RESOURCE variable=_mul_stencil_stream core=FIFO_SRL

 // produce mul.stencil.stream
 for (int _mul_y___scan_dim_1 = 0; _mul_y___scan_dim_1 < 0 + 2; _mul_y___scan_dim_1++)
 {
  for (int _mul_x___scan_dim_0 = 0; _mul_x___scan_dim_0 < 0 + 2; _mul_x___scan_dim_0++)
  {
#pragma HLS PIPELINE II=1
   Stencil<int8_t, 3, 3> _hw_input_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_input_stencil.value complete dim=0

   _hw_input_stencil = _hw_input_stencil_stream_to_mul.read();
   (void)0;
   Stencil<int32_t, 1, 1> _mul_stencil;
#pragma HLS ARRAY_PARTITION variable=_mul_stencil.value complete dim=0

   _mul_stencil(0, 0) = 0;
   int32_t _304 = _mul_stencil(0, 0);
   int8_t _305 = _hw_input_stencil(0, 0);
   int32_t _306 = (int32_t)(_305);
   int32_t _307 = _p2_kernela0[0];
   int32_t _308 = _306 << _307;
   int8_t _309 = (int8_t)(_308);
   int32_t _310 = (int32_t)(_309);
   int32_t _311 = _304 + _310;
   _mul_stencil(0, 0) = _311;
   int32_t _312 = _mul_stencil(0, 0);
   int8_t _313 = _hw_input_stencil(1, 0);
   int32_t _314 = (int32_t)(_313);
   int32_t _315 = _p2_kernela0[1];
   int32_t _316 = _314 << _315;
   int8_t _317 = (int8_t)(_316);
   int32_t _318 = (int32_t)(_317);
   int32_t _319 = _312 + _318;
   _mul_stencil(0, 0) = _319;
   int32_t _320 = _mul_stencil(0, 0);
   int8_t _321 = _hw_input_stencil(2, 0);
   int32_t _322 = (int32_t)(_321);
   int32_t _323 = _p2_kernela0[2];
   int32_t _324 = _322 << _323;
   int8_t _325 = (int8_t)(_324);
   int32_t _326 = (int32_t)(_325);
   int32_t _327 = _320 + _326;
   _mul_stencil(0, 0) = _327;
   int32_t _328 = _mul_stencil(0, 0);
   int8_t _329 = _hw_input_stencil(0, 1);
   int32_t _330 = (int32_t)(_329);
   int32_t _331 = _p2_kernela0[3];
   int32_t _332 = _330 << _331;
   int8_t _333 = (int8_t)(_332);
   int32_t _334 = (int32_t)(_333);
   int32_t _335 = _328 + _334;
   _mul_stencil(0, 0) = _335;
   int32_t _336 = _mul_stencil(0, 0);
   int8_t _337 = _hw_input_stencil(1, 1);
   int32_t _338 = (int32_t)(_337);
   int32_t _339 = _p2_kernela0[4];
   int32_t _340 = _338 << _339;
   int8_t _341 = (int8_t)(_340);
   int32_t _342 = (int32_t)(_341);
   int32_t _343 = _336 + _342;
   _mul_stencil(0, 0) = _343;
   int32_t _344 = _mul_stencil(0, 0);
   int8_t _345 = _hw_input_stencil(2, 1);
   int32_t _346 = (int32_t)(_345);
   int32_t _347 = _p2_kernela0[5];
   int32_t _348 = _346 << _347;
   int8_t _349 = (int8_t)(_348);
   int32_t _350 = (int32_t)(_349);
   int32_t _351 = _344 + _350;
   _mul_stencil(0, 0) = _351;
   int32_t _352 = _mul_stencil(0, 0);
   int8_t _353 = _hw_input_stencil(0, 2);
   int32_t _354 = (int32_t)(_353);
   int32_t _355 = _p2_kernela0[6];
   int32_t _356 = _354 << _355;
   int8_t _357 = (int8_t)(_356);
   int32_t _358 = (int32_t)(_357);
   int32_t _359 = _352 + _358;
   _mul_stencil(0, 0) = _359;
   int32_t _360 = _mul_stencil(0, 0);
   int8_t _361 = _hw_input_stencil(1, 2);
   int32_t _362 = (int32_t)(_361);
   int32_t _363 = _p2_kernela0[7];
   int32_t _364 = _362 << _363;
   int8_t _365 = (int8_t)(_364);
   int32_t _366 = (int32_t)(_365);
   int32_t _367 = _360 + _366;
   _mul_stencil(0, 0) = _367;
   int32_t _368 = _mul_stencil(0, 0);
   int8_t _369 = _hw_input_stencil(2, 2);
   int32_t _370 = (int32_t)(_369);
   int32_t _371 = _p2_kernela0[8];
   int32_t _372 = _370 << _371;
   int8_t _373 = (int8_t)(_372);
   int32_t _374 = (int32_t)(_373);
   int32_t _375 = _368 + _374;
   _mul_stencil(0, 0) = _375;
   _mul_stencil_stream.write(_mul_stencil);
   (void)0;
  } // for _mul_x___scan_dim_0
 } // for _mul_y___scan_dim_1
 // consume mul.stencil.stream
 // dispatch_stream(_mul_stencil_stream, 2, 1, 1, 2, 1, 1, 2, 1, "hw_output", 0, 0, 2, 0, 2);
 hls::stream<PackedStencil<int32_t, 1, 1> > &_mul_stencil_stream_to_hw_output = _mul_stencil_stream;
 (void)0;
 // produce hw_output.stencil.stream
 for (int _hw_output_y___scan_dim_1 = 0; _hw_output_y___scan_dim_1 < 0 + 2; _hw_output_y___scan_dim_1++)
 {
  for (int _hw_output_x___scan_dim_0 = 0; _hw_output_x___scan_dim_0 < 0 + 2; _hw_output_x___scan_dim_0++)
  {
#pragma HLS PIPELINE II=1
   Stencil<int32_t, 1, 1> _mul_stencil;
#pragma HLS ARRAY_PARTITION variable=_mul_stencil.value complete dim=0

   _mul_stencil = _mul_stencil_stream_to_hw_output.read();
   (void)0;
   Stencil<int8_t, 3, 3> _hw_input_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_input_stencil.value complete dim=0

   _hw_input_stencil = _hw_input_stencil_stream_to_hw_output.read();
   (void)0;
   Stencil<int8_t, 1, 1> _hw_output_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_output_stencil.value complete dim=0

   int8_t _376 = _hw_input_stencil(1, 1);
   int32_t _377 = _mul_stencil(0, 0);
   int32_t _378 = _377 >> 4;
   int8_t _379 = (int8_t)(_378);
   int8_t _380 = _376 - _379;
   int8_t _381 = _hw_input_stencil(2, 2);
   int8_t _382 = (int8_t)(0);
   uint8_t _383 = (uint8_t)(15);
   int8_t _384 = _382 - _380;
   bool _385 = _380 > _382;
   int8_t _386 = (int8_t)(_385 ? _380 : _384);
   uint8_t _387 = (uint8_t)(_386);
   uint8_t _388 = _387;
   bool _389 = _383 < _388;
   int8_t _390 = (int8_t)(_389 ? _380 : _382);
   int8_t _391 = _390 >> 2;
   int8_t _392 = _381 + _391;
   _hw_output_stencil(0, 0) = _392;
   AxiPackedStencil<int8_t, 1, 1> _hw_output_stencil_packed = _hw_output_stencil;
   if (_hw_output_x___scan_dim_0 == 1 && _hw_output_y___scan_dim_1 == 1) {
    _hw_output_stencil_packed.last = 1;
   } else {
    _hw_output_stencil_packed.last = 0;
   }
   _hw_output_stencil_stream.write(_hw_output_stencil_packed);
   (void)0;
  } // for _hw_output_x___scan_dim_0
 } // for _hw_output_y___scan_dim_1
} // kernel hls_target_hls_target


