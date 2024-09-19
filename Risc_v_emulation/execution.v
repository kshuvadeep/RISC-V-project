//*******************************************
//6th august :2024 : RiSk free corporation 
//This is first code for the execution unit 
//We implement the control paths and datapath for 
//execution units in this module  
//Individual execution units are described in their 
//respective modules instantiated here .
//******************************************

//***********************************************************
//Execution Stage is a 2 stage deep pipeline 
//where first stages Exe01 deocdes the pre decoded information 
//from the decoder stage and generates control paths that 
//control the individual execution units like adder ,shifter ,
//logical operators , load/store operator and so on . 
//Second stage Exe02 is dedicated for the data paths ,where 
//executions are executed and result is sent to Write back stage 
//****************************************************************

//*******************************************
//signal Naming convention 
// add_value_exe01 : denotes the output of adder unit and EXEO1 
// denotes that it captures the signals that belong to stage 1 of the 
// pipeline 

`include "system_param.vh"
`include "rvi32_instructions.vh"
`include "Execution_param.vh"
`include "Macros.vh"
//Execution Units 
`include "Alu_ctrl.v"  
`include "logical_unit.v"  
`include "Adder_int.v"  


module execution(
      input[6:0] instruction_type,
      input[2:0] funct3,
      input[6:0] funct7,
      input[20:0] immediate ,
      input system_stall,
      input uop_valid_in,
      input[`DATA_WIDTH-1:0] data_src1,
      input[`DATA_WIDTH-1:0]  data_src2,
      //outputs 
      output [`DATA_WIDTH-1:0] Execution_Result,
      output reg  uop_valid_out,
     //* Mem to be implemented later 
     // output [`ADDR_WIDTH-1:0] Mem_addr,
     // output uop_is_mem ,  
      //
      input clk ,
      input reset 
      );

      wire[`DATA_WIDTH-1:0] add_value_exe01,logical_value_exe01; 
      reg[`DATA_WIDTH-1:0] Execution_Result_exe01,Execution_Result_exe02; 
      wire result_valid_exe01;
      wire [`CTRL_LOGIC_WIDTH-1:0] ctrl_logic ;
      wire [`CTRL_ADD_WIDTH-1:0] ctrl_adder ;
      wire uop_is_logic_nq,uop_is_add_nq,uop_is_add,uop_is_logic;
      reg uop_valid_intermediate; 

      //Registers
      //

      //Control Unit  
      Alu_ctrl u_Alu_ctrl (
    .instruction_type(instruction_type),
    .funct3(funct3),
    .funct7(funct7),
    .clk(clk),
    .reset(reset),
    .uop_valid_in(uop_valid_in),
    .ctrl_adder(ctrl_adder),
    .uop_is_add(uop_is_add_nq),
    .ctrl_logic(ctrl_logic),
    .uop_is_logic(uop_is_logic_nq)
       ); 
  
      //execution units or datapath units 
      
     //logic unit  
       logical_unit u_logical_unit (
    .clk(clk),
    .reset(reset),
    .uop_valid_in(uop_valid_intermediate),
    .logic_type(ctrl_logic),
    .src1(data_src1),
    .src2(data_src2),
    .immediate(immediate),
    .logical_value(logical_value_exe01)
     );

     //Adder unit 
     Adder_int u_Adder_int (
        .clk(clk), 
        .reset(reset),
        .uop_valid_in(uop_valid_in),
        .add_type(ctrl_adder),
        .src1(data_src1),
        .src2(data_src2),
        .immediate(immediate),
        .add_value(add_value_exe01)
    );
   
       //Datapath Muxing

      // valid qualification 
      // uop is add is generated in exe01 stage ,hence it is 
     // qualified with uop_valid_intermediate;
      assign  uop_is_add =uop_is_add_nq & uop_valid_intermediate;
      assign  uop_is_logic= uop_is_logic_nq & uop_valid_intermediate;

         always@(*)
         begin
            if(reset)
            begin 
		Execution_Result_exe01={`DATA_WIDTH{1'b0}};
                uop_valid_out=1'b0;
            end 
             
            if(uop_is_add)
            begin 	Execution_Result_exe01=add_value_exe01; end 
            else if(uop_is_logic) 
            begin 	Execution_Result_exe01=logical_value_exe01; end 
          end // always block  
       
      assign result_valid_exe01 =(uop_is_add| uop_is_logic) ;   // gate here for any execution error like overflow detection from adder etc in future

       //Flop the result for staging to WB 
         `POS_EDGE_FF(clk,reset, Execution_Result_exe01,Execution_Result_exe02)
       //  `POS_EDGE_FF(clk,reset,result_valid_exe01,Result_valid)
          `POS_EDGE_FF(clk,reset,uop_valid_in,uop_valid_intermediate)
          `POS_EDGE_FF(clk,reset,result_valid_exe01 ,uop_valid_out)


      assign  Execution_Result=Execution_Result_exe02;
  
      

      

 endmodule 	
