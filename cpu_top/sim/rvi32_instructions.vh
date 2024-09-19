// rvi32_instructions.vh

// ChatGpt generated file with the given query 
// generate an header files in verilog defining all the RVI32 instruction and with their corresponding opcode . like define  ADD 0110011 
// RISC-V Instruction Categories and Bit Fields

`define R_TYPE 4'b000
`define I_TYPE 3'b001
`define LOAD_TYPE 3'b010
`define STORE_TYPE 3'b011
`define B_TYPE 3'b100
`define J_TYPE 3'b101
`define U_TYPE 3'b110
`define S_TYPE 3'b111



// R-type Instructions
`define R_TYPE_OP  7'b0110011
`define R_ADD       3'b000
`define R_SUB       3'b000
`define R_SLL       3'b001
`define R_SLT       3'b010
`define R_SLTU      3'b011
`define R_XOR       3'b100
`define R_SRL       3'b101
`define R_SRA       3'b101
`define R_OR        3'b110
`define R_AND       3'b111
`define R_FUNCT7_SRA 7'b0100000
`define R_FUNCT7_SRL 7'b0000000

// I-type Instructions
`define I_TYPE_OP  7'b0010011
`define I_ADD       3'b000
`define I_SLTI      3'b010
`define I_SLTIU     3'b011
`define I_XORI      3'b100
`define I_ORI       3'b110
`define I_ANDI      3'b111

// Load Instructions
`define LOAD_OP    7'b0000011
`define LOAD_LB    3'b000
`define LOAD_LH    3'b001
`define LOAD_LW    3'b010
`define LOAD_LBU   3'b100
`define LOAD_LHU   3'b101

// Store Instructions
`define STORE_OP   7'b0100011
`define STORE_SB   3'b000
`define STORE_SH   3'b001
`define STORE_SW   3'b010

// Branch Instructions
`define BRANCH_OP  7'b1100011
`define BRANCH_BEQ 3'b000
`define BRANCH_BNE 3'b001
`define BRANCH_BLT 3'b100
`define BRANCH_BGE 3'b101
`define BRANCH_BLTU 3'b110
`define BRANCH_BGEU 3'b111

// J-type Instructions
`define JAL_OP    7'b1101111
`define JALR_OP   7'b1100111

// U-type Instructions
`define U_TYPE_OP  7'b0110111
`define AUIPC_OP   7'b0010111

// SYSTEM Instructions
`define SYSTEM_OP  7'b1110011
`define ECALL      3'b000
`define EBREAK     3'b001

// Immediate Bit Fields
`define IMM_I   11:0
`define IMM_S   11:0
`define IMM_B   12:1
`define IMM_J   20:1
`define IMM_U   31:12

// Function Code Bit Fields
`define FUNCT3   2:0
`define FUNCT7   6:0

