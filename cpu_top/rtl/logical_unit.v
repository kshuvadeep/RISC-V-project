
`timescale 1ns / 1ps
`include "system_param.vh"
`include "Execution_param.vh"
`include "rvi32_instructions.vh"

module logical_unit 
(
    //clk & reset 
    input clk,
    input reset,
    input uop_valid_in,
    //control 
    input [2:0] logic_type,
    // source         
    input [`DATA_WIDTH-1:0] src1,
    input [`DATA_WIDTH-1:0] src2,
    input [20:0] immediate,
    // output 
    output [`DATA_WIDTH-1:0] logical_value
);

    reg [`DATA_WIDTH-1:0] logical_src1, logical_src2;
    wire [`DATA_WIDTH-1:0] logical_src2_inp;
    reg [`DATA_WIDTH-1:0] logical_value_reg;

    wire [`DATA_WIDTH-1:0] And_result, Or_result, Xor_result;

    //source selection for rs2 based on the MSB of the control input 
    assign logical_src2_inp = logic_type[`MSB_CTRL] ? {{(`DATA_WIDTH-21){1'b0}}, immediate} : src2;

    always@(posedge clk)
    begin 
        if(reset)
        begin 
            logical_src1 = {`DATA_WIDTH{1'b0}};
            logical_src2 = {`DATA_WIDTH{1'b0}};
           
        end 
        else begin
            logical_src1 = src1;
            logical_src2 = logical_src2_inp;
        end
    end 

    // Will separately design libraries for this in future 
    assign And_result = logical_src1 & logical_src2;
    assign Or_result = logical_src1 | logical_src2;
    assign Xor_result = logical_src1 ^ logical_src2;

    always@(*)
    begin
       if(reset)
       logical_value_reg<=0;
       else begin 
       if(uop_valid_in)
       begin 
        case(logic_type)
            `CTRL_AND:  logical_value_reg = And_result;
            `CTRL_OR  : logical_value_reg = Or_result;
            `CTRL_XOR :  logical_value_reg = Xor_result;
            `CTRL_ANDI :  logical_value_reg = And_result;
             `CTRL_ORI:    logical_value_reg = Or_result;
            `CTRL_XORI:  logical_value_reg = Xor_result;
            default:                logical_value_reg = {`DATA_WIDTH{1'b0}};
        endcase
       end //uop valid 
      end //if else 
    end 

    assign logical_value = logical_value_reg;

endmodule
