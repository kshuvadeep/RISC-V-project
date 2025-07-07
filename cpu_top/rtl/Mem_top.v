// this file is the simple register file that is used as a simple soc simuilation 

//`include "Global_defines.vh"
`include "system_param.vh"
`timescale 1ns / 1ps

 module Mem_top  
                ( input[`ADDR_WIDTH-1:0] addr ,
                 input req_valid ,input WE,
                 input clk ,reset ,
                 input[`DATA_WIDTH-1:0]  wrt_data,
                 output[`DATA_WIDTH-1:0]  rd_data,
                 output  data_valid ) ; // think of it as a successful read/write status bit  

     // localparam `ADDR_WIDTH=$clog2(`MEM_DEPTH);
       reg[`DATA_WIDTH-1:0] data_reg;
       reg data_valid_reg;
       reg csn_mem;
             // 1Read /1 Write Memory model
        //Main Memory 
       reg[`MEM_DATA_WIDTH-1:0] Mem[0:`MEM_DEPTH-1];
       integer i;
 
      
       //assign csn_mem =  (addr[`ADDR_WIDTH-1: `ADDR_WIDTH-`IO_SELECT-1] ==`MEM_SELECT ) ? 1'b1 :1'b0;
      // MEMORY INITIALIZATION 

       // `include "Mem_init_fibonacci.v" 
       // `include "/home/shuvadeep/Documents/Work/RISC_V_ver2/emulator/load_store_code_uart.v"  // passed 
        `include "/home/shuvadeep/Documents/Work/RISC_V_ver2/emulator/transmit_hello.v"  //waiting to be passed yet 
       // `include "/home/shuvadeep/Documents/Work/RISC_V_ver2/emulator/memory_code_fibonacci.v" //passed on 28/05/2025

 
         // $readmemh("/home/shuvadeep/Documents/Work/RISC_V/emulator/memory_code_fibonacci.hex",Mem); // passed  ECO done 
        // $readmemh("/home/shuvadeep/Documents/Work/RISC_V/emulator/loop_multiplication.hex",Mem); // passed , ECO done 

		
		 always@(posedge clk  )
		 begin
			
                if(reset)
                    begin
		    data_valid_reg <= 1'b0;
                    data_reg<= {`DATA_WIDTH{1'b0}};                                                      

		         end 
                 else begin
                
        
		   if(req_valid && !WE)
		   data_reg <= {Mem[addr+3],Mem[addr+2],Mem[addr+1],Mem[addr]};
                   //write 
		   if(req_valid && WE )
		   Mem[addr] <=wrt_data;
		  // data_valid
                   data_valid_reg <= req_valid ;// simplyfying 
                  
                 
              end // if reset else block 

		//   data_valid_reg=1'b0;
		
		csn_mem =  (addr[`ADDR_WIDTH-1: `ADDR_WIDTH-`IO_SELECT] ==`MEM_SELECT ) ? 1'b1 :1'b0;

	   end  //always block 
	    
	    
           assign  rd_data= csn_mem ?data_reg : {`DATA_WIDTH{1'bz}} ;     
           assign data_valid = csn_mem ?  data_valid_reg   : 1'bz;
           // release the data bus from output in case of unselected io  
	   // assign data_valid=data_valid_reg;

	    //there are some loopholes in data_valid logic , need to fix it
	    //chnage#2 



  endmodule 	    





		        	
    
		 





    

