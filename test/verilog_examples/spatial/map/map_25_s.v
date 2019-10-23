// Latency = 3
module top(
  input CLK/*verilator public*/, 
  input [7:0]  I_0 /*verilator public*/, 
  input [7:0]  I_1 /*verilator public*/, 
  input [7:0]  I_2 /*verilator public*/, 
  input [7:0]  I_3 /*verilator public*/, 
  input [7:0]  I_4 /*verilator public*/, 
  input [7:0]  I_5 /*verilator public*/, 
  input [7:0]  I_6 /*verilator public*/, 
  input [7:0]  I_7 /*verilator public*/, 
  output [7:0] O_0 /*verilator public*/, 
  output [7:0] O_1 /*verilator public*/, 
  output [7:0] O_2 /*verilator public*/, 
  output [7:0] O_3 /*verilator public*/, 
  output [7:0] O_4 /*verilator public*/, 
  output [7:0] O_5 /*verilator public*/, 
  output [7:0] O_6 /*verilator public*/, 
  output [7:0] O_7 /*verilator public*/, 
  output valid_down/*verilator public*/, 
  input valid_up/*verilator public*/
);
  wire dontcare;
  x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1 sampler_box ( // @[m_x55_ctr_0.scala 26:17:@1721.4]
    .clock(CLK), // @[:@1296.4]
    .reset('b0), // @[:@1297.4]
    .io_in_x17_TREADY(dontcare), // @[:@1298.4]
    .io_in_x17_TDATA({I_0,I_1,I_2,I_3,I_4,I_5,I_6,I_7}), // @[:@1298.4]
    .io_in_x18_TVALID(valid_down), // @[:@1298.4]
    .io_in_x18_TDATA({O_0,O_1,O_2,O_3,O_4,O_5,O_6,O_7}), // @[:@1298.4]
    .io_sigsIn_datapathEn(valid_up), // @[:@1298.4]
    .io_sigsIn_cchainOutputs_0_oobs_0('b0), // @[:@1298.4]
    .io_rr('b1) // @[:@1298.4]
  );
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
  assign _T_57 = $signed(_T_52) >= $signed(32'sh3); // @[Counter.scala 285:18:@106.4]
  assign _T_68 = $unsigned(_T_48); // @[Counter.scala 291:115:@114.4]
  assign _T_71 = $unsigned(_T_52); // @[Counter.scala 291:152:@117.4]
  assign _T_72 = _T_57 ? _T_68 : _T_71; // @[Counter.scala 291:74:@118.4]
  assign io_output_done = $signed(_T_52) >= $signed(32'sh3); // @[Counter.scala 325:20:@127.4]
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
module RootController_sm( // @[:@312.2]
  input   clock, // @[:@313.4]
  input   reset, // @[:@314.4]
  input   io_enable, // @[:@315.4]
  output  io_done, // @[:@315.4]
  input   io_rst, // @[:@315.4]
  input   io_ctrDone, // @[:@315.4]
  output  io_ctrInc, // @[:@315.4]
  input   io_doneIn_0, // @[:@315.4]
  output  io_enableOut_0, // @[:@315.4]
  output  io_childAck_0 // @[:@315.4]
);
  wire  active_0_clock; // @[Controllers.scala 76:50:@318.4]
  wire  active_0_reset; // @[Controllers.scala 76:50:@318.4]
  wire  active_0_io_input_set; // @[Controllers.scala 76:50:@318.4]
  wire  active_0_io_input_reset; // @[Controllers.scala 76:50:@318.4]
  wire  active_0_io_input_asyn_reset; // @[Controllers.scala 76:50:@318.4]
  wire  active_0_io_output; // @[Controllers.scala 76:50:@318.4]
  wire  done_0_clock; // @[Controllers.scala 77:48:@321.4]
  wire  done_0_reset; // @[Controllers.scala 77:48:@321.4]
  wire  done_0_io_input_set; // @[Controllers.scala 77:48:@321.4]
  wire  done_0_io_input_reset; // @[Controllers.scala 77:48:@321.4]
  wire  done_0_io_input_asyn_reset; // @[Controllers.scala 77:48:@321.4]
  wire  done_0_io_output; // @[Controllers.scala 77:48:@321.4]
  wire  iterDone_0_clock; // @[Controllers.scala 90:52:@338.4]
  wire  iterDone_0_reset; // @[Controllers.scala 90:52:@338.4]
  wire  iterDone_0_io_input_set; // @[Controllers.scala 90:52:@338.4]
  wire  iterDone_0_io_input_reset; // @[Controllers.scala 90:52:@338.4]
  wire  iterDone_0_io_input_asyn_reset; // @[Controllers.scala 90:52:@338.4]
  wire  iterDone_0_io_output; // @[Controllers.scala 90:52:@338.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@357.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@357.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@357.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@357.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@357.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@416.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@416.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@416.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@416.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@416.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@433.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@433.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@433.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@433.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@433.4]
  wire  finished; // @[Controllers.scala 81:26:@324.4]
  wire  synchronize; // @[package.scala 96:25:@362.4 package.scala 96:25:@363.4]
  wire  _T_122; // @[Controllers.scala 128:33:@371.4]
  wire  _T_124; // @[Controllers.scala 128:54:@372.4]
  wire  _T_125; // @[Controllers.scala 128:52:@373.4]
  wire  _T_126; // @[Controllers.scala 128:66:@374.4]
  wire  _T_128; // @[Controllers.scala 128:98:@376.4]
  wire  _T_129; // @[Controllers.scala 128:96:@377.4]
  wire  _T_131; // @[Controllers.scala 128:123:@378.4]
  wire  _T_133; // @[Controllers.scala 129:48:@381.4]
  wire  _T_138; // @[Controllers.scala 130:52:@386.4]
  wire  _T_139; // @[Controllers.scala 130:50:@387.4]
  wire  _T_147; // @[Controllers.scala 130:129:@393.4]
  wire  _T_150; // @[Controllers.scala 131:45:@396.4]
  wire  _T_154; // @[Controllers.scala 213:68:@402.4]
  wire  _T_156; // @[Controllers.scala 213:90:@404.4]
  wire  _T_158; // @[Controllers.scala 213:132:@406.4]
  wire  _T_159; // @[Controllers.scala 213:130:@407.4]
  wire  _T_160; // @[Controllers.scala 213:156:@408.4]
  reg  _T_166; // @[package.scala 48:56:@412.4]
  reg [31:0] _RAND_0;
  reg  _T_180; // @[package.scala 48:56:@430.4]
  reg [31:0] _RAND_1;
  SRFF active_0 ( // @[Controllers.scala 76:50:@318.4]
    .clock(active_0_clock),
    .reset(active_0_reset),
    .io_input_set(active_0_io_input_set),
    .io_input_reset(active_0_io_input_reset),
    .io_input_asyn_reset(active_0_io_input_asyn_reset),
    .io_output(active_0_io_output)
  );
  SRFF done_0 ( // @[Controllers.scala 77:48:@321.4]
    .clock(done_0_clock),
    .reset(done_0_reset),
    .io_input_set(done_0_io_input_set),
    .io_input_reset(done_0_io_input_reset),
    .io_input_asyn_reset(done_0_io_input_asyn_reset),
    .io_output(done_0_io_output)
  );
  SRFF iterDone_0 ( // @[Controllers.scala 90:52:@338.4]
    .clock(iterDone_0_clock),
    .reset(iterDone_0_reset),
    .io_input_set(iterDone_0_io_input_set),
    .io_input_reset(iterDone_0_io_input_reset),
    .io_input_asyn_reset(iterDone_0_io_input_asyn_reset),
    .io_output(iterDone_0_io_output)
  );
  RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@357.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@416.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@433.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  assign finished = done_0_io_output | io_done; // @[Controllers.scala 81:26:@324.4]
  assign synchronize = RetimeWrapper_io_out; // @[package.scala 96:25:@362.4 package.scala 96:25:@363.4]
  assign _T_122 = done_0_io_output == 1'h0; // @[Controllers.scala 128:33:@371.4]
  assign _T_124 = io_ctrDone == 1'h0; // @[Controllers.scala 128:54:@372.4]
  assign _T_125 = _T_122 & _T_124; // @[Controllers.scala 128:52:@373.4]
  assign _T_126 = _T_125 & io_enable; // @[Controllers.scala 128:66:@374.4]
  assign _T_128 = ~ iterDone_0_io_output; // @[Controllers.scala 128:98:@376.4]
  assign _T_129 = _T_126 & _T_128; // @[Controllers.scala 128:96:@377.4]
  assign _T_131 = io_doneIn_0 == 1'h0; // @[Controllers.scala 128:123:@378.4]
  assign _T_133 = io_doneIn_0 | io_rst; // @[Controllers.scala 129:48:@381.4]
  assign _T_138 = synchronize == 1'h0; // @[Controllers.scala 130:52:@386.4]
  assign _T_139 = io_doneIn_0 & _T_138; // @[Controllers.scala 130:50:@387.4]
  assign _T_147 = finished == 1'h0; // @[Controllers.scala 130:129:@393.4]
  assign _T_150 = io_rst == 1'h0; // @[Controllers.scala 131:45:@396.4]
  assign _T_154 = io_enable & active_0_io_output; // @[Controllers.scala 213:68:@402.4]
  assign _T_156 = _T_154 & _T_128; // @[Controllers.scala 213:90:@404.4]
  assign _T_158 = ~ done_0_io_output; // @[Controllers.scala 213:132:@406.4]
  assign _T_159 = _T_156 & _T_158; // @[Controllers.scala 213:130:@407.4]
  assign _T_160 = ~ io_ctrDone; // @[Controllers.scala 213:156:@408.4]
  assign io_done = RetimeWrapper_2_io_out; // @[Controllers.scala 245:13:@440.4]
  assign io_ctrInc = io_doneIn_0; // @[Controllers.scala 122:17:@356.4]
  assign io_enableOut_0 = _T_159 & _T_160; // @[Controllers.scala 213:55:@410.4]
  assign io_childAck_0 = iterDone_0_io_output; // @[Controllers.scala 212:58:@401.4]
  assign active_0_clock = clock; // @[:@319.4]
  assign active_0_reset = reset; // @[:@320.4]
  assign active_0_io_input_set = _T_129 & _T_131; // @[Controllers.scala 128:30:@380.4]
  assign active_0_io_input_reset = _T_133 | done_0_io_output; // @[Controllers.scala 129:32:@385.4]
  assign active_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 84:40:@326.4]
  assign done_0_clock = clock; // @[:@322.4]
  assign done_0_reset = reset; // @[:@323.4]
  assign done_0_io_input_set = io_ctrDone & _T_150; // @[Controllers.scala 131:28:@399.4]
  assign done_0_io_input_reset = io_rst | done_0_io_output; // @[Controllers.scala 86:33:@336.4]
  assign done_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 85:38:@327.4]
  assign iterDone_0_clock = clock; // @[:@339.4]
  assign iterDone_0_reset = reset; // @[:@340.4]
  assign iterDone_0_io_input_set = _T_139 & _T_147; // @[Controllers.scala 130:32:@395.4]
  assign iterDone_0_io_input_reset = synchronize | io_rst; // @[Controllers.scala 92:37:@350.4]
  assign iterDone_0_io_input_asyn_reset = 1'h0; // @[Controllers.scala 91:42:@341.4]
  assign RetimeWrapper_clock = clock; // @[:@358.4]
  assign RetimeWrapper_reset = reset; // @[:@359.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@361.4]
  assign RetimeWrapper_io_in = io_doneIn_0; // @[package.scala 94:16:@360.4]
  assign RetimeWrapper_1_clock = clock; // @[:@417.4]
  assign RetimeWrapper_1_reset = reset; // @[:@418.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@420.4]
  assign RetimeWrapper_1_io_in = done_0_io_output & _T_166; // @[package.scala 94:16:@419.4]
  assign RetimeWrapper_2_clock = clock; // @[:@434.4]
  assign RetimeWrapper_2_reset = reset; // @[:@435.4]
  assign RetimeWrapper_2_io_flow = io_enable; // @[package.scala 95:18:@437.4]
  assign RetimeWrapper_2_io_in = done_0_io_output & _T_180; // @[package.scala 94:16:@436.4]
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
  _T_166 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_180 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_166 <= 1'h0;
    end else begin
      _T_166 <= _T_122;
    end
    if (reset) begin
      _T_180 <= 1'h0;
    end else begin
      _T_180 <= _T_122;
    end
  end
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
  RetimeShiftRegister #(.WIDTH(1), .STAGES(3)) sr ( // @[RetimeShiftRegister.scala 15:20:@639.4]
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
  input   io_in // @[:@765.4]
);
  wire  sr_out; // @[RetimeShiftRegister.scala 15:20:@767.4]
  wire  sr_in; // @[RetimeShiftRegister.scala 15:20:@767.4]
  wire  sr_init; // @[RetimeShiftRegister.scala 15:20:@767.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@767.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@767.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@767.4]
  RetimeShiftRegister #(.WIDTH(1), .STAGES(2)) sr ( // @[RetimeShiftRegister.scala 15:20:@767.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@779.4]
  assign sr_init = 1'h0; // @[RetimeShiftRegister.scala 19:16:@778.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@777.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@776.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@774.4]
endmodule
module x27_inr_Foreach_SAMPLER_BOX_sm( // @[:@782.2]
  input   clock, // @[:@783.4]
  input   reset, // @[:@784.4]
  input   io_enable, // @[:@785.4]
  output  io_done, // @[:@785.4]
  input   io_ctrDone, // @[:@785.4]
  output  io_datapathEn, // @[:@785.4]
  output  io_ctrInc, // @[:@785.4]
  output  io_ctrRst, // @[:@785.4]
  input   io_parentAck // @[:@785.4]
);
  wire  active_clock; // @[Controllers.scala 261:22:@787.4]
  wire  active_reset; // @[Controllers.scala 261:22:@787.4]
  wire  active_io_input_set; // @[Controllers.scala 261:22:@787.4]
  wire  active_io_input_reset; // @[Controllers.scala 261:22:@787.4]
  wire  active_io_input_asyn_reset; // @[Controllers.scala 261:22:@787.4]
  wire  active_io_output; // @[Controllers.scala 261:22:@787.4]
  wire  done_clock; // @[Controllers.scala 262:20:@790.4]
  wire  done_reset; // @[Controllers.scala 262:20:@790.4]
  wire  done_io_input_set; // @[Controllers.scala 262:20:@790.4]
  wire  done_io_input_reset; // @[Controllers.scala 262:20:@790.4]
  wire  done_io_input_asyn_reset; // @[Controllers.scala 262:20:@790.4]
  wire  done_io_output; // @[Controllers.scala 262:20:@790.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@824.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@824.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@824.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@824.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@846.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@846.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@846.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@846.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@858.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@858.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@858.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@858.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@858.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@866.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@866.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@866.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@866.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@866.4]
  wire  RetimeWrapper_4_clock; // @[package.scala 93:22:@882.4]
  wire  RetimeWrapper_4_reset; // @[package.scala 93:22:@882.4]
  wire  RetimeWrapper_4_io_in; // @[package.scala 93:22:@882.4]
  wire  _T_80; // @[Controllers.scala 264:48:@795.4]
  wire  _T_81; // @[Controllers.scala 264:46:@796.4]
  wire  _T_82; // @[Controllers.scala 264:62:@797.4]
  wire  _T_100; // @[package.scala 100:49:@815.4]
  reg  _T_103; // @[package.scala 48:56:@816.4]
  reg [31:0] _RAND_0;
  wire  _T_108; // @[package.scala 96:25:@829.4 package.scala 96:25:@830.4]
  wire  _T_110; // @[package.scala 100:49:@831.4]
  reg  _T_113; // @[package.scala 48:56:@832.4]
  reg [31:0] _RAND_1;
  wire  _T_114; // @[package.scala 100:41:@834.4]
  wire  _T_118; // @[Controllers.scala 283:41:@839.4]
  wire  _T_124; // @[package.scala 96:25:@851.4 package.scala 96:25:@852.4]
  wire  _T_126; // @[package.scala 100:49:@853.4]
  reg  _T_129; // @[package.scala 48:56:@854.4]
  reg [31:0] _RAND_2;
  wire  _T_150; // @[package.scala 100:49:@878.4]
  reg  _T_153; // @[package.scala 48:56:@879.4]
  reg [31:0] _RAND_3;
  SRFF active ( // @[Controllers.scala 261:22:@787.4]
    .clock(active_clock),
    .reset(active_reset),
    .io_input_set(active_io_input_set),
    .io_input_reset(active_io_input_reset),
    .io_input_asyn_reset(active_io_input_asyn_reset),
    .io_output(active_io_output)
  );
  SRFF done ( // @[Controllers.scala 262:20:@790.4]
    .clock(done_clock),
    .reset(done_reset),
    .io_input_set(done_io_input_set),
    .io_input_reset(done_io_input_reset),
    .io_input_asyn_reset(done_io_input_asyn_reset),
    .io_output(done_io_output)
  );
  RetimeWrapper_5 RetimeWrapper ( // @[package.scala 93:22:@824.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  RetimeWrapper_5 RetimeWrapper_1 ( // @[package.scala 93:22:@846.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@858.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@866.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  RetimeWrapper_9 RetimeWrapper_4 ( // @[package.scala 93:22:@882.4]
    .clock(RetimeWrapper_4_clock),
    .reset(RetimeWrapper_4_reset),
    .io_in(RetimeWrapper_4_io_in)
  );
  assign _T_80 = ~ io_ctrDone; // @[Controllers.scala 264:48:@795.4]
  assign _T_81 = io_enable & _T_80; // @[Controllers.scala 264:46:@796.4]
  assign _T_82 = ~ done_io_output; // @[Controllers.scala 264:62:@797.4]
  assign _T_100 = io_ctrDone == 1'h0; // @[package.scala 100:49:@815.4]
  assign _T_108 = RetimeWrapper_io_out; // @[package.scala 96:25:@829.4 package.scala 96:25:@830.4]
  assign _T_110 = _T_108 == 1'h0; // @[package.scala 100:49:@831.4]
  assign _T_114 = _T_108 & _T_113; // @[package.scala 100:41:@834.4]
  assign _T_118 = active_io_output & _T_82; // @[Controllers.scala 283:41:@839.4]
  assign _T_124 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@851.4 package.scala 96:25:@852.4]
  assign _T_126 = _T_124 == 1'h0; // @[package.scala 100:49:@853.4]
  assign _T_150 = done_io_output == 1'h0; // @[package.scala 100:49:@878.4]
  assign io_done = _T_124 & _T_129; // @[Controllers.scala 287:13:@857.4]
  assign io_datapathEn = _T_118 & io_enable; // @[Controllers.scala 283:21:@842.4]
  assign io_ctrInc = active_io_output & io_enable; // @[Controllers.scala 284:17:@845.4]
  assign io_ctrRst = _T_114 | io_parentAck; // @[Controllers.scala 274:13:@837.4]
  assign active_clock = clock; // @[:@788.4]
  assign active_reset = reset; // @[:@789.4]
  assign active_io_input_set = _T_81 & _T_82; // @[Controllers.scala 264:23:@800.4]
  assign active_io_input_reset = io_ctrDone | io_parentAck; // @[Controllers.scala 265:25:@804.4]
  assign active_io_input_asyn_reset = 1'h0; // @[Controllers.scala 266:30:@805.4]
  assign done_clock = clock; // @[:@791.4]
  assign done_reset = reset; // @[:@792.4]
  assign done_io_input_set = io_ctrDone & _T_103; // @[Controllers.scala 269:104:@820.4]
  assign done_io_input_reset = io_parentAck; // @[Controllers.scala 267:23:@813.4]
  assign done_io_input_asyn_reset = 1'h0; // @[Controllers.scala 268:28:@814.4]
  assign RetimeWrapper_clock = clock; // @[:@825.4]
  assign RetimeWrapper_reset = reset; // @[:@826.4]
  assign RetimeWrapper_io_in = done_io_output; // @[package.scala 94:16:@827.4]
  assign RetimeWrapper_1_clock = clock; // @[:@847.4]
  assign RetimeWrapper_1_reset = reset; // @[:@848.4]
  assign RetimeWrapper_1_io_in = done_io_output; // @[package.scala 94:16:@849.4]
  assign RetimeWrapper_2_clock = clock; // @[:@859.4]
  assign RetimeWrapper_2_reset = reset; // @[:@860.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@862.4]
  assign RetimeWrapper_2_io_in = 1'h0; // @[package.scala 94:16:@861.4]
  assign RetimeWrapper_3_clock = clock; // @[:@867.4]
  assign RetimeWrapper_3_reset = reset; // @[:@868.4]
  assign RetimeWrapper_3_io_flow = 1'h1; // @[package.scala 95:18:@870.4]
  assign RetimeWrapper_3_io_in = io_ctrDone; // @[package.scala 94:16:@869.4]
  assign RetimeWrapper_4_clock = clock; // @[:@883.4]
  assign RetimeWrapper_4_reset = reset; // @[:@884.4]
  assign RetimeWrapper_4_io_in = done_io_output & _T_153; // @[package.scala 94:16:@885.4]
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
  _T_103 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_113 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_129 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_153 = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_103 <= 1'h0;
    end else begin
      _T_103 <= _T_100;
    end
    if (reset) begin
      _T_113 <= 1'h0;
    end else begin
      _T_113 <= _T_110;
    end
    if (reset) begin
      _T_129 <= 1'h0;
    end else begin
      _T_129 <= _T_126;
    end
    if (reset) begin
      _T_153 <= 1'h0;
    end else begin
      _T_153 <= _T_150;
    end
  end
endmodule
module RetimeWrapper_13( // @[:@1048.2]
  input         clock, // @[:@1049.4]
  input         reset, // @[:@1050.4]
  input  [63:0] io_in, // @[:@1051.4]
  output [63:0] io_out // @[:@1051.4]
);
  wire [63:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  wire [63:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  wire [63:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@1053.4]
  RetimeShiftRegister #(.WIDTH(64), .STAGES(1)) sr ( // @[RetimeShiftRegister.scala 15:20:@1053.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@1066.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@1065.4]
  assign sr_init = 64'h0; // @[RetimeShiftRegister.scala 19:16:@1064.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@1063.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@1062.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@1060.4]
endmodule
module SimBlackBoxesfix2fixBox_1( // @[:@1068.2]
  input  [63:0] io_a, // @[:@1071.4]
  output [64:0] io_b // @[:@1071.4]
);
  wire  _T_20; // @[implicits.scala 69:16:@1078.4]
  assign _T_20 = io_a[63]; // @[implicits.scala 69:16:@1078.4]
  assign io_b = {_T_20,io_a}; // @[SimBlackBoxes.scala 99:40:@1083.4]
endmodule
module __1( // @[:@1085.2]
  input  [63:0] io_b, // @[:@1088.4]
  output [64:0] io_result // @[:@1088.4]
);
  wire [63:0] SimBlackBoxesfix2fixBox_io_a; // @[BigIPSim.scala 239:30:@1093.4]
  wire [64:0] SimBlackBoxesfix2fixBox_io_b; // @[BigIPSim.scala 239:30:@1093.4]
  SimBlackBoxesfix2fixBox_1 SimBlackBoxesfix2fixBox ( // @[BigIPSim.scala 239:30:@1093.4]
    .io_a(SimBlackBoxesfix2fixBox_io_a),
    .io_b(SimBlackBoxesfix2fixBox_io_b)
  );
  assign io_result = SimBlackBoxesfix2fixBox_io_b; // @[Math.scala 706:17:@1106.4]
  assign SimBlackBoxesfix2fixBox_io_a = io_b; // @[BigIPSim.scala 241:23:@1101.4]
endmodule
module RetimeWrapper_14( // @[:@1160.2]
  input         clock, // @[:@1161.4]
  input         reset, // @[:@1162.4]
  input  [63:0] io_in, // @[:@1163.4]
  output [63:0] io_out // @[:@1163.4]
);
  wire [63:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@1165.4]
  wire [63:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@1165.4]
  wire [63:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@1165.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@1165.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@1165.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@1165.4]
  RetimeShiftRegister #(.WIDTH(64), .STAGES(2)) sr ( // @[RetimeShiftRegister.scala 15:20:@1165.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@1178.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@1177.4]
  assign sr_init = 64'h0; // @[RetimeShiftRegister.scala 19:16:@1176.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@1175.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@1174.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@1172.4]
endmodule
module fix2fixBox( // @[:@1180.2]
  input         clock, // @[:@1181.4]
  input         reset, // @[:@1182.4]
  input  [64:0] io_a, // @[:@1183.4]
  output [63:0] io_b // @[:@1183.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1193.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1193.4]
  wire [63:0] RetimeWrapper_io_in; // @[package.scala 93:22:@1193.4]
  wire [63:0] RetimeWrapper_io_out; // @[package.scala 93:22:@1193.4]
  RetimeWrapper_14 RetimeWrapper ( // @[package.scala 93:22:@1193.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  assign io_b = RetimeWrapper_io_out; // @[Converter.scala 95:38:@1200.4]
  assign RetimeWrapper_clock = clock; // @[:@1194.4]
  assign RetimeWrapper_reset = reset; // @[:@1195.4]
  assign RetimeWrapper_io_in = io_a[63:0]; // @[package.scala 94:16:@1196.4]
endmodule
module x25_sum( // @[:@1202.2]
  input         clock, // @[:@1203.4]
  input         reset, // @[:@1204.4]
  input  [63:0] io_b, // @[:@1205.4]
  output [63:0] io_result // @[:@1205.4]
);
  wire [63:0] __io_b; // @[Math.scala 709:24:@1213.4]
  wire [64:0] __io_result; // @[Math.scala 709:24:@1213.4]
  wire [63:0] __1_io_b; // @[Math.scala 709:24:@1220.4]
  wire [64:0] __1_io_result; // @[Math.scala 709:24:@1220.4]
  wire  fix2fixBox_clock; // @[Math.scala 141:30:@1238.4]
  wire  fix2fixBox_reset; // @[Math.scala 141:30:@1238.4]
  wire [64:0] fix2fixBox_io_a; // @[Math.scala 141:30:@1238.4]
  wire [63:0] fix2fixBox_io_b; // @[Math.scala 141:30:@1238.4]
  wire [64:0] a_upcast_number; // @[Math.scala 712:22:@1218.4 Math.scala 713:14:@1219.4]
  wire [64:0] b_upcast_number; // @[Math.scala 712:22:@1225.4 Math.scala 713:14:@1226.4]
  wire [65:0] _T_21; // @[Math.scala 136:37:@1227.4]
  __1 _ ( // @[Math.scala 709:24:@1213.4]
    .io_b(__io_b),
    .io_result(__io_result)
  );
  __1 __1 ( // @[Math.scala 709:24:@1220.4]
    .io_b(__1_io_b),
    .io_result(__1_io_result)
  );
  fix2fixBox fix2fixBox ( // @[Math.scala 141:30:@1238.4]
    .clock(fix2fixBox_clock),
    .reset(fix2fixBox_reset),
    .io_a(fix2fixBox_io_a),
    .io_b(fix2fixBox_io_b)
  );
  assign a_upcast_number = __io_result; // @[Math.scala 712:22:@1218.4 Math.scala 713:14:@1219.4]
  assign b_upcast_number = __1_io_result; // @[Math.scala 712:22:@1225.4 Math.scala 713:14:@1226.4]
  assign _T_21 = a_upcast_number + b_upcast_number; // @[Math.scala 136:37:@1227.4]
  assign io_result = fix2fixBox_io_b; // @[Math.scala 147:17:@1246.4]
  assign __io_b = 64'h5; // @[Math.scala 710:17:@1216.4]
  assign __1_io_b = io_b; // @[Math.scala 710:17:@1223.4]
  assign fix2fixBox_clock = clock; // @[:@1239.4]
  assign fix2fixBox_reset = reset; // @[:@1240.4]
  assign fix2fixBox_io_a = a_upcast_number + b_upcast_number; // @[Math.scala 142:23:@1241.4]
endmodule
module x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1( // @[:@1312.2]
  input          clock, // @[:@1313.4]
  input          reset, // @[:@1314.4]
  output         io_in_x17_TREADY, // @[:@1315.4]
  input  [255:0] io_in_x17_TDATA, // @[:@1315.4]
  output         io_in_x18_TVALID, // @[:@1315.4]
  output [255:0] io_in_x18_TDATA, // @[:@1315.4]
  input          io_sigsIn_datapathEn, // @[:@1315.4]
  input          io_sigsIn_cchainOutputs_0_oobs_0, // @[:@1315.4]
  input          io_rr // @[:@1315.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1343.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1343.4]
  wire [63:0] RetimeWrapper_io_in; // @[package.scala 93:22:@1343.4]
  wire [63:0] RetimeWrapper_io_out; // @[package.scala 93:22:@1343.4]
  wire  x25_sum_1_clock; // @[Math.scala 150:24:@1356.4]
  wire  x25_sum_1_reset; // @[Math.scala 150:24:@1356.4]
  wire [63:0] x25_sum_1_io_b; // @[Math.scala 150:24:@1356.4]
  wire [63:0] x25_sum_1_io_result; // @[Math.scala 150:24:@1356.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@1366.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@1366.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@1366.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@1366.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@1375.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@1375.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@1375.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@1375.4]
  wire  b22; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 61:17:@1337.4]
  wire  _T_209; // @[package.scala 96:25:@1380.4 package.scala 96:25:@1381.4]
  wire  _T_211; // @[implicits.scala 55:10:@1382.4]
  wire  x29_b22_D3; // @[package.scala 96:25:@1371.4 package.scala 96:25:@1372.4]
  RetimeWrapper_13 RetimeWrapper ( // @[package.scala 93:22:@1343.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  x25_sum x25_sum_1 ( // @[Math.scala 150:24:@1356.4]
    .clock(x25_sum_1_clock),
    .reset(x25_sum_1_reset),
    .io_b(x25_sum_1_io_b),
    .io_result(x25_sum_1_io_result)
  );
  RetimeWrapper_5 RetimeWrapper_1 ( // @[package.scala 93:22:@1366.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RetimeWrapper_5 RetimeWrapper_2 ( // @[package.scala 93:22:@1375.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  assign b22 = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 61:17:@1337.4]
  assign _T_209 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@1380.4 package.scala 96:25:@1381.4]
  assign _T_211 = io_rr ? _T_209 : 1'h0; // @[implicits.scala 55:10:@1382.4]
  assign x29_b22_D3 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@1371.4 package.scala 96:25:@1372.4]
  assign io_in_x17_TREADY = b22 & io_sigsIn_datapathEn; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 63:17:@1340.4]
  assign io_in_x18_TVALID = _T_211 & x29_b22_D3; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 73:17:@1385.4]
  assign io_in_x18_TDATA = {{192'd0}, x25_sum_1_io_result}; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 74:19:@1386.4]
  assign RetimeWrapper_clock = clock; // @[:@1344.4]
  assign RetimeWrapper_reset = reset; // @[:@1345.4]
  assign RetimeWrapper_io_in = io_in_x17_TDATA[63:0]; // @[package.scala 94:16:@1346.4]
  assign x25_sum_1_clock = clock; // @[:@1357.4]
  assign x25_sum_1_reset = reset; // @[:@1358.4]
  assign x25_sum_1_io_b = RetimeWrapper_io_out; // @[Math.scala 152:17:@1360.4]
  assign RetimeWrapper_1_clock = clock; // @[:@1367.4]
  assign RetimeWrapper_1_reset = reset; // @[:@1368.4]
  assign RetimeWrapper_1_io_in = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[package.scala 94:16:@1369.4]
  assign RetimeWrapper_2_clock = clock; // @[:@1376.4]
  assign RetimeWrapper_2_reset = reset; // @[:@1377.4]
  assign RetimeWrapper_2_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@1378.4]
endmodule
module RootController_kernelRootController_concrete1( // @[:@1396.2]
  input          clock, // @[:@1397.4]
  input          reset, // @[:@1398.4]
  output         io_in_x17_TREADY, // @[:@1399.4]
  input  [255:0] io_in_x17_TDATA, // @[:@1399.4]
  output         io_in_x18_TVALID, // @[:@1399.4]
  output [255:0] io_in_x18_TDATA, // @[:@1399.4]
  input          io_sigsIn_smEnableOuts_0, // @[:@1399.4]
  input          io_sigsIn_smChildAcks_0, // @[:@1399.4]
  output         io_sigsOut_smDoneIn_0, // @[:@1399.4]
  input          io_rr // @[:@1399.4]
);
  wire  x20_ctrchain_clock; // @[SpatialBlocks.scala 37:22:@1409.4]
  wire  x20_ctrchain_reset; // @[SpatialBlocks.scala 37:22:@1409.4]
  wire  x20_ctrchain_io_input_reset; // @[SpatialBlocks.scala 37:22:@1409.4]
  wire  x20_ctrchain_io_input_enable; // @[SpatialBlocks.scala 37:22:@1409.4]
  wire  x20_ctrchain_io_output_oobs_0; // @[SpatialBlocks.scala 37:22:@1409.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_sm_clock; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 32:18:@1461.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_sm_reset; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 32:18:@1461.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_sm_io_enable; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 32:18:@1461.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_sm_io_done; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 32:18:@1461.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_sm_io_ctrDone; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 32:18:@1461.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_sm_io_datapathEn; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 32:18:@1461.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_sm_io_ctrInc; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 32:18:@1461.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_sm_io_ctrRst; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 32:18:@1461.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_sm_io_parentAck; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 32:18:@1461.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1489.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1489.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@1489.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@1489.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@1489.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@1529.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@1529.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@1529.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@1529.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@1529.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@1537.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@1537.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@1537.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@1537.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@1537.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_clock; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 82:24:@1568.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_reset; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 82:24:@1568.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x17_TREADY; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 82:24:@1568.4]
  wire [255:0] x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x17_TDATA; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 82:24:@1568.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x18_TVALID; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 82:24:@1568.4]
  wire [255:0] x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x18_TDATA; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 82:24:@1568.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_datapathEn; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 82:24:@1568.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_cchainOutputs_0_oobs_0; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 82:24:@1568.4]
  wire  x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_rr; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 82:24:@1568.4]
  wire  _T_233; // @[package.scala 96:25:@1494.4 package.scala 96:25:@1495.4]
  wire  _T_248; // @[package.scala 96:25:@1534.4 package.scala 96:25:@1535.4]
  wire  _T_254; // @[package.scala 96:25:@1542.4 package.scala 96:25:@1543.4]
  wire  _T_257; // @[SpatialBlocks.scala 110:93:@1545.4]
  wire  _T_259; // @[SpatialBlocks.scala 128:36:@1554.4]
  wire  _T_260; // @[SpatialBlocks.scala 128:78:@1555.4]
  x20_ctrchain x20_ctrchain ( // @[SpatialBlocks.scala 37:22:@1409.4]
    .clock(x20_ctrchain_clock),
    .reset(x20_ctrchain_reset),
    .io_input_reset(x20_ctrchain_io_input_reset),
    .io_input_enable(x20_ctrchain_io_input_enable),
    .io_output_oobs_0(x20_ctrchain_io_output_oobs_0)
  );
  x27_inr_Foreach_SAMPLER_BOX_sm x27_inr_Foreach_SAMPLER_BOX_sm ( // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 32:18:@1461.4]
    .clock(x27_inr_Foreach_SAMPLER_BOX_sm_clock),
    .reset(x27_inr_Foreach_SAMPLER_BOX_sm_reset),
    .io_enable(x27_inr_Foreach_SAMPLER_BOX_sm_io_enable),
    .io_done(x27_inr_Foreach_SAMPLER_BOX_sm_io_done),
    .io_ctrDone(x27_inr_Foreach_SAMPLER_BOX_sm_io_ctrDone),
    .io_datapathEn(x27_inr_Foreach_SAMPLER_BOX_sm_io_datapathEn),
    .io_ctrInc(x27_inr_Foreach_SAMPLER_BOX_sm_io_ctrInc),
    .io_ctrRst(x27_inr_Foreach_SAMPLER_BOX_sm_io_ctrRst),
    .io_parentAck(x27_inr_Foreach_SAMPLER_BOX_sm_io_parentAck)
  );
  RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@1489.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@1529.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@1537.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1 x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1 ( // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 82:24:@1568.4]
    .clock(x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_clock),
    .reset(x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_reset),
    .io_in_x17_TREADY(x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x17_TREADY),
    .io_in_x17_TDATA(x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x17_TDATA),
    .io_in_x18_TVALID(x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x18_TVALID),
    .io_in_x18_TDATA(x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x18_TDATA),
    .io_sigsIn_datapathEn(x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_datapathEn),
    .io_sigsIn_cchainOutputs_0_oobs_0(x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_cchainOutputs_0_oobs_0),
    .io_rr(x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_rr)
  );
  assign _T_233 = RetimeWrapper_io_out; // @[package.scala 96:25:@1494.4 package.scala 96:25:@1495.4]
  assign _T_248 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@1534.4 package.scala 96:25:@1535.4]
  assign _T_254 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@1542.4 package.scala 96:25:@1543.4]
  assign _T_257 = ~ _T_254; // @[SpatialBlocks.scala 110:93:@1545.4]
  assign _T_259 = x27_inr_Foreach_SAMPLER_BOX_sm_io_datapathEn; // @[SpatialBlocks.scala 128:36:@1554.4]
  assign _T_260 = ~ x27_inr_Foreach_SAMPLER_BOX_sm_io_ctrDone; // @[SpatialBlocks.scala 128:78:@1555.4]
  assign io_in_x17_TREADY = x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x17_TREADY; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 48:22:@1623.4]
  assign io_in_x18_TVALID = x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x18_TVALID; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 49:22:@1633.4]
  assign io_in_x18_TDATA = x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x18_TDATA; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 49:22:@1631.4]
  assign io_sigsOut_smDoneIn_0 = x27_inr_Foreach_SAMPLER_BOX_sm_io_done; // @[SpatialBlocks.scala 127:53:@1552.4]
  assign x20_ctrchain_clock = clock; // @[:@1410.4]
  assign x20_ctrchain_reset = reset; // @[:@1411.4]
  assign x20_ctrchain_io_input_reset = x27_inr_Foreach_SAMPLER_BOX_sm_io_ctrRst; // @[SpatialBlocks.scala 130:103:@1567.4]
  assign x20_ctrchain_io_input_enable = x27_inr_Foreach_SAMPLER_BOX_sm_io_ctrInc; // @[SpatialBlocks.scala 104:75:@1522.4 SpatialBlocks.scala 130:45:@1566.4]
  assign x27_inr_Foreach_SAMPLER_BOX_sm_clock = clock; // @[:@1462.4]
  assign x27_inr_Foreach_SAMPLER_BOX_sm_reset = reset; // @[:@1463.4]
  assign x27_inr_Foreach_SAMPLER_BOX_sm_io_enable = _T_248 & _T_257; // @[SpatialBlocks.scala 112:18:@1549.4]
  assign x27_inr_Foreach_SAMPLER_BOX_sm_io_ctrDone = io_rr ? _T_233 : 1'h0; // @[sm_RootController.scala 65:49:@1497.4]
  assign x27_inr_Foreach_SAMPLER_BOX_sm_io_parentAck = io_sigsIn_smChildAcks_0; // @[SpatialBlocks.scala 114:21:@1551.4]
  assign RetimeWrapper_clock = clock; // @[:@1490.4]
  assign RetimeWrapper_reset = reset; // @[:@1491.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@1493.4]
  assign RetimeWrapper_io_in = 1'h0; // @[package.scala 94:16:@1492.4]
  assign RetimeWrapper_1_clock = clock; // @[:@1530.4]
  assign RetimeWrapper_1_reset = reset; // @[:@1531.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@1533.4]
  assign RetimeWrapper_1_io_in = io_sigsIn_smEnableOuts_0; // @[package.scala 94:16:@1532.4]
  assign RetimeWrapper_2_clock = clock; // @[:@1538.4]
  assign RetimeWrapper_2_reset = reset; // @[:@1539.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@1541.4]
  assign RetimeWrapper_2_io_in = x27_inr_Foreach_SAMPLER_BOX_sm_io_done; // @[package.scala 94:16:@1540.4]
  assign x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_clock = clock; // @[:@1569.4]
  assign x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_reset = reset; // @[:@1570.4]
  assign x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x17_TDATA = io_in_x17_TDATA; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 48:22:@1622.4]
  assign x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_datapathEn = _T_259 & _T_260; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 86:22:@1646.4]
  assign x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_cchainOutputs_0_oobs_0 = x20_ctrchain_io_output_oobs_0; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 86:22:@1638.4]
  assign x27_inr_Foreach_SAMPLER_BOX_kernelx27_inr_Foreach_SAMPLER_BOX_concrete1_io_rr = io_rr; // @[sm_x27_inr_Foreach_SAMPLER_BOX.scala 85:18:@1634.4]
