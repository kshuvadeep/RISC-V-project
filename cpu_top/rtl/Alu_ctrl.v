
`timescale 1ns / 1ps
`include "system_param.vh"
`include "Execution_param.vh"
`include "Macros.vh"
`include "rvi32_instructions.vh"

module Alu_ctrl(
    //inputs
    input[6:0] instruction_type, //R type ,I type ,J type etc 
    input[2:0] funct3,
    input [6:0] funct7,
    //clk,reset
     input clk ,
     input reset,
     input uop_valid_in,
     //outputs 
     output reg[`CTRL_ADD_WIDTH-1:0] ctrl_adder,  //adder datapath control 
     output reg uop_is_add,
     output reg[`CTRL_LOGIC_WIDTH-1:0] ctrl_logic , //logic unit ctrl 
    output reg uop_is_logic 
     ); 

   // Need to extend this further for other kinds of uop in execution unit

     always@(posedge clk )
      begin 
       if(reset)
       begin 
         ctrl_adder={`CTRL_ADD_WIDTH{1'b0}}; 
         ctrl_logic={`CTRL_LOGIC_WIDTH{1'b0}};
       end 
         // adder ctrl logic
      if(uop_valid_in)
       begin  
         
        if(instruction_type==`R_TYPE_OP && funct3==`R_ADD)
         begin 
          uop_is_add =1'b1;
           if(funct7[5]==1'b0)
           begin 
             ctrl_adder=`CTRL_ADD ; //addition 
            end 
           else if(funct7[5]==1'b1)
              begin ctrl_adder=`CTRL_SUB ; end // substraction 
          end 
         else if(instruction_type==`I_TYPE_OP && funct3==`I_ADD) 
            begin 
              uop_is_add =1'b1;
		ctrl_adder=`CTRL_ADDI;
             end
         else begin   uop_is_add=1'b0;  ctrl_adder={`CTRL_ADD_WIDTH{1'b0}}; end 

         // logic ctrl  
           
          if(instruction_type==`R_TYPE_OP)
           begin 
            case(funct3)
             `R_OR: begin ctrl_logic = `CTRL_OR; end
             `R_XOR :begin ctrl_logic=`CTRL_XOR; end 
              `R_AND:begin ctrl_logic=`CTRL_AND; end
              default : begin ctrl_logic = {`CTRL_LOGIC_WIDTH{1'b0}}; end 
             endcase 
            end

	if(instruction_type==`I_TYPE_OP)
           begin 
            case(funct3)
             `I_ORI: begin ctrl_logic = `CTRL_ORI; end
             `I_XORI :begin ctrl_logic=`CTRL_XORI; end 
              `I_ANDI :begin ctrl_logic=`CTRL_ANDI; end
              default : begin ctrl_logic ={`CTRL_LOGIC_WIDTH{1'b0}}; end 
             endcase 
            end 
 
            uop_is_logic = (| ctrl_logic); // the encoding is done in such a way 
       end //uop valid 
 
      end //always block
    
        //write an assertion to check for the exclusivity of these operators like uop_logic and uop_add should not be high at the same time 
        // Need to see if we can write a predicate for the uopcode for scalability for further extensions with ease  


 endmodule 


 	    


               
           
