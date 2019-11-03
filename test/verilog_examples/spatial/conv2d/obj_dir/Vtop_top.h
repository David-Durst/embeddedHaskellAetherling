// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef _Vtop_top_H_
#define _Vtop_top_H_

#include "verilated.h"
#include "Vtop__Dpi.h"

class Vtop__Syms;
class Vtop_Mem1D_4;
class Vtop_StickySelects;

//----------

VL_MODULE(Vtop_top) {
  public:
    // CELLS
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_1;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_2;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_3;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_4;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_5;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_6;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_7;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_8;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_9;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_10;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_11;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_12;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_13;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_14;
    Vtop_Mem1D_4*      	__PVT__sampler_box__DOT__x283_lb_0__DOT__Mem1D_15;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_1;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_2;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_3;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_4;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_5;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_6;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_7;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_8;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_9;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_10;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_11;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_12;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_13;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_14;
    Vtop_StickySelects*	__PVT__sampler_box__DOT__x283_lb_0__DOT__StickySelects_15;
    
    // PORTS
    // Begin mtask footprint  all: 
    VL_IN8(CLK,0,0);
    VL_IN8(I,7,0);
    VL_OUT8(O,7,0);
    VL_OUT8(valid_down,0,0);
    VL_IN8(valid_up,0,0);
    
    // LOCAL SIGNALS
    // Begin mtask footprint  all: 
    VL_SIG8(__PVT__sampler_box__DOT__RetimeWrapper_56__DOT__sr__DOT__sr[4],7,0);
    
    // LOCAL VARIABLES
    
    // INTERNAL VARIABLES
  private:
    Vtop__Syms* __VlSymsp;  // Symbol table
  public:
    
    // PARAMETERS
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vtop_top);  ///< Copying not allowed
  public:
    Vtop_top(const char* name="TOP");
    ~Vtop_top();
    
    // API METHODS
    
    // INTERNAL METHODS
    void __Vconfigure(Vtop__Syms* symsp, bool first);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _initial__TOP__top__1(Vtop__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _settle__TOP__top__2(Vtop__Syms* __restrict vlSymsp) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(128);

#endif // guard
