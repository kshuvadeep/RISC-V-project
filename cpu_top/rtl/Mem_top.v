// this file is the simple register file that is used as a simple soc simuilation 

//`include "Global_defines.vh"
`include "system_param.vh"
`timescale 1ns / 1ps

 module Mem_top #(parameter MEM_DEPTH=8 ,parameter DATA_WIDTH=32 ) 
                ( input[`ADDR_WIDTH-1:0] addr ,
                 input req_valid ,input WE,
                 input clk ,reset ,
                 inout[`DATA_WIDTH-1:0]  Data,
                 output reg data_valid ) ; // think of it as a successful read/write status bit  

     // localparam `ADDR_WIDTH=$clog2(MEM_DEPTH);
       integer i ;
       reg[`DATA_WIDTH-1:0] data_reg;
       reg data_valid_reg;
       wire csn_mem;
             // 1Read /1 Write Memory model
        //Main Memory 
       reg[`MEM_DATA_WIDTH-1:0] Mem[0:MEM_DEPTH-1];
 
      
       assign csn_mem =  (addr[`ADDR_WIDTH: `ADDR_WIDTH-`IO_SELECT] ==`MEM_SELECT ) ? 1'b0 :1'b0;
      // MEMORY INITIALIZATION 

        initial begin 
         //$readmemh("/home/shuvadeep/Documents/Work/RISC_V/emulator/load_store3.hex",Mem);  //passed 
         // $readmemh("/home/shuvadeep/Documents/Work/RISC_V/emulator/memory_code_fibonacci.hex",Mem); // passed  ECO done 
        // $readmemh("/home/shuvadeep/Documents/Work/RISC_V/emulator/loop_multiplication.hex",Mem); // passed , ECO done 
        end 

		
		 always@(posedge clk or posedge reset)
		 begin
			
                if(reset)
                    begin
		    data_valid <= 1'b0;
                    data_reg= {`DATA_WIDTH{1'b0}};                                                      

		   end 
                 else begin

		   // Read 
		   if(req_valid && !WE)
		   begin 
		   data_reg <= {Mem[addr+3],Mem[addr+2],Mem[addr+1],Mem[addr]};
		  // data_valid_reg <=1'b1;
	           end 
                   //write 
		   if(req_valid && WE )
		   begin 
		   Mem[addr] <=Data;
		  // data_valid_reg <=1'b1;
	           end 
                 if(csn_mem) 
                data_valid <= req_valid ;// simplyfying 
                 else 
                   data_valid <= 1'bz;    
                              
              end // if reset else block 

		//   data_valid_reg=1'b0;

	   end  //always block 
	    
	    assign Data=csn_mem ? : (WE? {`DATA_WIDTH{1'bz}}: data_reg) : 1'bz ; // release the data bus from output in case of write request  
	   // assign data_valid=data_valid_reg;

	    //there are some loopholes in data_valid logic , need to fix it
	    //chnage#2 



  endmodule 	    





		        	
    
		 





    

