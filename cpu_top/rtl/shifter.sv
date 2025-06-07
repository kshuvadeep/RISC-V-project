//*******************************************//
// Shifter unit for the RVI32 instruction set 
//*******************************************//
// Company : Risc Free 
// Author : Shuvadeep k 
// instructions that are supported are 
// 1. SLL 2. SLLI 3. SRL 4.SRLI 5.SRA 6.SRAI
//*******************************************


`include "system_param.vh"
`include "rvi32_instructions.vh"
`include "Execution_param.vh"
`include "Macros.vh"

module shifter( 
input clk ,
input reset, 
input uop_is_shift,                       // qualified with the uop valid 
input[`DATA_WIDTH-1:0] data_src1,         // rs1 
input[`DATA_WIDTH-1:0] data_src2,         //rs2 
input [`IMMEDIATE_WIDTH-1:0] immediate,    //immediate 
input [`CTRL_SHIFT_WIDTH-1:0] ctrl_shift, // shift operation type 
output [`DATA_WIDTH-1:0] result_shifter   //result 

);  

reg[`DATA_WIDTH-1:0] shift_out;

 always@(*)
  begin 
     if(uop_is_shift)
     begin 
       case(ctrl_shift)
       `CTRL_SLL  : shift_out = data_src1 << ( data_src2[4:0]);  // even if this oprator work ,it is better to make 
       `CTRL_SLLI : shift_out = data_src1 << immediate ;        // this code more structural 
       `CTRL_SRL  : shift_out = data_src1 >> (data_src2[4:0]);
       `CTRL_SRLI : shift_out = data_src1 >> immediate ;
       `CTRL_SRA : shift_out =  data_src1 >>> ( data_src2[4:0]);
       `CTRL_SRAI : shift_out =  data_src1 >>> (immediate);
        default :   shift_out =  data_src1 ;
       endcase 
     end 
     else 
        shift_out = {`DATA_WIDTH{1'b0}};
   end //always comb 

 assign result_shifter = shift_out ;


endmodule 
        
    
 
     
   
 

    


