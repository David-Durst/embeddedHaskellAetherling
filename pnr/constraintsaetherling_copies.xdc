create_clock -period 5.700 -name clk -waveform {0.000 2.850} [get_ports * -filter "name == CLK || name == ap_clk || name == clock"]
set_property HD.CLK_SRC BUFGCTRL_X0Y16 [get_ports * -filter "name == CLK || name == ap_clk || name == clock"]
