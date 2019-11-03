// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop_StickySelects.h"
#include "Vtop__Syms.h"

#include "verilated_dpi.h"


//--------------------
// STATIC VARIABLES


//--------------------

VL_CTOR_IMP(Vtop_StickySelects) {
    // Reset internal values
    // Reset structure values
    _ctor_var_reset();
}

void Vtop_StickySelects::__Vconfigure(Vtop__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

Vtop_StickySelects::~Vtop_StickySelects() {
}

//--------------------
// Internal Methods

void Vtop_StickySelects::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+                    Vtop_StickySelects::_ctor_var_reset\n"); );
    // Body
    __PVT__clock = VL_RAND_RESET_I(1);
    __PVT__reset = VL_RAND_RESET_I(1);
    __PVT__io_ins_0 = VL_RAND_RESET_I(1);
    __PVT__io_ins_1 = VL_RAND_RESET_I(1);
    __PVT__io_ins_2 = VL_RAND_RESET_I(1);
    __PVT__io_ins_3 = VL_RAND_RESET_I(1);
    __PVT__io_ins_4 = VL_RAND_RESET_I(1);
    __PVT__io_ins_5 = VL_RAND_RESET_I(1);
    __PVT__io_ins_6 = VL_RAND_RESET_I(1);
    __PVT__io_ins_7 = VL_RAND_RESET_I(1);
    __PVT__io_ins_8 = VL_RAND_RESET_I(1);
    __PVT__io_outs_0 = VL_RAND_RESET_I(1);
    __PVT__io_outs_1 = VL_RAND_RESET_I(1);
    __PVT__io_outs_2 = VL_RAND_RESET_I(1);
    __PVT__io_outs_3 = VL_RAND_RESET_I(1);
    __PVT__io_outs_4 = VL_RAND_RESET_I(1);
    __PVT__io_outs_5 = VL_RAND_RESET_I(1);
    __PVT__io_outs_6 = VL_RAND_RESET_I(1);
    __PVT__io_outs_7 = VL_RAND_RESET_I(1);
    __PVT__io_outs_8 = VL_RAND_RESET_I(1);
}
