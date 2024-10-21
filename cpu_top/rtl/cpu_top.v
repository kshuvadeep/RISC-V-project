
// Development of a basic risc -v cpu core .
// 26h july 
//`include "Global_defines.vh"


`timescale 1ns / 1ps
 `include "system_param.vh"
 `include  "rvi32_instructions.vh"
`include "Arbiter.v"
 `include "Fetch.v"
`include "Decode.v"
`include "execution.v"
`include "WriteBack.v"
`include "Registers_ISA.v"


 module cpu_top #(parameter MEM_DEPTH=64 ,parameter DATA_WIDTH=32 ) 
   (
	output[`ADDR_WIDTH -1:0] Addr ,
	inout[`DATA_WIDTH-1:0] Data,
	output we,
        output  req_valid,
//	input intr,  to be implemented later 
	input clk ,
	input reset,
	input data_valid

        );
    
  //************************************************
  // Wires declaration  
  //*********************************************
wire [`ADDR_WIDTH - 1:0] addr_ifetch,addr_mem;
wire [`DATA_WIDTH - 1:0] data_inst,data_mem; 
wire [`DATA_WIDTH - 1:0] data_mmu; 
wire we_ifetch,we_mem;
wire req_valid_ifetch,req_valid_mem,grant_ifetch,grant_mmu;
wire [`INST_WIDTH-1:0] opcode_wire ;
wire [`OPCODE_WIDTH-1:0] instruction_wire;
wire system_stall_wire;
wire [`REG_ADDR_WIDTH-1:0] rs1_wire, rs2_wire, rd_wire;
wire rs1_valid_wire, rs2_valid_wire, rd_valid_wire;
wire [`OPCODE_WIDTH-1:0] instruction_type_wire, funct7_wire;
wire [2:0] funct3_wire;
wire [20:0] immediate_wire;
wire decoder_stall_wire;

wire [`DATA_WIDTH-1:0] data_src1_wire, data_src2_wire, Execution_Result_wire,WrtBck_data_wire;
wire data_src1_valid ,data_src2_valid;
wire Result_valid_wire;

wire [`REG_ADDR_WIDTH-1:0]  WrtBck_Addr_wire;
wire Wr_En_wire;
wire uop_valid_fetch ,uop_valid_decode,uop_valid_exe,uop_valid_wrtbck;

