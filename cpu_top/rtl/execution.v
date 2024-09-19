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
`timescale 1ns / 1ps
`include "system_param.vh"
`include "rvi32_instructions.vh"
`include "Execution_param.vh"
`include "Macros.vh"
//Execution Units 
`include "Alu_ctrl.v"  
`include "logical_unit.v"  
`include "Adder_int.v" 
`include "branch_computation_unit.sv"


module execution(
      input[6:0] instruction_type,
      input[2:0] funct3,
      input[6:0] funct7,
      input[20:0] immediate ,
      input system_stall,
      input uop_valid_in,
      input[`DATA_WIDTH-1:0] data_src1,
      input[`DATA_WIDTH-1:0]  data_src2,
      input [`ADDR_WIDTH-1:0] pc_in,
      //outputs 
      output [`DATA_WIDTH-1:0] Execution_Result,
      output reg  uop_valid_out,
      output[`ADDR_WIDTH-1:0] next_pc,
      output  branch_taken,
      output stall_from_exe, // stall the fetch and decode stages in case of stall_from_exe signals 
     //* Mem to be implemented later 
     // output [`ADDR_WIDTH-1:0] Mem_addr,
     // output uop_is_mem ,  
      //
      input clk ,
      input reset,
      // sim only signals 
      input[`INST_WIDTH-1:0] instruction_in , 
      output reg[`ADDR_WIDTH-1:0] pc_out ,
      output reg [`INST_WIDTH-1:0] instruction_out
 
      );

      wire[`DATA_WIDTH-1:0] add_value_exe01,logical_value_exe01; 
      reg[`DATA_WIDTH-1:0] Execution_Result_exe01,Execution_Result_exe02; 
      wire result_valid_exe01;
      wire [`CTRL_LOGIC_WIDTH-1:0] ctrl_logic ;
      wire [`CTRL_ADD_WIDTH-1:0] ctrl_adder ;
      wire [`CTRL_BRANCH_WIDTH-1:0] ctrl_branch;
      wire uop_is_logic_nq,uop_is_add_nq,uop_is_add,uop_is_logic,uop_is_branch;
      reg[`ADDR_WIDTH-1:0] pc_in_01, pc_in_00;
      reg uop_valid_intermediate;
      reg[`INST_WIDTH-1:0]  instruction_out0;
      wire [`ADDR_WIDTH-1:0] next_pc_wire;
     

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
    .uop_is_logic(uop_is_logic_nq),
    .uop_is_branch(uop_is_branch),
     .ctrl_branch(ctrl_branch)
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
   
    branch_cmp_unit u_branch_cmp_unit (
    .src1(data_src1),                         
    .src2(data_src2),                       
    .ctrl_branch(ctrl_branch),           
    .immediate(immediate),             
    .pc(pc_in_01),         //  1 cycle delayed                 
    .system_stall(system_stall),   
    .clk(clk),                   
    .reset(reset),             
    .uop_valid_in(uop_valid_intermediate),
    .uop_is_branch(uop_is_branch),   
    .next_pc(next_pc_wire),             
    .branch_taken(branch_taken)  
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
         `POS_EDGE_FF(clk,reset,Execution_Result_exe01,Execution_Result_exe02)
       //  `POS_EDGE_FF(clk,reset,result_valid_exe01,Result_valid)
          `POS_EDGE_FF(clk,reset,uop_valid_in,uop_valid_intermediate)
          `POS_EDGE_FF(clk,reset,result_valid_exe01,uop_valid_out)
          `POS_EDGE_FF(clk,reset,pc_in,pc_in_01)
          `POS_EDGE_FF(clk,reset,pc_in_01,pc_out)
       // Sim only design 
          `POS_EDGE_FF(clk,reset,instruction_in,instruction_out0)
          `POS_EDGE_FF(clk,reset,instruction_out0,instruction_out)
     
                

      assign  Execution_Result=Execution_Result_exe02;

    // stall the pipe in case of a branch instruction 
    //We will remove this constraints in future  
    // REVIEW : 
      assign stall_from_exe=uop_is_branch;
      assign next_pc= next_pc_wire ;   
  
      

      

 endmodule 	
