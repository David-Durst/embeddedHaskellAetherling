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

 uint8_t _p2_kernela0[9];
 // produce p2:kernel
 uint8_t _335 = (uint8_t)(0);
 _p2_kernela0[0] = _335;
 uint8_t _336 = (uint8_t)(0);
 _p2_kernela0[1] = _336;
 uint8_t _337 = (uint8_t)(0);
 _p2_kernela0[2] = _337;
 uint8_t _338 = (uint8_t)(0);
 _p2_kernela0[3] = _338;
 uint8_t _339 = (uint8_t)(0);
 _p2_kernela0[4] = _339;
 uint8_t _340 = (uint8_t)(0);
 _p2_kernela0[5] = _340;
 uint8_t _341 = (uint8_t)(0);
 _p2_kernela0[6] = _341;
 uint8_t _342 = (uint8_t)(0);
 _p2_kernela0[7] = _342;
 uint8_t _343 = (uint8_t)(0);
 _p2_kernela0[8] = _343;
 uint8_t _344 = (uint8_t)(0);
 _p2_kernela0[0] = _344;
 uint8_t _345 = (uint8_t)(1);
 _p2_kernela0[1] = _345;
 uint8_t _346 = (uint8_t)(0);
 _p2_kernela0[2] = _346;
 uint8_t _347 = (uint8_t)(1);
 _p2_kernela0[3] = _347;
 uint8_t _348 = (uint8_t)(2);
 _p2_kernela0[4] = _348;
 uint8_t _349 = (uint8_t)(1);
 _p2_kernela0[5] = _349;
 uint8_t _350 = (uint8_t)(0);
 _p2_kernela0[6] = _350;
 uint8_t _351 = (uint8_t)(1);
 _p2_kernela0[7] = _351;
 uint8_t _352 = (uint8_t)(0);
 _p2_kernela0[8] = _352;
 // consume p2:kernel
 hls::stream<PackedStencil<uint8_t, 3, 3> > _hw_input_stencil_stream;
#pragma HLS STREAM variable=_hw_input_stencil_stream depth=1
#pragma HLS RESOURCE variable=_hw_input_stencil_stream core=FIFO_SRL

 linebuffer<4, 4>(_hw_input_stencil_update_stream, _hw_input_stencil_stream);
 (void)0;
 // dispatch_stream(_hw_input_stencil_stream, 2, 3, 1, 4, 3, 1, 4, 1, "hw_output", 0, 0, 4, 0, 4);
 hls::stream<PackedStencil<uint8_t, 3, 3> > &_hw_input_stencil_stream_to_hw_output = _hw_input_stencil_stream;
 (void)0;
 // produce hw_output.stencil.stream
 for (int _hw_output_y___scan_dim_1 = 0; _hw_output_y___scan_dim_1 < 0 + 2; _hw_output_y___scan_dim_1++)
 {
  for (int _hw_output_x___scan_dim_0 = 0; _hw_output_x___scan_dim_0 < 0 + 2; _hw_output_x___scan_dim_0++)
  {
#pragma HLS PIPELINE II=1
   Stencil<uint8_t, 3, 3> _hw_input_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_input_stencil.value complete dim=0

   _hw_input_stencil = _hw_input_stencil_stream_to_hw_output.read();
   (void)0;
   Stencil<uint8_t, 1, 1> _hw_output_stencil;
#pragma HLS ARRAY_PARTITION variable=_hw_output_stencil.value complete dim=0

   int32_t _mula1[1];
   _mula1[0] = 0;
   int32_t _353 = _mula1[0];
   uint8_t _354 = _hw_input_stencil(0, 0);
   uint8_t _355 = _p2_kernela0[0];
   uint8_t _356 = _354 << _355;
   int32_t _357 = (int32_t)(_356);
   int32_t _358 = _353 + _357;
   _mula1[0] = _358;
   int32_t _359 = _mula1[0];
   uint8_t _360 = _hw_input_stencil(1, 0);
   uint8_t _361 = _p2_kernela0[1];
   uint8_t _362 = _360 << _361;
   int32_t _363 = (int32_t)(_362);
   int32_t _364 = _359 + _363;
   _mula1[0] = _364;
   int32_t _365 = _mula1[0];
   uint8_t _366 = _hw_input_stencil(2, 0);
   uint8_t _367 = _p2_kernela0[2];
   uint8_t _368 = _366 << _367;
   int32_t _369 = (int32_t)(_368);
   int32_t _370 = _365 + _369;
   _mula1[0] = _370;
   int32_t _371 = _mula1[0];
   uint8_t _372 = _hw_input_stencil(0, 1);
   uint8_t _373 = _p2_kernela0[3];
   uint8_t _374 = _372 << _373;
   int32_t _375 = (int32_t)(_374);
   int32_t _376 = _371 + _375;
   _mula1[0] = _376;
   int32_t _377 = _mula1[0];
   uint8_t _378 = _hw_input_stencil(1, 1);
   uint8_t _379 = _p2_kernela0[4];
   uint8_t _380 = _378 << _379;
   int32_t _381 = (int32_t)(_380);
   int32_t _382 = _377 + _381;
   _mula1[0] = _382;
   int32_t _383 = _mula1[0];
   uint8_t _384 = _hw_input_stencil(2, 1);
   uint8_t _385 = _p2_kernela0[5];
   uint8_t _386 = _384 << _385;
   int32_t _387 = (int32_t)(_386);
   int32_t _388 = _383 + _387;
   _mula1[0] = _388;
   int32_t _389 = _mula1[0];
   uint8_t _390 = _hw_input_stencil(0, 2);
   uint8_t _391 = _p2_kernela0[6];
   uint8_t _392 = _390 << _391;
   int32_t _393 = (int32_t)(_392);
   int32_t _394 = _389 + _393;
   _mula1[0] = _394;
   int32_t _395 = _mula1[0];
   uint8_t _396 = _hw_input_stencil(1, 2);
   uint8_t _397 = _p2_kernela0[7];
   uint8_t _398 = _396 << _397;
   int32_t _399 = (int32_t)(_398);
   int32_t _400 = _395 + _399;
   _mula1[0] = _400;
   int32_t _401 = _mula1[0];
   uint8_t _402 = _hw_input_stencil(2, 2);
   uint8_t _403 = _p2_kernela0[8];
   uint8_t _404 = _402 << _403;
   int32_t _405 = (int32_t)(_404);
   int32_t _406 = _401 + _405;
   _mula1[0] = _406;
   int32_t _407 = _mula1[0];
   int32_t _408 = _407 >> 4;
   uint8_t _409 = (uint8_t)(_408);
   _hw_output_stencil(0, 0) = _409;
   AxiPackedStencil<uint8_t, 1, 1> _hw_output_stencil_packed = _hw_output_stencil;
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


