`timescale 1ns/1ps

module Arbiter_tb();

  // Declare variables for the inputs and outputs of the arbiter
  reg clk;
  reg reset;

  // IFetch interface
  reg req0_valid;
  reg [`ADDR_WIDTH-1:0] addr_p0;
  reg [`DATA_WIDTH-1:0] data_p0;  // since `inout`, it will act as reg in testbench
  reg we_p0;
  wire grant0;

  // MMU interface
  reg req1_valid;
  reg [`ADDR_WIDTH-1:0] addr_p1;
  reg [`DATA_WIDTH-1:0] data_p1;  // since `inout`, it will act as reg in testbench
  reg we_p1;
  wire grant1;

  // CPU top or Main memory bus interface
  wire req_valid;
  wire [`ADDR_WIDTH-1:0] addr;
  wire [`DATA_WIDTH-1:0] data;    // since `inout`, we assign bidirectionally
  wire we;
  reg data_valid;

  // Instantiate the Arbiter module
  Arbiter arbiter_inst (
    .clk(clk),
    .reset(reset),
    .req0_valid(req0_valid),
    .addr_p0(addr_p0),
    .data_p0(data_p0),
    .we_p0(we_p0),
    .grant0(grant0),
    .req1_valid(req1_valid),
    .addr_p1(addr_p1),
    .data_p1(data_p1),
    .we_p1(we_p1),
    .grant1(grant1),
    .req_valid(req_valid),
    .addr(addr),
    .data(data),
    .we(we),
    .data_valid(data_valid)
  );

  // Clock generation
  always #5 clk = ~clk;  // 10ns clock period (100MHz)

  // Test sequence
  initial begin
    // Initialize signals
    clk = 0;
    reset = 1;   // Apply reset initially
    req0_valid = 0;
    req1_valid = 0;
    addr_p0 = 0;
    addr_p1 = 0;
    data_p0 = 0;
    data_p1 = 0;
    we_p0 = 0;
    we_p1 = 0;
    data_valid = 0;

    // Release reset after some time
    #10;
    reset = 0;

    // Scenario 1: IFetch (req0) makes a request
    #10;
    req0_valid = 1;
    addr_p0 = 32'hDEADBEEF;
    data_p0 = 32'h12345678;
    we_p0 = 1;

    #20;
    req0_valid = 0;  // Release request after some cycles

    // Scenario 2: MMU (req1) makes a request
    #30;
    req1_valid = 1;
    addr_p1 = 32'hCAFEBABE;
    data_p1 = 32'h87654321;
    we_p1 = 0;

    #20;
    req1_valid = 0;  // Release request

    // Scenario 3: Both IFetch (req0) and MMU (req1) make a request at the same time
    #30;
    req0_valid = 1;
    addr_p0 = 32'hABCDEF01;
    data_p0 = 32'h13579BDF;
    we_p0 = 1;

    req1_valid = 1;
    addr_p1 = 32'h12345678;
    data_p1 = 32'h2468ACE0;
    we_p1 = 0;

    #50;
    req0_valid = 0;
    req1_valid = 0;  // Release both requests

    // Finish simulation
    #50;
    $stop;
  end

  // Monitor the key signals
  initial begin
    $monitor("Time=%0d: req0_valid=%b, grant0=%b, addr_p0=%h, data_p0=%h, we_p0=%b, req1_valid=%b, grant1=%b, addr_p1=%h, data_p1=%h, we_p1=%b, req_valid=%b, addr=%h, data=%h, we=%b",
             $time, req0_valid, grant0, addr_p0, data_p0, we_p0, req1_valid, grant1, addr_p1, data_p1, we_p1, req_valid, addr, data, we);
  end

  // for dumping waveforms 

    initial begin
        // Dump waveforms
        $dumpfile("arbiter_waves.vcd");
        $dumpvars(0, Arbiter_tb);       // Include top-level signals in the testbench module
        $dumpvars(1, Arbiter_tb.dut);   // Include signals in the counter module (uut instance)
	// $dumpvars(1, testbench.dut); 
      end 


endmodule

