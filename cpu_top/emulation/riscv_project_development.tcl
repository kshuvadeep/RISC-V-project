# Create a new project
create_project -force  RISC_V_latest /home/shuvadeep/Documents/Work/Xillinx_projects/RISC-V/  -part  xc7a35tftg256-1 

# Add source files


add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Soc.v
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//register_defines.vh
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//rvi32_instructions.vh
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Registers_ISA.v
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Execution_param.vh
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Decode.v
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Mem_top.v
add_files  /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//execution.sv
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//system_param.vh
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//logical_unit.v
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Fetch.v
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Alu_ctrl.v
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Adder_int.v
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//WriteBack.v
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//cpu_top.v
add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Macros.vh 
add_files  /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//branch_computation_unit.sv  
add_files  /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//sign_extended_right_shift.v
add_files  /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Arbiter.v
add_files  /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Mmu_unit.v
add_files  /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Mmu_param.vh
add_files  /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Uart_module.v
add_files  /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Uart_tx.v
add_files  /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl//Fifo.v


# Add the testbench
add_files  /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl//soc_tb.sv -fileset sim_1

# Set the top module for simulation
set_property top soc_tb [get_filesets sim_1]


# Add the testbench
add_files  /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl//soc_tb.sv -fileset sim_1

# Add the constraints 

add_files /home/shuvadeep/Documents/Work/RISC_V/cpu_top/emulation/Soc.xdc -fileset constrs_1

# Set the top module for simulation
set_property top soc_tb [get_filesets sim_1]
# Launch the simulation (without GUI)
#launch_simulation -mode behavioral

start_gui 

#set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs synth_1]
#
## Set opt_design disabled
#set_property STEPS.OPT_DESIGN.IS_ENABLED false [get_runs impl_1]
#
## Launch synthesis and wait
#launch_runs synth_1 -jobs 4
#wait_on_run synth_1
#
## Launch implementation and wait
#launch_runs impl_1 -to_step write_bitstream -jobs 4
#wait_on_run impl_1
#
## Optionally: write reports or bitstream path
#puts "Bitstream generated at: [get_property BITSTREAM.FILE [get_runs impl_1]]"
start_gui 


