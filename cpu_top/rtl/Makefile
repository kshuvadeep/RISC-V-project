TOPLEVEL_LANG = verilog
TOPLEVEL = soc_tb
MODULE = soc_test
SIM = verilator

RTL_PATH = /home/shuvadeep/Documents/Work/RISC_V/cpu_top/rtl/latest_rtl

VERILOG_SOURCES = \
  $(RTL_PATH)/Adder_int.v \
  $(RTL_PATH)/Alu_ctrl.v \
  $(RTL_PATH)/Arbiter.v \
  $(RTL_PATH)/branch_computation_unit.sv \
  $(RTL_PATH)/cpu_top.v \
  $(RTL_PATH)/Decode.v \
  $(RTL_PATH)/Execution_param.vh \
  $(RTL_PATH)/execution.sv \
  $(RTL_PATH)/Fetch.v \
  $(RTL_PATH)/Fifo.v \
  $(RTL_PATH)/logical_unit.v \
  $(RTL_PATH)/Macros.vh \
  $(RTL_PATH)/Mem_top.v \
  $(RTL_PATH)/Mmu_param.vh \
  $(RTL_PATH)/Mmu_unit.v \
  $(RTL_PATH)/register_defines.vh \
  $(RTL_PATH)/Registers_ISA.v \
  $(RTL_PATH)/rvi32_instructions.vh \
  $(RTL_PATH)/shifter.sv \
  $(RTL_PATH)/sign_extended_right_shift.v \
  $(RTL_PATH)/soc_tb.sv \
  $(RTL_PATH)/Soc.v \
  $(RTL_PATH)/system_param.vh \
  $(RTL_PATH)/Uart_module_latest.v \
  $(RTL_PATH)/Uart_tx.v \
  $(RTL_PATH)/Uart_rx.v \
  $(RTL_PATH)/lcd_driver.v \
  $(RTL_PATH)/WriteBack.v

VERILATOR_FLAGS += --trace --trace-structs
VERILATOR_FLAGS += -I$(RTL_PATH) 
EXTRA_ARGS += -I$(RTL_PATH) -Wno-fatal 
VERILATOR_FLAGS += -Wno-fatal
VERILATOR_FLAGS += --max-num-warnings 1000
VERILATOR_FLAGS += --no-timing
VERILATOR_FLAGS += -std=c++20
EXTRA_ARGS += --trace
CXXFLAGS += -std=c++20 -fcoroutines

WAVES=1

include $(shell cocotb-config --makefiles)/Makefile.sim