endmodule
module AccelUnit( // @[:@1661.2]
  input          clock, // @[:@1662.4]
  input          reset, // @[:@1663.4]
  input          io_enable, // @[:@1664.4]
  output         io_done, // @[:@1664.4]
  input          io_reset, // @[:@1664.4]
  input          io_memStreams_loads_0_cmd_ready, // @[:@1664.4]
  output         io_memStreams_loads_0_cmd_valid, // @[:@1664.4]
  output [63:0]  io_memStreams_loads_0_cmd_bits_addr, // @[:@1664.4]
  output [31:0]  io_memStreams_loads_0_cmd_bits_size, // @[:@1664.4]
  output         io_memStreams_loads_0_data_ready, // @[:@1664.4]
  input          io_memStreams_loads_0_data_valid, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_0, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_1, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_2, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_3, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_4, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_5, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_6, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_7, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_8, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_9, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_10, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_11, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_12, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_13, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_14, // @[:@1664.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_15, // @[:@1664.4]
  input          io_memStreams_stores_0_cmd_ready, // @[:@1664.4]
  output         io_memStreams_stores_0_cmd_valid, // @[:@1664.4]
  output [63:0]  io_memStreams_stores_0_cmd_bits_addr, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_cmd_bits_size, // @[:@1664.4]
  input          io_memStreams_stores_0_data_ready, // @[:@1664.4]
  output         io_memStreams_stores_0_data_valid, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_0, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_1, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_2, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_3, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_4, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_5, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_6, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_7, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_8, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_9, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_10, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_11, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_12, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_13, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_14, // @[:@1664.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_15, // @[:@1664.4]
  output [15:0]  io_memStreams_stores_0_data_bits_wstrb, // @[:@1664.4]
  output         io_memStreams_stores_0_wresp_ready, // @[:@1664.4]
  input          io_memStreams_stores_0_wresp_valid, // @[:@1664.4]
  input          io_memStreams_stores_0_wresp_bits, // @[:@1664.4]
  input          io_memStreams_gathers_0_cmd_ready, // @[:@1664.4]
  output         io_memStreams_gathers_0_cmd_valid, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_0, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_1, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_2, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_3, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_4, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_5, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_6, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_7, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_8, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_9, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_10, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_11, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_12, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_13, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_14, // @[:@1664.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_15, // @[:@1664.4]
  output         io_memStreams_gathers_0_data_ready, // @[:@1664.4]
  input          io_memStreams_gathers_0_data_valid, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_0, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_1, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_2, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_3, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_4, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_5, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_6, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_7, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_8, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_9, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_10, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_11, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_12, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_13, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_14, // @[:@1664.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_15, // @[:@1664.4]
  input          io_memStreams_scatters_0_cmd_ready, // @[:@1664.4]
  output         io_memStreams_scatters_0_cmd_valid, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_0, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_1, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_2, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_3, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_4, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_5, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_6, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_7, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_8, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_9, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_10, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_11, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_12, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_13, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_14, // @[:@1664.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_15, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_0, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_1, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_2, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_3, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_4, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_5, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_6, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_7, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_8, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_9, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_10, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_11, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_12, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_13, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_14, // @[:@1664.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_15, // @[:@1664.4]
  output         io_memStreams_scatters_0_wresp_ready, // @[:@1664.4]
  input          io_memStreams_scatters_0_wresp_valid, // @[:@1664.4]
  input          io_memStreams_scatters_0_wresp_bits, // @[:@1664.4]
  input          io_axiStreamsIn_0_TVALID, // @[:@1664.4]
  output         io_axiStreamsIn_0_TREADY, // @[:@1664.4]
  input  [255:0] io_axiStreamsIn_0_TDATA, // @[:@1664.4]
  input  [31:0]  io_axiStreamsIn_0_TSTRB, // @[:@1664.4]
  input  [31:0]  io_axiStreamsIn_0_TKEEP, // @[:@1664.4]
  input          io_axiStreamsIn_0_TLAST, // @[:@1664.4]
  input  [7:0]   io_axiStreamsIn_0_TID, // @[:@1664.4]
  input  [7:0]   io_axiStreamsIn_0_TDEST, // @[:@1664.4]
  input  [31:0]  io_axiStreamsIn_0_TUSER, // @[:@1664.4]
  output         io_axiStreamsOut_0_TVALID, // @[:@1664.4]
  input          io_axiStreamsOut_0_TREADY, // @[:@1664.4]
  output [255:0] io_axiStreamsOut_0_TDATA, // @[:@1664.4]
  output [31:0]  io_axiStreamsOut_0_TSTRB, // @[:@1664.4]
  output [31:0]  io_axiStreamsOut_0_TKEEP, // @[:@1664.4]
  output         io_axiStreamsOut_0_TLAST, // @[:@1664.4]
  output [7:0]   io_axiStreamsOut_0_TID, // @[:@1664.4]
  output [7:0]   io_axiStreamsOut_0_TDEST, // @[:@1664.4]
  output [31:0]  io_axiStreamsOut_0_TUSER, // @[:@1664.4]
  output         io_heap_0_req_valid, // @[:@1664.4]
  output         io_heap_0_req_bits_allocDealloc, // @[:@1664.4]
  output [63:0]  io_heap_0_req_bits_sizeAddr, // @[:@1664.4]
  input          io_heap_0_resp_valid, // @[:@1664.4]
  input          io_heap_0_resp_bits_allocDealloc, // @[:@1664.4]
  input  [63:0]  io_heap_0_resp_bits_sizeAddr, // @[:@1664.4]
  input  [63:0]  io_argIns_0, // @[:@1664.4]
  input          io_argOuts_0_port_ready, // @[:@1664.4]
  output         io_argOuts_0_port_valid, // @[:@1664.4]
  output [63:0]  io_argOuts_0_port_bits, // @[:@1664.4]
  input  [63:0]  io_argOuts_0_echo // @[:@1664.4]
);
  wire  SingleCounter_clock; // @[Main.scala 29:32:@1822.4]
  wire  SingleCounter_reset; // @[Main.scala 29:32:@1822.4]
  wire  SingleCounter_io_input_reset; // @[Main.scala 29:32:@1822.4]
  wire  SingleCounter_io_output_done; // @[Main.scala 29:32:@1822.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1840.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1840.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@1840.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@1840.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@1840.4]
  wire  SRFF_clock; // @[Main.scala 33:28:@1849.4]
  wire  SRFF_reset; // @[Main.scala 33:28:@1849.4]
  wire  SRFF_io_input_set; // @[Main.scala 33:28:@1849.4]
  wire  SRFF_io_input_reset; // @[Main.scala 33:28:@1849.4]
  wire  SRFF_io_input_asyn_reset; // @[Main.scala 33:28:@1849.4]
  wire  SRFF_io_output; // @[Main.scala 33:28:@1849.4]
  wire  RootController_sm_clock; // @[sm_RootController.scala 32:18:@1887.4]
  wire  RootController_sm_reset; // @[sm_RootController.scala 32:18:@1887.4]
  wire  RootController_sm_io_enable; // @[sm_RootController.scala 32:18:@1887.4]
  wire  RootController_sm_io_done; // @[sm_RootController.scala 32:18:@1887.4]
  wire  RootController_sm_io_rst; // @[sm_RootController.scala 32:18:@1887.4]
  wire  RootController_sm_io_ctrDone; // @[sm_RootController.scala 32:18:@1887.4]
  wire  RootController_sm_io_ctrInc; // @[sm_RootController.scala 32:18:@1887.4]
  wire  RootController_sm_io_doneIn_0; // @[sm_RootController.scala 32:18:@1887.4]
  wire  RootController_sm_io_enableOut_0; // @[sm_RootController.scala 32:18:@1887.4]
  wire  RootController_sm_io_childAck_0; // @[sm_RootController.scala 32:18:@1887.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@1919.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@1919.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@1919.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@1919.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@1919.4]
  wire  RootController_kernelRootController_concrete1_clock; // @[sm_RootController.scala 74:24:@1978.4]
  wire  RootController_kernelRootController_concrete1_reset; // @[sm_RootController.scala 74:24:@1978.4]
  wire  RootController_kernelRootController_concrete1_io_in_x17_TREADY; // @[sm_RootController.scala 74:24:@1978.4]
  wire [255:0] RootController_kernelRootController_concrete1_io_in_x17_TDATA; // @[sm_RootController.scala 74:24:@1978.4]
  wire  RootController_kernelRootController_concrete1_io_in_x18_TVALID; // @[sm_RootController.scala 74:24:@1978.4]
  wire [255:0] RootController_kernelRootController_concrete1_io_in_x18_TDATA; // @[sm_RootController.scala 74:24:@1978.4]
  wire  RootController_kernelRootController_concrete1_io_sigsIn_smEnableOuts_0; // @[sm_RootController.scala 74:24:@1978.4]
  wire  RootController_kernelRootController_concrete1_io_sigsIn_smChildAcks_0; // @[sm_RootController.scala 74:24:@1978.4]
  wire  RootController_kernelRootController_concrete1_io_sigsOut_smDoneIn_0; // @[sm_RootController.scala 74:24:@1978.4]
  wire  RootController_kernelRootController_concrete1_io_rr; // @[sm_RootController.scala 74:24:@1978.4]
  wire  _T_593; // @[package.scala 96:25:@1845.4 package.scala 96:25:@1846.4]
  wire  _T_658; // @[Main.scala 35:50:@1915.4]
  wire  _T_659; // @[Main.scala 35:59:@1916.4]
  wire  _T_671; // @[package.scala 100:49:@1936.4]
  reg  _T_674; // @[package.scala 48:56:@1937.4]
  reg [31:0] _RAND_0;
  SingleCounter SingleCounter ( // @[Main.scala 29:32:@1822.4]
    .clock(SingleCounter_clock),
    .reset(SingleCounter_reset),
    .io_input_reset(SingleCounter_io_input_reset),
    .io_output_done(SingleCounter_io_output_done)
  );
  RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@1840.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  SRFF SRFF ( // @[Main.scala 33:28:@1849.4]
    .clock(SRFF_clock),
    .reset(SRFF_reset),
    .io_input_set(SRFF_io_input_set),
    .io_input_reset(SRFF_io_input_reset),
    .io_input_asyn_reset(SRFF_io_input_asyn_reset),
    .io_output(SRFF_io_output)
  );
  RootController_sm RootController_sm ( // @[sm_RootController.scala 32:18:@1887.4]
    .clock(RootController_sm_clock),
    .reset(RootController_sm_reset),
    .io_enable(RootController_sm_io_enable),
    .io_done(RootController_sm_io_done),
    .io_rst(RootController_sm_io_rst),
    .io_ctrDone(RootController_sm_io_ctrDone),
    .io_ctrInc(RootController_sm_io_ctrInc),
    .io_doneIn_0(RootController_sm_io_doneIn_0),
    .io_enableOut_0(RootController_sm_io_enableOut_0),
    .io_childAck_0(RootController_sm_io_childAck_0)
  );
  RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@1919.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RootController_kernelRootController_concrete1 RootController_kernelRootController_concrete1 ( // @[sm_RootController.scala 74:24:@1978.4]
    .clock(RootController_kernelRootController_concrete1_clock),
    .reset(RootController_kernelRootController_concrete1_reset),
    .io_in_x17_TREADY(RootController_kernelRootController_concrete1_io_in_x17_TREADY),
    .io_in_x17_TDATA(RootController_kernelRootController_concrete1_io_in_x17_TDATA),
    .io_in_x18_TVALID(RootController_kernelRootController_concrete1_io_in_x18_TVALID),
    .io_in_x18_TDATA(RootController_kernelRootController_concrete1_io_in_x18_TDATA),
    .io_sigsIn_smEnableOuts_0(RootController_kernelRootController_concrete1_io_sigsIn_smEnableOuts_0),
    .io_sigsIn_smChildAcks_0(RootController_kernelRootController_concrete1_io_sigsIn_smChildAcks_0),
    .io_sigsOut_smDoneIn_0(RootController_kernelRootController_concrete1_io_sigsOut_smDoneIn_0),
    .io_rr(RootController_kernelRootController_concrete1_io_rr)
  );
  assign _T_593 = RetimeWrapper_io_out; // @[package.scala 96:25:@1845.4 package.scala 96:25:@1846.4]
  assign _T_658 = io_enable & _T_593; // @[Main.scala 35:50:@1915.4]
  assign _T_659 = ~ SRFF_io_output; // @[Main.scala 35:59:@1916.4]
  assign _T_671 = RootController_sm_io_ctrInc == 1'h0; // @[package.scala 100:49:@1936.4]
  assign io_done = SRFF_io_output; // @[Main.scala 42:23:@1935.4]
  assign io_memStreams_loads_0_cmd_valid = 1'h0;
  assign io_memStreams_loads_0_cmd_bits_addr = 64'h0;
  assign io_memStreams_loads_0_cmd_bits_size = 32'h0;
  assign io_memStreams_loads_0_data_ready = 1'h0;
  assign io_memStreams_stores_0_cmd_valid = 1'h0;
  assign io_memStreams_stores_0_cmd_bits_addr = 64'h0;
  assign io_memStreams_stores_0_cmd_bits_size = 32'h0;
  assign io_memStreams_stores_0_data_valid = 1'h0;
  assign io_memStreams_stores_0_data_bits_wdata_0 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_1 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_2 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_3 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_4 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_5 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_6 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_7 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_8 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_9 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_10 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_11 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_12 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_13 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_14 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wdata_15 = 32'h0;
  assign io_memStreams_stores_0_data_bits_wstrb = 16'h0;
  assign io_memStreams_stores_0_wresp_ready = 1'h0;
  assign io_memStreams_gathers_0_cmd_valid = 1'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_0 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_1 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_2 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_3 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_4 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_5 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_6 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_7 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_8 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_9 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_10 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_11 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_12 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_13 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_14 = 64'h0;
  assign io_memStreams_gathers_0_cmd_bits_addr_15 = 64'h0;
  assign io_memStreams_gathers_0_data_ready = 1'h0;
  assign io_memStreams_scatters_0_cmd_valid = 1'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_0 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_1 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_2 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_3 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_4 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_5 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_6 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_7 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_8 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_9 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_10 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_11 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_12 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_13 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_14 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_addr_addr_15 = 64'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_0 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_1 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_2 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_3 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_4 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_5 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_6 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_7 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_8 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_9 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_10 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_11 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_12 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_13 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_14 = 32'h0;
  assign io_memStreams_scatters_0_cmd_bits_wdata_15 = 32'h0;
  assign io_memStreams_scatters_0_wresp_ready = 1'h0;
  assign io_axiStreamsIn_0_TREADY = RootController_kernelRootController_concrete1_io_in_x17_TREADY; // @[sm_RootController.scala 48:22:@2033.4]
  assign io_axiStreamsOut_0_TVALID = RootController_kernelRootController_concrete1_io_in_x18_TVALID; // @[sm_RootController.scala 49:22:@2043.4]
  assign io_axiStreamsOut_0_TDATA = RootController_kernelRootController_concrete1_io_in_x18_TDATA; // @[sm_RootController.scala 49:22:@2041.4]
  assign io_axiStreamsOut_0_TSTRB = 32'hffffffff; // @[sm_RootController.scala 49:22:@2040.4]
  assign io_axiStreamsOut_0_TKEEP = 32'hffffffff; // @[sm_RootController.scala 49:22:@2039.4]
  assign io_axiStreamsOut_0_TLAST = 1'h0; // @[sm_RootController.scala 49:22:@2038.4]
  assign io_axiStreamsOut_0_TID = 8'h0; // @[sm_RootController.scala 49:22:@2037.4]
  assign io_axiStreamsOut_0_TDEST = 8'h0; // @[sm_RootController.scala 49:22:@2036.4]
  assign io_axiStreamsOut_0_TUSER = 32'h4; // @[sm_RootController.scala 49:22:@2035.4]
  assign io_heap_0_req_valid = 1'h0;
  assign io_heap_0_req_bits_allocDealloc = 1'h0;
  assign io_heap_0_req_bits_sizeAddr = 64'h0;
  assign io_argOuts_0_port_valid = 1'h0;
  assign io_argOuts_0_port_bits = 64'h0;
  assign SingleCounter_clock = clock; // @[:@1823.4]
  assign SingleCounter_reset = reset; // @[:@1824.4]
  assign SingleCounter_io_input_reset = reset; // @[Main.scala 30:79:@1838.4]
  assign RetimeWrapper_clock = clock; // @[:@1841.4]
  assign RetimeWrapper_reset = reset; // @[:@1842.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@1844.4]
  assign RetimeWrapper_io_in = SingleCounter_io_output_done; // @[package.scala 94:16:@1843.4]
  assign SRFF_clock = clock; // @[:@1850.4]
  assign SRFF_reset = reset; // @[:@1851.4]
  assign SRFF_io_input_set = RootController_sm_io_done; // @[Main.scala 51:29:@2070.4]
  assign SRFF_io_input_reset = RetimeWrapper_1_io_out; // @[Main.scala 40:31:@1933.4]
  assign SRFF_io_input_asyn_reset = RetimeWrapper_1_io_out; // @[Main.scala 41:36:@1934.4]
  assign RootController_sm_clock = clock; // @[:@1888.4]
  assign RootController_sm_reset = reset; // @[:@1889.4]
  assign RootController_sm_io_enable = _T_658 & _T_659; // @[Main.scala 39:33:@1932.4 SpatialBlocks.scala 112:18:@1966.4]
  assign RootController_sm_io_rst = RetimeWrapper_1_io_out; // @[SpatialBlocks.scala 106:15:@1960.4]
  assign RootController_sm_io_ctrDone = RootController_sm_io_ctrInc & _T_674; // @[Main.scala 43:34:@1940.4]
  assign RootController_sm_io_doneIn_0 = RootController_kernelRootController_concrete1_io_sigsOut_smDoneIn_0; // @[SpatialBlocks.scala 102:67:@1957.4]
  assign RetimeWrapper_1_clock = clock; // @[:@1920.4]
  assign RetimeWrapper_1_reset = reset; // @[:@1921.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@1923.4]
  assign RetimeWrapper_1_io_in = reset | io_reset; // @[package.scala 94:16:@1922.4]
  assign RootController_kernelRootController_concrete1_clock = clock; // @[:@1979.4]
  assign RootController_kernelRootController_concrete1_reset = reset; // @[:@1980.4]
  assign RootController_kernelRootController_concrete1_io_in_x17_TDATA = io_axiStreamsIn_0_TDATA; // @[sm_RootController.scala 48:22:@2032.4]
  assign RootController_kernelRootController_concrete1_io_sigsIn_smEnableOuts_0 = RootController_sm_io_enableOut_0; // @[sm_RootController.scala 78:22:@2052.4]
  assign RootController_kernelRootController_concrete1_io_sigsIn_smChildAcks_0 = RootController_sm_io_childAck_0; // @[sm_RootController.scala 78:22:@2050.4]
  assign RootController_kernelRootController_concrete1_io_rr = RetimeWrapper_io_out; // @[sm_RootController.scala 77:18:@2044.4]
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
  _T_674 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_674 <= 1'h0;
    end else begin
      _T_674 <= _T_671;
    end
  end
