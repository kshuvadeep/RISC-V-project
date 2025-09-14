set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS33} [get_ports clk]
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS33} [get_ports reset]
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports txd]
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports rxd]






create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports clk]



set_property -dict { PACKAGE_PIN P3 IOSTANDARD LVCMOS33 } [get_ports {lcd_dout[7]}];
set_property -dict { PACKAGE_PIN M5 IOSTANDARD LVCMOS33 } [get_ports {lcd_dout[6]}];
set_property -dict { PACKAGE_PIN N4 IOSTANDARD LVCMOS33 } [get_ports {lcd_dout[5]}];
set_property -dict { PACKAGE_PIN R2 IOSTANDARD LVCMOS33 } [get_ports {lcd_dout[4]}];
set_property -dict { PACKAGE_PIN R1 IOSTANDARD LVCMOS33 } [get_ports {lcd_dout[3]}];
set_property -dict { PACKAGE_PIN R3 IOSTANDARD LVCMOS33 } [get_ports {lcd_dout[2]}];
set_property -dict { PACKAGE_PIN T2 IOSTANDARD LVCMOS33 } [get_ports {lcd_dout[1]}];
set_property -dict { PACKAGE_PIN T4 IOSTANDARD LVCMOS33 } [get_ports {lcd_dout[0]}];
set_property -dict { PACKAGE_PIN T3 IOSTANDARD LVCMOS33 } [get_ports {lcd_e}];
set_property -dict { PACKAGE_PIN P5 IOSTANDARD LVCMOS33 } [get_ports {lcd_rs}];


set_property DONT_TOUCH true [get_nets uop_valid_out]
set_property DONT_TOUCH true [get_nets source_not_ready] 
set_property DONT_TOUCH true [get_cells source_not_ready_INST_0]
set_property DONT_TOUCH true [get_cells -hier -regexp {.*uop_valid_out.*}]
set_property DONT_TOUCH true [get_cells -hier -regexp {.*source_not_ready.*}]
