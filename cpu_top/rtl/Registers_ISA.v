// this is the primary register file containing all the architectural registers
// and the read /write logic associated with it 
// We want a register file with 2 read and 1 write port with it 
// 2 for reading 2 source operand and 1 for writing 
// if there is any conflict between read and write  , we can prioritize write
// first stalling the decoder and subsequently the pipeline  for 1 cyle 
// We design this registers of 32 x32 as a FF based design becuase of speed 
// we cannot match the speed with such a 3 port register file . the area it
// save is not worth it considering the speed and power tradeoffs
//*********************************** 
//Another invalidaiton port will be required to invalidate an register when it
//is a destination register for the instruction. It will be written one cycle
//later the source operand read in order to avoild the read write conflict 
//for a:a+15 kind of instructions 
//Plese note invalidation will only work on the valid bit array 
//***************************************
`timescale 1ns / 1ps
`include "register_defines.vh"
`include "Macros.vh"
module ArchRegistersInt(

	input clk ,
	input reset ,

        //p0 read port1 
	input[4:0] addr_p0,
	input re_p0,
	output[31:0] dout_p0,
	output v_p0,
        //p1 read port2
	input[4:0] addr_p1,
        input re_p1,
        output[31:0] dout_p1,
	output v_p1, 
       //p2 WB port 
         input[4:0] addr_p2,
	 input we_p2,
	 input[31:0] din_p2,
	//Pi , invalidation port
	input we_pi,
	input[4:0] addr_pi,
	input uop_valid,  

	 output source_not_ready 
 );

    // registers :
   reg[31:0] zero,ra,sp,gp,tp,t0,t1,t2,t3,t4,t5,t6,s0,s1;
   reg[31:0] a0,a1,a2,a3,a4,a5,a6,a7,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11;
   reg[31:0] dout_p0_reg ,dout_p1_reg;
   reg re_p0_reg, re_p1_reg;

   //registers valid array
   reg[31:0] V_array ; 
   reg v_p0_reg,v_p1_reg;
   reg uop_valid_out;
 
   wire re_p0_conflict,re_p1_conflict,we_p2_reg;
   wire ReadP0Conflict,ReadP1Conflict;

   //conflict detector 
  assign ReadP0Conflict=(addr_p0==addr_p2) & re_p0 & we_p2;
  assign ReadP1Conflict =(addr_p1==addr_p2) & re_p1 & we_p2;

   assign re_p0_conflict = ReadP0Conflict ? 1'b0:re_p0;
   assign re_p1_conflict =  ReadP1Conflict  ? 1'b0:re_p1;
   assign ReadWriteConflict= ReadP0Conflict | ReadP1Conflict ;

   //behavioral design (may need to code it structurally in order to meet
   //timing 

   always@(posedge clk)
   begin 
     if(reset)
     begin 
        zero=0;ra=0;sp=0;gp=0;tp=0;t0=0;t1=0;t2=0;t3=0;t4=0;t5=0;t6=0;s0=0;s1=0; dout_p0_reg=0; dout_p1_reg=0;
	a0=0;a1=0;a2=0;a3=0;a4=0;a5=0;a6=0;a7=0;s2=0;s3=0;s4=0;s5=0;s6=0;s7=0;s8=0;s9=0;s10=0;s11=0;
        re_p0_reg=1'b0; re_p1_reg=1'b0; uop_valid_out=1'b0;
      end 
     
       //need to flop the enable for cycle accurate computation 
        re_p0_reg=re_p0;
        re_p1_reg=re_p1; 
    
 
      if(re_p0_conflict) // decoder for p0
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
      if(re_p1_conflict) 
      begin 
          case(addr_p1)
	    `zero: dout_p1_reg =zero;
             `ra:   dout_p1_reg=ra ;
              `sp:   dout_p1_reg = sp;
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
          //Read Wrire port conflict handling 
   end 

      // data forwarding 
     if(ReadP0Conflict)
      	dout_p0_reg=din_p2;
    if(ReadP1Conflict)
      	dout_p1_reg=din_p2;
	

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

   //valid array 

  always@(posedge clk)
  begin 
     if(reset)
     begin
           //initializing the registers with zero 
           //Other wise pipeline will stall  

	    V_array=32'hFFFFFFFF;    
    end 
     //p0 read valid array
     if(re_p0_conflict)
     begin
	    v_p0_reg=V_array[addr_p0];
     end 
        else begin  v_p0_reg=1'b0; end 
     //p1 read valid array

      if(re_p1_conflict)
     begin
	    v_p1_reg=V_array[addr_p1];
     end 
    
     else begin  v_p1_reg=1'b0; end

    //write port conflict with invalidation 
    if(addr_pi==addr_p2 & we_p2 & we_pi) 
    begin 
       V_array[addr_pi]=1'b0; 
      //incase of a conflict , invalidation gets prioriry as 
      //there is no consumer of that WB data ,think of a case and 
      //document it  
       end 

       else begin 

      if(we_p2)
      begin 
        V_array[addr_p2]=1'b1;
      end 
     //invalidation 
      if(we_pi)  
      begin 
          V_array[addr_pi]=1'b0;
       end 
     end 
  end //always block for valid array 

   //need to flop the enable for cycle accurate computation 
  // Macros not working properly ,need to check in other simulators 
  // `POS_EDGE_FF(clk,reset,re_p0,re_p0_reg)
 
   `POS_EDGE_FF(clk,reset,uop_valid,uop_valid_out) 


  


//  assign dout_p0 =ReadP0Conflict ? din_p2:dout_p0_reg;  // data forwarding in case of write back on the same register 
//  assign dout_p1 =ReadP1Conflict? din_p2:dout_p1_reg;
  assign dout_p0 =dout_p0_reg;  
  assign dout_p1 =dout_p1_reg;
  assign v_p0=ReadP0Conflict ? 1'b1:v_p0_reg;
  assign v_p1=ReadP1Conflict? 1'b1:v_p1_reg;
  assign source_not_ready = ((re_p0_reg ^ v_p0 )  | (re_p1_reg ^ v_p1 )) & uop_valid_out ;  // if any of source operands are not ready  



  endmodule 



	
