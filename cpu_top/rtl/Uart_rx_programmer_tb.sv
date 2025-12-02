//*************************************
//TestBench****************************
//a simple testbench to test the programming the cpu
//based on programming pin


module Uart_rx_programmer_tb ;


reg clk ,rst, prog1,prog2 ;
wire tx_data,tx_soc2;


 Soc u_soc_driver (
	   .clk(clk),
	   .reset(rst),
       .programming(prog1),
       .txd(tx_data),
       .rxd(1'b0)

	// to be added ports for debug
	);


 Soc u_soc_receiver (
	   .clk(clk),
	   .reset(rst),
       .programming(prog2),
       .txd(tx_soc2),
       .rxd(tx_data)

	// to be added ports for debug
	);

 initial
   begin
     rst=1'b1;
     clk=0;
     prog1 =1'b0;
     prog2=1'b0;

    #30

       prog2 = 1'b1;
    #50
       rst =1'b0;

       //100ms simulation time
        #10000000;
        $finish;


   end





   always
     begin
       #10
        clk = ~clk;
     end

 initial begin
        // Monitoring signals
        //
        $monitor("At time %t, clk = %b,rst = %b , txd =%b ",
                 $time, clk, rst,tx_data);
    end

 initial begin
        // Dump waveforms
        $dumpfile("waves_programmer.vcd");
        $dumpvars(0, Uart_rx_programmer_tb);       // Include top-level signals in the testbench module
        $dumpvars(1, Uart_rx_programmer_tb. u_soc_receiver);   // Include signals in the counter module (uut instance)
        // $dumpvars(1, testbench.dut);
    end



     endmodule
