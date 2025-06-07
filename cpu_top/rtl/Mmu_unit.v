//This is the design of the MMU unit inside risc v processor 
// Company: autoRisca 
// Author : CEO ,founder ,shuvadeep 
// Date :13/09/2024

`timescale 1ns/1ps 
`include "system_param.vh"
`include "Mmu_param.vh"
`include "Macros.vh" 
`define RESET 2'b00
`define TX 2'b01
`define RX 2'b10
`define WAIT 2'b11 


module Mmu(
  input clk ,
  input reset ,
  input uop_is_mem_load,
  input uop_is_mem_store,
  output reg mem_stall, 
  input grant , 
  input[`CTRL_MEM_WIDTH-1:0] ctrl_mem,
  input [`DATA_WIDTH -1:0] src1 ,
  input [`DATA_WIDTH -1:0] src2 ,
  input [`IMMEDIATE_WIDTH-1:0] immediate ,
  input uop_valid,
  //bus towards Instruction /Data memory arbiter 
  output reg [`ADDR_WIDTH-1:0] addr,
  input [`DATA_WIDTH-1:0] rd_data,
  output [`DATA_WIDTH-1:0] wrt_data,
  input data_valid ,
  output reg we,
  output reg req_valid ,
  output reg[`DATA_WIDTH-1:0] mem_result,
  output reg mem_op_completed 
 // output data from MMU unit
    
);
   localparam STATE_WIDTH=2;

  (* DONT_TOUCH = "true" *) wire uop_is_mem;
 
   reg[`ADDR_WIDTH-1:0] Mem_Address ,addr_reg;
   reg[STATE_WIDTH-1:0] PresentState , NextState;
   reg[`DATA_WIDTH-1:0] write_mem_data , write_data;
   reg req_valid_reg,we_reg ;
 // MMu unit will consist of a simple data cache 
