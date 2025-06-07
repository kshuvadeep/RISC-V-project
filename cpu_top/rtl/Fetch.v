
// Development of a basic risc -v cpu core .
// 26h july 
//`include "Global_defines.vh"
`timescale 1ns / 1ps
`define RESET 2'b00
`define TX 2'b01 
`define WAIT 2'b11
`define RX 2'b10

`include "system_param.vh"
`include "Macros.vh"

 module Fetch    (
	output reg[`ADDR_WIDTH -1:0] Addr ,
	input[`DATA_WIDTH-1:0] Data,
        output reg req_valid,
        input grant ,

//	input intr,  to be implemented later 
	input clk ,
	input reset,
	input data_valid,
        input system_stall ,
        input Mem_stall, 
    // branch address and jump address from branch handling unit 
        input branch_taken ,
        input[`ADDR_WIDTH-1:0]  next_pc,
        output system_flush,  
        output reg[`INST_WIDTH-1:0] opcode, 
        output reg uop_valid_out,
        output reg[`ADDR_WIDTH-1:0] pc_out 
        );

   localparam STATE_WIDTH=2;
// localparam `ADDR_WIDTH=$clog2(`MEM_DEPTH);
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
     wire Extend_wait_state  ; 
     reg Extend_wait_state_flopped  ; 








      //************************************************************************************
      //  R E S E T    L   O  G  I  C 
      //**********************************************************************************
    
     initial begin 
          InstructionRegister<={`INST_WIDTH{1'b0}};
             ProgramCounter_previous<={`ADDR_WIDTH{1'b0}};
              ProgramCounter <={`ADDR_WIDTH{1'b0}};
            IR_v <=1'b0;
     end 

        
       

       // opcode and uop valid sent to the pipeline ent to the pipeline 


      //************************************************************************************
      //P R O G R A M     C O U N T E R       L   O  G  I  C  
      //**********************************************************************************


        always @(posedge clk  )  
        begin

              
	                    
	    if(reset )
	     begin 
	//  NextState=`RESET;
             InstructionRegister<={`INST_WIDTH{1'b0}};
             ProgramCounter_previous<={`ADDR_WIDTH{1'b0}};
              ProgramCounter <={`ADDR_WIDTH{1'b0}};
           

          end

   
           // Program Counter update logic 
           //PC is updated only when PresentState is RX 
           // or whenver there is branch taken    
              if(branch_taken)
                  begin 
                  ProgramCounter_previous <= ProgramCounter ;  
                  ProgramCounter<=next_pc;
                 // IR_v <=1'b0;
                  end

            else  if( !system_stall  && !reset && !Mem_stall && !system_flush )  
                   begin 


                 if (NextState == `RX )
                 begin
                     if(Mem_stall)
                      ProgramCounter <= ProgramCounter_previous;
                    else begin 
                      ProgramCounter_previous <= ProgramCounter ;  
                      ProgramCounter <= ProgramCounter+4; 
                     end 

                    

                     //Instruction Register & valid  Update 
               
                       InstructionRegister<=Data;
	            //    IR_v<= !system_stall  ; // in short if system stall don't assert it as valid ,
                                         // assert only when it recovers from the stall 
                    end
 
               



                  // Limiting unintended executions of invalid instructions  

                     if(ProgramCounter==(`MEM_DEPTH))
			  ProgramCounter <=0;
               end  // if branch not taken

                 //refactoring the code for IR_V as we see some synthesis issue
              
               IR_v <= branch_taken ? 1'b0 : (( NextState==`RX && !system_stall) ? 1'b1:1'b0 );
                
        end  // always clk 
   

    



      //************************************************************************************
      //TX & RX  S T A T E     M  A  C  H  I  N  E         L   O  G  I  C 
      //**********************************************************************************

    // During the Memory stall , the Arbiter serves the Mmu unit on priority 
    // However if there was an ongoing fetch operations being served currently 
    //we  


     always@(*)  //always comb 
        begin 
       
 
        if( (!system_stall || branch_taken) & !reset)   
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
                            if(grant & !system_stall & !Mem_stall)
			    	NextState <=`WAIT;
                             else 
                                NextState <= `TX;
  
 			    end 
		     `WAIT :  begin
                                
                              if(Extend_wait_state_flopped)
                               NextState<= `WAIT;

                               else begin 

                              if(data_valid && !system_stall && !Mem_stall && !Extend_wait_state_flopped)
			      NextState <= `RX;
                               else if(Mem_stall)
                               NextState<=`TX;
                                else 
                                  NextState <=`WAIT;
                              end //if else    
                                
                                                        
                                 end 

		    `RX : begin
                                                          
                          	 NextState <=`TX;
		          end 

                endcase

                      

                end 
             end // always block   

        `POS_EDGE_FF_EN(clk,reset,!system_stall,NextState,PresentState)
        `POS_EDGE_FF(clk,reset,Extend_wait_state,Extend_wait_state_flopped)

     
      //************************************************************************************
      // O U T P U T         L   O  G  I  C 
      //**********************************************************************************
 

           






           always@(posedge clk )
           begin 

               
            if(reset )
              begin 
              req_valid <=1'b0;
              Addr <= {`ADDR_WIDTH{1'b0}} ;
               opcode <={`INST_WIDTH{1'b0}};
              uop_valid_out <=1'b0;
              pc_out <={`ADDR_WIDTH{1'b0}};

            end 
         //only flush the requests , existing branch uop shouldn't be flushed  
          if(system_flush)
           begin 
              req_valid <=1'b0;
             Addr = {`ADDR_WIDTH{1'b0}} ;
         end 
 
              
                if(IR_v)
                begin 
                    opcode <=InstructionRegister;
                    pc_out <=ProgramCounter_previous; 
                end 
              uop_valid_out=IR_v & !Mem_stall & !system_flush;

              
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

   //special case detection // bug description is in Joplin notebook  
    
      assign Extend_wait_state =  (PresentState==`WAIT & ! data_valid & system_stall) ? 1'b1:1'b0;
            

	

   // flush logic , to be extended later as development progresses  
   assign system_flush = branch_taken ;

endmodule 
