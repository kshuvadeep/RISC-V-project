set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS33} [get_ports clk]
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS33} [get_ports reset]
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports txd]
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports rxd]






create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports clk]
