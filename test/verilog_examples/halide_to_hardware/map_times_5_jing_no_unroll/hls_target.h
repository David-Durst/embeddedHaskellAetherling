#ifndef HALIDE_CODEGEN_HLS_TARGET_HLS_TARGET_H
#define HALIDE_CODEGEN_HLS_TARGET_HLS_TARGET_H

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <hls_stream.h>
#include "Stencil.h"

void hls_target(
hls::stream<AxiPackedStencil<uint8_t, 8, 1> > &hw_input,
hls::stream<AxiPackedStencil<uint8_t, 8, 1> > &hw_output);

#endif

