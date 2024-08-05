`timescale 1ns / 1ps

`include "rvi32_instructions.vh"
module decoder_tb;

// Inputs
reg [`INST_WIDTH-1:0] instruction;
reg clk;
reg reset;
reg system_stall;

// Outputs
wire [`REG_ADDR_WIDTH-1:0] rs1;
wire [`REG_ADDR_WIDTH-1:0] rs2;
wire [`REG_ADDR_WIDTH-1:0] rd;
wire rs1_valid;
wire rs2_valid;
wire rd_valid;
wire [6:0] instruction_type;
wire [2:0] funct3;
wire [6:0] funct7;
wire [20:0] immediate;
wire decoder_stall;

// Instantiate the decoder module
decoder uut (
    .instruction(instruction),
    .clk(clk),
    .reset(reset),
    .system_stall(system_stall),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .rs1_valid(rs1_valid),
    .rs2_valid(rs2_valid),
    .rd_valid(rd_valid),
    .instruction_type(instruction_type),
    .funct3(funct3),
    .funct7(funct7),
    .immediate(immediate),
    .decoder_stall(decoder_stall)
);

// Clock generation
always #10 clk = ~clk;  // 20 time unit clock period

initial begin
    $monitor("Time = %0d, instruction = %b, rs1 = %b, rs2 = %b, rd = %b, rs1_valid = %b, rs2_valid = %b, rd_valid = %b, instruction_type = %b, funct3 = %b, funct7 = %b, immediate = %b, decoder_stall = %b",
             $time, instruction, rs1, rs2, rd, rs1_valid, rs2_valid, rd_valid, instruction_type, funct3, funct7, immediate, decoder_stall);
end

// Dump variables for waveform generation
initial begin
    $dumpfile("decoder_tb.vcd");
    $dumpvars(0, decoder_tb);
end

initial begin
    // Initialize inputs
    clk = 0;
    reset = 1;
    system_stall = 0;

    // Wait 100 ns for global reset to finish
    #100;

    // Deassert reset
    reset = 0;

    // Test R-type instruction (e.g., ADD)
    instruction = 32'b0000000_00010_00001_000_00100_0110011;
    #20;

    // Test I-type instruction (e.g., ADDI)
    instruction = 32'b000000000000_00001_000_00100_0010011;
    #20;

    // Test Load instruction (e.g., LW)
    instruction = 32'b000000000000_00001_010_00100_0000011;
    #20;

    // Test Store instruction (e.g., SW)
    instruction = 32'b0000000_00010_00001_010_00100_0100011;
    #20;

    // Test Branch instruction (e.g., BEQ)
    instruction = 32'b0000000_00010_00001_000_00100_1100011;
    #20;

    // Test U-type instruction (e.g., LUI)
    instruction = 32'b00000000000000000001_00000_0110111;
    #20;

    // Test JAL instruction
    instruction = 32'b00000000000000000001_00000_1101111;
    #20;

    // Test JALR instruction
    instruction = 32'b000000000000_00001_000_00100_1100111;
    #20;

    // Test AUIPC instruction
    instruction = 32'b00000000000000000001_00000_0010111;
    #20;

  

    // Finish simulation
    $finish;
end

endmodule
