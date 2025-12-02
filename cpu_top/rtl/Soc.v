// This is the soc top integrating the cpu core and Mem_top via a custom
// defined bus and bus protocol

//`include "Global_defines.vh"
`timescale 1ns / 1ps
`include "system_param.vh"


module Soc (
	input clk ,
	input reset,
    input programming,
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
          .programming(programming),
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
        .programming(programming),
         .we(we),
        .req_valid(req_valid),
        .data_valid(valid_data),
        .txd(txd),
        .rxd(rxd)
    );


 //uart_io_general u_uart_io_general (
//    .clk        (clk),
//    .rst        (r),
//    .rxd        (rxd),
//    .programming(programming),
//    .en         (en),
//    .req_valid  (req_valid),
//    .addr       (addr),
//    .rd_data    (rd_data),
//    .wrt_data   (wrt_data),
//    .data_v     (data_v)
//  );
//

    endmodule





