// This is the soc top integrating the cpu core and Mem_top via a custom
// defined bus and bus protocol 

//`include "Global_defines.vh"
`timescale 1ns / 1ps
`include "cpu_top.v"
`include "Mem_top.v"
`include "system_param.vh"
`include "Uart_module.v"


module Soc (
	input clk ,
	input reset,
        output txd,
        input rxd 

	// to be added ports for debug 
	);

	wire [`DATA_WIDTH-1:0] rd_data,wrt_data;
	//localparam ADDR_WIDTH =$clog2(MEM_DEPTH);
	wire [`ADDR_WIDTH-1:0] addr;
	wire req_valid,valid_data ,we;

     cpu_top core1(
                   .clk(clk),
	          .reset(reset),
		  .Addr(addr),
		  .rd_data(rd_data),
                  .wrt_data(wrt_data),
		  .req_valid(req_valid),
		  .data_valid(valid_data),
		  .we(we)
	  );


      Mem_top  Mem(
                   .clk(clk),
	          .reset(reset),
		  .addr(addr),
		  .rd_data(rd_data),
		  .wrt_data(wrt_data),
		  .req_valid(req_valid),
		  .data_valid(valid_data),
		  .WE(we)
	  );
          
        Uart_module Uart (
        .clk(clk),
        .reset(reset),
        .addr(addr),
         .rd_data(rd_data),
        .wrt_data(wrt_data),
         .we(we),
        .req_valid(req_valid),
        .data_valid(valid_data),
        .txd(txd),
        .rxd(rxd)
    );


    endmodule 	  





