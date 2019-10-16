create_clock -period 1.000 -name clk -waveform {0.000 0.500} [get_ports CLK]
set_property HD.CLK_SRC BUFGCTRL_X0Y16 [get_ports CLK]
