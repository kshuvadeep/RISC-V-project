//******************************
//Company :Auto-Risca
//This is a mixed logic of
//arbitration ,packet buffer and
//control logic for Uart rx to handle
//programming bytes transmission or handle
//read requests from the CPU
//*******************************

`include "system_param.vh"

module Arbiter_uart_rx
(   input clk ,
    input rst ,
    inout[`ADDR_WIDTH-1:0] addr,
    input packet_v,
    input[`DATA_WIDTH-1:0] packet_data,
    output[`DATA_WIDTH-1:0] wrt_data,
    output[`DATA_WIDTH-1:0] rd_data,
    //control signals
    input programming ,
    input csn_uart,
   // output ready ,// optional ,to tell the sender it's status .
    inout req_valid ,
    inout data_valid,
    output arbiter_data_valid,
    inout we
);

  wire busy;
  wire wrt_request ,rd_request;
  reg [`DATA_WIDTH-1:0] packet_buffer;
  reg packet_buffer_v;
  wire rst_packet_v;
  reg[`ADDR_WIDTH-1:0] prog_addr;
  reg programming_ff;
  wire programming_negedge;
  wire we_int;
 typedef enum logic[1:0] {IDLE, WRT_REQUEST,
        RD_DATA} Arb_state ;
     Arb_state Present_state,Next_state ;

// design assumption
// We are assuming that write to UART packet buffer is
// so slow compared to cpu bus speed that any read or
// write triggered by programmer or CPU shall be done
// way before the next packet arrives and we don't loose
// any packet if it arrives in between an UART read or UART
// initiated Write


 assign wrt_request = programming  & packet_buffer_v;
 assign rd_request = !programming & req_valid & !we &
                     csn_uart & packet_buffer_v ;
                 // MSB 01 of the address depict the selection of Uart_io
                 // receiver

 // State Machine
 always_comb //state transition logic
  begin
      case(Present_state)
        IDLE: if(wrt_request)
                 Next_state <= WRT_REQUEST ;
              else if(rd_request)
                   Next_state <=RD_DATA  ;
               else
                   Next_state <=IDLE ;

         WRT_REQUEST:  if(data_valid)
                          Next_state <= IDLE ;
                       else
                          Next_state <= WRT_REQUEST;

         RD_DATA: if(data_valid)
                   Next_state <= IDLE;
                 else
                     Next_state <=RD_DATA;
          default : Next_state <= IDLE;

      endcase
         end  //always comb

    `POS_EDGE_FF(clk,rst, Next_state,Present_state)
    //packet buffer of 1 reigster as per design assumption
    `POS_EDGE_FF_EN(clk ,rst, packet_v , packet_data,packet_buffer)
    `POS_EDGE_FF(clk ,rst_packet_v ,packet_v,packet_buffer_v)
    `POS_EDGE_FF(clk,rst,programming,programming_ff)

    //O  U  T  P  U  T      L  O  G  I  C
    //*******************************************


     //req_valid will be driven by the module only if programming is on
       assign req_valid =( programming==1'b1) ? ((Present_state==WRT_REQUEST) ? 1'b1: 1'b0) :1'bz;

    // drive wrt_data & WE only during these 2 states of WRT
      assign wrt_data = we &&  programming ?  packet_buffer :{`DATA_WIDTH{1'bz}};
      assign addr =( programming==1'b1) ? prog_addr: {`ADDR_WIDTH{1'bz}};
      assign   we = (Present_state== WRT_REQUEST)  ? 1'b1:1'bz;


        //after a successful write ,reset the packet valid status

         assign rst_packet_v = rst | data_valid;


    // drive the data valid and packet data during the READ complete

      assign arbiter_data_valid  = (( Present_state==RD_DATA && packet_buffer_v)? 1'b1 :1'b0);
      assign rd_data = packet_buffer;

      //detect the end of programming and reset the address for programming
      assign programming_negedge = programming_ff & !programming ;





//address logic
//address will be driven only during the programming
//pahse of the block
        always@(posedge clk )
         begin
              if(rst || programming_negedge)
                prog_addr <=0 ;
            else if((Present_state==WRT_REQUEST) && data_valid)
              prog_addr<=prog_addr+1;
         end

       //internal to external net


  endmodule

