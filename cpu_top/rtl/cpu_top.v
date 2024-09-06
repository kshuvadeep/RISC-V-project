
// Development of a basic risc -v cpu core .
// 26h july 
//`include "Global_defines.vh"


`timescale 1ns / 1ps
 `include "system_param.vh"
 `include  "rvi32_instructions.vh"
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
wire [`ADDR_WIDTH - 1:0] addr_wire;
wire [`DATA_WIDTH - 1:0] data_wire;
wire we_wire;
wire req_valid_wire;
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
wire uop_valid_fetch ,uop_valid_exe,uop_valid_wrtbck;

wire v_p0_wire, v_p1_wire, source_not_ready_wire;

//stall ,initial implementation 

wire stall_fetch, stall_decode ; 

//***********************************************





  Fetch #(
    .MEM_DEPTH(8),        // Set the memory depth
    .DATA_WIDTH(32)       // Set the data width
     ) 
        u_fetch(
    .Addr(addr_wire),        // Address output
    .Data(Data),        // Data inout
    .we(we_wire),            // Write enable output
    .req_valid(req_valid_wire),  // Request valid output
    .clk(clk),              // Clock input
    .reset(reset),          // Reset input
    .data_valid(data_valid), // Data valid input
    .system_stall(stall_fetch), //stall 
    .opcode(opcode_wire),
    .uop_valid_out(uop_valid_fetch)
    );
   
   //Decoder 
   decoder decoder_inst (
    .instruction(opcode_wire),       // Instruction input
    .clk(clk),                            // Clock input
    .reset(reset),                        // Reset input
    .system_stall(stall_decode),     // System stall input
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
     .uop_valid_out(uop_valid_exe)
    //.decoder_stall(decoder_stall_wire)    // Decoder stall output
     );
   
       //Execution 
    
     execution execution_inst (
    .instruction_type(instruction_type_wire),    // Instruction type input
    .funct3(funct3_wire),                        // Funct3 input
    .funct7(funct7_wire),                        // Funct7 input
    .immediate(immediate_wire),                  // Immediate input
    .system_stall(system_stall_wire),            // System stall input
    .uop_valid_in(uop_valid_exe),
    .data_src1(data_src1_wire),                  // Data source 1 input
    .data_src2(data_src2_wire),                  // Data source 2 input
    .Execution_Result(Execution_Result_wire),    // Execution result output
    .uop_valid_out(uop_valid_wrtbck),            // Result valid output
    .clk(clk),                                   // Clock input
    .reset(reset)                                // Reset input
      )     ;

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
    .Wr_En(Wr_En_wire)                             // Write enable output
   );



   // **************************************************
   // R   E  G  I  S  T  E  R  ( 2 read ,1 Write ,1 invalidaiton port 
   //***************************************************

  ArchRegistersInt ArchRegistersInt_inst (
    .clk(clk),                                  // Clock input
    .reset(reset),                              // Reset input
    
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
       assign    stall_fetch=source_not_ready_wire; 
       assign    stall_decode =source_not_ready_wire; 

       //output Glue logic
      
      assign  Addr=addr_wire ;
      assign  we=we_wire;
       assign req_valid=req_valid_wire ;
   
   endmodule    
