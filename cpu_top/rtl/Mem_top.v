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
                           
                       //****************************************************************
                       //  T e s t c a s e 1  with simple logic and add operations 
                       //*************************************************************** 
                      //       Mem[0]=32'h00a00313;      //addi x6,x0,10      
                      //      Mem[1]=32'h01400393;      //addi x7,x0,20               
                      //      Mem[2]=32'h00730e33  ;     //add x28,x6,x7
                      //      Mem[3]=32'h40638eb3 ;    //sub x29,x7,x6
                      //      Mem[4]=32'h01de7f33  ;    //and x30,x28,x29
                      //      Mem[5]=32'h01de4fb3   ;   // xor x31,x28,x29

 	        	 //  for(i=6;i<MEM_DEPTH;i=i+1) begin 
			 //          Mem[i]=i;  // just for creating a test case 
			 //  end 

			 //  data_valid_reg=1'b0;



                        //****************************************************************
                       //  T e s t c a s e 2  with simple add  and loop operations to a multiplication operation  
                       //*************************************************************** 
                          
                            Mem[0]=32'h00a00313;    // addi x6,x0,10 
                            Mem[1]=32'h00f00393 ;    //addi x7,x0,15
                            Mem[2]=32'h00000e13 ;   // addi x28,x0,0
                            Mem[3]=32'h00100e93 ;  // addi x29,x0,1  ;  

                            Mem[4]=32'h007e0e33 ;   //  add x28,x28,x7  ;  accumulation 
                            Mem[5]=32'h41d30333 ;    //sub x6,x6,x29  ,loop variable decrement
                            Mem[6]=32'hfe031ce3  ;  //bne x6,x0,0xfffffff8               
                            
 
			   for(i=7;i<MEM_DEPTH;i=i+1) begin 
				   Mem[i]=i;  // just for creating a test case 
			   end 

			   data_valid_reg=1'b0;

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





		        	
    
		 





    

