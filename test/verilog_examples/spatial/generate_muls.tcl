
## Integer Divider
create_ip -name div_gen -vendor xilinx.com -library ip -version 5.1 -module_name div_32_32_16_Unsigned_Remainder
set_property -dict [list CONFIG.latency_configuration {Manual} CONFIG.latency {16} CONFIG.aclken {true}] [get_ips div_32_32_16_Unsigned_Remainder]
set_property -dict [list CONFIG.dividend_and_quotient_width {32} CONFIG.divisor_width {32} CONFIG.remainder_type {Remainder} CONFIG.clocks_per_division {1} CONFIG.fractional_width {32} CONFIG.operand_sign {Unsigned}] [get_ips div_32_32_16_Unsigned_Remainder]
set_property -dict [list CONFIG.ACLK_INTF.FREQ_HZ $CLOCK_FREQ_HZ] [get_ips div_32_32_16_Unsigned_Remainder]
set_property generate_synth_checkpoint false [get_files div_32_32_16_Unsigned_Remainder.xci]
generate_target {all} [get_ips div_32_32_16_Unsigned_Remainder]



## Integer Divider
create_ip -name div_gen -vendor xilinx.com -library ip -version 5.1 -module_name div_32_32_20_Signed_Fractional
set_property -dict [list CONFIG.latency_configuration {Manual} CONFIG.latency {20} CONFIG.aclken {true}] [get_ips div_32_32_20_Signed_Fractional]
set_property -dict [list CONFIG.dividend_and_quotient_width {32} CONFIG.divisor_width {32} CONFIG.remainder_type {Fractional} CONFIG.clocks_per_division {1} CONFIG.fractional_width {2} CONFIG.operand_sign {Signed}] [get_ips div_32_32_20_Signed_Fractional]
set_property -dict [list CONFIG.ACLK_INTF.FREQ_HZ $CLOCK_FREQ_HZ] [get_ips div_32_32_20_Signed_Fractional]
set_property generate_synth_checkpoint false [get_files div_32_32_20_Signed_Fractional.xci]
generate_target {all} [get_ips div_32_32_20_Signed_Fractional]



## Integer Multiplier
create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name mul_39_39_39_6_Unsigned_Use_Mults
set_property -dict [list CONFIG.MultType {Parallel_Multiplier} CONFIG.PortAType {Unsigned}  CONFIG.PortAWidth {39} CONFIG.PortBType {Unsigned} CONFIG.PortBWidth {39} CONFIG.Multiplier_Construction {Use_Mults} CONFIG.OptGoal {Speed} CONFIG.Use_Custom_Output_Width {true} CONFIG.OutputWidthHigh {39} CONFIG.PipeStages {6} CONFIG.ClockEnable {true}] [get_ips mul_39_39_39_6_Unsigned_Use_Mults]
set_property -dict [list CONFIG.clk_intf.FREQ_HZ $CLOCK_FREQ_HZ] [get_ips mul_39_39_39_6_Unsigned_Use_Mults]
set_property generate_synth_checkpoint false [get_files mul_39_39_39_6_Unsigned_Use_Mults.xci]
generate_target {all} [get_ips mul_39_39_39_6_Unsigned_Use_Mults]