endmodule
module SpatialIP( // @[:@2072.2]
  input         clock, // @[:@2073.4]
  input         reset, // @[:@2074.4]
  input  [31:0] io_raddr, // @[:@2075.4]
  input         io_wen, // @[:@2075.4]
  input  [31:0] io_waddr, // @[:@2075.4]
  input  [63:0] io_wdata, // @[:@2075.4]
  output [63:0] io_rdata // @[:@2075.4]
);
  wire  accel_clock; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_reset; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_enable; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_done; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_reset; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_loads_0_cmd_ready; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_loads_0_cmd_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_loads_0_cmd_bits_addr; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_cmd_bits_size; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_loads_0_data_ready; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_loads_0_data_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_0; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_1; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_2; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_3; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_4; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_5; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_6; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_7; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_8; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_9; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_10; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_11; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_12; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_13; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_14; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_15; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_stores_0_cmd_ready; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_stores_0_cmd_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_stores_0_cmd_bits_addr; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_cmd_bits_size; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_stores_0_data_ready; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_stores_0_data_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_0; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_1; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_2; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_3; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_4; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_5; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_6; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_7; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_8; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_9; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_10; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_11; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_12; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_13; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_14; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_15; // @[Instantiator.scala 53:44:@2077.4]
  wire [15:0] accel_io_memStreams_stores_0_data_bits_wstrb; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_stores_0_wresp_ready; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_stores_0_wresp_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_stores_0_wresp_bits; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_gathers_0_cmd_ready; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_gathers_0_cmd_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_0; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_1; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_2; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_3; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_4; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_5; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_6; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_7; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_8; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_9; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_10; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_11; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_12; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_13; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_14; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_15; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_gathers_0_data_ready; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_gathers_0_data_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_0; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_1; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_2; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_3; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_4; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_5; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_6; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_7; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_8; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_9; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_10; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_11; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_12; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_13; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_14; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_15; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_scatters_0_cmd_ready; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_scatters_0_cmd_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_0; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_1; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_2; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_3; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_4; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_5; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_6; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_7; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_8; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_9; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_10; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_11; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_12; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_13; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_14; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_15; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_0; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_1; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_2; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_3; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_4; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_5; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_6; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_7; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_8; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_9; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_10; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_11; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_12; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_13; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_14; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_15; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_scatters_0_wresp_ready; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_scatters_0_wresp_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_memStreams_scatters_0_wresp_bits; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_axiStreamsIn_0_TVALID; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_axiStreamsIn_0_TREADY; // @[Instantiator.scala 53:44:@2077.4]
  wire [255:0] accel_io_axiStreamsIn_0_TDATA; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_axiStreamsIn_0_TSTRB; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_axiStreamsIn_0_TKEEP; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_axiStreamsIn_0_TLAST; // @[Instantiator.scala 53:44:@2077.4]
  wire [7:0] accel_io_axiStreamsIn_0_TID; // @[Instantiator.scala 53:44:@2077.4]
  wire [7:0] accel_io_axiStreamsIn_0_TDEST; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_axiStreamsIn_0_TUSER; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_axiStreamsOut_0_TVALID; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_axiStreamsOut_0_TREADY; // @[Instantiator.scala 53:44:@2077.4]
  wire [255:0] accel_io_axiStreamsOut_0_TDATA; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_axiStreamsOut_0_TSTRB; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_axiStreamsOut_0_TKEEP; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_axiStreamsOut_0_TLAST; // @[Instantiator.scala 53:44:@2077.4]
  wire [7:0] accel_io_axiStreamsOut_0_TID; // @[Instantiator.scala 53:44:@2077.4]
  wire [7:0] accel_io_axiStreamsOut_0_TDEST; // @[Instantiator.scala 53:44:@2077.4]
  wire [31:0] accel_io_axiStreamsOut_0_TUSER; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_heap_0_req_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_heap_0_req_bits_allocDealloc; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_heap_0_req_bits_sizeAddr; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_heap_0_resp_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_heap_0_resp_bits_allocDealloc; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_heap_0_resp_bits_sizeAddr; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_argIns_0; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_argOuts_0_port_ready; // @[Instantiator.scala 53:44:@2077.4]
  wire  accel_io_argOuts_0_port_valid; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_argOuts_0_port_bits; // @[Instantiator.scala 53:44:@2077.4]
  wire [63:0] accel_io_argOuts_0_echo; // @[Instantiator.scala 53:44:@2077.4]
  AccelUnit accel ( // @[Instantiator.scala 53:44:@2077.4]
    .clock(accel_clock),
    .reset(accel_reset),
    .io_enable(accel_io_enable),
    .io_done(accel_io_done),
    .io_reset(accel_io_reset),
    .io_memStreams_loads_0_cmd_ready(accel_io_memStreams_loads_0_cmd_ready),
    .io_memStreams_loads_0_cmd_valid(accel_io_memStreams_loads_0_cmd_valid),
    .io_memStreams_loads_0_cmd_bits_addr(accel_io_memStreams_loads_0_cmd_bits_addr),
    .io_memStreams_loads_0_cmd_bits_size(accel_io_memStreams_loads_0_cmd_bits_size),
    .io_memStreams_loads_0_data_ready(accel_io_memStreams_loads_0_data_ready),
    .io_memStreams_loads_0_data_valid(accel_io_memStreams_loads_0_data_valid),
    .io_memStreams_loads_0_data_bits_rdata_0(accel_io_memStreams_loads_0_data_bits_rdata_0),
    .io_memStreams_loads_0_data_bits_rdata_1(accel_io_memStreams_loads_0_data_bits_rdata_1),
    .io_memStreams_loads_0_data_bits_rdata_2(accel_io_memStreams_loads_0_data_bits_rdata_2),
    .io_memStreams_loads_0_data_bits_rdata_3(accel_io_memStreams_loads_0_data_bits_rdata_3),
    .io_memStreams_loads_0_data_bits_rdata_4(accel_io_memStreams_loads_0_data_bits_rdata_4),
    .io_memStreams_loads_0_data_bits_rdata_5(accel_io_memStreams_loads_0_data_bits_rdata_5),
    .io_memStreams_loads_0_data_bits_rdata_6(accel_io_memStreams_loads_0_data_bits_rdata_6),
    .io_memStreams_loads_0_data_bits_rdata_7(accel_io_memStreams_loads_0_data_bits_rdata_7),
    .io_memStreams_loads_0_data_bits_rdata_8(accel_io_memStreams_loads_0_data_bits_rdata_8),
    .io_memStreams_loads_0_data_bits_rdata_9(accel_io_memStreams_loads_0_data_bits_rdata_9),
    .io_memStreams_loads_0_data_bits_rdata_10(accel_io_memStreams_loads_0_data_bits_rdata_10),
    .io_memStreams_loads_0_data_bits_rdata_11(accel_io_memStreams_loads_0_data_bits_rdata_11),
    .io_memStreams_loads_0_data_bits_rdata_12(accel_io_memStreams_loads_0_data_bits_rdata_12),
    .io_memStreams_loads_0_data_bits_rdata_13(accel_io_memStreams_loads_0_data_bits_rdata_13),
    .io_memStreams_loads_0_data_bits_rdata_14(accel_io_memStreams_loads_0_data_bits_rdata_14),
    .io_memStreams_loads_0_data_bits_rdata_15(accel_io_memStreams_loads_0_data_bits_rdata_15),
    .io_memStreams_stores_0_cmd_ready(accel_io_memStreams_stores_0_cmd_ready),
    .io_memStreams_stores_0_cmd_valid(accel_io_memStreams_stores_0_cmd_valid),
    .io_memStreams_stores_0_cmd_bits_addr(accel_io_memStreams_stores_0_cmd_bits_addr),
    .io_memStreams_stores_0_cmd_bits_size(accel_io_memStreams_stores_0_cmd_bits_size),
    .io_memStreams_stores_0_data_ready(accel_io_memStreams_stores_0_data_ready),
    .io_memStreams_stores_0_data_valid(accel_io_memStreams_stores_0_data_valid),
    .io_memStreams_stores_0_data_bits_wdata_0(accel_io_memStreams_stores_0_data_bits_wdata_0),
    .io_memStreams_stores_0_data_bits_wdata_1(accel_io_memStreams_stores_0_data_bits_wdata_1),
    .io_memStreams_stores_0_data_bits_wdata_2(accel_io_memStreams_stores_0_data_bits_wdata_2),
    .io_memStreams_stores_0_data_bits_wdata_3(accel_io_memStreams_stores_0_data_bits_wdata_3),
    .io_memStreams_stores_0_data_bits_wdata_4(accel_io_memStreams_stores_0_data_bits_wdata_4),
    .io_memStreams_stores_0_data_bits_wdata_5(accel_io_memStreams_stores_0_data_bits_wdata_5),
    .io_memStreams_stores_0_data_bits_wdata_6(accel_io_memStreams_stores_0_data_bits_wdata_6),
    .io_memStreams_stores_0_data_bits_wdata_7(accel_io_memStreams_stores_0_data_bits_wdata_7),
    .io_memStreams_stores_0_data_bits_wdata_8(accel_io_memStreams_stores_0_data_bits_wdata_8),
    .io_memStreams_stores_0_data_bits_wdata_9(accel_io_memStreams_stores_0_data_bits_wdata_9),
    .io_memStreams_stores_0_data_bits_wdata_10(accel_io_memStreams_stores_0_data_bits_wdata_10),
    .io_memStreams_stores_0_data_bits_wdata_11(accel_io_memStreams_stores_0_data_bits_wdata_11),
    .io_memStreams_stores_0_data_bits_wdata_12(accel_io_memStreams_stores_0_data_bits_wdata_12),
    .io_memStreams_stores_0_data_bits_wdata_13(accel_io_memStreams_stores_0_data_bits_wdata_13),
    .io_memStreams_stores_0_data_bits_wdata_14(accel_io_memStreams_stores_0_data_bits_wdata_14),
    .io_memStreams_stores_0_data_bits_wdata_15(accel_io_memStreams_stores_0_data_bits_wdata_15),
    .io_memStreams_stores_0_data_bits_wstrb(accel_io_memStreams_stores_0_data_bits_wstrb),
    .io_memStreams_stores_0_wresp_ready(accel_io_memStreams_stores_0_wresp_ready),
    .io_memStreams_stores_0_wresp_valid(accel_io_memStreams_stores_0_wresp_valid),
    .io_memStreams_stores_0_wresp_bits(accel_io_memStreams_stores_0_wresp_bits),
    .io_memStreams_gathers_0_cmd_ready(accel_io_memStreams_gathers_0_cmd_ready),
    .io_memStreams_gathers_0_cmd_valid(accel_io_memStreams_gathers_0_cmd_valid),
    .io_memStreams_gathers_0_cmd_bits_addr_0(accel_io_memStreams_gathers_0_cmd_bits_addr_0),
    .io_memStreams_gathers_0_cmd_bits_addr_1(accel_io_memStreams_gathers_0_cmd_bits_addr_1),
    .io_memStreams_gathers_0_cmd_bits_addr_2(accel_io_memStreams_gathers_0_cmd_bits_addr_2),
    .io_memStreams_gathers_0_cmd_bits_addr_3(accel_io_memStreams_gathers_0_cmd_bits_addr_3),
    .io_memStreams_gathers_0_cmd_bits_addr_4(accel_io_memStreams_gathers_0_cmd_bits_addr_4),
    .io_memStreams_gathers_0_cmd_bits_addr_5(accel_io_memStreams_gathers_0_cmd_bits_addr_5),
    .io_memStreams_gathers_0_cmd_bits_addr_6(accel_io_memStreams_gathers_0_cmd_bits_addr_6),
    .io_memStreams_gathers_0_cmd_bits_addr_7(accel_io_memStreams_gathers_0_cmd_bits_addr_7),
    .io_memStreams_gathers_0_cmd_bits_addr_8(accel_io_memStreams_gathers_0_cmd_bits_addr_8),
    .io_memStreams_gathers_0_cmd_bits_addr_9(accel_io_memStreams_gathers_0_cmd_bits_addr_9),
    .io_memStreams_gathers_0_cmd_bits_addr_10(accel_io_memStreams_gathers_0_cmd_bits_addr_10),
    .io_memStreams_gathers_0_cmd_bits_addr_11(accel_io_memStreams_gathers_0_cmd_bits_addr_11),
    .io_memStreams_gathers_0_cmd_bits_addr_12(accel_io_memStreams_gathers_0_cmd_bits_addr_12),
    .io_memStreams_gathers_0_cmd_bits_addr_13(accel_io_memStreams_gathers_0_cmd_bits_addr_13),
    .io_memStreams_gathers_0_cmd_bits_addr_14(accel_io_memStreams_gathers_0_cmd_bits_addr_14),
    .io_memStreams_gathers_0_cmd_bits_addr_15(accel_io_memStreams_gathers_0_cmd_bits_addr_15),
    .io_memStreams_gathers_0_data_ready(accel_io_memStreams_gathers_0_data_ready),
    .io_memStreams_gathers_0_data_valid(accel_io_memStreams_gathers_0_data_valid),
    .io_memStreams_gathers_0_data_bits_0(accel_io_memStreams_gathers_0_data_bits_0),
    .io_memStreams_gathers_0_data_bits_1(accel_io_memStreams_gathers_0_data_bits_1),
    .io_memStreams_gathers_0_data_bits_2(accel_io_memStreams_gathers_0_data_bits_2),
    .io_memStreams_gathers_0_data_bits_3(accel_io_memStreams_gathers_0_data_bits_3),
    .io_memStreams_gathers_0_data_bits_4(accel_io_memStreams_gathers_0_data_bits_4),
    .io_memStreams_gathers_0_data_bits_5(accel_io_memStreams_gathers_0_data_bits_5),
    .io_memStreams_gathers_0_data_bits_6(accel_io_memStreams_gathers_0_data_bits_6),
    .io_memStreams_gathers_0_data_bits_7(accel_io_memStreams_gathers_0_data_bits_7),
    .io_memStreams_gathers_0_data_bits_8(accel_io_memStreams_gathers_0_data_bits_8),
    .io_memStreams_gathers_0_data_bits_9(accel_io_memStreams_gathers_0_data_bits_9),
    .io_memStreams_gathers_0_data_bits_10(accel_io_memStreams_gathers_0_data_bits_10),
    .io_memStreams_gathers_0_data_bits_11(accel_io_memStreams_gathers_0_data_bits_11),
    .io_memStreams_gathers_0_data_bits_12(accel_io_memStreams_gathers_0_data_bits_12),
    .io_memStreams_gathers_0_data_bits_13(accel_io_memStreams_gathers_0_data_bits_13),
    .io_memStreams_gathers_0_data_bits_14(accel_io_memStreams_gathers_0_data_bits_14),
    .io_memStreams_gathers_0_data_bits_15(accel_io_memStreams_gathers_0_data_bits_15),
    .io_memStreams_scatters_0_cmd_ready(accel_io_memStreams_scatters_0_cmd_ready),
    .io_memStreams_scatters_0_cmd_valid(accel_io_memStreams_scatters_0_cmd_valid),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_0(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_0),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_1(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_1),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_2(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_2),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_3(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_3),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_4(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_4),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_5(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_5),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_6(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_6),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_7(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_7),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_8(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_8),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_9(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_9),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_10(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_10),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_11(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_11),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_12(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_12),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_13(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_13),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_14(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_14),
    .io_memStreams_scatters_0_cmd_bits_addr_addr_15(accel_io_memStreams_scatters_0_cmd_bits_addr_addr_15),
    .io_memStreams_scatters_0_cmd_bits_wdata_0(accel_io_memStreams_scatters_0_cmd_bits_wdata_0),
    .io_memStreams_scatters_0_cmd_bits_wdata_1(accel_io_memStreams_scatters_0_cmd_bits_wdata_1),
    .io_memStreams_scatters_0_cmd_bits_wdata_2(accel_io_memStreams_scatters_0_cmd_bits_wdata_2),
    .io_memStreams_scatters_0_cmd_bits_wdata_3(accel_io_memStreams_scatters_0_cmd_bits_wdata_3),
    .io_memStreams_scatters_0_cmd_bits_wdata_4(accel_io_memStreams_scatters_0_cmd_bits_wdata_4),
    .io_memStreams_scatters_0_cmd_bits_wdata_5(accel_io_memStreams_scatters_0_cmd_bits_wdata_5),
    .io_memStreams_scatters_0_cmd_bits_wdata_6(accel_io_memStreams_scatters_0_cmd_bits_wdata_6),
    .io_memStreams_scatters_0_cmd_bits_wdata_7(accel_io_memStreams_scatters_0_cmd_bits_wdata_7),
    .io_memStreams_scatters_0_cmd_bits_wdata_8(accel_io_memStreams_scatters_0_cmd_bits_wdata_8),
    .io_memStreams_scatters_0_cmd_bits_wdata_9(accel_io_memStreams_scatters_0_cmd_bits_wdata_9),
    .io_memStreams_scatters_0_cmd_bits_wdata_10(accel_io_memStreams_scatters_0_cmd_bits_wdata_10),
    .io_memStreams_scatters_0_cmd_bits_wdata_11(accel_io_memStreams_scatters_0_cmd_bits_wdata_11),
    .io_memStreams_scatters_0_cmd_bits_wdata_12(accel_io_memStreams_scatters_0_cmd_bits_wdata_12),
    .io_memStreams_scatters_0_cmd_bits_wdata_13(accel_io_memStreams_scatters_0_cmd_bits_wdata_13),
    .io_memStreams_scatters_0_cmd_bits_wdata_14(accel_io_memStreams_scatters_0_cmd_bits_wdata_14),
    .io_memStreams_scatters_0_cmd_bits_wdata_15(accel_io_memStreams_scatters_0_cmd_bits_wdata_15),
    .io_memStreams_scatters_0_wresp_ready(accel_io_memStreams_scatters_0_wresp_ready),
    .io_memStreams_scatters_0_wresp_valid(accel_io_memStreams_scatters_0_wresp_valid),
    .io_memStreams_scatters_0_wresp_bits(accel_io_memStreams_scatters_0_wresp_bits),
    .io_axiStreamsIn_0_TVALID(accel_io_axiStreamsIn_0_TVALID),
    .io_axiStreamsIn_0_TREADY(accel_io_axiStreamsIn_0_TREADY),
    .io_axiStreamsIn_0_TDATA(accel_io_axiStreamsIn_0_TDATA),
    .io_axiStreamsIn_0_TSTRB(accel_io_axiStreamsIn_0_TSTRB),
    .io_axiStreamsIn_0_TKEEP(accel_io_axiStreamsIn_0_TKEEP),
    .io_axiStreamsIn_0_TLAST(accel_io_axiStreamsIn_0_TLAST),
    .io_axiStreamsIn_0_TID(accel_io_axiStreamsIn_0_TID),
    .io_axiStreamsIn_0_TDEST(accel_io_axiStreamsIn_0_TDEST),
    .io_axiStreamsIn_0_TUSER(accel_io_axiStreamsIn_0_TUSER),
    .io_axiStreamsOut_0_TVALID(accel_io_axiStreamsOut_0_TVALID),
    .io_axiStreamsOut_0_TREADY(accel_io_axiStreamsOut_0_TREADY),
    .io_axiStreamsOut_0_TDATA(accel_io_axiStreamsOut_0_TDATA),
    .io_axiStreamsOut_0_TSTRB(accel_io_axiStreamsOut_0_TSTRB),
    .io_axiStreamsOut_0_TKEEP(accel_io_axiStreamsOut_0_TKEEP),
    .io_axiStreamsOut_0_TLAST(accel_io_axiStreamsOut_0_TLAST),
    .io_axiStreamsOut_0_TID(accel_io_axiStreamsOut_0_TID),
    .io_axiStreamsOut_0_TDEST(accel_io_axiStreamsOut_0_TDEST),
    .io_axiStreamsOut_0_TUSER(accel_io_axiStreamsOut_0_TUSER),
    .io_heap_0_req_valid(accel_io_heap_0_req_valid),
    .io_heap_0_req_bits_allocDealloc(accel_io_heap_0_req_bits_allocDealloc),
    .io_heap_0_req_bits_sizeAddr(accel_io_heap_0_req_bits_sizeAddr),
    .io_heap_0_resp_valid(accel_io_heap_0_resp_valid),
    .io_heap_0_resp_bits_allocDealloc(accel_io_heap_0_resp_bits_allocDealloc),
    .io_heap_0_resp_bits_sizeAddr(accel_io_heap_0_resp_bits_sizeAddr),
    .io_argIns_0(accel_io_argIns_0),
    .io_argOuts_0_port_ready(accel_io_argOuts_0_port_ready),
    .io_argOuts_0_port_valid(accel_io_argOuts_0_port_valid),
    .io_argOuts_0_port_bits(accel_io_argOuts_0_port_bits),
    .io_argOuts_0_echo(accel_io_argOuts_0_echo)
  );
  assign io_rdata = 64'h0;
  assign accel_clock = clock; // @[:@2078.4]
  assign accel_reset = reset; // @[:@2079.4]
  assign accel_io_enable = 1'h0;
  assign accel_io_reset = 1'h0;
  assign accel_io_memStreams_loads_0_cmd_ready = 1'h0;
  assign accel_io_memStreams_loads_0_data_valid = 1'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_0 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_1 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_2 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_3 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_4 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_5 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_6 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_7 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_8 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_9 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_10 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_11 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_12 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_13 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_14 = 32'h0;
  assign accel_io_memStreams_loads_0_data_bits_rdata_15 = 32'h0;
  assign accel_io_memStreams_stores_0_cmd_ready = 1'h0;
  assign accel_io_memStreams_stores_0_data_ready = 1'h0;
  assign accel_io_memStreams_stores_0_wresp_valid = 1'h0;
  assign accel_io_memStreams_stores_0_wresp_bits = 1'h0;
  assign accel_io_memStreams_gathers_0_cmd_ready = 1'h0;
  assign accel_io_memStreams_gathers_0_data_valid = 1'h0;
  assign accel_io_memStreams_gathers_0_data_bits_0 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_1 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_2 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_3 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_4 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_5 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_6 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_7 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_8 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_9 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_10 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_11 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_12 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_13 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_14 = 32'h0;
  assign accel_io_memStreams_gathers_0_data_bits_15 = 32'h0;
  assign accel_io_memStreams_scatters_0_cmd_ready = 1'h0;
  assign accel_io_memStreams_scatters_0_wresp_valid = 1'h0;
  assign accel_io_memStreams_scatters_0_wresp_bits = 1'h0;
  assign accel_io_axiStreamsIn_0_TVALID = 1'h0;
  assign accel_io_axiStreamsIn_0_TDATA = 256'h0;
  assign accel_io_axiStreamsIn_0_TSTRB = 32'h0;
  assign accel_io_axiStreamsIn_0_TKEEP = 32'h0;
  assign accel_io_axiStreamsIn_0_TLAST = 1'h0;
  assign accel_io_axiStreamsIn_0_TID = 8'h0;
  assign accel_io_axiStreamsIn_0_TDEST = 8'h0;
  assign accel_io_axiStreamsIn_0_TUSER = 32'h0;
  assign accel_io_axiStreamsOut_0_TREADY = 1'h0;
  assign accel_io_heap_0_resp_valid = 1'h0;
  assign accel_io_heap_0_resp_bits_allocDealloc = 1'h0;
  assign accel_io_heap_0_resp_bits_sizeAddr = 64'h0;
  assign accel_io_argIns_0 = 64'h0;
  assign accel_io_argOuts_0_port_ready = 1'h0;
  assign accel_io_argOuts_0_echo = 64'h0;
endmodule