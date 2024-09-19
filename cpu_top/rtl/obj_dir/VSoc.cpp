// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VSoc.h for the primary calling header

#include "VSoc.h"
#include "VSoc__Syms.h"

//==========

VL_CTOR_IMP(VSoc) {
    VSoc__Syms* __restrict vlSymsp = __VlSymsp = new VSoc__Syms(this, name());
    VSoc* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void VSoc::__Vconfigure(VSoc__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

VSoc::~VSoc() {
    delete __VlSymsp; __VlSymsp=NULL;
}

void VSoc::eval() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate VSoc::eval\n"); );
    VSoc__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    VSoc* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("soc_tb_2.sv", 25, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void VSoc::_eval_initial_loop(VSoc__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("soc_tb_2.sv", 25, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void VSoc::_initial__TOP__1(VSoc__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSoc::_initial__TOP__1\n"); );
    VSoc* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->SOC_tb__DOT__clk = 0U;
    vlTOPp->SOC_tb__DOT__reset = 0U;
    VL_FINISH_MT("soc_tb_2.sv", 67, "");
}

VL_INLINE_OPT void VSoc::_combo__TOP__3(VSoc__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSoc::_combo__TOP__3\n"); );
    VSoc* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->SOC_tb__DOT__clk = (1U & (~ (IData)(vlTOPp->SOC_tb__DOT__clk)));
}

void VSoc::_eval(VSoc__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSoc::_eval\n"); );
    VSoc* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__3(vlSymsp);
    // Final
    vlTOPp->__Vclklast__TOP____VinpClk__TOP__SOC_tb__DOT__clk 
        = vlTOPp->__VinpClk__TOP__SOC_tb__DOT__clk;
    vlTOPp->__Vclklast__TOP__SOC_tb__DOT__reset = vlTOPp->SOC_tb__DOT__reset;
    vlTOPp->__VinpClk__TOP__SOC_tb__DOT__clk = vlTOPp->SOC_tb__DOT__clk;
}

void VSoc::_eval_initial(VSoc__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSoc::_eval_initial\n"); );
    VSoc* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_initial__TOP__1(vlSymsp);
    vlTOPp->__Vclklast__TOP____VinpClk__TOP__SOC_tb__DOT__clk 
        = vlTOPp->__VinpClk__TOP__SOC_tb__DOT__clk;
    vlTOPp->__Vclklast__TOP__SOC_tb__DOT__reset = 0U;
}

void VSoc::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSoc::final\n"); );
    // Variables
    VSoc__Syms* __restrict vlSymsp = this->__VlSymsp;
    VSoc* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void VSoc::_eval_settle(VSoc__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSoc::_eval_settle\n"); );
    VSoc* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__3(vlSymsp);
}

VL_INLINE_OPT QData VSoc::_change_request(VSoc__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSoc::_change_request\n"); );
    VSoc* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    __req |= ((vlTOPp->SOC_tb__DOT__clk ^ vlTOPp->__Vchglast__TOP__SOC_tb__DOT__clk));
    VL_DEBUG_IF( if(__req && ((vlTOPp->SOC_tb__DOT__clk ^ vlTOPp->__Vchglast__TOP__SOC_tb__DOT__clk))) VL_DBG_MSGF("        CHANGE: soc_tb_2.sv:32: SOC_tb.clk\n"); );
    // Final
    vlTOPp->__Vchglast__TOP__SOC_tb__DOT__clk = vlTOPp->SOC_tb__DOT__clk;
    return __req;
}

#ifdef VL_DEBUG
void VSoc::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSoc::_eval_debug_assertions\n"); );
}
#endif  // VL_DEBUG

void VSoc::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSoc::_ctor_var_reset\n"); );
    // Body
    SOC_tb__DOT__clk = VL_RAND_RESET_I(1);
    SOC_tb__DOT__reset = VL_RAND_RESET_I(1);
    __VinpClk__TOP__SOC_tb__DOT__clk = VL_RAND_RESET_I(1);
    __Vchglast__TOP__SOC_tb__DOT__clk = VL_RAND_RESET_I(1);
}
