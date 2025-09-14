module lcd_driver (
    input wire clk,               // Clock input
    input data_v,                  // Data valid 
    input[7:0]  data,               // Data from Uart Rx 
    output reg lcd_e,             // LCD enable control
    output reg lcd_rs,            // Register select: 0 = command, 1 = data
    output reg [7:0] dout         // 8-bit data output to LCD
 
);

    // Parameters
    parameter N = 22;
    reg[7:0] wrt_ptr=6;

    // ROM holding LCD command and data
    reg [7:0] datas [1:N];
    initial begin
        datas[1]  = 8'h38; // Function set
        datas[2]  = 8'h0C; // Display ON, cursor OFF
        datas[3]  = 8'h06; // Entry mode set
        datas[4]  = 8'h01; // Clear display
        datas[5]  = 8'hC0; // Set DDRAM address to 2nd line
        datas[6]  = 8'h31; // Data: '1'
        datas[7]  = 8'h32; // Data: '2'
        datas[8]  = 8'h33; // Data: '3'
        datas[9]  = 8'h34; // Data: '4'
        datas[10] = 8'h35; // Data: '5'
        datas[11] = 8'h36; // Data: '6'
        datas[12] = 8'h37; // Data: '7'
        datas[13] = 8'h38; // Data: '8'
        datas[14] = 8'h39; // Data: '9'
        datas[15] = 8'h41; // Data: 'A'
        datas[16] = 8'h42; // Data: 'B'
        datas[17] = 8'h43; // Data: 'C'
        datas[18] = 8'h44; // Data: 'D'
        datas[19] = 8'h45; // Data: 'E'
        datas[20] = 8'h46; // Data: 'F'
        datas[21] = 8'h47; // Data: 'G'
        datas[22] = 8'h48; // Data: 'H'
    end

     always@(posedge clk )
      begin 
        if(data_v)
          begin
          datas[wrt_ptr] <=data;
          wrt_ptr<=wrt_ptr+1;
          end 
        if(wrt_ptr==22)
           wrt_ptr<=6;
      end 


    // Internal counters
    integer i = 0;  // Clock cycle counter
    integer j = 1;  // Index for datas array

    always @(posedge clk) begin
        if (i <= 1_000_000) begin
            i <= i + 1;
            lcd_e <= 1'b1;               // Pulse LCD enable HIGH
            dout <= datas[j];           // Output data/command
        end
        else if (i > 1_000_000 && i < 2_000_000) begin
            i <= i + 1;
            lcd_e <= 1'b0;              // Pulse LCD enable LOW
        end
        else if (i == 2_000_000) begin
            j <= j + 1;
            i <= 0;
        end

        // Determine if it's command or data
        if (j <= 5)
            lcd_rs <= 1'b0;             // Commands
        else
            lcd_rs <= 1'b1;             // Data

        // Loop back the data output from 6th element after all data sent
        if (j == 22)
            j <= 5;
    end

endmodule
