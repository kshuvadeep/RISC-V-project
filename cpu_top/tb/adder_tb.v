`timescale 1ns / 1ps

`include "Execution_param.vh"

module tb_Adder_int;

    // Parameters
    localparam DATA_WIDTH = 32;

    // Inputs
    reg clk;
    reg reset;
    reg [1:0] add_type;
    reg [DATA_WIDTH-1:0] src1;
    reg [DATA_WIDTH-1:0] src2;
    reg [20:0] immediate;

    // Outputs
    wire [DATA_WIDTH-1:0] add_value;

    // Instantiate the Unit Under Test (UUT)
    Adder_int uut (
        .clk(clk), 
        .reset(reset), 
        .add_type(add_type), 
        .src1(src1), 
        .src2(src2), 
        .immediate(immediate), 
        .add_value(add_value)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 20ns period
    end

    // Stimulus
    initial begin
        // Initialize Inputs
        reset = 1;
        add_type = 3'b000;
        src1 = 0;
        src2 = 0;
        immediate = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Deassert reset
        reset = 0;

        // Test ADD
        #20;
        src1 = 32'd15;
        src2 = 32'd10;
        add_type = `CTRL_ADD; // Assuming 3'b000 is `ADD` operation
        #20;
        $display("ADD: src1 = %d, src2 = %d, add_value = %d", src1, src2, add_value);

        // Test SUB
        #20;
        src1 = 32'd20;
        src2 = 32'd5;
        add_type = `CTRL_SUB; // Assuming 3'b001 is `SUB` operation
        #20;
        $display("SUB: src1 = %d, src2 = %d, add_value = %d", src1, src2, add_value);

        // Test ADDI
        #20;
        src1 = 32'd10;
        immediate = 21'd5;
        add_type = `CTRL_ADDI; // Assuming 3'b010 is `ADDI` operation
        #20;
        $display("ADDI: src1 = %d, immediate = %d, add_value = %d", src1, immediate, add_value);

        // Finish simulation
        #500;
        $finish;
    end

    // Dump variables for waveform viewing
    initial begin
        $dumpfile("tb_Adder_int.vcd");
        $dumpvars(0, tb_Adder_int);
    end

endmodule

