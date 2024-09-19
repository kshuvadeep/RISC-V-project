// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VSOC_tb.h for the primary calling header

#include "VSOC_tb.h"
#include "VSOC_tb__Syms.h"

//==========

VL_CTOR_IMP(VSOC_tb) {
    VSOC_tb__Syms* __restrict vlSymsp = __VlSymsp = new VSOC_tb__Syms(this, name());
    VSOC_tb* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void VSOC_tb::__Vconfigure(VSOC_tb__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

VSOC_tb::~VSOC_tb() {
    delete __VlSymsp; __VlSymsp=NULL;
}

void VSOC_tb::eval() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate VSOC_tb::eval\n"); );
    VSOC_tb__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    VSOC_tb* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
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

void VSOC_tb::_eval_initial_loop(VSOC_tb__Syms* __restrict vlSymsp) {
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

void VSOC_tb::_initial__TOP__1(VSOC_tb__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSOC_tb::_initial__TOP__1\n"); );
    VSOC_tb* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->SOC_tb__DOT__clk = 0U;
    vlTOPp->SOC_tb__DOT__reset = 0U;
    VL_FINISH_MT("soc_tb_2.sv", 67, "");
}

VL_INLINE_OPT void VSOC_tb::_combo__TOP__3(VSOC_tb__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSOC_tb::_combo__TOP__3\n"); );
    VSOC_tb* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->SOC_tb__DOT__clk = (1U & (~ (IData)(vlTOPp->SOC_tb__DOT__clk)));
}

void VSOC_tb::_eval(VSOC_tb__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSOC_tb::_eval\n"); );
    VSOC_tb* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__3(vlSymsp);
    // Final
    vlTOPp->__Vclklast__TOP____VinpClk__TOP__SOC_tb__DOT__clk 
        = vlTOPp->__VinpClk__TOP__SOC_tb__DOT__clk;
    vlTOPp->__Vclklast__TOP__SOC_tb__DOT__reset = vlTOPp->SOC_tb__DOT__reset;
    vlTOPp->__VinpClk__TOP__SOC_tb__DOT__clk = vlTOPp->SOC_tb__DOT__clk;
}

void VSOC_tb::_eval_initial(VSOC_tb__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSOC_tb::_eval_initial\n"); );
    VSOC_tb* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_initial__TOP__1(vlSymsp);
    vlTOPp->__Vclklast__TOP____VinpClk__TOP__SOC_tb__DOT__clk 
        = vlTOPp->__VinpClk__TOP__SOC_tb__DOT__clk;
    vlTOPp->__Vclklast__TOP__SOC_tb__DOT__reset = 0U;
}

void VSOC_tb::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSOC_tb::final\n"); );
    // Variables
    VSOC_tb__Syms* __restrict vlSymsp = this->__VlSymsp;
    VSOC_tb* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void VSOC_tb::_eval_settle(VSOC_tb__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSOC_tb::_eval_settle\n"); );
    VSOC_tb* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__3(vlSymsp);
}

VL_INLINE_OPT QData VSOC_tb::_change_request(VSOC_tb__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSOC_tb::_change_request\n"); );
    VSOC_tb* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
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
void VSOC_tb::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSOC_tb::_eval_debug_assertions\n"); );
}
#endif  // VL_DEBUG

void VSOC_tb::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VSOC_tb::_ctor_var_reset\n"); );
    // Body
    SOC_tb__DOT__clk = VL_RAND_RESET_I(1);
    SOC_tb__DOT__reset = VL_RAND_RESET_I(1);
    __VinpClk__TOP__SOC_tb__DOT__clk = VL_RAND_RESET_I(1);
    __Vchglast__TOP__SOC_tb__DOT__clk = VL_RAND_RESET_I(1);
}
