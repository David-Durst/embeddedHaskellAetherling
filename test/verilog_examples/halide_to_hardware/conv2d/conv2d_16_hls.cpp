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
 uint8_t _290 = (uint8_t)(0);
 _p2_kernela0[0] = _290;
 uint8_t _291 = (uint8_t)(0);
 _p2_kernela0[1] = _291;
 uint8_t _292 = (uint8_t)(0);
 _p2_kernela0[2] = _292;
 uint8_t _293 = (uint8_t)(0);
 _p2_kernela0[3] = _293;
 uint8_t _294 = (uint8_t)(0);
 _p2_kernela0[4] = _294;
 uint8_t _295 = (uint8_t)(0);
 _p2_kernela0[5] = _295;
 uint8_t _296 = (uint8_t)(0);
 _p2_kernela0[6] = _296;
 uint8_t _297 = (uint8_t)(0);
 _p2_kernela0[7] = _297;
 uint8_t _298 = (uint8_t)(0);
 _p2_kernela0[8] = _298;
 uint8_t _299 = (uint8_t)(0);
 _p2_kernela0[0] = _299;
 uint8_t _300 = (uint8_t)(1);
 _p2_kernela0[1] = _300;
 uint8_t _301 = (uint8_t)(0);
 _p2_kernela0[2] = _301;
 uint8_t _302 = (uint8_t)(1);
 _p2_kernela0[3] = _302;
 uint8_t _303 = (uint8_t)(2);
 _p2_kernela0[4] = _303;
 uint8_t _304 = (uint8_t)(1);
 _p2_kernela0[5] = _304;
 uint8_t _305 = (uint8_t)(0);
 _p2_kernela0[6] = _305;
 uint8_t _306 = (uint8_t)(1);
 _p2_kernela0[7] = _306;
 uint8_t _307 = (uint8_t)(0);
 _p2_kernela0[8] = _307;
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
   int32_t _308 = _mula1[0];
   uint8_t _309 = _hw_input_stencil(0, 0);
   uint8_t _310 = _p2_kernela0[0];
   uint8_t _311 = _309 << _310;
   int32_t _312 = (int32_t)(_311);
   int32_t _313 = _308 + _312;
   _mula1[0] = _313;
   int32_t _314 = _mula1[0];
   uint8_t _315 = _hw_input_stencil(1, 0);
   uint8_t _316 = _p2_kernela0[1];
   uint8_t _317 = _315 << _316;
   int32_t _318 = (int32_t)(_317);
   int32_t _319 = _314 + _318;
   _mula1[0] = _319;
   int32_t _320 = _mula1[0];
   uint8_t _321 = _hw_input_stencil(2, 0);
   uint8_t _322 = _p2_kernela0[2];
   uint8_t _323 = _321 << _322;
   int32_t _324 = (int32_t)(_323);
   int32_t _325 = _320 + _324;
   _mula1[0] = _325;
   int32_t _326 = _mula1[0];
   uint8_t _327 = _hw_input_stencil(0, 1);
   uint8_t _328 = _p2_kernela0[3];
   uint8_t _329 = _327 << _328;
   int32_t _330 = (int32_t)(_329);
   int32_t _331 = _326 + _330;
   _mula1[0] = _331;
   int32_t _332 = _mula1[0];
   uint8_t _333 = _hw_input_stencil(1, 1);
   uint8_t _334 = _p2_kernela0[4];
   uint8_t _335 = _333 << _334;
   int32_t _336 = (int32_t)(_335);
   int32_t _337 = _332 + _336;
   _mula1[0] = _337;
   int32_t _338 = _mula1[0];
   uint8_t _339 = _hw_input_stencil(2, 1);
   uint8_t _340 = _p2_kernela0[5];
   uint8_t _341 = _339 << _340;
   int32_t _342 = (int32_t)(_341);
   int32_t _343 = _338 + _342;
   _mula1[0] = _343;
   int32_t _344 = _mula1[0];
   uint8_t _345 = _hw_input_stencil(0, 2);
   uint8_t _346 = _p2_kernela0[6];
   uint8_t _347 = _345 << _346;
   int32_t _348 = (int32_t)(_347);
   int32_t _349 = _344 + _348;
   _mula1[0] = _349;
   int32_t _350 = _mula1[0];
   uint8_t _351 = _hw_input_stencil(1, 2);
   uint8_t _352 = _p2_kernela0[7];
   uint8_t _353 = _351 << _352;
   int32_t _354 = (int32_t)(_353);
   int32_t _355 = _350 + _354;
   _mula1[0] = _355;
   int32_t _356 = _mula1[0];
   uint8_t _357 = _hw_input_stencil(2, 2);
   uint8_t _358 = _p2_kernela0[8];
   uint8_t _359 = _357 << _358;
   int32_t _360 = (int32_t)(_359);
   int32_t _361 = _356 + _360;
   _mula1[0] = _361;
   int32_t _362 = _mula1[0];
   int32_t _363 = _362 >> 4;
   uint8_t _364 = (uint8_t)(_363);
   _hw_output_stencil(0, 0) = _364;
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


