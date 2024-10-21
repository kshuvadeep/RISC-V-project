// This module acts as an arbiter between instruction fetch & data fetch unit 
// it's a simple priority encoder logic giving priority to instructions for obvious reasosns 
// Author: Shuvadeep Kumar 
// Company Name : auToRIsca 
//Date :24th September 

`include "system_param.vh"
`define RESET 2'b00
`define TX 2'b01 
`define WAIT 2'b11
`define RX 2'b10   // Fixed RX size

`define NOREQ 2'b00 
`define REQ0 2'b10
`define REQ1 2'b01
`define BOTHREQ 2'b11

module Arbiter(
    input clk,
    input reset,
    // IFetch interface
    input req0_valid,
    input [`ADDR_WIDTH-1:0] addr_p0,
    inout [`DATA_WIDTH-1:0] data_p0,
    input we_p0,
    output reg grant0,
    input system_flush,
    input system_stall , 
    // MMU interface
    input req1_valid,
    input [`ADDR_WIDTH-1:0] addr_p1,
    inout [`DATA_WIDTH-1:0] data_p1,
    input we_p1,
    output reg grant1,
    // CPU top interface or Main memory bus interface
    output reg req_valid,
    output reg [`ADDR_WIDTH-1:0] addr,
    output reg we,
    inout [`DATA_WIDTH-1:0] data,
    input data_valid
    
);

    // Intermediate signals
    reg [`DATA_WIDTH-1:0] next_data;
    reg busy, PingPong ;
    reg [`ADDR_WIDTH -1:0] addr_reg;

    // State registers
    reg [1:0] PresentState, NextState;
     
     // data registers
    reg[`DATA_WIDTH-1:0] data_p0_reg ,data_p1_reg; 
   wire[1:0] req ={req0_valid,req1_valid};

    // Assert that grant0 and grant1 cannot be high at the same time
    always @(posedge clk) begin
        if (grant0 && grant1) begin
            $display("Error: grant0 and grant1 are both asserted at time %0t", $time);
            $stop; // Stop simulation if this happens
        end
    end

    // Priority or grant logic in always comb block 
    always @(*) begin
        if (reset) begin
            grant0 <= 1'b0;
            grant1 <= 1'b0;
            busy <= 1'b0;
            PresentState<= 2'b0;
            NextState<= 2'b0;
            next_data <={`DATA_WIDTH{1'b0}};
           //  PingPong <= 1'b0; 

        end else begin
               
             if(busy)
               begin 
                  grant0 <=1'b0;
                  grant1 <= 1'b0;
                end 
               else 
               begin 
               case (req )
               
                `NOREQ : begin 
                          grant0 <= 1'b0;
                          grant1 <= 1'b0;
                         end 
               `REQ0 : begin 
                      	   grant0 <= 1'b1;
                           grant1 <= 1'b0;
                       end 
               `REQ1: begin
                      	   grant0 <= 1'b0;
                           grant1 <= 1'b1;
 
                      end 
              `BOTHREQ :begin 
                        // PingPong <= ~PingPong ; 
         // a simple Ping pong Arbitration scheme , that can be easily scaled  
                        //  if(PingPong)
                        //   begin  
                      	//   grant0 <= 1'b1;
                        //   grant1 <= 1'b0;
                        //   end

          // since it's a data dependent machine i.e a simple 
          // in order machine , data should be our first priority
         // Fetched uop has no meaning if the younger instructions are not 
        // executed   
                            grant0 <= 1'b0;
                           grant1 <= 1'b1;

                       end   
                     
               endcase 
            end 
       end  
     end //always block  

    // State Machine for the data transmission protocol
    always @(posedge clk or posedge reset) begin
        if (reset || (NextState == `RESET) || system_flush) begin
            PresentState <= `RESET;
            addr <= {`ADDR_WIDTH{1'b0}};
            data_p0_reg <= {`DATA_WIDTH{1'b0}};
            data_p1_reg <= {`DATA_WIDTH{1'b0}};
            req_valid <= 1'b0;
            we <= 1'b0;
            busy <= 1'b0;
        end else begin
           
            // Update state
            if(!system_stall )
            PresentState <= NextState;
          // if NextState is reset , deassert the Mem request 

         
        end
    end

    // Next State logic State machine as a combo circuit

   always@(posedge clk or posedge reset)
   begin 

      if (grant0) begin
             addr_reg <= addr_p0;
             if (we_p0)
                next_data <= data_p0;
        end else if (grant1) begin
                 addr_reg <= addr_p1;
                  if (we_p1)
                     next_data <= data_p1;
                 end

          we <= we_p0 & grant0 | we_p1 & grant1 ;


     end  //always block 


 

    always@(*)
       begin

          if(system_flush)
           NextState <= `RESET ;

             
         else begin  

         case (PresentState)
                `RESET: begin
                    if (grant0 || grant1) begin
                        NextState <= `TX;
                    end
                end

                `TX: begin
                    req_valid <= 1'b1;
                     addr <= addr_reg;
                    // MUX for the arbiter input address and data
                                       NextState <= `RX;
                    busy <= 1'b1;
                end

                `RX: begin
                    if (data_valid) begin
                        NextState <= `WAIT;
                      //  next_data <= data;
                        busy <= 1'b1;
                        // for ifetch unit
                        if(req0_valid && !we)
                        data_p0_reg <=data ;
                       // for MMU unit 
                        if(req1_valid && !we)
                        data_p1_reg <=data ;
                       
                    end
                    else 
                     NextState <=`RX;
                end

                `WAIT: begin
                    if (grant0 || grant1) 
                        NextState <= `TX;
                      else 
                        NextState <=`RESET;
                    busy <= 1'b0;
                  //  we <= 1'b0;
                    req_valid<= 1'b0 ;
                end

                default: NextState <= `RESET; // Default to reset state
            endcase

            
       end 
    end  //always_comb block 






    // Assign the inout data signal
    assign data = we ? next_data : {`DATA_WIDTH{1'bz}};
    assign data_p0= we_p0? {`DATA_WIDTH{1'bz}}: data_p0_reg;
    assign data_p1 = we_p1? {`DATA_WIDTH{1'bz}}: data_p1_reg;

endmodule



