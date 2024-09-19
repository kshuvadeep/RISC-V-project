// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef _VSOC_TB__SYMS_H_
#define _VSOC_TB__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODULE CLASSES
#include "VSOC_tb.h"

// SYMS CLASS
class VSOC_tb__Syms : public VerilatedSyms {
  public:
    
    // LOCAL STATE
    const char* __Vm_namep;
    bool __Vm_didInit;
    
    // SUBCELL STATE
    VSOC_tb*                       TOPp;
    
    // CREATORS
    VSOC_tb__Syms(VSOC_tb* topp, const char* namep);
    ~VSOC_tb__Syms() {}
    
    // METHODS
    inline const char* name() { return __Vm_namep; }
    
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
