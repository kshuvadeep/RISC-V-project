//*******************************************
//6th august :2024 : RiSk free corporation 
//This is first code for the execution unit 
//We implement the control paths and datapath for 
//execution units in this module  
//Individual execution units are described in their 
//respective modules instantiated here .
//******************************************

//***********************************************************
//Execution Stage is a 2 stage deep pipeline 
//where first stages Exe01 deocdes the pre decoded information 
//from the decoder stage and generates control paths that 
//control the individual execution units like adder ,shifter ,
//logical operators , load/store operator and so on . 
//Second stage Exe02 is dedicated for the data paths ,where 
//executions are executed and result is sent to Write back stage 
//****************************************************************

//*******************************************
//Register Naming convention 
// SRC1_ADDER_EXE01 : defines the source of adder unit and EXEO1 
// denotes that it captures the signals that belong to stage 1 of the 
// pipeline 

`define DATA_WIDTH 32 


module execution(

     input[6:0] instruction_type,
      input[2:0] funct3,
      input[6:0] funct7,
      input[20:0] immediate ,
      input system_stall,
      input[`DATA_WIDTH-1:0] data_src1,
      input[`DATA_WIDTH-1:0]  data_src2,
      //outputs 
      output[`DATA_WIDTH-1:0] Execution_Result,
      output [`ADDR_WIDTH-1:0] Mem_addr,
      output uop_is_mem ,
      //
      input clk ,
      input reset 
      );



      //Registers
      //

      
      
       



       
     
      

      

	
