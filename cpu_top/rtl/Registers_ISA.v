`timescale 1ns / 1ps
`include "register_defines.vh"
`include "Macros.vh"

module ArchRegistersInt(
    input clk,
    input reset,
    
    // Read Port 0
    input [4:0] addr_p0,       // Address for read port 0
    input re_p0,               // Read enable for port 0
    output reg [31:0] dout_p0, // Data output for port 0
    output reg v_p0,           // Valid output for port 0
    
    // Read Port 1
    input [4:0] addr_p1,       // Address for read port 1
    input re_p1,               // Read enable for port 1
    output reg [31:0] dout_p1, // Data output for port 1
    output reg v_p1,           // Valid output for port 1

    // Write Port
    input [4:0] addr_p2,       // Address for write port
    input we_p2,               // Write enable for write port
    input [31:0] din_p2,       // Data input for write port
    
    // Invalidation Port
    input we_pi,               // Invalidate enable
    input [4:0] addr_pi,       // Address for invalidation
    input uop_valid,           // Micro-op validity indicator
    
    output  source_not_ready // Flag indicating read-write conflict
);

    // Register file and validity bit array
    reg [31:0] regfile [31:0]; // 32 registers, 32 bits each
    reg [31:0] V_array;        // Validity bit array for each register
  //  reg re_p0_1d,re_p1_1d;

    // Conflict detection wires
    wire ReadP0Conflict, ReadP1Conflict;
    reg uop_valid_out;
    integer i ,j ;
    
    // Conflict detection logic for read-write conflicts
    assign ReadP0Conflict = (addr_p0 == addr_p2) & re_p0 & we_p2;
    assign ReadP1Conflict = (addr_p1 == addr_p2) & re_p1 & we_p2;
  //  assign source_not_ready = ReadP0Conflict | ReadP1Conflict;

initial begin 

 
            for (j = 0; j < 32; j = j + 1) begin
                regfile[j] <= 32'b0; // Initialize register values
                V_array[j] <= 1'b1;  // Reset valid bits
            end
end 

    // Sequential logic for register writes and invalidation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                regfile[i] <= 32'b0; // Initialize register values
                V_array[i] <= 1'b1;  // Reset valid bits
            end
        end else begin
            if (we_p2) begin
                regfile[addr_p2] <= din_p2; // Write data to register
                V_array[addr_p2] <= 1'b1;   // Mark register as valid
            end

            // Invalidate register if necessary
            if (we_pi && uop_valid_out) begin
                V_array[addr_pi] <= 1'b0;
            end
        end
    end

    // Combinational logic for read ports with forwarding
    always @(* ) begin
        // Read Port 0 with forwarding
        if (re_p0) begin
            if (ReadP0Conflict) begin
                dout_p0 = din_p2;          // Forward write data to read port 0
                v_p0 = 1'b1;               // Assume forwarded data is valid
            end else begin
                dout_p0 = regfile[addr_p0];
                v_p0 = V_array[addr_p0];
            end
        end else begin
            dout_p0 = 32'b0;
            v_p0 = 1'b0;
        end

        // Read Port 1 with forwarding
        if (re_p1) begin
            if (ReadP1Conflict) begin
                dout_p1 = din_p2;          // Forward write data to read port 1
                v_p1 = 1'b1;               // Assume forwarded data is valid
            end else begin
                dout_p1 = regfile[addr_p1];
                v_p1 = V_array[addr_p1];
            end
        end else begin
            dout_p1 = 32'b0;
            v_p1 = 1'b0;
        end
    end

//   `POS_EDGE_FF(clk,reset,re_p0,re_p0_1d)
//   `POS_EDGE_FF(clk,reset,re_p1,re_p1_1d)
   `POS_EDGE_FF(clk,reset,uop_valid,uop_valid_out) 
   

   assign source_not_ready = ((re_p0 ^ v_p0 )  | (re_p1 ^ v_p1 )) & uop_valid_out ;  // if any of source operands are not valid

endmodule

