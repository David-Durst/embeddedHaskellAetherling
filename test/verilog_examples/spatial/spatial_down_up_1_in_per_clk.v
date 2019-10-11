module Module_0(
  input CLK/*verilator public*/, 
  input [7:0] I/*verilator public*/, 
  output [7:0] O/*verilator public*/, 
  output valid_down/*verilator public*/, 
  input valid_up/*verilator public*/
);
  x79_inr_Foreach_kernelx79_inr_Foreach_concrete1 sampler_box ( // @[m_x55_ctr_0.scala 26:17:@1721.4]
    .clock(CLK),
    .reset('b0),
    .io_in_x48_valid(valid_down),
    .io_in_x48_bits(O),
    .io_in_x47_ready(),
    .io_in_x47_bits(I),
    .io_sigsIn_datapathEn(valid_up),
    .io_sigsIn_break('b0),
    .io_sigsIn_cchainOutputs_0_oobs_0('b0),
    .io_rr('b1)
  );
endmodule

module x79_inr_Foreach_kernelx79_inr_Foreach_concrete1( // @[:@1691.2]
  input        clock, // @[:@1692.4]
  input        reset, // @[:@1693.4]
  output       io_in_x48_valid, // @[:@1694.4]
  output [7:0] io_in_x48_bits, // @[:@1694.4]
  output       io_in_x47_ready, // @[:@1694.4]
  input  [7:0] io_in_x47_bits, // @[:@1694.4]
  input        io_sigsIn_datapathEn, // @[:@1694.4]
  input        io_sigsIn_break, // @[:@1694.4]
  input        io_sigsIn_cchainOutputs_0_oobs_0, // @[:@1694.4]
  input        io_rr // @[:@1694.4]
);
  wire  x55_ctr_0_clock; // @[m_x55_ctr_0.scala 26:17:@1721.4]
  wire  x55_ctr_0_reset; // @[m_x55_ctr_0.scala 26:17:@1721.4]
  wire [31:0] x55_ctr_0_io_rPort_0_output_0; // @[m_x55_ctr_0.scala 26:17:@1721.4]
  wire [31:0] x55_ctr_0_io_wPort_0_data_0; // @[m_x55_ctr_0.scala 26:17:@1721.4]
  wire  x55_ctr_0_io_wPort_0_reset; // @[m_x55_ctr_0.scala 26:17:@1721.4]
  wire  x55_ctr_0_io_wPort_0_en_0; // @[m_x55_ctr_0.scala 26:17:@1721.4]
  wire  x55_ctr_0_io_reset; // @[m_x55_ctr_0.scala 26:17:@1721.4]
  wire  x56_ctr_1_clock; // @[m_x56_ctr_1.scala 26:17:@1738.4]
  wire  x56_ctr_1_reset; // @[m_x56_ctr_1.scala 26:17:@1738.4]
  wire [31:0] x56_ctr_1_io_rPort_0_output_0; // @[m_x56_ctr_1.scala 26:17:@1738.4]
  wire [31:0] x56_ctr_1_io_wPort_0_data_0; // @[m_x56_ctr_1.scala 26:17:@1738.4]
  wire  x56_ctr_1_io_wPort_0_reset; // @[m_x56_ctr_1.scala 26:17:@1738.4]
  wire  x56_ctr_1_io_wPort_0_en_0; // @[m_x56_ctr_1.scala 26:17:@1738.4]
  wire  x56_ctr_1_io_reset; // @[m_x56_ctr_1.scala 26:17:@1738.4]
  wire  x57_latch_0_clock; // @[m_x57_latch_0.scala 26:17:@1755.4]
  wire  x57_latch_0_reset; // @[m_x57_latch_0.scala 26:17:@1755.4]
  wire [7:0] x57_latch_0_io_rPort_0_output_0; // @[m_x57_latch_0.scala 26:17:@1755.4]
  wire [7:0] x57_latch_0_io_wPort_0_data_0; // @[m_x57_latch_0.scala 26:17:@1755.4]
  wire  x57_latch_0_io_wPort_0_reset; // @[m_x57_latch_0.scala 26:17:@1755.4]
  wire  x57_latch_0_io_wPort_0_en_0; // @[m_x57_latch_0.scala 26:17:@1755.4]
  wire  x57_latch_0_io_reset; // @[m_x57_latch_0.scala 26:17:@1755.4]
  wire  x59_sum_1_clock; // @[Math.scala 150:24:@1785.4]
  wire  x59_sum_1_reset; // @[Math.scala 150:24:@1785.4]
  wire [31:0] x59_sum_1_io_a; // @[Math.scala 150:24:@1785.4]
  wire [31:0] x59_sum_1_io_result; // @[Math.scala 150:24:@1785.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1795.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1795.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@1795.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@1795.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@1795.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@1806.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@1806.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@1806.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@1806.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@1806.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@1825.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@1825.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@1825.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@1825.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@1825.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@1845.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@1845.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@1845.4]
  wire  x63_1_clock; // @[Math.scala 366:24:@1861.4]
  wire  x63_1_reset; // @[Math.scala 366:24:@1861.4]
  wire [31:0] x63_1_io_a; // @[Math.scala 366:24:@1861.4]
  wire [31:0] x63_1_io_result; // @[Math.scala 366:24:@1861.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@1878.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@1878.4]
  wire [7:0] RetimeWrapper_4_io_in; // @[package.scala 93:22:@1878.4]
  wire [7:0] RetimeWrapper_4_io_out; // @[package.scala 93:22:@1878.4]
  wire  RetimeWrapper_5_clock; // @[package.scala 93:22:@1894.4]
  wire  RetimeWrapper_5_reset; // @[package.scala 93:22:@1894.4]
  wire [7:0] RetimeWrapper_5_io_in; // @[package.scala 93:22:@1894.4]
  wire [7:0] RetimeWrapper_5_io_out; // @[package.scala 93:22:@1894.4]
  wire  RetimeWrapper_6_clock; // @[package.scala 93:22:@1905.4]
  wire  RetimeWrapper_6_reset; // @[package.scala 93:22:@1905.4]
  wire  RetimeWrapper_6_io_in; // @[package.scala 93:22:@1905.4]
  wire  RetimeWrapper_6_io_out; // @[package.scala 93:22:@1905.4]
  wire  RetimeWrapper_7_clock; // @[package.scala 93:22:@1932.4]
  wire  RetimeWrapper_7_reset; // @[package.scala 93:22:@1932.4]
  wire  RetimeWrapper_7_io_in; // @[package.scala 93:22:@1932.4]
  wire  RetimeWrapper_7_io_out; // @[package.scala 93:22:@1932.4]
  wire  RetimeWrapper_8_clock; // @[package.scala 93:22:@1946.4]
  wire  RetimeWrapper_8_reset; // @[package.scala 93:22:@1946.4]
  wire  RetimeWrapper_8_io_flow; // @[package.scala 93:22:@1946.4]
  wire  RetimeWrapper_8_io_in; // @[package.scala 93:22:@1946.4]
  wire  RetimeWrapper_8_io_out; // @[package.scala 93:22:@1946.4]
  wire  RetimeWrapper_9_clock; // @[package.scala 93:22:@1955.4]
  wire  RetimeWrapper_9_reset; // @[package.scala 93:22:@1955.4]
  wire  RetimeWrapper_9_io_in; // @[package.scala 93:22:@1955.4]
  wire  RetimeWrapper_9_io_out; // @[package.scala 93:22:@1955.4]
  wire  b52; // @[sm_x79_inr_Foreach.scala 60:17:@1716.4]
  wire  _T_153; // @[sm_x79_inr_Foreach.scala 71:136:@1773.4]
  wire  _T_176; // @[package.scala 96:25:@1811.4 package.scala 96:25:@1812.4]
  wire  _T_178; // @[implicits.scala 55:10:@1813.4]
  wire  _T_179; // @[sm_x79_inr_Foreach.scala 80:125:@1814.4]
  wire  _T_181; // @[sm_x79_inr_Foreach.scala 80:212:@1816.4]
  wire  x81_b52_D1; // @[package.scala 96:25:@1800.4 package.scala 96:25:@1801.4]
  wire  _T_188; // @[package.scala 96:25:@1830.4 package.scala 96:25:@1831.4]
  wire  _T_190; // @[implicits.scala 55:10:@1832.4]
  wire  _T_191; // @[sm_x79_inr_Foreach.scala 85:125:@1833.4]
  wire  _T_193; // @[sm_x79_inr_Foreach.scala 85:212:@1835.4]
  wire [31:0] x63_number; // @[Math.scala 370:22:@1867.4 Math.scala 371:14:@1868.4]
  wire [31:0] _T_221; // @[Math.scala 499:37:@1873.4]
  wire  x64; // @[Math.scala 499:44:@1875.4]
  wire  _T_248; // @[package.scala 96:25:@1910.4 package.scala 96:25:@1911.4]
  wire  _T_250; // @[implicits.scala 55:10:@1912.4]
  wire  _T_251; // @[sm_x79_inr_Foreach.scala 109:127:@1913.4]
  wire  _T_253; // @[sm_x79_inr_Foreach.scala 109:215:@1915.4]
  wire  _T_281; // @[package.scala 96:25:@1960.4 package.scala 96:25:@1961.4]
  wire  _T_283; // @[implicits.scala 55:10:@1962.4]
  wire  x84_x72_D1; // @[package.scala 96:25:@1951.4 package.scala 96:25:@1952.4]
  x55_ctr_0 x55_ctr_0 ( // @[m_x55_ctr_0.scala 26:17:@1721.4]
    .clock(x55_ctr_0_clock),
    .reset(x55_ctr_0_reset),
    .io_rPort_0_output_0(x55_ctr_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(x55_ctr_0_io_wPort_0_data_0),
    .io_wPort_0_reset(x55_ctr_0_io_wPort_0_reset),
    .io_wPort_0_en_0(x55_ctr_0_io_wPort_0_en_0),
    .io_reset(x55_ctr_0_io_reset)
  );
  x55_ctr_0 x56_ctr_1 ( // @[m_x56_ctr_1.scala 26:17:@1738.4]
    .clock(x56_ctr_1_clock),
    .reset(x56_ctr_1_reset),
    .io_rPort_0_output_0(x56_ctr_1_io_rPort_0_output_0),
    .io_wPort_0_data_0(x56_ctr_1_io_wPort_0_data_0),
    .io_wPort_0_reset(x56_ctr_1_io_wPort_0_reset),
    .io_wPort_0_en_0(x56_ctr_1_io_wPort_0_en_0),
    .io_reset(x56_ctr_1_io_reset)
  );
  x57_latch_0 x57_latch_0 ( // @[m_x57_latch_0.scala 26:17:@1755.4]
    .clock(x57_latch_0_clock),
    .reset(x57_latch_0_reset),
    .io_rPort_0_output_0(x57_latch_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(x57_latch_0_io_wPort_0_data_0),
    .io_wPort_0_reset(x57_latch_0_io_wPort_0_reset),
    .io_wPort_0_en_0(x57_latch_0_io_wPort_0_en_0),
    .io_reset(x57_latch_0_io_reset)
  );
  x59_sum x59_sum_1 ( // @[Math.scala 150:24:@1785.4]
    .clock(x59_sum_1_clock),
    .reset(x59_sum_1_reset),
    .io_a(x59_sum_1_io_a),
    .io_result(x59_sum_1_io_result)
  );
  RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@1795.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@1806.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@1825.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  RetimeWrapper_17 RetimeWrapper_3 ( // @[package.scala 93:22:@1845.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_in(RetimeWrapper_3_io_in)
  );
  x63 x63_1 ( // @[Math.scala 366:24:@1861.4]
    .clock(x63_1_clock),
    .reset(x63_1_reset),
    .io_a(x63_1_io_a),
    .io_result(x63_1_io_result)
  );
  RetimeWrapper_19 RetimeWrapper_4 ( // @[package.scala 93:22:@1878.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_in(RetimeWrapper_4_io_in),
    .io_out(RetimeWrapper_4_io_out)
  );
  RetimeWrapper_20 RetimeWrapper_5 ( // @[package.scala 93:22:@1894.4]
    .clock(RetimeWrapper_5_clock),
    .reset(RetimeWrapper_5_reset),
    .io_in(RetimeWrapper_5_io_in),
    .io_out(RetimeWrapper_5_io_out)
  );
  RetimeWrapper_9 RetimeWrapper_6 ( // @[package.scala 93:22:@1905.4]
    .clock(RetimeWrapper_6_clock),
    .reset(RetimeWrapper_6_reset),
    .io_in(RetimeWrapper_6_io_in),
    .io_out(RetimeWrapper_6_io_out)
  );
  RetimeWrapper_5 RetimeWrapper_7 ( // @[package.scala 93:22:@1932.4]
    .clock(RetimeWrapper_7_clock),
    .reset(RetimeWrapper_7_reset),
    .io_in(RetimeWrapper_7_io_in),
    .io_out(RetimeWrapper_7_io_out)
  );
  RetimeWrapper RetimeWrapper_8 ( // @[package.scala 93:22:@1946.4]
    .clock(RetimeWrapper_8_clock),
    .reset(RetimeWrapper_8_reset),
    .io_flow(RetimeWrapper_8_io_flow),
    .io_in(RetimeWrapper_8_io_in),
    .io_out(RetimeWrapper_8_io_out)
  );
  RetimeWrapper_5 RetimeWrapper_9 ( // @[package.scala 93:22:@1955.4]
    .clock(RetimeWrapper_9_clock),
    .reset(RetimeWrapper_9_reset),
    .io_in(RetimeWrapper_9_io_in),
    .io_out(RetimeWrapper_9_io_out)
  );
  assign b52 = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[sm_x79_inr_Foreach.scala 60:17:@1716.4]
  assign _T_153 = ~ io_sigsIn_break; // @[sm_x79_inr_Foreach.scala 71:136:@1773.4]
  assign _T_176 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@1811.4 package.scala 96:25:@1812.4]
  assign _T_178 = io_rr ? _T_176 : 1'h0; // @[implicits.scala 55:10:@1813.4]
  assign _T_179 = _T_153 & _T_178; // @[sm_x79_inr_Foreach.scala 80:125:@1814.4]
  assign _T_181 = _T_179 & _T_153; // @[sm_x79_inr_Foreach.scala 80:212:@1816.4]
  assign x81_b52_D1 = RetimeWrapper_io_out; // @[package.scala 96:25:@1800.4 package.scala 96:25:@1801.4]
  assign _T_188 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@1830.4 package.scala 96:25:@1831.4]
  assign _T_190 = io_rr ? _T_188 : 1'h0; // @[implicits.scala 55:10:@1832.4]
  assign _T_191 = _T_153 & _T_190; // @[sm_x79_inr_Foreach.scala 85:125:@1833.4]
  assign _T_193 = _T_191 & _T_153; // @[sm_x79_inr_Foreach.scala 85:212:@1835.4]
  assign x63_number = x63_1_io_result; // @[Math.scala 370:22:@1867.4 Math.scala 371:14:@1868.4]
  assign _T_221 = $signed(x63_number); // @[Math.scala 499:37:@1873.4]
  assign x64 = $signed(_T_221) == $signed(32'sh0); // @[Math.scala 499:44:@1875.4]
  assign _T_248 = RetimeWrapper_6_io_out; // @[package.scala 96:25:@1910.4 package.scala 96:25:@1911.4]
  assign _T_250 = io_rr ? _T_248 : 1'h0; // @[implicits.scala 55:10:@1912.4]
  assign _T_251 = _T_153 & _T_250; // @[sm_x79_inr_Foreach.scala 109:127:@1913.4]
  assign _T_253 = _T_251 & _T_153; // @[sm_x79_inr_Foreach.scala 109:215:@1915.4]
  assign _T_281 = RetimeWrapper_9_io_out; // @[package.scala 96:25:@1960.4 package.scala 96:25:@1961.4]
  assign _T_283 = io_rr ? _T_281 : 1'h0; // @[implicits.scala 55:10:@1962.4]
  assign x84_x72_D1 = RetimeWrapper_8_io_out; // @[package.scala 96:25:@1951.4 package.scala 96:25:@1952.4]
  assign io_in_x48_valid = _T_283 & x84_x72_D1; // @[sm_x79_inr_Foreach.scala 119:17:@1965.4]
  assign io_in_x48_bits = x57_latch_0_io_rPort_0_output_0; // @[sm_x79_inr_Foreach.scala 120:16:@1966.4]
  assign io_in_x47_ready = b52 & io_sigsIn_datapathEn; // @[sm_x79_inr_Foreach.scala 62:17:@1719.4]
  assign x55_ctr_0_clock = clock; // @[:@1722.4]
  assign x55_ctr_0_reset = reset; // @[:@1723.4]
  assign x55_ctr_0_io_wPort_0_data_0 = x59_sum_1_io_result; // @[MemInterfaceType.scala 90:56:@1838.4]
  assign x55_ctr_0_io_wPort_0_reset = x55_ctr_0_io_reset; // @[MemInterfaceType.scala 91:23:@1839.4]
  assign x55_ctr_0_io_wPort_0_en_0 = _T_193 & x81_b52_D1; // @[MemInterfaceType.scala 93:57:@1840.4]
  assign x55_ctr_0_io_reset = 1'h0; // @[m_x55_ctr_0.scala 42:14:@1737.4]
  assign x56_ctr_1_clock = clock; // @[:@1739.4]
  assign x56_ctr_1_reset = reset; // @[:@1740.4]
  assign x56_ctr_1_io_wPort_0_data_0 = x59_sum_1_io_result; // @[MemInterfaceType.scala 90:56:@1819.4]
  assign x56_ctr_1_io_wPort_0_reset = x56_ctr_1_io_reset; // @[MemInterfaceType.scala 91:23:@1820.4]
  assign x56_ctr_1_io_wPort_0_en_0 = _T_181 & x81_b52_D1; // @[MemInterfaceType.scala 93:57:@1821.4]
  assign x56_ctr_1_io_reset = 1'h0; // @[m_x56_ctr_1.scala 42:14:@1754.4]
  assign x57_latch_0_clock = clock; // @[:@1756.4]
  assign x57_latch_0_reset = reset; // @[:@1757.4]
  assign x57_latch_0_io_wPort_0_data_0 = RetimeWrapper_5_io_out; // @[MemInterfaceType.scala 90:56:@1918.4]
  assign x57_latch_0_io_wPort_0_reset = x57_latch_0_io_reset; // @[MemInterfaceType.scala 91:23:@1919.4]
  assign x57_latch_0_io_wPort_0_en_0 = _T_253 & x64; // @[MemInterfaceType.scala 93:57:@1920.4]
  assign x57_latch_0_io_reset = 1'h0; // @[m_x57_latch_0.scala 42:14:@1771.4]
  assign x59_sum_1_clock = clock; // @[:@1786.4]
  assign x59_sum_1_reset = reset; // @[:@1787.4]
  assign x59_sum_1_io_a = x55_ctr_0_io_rPort_0_output_0; // @[Math.scala 151:17:@1788.4]
  assign RetimeWrapper_clock = clock; // @[:@1796.4]
  assign RetimeWrapper_reset = reset; // @[:@1797.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@1799.4]
  assign RetimeWrapper_io_in = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[package.scala 94:16:@1798.4]
  assign RetimeWrapper_1_clock = clock; // @[:@1807.4]
  assign RetimeWrapper_1_reset = reset; // @[:@1808.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@1810.4]
  assign RetimeWrapper_1_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@1809.4]
  assign RetimeWrapper_2_clock = clock; // @[:@1826.4]
  assign RetimeWrapper_2_reset = reset; // @[:@1827.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@1829.4]
  assign RetimeWrapper_2_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@1828.4]
  assign RetimeWrapper_3_clock = clock; // @[:@1846.4]
  assign RetimeWrapper_3_reset = reset; // @[:@1847.4]
  assign RetimeWrapper_3_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@1848.4]
  assign x63_1_clock = clock; // @[:@1862.4]
  assign x63_1_reset = reset; // @[:@1863.4]
  assign x63_1_io_a = x56_ctr_1_io_rPort_0_output_0; // @[Math.scala 367:17:@1864.4]
  assign RetimeWrapper_4_clock = clock; // @[:@1879.4]
  assign RetimeWrapper_4_reset = reset; // @[:@1880.4]
  assign RetimeWrapper_4_io_in = io_in_x47_bits; // @[package.scala 94:16:@1881.4]
  assign RetimeWrapper_5_clock = clock; // @[:@1895.4]
  assign RetimeWrapper_5_reset = reset; // @[:@1896.4]
  assign RetimeWrapper_5_io_in = RetimeWrapper_4_io_out; // @[package.scala 94:16:@1897.4]
  assign RetimeWrapper_6_clock = clock; // @[:@1906.4]
  assign RetimeWrapper_6_reset = reset; // @[:@1907.4]
  assign RetimeWrapper_6_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@1908.4]
  assign RetimeWrapper_7_clock = clock; // @[:@1933.4]
  assign RetimeWrapper_7_reset = reset; // @[:@1934.4]
  assign RetimeWrapper_7_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@1935.4]
  assign RetimeWrapper_8_clock = clock; // @[:@1947.4]
  assign RetimeWrapper_8_reset = reset; // @[:@1948.4]
  assign RetimeWrapper_8_io_flow = 1'h1; // @[package.scala 95:18:@1950.4]
  assign RetimeWrapper_8_io_in = $signed(_T_221) != $signed(32'sh4); // @[package.scala 94:16:@1949.4]
  assign RetimeWrapper_9_clock = clock; // @[:@1956.4]
  assign RetimeWrapper_9_reset = reset; // @[:@1957.4]
  assign RetimeWrapper_9_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@1958.4]
