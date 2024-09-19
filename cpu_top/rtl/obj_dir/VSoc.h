// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VSOC_H_
#define _VSOC_H_  // guard

#include "verilated.h"

//==========

class VSoc__Syms;

//----------

VL_MODULE(VSoc) {
  public:
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    CData/*0:0*/ SOC_tb__DOT__clk;
    CData/*0:0*/ SOC_tb__DOT__reset;
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    CData/*0:0*/ __VinpClk__TOP__SOC_tb__DOT__clk;
    CData/*0:0*/ __Vclklast__TOP____VinpClk__TOP__SOC_tb__DOT__clk;
    CData/*0:0*/ __Vclklast__TOP__SOC_tb__DOT__reset;
    CData/*0:0*/ __Vchglast__TOP__SOC_tb__DOT__clk;
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    VSoc__Syms* __VlSymsp;  // Symbol table
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(VSoc);  ///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible with respect to DPI scope names.
    VSoc(const char* name = "TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~VSoc();
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval();
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(VSoc__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(VSoc__Syms* symsp, bool first);
  private:
    static QData _change_request(VSoc__Syms* __restrict vlSymsp);
  public:
    static void _combo__TOP__3(VSoc__Syms* __restrict vlSymsp);
  private:
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(VSoc__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif  // VL_DEBUG
  public:
    static void _eval_initial(VSoc__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(VSoc__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _initial__TOP__1(VSoc__Syms* __restrict vlSymsp) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
