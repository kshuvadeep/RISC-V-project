// this file is the simple register file that is used as a simple soc simuilation 

//`include "Global_defines.vh"

 module Mem_top #(parameter MEM_DEPTH=8 ,parameter DATA_WIDTH=32 ) 
                ( input[ADDR_WIDTH-1:0] addr ,
                 input req_valid ,input WE,
                 input clk ,reset ,
                 inout[DATA_WIDTH-1:0]  Data,
                 output data_valid ) ; // think of it as a successful read/write status bit  

      localparam ADDR_WIDTH=$clog2(MEM_DEPTH);
       integer i ;
       reg[DATA_WIDTH-1:0] data_reg;
       reg data_valid_reg;
             // 1Read /1 Write Memory model 

		 //Main Memory
		 reg[DATA_WIDTH-1:0] Mem[0:MEM_DEPTH-1];

		 always@(posedge clk or posedge reset)
		 begin
			if(reset)
			begin 
                          
			   for(i=0;i<MEM_DEPTH;i=i+1) begin 
				   Mem[i]=i;  // just for creating a test case 
			   end 

			   data_valid_reg=1'b0;

		   end 


		   // Read 
		   if(req_valid && !WE)
		   begin 
		   data_reg = Mem[addr];
		   data_valid_reg=1'b1;
	           end 
                   //write 
		   if(req_valid && WE )
		   begin 
		   Mem[addr]=Data;
		   data_valid_reg=1'b1;
	           end 

		//   data_valid_reg=1'b0;

	   end  //always block 
	    
	    assign Data=data_reg;
	    assign data_valid=data_valid_reg;

	    //there are some loopholes in data_valid logic , need to fix it
	    //chnage#2 



  endmodule 	    





		        	
    
		 





    

