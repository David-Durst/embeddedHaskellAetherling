// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop_Mem1D_4.h"
#include "Vtop__Syms.h"

#include "verilated_dpi.h"


//--------------------
// STATIC VARIABLES


//--------------------

VL_CTOR_IMP(Vtop_Mem1D_4) {
    // Reset internal values
    // Reset structure values
    _ctor_var_reset();
}

void Vtop_Mem1D_4::__Vconfigure(Vtop__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

Vtop_Mem1D_4::~Vtop_Mem1D_4() {
}

//--------------------
// Internal Methods

void Vtop_Mem1D_4::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+                    Vtop_Mem1D_4::_ctor_var_reset\n"); );
    // Body
    __PVT__clock = VL_RAND_RESET_I(1);
    __PVT__reset = VL_RAND_RESET_I(1);
    __PVT__io_r_ofs_0 = VL_RAND_RESET_I(1);
    __PVT__io_r_backpressure = VL_RAND_RESET_I(1);
    __PVT__io_w_ofs_0 = VL_RAND_RESET_I(1);
    __PVT__io_w_data_0 = VL_RAND_RESET_I(8);
    __PVT__io_w_en_0 = VL_RAND_RESET_I(1);
    __PVT__io_output = VL_RAND_RESET_I(8);
}
