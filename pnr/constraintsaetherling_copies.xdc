create_clock -period 6.100 -name clk -waveform {0.000 3.050} [get_ports * -filter "name == CLK || name == ap_clk || name == clock"]
set_property HD.CLK_SRC BUFGCTRL_X0Y16 [get_ports * -filter "name == CLK || name == ap_clk || name == clock"]
