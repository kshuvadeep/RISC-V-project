
`timescale 1ns / 1ps
`include "system_param.vh"
`include "Execution_param.vh"
`include "Mmu_param.vh"
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
     output reg uop_is_logic ,
     output reg[`CTRL_BRANCH_WIDTH-1:0] ctrl_branch, // branch unit ctrl 
     output reg uop_is_branch, 
      output reg[`CTRL_MEM_WIDTH-1:0] ctrl_mem ,
      output reg uop_is_mem_load,
      output reg uop_is_mem_store
        ); 

   // Need to extend this further for other kinds of uop in execution unit

     always@(posedge clk )
      begin 
       if(reset)
       begin 
         ctrl_adder={`CTRL_ADD_WIDTH{1'b0}}; 
         ctrl_logic={`CTRL_LOGIC_WIDTH{1'b0}};
         ctrl_branch={`CTRL_BRANCH_WIDTH{1'b0}};

         uop_is_branch=1'b0;
         uop_is_add=1'b0;
         uop_is_logic=1'b0;
                  
       end 
      if(uop_valid_in)
       begin  
        
      //*************************************************************************//
       // A D D E R        C O N T R O L 
       //************************************************************************

 
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

        //*************************************************************************//
       // L O G I C       C O N T R O L 
       //************************************************************************
 
           
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
     end // gating of uop valid  

       //*************************************************************************//
       // B R A N C H        C O N T R O L 
       //************************************************************************
          //branch control  , to do : Need to update the logic with uop_valid gating 
          if((instruction_type== `BRANCH_OP )|| (instruction_type== `JAL_OP )|| (instruction_type== `JALR_OP ) )
          begin 
               uop_is_branch=1'b1;
             if(instruction_type== `BRANCH_OP ) 
              begin 
               case(funct3)
               `BRANCH_BEQ: ctrl_branch=`CTRL_BEQ ;
               `BRANCH_BNE: ctrl_branch=`CTRL_BNE ;
               `BRANCH_BLT: ctrl_branch=`CTRL_BLT ;
               `BRANCH_BGE: ctrl_branch=`CTRL_BGE ;
               `BRANCH_BLTU: ctrl_branch=`CTRL_BLTU ;
               `BRANCH_BGEU: ctrl_branch=`CTRL_BGEU ;
                default : ctrl_branch={`CTRL_BRANCH_WIDTH{1'b0}};
              endcase 
            end 
              if( instruction_type== `JAL_OP )
                 ctrl_branch = `CTRL_JAL;

               if( instruction_type== `JALR_OP )
                 ctrl_branch = `CTRL_JALR;
         end 
          else begin 
                  uop_is_branch=1'b0;
                   ctrl_branch={`CTRL_BRANCH_WIDTH{1'b0}};
             end       // branch control 

        //*************************************************************************//
       // M E M        C O N T R O L 
       //************************************************************************

      if(instruction_type == `LOAD_OP || instruction_type == `STORE_OP) 
         begin 
         if (instruction_type == `LOAD_OP) 
          begin
	      uop_is_mem_load = 1'b1;  // Set load memory operation flag
              uop_is_mem_store = 1'b0;  // Set load memory operation flag
             

        case(funct3)
            `LOAD_LB: ctrl_mem = `CTRL_LB;
            `LOAD_LH: ctrl_mem = `CTRL_LH;
            `LOAD_LW: ctrl_mem = `CTRL_LW;
            `LOAD_LBU: ctrl_mem = `CTRL_LBU;
            `LOAD_LHU: ctrl_mem = `CTRL_LHU;
            default: ctrl_mem = {`CTRL_MEM_WIDTH{1'b0}}; // Default no-op
        endcase
      end 
    else if (instruction_type == `STORE_OP) 
    begin
         uop_is_mem_store = 1'b1;
         uop_is_mem_load = 1'b0;
        case(funct3)
            `STORE_SB: ctrl_mem = `CTRL_SB;
            `STORE_SH: ctrl_mem = `CTRL_SH;
            `STORE_SW: ctrl_mem = `CTRL_SW;
            default: ctrl_mem = {`CTRL_MEM_WIDTH{1'b0}}; // Default no-op
        endcase
    end
  end
 else 
  begin 
    uop_is_mem_load = 1'b0;  // No memory load operation
    uop_is_mem_store = 1'b0;  // No memory store operation
    ctrl_mem = {`CTRL_MEM_WIDTH{1'b0}}; // Reset memory control signals
   end

           
 
      end //always block

   
    
        //write an assertion to check for the exclusivity of these operators like uop_logic and uop_add should not be high at the same time 
        // Need to see if we can write a predicate for the uopcode for scalability for further extensions with ease  


 endmodule 


 	    


               
           
