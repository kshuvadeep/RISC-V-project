
`include "register_defines.vh"
module ArchRegistersInt_tb;

// Inputs
reg clk;
reg reset;
reg [4:0] addr_p0;
reg re_p0;
wire [31:0] dout_p0;
reg [4:0] addr_p1;
reg re_p1;
wire [31:0] dout_p1;
reg [4:0] addr_p2;
reg we_p2;
reg [31:0] din_p2;

// Instantiate the Unit Under Test (UUT)
ArchRegistersInt uut (
    .clk(clk),
    .reset(reset),
    .addr_p0(addr_p0),
    .re_p0(re_p0),
    .dout_p0(dout_p0),
    .addr_p1(addr_p1),
    .re_p1(re_p1),
    .dout_p1(dout_p1),
    .addr_p2(addr_p2),
    .we_p2(we_p2),
    .din_p2(din_p2)
);

// Clock generation
always begin
  #10    clk = ~clk;
end

initial begin
    // Initialize Inputs
    clk=0;
    reset = 1;
    addr_p0 = 0;
    re_p0 = 0;
    addr_p1 = 0;
    re_p1 = 0;
    addr_p2 = 0;
    we_p2 = 0;
    din_p2 = 0;

    // Apply reset
    #30;
    reset = 0;

    // Write to registers
    #15; addr_p2 = `ra; din_p2 = 32'hA5A5A5A5; we_p2 = 1;
    #20; we_p2 = 0;

    #20; addr_p2 = `sp; din_p2 = 32'h5A5A5A5A; we_p2 = 1;
    #20; we_p2 = 0;

    // Read from registers
    #20; addr_p0 = `ra; re_p0 = 1;addr_p2=0;
    #20; re_p0 = 0;

    #20; addr_p1 = `sp; re_p1 = 1;
    #20; re_p1 = 0;

    // Add more read and write operations as needed

    // Finish simulation
    #1000;
    $finish;
end

initial begin
    $monitor("Time=%0t, addr_p0=%0d, dout_p0=%h, addr_p1=%0d, dout_p1=%h, addr_p2=%0d, din_p2=%h, we_p2=%b",
             $time, addr_p0, dout_p0, addr_p1, dout_p1, addr_p2, din_p2, we_p2);


// Dump waveforms**

$dumpfile("waves.vcd");

$dumpvars(0, ArchRegistersInt_tb);
end

endmodule

