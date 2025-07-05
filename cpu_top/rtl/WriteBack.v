////*******************
// This is the stage where the executed results are sent out to the register files for write 
// based on their destination registers 
// date :August 9th , 6:30 pm 
//Author : Shuvadeep Kumar 

`timescale 1ns / 1ps
`include "system_param.vh"
`include "Macros.vh"


module WriteBack(
             
            //dest register
             
            input[`REG_ADDR_WIDTH-1:0] Rd_decode, //coming from decode stage 
            input[`DATA_WIDTH-1:0] Execution_Result ,
            input uop_valid_in,
            input Mem_stall ,
            //clk ,reset
            input clk , reset ,
            //output 
             output reg[`REG_ADDR_WIDTH-1:0] WrtBck_Addr,
             output reg[`DATA_WIDTH-1:0] WrtBck_Data,
             output reg Wr_En ,
            //sim only 
             input[`ADDR_WIDTH-1:0] pc_in,
             input[`INST_WIDTH-1:0] instruction_in 
           );


            
             reg[`REG_ADDR_WIDTH-1:0] Rd_wb_exe01 ,Rd_wb_exe02 ;        
   
             //flopping the destination register for cycle allignment 
            // as it comes from decode stage  
            // Macros are not working realibily 

         //    `POS_EDGE_FF(clk,reset,Rd_decode,Rd_wb_exe01)
          //   `POS_EDGE_FF(clk,reset,Rd_wb_exe01,Rd_wb_exe02)

           always@(posedge clk)
           begin 
             if(reset)
             begin 
                Rd_wb_exe01<={`REG_ADDR_WIDTH{1'b0}};
                Rd_wb_exe02<={`REG_ADDR_WIDTH{1'b0}};
              end
                  if(!Mem_stall) begin 
                    Rd_wb_exe01 <= Rd_decode;
                     Rd_wb_exe02 <= Rd_wb_exe01;
                  end 
            end  //always block 

             always@(posedge clk)
              begin 
                if(reset)
                 begin 
                   WrtBck_Addr <={`REG_ADDR_WIDTH{1'b0}};
                   WrtBck_Data <={`DATA_WIDTH{1'b0}};
                   Wr_En<=1'b0;
                  end 
                  
                  if(uop_valid_in)
                   begin 
                      WrtBck_Addr <= Rd_wb_exe02;
                      WrtBck_Data <= Execution_Result;
                      Wr_En <= 1'b1;
                    end 
                   else
                     begin Wr_En <= 1'b0;
                   end 
              end //always block 


 endmodule      
