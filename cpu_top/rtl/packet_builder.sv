//************************************
//module :packet builder
//As the moudle name implies
//This module simply collects
//the byte and output a packet
//based on the packet size




module packet_builder #( parameter NUM_BYTE=4)
       (  input clk ,
          input rst,
         input[7:0] data_byte,
         input data_byte_valid,
         output reg [ NUM_BYTE*8-1:0] packet_data,
         output reg packet_valid
     );


     localparam COUNT_WIDTH= $clog2(NUM_BYTE+1);
     reg [COUNT_WIDTH-1:0] count;

      always@(posedge clk )
        begin
            if(rst)
              begin
              packet_data<=0;
              count<=0;
              end
            else begin
               if(data_byte_valid)
                begin
                  count <= count+1;
//                  packet_data <={(packet_data<<4) ,data_byte };
                  packet_data <= { packet_data[NUM_BYTE*8-9:0],data_byte};

                 end
             end

            if(count==NUM_BYTE)
                 begin
                  count<=0;
                   packet_valid <=1'b1;
                  end
              else
                   packet_valid<=1'b0 ;
          end  //always block

endmodule

