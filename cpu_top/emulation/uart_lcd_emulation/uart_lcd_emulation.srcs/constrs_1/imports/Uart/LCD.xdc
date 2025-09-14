set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports {dout[7]}]
set_property -dict {PACKAGE_PIN M5 IOSTANDARD LVCMOS33} [get_ports {dout[6]}]
set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS33} [get_ports {dout[5]}]
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {dout[4]}]
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports {dout[3]}]
set_property -dict {PACKAGE_PIN R3 IOSTANDARD LVCMOS33} [get_ports {dout[2]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {dout[1]}]
set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS33} [get_ports {dout[0]}]
set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports lcd_e]
set_property -dict {PACKAGE_PIN P5 IOSTANDARD LVCMOS33} [get_ports lcd_rs]
set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS33} [get_ports clk]
set_property -dict {PACKAGE_PIN D4 IOSTANDARD LVCMOS33} [get_ports rxd]





create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {dout_OBUF[0]} {dout_OBUF[1]} {dout_OBUF[2]} {dout_OBUF[3]} {dout_OBUF[4]} {dout_OBUF[5]} {dout_OBUF[6]} {dout_OBUF[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {MyLcdDriver/j[0]} {MyLcdDriver/j[1]} {MyLcdDriver/j[2]} {MyLcdDriver/j[3]} {MyLcdDriver/j[4]} {MyLcdDriver/j[5]} {MyLcdDriver/j[6]} {MyLcdDriver/j[7]} {MyLcdDriver/j[8]} {MyLcdDriver/j[9]} {MyLcdDriver/j[10]} {MyLcdDriver/j[11]} {MyLcdDriver/j[12]} {MyLcdDriver/j[13]} {MyLcdDriver/j[14]} {MyLcdDriver/j[15]} {MyLcdDriver/j[16]} {MyLcdDriver/j[17]} {MyLcdDriver/j[18]} {MyLcdDriver/j[19]} {MyLcdDriver/j[20]} {MyLcdDriver/j[21]} {MyLcdDriver/j[22]} {MyLcdDriver/j[23]} {MyLcdDriver/j[24]} {MyLcdDriver/j[25]} {MyLcdDriver/j[26]} {MyLcdDriver/j[27]} {MyLcdDriver/j[28]} {MyLcdDriver/j[29]} {MyLcdDriver/j[30]} {MyLcdDriver/j[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {MyLcdDriver/i_reg[0]} {MyLcdDriver/i_reg[1]} {MyLcdDriver/i_reg[2]} {MyLcdDriver/i_reg[3]} {MyLcdDriver/i_reg[4]} {MyLcdDriver/i_reg[5]} {MyLcdDriver/i_reg[6]} {MyLcdDriver/i_reg[7]} {MyLcdDriver/i_reg[8]} {MyLcdDriver/i_reg[9]} {MyLcdDriver/i_reg[10]} {MyLcdDriver/i_reg[11]} {MyLcdDriver/i_reg[12]} {MyLcdDriver/i_reg[13]} {MyLcdDriver/i_reg[14]} {MyLcdDriver/i_reg[15]} {MyLcdDriver/i_reg[16]} {MyLcdDriver/i_reg[17]} {MyLcdDriver/i_reg[18]} {MyLcdDriver/i_reg[19]} {MyLcdDriver/i_reg[20]} {MyLcdDriver/i_reg[21]} {MyLcdDriver/i_reg[22]} {MyLcdDriver/i_reg[23]} {MyLcdDriver/i_reg[24]} {MyLcdDriver/i_reg[25]} {MyLcdDriver/i_reg[26]} {MyLcdDriver/i_reg[27]} {MyLcdDriver/i_reg[28]} {MyLcdDriver/i_reg[29]} {MyLcdDriver/i_reg[30]} {MyLcdDriver/i_reg[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {MyLcdDriver/wrt_ptr[0]} {MyLcdDriver/wrt_ptr[1]} {MyLcdDriver/wrt_ptr[2]} {MyLcdDriver/wrt_ptr[3]} {MyLcdDriver/wrt_ptr[4]} {MyLcdDriver/wrt_ptr[5]} {MyLcdDriver/wrt_ptr[6]} {MyLcdDriver/wrt_ptr[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {r_Rx_Byte[0]} {r_Rx_Byte[1]} {r_Rx_Byte[2]} {r_Rx_Byte[3]} {r_Rx_Byte[4]} {r_Rx_Byte[5]} {r_Rx_Byte[6]} {r_Rx_Byte[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list r_Rx_DV]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
