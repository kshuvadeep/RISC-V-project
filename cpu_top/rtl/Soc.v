// This is the soc top integrating the cpu core and Mem_top via a custom
// defined bus and bus protocol 

//`include "Global_defines.vh"
`timescale 1ns / 1ps
`include "cpu_top.v"
`include "Mem_top.v"
`include "system_param.vh"

module Soc #(parameter MEM_DEPTH=64 ,parameter DATA_WIDTH=32)
   (
	input clk ,
	input reset

	// to be added ports for debug 
	);

	wire [`DATA_WIDTH-1:0] data;
	//localparam ADDR_WIDTH =$clog2(MEM_DEPTH);
	wire [`ADDR_WIDTH-1:0] addr;
	wire req_valid,valid_data ,we;

     cpu_top #(MEM_DEPTH,DATA_WIDTH)	core1(.clk(clk),
	          .reset(reset),
		  .Addr(addr),
		  .Data(data),
		  .req_valid(req_valid),
		  .data_valid(valid_data),
		  .we(we)
	  );


	  Mem_top #(MEM_DEPTH,DATA_WIDTH) Mem(.clk(clk),
	          .reset(reset),
		  .addr(addr),
		  .Data(data),
		  .req_valid(req_valid),
		  .data_valid(valid_data),
		  .WE(we)
	  );

    endmodule 	  





