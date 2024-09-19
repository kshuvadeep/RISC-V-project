// This is the decode stage where instructions 
// are decoded for their respective types 
// different bitfields are collected based on that and sent to exe unit
// Additionally decodes sends out the source and destination address to 
// Architectural registers  to read the data and if source is not found 
// Decoder will inititate stall signal to halt the system 

`include "rvi32_instructions.vh"
`include "system_param.vh"
// for 32 architectural register 
  

module decoder(

	  // inputs 
           input[`INST_WIDTH-1 :0] instruction,
	   input clk,
	   input reset,
	   input system_stall,
           input uop_valid_in ,
	   input source_not_ready, 
	   //outputs to RF 
	   output[`REG_ADDR_WIDTH-1:0] rs1,
           output[`REG_ADDR_WIDTH-1:0] rs2,
	   output[`REG_ADDR_WIDTH-1:0] rd,
	   output rs1_valid,rs2_valid,rd_valid,
	   // outputs to Execution unit 
	   output[6:0] instruction_type,
	    output[2:0] funct3,
           output[6:0] funct7,
            output[20:0] immediate ,
	  // output decoder_stall,
           output uop_valid_out
    );

   // local register 
    reg[6:0] instruction_type_reg ;
    reg[2:0] funct3_reg ;
    reg[6:0] funct7_reg;
    reg[20:0] immediate_reg;
    reg[6:0] instruction_opcode;
    reg[`REG_ADDR_WIDTH-1:0] rs1_reg,rs2_reg,rd_reg;
    reg rs1_valid_reg,rs2_valid_reg,rd_valid_reg,uop_valid_out_reg;
    wire uop_valid_decode;



   // Uop valid computation, assert the uop valid 
   // if a uop is coming for the first time or stalling becuase 
   //of data dependency . in case of stall due to data dependency
  // redispatch the uop from the decode stage 
   assign  uop_valid_decode= uop_valid_in | source_not_ready ;

    always @(posedge clk )
    begin 

       if(reset)
       begin 
       
	   instruction_type_reg = 6'b0;
            funct3_reg = 3'b0;
            funct7_reg = 7'b0;
            immediate_reg = 21'b0;
            rs1_reg = `REG_ADDR_WIDTH'b0;
            rs2_reg = `REG_ADDR_WIDTH'b0;
            rd_reg = `REG_ADDR_WIDTH'b0;
            rs1_valid_reg = 1'b0;
            rs2_valid_reg = 1'b0;
            rd_valid_reg = 1'b0;
            uop_valid_out_reg=1'b0;
            instruction_opcode=7'b0;

         end

           	  

	 else if(!system_stall && uop_valid_decode )
         begin 		 
	          instruction_opcode=instruction[6:0]; // opcode ,denotes whether a uop is R type ,I type etc 

 
         	 case(instruction_opcode) 
	     		 `R_TYPE_OP : begin
		    // make these bit fields parameterizable in future 
                           
			    funct3_reg =instruction[2:0];
                             rs1_reg= instruction[19:15];
			     rs2_reg=instruction[24:20];
			     rd_reg =instruction[11:7];
			     funct3_reg=instruction[14:12];
			     funct7_reg= instruction[31:25];
			     rs1_valid_reg=1'b1;  // if rs1 is getting used in the instruction ,this acts as read enable for register file ports 
			     rs2_valid_reg=1'b1;
			     rd_valid_reg=1'b1;
			     instruction_type_reg=`R_TYPE_OP;
			    end 
			  // I type or immediate instructions    

                        `I_TYPE_OP: begin
                   		funct3_reg = instruction[14:12];
                    		funct7_reg = 7'b0;  // `funct7` is not used in I-type instructions
                   		 rs1_reg = instruction[19:15];
                   		 rs2_reg = `REG_ADDR_WIDTH'b0;  // `rs2` is not used in I-type instructions
                  		  rd_reg = instruction[11:7];
                    		immediate_reg = {20'b0, instruction[31:20]}; // Sign-extended immediate
                   		 rs1_valid_reg = 1'b1;
                   	         rs2_valid_reg = 1'b0;
                    rd_valid_reg = 1'b1;
                    instruction_type_reg = `I_TYPE_OP;
                            end

	            `LOAD_OP: begin
                    funct3_reg = instruction[14:12]; // funct3 for load instructions
                    funct7_reg = 7'b0;  // `funct7` is not used in Load instructions
                    rs1_reg = instruction[19:15];
                    rs2_reg = `REG_ADDR_WIDTH'b0;  // `rs2` is not used in Load instructions
                    rd_reg = instruction[11:7];
                    immediate_reg = {20'b0, instruction[31:20]}; // Sign-extended immediate
                    rs1_valid_reg = 1'b1;
                    rs2_valid_reg = 1'b0;
                    rd_valid_reg = 1'b1;
                    instruction_type_reg = `LOAD_OP; // Make sure to define `LOAD_TYPE` in `rvi32_instructions.vh`

                          end
			  `STORE_OP: begin
                    funct3_reg = instruction[14:12]; // funct3 for store instructions
                    funct7_reg = 7'b0;  // `funct7` is not used in S-type instructions
                    rs1_reg = instruction[19:15];
                    rs2_reg = instruction[24:20];
                    rd_reg = `REG_ADDR_WIDTH'b0;  // `rd` is not used in S-type instructions
                    immediate_reg = {instruction[31:25], instruction[11:7]}; // Sign-extended immediate
                    rs1_valid_reg = 1'b1;
                    rs2_valid_reg = 1'b1;
                    rd_valid_reg = 1'b0;
                    instruction_type_reg = `STORE_OP;
		                end 
		    `BRANCH_OP: begin
                    funct3_reg = instruction[14:12]; // funct3 for branch instructions
                    funct7_reg = 7'b0;  // `funct7` is not used in B-type instructions
                    rs1_reg = instruction[19:15];
                    rs2_reg = instruction[24:20];
                    rd_reg = `REG_ADDR_WIDTH'b0;  // `rd` is not used in B-type instructions
                    immediate_reg = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]}; // Sign-extended immediate
                    rs1_valid_reg = 1'b1;
                    rs2_valid_reg = 1'b1;
                    rd_valid_reg = 1'b0;
                    instruction_type_reg = `BRANCH_OP;
		      
		       end 

		       `U_TYPE_OP: begin
                    funct3_reg = 3'b0;  // `funct3` is not used in U-type instructions
                    funct7_reg = 7'b0;  // `funct7` is not used in U-type instructions
                    rs1_reg = `REG_ADDR_WIDTH'b0;  // `rs1` is not used in U-type instructions
                    rs2_reg = `REG_ADDR_WIDTH'b0;  // `rs2` is not used in U-type instructions
                    rd_reg = instruction[11:7];
                    immediate_reg = {instruction[31:12], 12'b0}; // Sign-extended immediate
                    rs1_valid_reg = 1'b0;
                    rs2_valid_reg = 1'b0;
                    rd_valid_reg = 1'b1;
                    instruction_type_reg = `U_TYPE_OP;
		           end 
		    `JAL_OP: begin
                    funct3_reg = 3'b0;  // `funct3` is not used in J-type instructions
                    funct7_reg = 7'b0;  // `funct7` is not used in J-type instructions
                    rs1_reg = `REG_ADDR_WIDTH'b0;  // `rs1` is not used in J-type instructions
                    rs2_reg = `REG_ADDR_WIDTH'b0;  // `rs2` is not used in J-type instructions
                    rd_reg = instruction[11:7];
                    immediate_reg = {instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // Sign-extended immediate
                    rs1_valid_reg = 1'b0;
                    rs2_valid_reg = 1'b0;
                    rd_valid_reg = 1'b1;
                    instruction_type_reg = `JAL_OP;
                end

		 `JALR_OP: begin
                    funct3_reg = instruction[14:12];
                    funct7_reg = 7'b0;  // `funct7` is not used in JALR instructions
                    rs1_reg = instruction[19:15];
                    rs2_reg = `REG_ADDR_WIDTH'b0;  // `rs2` is not used in JALR instructions
                    rd_reg = instruction[11:7];
                    immediate_reg = {20'b0, instruction[31:20]}; // Sign-extended immediate
                    rs1_valid_reg = 1'b1;
                    rs2_valid_reg = 1'b0;
                    rd_valid_reg = 1'b1;
                    instruction_type_reg = `JALR_OP;
                end
                `AUIPC_OP: begin
                    funct3_reg = 3'b0;  // `funct3` is not used in AUIPC instructions
                    funct7_reg = 7'b0;  // `funct7` is not used in AUIPC instructions
                    rs1_reg = `REG_ADDR_WIDTH'b0;  // `rs1` is not used in AUIPC instructions
                    rs2_reg = `REG_ADDR_WIDTH'b0;  // `rs2` is not used in AUIPC instructions
                    rd_reg = instruction[11:7];
                    immediate_reg = {instruction[31:12], 12'b0}; // Sign-extended immediate
                    rs1_valid_reg = 1'b0;
                    rs2_valid_reg = 1'b0;
                    rd_valid_reg = 1'b1;
                    instruction_type_reg = `AUIPC_OP;
                end
                `SYSTEM_OP: begin
                    funct3_reg = instruction[14:12]; // funct3 for system instructions
                    funct7_reg = 7'b0;  // `funct7` is not used in system instructions
                    rs1_reg = instruction[19:15];
                    rs2_reg = `REG_ADDR_WIDTH'b0;  // `rs2` is not used in system instructions
                    rd_reg = instruction[11:7];
                    immediate_reg = {20'b0, instruction[31:20]}; // Sign-extended immediate
                    rs1_valid_reg = 1'b0;
                    rs2_valid_reg = 1'b0;
                    rd_valid_reg = 1'b0;
                    instruction_type_reg = `SYSTEM_OP;
                end
                default: begin
                    instruction_type_reg = 6'b0;
                    funct3_reg = 3'b0;
                    funct7_reg = 7'b0;
                    immediate_reg = 21'b0;
                    rs1_reg = `REG_ADDR_WIDTH'b0;
                    rs2_reg = `REG_ADDR_WIDTH'b0;
                    rd_reg = `REG_ADDR_WIDTH'b0;
                    rs1_valid_reg = 1'b0;
                    rs2_valid_reg = 1'b0;
                    rd_valid_reg = 1'b0;
                end

            endcase
               
       end  // ~stall block 
        
         //uop valid out
 
             uop_valid_out_reg= uop_valid_decode;

            
     end  // always block 

     assign instruction_type = instruction_type_reg;
    assign funct3 = funct3_reg;
    assign funct7 = funct7_reg;
    assign immediate = immediate_reg;
    assign rs1 = rs1_reg;
    assign rs2 = rs2_reg;
    assign rd = rd_reg;
    assign rs1_valid = rs1_valid_reg;
    assign rs2_valid = rs2_valid_reg;
    assign rd_valid = rd_valid_reg;
  //  assign decoder_stall = system_stall;
    assign uop_valid_out=uop_valid_out_reg & ~source_not_ready; // make the uop invalid as their sources are not ready 


    endmodule 
		   
   

		             	
	                          	

         


 

   





	    



