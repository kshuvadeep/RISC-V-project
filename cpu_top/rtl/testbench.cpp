#include "VSOC.h"          // Verilator-generated header for the SOC module
#include "verilated.h"     // Verilator header
#include "verilated_vcd_c.h" // Header for VCD waveform tracing

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);  // Initialize Verilator

    // Create instance of the DUT (Device Under Test)
    VSOC* dut = new VSOC;

    // Initialize VCD waveform dumping
    VerilatedVcdC* tfp = new VerilatedVcdC;
    Verilated::traceEverOn(true);
    dut->trace(tfp, 99); // Trace up to 99 levels of hierarchy
    tfp->open("soc_tb.vcd"); // Open the VCD file

    // Initialize clock and reset signals
    dut->clk = 0;
    dut->reset = 1;

    // Run for a few cycles with reset asserted
    for (int i = 0; i < 5; i++) {
        dut->clk = !dut->clk;  // Toggle clock
        dut->eval();           // Evaluate the design
        tfp->dump(i*10);       // Dump the waveform at this time step
    }

    // Deassert reset
    dut->reset = 0;

    // Main simulation loop (with a fixed duration)
    for (int i = 5; i < 1005; i++) {
        dut->clk = !dut->clk;  // Toggle clock

        // Stimulus can be added here, e.g., setting req_valid, we, addr, and data
        if (i == 20) {
            // Example: dut->req_valid = 1;
        }

        dut->eval();           // Evaluate the design
        tfp->dump(i*10);       // Dump the waveform at this time step
    }

    // Finalize simulation
    tfp->close();
    delete dut;
    return 0;
}
