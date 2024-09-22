// this file is the simple register file that is used as a simple soc simuilation 

//`include "Global_defines.vh"
`include "system_param.vh"
`timescale 1ns / 1ps

 module Mem_top #(parameter MEM_DEPTH=8 ,parameter DATA_WIDTH=32 ) 
                ( input[`ADDR_WIDTH-1:0] addr ,
                 input req_valid ,input WE,
                 input clk ,reset ,
                 inout[DATA_WIDTH-1:0]  Data,
                 output data_valid ) ; // think of it as a successful read/write status bit  

     // localparam `ADDR_WIDTH=$clog2(MEM_DEPTH);
       integer i ;
       reg[DATA_WIDTH-1:0] data_reg;
       reg data_valid_reg;
             // 1Read /1 Write Memory model 

		 //Main Memory
		 reg[DATA_WIDTH-1:0] Mem[0:MEM_DEPTH-1];

		 always@(posedge clk or posedge reset)
		 begin
			if(reset)
			begin 
                         
                            // Instructions will be loaded onto the Memory for the first time 
                            // through reset , **In future these memory will be loaded through a
                            // block called programmer ,which will load the instructions to Memory via 
                           // Serial port or UART
                           
                      
		//***************************************************************
		//  T e s t c a s e : Fibonacci with loops 
		//***************************************************************

		Mem[0] = 32'h00100293; // addi x5,x0,1 4 li t0 1
		Mem[1] = 32'h00500313; // addi x6,x0,5 6 li t1 ,5
		Mem[2] = 32'h00000393; // addi x7,x0,0 9 li t2 , 0
		Mem[3] = 32'h00100e13; // addi x28,x0,1 12 li t3 ,1
		Mem[4] = 32'h007e0eb3; // add x29,x28,x7 16 LOOP :add t4 ,t3 ,t2
		Mem[5] = 32'h000e03b3; // add x7,x28,x0 18 add t2 , t3 ,zero
		Mem[6] = 32'h000e8e33; // add x28,x29,x0 20 add t3 ,t4 ,zero
		Mem[7] = 32'h40530333; // sub x6,x6,x5 21 sub t1 ,t1 ,t0
		Mem[8] = 32'hfe0318e3; // bne x6,x0,0xfffffff0 22 bnez t1 LOOP

		for(i=9; i<MEM_DEPTH; i=i+1) begin
   			 Mem[i] = i;  // Just for creating a test case
		end

		data_valid_reg = 1'b0;
                                                                       

		   end 
                 else begin

		   // Read 
		   if(req_valid && !WE)
		   begin 
		   data_reg = Mem[addr];
		   data_valid_reg=1'b1;
	           end 
                   //write 
		   if(req_valid && WE )
		   begin 
		   Mem[addr]=Data;
		   data_valid_reg=1'b1;
	           end 
              end // if reset else block 

		//   data_valid_reg=1'b0;

	   end  //always block 
	    
	    assign Data=data_reg;
	    assign data_valid=data_valid_reg;

	    //there are some loopholes in data_valid logic , need to fix it
	    //chnage#2 



  endmodule 	    





		        	
    
		 





    

