// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef _VSOC__SYMS_H_
#define _VSOC__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODULE CLASSES
#include "VSoc.h"

// SYMS CLASS
class VSoc__Syms : public VerilatedSyms {
  public:
    
    // LOCAL STATE
    const char* __Vm_namep;
    bool __Vm_didInit;
    
    // SUBCELL STATE
    VSoc*                          TOPp;
    
    // CREATORS
    VSoc__Syms(VSoc* topp, const char* namep);
    ~VSoc__Syms() {}
    
    // METHODS
    inline const char* name() { return __Vm_namep; }
    
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
