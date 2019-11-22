#ifndef HALIDE_CODEGEN_HLS_TARGET_HLS_TARGET_H
#define HALIDE_CODEGEN_HLS_TARGET_HLS_TARGET_H

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <hls_stream.h>
#include "Stencil.h"

//void hls_target(
    //int hw_input[1],
    //int hw_output[1]);

void hls_target(
hls::stream<int> &hw_input,
hls::stream<int> &hw_output);

//void hls_target(
//hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &hw_input,
//hls::stream<AxiPackedStencil<uint8_t, 1, 1> > &hw_output);

#endif

