// This module acts as an arbiter between instruction fetch & data fetch unit 
// it's a simple priority encoder logic giving priority to instructions for obvious reasosns 
// Author: Shuvadeep Kumar 
// Company Name : auToRIsca 
//Date :24th September 

`include "system_param.vh"
`include "Macros.vh"
`define RESET 2'b00
`define TX 2'b01 
`define WAIT 2'b11
`define RX 2'b10   // Fixed RX size

`define NOREQ 2'b00 
`define REQ0 2'b10
`define REQ1 2'b01
`define BOTHREQ 2'b11

`define IFETCH 1'b0
`define MMU 1'b1 

module Arbiter(
    input clk,
    input reset,
    // IFetch interface
    input req0_valid,
    input [`ADDR_WIDTH-1:0] addr_p0,
    output reg [`DATA_WIDTH-1:0] data_p0,
    output reg grant0,
    input system_flush,
    input system_stall , 
    // MMU interface
    input req1_valid,
    input [`ADDR_WIDTH-1:0] addr_p1,
    input [`DATA_WIDTH-1:0] data_p1_wrt,
    output reg [`DATA_WIDTH-1:0] data_p1_rd,
    input we_p1,
    output reg grant1,
    // CPU top interface or Main memory bus interface
    output reg req_valid,
    output reg [`ADDR_WIDTH-1:0] addr,
    output reg we,
    input [`DATA_WIDTH-1:0] rd_data,
    output reg [`DATA_WIDTH-1:0] wrt_data,
    output reg data_valid_mem,
   
    input data_valid
    
);

    // Intermediate signals
    reg [`DATA_WIDTH-1:0] next_data;
    reg busy, PingPong ;
    (* KEEP = "true" *) reg [`ADDR_WIDTH -1:0] addr_reg; // Instruction to synth tool to keep all the bits 
    reg current_agent;


    // State registers
    reg [1:0] PresentState, NextState;
     
     // data registers
    reg[`DATA_WIDTH-1:0] data_p0_reg ,data_p1_reg; 
    reg [`DATA_WIDTH-1:0] data_p1_wrt_1d;
   wire[1:0] req ={req0_valid,req1_valid};

    // Assert that grant0 and grant1 cannot be high at the same time
//    always @(posedge clk) begin
//        if (grant0 && grant1) begin
//            $display("Error: grant0 and grant1 are both asserted at time %0t", $time);
//            $stop; // Stop simulation if this happens
//        end
//    end

    // Priority or grant logic in always comb block 
    always @(*) begin
        if (reset) begin
            grant0 <= 1'b0;
            grant1 <= 1'b0;
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
    always @(posedge clk ) begin
        if (reset || (NextState == `RESET) || system_flush) begin
            PresentState <= `RESET;
        //    addr <= {`ADDR_WIDTH{1'b0}};
        //    data_p0_reg <= {`DATA_WIDTH{1'b0}};
        //    data_p1_reg <= {`DATA_WIDTH{1'b0}};
        //    req_valid <= 1'b0;
        //    we <= 1'b0;
        //    busy <= 1'b0;
        end else begin
           
            // Update state
            if(!system_stall )
            PresentState <= NextState;
          // if NextState is reset , deassert the Mem request 

         
        end
    end

    // Next State logic State machine as a combo circuit

   always@(posedge clk )
   begin 

         if(reset || (NextState == `RESET) || system_flush)
         begin 
           addr_reg<=0;
            we <= 1'b0;
            
         end 


      if (grant0) begin
             addr_reg <= addr_p0;
        end else if (grant1) 
                 addr_reg <= addr_p1;

          we <=  we_p1 & grant1 ;


     end  //always block 


 
   // need to track which agent is using the arbiter currently 
  always@(posedge clk )
  begin 
   if(grant0)
    current_agent <= `IFETCH ;
   else if(grant1)
      current_agent <=`MMU;
  end 



    always@(*)
       begin
 

           
            NextState=PresentState ; // to prevent the latch inferance 

            if(reset || (NextState == `RESET) || system_flush)
           begin 
           addr<=0;
          // data_p0 <= {`DATA_WIDTH{1'b0}};
           // data_p1_rd <= {`DATA_WIDTH{1'b0}};
            req_valid <= 1'b0;
            busy <= 1'b0;
            wrt_data <= 0;

         end 

           

          if(system_flush)
           NextState <= `RESET ;

             
         else begin  

         case (PresentState)
                `RESET: begin
                    if (grant0 || grant1)
                        NextState <= `TX;
                    else 
                        NextState <= `RESET;
                     
                     data_valid_mem <= 1'b0;

                end

                `TX: begin
                    req_valid <= 1'b1;
                     addr <= addr_reg;
                    // MUX for the arbiter input address and data
                     NextState <= `RX;
                    busy <= 1'b1;
                    data_valid_mem <= 1'b0;

                    
                    if(we)
                      wrt_data<=data_p1_wrt_1d; 
                
                end

                `RX: begin
                    if (data_valid) 
                        NextState <= `WAIT;
                      else 
                         NextState <= `RX;
                      //  next_data <= data;
                        busy <= 1'b1;
                        // for ifetch unit
                        if(current_agent == `IFETCH  && !we)
                        data_p0 <=rd_data ;
                     //   for MMU unit 
                      if(current_agent == `MMU && !we)
                        begin
                         data_p1_rd <=rd_data ;
                         data_valid_mem <= 1'b1;
                       end 
                       
                    end
                   
               

                `WAIT: begin
                    if (grant0 || grant1) 
                        NextState <= `TX;
                      else 
                        NextState <=`RESET;
                    busy <= 1'b0;
                  //  we <= 1'b0;
                    req_valid<= 1'b0 ;
                    data_valid_mem <= 1'b0;

                end

                default: NextState <= `RESET; // Default to reset state
            endcase

            
       end 
    end  //always_comb block


//    always@(posedge clk or posedge reset)
//    begin 
//      if(reset) begin
//          data_p1_rd <={`DATA_WIDTH{1'b0}};
//          data_valid_mem<= 1'b0;
//        end
//      else begin
//        if(NextState ==`TX ) begin
//            if(current_agent==`IFETCH)
//                data_p0 <=rd_data ;
//           else if(current_agent == `MMU)
//                begin
//                data_p1_rd <=rd_data;
//                data_valid_mem<= 1'b1;
//           end 
//         end 
//         else
//             data_valid_mem <= 1'b0;
//       end   
//
//   end 



 `POS_EDGE_FF(clk,reset,data_p1_wrt,data_p1_wrt_1d) 



    // Assign the inout data signal

endmodule



