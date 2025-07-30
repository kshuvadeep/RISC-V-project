`include "system_param.vh"
//***************************************************************
//  T e s t c a s e : code to send hello via uart
//***************************************************************

initial begin 
// addi x29,x0,1 5 li t4 ,1
Mem[0] = 8'h93;
Mem[1] = 8'h0e;
Mem[2] = 8'h10;
Mem[3] = 8'h00;

// addi x7,x0,31 6 li t2 ,31
Mem[4] = 8'h93;
Mem[5] = 8'h03;
Mem[6] = 8'hf0;
Mem[7] = 8'h01;

// sll x28,x29,x7 7 sll t3 ,t4 , t2
Mem[8] = 8'h33;
Mem[9] = 8'h9e;
Mem[10] = 8'h7e;
Mem[11] = 8'h00;

// addi x6,x0,0x00000068 9 li t1 ,0x68 #h
Mem[12] = 8'h13;
Mem[13] = 8'h03;
Mem[14] = 8'h80;
Mem[15] = 8'h06;

// sb x6,0(x28) 10 sb t1 ,(t3)
Mem[16] = 8'h23;
Mem[17] = 8'h00;
Mem[18] = 8'h6e;
Mem[19] = 8'h00;

// addi x6,x0,0x00000065 11 li t1 ,0x65 #e
Mem[20] = 8'h13;
Mem[21] = 8'h03;
Mem[22] = 8'h50;
Mem[23] = 8'h06;

// sb x6,0(x28) 12 sb t1 ,(t3)
Mem[24] = 8'h23;
Mem[25] = 8'h00;
Mem[26] = 8'h6e;
Mem[27] = 8'h00;

// addi x6,x0,0x0000006c 13 li t1 ,0x6c #l
Mem[28] = 8'h13;
Mem[29] = 8'h03;
Mem[30] = 8'hc0;
Mem[31] = 8'h06;

// sb x6,0(x28) 14 sb t1 ,(t3)
Mem[32] = 8'h23;
Mem[33] = 8'h00;
Mem[34] = 8'h6e;
Mem[35] = 8'h00;

// addi x6,x0,0x0000006c 15 li t1 ,0x6c #l
Mem[36] = 8'h13;
Mem[37] = 8'h03;
Mem[38] = 8'hc0;
Mem[39] = 8'h06;

// sb x6,0(x28) 16 sb t1 ,(t3)
Mem[40] = 8'h23;
Mem[41] = 8'h00;
Mem[42] = 8'h6e;
Mem[43] = 8'h00;

// addi x6,x0,0x0000006f 17 li t1 ,0x6F #o
Mem[44] = 8'h13;
Mem[45] = 8'h03;
Mem[46] = 8'hf0;
Mem[47] = 8'h06;

// sb x6,0(x28) 18 sb t1 ,(t3)
Mem[48] = 8'h23;
Mem[49] = 8'h00;
Mem[50] = 8'h6e;
Mem[51] = 8'h00;

// addi x6,x0,10 19 li t1 ,0x0a #\n
Mem[52] = 8'h13;
Mem[53] = 8'h03;
Mem[54] = 8'ha0;
Mem[55] = 8'h00;

// sb x6,0(x28) 20 sb t1 ,(t3)
Mem[56] = 8'h23;
Mem[57] = 8'h00;
Mem[58] = 8'h6e;
Mem[59] = 8'h00;


for(i=60; i<64; i=i+1) begin
    Mem[i] = 0;  // Fill up to specified depth
end
end
