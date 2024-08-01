// this is the primary register file containing all the architectural registers
// and the read /write logic associated with it 
// We want a register file with 2 read and 1 write port with it 
// 2 for reading 2 source operand and 1 for writing 
// if there is any conflict between read and write  , we can prioritize write
// first stalling the decoder and subsequently the pipeline  for 1 cyle 
// We design this registers of 32 x32 as a FF based design becuase of speed 
// we cannot match the speed with such a 3 port register file . the area it
// save is not worth it considering the speed and power tradeoffs 
//
`include "register_defines.vh"
module ArchRegistersInt(

	input clk ,
	input reset ,

        //p0 
	input[4:0] addr_p0,
	input re_p0,
	output[31:0] dout_p0,
        //p1 
	input[4:0] addr_p1,
        input re_p1,
        output[31:0] dout_p1,
       //p2
         input[4:0] addr_p2,
	 input we_p2,
	 input[31:0] din_p2
 );

    // registers 
   reg[31:0] zero,ra,sp,gp,tp,t0,t1,t2,t3,t4,t5,t6,s0,s1;
   reg[31:0] a0,a1,a2,a3,a4,a5,a6,a7,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11;
   reg[31:0] dout_p0_reg ,dout_p1_reg;
 
   wire re_p0_reg,re_p1_reg,we_p2_reg;

   //conflict detector 

   assign re_p0_reg = (addr_p0==addr_p2) ? 1'b0:re_p0;
   assign re_p1_reg = (addr_p1==addr_p2) ? 1'b0:re_p1;



   //behavioral design (may need to code it structurally in order to meet
   //timing 

   always@(posedge clk)
   begin 
     if(reset)
     begin 
        zero=0;ra=0;sp=0;gp=0;tp=0;t0=0;t1=0;t2=0;t3=0;t4=0;t5=0;t6=0;s0=0;s1=0; dout_p0_reg=0; dout_p1_reg=0;
	a0=0;a1=0;a2=0;a3=0;a4=0;a5=0;a6=0;a7=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;s8=0;s9=0;s10=0;s11=0;
      end 
      
      if(re_p0_reg) // decoder for p0
      begin 
          case(addr_p0)
	    `zero: dout_p0_reg =zero;
            `ra:   dout_p0_reg=ra ;
              `sp:   dout_p0_reg = sp;
               `gp:   dout_p0_reg = gp;
                `tp:   dout_p0_reg = tp;
                `t0:   dout_p0_reg = t0;
                `t1:   dout_p0_reg = t1;
                `t2:   dout_p0_reg = t2;
                `s0:   dout_p0_reg = s0;
                `s1:   dout_p0_reg = s1;
                `a0:   dout_p0_reg = a0;
                `a1:   dout_p0_reg = a1;
                `a2:   dout_p0_reg = a2;
                `a3:   dout_p0_reg = a3;
                `a4:   dout_p0_reg = a4;
                `a5:   dout_p0_reg = a5;
                `a6:   dout_p0_reg = a6;
                `a7:   dout_p0_reg = a7;
                `s2:   dout_p0_reg = s2;
                `s3:   dout_p0_reg = s3;
                `s4:   dout_p0_reg = s4;
                `s5:   dout_p0_reg = s5;
                `s6:   dout_p0_reg = s6;
                `s7:   dout_p0_reg = s7;
                `s8:   dout_p0_reg = s8;
                `s9:   dout_p0_reg = s9;
                `s10:  dout_p0_reg = s10;
                `s11:  dout_p0_reg = s11;
                `t3:   dout_p0_reg = t3;
                `t4:   dout_p0_reg = t4;
                `t5:   dout_p0_reg = t5;
                `t6:   dout_p0_reg = t6;
                default: dout_p0_reg = 32'h00000000;  // Default case	  
	endcase 
   end 	

   // decoder for p1 
      if(re_p1_reg) 
      begin 
          case(addr_p1)
	    `zero: dout_p1_reg =zero;
             `ra:   dout_p1_reg=ra ;
              `sp:   dout_p1_reg = sp;
                `gp:   dout_p1_reg = gp;
                `gp:   dout_p1_reg = gp;
                `tp:   dout_p1_reg = tp;
                `t0:   dout_p1_reg = t0;
                `t1:   dout_p1_reg = t1;
                `t2:   dout_p1_reg = t2;
                `s0:   dout_p1_reg = s0;
                `s1:   dout_p1_reg = s1;
                `a0:   dout_p1_reg = a0;
                `a1:   dout_p1_reg = a1;
                `a2:   dout_p1_reg = a2;
                `a3:   dout_p1_reg = a3;
                `a4:   dout_p1_reg = a4;
                `a5:   dout_p1_reg = a5;
                `a6:   dout_p1_reg = a6;
                `a7:   dout_p1_reg = a7;
                `s2:   dout_p1_reg = s2;
                `s3:   dout_p1_reg = s3;
                `s4:   dout_p1_reg = s4;
                `s5:   dout_p1_reg = s5;
                `s6:   dout_p1_reg = s6;
                `s7:   dout_p1_reg = s7;
                `s8:   dout_p1_reg = s8;
                `s9:   dout_p1_reg = s9;
               `s10:  dout_p1_reg = s10;
                `s11:  dout_p1_reg = s11;
                `t3:   dout_p1_reg = t3;
                `t4:   dout_p1_reg = t4;
                `t5:   dout_p1_reg = t5;
                `t6:   dout_p1_reg = t6;
                default: dout_p1_reg = 32'h00000000;  // Default case	  
	endcase 
   end 	

     if(we_p2)
      begin
         case(addr_p2) 
        `zero :zero=din_p2;
         `ra:   ra = din_p2;
        `sp:   sp = din_p2;
        `gp:   gp = din_p2;
        `tp:   tp = din_p2;
        `t0:   t0 = din_p2;
        `t1:   t1 = din_p2;
        `t2:   t2 = din_p2;
        `s0:   s0 = din_p2;
        `s1:   s1 = din_p2;
        `a0:   a0 = din_p2;
        `a1:   a1 = din_p2;
        `a2:   a2 = din_p2;
        `a3:   a3 = din_p2;
        `a4:   a4 = din_p2;
        `a5:   a5 = din_p2;
        `a6:   a6 = din_p2;
        `a7:   a7 = din_p2;
        `s2:   s2 = din_p2;
        `s3:   s3 = din_p2;
        `s4:   s4 = din_p2;
        `s5:   s5 = din_p2;
        `s6:   s6 = din_p2;
        `s7:   s7 = din_p2;
        `s8:   s8 = din_p2;
        `s9:   s9 = din_p2;
        `s10:  s10 = din_p2;
        `s11:  s11 = din_p2;
        `t3:   t3 = din_p2;
        `t4:   t4 = din_p2;
        `t5:   t5 = din_p2;
        `t6:   t6 = din_p2;
          // Default case can be added if needed
    endcase
   end
        
  end // always block 



  assign dout_p0=dout_p0_reg;
  assign dout_p1 =dout_p1_reg;


  endmodule 



	
