`include "system_param.vh"

module sign_extended_right_shift (
    input  wire [`ADDR_WIDTH-1:0] data_in,       // Input data to be shifted
    input  wire [4:0]       shift_amount,  // Number of bits to shift (5 bits for up to 31 shifts)
    output reg  [`ADDR_WIDTH-1:0] data_out       // Output after sign-extended right shift
);

 always @(*) begin
        if (data_in[31] == 1'b1) begin
            // If the number is negative, perform a logical right shift and fill MSBs with 1s
            data_out = (data_in >> 2) |  (32'hFFFFFFFF << (32 - 2));  // Sign extend
        end else begin
            // If the number is positive, perform a regular logical right shift
            data_out = data_in >> 2;
        end
    end
   
endmodule
