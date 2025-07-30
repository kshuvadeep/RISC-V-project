# Create a new project
create_project -force  RISC_V_latest_latest /home/shuvadeep/Documents/Work/Xillinx_projects/Xillinx_projects/RISC-V/  -part xc7a35tftg256-1 

# Add source files


add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Soc.v
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/register_defines.vh
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/rvi32_instructions.vh
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Registers_ISA.v
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Execution_param.vh
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Decode.v
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Mem_top.v
add_files  /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/execution.sv
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/system_param.vh
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/logical_unit.v
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Fetch.v
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Alu_ctrl.v
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Adder_int.v
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/WriteBack.v
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/cpu_top.v
add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Macros.vh 
add_files  /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/branch_computation_unit.sv  
add_files  /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/sign_extended_right_shift.v
add_files  /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Arbiter.v
add_files  /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Mmu_unit.v
add_files  /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Mmu_param.vh
add_files  /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Uart_module.v
add_files  /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Uart_tx.v
add_files  /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/Fifo.v


# Add the testbench
add_files  /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/rtl/soc_tb.sv -fileset sim_1

# Set the top module for simulation
set_property top soc_tb [get_filesets sim_1]



# Add the constraints 

#add_files /home/shuvadeep/Documents/Work/Xillinx_projects/RISC_V_latest/cpu_top/constrs/Soc.xdc -fileset constrs_1
start_gui 
# Set the top module for simulation
# Launch the simulation (without GUI)
#launch_simulation -mode behavioral




