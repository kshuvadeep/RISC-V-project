//This is the design of the MMU unit inside risc v processor 
// Company: Risc Free 
// Author : CEO ,founder ,shuvadeep 
// Date :13/09/2024

`timescale 1ns/1ps 
`include "system_param.vh"
`include "MMU_param.vh"

module Mmu(
  input clk ,
  input reset ,
  input[`CTRL_MEM_WIDTH] ctrl_mem,
  input[`ADDR_WIDTH-1:0] addr , 
  input [`DATA_WIDTH-1:0] data,
  //bus towards Instruction /Data memory arbiter 
  output [`ADDR_WIDTH-1:0] addr_req,
  output [`DATA_WIDTH-1:0] data_req,
  output We_req
 // output data from MMU unit
    
)


 // MMu unit will consist of a simple data cache 
// that probes the L1 core and sends out data in case of 
// a data hit
// currently i am designing a 4 x 4 set assosiative cache Memory 
// the Memory will consist of 1 tag and 1 data array 

 //Tag array 

