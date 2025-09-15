import cocotb
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def basic_test(dut):
    dut.reset.value = 1
    dut.clk.value = 0
    await Timer(10, units='ns')
    dut.reset.value = 0
    #250 ms   
    sim_time=0.25 
    clock_per_sec=50000000   
    num_clock=int(sim_time*clock_per_sec)

    for i in range(num_clock):
        dut.clk.value = 1
        await Timer(10, units='ns')
        dut.clk.value = 0
        await Timer(10, units='ns')

   #  cocotb.log.info(f"Output byte: {dut.out_byte.value}")
