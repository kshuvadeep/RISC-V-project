// This module consists of UArt tx , uart rx ,and Fifo . 
// This module works as an IO module connected to main 
// cpu core via a system bus . 
//We will use Memory mapped IO to send data to it 
//Uart works as an interface to send data to any other devices 
//It can be a raspberry pi or a laptop 
// Author: Shuvadeep Kumar 
// Company :autoRisca 
//Date :22nd october 

`include "/home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/system_param.vh" 
`include "/home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/Macros.vh" 
`include "Fifo.v"

module Uart_module(
         input clk ,
         input reset,
         //system bus 
         input[`ADDR_WIDTH-1:0] addr ,
         inout[`DATA_WIDTH-1:0] data ,
         input we ,
         input req_valid,
         output data_valid ,   // will work as ready for read operation  
         //
         output txd ,
         input rxd 
       );


      reg wrt_clk_tx;
      wire rd_clk_tx;
      reg wrt_clk_rx, rd_clk_rx;  
      reg [`DATA_WIDTH-1:0] tx_data;    
     //subscript tx and rx stands for the corresponding modules 
      wire wrt_en_tx ,rd_en_tx;  
      wire wrt_en_rx, rd_en_rx ; 
      wire tx_enable ,rx_enable  ;
      wire tx_full , tx_empty ;
      wire csn_uart ; // whether the Uart module is selected or not

       // chip select login 
       assign csn_uart =  (addr[`ADDR_WIDTH: `ADDR_WIDTH-`IO_SELECT] ==`UART_SELECT ) ? 1'b0 :1'b0;

      //rd and wrt enbale logic 
      assign wrt_en_tx = req_valid & csn_uart & we ;
      assign rd_en_tx = !tx_empty & tx_enable ;      

 
   //   assign rd_en_rx <= req_valid & (addr[`ADDR_WIDTH: `ADDR_WIDTH-`IO_SELECT] ==4'b0001 ) & !we ; 
   //   assign wrt_en_rx <= !rx_empty & rx_enable  ;
     
      `CLK_GATE(clk,wrt_en_tx,wrt_clk_tx)
     // `CLK_GATE(clk,rd_en_tx,rd_clk_tx)

   //   CLK_GATE(clk,wrt_en_rx,wrt_clk_rx)
   //   CLK_GATE(clk,rd_en_rx,rd_clk_rx)


      //Fifo for TX 

       Fifo #(
        .DEPTH(16),      // Set depth of FIFO to 16
        .WIDTH(32)       // Set width of data to 32 bits
    ) fifo_tx (
        .reset(reset),
        .wrt_clk(wrt_clk_tx),
        .rd_clk(rd_clk_tx),
        .wrt_data(data),
        .rd_data(tx_data),
        .full(tx_full),
        .empty(tx_empty)
    );

      

     // Transmission module 

   Uart_tx uart_tx_inst (
        .clk(clk),
        .reset(reset),
        .data(tx_data),
        .tx_fifo_empty(tx_empty),
        .rd_clk_tx(rd_clk_tx),
        .txd(txd)
    );
     
     assign data_valid = csn_uart? !tx_full :1'bz; // needs to  modify this for the Receiver module

       
endmodule
