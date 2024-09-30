
// Development of a basic risc -v cpu core .
// 26h july 
//`include "Global_defines.vh"
`timescale 1ns / 1ps
`define RESET 2'b00
`define TX 2'b01 
`define WAIT 2'b11
`define RX 12'b10

`include "system_param.vh"
`include "Macros.vh"

 module Fetch #(parameter MEM_DEPTH=16 ,parameter DATA_WIDTH=32 ) 
   (
	output reg[`ADDR_WIDTH -1:0] Addr ,
	inout[`DATA_WIDTH-1:0] Data,
	output reg we,
        output reg req_valid,
        input grant ,

//	input intr,  to be implemented later 
	input clk ,
	input reset,
	input data_valid,
        input system_stall ,
    // branch address and jump address from branch handling unit 
        input branch_taken ,
        input[`ADDR_WIDTH-1:0]  next_pc,
        output system_flush,  
        output reg[`INST_WIDTH-1:0] opcode, 
        output reg uop_valid_out,
        output reg[`ADDR_WIDTH-1:0] pc_out 
        );

   localparam STATE_WIDTH=2;
// localparam `ADDR_WIDTH=$clog2(MEM_DEPTH);
     // top level 

     //architectural registers for simple registers  

   //  reg[31:0] A, B,C,D,E  //specify the registers later 
     reg[STATE_WIDTH-1:0] PresentState , NextState;
     //program counter
     reg[31:0] ProgramCounter;
    //old program counter is to be reatained 
     reg[31:0] ProgramCounter_previous;
     // instruction register 
     reg[31:0] InstructionRegister;
     reg IR_v; //Instruction regsiter valid








      //************************************************************************************
      //  R E S E T    L   O  G  I  C 
      //**********************************************************************************
     
        
       

     always@(posedge clk or posedge reset)
     begin
	    		      
                      
	  if(reset )
	  begin 
	//  NextState=`RESET;
          PresentState=`RESET;
          InstructionRegister<={`INST_WIDTH{1'b0}};
          ProgramCounter_previous<={`ADDR_WIDTH{1'b0}};
          ProgramCounter <={`ADDR_WIDTH{1'b0}};
           

          end

         
          if(reset || system_flush)
          begin 
             req_valid=1'b0;
             we = 1'b0;
             Addr = {`ADDR_WIDTH{1'b0}} ;
             opcode={`INST_WIDTH{1'b0}};
            uop_valid_out=1'b0;
            pc_out={`ADDR_WIDTH{1'b0}};

          end 

	  
         
      end //always block  
       // opcode and uop valid sent to the pipeline ent to the pipeline 


      //************************************************************************************
      //P R O G R A M     C O U N T E R       L   O  G  I  C  
      //**********************************************************************************


        always @(posedge clk or posedge reset  )  
        begin

            if( !system_stall || branch_taken || !reset)   
          begin 
	            
           // Program Counter update logic 
           //PC is updated only when PresentState is RX 
           // or whenver there is branch taken    
              if(branch_taken)
                  begin 
                  ProgramCounter_previous <= ProgramCounter ;  
                  ProgramCounter<=next_pc;
                  end
            else  if(NextState == `RX )
                 begin
                  ProgramCounter_previous <= ProgramCounter ;  
                  ProgramCounter <= ProgramCounter+1; 
                 end 

                    

                //Instruction Register & valid  Update 
               
                if(NextState == `RX )
                 begin
                  InstructionRegister<=Data;
	          IR_v<=1'b1;
                   end 
                 else 
                  IR_v <=1'b0;




                  // Limiting unintended executions of invalid instructions  

                if(ProgramCounter==MEM_DEPTH)
			  ProgramCounter <=0;
            end 
        end
   

    



      //************************************************************************************
      //TX & RX  S T A T E     M  A  C  H  I  N  E         L   O  G  I  C 
      //**********************************************************************************




     always@(*)  //always comb 
        begin 
       
 
        if( !system_stall || branch_taken || !reset)   
        begin 

       //in case of branch taken , unconditionally assume `TX state 
           if(branch_taken) 
                 NextState <=`TX ;

             

          case(PresentState) 

	    
	   	    `RESET :  begin
             	             if(reset)
                             begin 
                              NextState<=`RESET;
                            end    
                            else 
                            NextState <= `TX; 
                                   
		             end

                      `TX:   begin 
                            if(grant)
			    	NextState <=`WAIT;
                             else 
                                NextState <= `TX;
  
 			    end 
		     `WAIT :  begin

                              if(data_valid)
			      NextState <= `RX;
                               else 
                                 NextState<=`WAIT;

                              end 

		    `RX : begin
                           NextState <=`TX;
		          end 

                endcase

                      

                end 
             end // always block   

        `POS_EDGE_FF(clk,reset,NextState,PresentState) ;  

     
      //************************************************************************************
      // O U T P U T         L   O  G  I  C 
      //**********************************************************************************
 

           






           always@(posedge clk)
            begin 
                if(IR_v)
                begin 
                    opcode=InstructionRegister;
                    pc_out=ProgramCounter_previous; 
                end 
              uop_valid_out=IR_v;
              we <=1'b0; //as we never generate write request from fetch unit

              
              if(NextState==`TX || NextState==`WAIT )
               begin
                  
                 Addr <= ProgramCounter;
                 req_valid<= !system_flush & 1'b1;
               end 
               else begin
                 Addr <= ProgramCounter;

                 req_valid <=1'b0;
              end
                 


            end 		

   // flush logic , to be extended later as development progresses  
   assign system_flush = branch_taken ;

endmodule 



             
        	

	 
