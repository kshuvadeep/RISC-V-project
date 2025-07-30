`include "system_param.vh"
//***************************************************************
//  T e s t c a s e : load store code uart
//***************************************************************

initial begin 
// addi x6,x0,1 4 li t1 ,1
Mem[0] = 8'h13;
Mem[1] = 8'h03;
Mem[2] = 8'h10;
Mem[3] = 8'h00;

// addi x7,x0,31 5 li t2 ,31
Mem[4] = 8'h93;
Mem[5] = 8'h03;
Mem[6] = 8'hf0;
Mem[7] = 8'h01;

// sll x28,x6,x7 6 sll t3 ,t1 , t2
Mem[8] = 8'h33;
Mem[9] = 8'h1e;
Mem[10] = 8'h73;
Mem[11] = 8'h00;

// addi x6,x0,23 8 li t1 ,23
Mem[12] = 8'h13;
Mem[13] = 8'h03;
Mem[14] = 8'h70;
Mem[15] = 8'h01;

// sb x6,0(x28) 9 sb t1 ,(t3)
Mem[16] = 8'h23;
Mem[17] = 8'h00;
Mem[18] = 8'h6e;
Mem[19] = 8'h00;

// addi x29,x0,0x0000002d 13 li t4 , 45
Mem[20] = 8'h93;
Mem[21] = 8'h0e;
Mem[22] = 8'hd0;
Mem[23] = 8'h02;

// sb x29,0(x28) 14 sb t4 ,(t3)
Mem[24] = 8'h23;
Mem[25] = 8'h00;
Mem[26] = 8'hde;
Mem[27] = 8'h01;


for(i=28; i<64; i=i+1) begin
    Mem[i] = i;  // Fill up to specified depth
end
end
