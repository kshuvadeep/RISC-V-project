`include "system_param.vh"
//***************************************************************
//  T e s t c a s e : load store code modified Uart
//***************************************************************

initial begin 
// lui x6,0x00010000 2 li t1 ,0x10000000 # first write , t1 holds the address and t2 holds the data
Mem[0] = 8'h37;
Mem[1] = 8'h03;
Mem[2] = 8'h00;
Mem[3] = 8'h10;

// addi x6,x6,0
Mem[4] = 8'h13;
Mem[5] = 8'h03;
Mem[6] = 8'h03;
Mem[7] = 8'h00;

// addi x7,x0,14 3 li t2 , 14
Mem[8] = 8'h93;
Mem[9] = 8'h03;
Mem[10] = 8'he0;
Mem[11] = 8'h00;

// sb x7,0(x6) 4 sb t2 ,(t1)
Mem[12] = 8'h23;
Mem[13] = 8'h00;
Mem[14] = 8'h73;
Mem[15] = 8'h00;

// lui x28,0x00010000 7 li t3 ,0x10000000 # first write , t1 holds the address and t2 holds the data
Mem[16] = 8'h37;
Mem[17] = 8'h0e;
Mem[18] = 8'h00;
Mem[19] = 8'h10;

// addi x28,x28,0
Mem[20] = 8'h13;
Mem[21] = 8'h0e;
Mem[22] = 8'h0e;
Mem[23] = 8'h00;

// addi x7,x0,23 8 li t2 , 23
Mem[24] = 8'h93;
Mem[25] = 8'h03;
Mem[26] = 8'h70;
Mem[27] = 8'h01;

// sb x7,0(x28) 9 sb t2 ,(t3)
Mem[28] = 8'h23;
Mem[29] = 8'h00;
Mem[30] = 8'h7e;
Mem[31] = 8'h00;

// lb x29,0(x6) 11 lb t4 , (t1) # load from address 20
Mem[32] = 8'h83;
Mem[33] = 8'h0e;
Mem[34] = 8'h03;
Mem[35] = 8'h00;


for(i=36; i<64; i=i+1) begin
    Mem[i] = i;  // Fill up to specified depth
end
end
