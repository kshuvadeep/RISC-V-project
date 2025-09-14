//***********************************************************************************************
// This is to test the Uart receiver and the LCD display working together in emulation environment
//*********************************************************************************************** 
`include "Uart_rx.v"
`include "lcd_driver.v"

module Uart_top (
      input  rxd,                    // Uart receiver line 
      input  clk ,
      output  lcd_e,             // LCD enable control
      output  lcd_rs,            // Register select: 0 = command, 1 = data
      output[7:0] dout         // 8-bit data output to LCD
);
  wire rxd;
  wire[7:0] data_rx;

  Uart_rx MyUartReceiver(
                     .i_Clock(clk),           
                     .i_Rx_Serial(rxd),
                     .o_Rx_DV(data_v),
                     .o_Rx_Byte(data_rx)
                    );

 lcd_driver MyLcdDriver(
                    .clk(clk),
                     .data_v(data_v),
                     .data(data_rx),
                     .lcd_e(lcd_e),
                     .lcd_rs(lcd_rs),
                     .dout(dout)
                     );


endmodule 
