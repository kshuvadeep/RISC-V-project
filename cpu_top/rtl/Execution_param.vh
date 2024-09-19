
// defines for adder
`define CTRL_ADD_WIDTH 2 
`define CTRL_ADD 2'b01
`define CTRL_SUB 2'b10
`define CTRL_ADDI 2'b11

//defines for shifter 


//defines for logic 
`define CTRL_LOGIC_WIDTH 3
`define CTRL_XOR 3'b001
`define CTRL_OR 3'b010
`define CTRL_AND 3'b011
`define CTRL_ANDI 3'b101
`define CTRL_XORI 3'b111
`define CTRL_ORI 3'b110
`define MSB_CTRL 2

//defines for branch control 
`define CTRL_BRANCH_WIDTH 3
`define CTRL_JAL     3'b000  // Jump and Link (JAL)
`define CTRL_JALR    3'b001  // Jump and Link Register (JALR)
`define CTRL_BEQ     3'b010  // Branch if Equal (BEQ)
`define CTRL_BNE     3'b011  // Branch if Not Equal (BNE)
`define CTRL_BLT     3'b100  // Branch if Less Than (BLT)
`define CTRL_BGE     3'b101  // Branch if Greater Than or Equal (BGE)
`define CTRL_BLTU    3'b110  // Branch if Less Than, Unsigned (BLTU)
`define CTRL_BGEU    3'b111  // Branch if Greater Than or Equal, Unsigned (BGEU)


