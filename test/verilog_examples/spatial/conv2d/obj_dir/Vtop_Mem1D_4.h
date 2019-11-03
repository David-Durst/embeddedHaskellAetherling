// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vtop.h for the primary calling header

#ifndef _Vtop_Mem1D_4_H_
#define _Vtop_Mem1D_4_H_

#include "verilated.h"
#include "Vtop__Dpi.h"

class Vtop__Syms;

//----------

VL_MODULE(Vtop_Mem1D_4) {
  public:
    
    // PORTS
    // Begin mtask footprint  all: 
    VL_IN8(__PVT__clock,0,0);
    VL_IN8(__PVT__reset,0,0);
    VL_IN8(__PVT__io_r_ofs_0,0,0);
    VL_IN8(__PVT__io_r_backpressure,0,0);
    VL_IN8(__PVT__io_w_ofs_0,0,0);
    VL_IN8(__PVT__io_w_data_0,7,0);
    VL_IN8(__PVT__io_w_en_0,0,0);
    VL_OUT8(__PVT__io_output,7,0);
    
    // LOCAL SIGNALS
    
    // LOCAL VARIABLES
    
    // INTERNAL VARIABLES
  private:
    Vtop__Syms* __VlSymsp;  // Symbol table
  public:
    
    // PARAMETERS
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vtop_Mem1D_4);  ///< Copying not allowed
  public:
    Vtop_Mem1D_4(const char* name="TOP");
    ~Vtop_Mem1D_4();
    
    // API METHODS
    
    // INTERNAL METHODS
    void __Vconfigure(Vtop__Syms* symsp, bool first);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
} VL_ATTR_ALIGNED(128);

#endif // guard