wire v_p0_wire, v_p1_wire, source_not_ready_wire;
//program counter is also propagated to execution unit 
wire[`ADDR_WIDTH-1:0] pc_out_fetch,pc_out_decode ,pc_out_exe, pc_out_branch; 

//`ifdef SIM_ONLY
wire [`INST_WIDTH-1:0] instruction_out_decode , instruction_out_exe; 


//stall ,initial implementation 

wire stall_fetch, stall_decode,stall_from_exe ,system_flush; 

//branch 

wire branch_taken;

//***********************************************

//************Wires required for simulation  only ***




  //********************************************************************************
  // Only to be used for simulation  
  //********************************************************************************

 Arbiter arbiter_inst (
    .clk(clk),                        //clk
    .reset(reset),
    .req0_valid(req_valid_ifetch),    // Ifetch req to arbiter 
    .addr_p0(addr_ifetch),            //addr from ifetch 
    .data_p0(data_inst),              // data to ifetch 
    .we_p0(we_ifetch),                // we to ifetch though not necessary
    .system_flush(system_flush),     // flush the requests in case of the branch taken 
    .system_stall(source_not_ready_wire), // stall excludes stall from exe ,as it is created for mem request 
    .grant0(grant_ifetch),                  // grant from Arbiter 
    .req1_valid(req_valid_mem),                // MMu req to arbiter , currently tied to 0
    .addr_p1(addr_mem),                // addr from mmu
    .data_p1(data_mem),                //data from mmu
    .we_p1(we_mem),                    //we from mmu
    .grant1(grant_mmu),                  //grant from arbiter to mmu
    .req_valid(req_valid),           // req valid to Memory bus 
    .addr(Addr),                     // addr in Memory bus 
    .data(Data),                     // data in memory bus 
    .we(we),                         // we in Memory bus 
    .data_valid(data_valid)           //data valid from Mem 
  );



Fetch #(
    .MEM_DEPTH(64),        // Set the memory depth
    .DATA_WIDTH(32)       // Set the data width
     ) 
        u_fetch(
    .Addr(addr_ifetch),        // Address output
    .Data(data_inst),        // Data inout
    .we(we_ifetch),            // Write enable output
    .req_valid(req_valid_ifetch),  // Request valid output
    .clk(clk),                      // Clock input
    .reset(reset),                  // Reset input
    .grant(grant_ifetch),          //grant from arbiter 
    .data_valid(data_valid),      // Data valid input
    .system_stall(stall_fetch),  //stall
    .Mem_stall(stall_from_exe), 
    .opcode(opcode_wire),         // opcode 
    .uop_valid_out(uop_valid_fetch), // uop valid 
    .pc_out(pc_out_fetch)   ,          // program counter required to compute branch instructions
    .next_pc(pc_out_branch)   ,       // Next Program counter from branch unit
    .branch_taken(branch_taken),       //Whether the branch is taken 
    .system_flush(system_flush)
    );
   
   //Decoder 
   decoder decoder_inst (
    .instruction(opcode_wire),       // Instruction input
    .clk(clk),                            // Clock input
    .reset(reset),                        // Reset input
    .system_stall(stall_decode),     // System stall input
    .system_flush(system_flush),     //system flush  
    .uop_valid_in(uop_valid_fetch),       //uop valid input from Fetch
    .source_not_ready(source_not_ready_wire), // indicates data is not ready for that uop
    // Outputs to Register File (RF)
    .rs1(rs1_wire),                       // Source register 1 address output
    .rs2(rs2_wire),                       // Source register 2 address output
    .rd(rd_wire),                         // Destination register address output
    .rs1_valid(rs1_valid_wire),           // Source register 1 valid output
    .rs2_valid(rs2_valid_wire),           // Source register 2 valid output
    .rd_valid(rd_valid_wire),             // Destination register valid output

    // Outputs to Execution unit
    .instruction_type(instruction_type_wire),  // Instruction type output
    .funct3(funct3_wire),                 // Funct3 output
    .funct7(funct7_wire),                 // Funct7 output
    .immediate(immediate_wire)    ,       // Immediate output
     .uop_valid_out(uop_valid_exe),      // uop valid out
     .uop_valid_decode(uop_valid_decode), //uop valid out from decoder to register files  
     .pc_in(pc_out_fetch),                       // program counter needs to be propagated 
    //.decoder_stall(decoder_stall_wire)    // Decoder stall output 
      .pc_out(pc_out_decode),                       
      .instruction_out(instruction_out_decode)     //simulation only 

     );
   
       //Execution 
    
     execution execution_inst (
     .instruction_in(instruction_out_decode),          //instruction cycle alligned to exe ,sim only 
     .instruction_out(instruction_out_exe),            // instructions out alligned to exe ,sim only
     .pc_out(pc_out_exe) ,                      //pc out ,sim only 
    .instruction_type(instruction_type_wire),    // Instruction type input
    .funct3(funct3_wire),                        // Funct3 input
    .funct7(funct7_wire),                        // Funct7 input
    .immediate(immediate_wire),                  // Immediate input
    .system_stall(1'b0),                         // System stall input
    .uop_valid_in(uop_valid_exe),
    .data_src1(data_src1_wire),                  // Data source 1 input
    .data_src2(data_src2_wire),                  // Data source 2 input
    .Execution_Result(Execution_Result_wire),    // Execution result output
    .uop_valid_out(uop_valid_wrtbck),            // Result valid output
    .clk(clk),                                   // Clock input
    .reset(reset)        ,                        // Reset input
    .pc_in(pc_out_decode)  ,                      // program counter input 
    .next_pc(pc_out_branch) ,                       // program counter output
    .stall_from_exe(stall_from_exe), 
    .branch_taken(branch_taken) , 

      // Towards the Mem arbiter
     .addr(addr_mem),
     .data(data_mem),
     .data_valid(data_valid),
     .we(we_mem),
     .req_valid(req_valid_mem),
      . grant(grant_mmu)    
    ); 


    //Skipping memory related operations for now 
     
     //Wback 

    WriteBack WriteBack_inst (
    .Rd_decode(rd_wire),                    // Destination register address from decode stage
    .Execution_Result(Execution_Result_wire),      // Execution result input
    .uop_valid_in(uop_valid_wrtbck),                // Reset valid input
    .clk(clk),                                     // Clock input
    .reset(reset),                                 // Reset input
    .WrtBck_Addr(WrtBck_Addr_wire),                // Write-back address output
    .WrtBck_Data(WrtBck_data_wire),
    .Wr_En(Wr_En_wire) ,                            // Write enable output
    .pc_in(pc_out_exe),                             //SIM ONLY
    .instruction_in(instruction_out_exe)            // SIM ONLY 
   );



   // **************************************************
   // R   E  G  I  S  T  E  R  ( 2 read ,1 Write ,1 invalidaiton port ) 
   //***************************************************

  ArchRegistersInt ArchRegistersInt_inst (
    .clk(clk),                                  // Clock input
    .reset(reset),                              // Reset input
    .uop_valid(uop_valid_decode),                // uop valid decode 
    
    // p0 read port1
    .addr_p0(rs1_wire),                     // Address for port 0
    .re_p0(rs1_valid_wire),                         // Read enable for port 0
    .dout_p0(data_src1_wire),                     // Data output for port 0
    .v_p0(data_src1_valid),                           // Valid signal for port 0
    
    // p1 read port2
    .addr_p1(rs2_wire),                     // Address for port 1
    .re_p1(rs2_valid_wire),                         // Read enable for port 1
    .dout_p1(data_src2_wire),                     // Data output for port 1
    .v_p1(data_src2_valid),                           // Valid signal for port 1
    
    // p2 Write-back port
    .addr_p2(WrtBck_Addr_wire),                     // Address for port 2
    .we_p2(Wr_En_wire),                         // Write enable for port 2
    .din_p2(WrtBck_data_wire),                       // Data input for port 2
    
    // Pi invalidation port
    .we_pi(rd_valid_wire),                         // Write enable for invalidation port 
    .addr_pi(rd_wire),                     // Address for invalidation port
    
    .source_not_ready(source_not_ready_wire)    // Source not ready output
     );


   





        // Stall logic 
       assign    stall_fetch=source_not_ready_wire ;
       assign    stall_decode=source_not_ready_wire ;
      // removing stall from exe dependency for now ,as when the stall for the exe will happen , 
      // the arbiter will be busy in serving requests from memory , so the fetch unit will not receive and 
     // forward any new instruction into the pipeline  
     //  assign    stall_fetch =source_not_ready_wire | stall_from_exe ; 
     //  assign    stall_decode =source_not_ready_wire | stall_from_exe ; 

      
   
   endmodule    
