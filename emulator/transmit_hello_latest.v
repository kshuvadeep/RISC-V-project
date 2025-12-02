`include "system_param.vh"
//***************************************************************
//  T e s t c a s e : code to send hello via uart
//***************************************************************

initial begin

// addi x29,x0,1   ; li t4,1
Mem[0]  = 32'h00100e93;

// addi x7,x0,31   ; li t2,31
Mem[1]  = 32'h01f00393;

// sll x28,x29,x7  ; sll t3,t4,t2
Mem[2]  = 32'h007e9e33;

// addi x6,x0,0x68 ; li t1,0x68  # h
Mem[3]  = 32'h06800313;

// sb x6,0(x28)    ; sb t1,(t3)
Mem[4]  = 32'h006e0023;

// addi x6,x0,0x65 ; li t1,0x65  # e
Mem[5]  = 32'h06500313;

// sb x6,0(x28)    ; sb t1,(t3)
Mem[6]  = 32'h006e0023;

// addi x6,x0,0x6c ; li t1,0x6c  # l
Mem[7]  = 32'h06c00313;

// sb x6,0(x28)
Mem[8]  = 32'h006e0023;

// addi x6,x0,0x6c ; li t1,0x6c  # l
Mem[9]  = 32'h06c00313;

// sb x6,0(x28)
Mem[10] = 32'h006e0023;

// addi x6,x0,0x6f ; li t1,0x6F  # o
Mem[11] = 32'h06f00313;

// sb x6,0(x28)
Mem[12] = 32'h006e0023;

// addi x6,x0,10   ; li t1,0x0a  # \n
Mem[13] = 32'h00a00313;

// sb x6,0(x28)
Mem[14] = 32'h006e0023;

// padding
Mem[15] = 32'h00000000;



for(i=16; i<64; i=i+1) begin
    Mem[i] =0;  // Fill up to specified depth
end
end
