
module Uart_tx(

   
    
    
    input wire clk,        // Input clock signal
    input wire reset ,
    input [`DATA_WIDTH-1:0] data ,
    input tx_fifo_empty, 
    output reg rd_clk_tx,  //  This will remain low as long as the transmitter is sending data 
    output reg txd         // UART transmit data signal
);


// State machine for UART transmission using parameter definitions
parameter READY = 2'b00;
parameter START = 2'b01;
parameter STOP  = 2'b10;
parameter RESET = 2'b11;

reg [1:0] present_state = READY;  // State register

// Store the data to be transmitted
reg [`DATA_WIDTH-1:0] store;
reg busy;

// Clock generation for baud rate (9600 baud) using a counter
reg baud_clk;
integer baud_count = 0;

// Data to be transmitted ("Hello World!")

integer i = 0, j = 1;  // Variables to track bit transmission and string index

// Generate the baud clock (16x sampling rate for UART)
// For 9600 baud, the counter value = 50 x 10^6 / (16 * 9600) = 325



always @(posedge clk) begin
    if (baud_count == 325) begin
        baud_clk <= 1;
        baud_count <= 0;
    end else begin
        baud_count <= baud_count + 1;
        baud_clk <= 0;
    end
end

// State machine for UART transmission process
always @(posedge baud_clk) begin
    case (present_state)
        RESET: begin 
                 if(reset)
                  present_state<= RESET;
                 else 
                 if(!tx_fifo_empty)
                   present_state<=READY;
              end
                  
        READY: begin
              
             // Rd clk generation from fifo 
             if(i==0 )
              rd_clk_tx <=1'b1;
             else 
              rd_clk_tx<=1'b0;
              
            i = i + 1;
            if (i == 8 ) begin
                txd <= 0;  // Start bit
                busy <=1'b1; 
                i = 0;
                present_state <= START;
            end   // if !fifo_empty
          
            end

        START: begin
            i = i + 1;
            store <= data; // Load the next byte to transmit

            case (i)
                16:  txd <= store[0];  // Transmit bit 0
                32:  txd <= store[1];  // Transmit bit 1
                48:  txd <= store[2];  // Transmit bit 2
                64:  txd <= store[3];  // Transmit bit 3
                80:  txd <= store[4];  // Transmit bit 4
                96:  txd <= store[5];  // Transmit bit 5
                112: txd <= store[6];  // Transmit bit 6
                128: txd <= store[7];  // Transmit bit 7
                144: txd <= 1;         // Stop bit
                160: begin
                    i = 0;
                    present_state <= STOP;
                end
            endcase
        end

        STOP: begin
                  if(!tx_fifo_empty)
                   present_state <= READY;  // Prepare to transmit next byte
                  else 
                    present_state <=RESET;

                   busy<=1'b0;
                   i=0;
                
            end
    endcase
end

endmodule