endmodule

module FF( // @[:@3.2]
  input         clock, // @[:@4.4]
  input         reset, // @[:@5.4]
  output [31:0] io_rPort_0_output_0, // @[:@6.4]
  input  [31:0] io_wPort_0_data_0, // @[:@6.4]
  input         io_wPort_0_reset, // @[:@6.4]
  input         io_wPort_0_en_0 // @[:@6.4]
);
  reg [31:0] ff; // @[MemPrimitives.scala 173:19:@21.4]
  reg [31:0] _RAND_0;
  wire [31:0] _T_68; // @[MemPrimitives.scala 177:32:@23.4]
  wire [31:0] _T_69; // @[MemPrimitives.scala 177:12:@24.4]
  assign _T_68 = io_wPort_0_en_0 ? io_wPort_0_data_0 : ff; // @[MemPrimitives.scala 177:32:@23.4]
  assign _T_69 = io_wPort_0_reset ? 32'h0 : _T_68; // @[MemPrimitives.scala 177:12:@24.4]
  assign io_rPort_0_output_0 = ff; // @[MemPrimitives.scala 178:34:@26.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  ff = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      ff <= 32'h0;
    end else begin
      if (io_wPort_0_reset) begin
        ff <= 32'h0;
      end else begin
        if (io_wPort_0_en_0) begin
          ff <= io_wPort_0_data_0;
        end
      end
    end
  end
