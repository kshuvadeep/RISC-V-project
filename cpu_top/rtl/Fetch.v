
// Development of a basic risc -v cpu core .
// 26h july 
//`include "Global_defines.vh"

`define RESET 2'b00
`define TX 2'b01 
`define WAIT 2'b11
`define RX 12'b10


 module Fetch #(parameter MEM_DEPTH=8 ,parameter DATA_WIDTH=32 ) 
   (
	output[ADDR_WIDTH -1:0] Addr ,
	inout[DATA_WIDTH-1:0] Data,
	output we,
        output  req_valid,
//	input intr,  to be implemented later 
	input clk ,
	input reset,
	input data_valid

        );
localparam STATE_WIDTH=2;
 localparam ADDR_WIDTH=$clog2(MEM_DEPTH);
     // top level 

     //architectural registers for simple registers  

   //  reg[31:0] A, B,C,D,E  //specify the registers later 
     reg req_valid_reg,we_reg;
     reg [ADDR_WIDTH -1:0] Addr_reg; 
     reg[STATE_WIDTH-1:0] PresentState , NextState;
     //program counter
     reg[31:0] ProgramCounter;
     reg PC_v; // program counter valid 
     // instruction register 
     reg[31:0] InstructionRegister;
     reg IR_v; //Instruction regsiter valid 

     always@(posedge clk or posedge reset)
     begin
	    		      
           // increment program counter 
	   // There will be some Arbitration scheme required in future 
	   // to arbitrate between requests from Instruction and data sides
	   // change (1) 
	  if(reset)
	  begin 
	  NextState=`RESET;
	  end 
	  
           
	    case(PresentState) 

	    
		    
		    `RESET :    begin
				ProgramCounter=0;  // Initial value of Program counter , can be programmed to other values .
             			InstructionRegister=0;
                        PC_v=1'b1; IR_v=1'b0;
                     if(reset)
                     begin 
                     NextState=`RESET;
                     end    
                     
                                 
				 we_reg=1'b0;
				 if(PC_v)
				 begin 
				  NextState=`TX;
       				 end 
       				 end

               `TX:   begin 
		            Addr_reg=ProgramCounter;
			    req_valid_reg=1'b1;
			    PC_v=1'b0; IR_v=1'b0;
			    NextState =`WAIT;
			    we_reg=1'b0;
 			    end 
		     `WAIT :  begin
			      req_valid_reg=1'b1; 
			      if(data_valid)
			      begin 
			      NextState=`RX;

		 	      end 
		 	      end

		    `RX : begin 
		          InstructionRegister=Data;
			  IR_v=1'b1;
			  if(ProgramCounter==MEM_DEPTH)
			  begin ProgramCounter=0;
			  end
			  ProgramCounter=ProgramCounter+1; 
			  PC_v=1'b1;
			  req_valid_reg=1'b0;
			  // in future we need to implement a buffer ,we need
			  // to sample a busy signal from the instruction
			  // buffer and gate this transition 
			  NextState=`TX;
		          end

                endcase 

		PresentState=NextState;

      end 		

   assign Addr=Addr_reg;
   assign req_valid=req_valid_reg;
   assign we =we_reg ;



endmodule 



             
        	

	 
