`include "system_param.vh"
//***************************************************************
//  T e s t c a s e : shift unit code
//***************************************************************

initial begin 
// addi x6,x0,1 2 li t1 ,1
Mem[0] = 8'h13;
Mem[1] = 8'h03;
Mem[2] = 8'h10;
Mem[3] = 8'h00;

// addi x7,x0,31 3 li t2 ,31
Mem[4] = 8'h93;
Mem[5] = 8'h03;
Mem[6] = 8'hf0;
Mem[7] = 8'h01;

// sll x28,x6,x7 4 sll t3 ,t1 , t2
Mem[8] = 8'h33;
Mem[9] = 8'h1e;
Mem[10] = 8'h73;
Mem[11] = 8'h00;

// srli x29,x28,4 5 srli t4 ,t3 , 4
Mem[12] = 8'h93;
Mem[13] = 8'h5e;
Mem[14] = 8'h4e;
Mem[15] = 8'h00;


for(i=16; i<64; i=i+1) begin
    Mem[i] = i;  // Fill up to specified depth
end
end
