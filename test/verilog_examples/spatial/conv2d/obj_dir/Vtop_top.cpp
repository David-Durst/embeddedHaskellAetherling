// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop_top.h"
#include "Vtop__Syms.h"

#include "verilated_dpi.h"


//--------------------
// STATIC VARIABLES


//--------------------

VL_CTOR_IMP(Vtop_top) {
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_1, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_2, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_3, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_4, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_5, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_6, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_7, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_8, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_9, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_10, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_11, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_12, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_13, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_14, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_15, Vtop_Mem1D_4);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_1, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_2, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_3, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_4, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_5, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_6, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_7, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_8, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_9, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_10, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_11, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_12, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_13, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_14, Vtop_StickySelects);
    VL_CELL(__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_15, Vtop_StickySelects);
    // Reset internal values
    // Reset structure values
    _ctor_var_reset();
}

void Vtop_top::__Vconfigure(Vtop__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

Vtop_top::~Vtop_top() {
}

//--------------------
// Internal Methods

void Vtop_top::_initial__TOP__top__1(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+      Vtop_top::_initial__TOP__top__1\n"); );
    Vtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // INITIAL at conv2d_16.v:9398
    vlSymsp->TOP__top.valid_down = 0U;
}

void Vtop_top::_settle__TOP__top__2(Vtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+      Vtop_top::_settle__TOP__top__2\n"); );
    Vtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlSymsp->TOP__top.O = vlSymsp->TOP__top.__PVT__sampler_box__DOT__RetimeWrapper_56__DOT__sr__DOT__sr
	[2U];
}

void Vtop_top::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+      Vtop_top::_ctor_var_reset\n"); );
    // Body
    CLK = VL_RAND_RESET_I(1);
    I = VL_RAND_RESET_I(8);
    O = VL_RAND_RESET_I(8);
    valid_down = VL_RAND_RESET_I(1);
    valid_up = VL_RAND_RESET_I(1);
    { int __Vi0=0; for (; __Vi0<4; ++__Vi0) {
	    __PVT__sampler_box__DOT__RetimeWrapper_56__DOT__sr__DOT__sr[__Vi0] = VL_RAND_RESET_I(8);
    }}
}