endmodule
module SRFF( // @[:@28.2]
  input   clock, // @[:@29.4]
  input   reset, // @[:@30.4]
  input   io_input_set, // @[:@31.4]
  input   io_input_reset, // @[:@31.4]
  input   io_input_asyn_reset, // @[:@31.4]
  output  io_output // @[:@31.4]
);
  reg  _T_15; // @[SRFF.scala 20:21:@33.4]
  reg [31:0] _RAND_0;
  wire  _T_19; // @[SRFF.scala 21:74:@34.4]
  wire  _T_20; // @[SRFF.scala 21:48:@35.4]
  wire  _T_21; // @[SRFF.scala 21:14:@36.4]
  assign _T_19 = io_input_reset ? 1'h0 : _T_15; // @[SRFF.scala 21:74:@34.4]
  assign _T_20 = io_input_set ? 1'h1 : _T_19; // @[SRFF.scala 21:48:@35.4]
  assign _T_21 = io_input_asyn_reset ? 1'h0 : _T_20; // @[SRFF.scala 21:14:@36.4]
  assign io_output = io_input_asyn_reset ? 1'h0 : _T_15; // @[SRFF.scala 22:15:@39.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_15 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_15 <= 1'h0;
    end else begin
      if (io_input_asyn_reset) begin
        _T_15 <= 1'h0;
      end else begin
        if (io_input_set) begin
          _T_15 <= 1'h1;
        end else begin
          if (io_input_reset) begin
            _T_15 <= 1'h0;
          end
        end
      end
    end
  end
