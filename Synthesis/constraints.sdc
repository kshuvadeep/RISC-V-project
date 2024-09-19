
create_clock -name clk -period 20.0 [get_ports clk]
set_input_delay 1.0 -clock clk [get_ports {reset }]
