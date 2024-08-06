//***************************************
//*Describes the basic adder unit structurally 
//and behaviorally 
//Date:6th august ,2024 : Risc Free Corp 
//****************************************

`include "system_param.vh"
`include "Execution_param.vh"
`include "rvi32_instructions.vh"

//
 module Adder_int(

	 //clk & reset 
	 input clk ,
         input reset ,
	 //control 
	  input[1:0] add_type,
         // source 		  
	  input[`DATA_WIDTH-1:0] src1,
          input[`DATA_WIDTH-1:0] src2,
	  input[20:0] immediate ,
	  // output 
	  output[`DATA_WIDTH-1:0] add_value
	  // output equal ,
	  // output overflow ,
	  
	   
	  );


	  // These two registers hold the final operands for the add operation 
	  // based on the control logic , source operands are routed to these
	  // registers 

	  reg[`DATA_WIDTH-1:0] adder_src1 ,adder_src2;
	  reg[`DATA_WIDTH-1:0] src2_inp;
          reg[`DATA_WIDTH-1:0] add_value_reg;



	  always@(posedge clk)
	  begin 
	     if(reset)
	     begin 
                 adder_src1={`DATA_WIDTH{1'b0}};
                 adder_src2={`DATA_WIDTH{1'b0}};
	     end 

	       case(add_type)

		       `CTRL_ADD :  begin src2_inp=src2; end 
		       `CTRL_SUB :  begin src2_inp= (~src2+1); end 
		       `CTRL_ADDI :  begin src2_inp={{(`DATA_WIDTH-21){1'b0}}, immediate};   end 
		       default :  begin src2_inp={`DATA_WIDTH{1'b0}}; end 
		      
              endcase 
              // store the operand1   
	       adder_src1=src1;

	       //store operand2 

               adder_src2=src2_inp;
	 // perform the final addition  
	// Design and optimize the adder topology and create a data path
	// optimizided code for this adder (*To do ) 

	       add_value_reg =(adder_src1 + adder_src2 );


	     
	    end  //always block  


        	 assign  add_value = add_value_reg;


  endmodule

       


                    


