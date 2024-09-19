
`define POS_EDGE_FF(clk,reset,din,dout) \
always @(posedge clk or posedge reset) begin \
    if (reset) \
        dout <= 0; \
    else \
        dout <= din; \
end

`define NEG_EDGE_FF(clk, reset, din, dout) \
always @(negedge clk or posedge reset) begin \
    if (reset) \
        dout <= 0; \
    else \
        dout <= din; \
end
