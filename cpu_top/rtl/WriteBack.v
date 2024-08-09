//*******************
// This is the stage where the executed results are sent out to the register files for write 
// based on their destination registers 
// date :August 9th , 6:30 pm 
//Author : Shuvadeep Kumar 


`include "system_param.vh"



module WriteBack(
             
            //dest register 
            input[`REG_ADDR_WIDTH-1:0] Rd_decode, //coming from decode stage 
            input[`DATA_WIDTH-1:0] Execution_Result ,
            input Reset_Valid,
            //clk ,reset
            input clk , reset ,
            //output 
             output reg[`REG_ADDR_WIDTH-1:0] WrtBck_Addr,
             output reg Wr_En 
           );


            
             reg[`REG_ADDR_WIDTH-1:0] Rd_wb_exe01 ,Rd_wb_exe02 ;        
   
             //flopping the destination register for cycle allignment 
            // as it comes from decode stage  

             `POS_EDGE_FF(clk,reset,Rd_decode,Rd_wb_exe01)
             `POS_EDGE_FF(clk,reset,Rd_,Rd_wb_exe01,Rd_wb_exe02)

             always@(posedge clk)
              begin 
                if(reset)
                 begin 
                   WrtBck_Addr={`REG_ADDR_WIDTH{1'b0}};
                   Wr_En=1'b0;
                  end 
                  
                  if(Result_valid)
                   begin 
                      WrtBck_Addr=Rd_wb_exe02;
                      Wr_En=1'b1;
                    end 
                   else
                     begin Wr_En=1'b0;
                   end 
              end //always block 


 endmodule      
                                  
                       
                    

