// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef _Vtop_StickySelects_H_
#define _Vtop_StickySelects_H_

#include "verilated.h"
#include "Vtop__Dpi.h"

class Vtop__Syms;

//----------

VL_MODULE(Vtop_StickySelects) {
  public:
    
    // PORTS
    // Begin mtask footprint  all: 
    VL_IN8(__PVT__clock,0,0);
    VL_IN8(__PVT__reset,0,0);
    VL_IN8(__PVT__io_ins_0,0,0);
    VL_IN8(__PVT__io_ins_1,0,0);
    VL_IN8(__PVT__io_ins_2,0,0);
    VL_IN8(__PVT__io_ins_3,0,0);
    VL_IN8(__PVT__io_ins_4,0,0);
    VL_IN8(__PVT__io_ins_5,0,0);
    VL_IN8(__PVT__io_ins_6,0,0);
    VL_IN8(__PVT__io_ins_7,0,0);
    VL_IN8(__PVT__io_ins_8,0,0);
    VL_OUT8(__PVT__io_outs_0,0,0);
    VL_OUT8(__PVT__io_outs_1,0,0);
    VL_OUT8(__PVT__io_outs_2,0,0);
    VL_OUT8(__PVT__io_outs_3,0,0);
    VL_OUT8(__PVT__io_outs_4,0,0);
    VL_OUT8(__PVT__io_outs_5,0,0);
    VL_OUT8(__PVT__io_outs_6,0,0);
    VL_OUT8(__PVT__io_outs_7,0,0);
    VL_OUT8(__PVT__io_outs_8,0,0);
    
    // LOCAL SIGNALS
    
    // LOCAL VARIABLES
    
    // INTERNAL VARIABLES
  private:
    Vtop__Syms* __VlSymsp;  // Symbol table
  public:
    
    // PARAMETERS
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vtop_StickySelects);  ///< Copying not allowed
  public:
    Vtop_StickySelects(const char* name="TOP");
    ~Vtop_StickySelects();
    
    // API METHODS
    
    // INTERNAL METHODS
    void __Vconfigure(Vtop__Syms* symsp, bool first);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
} VL_ATTR_ALIGNED(128);

#endif // guard
