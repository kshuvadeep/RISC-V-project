
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

//`define CLK_GATE(clk_in, en, clk_out) \
// always@(posedge clk_in) begin \ 
//   if (en) \
//   clk_out <= clk_in; \
// end 

`define CLK_GATE(clk_in, en, clk_out) \
reg clk_out; \
 always @(posedge clk_in or negedge en) begin \
   if (!en) \
     clk_out <= 1'b0; \
   else \
     clk_out <= clk_in; \
 end