endmodule
module SingleCounter( // @[:@41.2]
  input   clock, // @[:@42.4]
  input   reset, // @[:@43.4]
  input   io_input_reset, // @[:@44.4]
  output  io_output_done // @[:@44.4]
);
  wire  bases_0_clock; // @[Counter.scala 253:53:@57.4]
  wire  bases_0_reset; // @[Counter.scala 253:53:@57.4]
  wire [31:0] bases_0_io_rPort_0_output_0; // @[Counter.scala 253:53:@57.4]
  wire [31:0] bases_0_io_wPort_0_data_0; // @[Counter.scala 253:53:@57.4]
  wire  bases_0_io_wPort_0_reset; // @[Counter.scala 253:53:@57.4]
  wire  bases_0_io_wPort_0_en_0; // @[Counter.scala 253:53:@57.4]
  wire  SRFF_clock; // @[Counter.scala 255:22:@73.4]
  wire  SRFF_reset; // @[Counter.scala 255:22:@73.4]
  wire  SRFF_io_input_set; // @[Counter.scala 255:22:@73.4]
  wire  SRFF_io_input_reset; // @[Counter.scala 255:22:@73.4]
  wire  SRFF_io_input_asyn_reset; // @[Counter.scala 255:22:@73.4]
  wire  SRFF_io_output; // @[Counter.scala 255:22:@73.4]
  wire [31:0] _T_48; // @[Counter.scala 279:52:@101.4]
  wire [32:0] _T_50; // @[Counter.scala 283:33:@102.4]
  wire [31:0] _T_51; // @[Counter.scala 283:33:@103.4]
  wire [31:0] _T_52; // @[Counter.scala 283:33:@104.4]
  wire  _T_57; // @[Counter.scala 285:18:@106.4]
  wire [31:0] _T_68; // @[Counter.scala 291:115:@114.4]
  wire [31:0] _T_71; // @[Counter.scala 291:152:@117.4]
  wire [31:0] _T_72; // @[Counter.scala 291:74:@118.4]
  FF bases_0 ( // @[Counter.scala 253:53:@57.4]
    .clock(bases_0_clock),
    .reset(bases_0_reset),
    .io_rPort_0_output_0(bases_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(bases_0_io_wPort_0_data_0),
    .io_wPort_0_reset(bases_0_io_wPort_0_reset),
    .io_wPort_0_en_0(bases_0_io_wPort_0_en_0)
  );
  SRFF SRFF ( // @[Counter.scala 255:22:@73.4]
    .clock(SRFF_clock),
    .reset(SRFF_reset),
    .io_input_set(SRFF_io_input_set),
    .io_input_reset(SRFF_io_input_reset),
    .io_input_asyn_reset(SRFF_io_input_asyn_reset),
    .io_output(SRFF_io_output)
  );
  assign _T_48 = $signed(bases_0_io_rPort_0_output_0); // @[Counter.scala 279:52:@101.4]
  assign _T_50 = $signed(_T_48) + $signed(32'sh1); // @[Counter.scala 283:33:@102.4]
  assign _T_51 = $signed(_T_48) + $signed(32'sh1); // @[Counter.scala 283:33:@103.4]
  assign _T_52 = $signed(_T_51); // @[Counter.scala 283:33:@104.4]
  assign _T_57 = $signed(_T_52) >= $signed(32'sh11); // @[Counter.scala 285:18:@106.4]
  assign _T_68 = $unsigned(_T_48); // @[Counter.scala 291:115:@114.4]
  assign _T_71 = $unsigned(_T_52); // @[Counter.scala 291:152:@117.4]
  assign _T_72 = _T_57 ? _T_68 : _T_71; // @[Counter.scala 291:74:@118.4]
  assign io_output_done = $signed(_T_52) >= $signed(32'sh11); // @[Counter.scala 325:20:@127.4]
  assign bases_0_clock = clock; // @[:@58.4]
  assign bases_0_reset = reset; // @[:@59.4]
  assign bases_0_io_wPort_0_data_0 = io_input_reset ? 32'h0 : _T_72; // @[Counter.scala 291:31:@120.4]
  assign bases_0_io_wPort_0_reset = io_input_reset; // @[Counter.scala 273:27:@99.4]
  assign bases_0_io_wPort_0_en_0 = 1'h1; // @[Counter.scala 276:29:@100.4]
  assign SRFF_clock = clock; // @[:@74.4]
  assign SRFF_reset = reset; // @[:@75.4]
  assign SRFF_io_input_set = io_input_reset == 1'h0; // @[Counter.scala 256:23:@78.4]
  assign SRFF_io_input_reset = io_input_reset | io_output_done; // @[Counter.scala 257:25:@80.4]
  assign SRFF_io_input_asyn_reset = 1'h0; // @[Counter.scala 258:30:@81.4]
endmodule
module RetimeWrapper( // @[:@144.2]
  input   clock, // @[:@145.4]
  input   reset, // @[:@146.4]
  input   io_flow, // @[:@147.4]
  input   io_in, // @[:@147.4]
  output  io_out // @[:@147.4]
);
  wire  sr_out; // @[RetimeShiftRegister.scala 15:20:@149.4]
  wire  sr_in; // @[RetimeShiftRegister.scala 15:20:@149.4]
  wire  sr_init; // @[RetimeShiftRegister.scala 15:20:@149.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@149.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@149.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@149.4]
  RetimeShiftRegister #(.WIDTH(1), .STAGES(1)) sr ( // @[RetimeShiftRegister.scala 15:20:@149.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@162.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@161.4]
  assign sr_init = 1'h0; // @[RetimeShiftRegister.scala 19:16:@160.4]
  assign sr_flow = io_flow; // @[RetimeShiftRegister.scala 18:16:@159.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@158.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@156.4]
endmodule

module SingleCounter_1( // @[:@515.2]
  input   clock, // @[:@516.4]
  input   reset, // @[:@517.4]
  input   io_input_reset, // @[:@518.4]
  input   io_input_enable // @[:@518.4]
);
  wire  bases_0_clock; // @[Counter.scala 253:53:@531.4]
  wire  bases_0_reset; // @[Counter.scala 253:53:@531.4]
  wire [31:0] bases_0_io_rPort_0_output_0; // @[Counter.scala 253:53:@531.4]
  wire [31:0] bases_0_io_wPort_0_data_0; // @[Counter.scala 253:53:@531.4]
  wire  bases_0_io_wPort_0_reset; // @[Counter.scala 253:53:@531.4]
  wire  bases_0_io_wPort_0_en_0; // @[Counter.scala 253:53:@531.4]
  wire [31:0] _T_36; // @[Counter.scala 339:61:@550.4]
  wire [32:0] _T_38; // @[Counter.scala 339:68:@551.4]
  wire [31:0] _T_39; // @[Counter.scala 339:68:@552.4]
  wire [31:0] _T_40; // @[Counter.scala 339:68:@553.4]
  FF bases_0 ( // @[Counter.scala 253:53:@531.4]
    .clock(bases_0_clock),
    .reset(bases_0_reset),
    .io_rPort_0_output_0(bases_0_io_rPort_0_output_0),
    .io_wPort_0_data_0(bases_0_io_wPort_0_data_0),
    .io_wPort_0_reset(bases_0_io_wPort_0_reset),
    .io_wPort_0_en_0(bases_0_io_wPort_0_en_0)
  );
  assign _T_36 = $signed(bases_0_io_rPort_0_output_0); // @[Counter.scala 339:61:@550.4]
  assign _T_38 = $signed(_T_36) + $signed(32'sh1); // @[Counter.scala 339:68:@551.4]
  assign _T_39 = $signed(_T_36) + $signed(32'sh1); // @[Counter.scala 339:68:@552.4]
  assign _T_40 = $signed(_T_39); // @[Counter.scala 339:68:@553.4]
  assign bases_0_clock = clock; // @[:@532.4]
  assign bases_0_reset = reset; // @[:@533.4]
  assign bases_0_io_wPort_0_data_0 = $unsigned(_T_40); // @[Counter.scala 339:31:@555.4]
  assign bases_0_io_wPort_0_reset = io_input_reset; // @[Counter.scala 337:27:@548.4]
  assign bases_0_io_wPort_0_en_0 = io_input_enable; // @[Counter.scala 338:29:@549.4]
endmodule
module x50_ctrchain( // @[:@562.2]
  input   clock, // @[:@563.4]
  input   reset, // @[:@564.4]
  input   io_input_reset, // @[:@565.4]
  input   io_input_enable, // @[:@565.4]
  output  io_output_oobs_0 // @[:@565.4]
);
  wire  ctrs_0_clock; // @[Counter.scala 505:46:@567.4]
  wire  ctrs_0_reset; // @[Counter.scala 505:46:@567.4]
  wire  ctrs_0_io_input_reset; // @[Counter.scala 505:46:@567.4]
  wire  ctrs_0_io_input_enable; // @[Counter.scala 505:46:@567.4]
  reg  doneLatch; // @[Counter.scala 542:26:@588.4]
  reg [31:0] _RAND_0;
  wire  _T_55; // @[Counter.scala 543:19:@590.4]
  SingleCounter_1 ctrs_0 ( // @[Counter.scala 505:46:@567.4]
    .clock(ctrs_0_clock),
    .reset(ctrs_0_reset),
    .io_input_reset(ctrs_0_io_input_reset),
    .io_input_enable(ctrs_0_io_input_enable)
  );
  assign _T_55 = io_input_reset ? 1'h0 : doneLatch; // @[Counter.scala 543:19:@590.4]
  assign io_output_oobs_0 = doneLatch; // @[Counter.scala 550:30:@594.4]
  assign ctrs_0_clock = clock; // @[:@568.4]
  assign ctrs_0_reset = reset; // @[:@569.4]
  assign ctrs_0_io_input_reset = io_input_reset; // @[Counter.scala 512:24:@573.4]
  assign ctrs_0_io_input_enable = io_input_enable; // @[Counter.scala 516:33:@574.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  doneLatch = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      doneLatch <= 1'h0;
    end else begin
      if (io_input_reset) begin
        doneLatch <= 1'h0;
      end
    end
  end
endmodule
module RetimeWrapper_5( // @[:@634.2]
  input   clock, // @[:@635.4]
  input   reset, // @[:@636.4]
  input   io_in, // @[:@637.4]
  output  io_out // @[:@637.4]
);
  wire  sr_out; // @[RetimeShiftRegister.scala 15:20:@639.4]
  wire  sr_in; // @[RetimeShiftRegister.scala 15:20:@639.4]
  wire  sr_init; // @[RetimeShiftRegister.scala 15:20:@639.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@639.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@639.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@639.4]
  RetimeShiftRegister #(.WIDTH(1), .STAGES(19)) sr ( // @[RetimeShiftRegister.scala 15:20:@639.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@652.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@651.4]
  assign sr_init = 1'h0; // @[RetimeShiftRegister.scala 19:16:@650.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@649.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@648.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@646.4]
endmodule
module RetimeWrapper_9( // @[:@762.2]
  input   clock, // @[:@763.4]
  input   reset, // @[:@764.4]
  input   io_in, // @[:@765.4]
  output  io_out // @[:@765.4]
);
  wire  sr_out; // @[RetimeShiftRegister.scala 15:20:@767.4]
  wire  sr_in; // @[RetimeShiftRegister.scala 15:20:@767.4]
  wire  sr_init; // @[RetimeShiftRegister.scala 15:20:@767.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@767.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@767.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@767.4]
  RetimeShiftRegister #(.WIDTH(1), .STAGES(18)) sr ( // @[RetimeShiftRegister.scala 15:20:@767.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@780.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@779.4]
  assign sr_init = 1'h0; // @[RetimeShiftRegister.scala 19:16:@778.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@777.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@776.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@774.4]
endmodule
module x55_ctr_0( // @[:@1036.2]
  input         clock, // @[:@1037.4]
  input         reset, // @[:@1038.4]
  output [31:0] io_rPort_0_output_0, // @[:@1039.4]
  input  [31:0] io_wPort_0_data_0, // @[:@1039.4]
  input         io_wPort_0_reset, // @[:@1039.4]
  input         io_wPort_0_en_0, // @[:@1039.4]
  input         io_reset // @[:@1039.4]
);
  reg [31:0] ff; // @[MemPrimitives.scala 173:19:@1055.4]
  reg [31:0] _RAND_0;
  wire [31:0] _T_69; // @[MemPrimitives.scala 177:32:@1057.4]
  wire [31:0] _T_70; // @[MemPrimitives.scala 177:12:@1058.4]
  assign _T_69 = io_wPort_0_en_0 ? io_wPort_0_data_0 : ff; // @[MemPrimitives.scala 177:32:@1057.4]
  assign _T_70 = io_wPort_0_reset ? 32'h0 : _T_69; // @[MemPrimitives.scala 177:12:@1058.4]
  assign io_rPort_0_output_0 = ff; // @[MemPrimitives.scala 178:34:@1060.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  ff = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      ff <= 32'h0;
    end else begin
      if (io_wPort_0_reset) begin
        ff <= 32'h0;
      end else begin
        if (io_wPort_0_en_0) begin
          ff <= io_wPort_0_data_0;
        end
      end
    end
  end
endmodule
module x57_latch_0( // @[:@1088.2]
  input        clock, // @[:@1089.4]
  input        reset, // @[:@1090.4]
  output [7:0] io_rPort_0_output_0, // @[:@1091.4]
  input  [7:0] io_wPort_0_data_0, // @[:@1091.4]
  input        io_wPort_0_reset, // @[:@1091.4]
  input        io_wPort_0_en_0, // @[:@1091.4]
  input        io_reset // @[:@1091.4]
);
  reg [7:0] ff; // @[MemPrimitives.scala 173:19:@1107.4]
  reg [31:0] _RAND_0;
  wire [7:0] _T_69; // @[MemPrimitives.scala 177:32:@1109.4]
  wire [7:0] _T_70; // @[MemPrimitives.scala 177:12:@1110.4]
  assign _T_69 = io_wPort_0_en_0 ? io_wPort_0_data_0 : ff; // @[MemPrimitives.scala 177:32:@1109.4]
  assign _T_70 = io_wPort_0_reset ? 8'h0 : _T_69; // @[MemPrimitives.scala 177:12:@1110.4]
  assign io_rPort_0_output_0 = ff; // @[MemPrimitives.scala 178:34:@1112.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  ff = _RAND_0[7:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      ff <= 8'h0;
    end else begin
      if (io_wPort_0_reset) begin
        ff <= 8'h0;
      end else begin
        if (io_wPort_0_en_0) begin
          ff <= io_wPort_0_data_0;
        end
      end
    end
  end
endmodule
module SimBlackBoxesfix2fixBox_1( // @[:@1114.2]
  input  [31:0] io_a, // @[:@1117.4]
  output [32:0] io_b // @[:@1117.4]
);
  wire  _T_20; // @[implicits.scala 69:16:@1124.4]
  assign _T_20 = io_a[31]; // @[implicits.scala 69:16:@1124.4]
  assign io_b = {_T_20,io_a}; // @[SimBlackBoxes.scala 99:40:@1129.4]
endmodule
module __1( // @[:@1131.2]
  input  [31:0] io_b, // @[:@1134.4]
  output [32:0] io_result // @[:@1134.4]
);
  wire [31:0] SimBlackBoxesfix2fixBox_io_a; // @[BigIPSim.scala 239:30:@1139.4]
  wire [32:0] SimBlackBoxesfix2fixBox_io_b; // @[BigIPSim.scala 239:30:@1139.4]
  SimBlackBoxesfix2fixBox_1 SimBlackBoxesfix2fixBox ( // @[BigIPSim.scala 239:30:@1139.4]
    .io_a(SimBlackBoxesfix2fixBox_io_a),
    .io_b(SimBlackBoxesfix2fixBox_io_b)
  );
  assign io_result = SimBlackBoxesfix2fixBox_io_b; // @[Math.scala 706:17:@1152.4]
  assign SimBlackBoxesfix2fixBox_io_a = io_b; // @[BigIPSim.scala 241:23:@1147.4]
endmodule
module RetimeWrapper_13( // @[:@1206.2]
  input         clock, // @[:@1207.4]
  input         reset, // @[:@1208.4]
  input  [31:0] io_in, // @[:@1209.4]
  output [31:0] io_out // @[:@1209.4]
);
  wire [31:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@1211.4]
  wire [31:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@1211.4]
  wire [31:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@1211.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@1211.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@1211.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@1211.4]
  RetimeShiftRegister #(.WIDTH(32), .STAGES(1)) sr ( // @[RetimeShiftRegister.scala 15:20:@1211.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@1224.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@1223.4]
  assign sr_init = 32'h0; // @[RetimeShiftRegister.scala 19:16:@1222.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@1221.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@1220.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@1218.4]
endmodule
module fix2fixBox( // @[:@1226.2]
  input         clock, // @[:@1227.4]
  input         reset, // @[:@1228.4]
  input  [32:0] io_a, // @[:@1229.4]
  output [31:0] io_b // @[:@1229.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1239.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1239.4]
  wire [31:0] RetimeWrapper_io_in; // @[package.scala 93:22:@1239.4]
  wire [31:0] RetimeWrapper_io_out; // @[package.scala 93:22:@1239.4]
  RetimeWrapper_13 RetimeWrapper ( // @[package.scala 93:22:@1239.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  assign io_b = RetimeWrapper_io_out; // @[Converter.scala 95:38:@1246.4]
  assign RetimeWrapper_clock = clock; // @[:@1240.4]
  assign RetimeWrapper_reset = reset; // @[:@1241.4]
  assign RetimeWrapper_io_in = io_a[31:0]; // @[package.scala 94:16:@1242.4]
endmodule
module x59_sum( // @[:@1248.2]
  input         clock, // @[:@1249.4]
  input         reset, // @[:@1250.4]
  input  [31:0] io_a, // @[:@1251.4]
  output [31:0] io_result // @[:@1251.4]
);
  wire [31:0] __io_b; // @[Math.scala 709:24:@1259.4]
  wire [32:0] __io_result; // @[Math.scala 709:24:@1259.4]
  wire [31:0] __1_io_b; // @[Math.scala 709:24:@1266.4]
  wire [32:0] __1_io_result; // @[Math.scala 709:24:@1266.4]
  wire  fix2fixBox_clock; // @[Math.scala 141:30:@1284.4]
  wire  fix2fixBox_reset; // @[Math.scala 141:30:@1284.4]
  wire [32:0] fix2fixBox_io_a; // @[Math.scala 141:30:@1284.4]
  wire [31:0] fix2fixBox_io_b; // @[Math.scala 141:30:@1284.4]
  wire [32:0] a_upcast_number; // @[Math.scala 712:22:@1264.4 Math.scala 713:14:@1265.4]
  wire [32:0] b_upcast_number; // @[Math.scala 712:22:@1271.4 Math.scala 713:14:@1272.4]
  wire [33:0] _T_21; // @[Math.scala 136:37:@1273.4]
  __1 _ ( // @[Math.scala 709:24:@1259.4]
    .io_b(__io_b),
    .io_result(__io_result)
  );
  __1 __1 ( // @[Math.scala 709:24:@1266.4]
    .io_b(__1_io_b),
    .io_result(__1_io_result)
  );
  fix2fixBox fix2fixBox ( // @[Math.scala 141:30:@1284.4]
    .clock(fix2fixBox_clock),
    .reset(fix2fixBox_reset),
    .io_a(fix2fixBox_io_a),
    .io_b(fix2fixBox_io_b)
  );
  assign a_upcast_number = __io_result; // @[Math.scala 712:22:@1264.4 Math.scala 713:14:@1265.4]
  assign b_upcast_number = __1_io_result; // @[Math.scala 712:22:@1271.4 Math.scala 713:14:@1272.4]
  assign _T_21 = a_upcast_number + b_upcast_number; // @[Math.scala 136:37:@1273.4]
  assign io_result = fix2fixBox_io_b; // @[Math.scala 147:17:@1292.4]
  assign __io_b = io_a; // @[Math.scala 710:17:@1262.4]
  assign __1_io_b = 32'h1; // @[Math.scala 710:17:@1269.4]
  assign fix2fixBox_clock = clock; // @[:@1285.4]
  assign fix2fixBox_reset = reset; // @[:@1286.4]
  assign fix2fixBox_io_a = a_upcast_number + b_upcast_number; // @[Math.scala 142:23:@1287.4]
endmodule
module RetimeWrapper_17( // @[:@1402.2]
  input   clock, // @[:@1403.4]
  input   reset, // @[:@1404.4]
  input   io_in // @[:@1405.4]
);
  wire  sr_out; // @[RetimeShiftRegister.scala 15:20:@1407.4]
  wire  sr_in; // @[RetimeShiftRegister.scala 15:20:@1407.4]
  wire  sr_init; // @[RetimeShiftRegister.scala 15:20:@1407.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@1407.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@1407.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@1407.4]
  RetimeShiftRegister #(.WIDTH(1), .STAGES(2)) sr ( // @[RetimeShiftRegister.scala 15:20:@1407.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@1419.4]
  assign sr_init = 1'h0; // @[RetimeShiftRegister.scala 19:16:@1418.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@1417.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@1416.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@1414.4]
endmodule
module RetimeWrapper_18( // @[:@1434.2]
  input         clock, // @[:@1435.4]
  input         reset, // @[:@1436.4]
  input  [31:0] io_in, // @[:@1437.4]
  output [31:0] io_out // @[:@1437.4]
);
  wire [31:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@1439.4]
  wire [31:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@1439.4]
  wire [31:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@1439.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@1439.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@1439.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@1439.4]
  RetimeShiftRegister #(.WIDTH(32), .STAGES(16)) sr ( // @[RetimeShiftRegister.scala 15:20:@1439.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@1452.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@1451.4]
  assign sr_init = 32'h0; // @[RetimeShiftRegister.scala 19:16:@1450.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@1449.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@1448.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@1446.4]
endmodule
module fix2fixBox_1( // @[:@1454.2]
  input  [63:0] io_a, // @[:@1457.4]
  output [31:0] io_b // @[:@1457.4]
);
  assign io_b = io_a[31:0]; // @[Converter.scala 95:38:@1467.4]
endmodule
module x63( // @[:@1469.2]
  input         clock, // @[:@1470.4]
  input         reset, // @[:@1471.4]
  input  [31:0] io_a, // @[:@1472.4]
  output [31:0] io_result // @[:@1472.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1481.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1481.4]
  wire [31:0] RetimeWrapper_io_in; // @[package.scala 93:22:@1481.4]
  wire [31:0] RetimeWrapper_io_out; // @[package.scala 93:22:@1481.4]
  wire [63:0] fix2fixBox_io_a; // @[Math.scala 357:30:@1489.4]
  wire [31:0] fix2fixBox_io_b; // @[Math.scala 357:30:@1489.4]
  wire [31:0] _T_19; // @[package.scala 96:25:@1486.4 package.scala 96:25:@1487.4]
  wire [31:0] _GEN_0; // @[package.scala 94:16:@1484.4]
  RetimeWrapper_18 RetimeWrapper ( // @[package.scala 93:22:@1481.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  fix2fixBox_1 fix2fixBox ( // @[Math.scala 357:30:@1489.4]
    .io_a(fix2fixBox_io_a),
    .io_b(fix2fixBox_io_b)
  );
  assign _T_19 = RetimeWrapper_io_out; // @[package.scala 96:25:@1486.4 package.scala 96:25:@1487.4]
  assign io_result = fix2fixBox_io_b; // @[Math.scala 363:17:@1497.4]
  assign RetimeWrapper_clock = clock; // @[:@1482.4]
  assign RetimeWrapper_reset = reset; // @[:@1483.4]
  assign _GEN_0 = io_a % 32'h5; // @[package.scala 94:16:@1484.4]
  assign RetimeWrapper_io_in = _GEN_0[31:0]; // @[package.scala 94:16:@1484.4]
  assign fix2fixBox_io_a = {{32'd0}, _T_19}; // @[Math.scala 358:23:@1492.4]
endmodule
module RetimeWrapper_19( // @[:@1511.2]
  input        clock, // @[:@1512.4]
  input        reset, // @[:@1513.4]
  input  [7:0] io_in, // @[:@1514.4]
  output [7:0] io_out // @[:@1514.4]
);
  wire [7:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@1516.4]
  wire [7:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@1516.4]
  wire [7:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@1516.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@1516.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@1516.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@1516.4]
  RetimeShiftRegister #(.WIDTH(8), .STAGES(1)) sr ( // @[RetimeShiftRegister.scala 15:20:@1516.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@1529.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@1528.4]
  assign sr_init = 8'h0; // @[RetimeShiftRegister.scala 19:16:@1527.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@1526.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@1525.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@1523.4]
endmodule
module RetimeWrapper_20( // @[:@1543.2]
  input        clock, // @[:@1544.4]
  input        reset, // @[:@1545.4]
  input  [7:0] io_in, // @[:@1546.4]
  output [7:0] io_out // @[:@1546.4]
);
  wire [7:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@1548.4]
  wire [7:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@1548.4]
  wire [7:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@1548.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@1548.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@1548.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@1548.4]
  RetimeShiftRegister #(.WIDTH(8), .STAGES(17)) sr ( // @[RetimeShiftRegister.scala 15:20:@1548.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@1561.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@1560.4]
  assign sr_init = 8'h0; // @[RetimeShiftRegister.scala 19:16:@1559.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@1558.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@1557.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@1555.4]
endmodule
module RetimeShiftRegister
#(
    parameter WIDTH = 1,
    parameter STAGES = 1)
(
    input clock,
    input reset,
    input flow,
    input [WIDTH-1:0] init,
    input [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);
  integer i;
  reg [WIDTH-1:0] sr[STAGES]; // Create 'STAGES' number of register, each 'WIDTH' bits wide

   /* synopsys dc_tcl_script_begin
    set_ungroup [current_design] true
    set_flatten true -effort high -phase true -design [current_design]
    set_dont_retime [current_design] false
    set_optimize_registers true -design [current_design]
    */
  always @(posedge clock) begin
    if (reset) begin
      for(i=0; i<STAGES; i=i+1) begin
        sr[i] <= init;
      end
    end else begin
      if (flow) begin 
        sr[0] <= in;
        for(i=1; i<STAGES; i=i+1) begin
          sr[i] <= sr[i-1];
        end
      end
    end
  end

  always @(*) begin
    out = sr[STAGES-1];
  end
endmodule

