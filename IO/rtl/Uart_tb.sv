`timescale 1ns/1ps

`include "Uart_module.v"

module Uart_module_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg [`ADDR_WIDTH-1:0] addr;
    reg [`DATA_WIDTH-1:0] data_reg;
    wire  [`DATA_WIDTH-1:0] data;
    reg we;
    reg req_valid;
    wire data_valid;
    wire txd;
    reg rxd;
    

    // Instantiate the Uart_module
    Uart_module uut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .data(data),
        .we(we),
        .req_valid(req_valid),
        .data_valid(data_valid),
        .txd(txd),
        .rxd(rxd)
    );

    // Clock generation
    always #5 clk = ~clk;
    
    assign data = we ? data_reg : {`DATA_WIDTH{1'bz}};

    // Testbench logic
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        addr = 0;
        data_reg = 0;
        we = 0;
        req_valid = 0;
        rxd = 1;

        // Reset sequence
        #10 reset = 0;
       
        // Write operation 1
        #10;
        addr = 32'h10000005;           // Set address
        data_reg = 3'hA5;           // Set data to be written
        we = 1;                // Enable write operation
        req_valid = 1;         // Valid request
        #10;
        we = 0;                // Disable write after one clock cycle
        req_valid = 0;

        // Write operation 2
        #20;
        addr =  32'h10000000 ;         // Set another address
        data_reg = 'h5A;       // Set data to be written
        we = 1;                // Enable write operation
        req_valid = 1;         // Valid request
        #10;
        we = 0;                // Disable write after one clock cycle
        req_valid = 0;

        // End simulation after some time
      
    end
endmodule