// that probes the L1 core and sends out data in case of 
// a data hit
// currently i am designing a 4 x 4 set assosiative cache Memory 
// the Memory will consist of 1 tag and 1 data array 

 
 //************************************************************************************
 //   A  G  U       L   O  G  I  C 
 //**********************************************************************************

     assign uop_is_mem = (uop_is_mem_load | uop_is_mem_store ) & uop_valid;

   
   
       
     
    //************************************************************************************
      //TX & RX  S T A T E     M  A  C  H  I  N  E         L   O  G  I  C 
      //**********************************************************************************

    
     // In case of a Memory 


     always@(*)  //always comb 
        begin 
       
 
        if( reset)   
         begin 
            addr<=0; we <=0 ; req_valid<=0;
         end 
         else 
        begin 

            if(uop_is_mem)
             NextState <= `TX ;
          else 
       
          case(PresentState) 

	    
	   	    `RESET :  begin
             	             if(reset)
                              NextState<=`RESET;

                              req_valid<=1'b0;
                              
                           end   
                              
                                                              
		           
                      `TX:   begin 
                            if(grant) 
                              begin
			    	NextState <=`WAIT;
                              end 
                             else begin
                                NextState <= `TX;
                              end 

                             addr <= addr_reg;
                            we <= we_reg;
                           req_valid <=req_valid_reg;

  
 			    end 
		     `WAIT :  begin

                              if(data_valid)
                              begin
			      NextState <= `RX;
                              req_valid<=1'b0;
                              end 
                               else begin 
                                 NextState<=`WAIT;
                                 req_valid<=1'b1;
                               end
                               

                             end 

		    `RX : begin
                           NextState <=`RESET;
                          we <=1'b0;
                           req_valid<=1'b0;

		          end 
                          
                endcase

                      

                end 
             end // always block   

        `POS_EDGE_FF(clk,reset,NextState,PresentState) 


  //************************************************************************************
  // O U T P U T         L   O  G  I  C 
  //**********************************************************************************
 


           always@( posedge clk )
            begin
              if(reset)
        begin 
          we_reg <=0 ;
          req_valid_reg <=0;
          mem_op_completed <=0 ;
          addr_reg <=0 ;
          write_mem_data <=0;
          req_valid_reg<=1'b0;
         end 
 
              // load mem request   
              if(uop_is_mem_load & uop_valid )
               begin
                 
                 addr_reg <=  src1 + immediate;
                 req_valid_reg <=  1'b1;
                 we_reg <= 1'b0; 
                 
               end 
              else
               

               // STORE MEM REQUEST 

                if(uop_is_mem_store & uop_valid )
               begin
                 
                 addr_reg <= src1 + immediate;
                 req_valid_reg <=  1'b1;
                 we_reg  <= 1'b1;
                write_mem_data <= write_data ; 
                 
               end 

              else begin
                 req_valid_reg <=1'b0 ;
                 we_reg<=1'b0;
                  end 
  
              if(NextState == `RX)
              mem_op_completed <=1'b1;
            else 
             mem_op_completed <=1'b0;
             


        
    //    `POS_EDGE_FF(clk,reset,addr_reg,addr) 
    //    `POS_EDGE_FF(clk,reset,req_valid_reg,req_valid) 
    //    `POS_EDGE_FF(clk,reset,we_reg,we) 
       // `POS_EDGE_FF(clk,reset,write_mem_data_reg,write_mem_data) 
   


  //************************************************************************************
  // S T A L L        L   O  G  I  C 
  //**********************************************************************************
     
    if(reset)
        mem_stall <= 1'b0; 
    else if( uop_is_mem) 
         mem_stall <=1'b1 ;
    else if( NextState == `RX ) // WE receive the data or acknowledgement at this stage
        mem_stall <= 1'b0 ;

 end  

  //************************************************************************************
  // L O A D    &      S T O R E         L   O  G  I  C 
  //**********************************************************************************
         

     always@(*)
     begin 
      if(reset)
       begin 
       write_data <= 0;
       mem_result <=0 ;
      end 
    else begin 
       if(NextState==`RX)
      begin
           
     // L o A D      D E C O D E  L O G I C 
       case(ctrl_mem)
         `CTRL_LB : begin
                    mem_result <={{(`DATA_WIDTH-8){rd_data[7]}}, rd_data[7:0]};
                    end 
           `CTRL_LH : begin 
                      mem_result <= {{(`DATA_WIDTH-16){rd_data[15]}},rd_data[15:0]};
                      end 
           `CTRL_LW :begin 
                      mem_result <= rd_data;
                      end 
           `CTRL_LBU : begin 
                       mem_result <= {{(`DATA_WIDTH-8){1'b0}},rd_data[7:0]};
                      end 
           `CTRL_LHU : begin 
                      mem_result <= {{(`DATA_WIDTH-16){1'b0}},rd_data[15:0]};
                      end 
            default : begin 
                      mem_result <= 0;
                      end 
         endcase

       end 
    end 

     // S T O R E     D E C O D E  L O G I C 
       
       if(uop_is_mem_store & uop_valid  )
        begin
           case(ctrl_mem)
            
         `CTRL_SB : begin
                    write_data <= {{(`DATA_WIDTH-8){src2[7]}},src2[7:0]};  // write just the byte
                    end 
         `CTRL_SH :begin 
                    write_data <= {{(`DATA_WIDTH-8){src2[15]}},src2[15:0]}; // write half word 
                    end 
 
            
         `CTRL_SW :begin 
                    write_data <= src2;  // write the full word 
                    end 
           
	   default : write_data <= 0 ;
          endcase
        end // if (we && NextState == `TX)
   end // always block
          // inout logic handling for data bus 

     assign wrt_data = we ?  write_mem_data : {`DATA_WIDTH{1'b0}};

    // if there is no write request from MMU unit     
        //     assign data = we ?  write_mem_data : {`DATA_WIDTH{1'bz}};
        //    assign addr = addr_reg;
        //     assign we = we_reg;
        //     assign req_valid =req_valid_reg;
 endmodule  
