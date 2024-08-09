`timescale 1ns/1ps

`include "system_param.vh"
`include "rvi32_instructions.vh"
`include "Execution_param.vh"
`include "Macros.vh"

module tb_execution_unit();

  // Inputs
  reg [6:0] instruction_type;
  reg [2:0] funct3;
  reg [6:0] funct7;
  reg [20:0] immediate;
  reg system_stall;
  reg [`DATA_WIDTH-1:0] data_src1;
  reg [`DATA_WIDTH-1:0] data_src2;
  reg clk;
  reg reset;

  // Outputs
  wire [`DATA_WIDTH-1:0] Execution_Result;
  wire Result_valid;

  // Instantiate the execution unit
  execution uut (
    .instruction_type(instruction_type),
    .funct3(funct3),
    .funct7(funct7),
    .immediate(immediate),
    .system_stall(system_stall),
    .data_src1(data_src1),
    .data_src2(data_src2),
    .Execution_Result(Execution_Result),
    .Result_valid(Result_valid),
    .clk(clk),
    .reset(reset)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #10 clk = ~clk; // 20ns period
  end

  // Test vectors
  initial begin
    // Initialize inputs
    reset = 1;
    instruction_type = 7'b0000000;
    funct3 = 3'b000;
    funct7 = 7'b0000000;
    immediate = 21'b0;
    system_stall = 0;
    data_src1 = 0;
    data_src2 = 0;

    // Reset sequence
    #15 reset = 0;

    // Test 1: Add operation
    instruction_type = 7'b0110011; // Example R-type opcode
    funct3 = 3'b000; // ADD
    funct7 = 7'b0000000; // ADD
    data_src1 = 32'h00000010;
    data_src2 = 32'h00000020;
    #20;

    // Test 2: Subtract operation
    funct3 = 3'b000; // SUB
    funct7 = 7'b0100000; // SUB
    data_src1 = 32'h00000030;
    data_src2 = 32'h00000010;
    #20;

    // Test 3: AND operation
    funct3 = 3'b111; // AND
    funct7 = 7'b0000000; // AND
    data_src1 = 32'hFFFFFFF0;
    data_src2 = 32'h0F0F0F0F;
    #20;

    // Test 4: OR operation
    funct3 = 3'b110; // OR
    funct7 = 7'b0000000; // OR
    data_src1 = 32'hF0F0F0F0;
    data_src2 = 32'h0F0F0F0F;
    #20;

    // Test 5: XOR operation
    funct3 = 3'b100; // XOR
    funct7 = 7'b0000000; // XOR
    data_src1 = 32'hAAAAAAAA;
    data_src2 = 32'h55555555;
    #20;

    // End simulation
    $stop;
  end

  // Monitor the results
  initial begin
    $monitor("At time %t: instruction_type = %b, funct3 = %b, funct7 = %b, data_src1 = %h, data_src2 = %h, Execution_Result = %h, Result_valid = %b",
              $time, instruction_type, funct3, funct7, data_src1, data_src2, Execution_Result, Result_valid);
   #500 
    $finish ;
  end

  initial begin 
    $dumpfile("tb_execution.vcd");
    $dumpvars(0,tb_execution_unit);
   end 

endmodule

