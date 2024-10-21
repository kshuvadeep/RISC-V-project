

`include "system_param.vh"
`include "Execution_param.vh" 
`include "sign_extended_right_shift.v"

module branch_cmp_unit(

 input[`DATA_WIDTH-1:0]  src1 ,
 input [`DATA_WIDTH-1:0] src2,
 input [`CTRL_BRANCH_WIDTH-1:0] ctrl_branch,
 input [`IMMEDIATE_WIDTH-1:0] immediate ,
 input [`ADDR_WIDTH-1:0] pc ,
 input system_stall,
 input clk ,
 input reset ,
 input uop_valid_in,
 input uop_is_branch,
 output reg[`ADDR_WIDTH-1:0] next_pc,
 output reg branch_taken 

);
//valid wire 

 wire [`ADDR_WIDTH-1:0] imm_jump_extended ,imm_branch_extended,imm_jump_extended_shifted,imm_branch_extended_shifted;

   assign imm_jump_extended = {{{`ADDR_WIDTH-`IMMEDIATE_WIDTH}{immediate[20]}}, immediate[20:0]};
  assign  imm_branch_extended = {{20{immediate[12]}}, immediate[12:0]}  ; 


// This is not needed any more , it was done to support a 4 byte word addressed memory 
//  sign_extended_right_shift  branch_shift (
//    .data_in(imm_branch_extended),        // Input data
//    .shift_amount(2),                     // Shift by 2 bits (equivalent to divide by 4)
//    .data_out(imm_branch_extended_shifted) // Output after shifting
//  );
//
//// Instantiate the module for imm_jump_extended_shifted
//sign_extended_right_shift  jump_shift (
//    .data_in(imm_jump_extended),          // Input data
//    .shift_amount(2),                     // Shift by 2 bits (equivalent to divide by 4)
//    .data_out(imm_jump_extended_shifted)  // Output after shifting
//);
 
 always@(*) // always comb 
  begin 
    
   

     if(reset)
      begin 
       next_pc={`ADDR_WIDTH{1'b0}};
       branch_taken=1'b0;
      end 

   //currently writing in behaviorally ,
   //However we will make it structural design considering backend and all in future 
   else begin 
     if(uop_valid_in & !system_stall & uop_is_branch)
     begin 
      
       case( ctrl_branch) 
          
            `CTRL_JAL : begin 
                       next_pc=pc+imm_jump_extended;
                       end
           `CTRL_JALR : begin 
                       next_pc = (src1 + imm_jump_extended) & ~32'b1; 
                       end

            `CTRL_BEQ: begin 
                       if(src1==src2)begin 
                       next_pc = pc+imm_branch_extended;
                       branch_taken=1'b1;
                       end 
                      else begin 
                        next_pc=pc+4; //considering 32 bit data is assigned an address, to do : change it to byte level
                        branch_taken =1'b0;
                       end   
                       
                       end 
            `CTRL_BNE : begin 
                       if(src1!==src2)begin 
                       next_pc = pc+imm_branch_extended;
                       branch_taken=1'b1;
                       end 
                      else begin 
                        branch_taken =1'b0;
                       end   
                       
                       end 

             `CTRL_BLT :   begin 
                       if(src1<src2)begin 
                       next_pc = pc+imm_branch_extended;
                       branch_taken=1'b1;
                       end 
                      else begin 
                        next_pc=pc+4; //considering 32 bit data is assigned an address, to do : change it to byte level
                        branch_taken =1'b0;
                       end   
                       
                       end 
             
                 `CTRL_BGE:  begin 
                       if(src1>=src2)begin 
                       next_pc = pc+imm_branch_extended;
                       branch_taken=1'b1;
                       end 
                      else begin 
                        next_pc=pc+4; //considering 32 bit data is assigned an address, to do : change it to byte level
                        branch_taken =1'b0;
                       end   
                       
                       end 
               // to do :signed and unsigned differentiation will be done during the structural coding 
               `CTRL_BLTU: begin 
                       if(src1<src2)begin 
                       next_pc = pc+imm_branch_extended;
                       branch_taken=1'b1;
                       end 
                      else begin 
                        next_pc=pc+4; //considering 32 bit data is assigned an address, to do : change it to byte level
                        branch_taken =1'b0;
                       end   
                       
                       end 
  
                  `CTRL_BGEU:begin 
                       if(src1>=src2)begin 
                       next_pc = pc+imm_branch_extended;
                       branch_taken=1'b1;
                       end 
                      else begin 
                        next_pc=pc+4; //considering 32 bit data is assigned an address, to do : change it to byte level
                        branch_taken =1'b0;
                       end   
                       
                       end 
 
                    default : begin  next_pc={`ADDR_WIDTH{1'b0}};  branch_taken =1'b0; end 

         endcase 
       end // always uop valid in block
    else 
        branch_taken=1'b0;
    end //if reset else 
   end  //always block  


endmodule   

  
                       
                         
            
                        
    
   

