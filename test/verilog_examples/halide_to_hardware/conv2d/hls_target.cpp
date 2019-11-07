#include "hls_target.h"

#include "Linebuffer.h"
#include "halide_math.h"
void hls_target(
hls::stream<AxiPackedStencil<uint8_t, 2, 1> > &hw_input,
hls::stream<AxiPackedStencil<uint8_t, 2, 1> > &hw_output)
{
#pragma HLS DATAFLOW
#pragma HLS INLINE region
#pragma HLS INTERFACE ap_hs port=hw_input
#pragma HLS INTERFACE ap_hs port=hw_output

 // alias the arguments
 hls::stream<AxiPackedStencil<uint8_t, 2, 1> > &_hw_input_stencil_update_stream = hw_input;
 hls::stream<AxiPackedStencil<uint8_t, 2, 1> > &_hw_output_stencil_stream = hw_output;

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
 hls::stream<PackedStencil<uint8_t, 4, 3> > _hw_input_stencil_stream;
#pragma HLS STREAM variable=_hw_input_stencil_stream depth=1
#pragma HLS RESOURCE variable=_hw_input_stencil_stream core=FIFO_SRL

 linebuffer<4, 4>(_hw_input_stencil_update_stream, _hw_input_stencil_stream);
 (void)0;
 // dispatch_stream(_hw_input_stencil_stream, 2, 4, 2, 4, 3, 1, 4, 1, "hw_output", 0, 0, 4, 0, 4);
 hls::stream<PackedStencil<uint8_t, 4, 3> > &_hw_input_stencil_stream_to_hw_output = _hw_input_stencil_stream;
 (void)0;
 // produce hw_output.stencil.stream
 for (int _hw_output_y___scan_dim_1 = 0; _hw_output_y___scan_dim_1 < 0 + 2; _hw_output_y___scan_dim_1++)
 {
  for (int _hw_output_x___scan_dim_0 = 0; _hw_output_x___scan_dim_0 < 0 + 1; _hw_output_x___scan_dim_0++)
  {
#pragma HLS PIPELINE II=1
   Stencil<uint8_t, 4, 3> _hw_input_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_input_stencil.value complete dim=0

   _hw_input_stencil = _hw_input_stencil_stream_to_hw_output.read();
   (void)0;
   Stencil<uint8_t, 2, 1> _hw_output_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_output_stencil.value complete dim=0

   int32_t _mula1[1];
   _mula1[0] = 0;
   int32_t _290 = _mula1[0];
   uint8_t _291 = _hw_input_stencil(0, 0);
   int32_t _292 = (int32_t)(_291);
   int32_t _293 = _p2_kernela0[0];
   int32_t _294 = _292 >> _293;
   int32_t _295 = _290 + _294;
   _mula1[0] = _295;
   int32_t _296 = _mula1[0];
   uint8_t _297 = _hw_input_stencil(1, 0);
   int32_t _298 = (int32_t)(_297);
   int32_t _299 = _p2_kernela0[1];
   int32_t _300 = _298 >> _299;
   int32_t _301 = _296 + _300;
   _mula1[0] = _301;
   int32_t _302 = _mula1[0];
   uint8_t _303 = _hw_input_stencil(2, 0);
   int32_t _304 = (int32_t)(_303);
   int32_t _305 = _p2_kernela0[2];
   int32_t _306 = _304 >> _305;
   int32_t _307 = _302 + _306;
   _mula1[0] = _307;
   int32_t _308 = _mula1[0];
   uint8_t _309 = _hw_input_stencil(0, 1);
   int32_t _310 = (int32_t)(_309);
   int32_t _311 = _p2_kernela0[3];
   int32_t _312 = _310 >> _311;
   int32_t _313 = _308 + _312;
   _mula1[0] = _313;
   int32_t _314 = _mula1[0];
   uint8_t _315 = _hw_input_stencil(1, 1);
   int32_t _316 = (int32_t)(_315);
   int32_t _317 = _p2_kernela0[4];
   int32_t _318 = _316 >> _317;
   int32_t _319 = _314 + _318;
   _mula1[0] = _319;
   int32_t _320 = _mula1[0];
   uint8_t _321 = _hw_input_stencil(2, 1);
   int32_t _322 = (int32_t)(_321);
   int32_t _323 = _p2_kernela0[5];
   int32_t _324 = _322 >> _323;
   int32_t _325 = _320 + _324;
   _mula1[0] = _325;
   int32_t _326 = _mula1[0];
   uint8_t _327 = _hw_input_stencil(0, 2);
   int32_t _328 = (int32_t)(_327);
   int32_t _329 = _p2_kernela0[6];
   int32_t _330 = _328 >> _329;
   int32_t _331 = _326 + _330;
   _mula1[0] = _331;
   int32_t _332 = _mula1[0];
   uint8_t _333 = _hw_input_stencil(1, 2);
   int32_t _334 = (int32_t)(_333);
   int32_t _335 = _p2_kernela0[7];
   int32_t _336 = _334 >> _335;
   int32_t _337 = _332 + _336;
   _mula1[0] = _337;
   int32_t _338 = _mula1[0];
   uint8_t _339 = _hw_input_stencil(2, 2);
   int32_t _340 = (int32_t)(_339);
   int32_t _341 = _p2_kernela0[8];
   int32_t _342 = _340 >> _341;
   int32_t _343 = _338 + _342;
   _mula1[0] = _343;
   int32_t _344 = _mula1[0];
   uint8_t _345 = (uint8_t)(_344);
   _hw_output_stencil(0, 0) = _345;
   int32_t _mula2[1];
   _mula2[0] = 0;
   int32_t _346 = _mula2[0];
   uint8_t _347 = _hw_input_stencil(1, 0);
   int32_t _348 = (int32_t)(_347);
   int32_t _349 = _p2_kernela0[0];
   int32_t _350 = _348 >> _349;
   int32_t _351 = _346 + _350;
   _mula2[0] = _351;
   int32_t _352 = _mula2[0];
   uint8_t _353 = _hw_input_stencil(2, 0);
   int32_t _354 = (int32_t)(_353);
   int32_t _355 = _p2_kernela0[1];
   int32_t _356 = _354 >> _355;
   int32_t _357 = _352 + _356;
   _mula2[0] = _357;
   int32_t _358 = _mula2[0];
   uint8_t _359 = _hw_input_stencil(3, 0);
   int32_t _360 = (int32_t)(_359);
   int32_t _361 = _p2_kernela0[2];
   int32_t _362 = _360 >> _361;
   int32_t _363 = _358 + _362;
   _mula2[0] = _363;
   int32_t _364 = _mula2[0];
   uint8_t _365 = _hw_input_stencil(1, 1);
   int32_t _366 = (int32_t)(_365);
   int32_t _367 = _p2_kernela0[3];
   int32_t _368 = _366 >> _367;
   int32_t _369 = _364 + _368;
   _mula2[0] = _369;
   int32_t _370 = _mula2[0];
   uint8_t _371 = _hw_input_stencil(2, 1);
   int32_t _372 = (int32_t)(_371);
   int32_t _373 = _p2_kernela0[4];
   int32_t _374 = _372 >> _373;
   int32_t _375 = _370 + _374;
   _mula2[0] = _375;
   int32_t _376 = _mula2[0];
   uint8_t _377 = _hw_input_stencil(3, 1);
   int32_t _378 = (int32_t)(_377);
   int32_t _379 = _p2_kernela0[5];
   int32_t _380 = _378 >> _379;
   int32_t _381 = _376 + _380;
   _mula2[0] = _381;
   int32_t _382 = _mula2[0];
   uint8_t _383 = _hw_input_stencil(1, 2);
   int32_t _384 = (int32_t)(_383);
   int32_t _385 = _p2_kernela0[6];
   int32_t _386 = _384 >> _385;
   int32_t _387 = _382 + _386;
   _mula2[0] = _387;
   int32_t _388 = _mula2[0];
   uint8_t _389 = _hw_input_stencil(2, 2);
   int32_t _390 = (int32_t)(_389);
   int32_t _391 = _p2_kernela0[7];
   int32_t _392 = _390 >> _391;
   int32_t _393 = _388 + _392;
   _mula2[0] = _393;
   int32_t _394 = _mula2[0];
   uint8_t _395 = _hw_input_stencil(3, 2);
   int32_t _396 = (int32_t)(_395);
   int32_t _397 = _p2_kernela0[8];
   int32_t _398 = _396 >> _397;
   int32_t _399 = _394 + _398;
   _mula2[0] = _399;
   int32_t _400 = _mula2[0];
   uint8_t _401 = (uint8_t)(_400);
   _hw_output_stencil(1, 0) = _401;
   AxiPackedStencil<uint8_t, 2, 1> _hw_output_stencil_packed = _hw_output_stencil;
   if (_hw_output_x___scan_dim_0 == 0 && _hw_output_y___scan_dim_1 == 1) {
    _hw_output_stencil_packed.last = 1;
   } else {
    _hw_output_stencil_packed.last = 0;
   }
   _hw_output_stencil_stream.write(_hw_output_stencil_packed);
   (void)0;
  } // for _hw_output_x___scan_dim_0
 } // for _hw_output_y___scan_dim_1
} // kernel hls_target_hls_target


