
module Fifo #(parameter DEPTH= 16, WIDTH=32) (
           input reset,
           input wrt_clk ,  // gated wrt_clk
           input rd_clk ,    // gated rd_clk 
           input[`DATA_WIDTH-1:0] wrt_data,
           output reg[`DATA_WIDTH-1:0] rd_data,
            
           output reg full ,
           output reg empty 
          );

     localparam PTR_WIDTH =$clog2(DEPTH);
   
    reg[WIDTH-1:0] Fifo[0:DEPTH-1] ; 
    reg [PTR_WIDTH-1:0] rd_ptr, wrt_ptr; 

    
     


    always@(posedge wrt_clk or posedge reset)
    begin 
         if(reset)
         begin 
            rd_ptr<=0;
            wrt_ptr<=0;
            full <=0;
            empty<=1'b1;
         end 
        else begin 
            if(!full) begin
             wrt_ptr<=wrt_ptr+1;
             Fifo[wrt_ptr] <= wrt_data;
             end
          end 
    end 

  always@(posedge rd_clk or posedge reset)
    begin 
         if(reset)
         begin 
            rd_ptr<=0;
            wrt_ptr<=0;
            full <=0;
            empty<=1'b1;
         end 
        else begin 
            if(!empty)begin
             rd_data<=Fifo[rd_ptr];
             rd_ptr<=rd_ptr+1;
             end
          end 
    end 

   
   always@(*)
   begin
    full = (rd_ptr == wrt_ptr+1); 
    empty = (rd_ptr ==wrt_ptr);
    end 


endmodule 
            
            
           
     
