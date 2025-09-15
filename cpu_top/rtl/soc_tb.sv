`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2024 02:23:17 PM
// Design Name: 
// Module Name: soc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include "Soc.v"
`include "cpu_top.v"

module soc_tb;

    // Parameters for width
   parameter DATA_WIDTH = 32;
   parameter MEM_DEPTH = 64;

    // Testbench signals
    reg clk;
    reg reset;
     localparam ADDR_WIDTH=$clog2(MEM_DEPTH);
    // Wires to connect to the SOC module
    wire [ADDR_WIDTH-1:0] addr;
    wire req_valid, valid_data, we;
    wire [DATA_WIDTH-1:0] data;
    wire txd ,rxd ;

    // Instantiate the SOC module
    Soc 
       dut (
        .clk(clk),
        .reset(reset),
         .txd(txd),
         .rxd(rxd)
        // Add debug ports if necessary
    );

    // Clock generation
  //  always #10 clk = ~clk;

  //  initial begin
  //      // Initialize signals
  //      clk = 0;
  //      reset = 1;

  //      // Apply reset
  //      #50;
  //      reset = 0;

  //      // Stimulus to the SOC module
  //      // Add stimulus code here, e.g., setting req_valid, we, addr, and data

  //      // Wait for a while
  //      #100;

  //      #10000;
  //      //$finish; 
  //      // End the simulation
  //    //  $finish;
  //  end

    initial begin
        // Monitoring signals
        $monitor("At time %t, clk = %b, reset = %b, addr = %h, req_valid = %b, valid_data = %b, we = %b, data = %h",
                 $time, clk, reset, addr, req_valid, valid_data, we, data);
    end

 initial begin
        // Dump waveforms
        $dumpfile("waves.vcd");
        $dumpvars(0, soc_tb);       // Include top-level signals in the testbench module
        $dumpvars(1, soc_tb.dut);   // Include signals in the counter module (uut instance)
        // $dumpvars(1, testbench.dut); 
    end


endmodule
