module Module_0(
  input CLK/*verilator public*/, 
  input [7:0] I/*verilator public*/, 
  output [7:0] O/*verilator public*/, 
  output valid_down/*verilator public*/, 
  input valid_up/*verilator public*/
);
  x27_inr_Foreach_kernelx27_inr_Foreach_concrete1 sampler_box ( // @[m_x55_ctr_0.scala 26:17:@1721.4]
    .clock(CLK), // @[:@1296.4]
    .reset('b0), // @[:@1297.4]
    .io_in_x17_ready(), // @[:@1298.4]
    .io_in_x17_bits(I), // @[:@1298.4]
    .io_in_x18_valid(valid_down), // @[:@1298.4]
    .io_in_x18_bits(O), // @[:@1298.4]
    .io_sigsIn_datapathEn(valid_up), // @[:@1298.4]
    .io_sigsIn_cchainOutputs_0_oobs_0('b0), // @[:@1298.4]
    .io_rr('b1) // @[:@1298.4]
  );
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
  assign _T_57 = $signed(_T_52) >= $signed(32'sh2); // @[Counter.scala 285:18:@106.4]
  assign _T_68 = $unsigned(_T_48); // @[Counter.scala 291:115:@114.4]
  assign _T_71 = $unsigned(_T_52); // @[Counter.scala 291:152:@117.4]
  assign _T_72 = _T_57 ? _T_68 : _T_71; // @[Counter.scala 291:74:@118.4]
  assign io_output_done = $signed(_T_52) >= $signed(32'sh2); // @[Counter.scala 325:20:@127.4]
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
module x20_ctrchain( // @[:@562.2]
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
  RetimeShiftRegister #(.WIDTH(1), .STAGES(2)) sr ( // @[RetimeShiftRegister.scala 15:20:@639.4]
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
module RetimeWrapper_13( // @[:@1048.2]
  input        clock, // @[:@1049.4]
  input        reset, // @[:@1050.4]
  input  [7:0] io_in, // @[:@1051.4]
  output [7:0] io_out // @[:@1051.4]
);
  wire [7:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  wire [7:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  wire [7:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  RetimeShiftRegister #(.WIDTH(8), .STAGES(1)) sr ( // @[RetimeShiftRegister.scala 15:20:@1053.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@1066.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@1065.4]
  assign sr_init = 8'h0; // @[RetimeShiftRegister.scala 19:16:@1064.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@1063.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@1062.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@1060.4]
endmodule
module RetimeWrapper_14( // @[:@1080.2]
  input         clock, // @[:@1081.4]
  input         reset, // @[:@1082.4]
  input  [15:0] io_in, // @[:@1083.4]
  output [15:0] io_out // @[:@1083.4]
);
  wire [15:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@1085.4]
  wire [15:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@1085.4]
  wire [15:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@1085.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@1085.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@1085.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@1085.4]
  RetimeShiftRegister #(.WIDTH(16), .STAGES(1)) sr ( // @[RetimeShiftRegister.scala 15:20:@1085.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@1098.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@1097.4]
  assign sr_init = 16'h0; // @[RetimeShiftRegister.scala 19:16:@1096.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@1095.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@1094.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@1092.4]
endmodule
module fix2fixBox( // @[:@1164.2]
  input  [7:0] io_a, // @[:@1167.4]
  output [7:0] io_b // @[:@1167.4]
);
  assign io_b = io_a; // @[Converter.scala 95:38:@1177.4]
endmodule
module x25_mul( // @[:@1179.2]
  input        clock, // @[:@1180.4]
  input        reset, // @[:@1181.4]
  input  [7:0] io_a, // @[:@1182.4]
  output [7:0] io_result // @[:@1182.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1190.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1190.4]
  wire [15:0] RetimeWrapper_io_in; // @[package.scala 93:22:@1190.4]
  wire [15:0] RetimeWrapper_io_out; // @[package.scala 93:22:@1190.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@1203.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@1203.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@1203.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@1203.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@1203.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@1214.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@1214.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@1214.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@1214.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@1214.4]
  wire [7:0] fix2fixBox_io_a; // @[Math.scala 253:30:@1221.4]
  wire [7:0] fix2fixBox_io_b; // @[Math.scala 253:30:@1221.4]
  wire [15:0] _T_18; // @[package.scala 96:25:@1195.4 package.scala 96:25:@1196.4]
  wire  _T_21; // @[FixedPoint.scala 50:25:@1200.4]
  RetimeWrapper_14 RetimeWrapper ( // @[package.scala 93:22:@1190.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@1203.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@1214.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  fix2fixBox fix2fixBox ( // @[Math.scala 253:30:@1221.4]
    .io_a(fix2fixBox_io_a),
    .io_b(fix2fixBox_io_b)
  );
  assign _T_18 = RetimeWrapper_io_out; // @[package.scala 96:25:@1195.4 package.scala 96:25:@1196.4]
  assign _T_21 = io_a[7]; // @[FixedPoint.scala 50:25:@1200.4]
  assign io_result = fix2fixBox_io_b; // @[Math.scala 259:17:@1229.4]
  assign RetimeWrapper_clock = clock; // @[:@1191.4]
  assign RetimeWrapper_reset = reset; // @[:@1192.4]
  assign RetimeWrapper_io_in = io_a * 8'h5; // @[package.scala 94:16:@1193.4]
  assign RetimeWrapper_1_clock = clock; // @[:@1204.4]
  assign RetimeWrapper_1_reset = reset; // @[:@1205.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@1207.4]
  assign RetimeWrapper_1_io_in = io_a[7]; // @[package.scala 94:16:@1206.4]
  assign RetimeWrapper_2_clock = clock; // @[:@1215.4]
  assign RetimeWrapper_2_reset = reset; // @[:@1216.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@1218.4]
  assign RetimeWrapper_2_io_in = _T_21 == 1'h0; // @[package.scala 94:16:@1217.4]
  assign fix2fixBox_io_a = _T_18[7:0]; // @[Math.scala 254:23:@1224.4]
endmodule
module x27_inr_Foreach_kernelx27_inr_Foreach_concrete1( // @[:@1295.2]
  input        clock, // @[:@1296.4]
  input        reset, // @[:@1297.4]
  output       io_in_x17_ready, // @[:@1298.4]
  input  [7:0] io_in_x17_bits, // @[:@1298.4]
  output       io_in_x18_valid, // @[:@1298.4]
  output [7:0] io_in_x18_bits, // @[:@1298.4]
  input        io_sigsIn_datapathEn, // @[:@1298.4]
  input        io_sigsIn_cchainOutputs_0_oobs_0, // @[:@1298.4]
  input        io_rr // @[:@1298.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1326.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1326.4]
  wire [7:0] RetimeWrapper_io_in; // @[package.scala 93:22:@1326.4]
  wire [7:0] RetimeWrapper_io_out; // @[package.scala 93:22:@1326.4]
  wire  x25_mul_1_clock; // @[Math.scala 262:24:@1339.4]
  wire  x25_mul_1_reset; // @[Math.scala 262:24:@1339.4]
  wire [7:0] x25_mul_1_io_a; // @[Math.scala 262:24:@1339.4]
  wire [7:0] x25_mul_1_io_result; // @[Math.scala 262:24:@1339.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@1349.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@1349.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@1349.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@1349.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@1358.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@1358.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@1358.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@1358.4]
  wire  b22; // @[sm_x27_inr_Foreach.scala 60:17:@1320.4]
  wire  _T_171; // @[package.scala 96:25:@1363.4 package.scala 96:25:@1364.4]
  wire  _T_173; // @[implicits.scala 55:10:@1365.4]
  wire  x29_b22_D2; // @[package.scala 96:25:@1354.4 package.scala 96:25:@1355.4]
  RetimeWrapper_13 RetimeWrapper ( // @[package.scala 93:22:@1326.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  x25_mul x25_mul_1 ( // @[Math.scala 262:24:@1339.4]
    .clock(x25_mul_1_clock),
    .reset(x25_mul_1_reset),
    .io_a(x25_mul_1_io_a),
    .io_result(x25_mul_1_io_result)
  );
  RetimeWrapper_5 RetimeWrapper_1 ( // @[package.scala 93:22:@1349.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RetimeWrapper_5 RetimeWrapper_2 ( // @[package.scala 93:22:@1358.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  assign b22 = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[sm_x27_inr_Foreach.scala 60:17:@1320.4]
  assign _T_171 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@1363.4 package.scala 96:25:@1364.4]
  assign _T_173 = io_rr ? _T_171 : 1'h0; // @[implicits.scala 55:10:@1365.4]
  assign x29_b22_D2 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@1354.4 package.scala 96:25:@1355.4]
  assign io_in_x17_ready = b22 & io_sigsIn_datapathEn; // @[sm_x27_inr_Foreach.scala 62:17:@1323.4]
  assign io_in_x18_valid = _T_173 & x29_b22_D2; // @[sm_x27_inr_Foreach.scala 72:17:@1368.4]
  assign io_in_x18_bits = x25_mul_1_io_result; // @[sm_x27_inr_Foreach.scala 73:16:@1369.4]
  assign RetimeWrapper_clock = clock; // @[:@1327.4]
  assign RetimeWrapper_reset = reset; // @[:@1328.4]
  assign RetimeWrapper_io_in = io_in_x17_bits; // @[package.scala 94:16:@1329.4]
  assign x25_mul_1_clock = clock; // @[:@1340.4]
  assign x25_mul_1_reset = reset; // @[:@1341.4]
  assign x25_mul_1_io_a = RetimeWrapper_io_out; // @[Math.scala 263:17:@1342.4]
  assign RetimeWrapper_1_clock = clock; // @[:@1350.4]
  assign RetimeWrapper_1_reset = reset; // @[:@1351.4]
  assign RetimeWrapper_1_io_in = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[package.scala 94:16:@1352.4]
  assign RetimeWrapper_2_clock = clock; // @[:@1359.4]
  assign RetimeWrapper_2_reset = reset; // @[:@1360.4]
  assign RetimeWrapper_2_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@1361.4]
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

