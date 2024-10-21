
`define POS_EDGE_FF(clk,reset,din,dout) \
always @(posedge clk or posedge reset) begin \
    if (reset) \
        dout <= 0; \
    else \
        dout <= din; \
end

`define POS_EDGE_FF_EN(clk,reset,en,din,dout) \
always @(posedge clk or posedge reset or posedge en ) begin \
    if (reset) \
        dout <= 0; \
    else \
       if(en)  \
        dout <= din; \
  end   

`define NEG_EDGE_FF(clk, reset, din, dout) \
always @(negedge clk or posedge reset) begin \
    if (reset) \
        dout <= 0; \
    else \
        dout <= din; \
end
