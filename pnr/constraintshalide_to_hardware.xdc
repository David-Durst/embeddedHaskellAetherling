create_clock -period 6.200 -name clk -waveform {0.000 3.100} [get_ports * -filter "name == CLK || name == ap_clk"]
set_property HD.CLK_SRC BUFGCTRL_X0Y16 [get_ports * -filter "name == CLK || name == ap_clk"]
