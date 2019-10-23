// Latency = 1
module top(
  input CLK/*verilator public*/, 
  input [7:0] I_0/*verilator public*/, 
  input [7:0] I_1/*verilator public*/, 
  input [7:0] I_2/*verilator public*/, 
  input [7:0] I_3/*verilator public*/, 
  input [7:0] I_4/*verilator public*/, 
  input [7:0] I_5/*verilator public*/, 
  input [7:0] I_6/*verilator public*/, 
  input [7:0] I_7/*verilator public*/, 
  input [7:0] I_8/*verilator public*/, 
  input [7:0] I_9/*verilator public*/, 
  input [7:0] I_10/*verilator public*/, 
  input [7:0] I_11/*verilator public*/, 
  input [7:0] I_12/*verilator public*/, 
  input [7:0] I_13/*verilator public*/, 
  input [7:0] I_14/*verilator public*/, 
  input [7:0] I_15/*verilator public*/, 
  input [7:0] I_16/*verilator public*/, 
  input [7:0] I_17/*verilator public*/, 
  input [7:0] I_18/*verilator public*/, 
  input [7:0] I_19/*verilator public*/, 
  input [7:0] I_20/*verilator public*/, 
  input [7:0] I_21/*verilator public*/, 
  input [7:0] I_22/*verilator public*/, 
  input [7:0] I_23/*verilator public*/, 
  input [7:0] I_24/*verilator public*/, 
  output [7:0] O_0/*verilator public*/, 
  output [7:0] O_1/*verilator public*/, 
  output [7:0] O_2/*verilator public*/, 
  output [7:0] O_3/*verilator public*/, 
  output [7:0] O_4/*verilator public*/, 
  output [7:0] O_5/*verilator public*/, 
  output [7:0] O_6/*verilator public*/, 
  output [7:0] O_7/*verilator public*/, 
  output [7:0] O_8/*verilator public*/, 
  output [7:0] O_9/*verilator public*/, 
  output [7:0] O_10/*verilator public*/, 
  output [7:0] O_11/*verilator public*/, 
  output [7:0] O_12/*verilator public*/, 
  output [7:0] O_13/*verilator public*/, 
  output [7:0] O_14/*verilator public*/, 
  output [7:0] O_15/*verilator public*/, 
  output [7:0] O_16/*verilator public*/, 
  output [7:0] O_17/*verilator public*/, 
  output [7:0] O_18/*verilator public*/, 
  output [7:0] O_19/*verilator public*/, 
  output valid_down/*verilator public*/, 
  input valid_up/*verilator public*/
);
  wire dontcare;
  x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1 sampler_box ( // @[m_x55_ctr_0.scala 26:17:@1721.4]
    .clock(CLK), // @[:@1296.4]
    .reset('b0), // @[:@1297.4]
    .io_in_x24_TREADY(dontcare), // @[:@1298.4]
    .io_in_x24_TDATA({I_0,I_1,I_2,I_3,I_4,I_5,I_6,I_7,I_8,I_9,I_10,I_11,I_12,I_13,I_14,I_15,I_16,I_17,I_18,I_19,I_20,I_21,I_22,I_23,I_24}), // @[:@1298.4]
    .io_in_x25_TVALID(valid_down), // @[:@1298.4]
    .io_in_x25_TDATA({O_0,O_1,O_2,O_3,O_4,O_5,O_6,O_7,O_8,O_9,O_10,O_11,O_12,O_13,O_14,O_15,O_16,O_17,O_18,O_19}), // @[:@1298.4]
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
  assign _T_57 = $signed(_T_52) >= $signed(32'sh1); // @[Counter.scala 285:18:@106.4]
  assign _T_68 = $unsigned(_T_48); // @[Counter.scala 291:115:@114.4]
  assign _T_71 = $unsigned(_T_52); // @[Counter.scala 291:152:@117.4]
  assign _T_72 = _T_57 ? _T_68 : _T_71; // @[Counter.scala 291:74:@118.4]
  assign io_output_done = $signed(_T_52) >= $signed(32'sh1); // @[Counter.scala 325:20:@127.4]
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
module x27_ctrchain( // @[:@562.2]
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
module x41_inr_Foreach_SAMPLER_BOX_sm( // @[:@750.2]
  input   clock, // @[:@751.4]
  input   reset, // @[:@752.4]
  input   io_enable, // @[:@753.4]
  output  io_done, // @[:@753.4]
  input   io_ctrDone, // @[:@753.4]
  output  io_datapathEn, // @[:@753.4]
  output  io_ctrInc, // @[:@753.4]
  output  io_ctrRst, // @[:@753.4]
  input   io_parentAck // @[:@753.4]
);
  wire  active_clock; // @[Controllers.scala 261:22:@755.4]
  wire  active_reset; // @[Controllers.scala 261:22:@755.4]
  wire  active_io_input_set; // @[Controllers.scala 261:22:@755.4]
  wire  active_io_input_reset; // @[Controllers.scala 261:22:@755.4]
  wire  active_io_input_asyn_reset; // @[Controllers.scala 261:22:@755.4]
  wire  active_io_output; // @[Controllers.scala 261:22:@755.4]
  wire  done_clock; // @[Controllers.scala 262:20:@758.4]
  wire  done_reset; // @[Controllers.scala 262:20:@758.4]
  wire  done_io_input_set; // @[Controllers.scala 262:20:@758.4]
  wire  done_io_input_reset; // @[Controllers.scala 262:20:@758.4]
  wire  done_io_input_asyn_reset; // @[Controllers.scala 262:20:@758.4]
  wire  done_io_output; // @[Controllers.scala 262:20:@758.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@792.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@792.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@792.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@792.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@792.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@814.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@814.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@814.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@814.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@814.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@826.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@826.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@826.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@826.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@826.4]
  wire  RetimeWrapper_3_clock; // @[package.scala 93:22:@834.4]
  wire  RetimeWrapper_3_reset; // @[package.scala 93:22:@834.4]
  wire  RetimeWrapper_3_io_flow; // @[package.scala 93:22:@834.4]
  wire  RetimeWrapper_3_io_in; // @[package.scala 93:22:@834.4]
  wire  RetimeWrapper_3_io_out; // @[package.scala 93:22:@834.4]
  wire  _T_80; // @[Controllers.scala 264:48:@763.4]
  wire  _T_81; // @[Controllers.scala 264:46:@764.4]
  wire  _T_82; // @[Controllers.scala 264:62:@765.4]
  wire  _T_100; // @[package.scala 100:49:@783.4]
  reg  _T_103; // @[package.scala 48:56:@784.4]
  reg [31:0] _RAND_0;
  wire  _T_108; // @[package.scala 96:25:@797.4 package.scala 96:25:@798.4]
  wire  _T_110; // @[package.scala 100:49:@799.4]
  reg  _T_113; // @[package.scala 48:56:@800.4]
  reg [31:0] _RAND_1;
  wire  _T_114; // @[package.scala 100:41:@802.4]
  wire  _T_118; // @[Controllers.scala 283:41:@807.4]
  wire  _T_124; // @[package.scala 96:25:@819.4 package.scala 96:25:@820.4]
  wire  _T_126; // @[package.scala 100:49:@821.4]
  reg  _T_129; // @[package.scala 48:56:@822.4]
  reg [31:0] _RAND_2;
  SRFF active ( // @[Controllers.scala 261:22:@755.4]
    .clock(active_clock),
    .reset(active_reset),
    .io_input_set(active_io_input_set),
    .io_input_reset(active_io_input_reset),
    .io_input_asyn_reset(active_io_input_asyn_reset),
    .io_output(active_io_output)
  );
  SRFF done ( // @[Controllers.scala 262:20:@758.4]
    .clock(done_clock),
    .reset(done_reset),
    .io_input_set(done_io_input_set),
    .io_input_reset(done_io_input_reset),
    .io_input_asyn_reset(done_io_input_asyn_reset),
    .io_output(done_io_output)
  );
  RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@792.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@814.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@826.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  RetimeWrapper RetimeWrapper_3 ( // @[package.scala 93:22:@834.4]
    .clock(RetimeWrapper_3_clock),
    .reset(RetimeWrapper_3_reset),
    .io_flow(RetimeWrapper_3_io_flow),
    .io_in(RetimeWrapper_3_io_in),
    .io_out(RetimeWrapper_3_io_out)
  );
  assign _T_80 = ~ io_ctrDone; // @[Controllers.scala 264:48:@763.4]
  assign _T_81 = io_enable & _T_80; // @[Controllers.scala 264:46:@764.4]
  assign _T_82 = ~ done_io_output; // @[Controllers.scala 264:62:@765.4]
  assign _T_100 = io_ctrDone == 1'h0; // @[package.scala 100:49:@783.4]
  assign _T_108 = RetimeWrapper_io_out; // @[package.scala 96:25:@797.4 package.scala 96:25:@798.4]
  assign _T_110 = _T_108 == 1'h0; // @[package.scala 100:49:@799.4]
  assign _T_114 = _T_108 & _T_113; // @[package.scala 100:41:@802.4]
  assign _T_118 = active_io_output & _T_82; // @[Controllers.scala 283:41:@807.4]
  assign _T_124 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@819.4 package.scala 96:25:@820.4]
  assign _T_126 = _T_124 == 1'h0; // @[package.scala 100:49:@821.4]
  assign io_done = _T_124 & _T_129; // @[Controllers.scala 287:13:@825.4]
  assign io_datapathEn = _T_118 & io_enable; // @[Controllers.scala 283:21:@810.4]
  assign io_ctrInc = active_io_output & io_enable; // @[Controllers.scala 284:17:@813.4]
  assign io_ctrRst = _T_114 | io_parentAck; // @[Controllers.scala 274:13:@805.4]
  assign active_clock = clock; // @[:@756.4]
  assign active_reset = reset; // @[:@757.4]
  assign active_io_input_set = _T_81 & _T_82; // @[Controllers.scala 264:23:@768.4]
  assign active_io_input_reset = io_ctrDone | io_parentAck; // @[Controllers.scala 265:25:@772.4]
  assign active_io_input_asyn_reset = 1'h0; // @[Controllers.scala 266:30:@773.4]
  assign done_clock = clock; // @[:@759.4]
  assign done_reset = reset; // @[:@760.4]
  assign done_io_input_set = io_ctrDone & _T_103; // @[Controllers.scala 269:104:@788.4]
  assign done_io_input_reset = io_parentAck; // @[Controllers.scala 267:23:@781.4]
  assign done_io_input_asyn_reset = 1'h0; // @[Controllers.scala 268:28:@782.4]
  assign RetimeWrapper_clock = clock; // @[:@793.4]
  assign RetimeWrapper_reset = reset; // @[:@794.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@796.4]
  assign RetimeWrapper_io_in = done_io_output; // @[package.scala 94:16:@795.4]
  assign RetimeWrapper_1_clock = clock; // @[:@815.4]
  assign RetimeWrapper_1_reset = reset; // @[:@816.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@818.4]
  assign RetimeWrapper_1_io_in = done_io_output; // @[package.scala 94:16:@817.4]
  assign RetimeWrapper_2_clock = clock; // @[:@827.4]
  assign RetimeWrapper_2_reset = reset; // @[:@828.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@830.4]
  assign RetimeWrapper_2_io_in = 1'h0; // @[package.scala 94:16:@829.4]
  assign RetimeWrapper_3_clock = clock; // @[:@835.4]
  assign RetimeWrapper_3_reset = reset; // @[:@836.4]
  assign RetimeWrapper_3_io_flow = 1'h1; // @[package.scala 95:18:@838.4]
  assign RetimeWrapper_3_io_in = io_ctrDone; // @[package.scala 94:16:@837.4]
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
  end
endmodule
module RetimeWrapper_12( // @[:@1009.2]
  input          clock, // @[:@1010.4]
  input          reset, // @[:@1011.4]
  input  [199:0] io_in, // @[:@1012.4]
  output [199:0] io_out // @[:@1012.4]
);
  wire [199:0] sr_out; // @[RetimeShiftRegister.scala 15:20:@1014.4]
  wire [199:0] sr_in; // @[RetimeShiftRegister.scala 15:20:@1014.4]
  wire [199:0] sr_init; // @[RetimeShiftRegister.scala 15:20:@1014.4]
  wire  sr_flow; // @[RetimeShiftRegister.scala 15:20:@1014.4]
  wire  sr_reset; // @[RetimeShiftRegister.scala 15:20:@1014.4]
  wire  sr_clock; // @[RetimeShiftRegister.scala 15:20:@1014.4]
  RetimeShiftRegister #(.WIDTH(200), .STAGES(1)) sr ( // @[RetimeShiftRegister.scala 15:20:@1014.4]
    .out(sr_out),
    .in(sr_in),
    .init(sr_init),
    .flow(sr_flow),
    .reset(sr_reset),
    .clock(sr_clock)
  );
  assign io_out = sr_out; // @[RetimeShiftRegister.scala 21:12:@1027.4]
  assign sr_in = io_in; // @[RetimeShiftRegister.scala 20:14:@1026.4]
  assign sr_init = 200'h0; // @[RetimeShiftRegister.scala 19:16:@1025.4]
  assign sr_flow = 1'h1; // @[RetimeShiftRegister.scala 18:16:@1024.4]
  assign sr_reset = reset; // @[RetimeShiftRegister.scala 17:17:@1023.4]
  assign sr_clock = clock; // @[RetimeShiftRegister.scala 16:17:@1021.4]
endmodule
module x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1( // @[:@1093.2]
  input          clock, // @[:@1094.4]
  input          reset, // @[:@1095.4]
  output         io_in_x24_TREADY, // @[:@1096.4]
  input  [255:0] io_in_x24_TDATA, // @[:@1096.4]
  output         io_in_x25_TVALID, // @[:@1096.4]
  output [255:0] io_in_x25_TDATA, // @[:@1096.4]
  input          io_sigsIn_datapathEn, // @[:@1096.4]
  input          io_sigsIn_cchainOutputs_0_oobs_0, // @[:@1096.4]
  input          io_rr // @[:@1096.4]
);
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1124.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1124.4]
  wire [199:0] RetimeWrapper_io_in; // @[package.scala 93:22:@1124.4]
  wire [199:0] RetimeWrapper_io_out; // @[package.scala 93:22:@1124.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@1238.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@1238.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@1238.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@1238.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@1238.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@1247.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@1247.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@1247.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@1247.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@1247.4]
  wire  b29; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 61:17:@1118.4]
  wire [199:0] x42_x30_D1_0_number; // @[package.scala 96:25:@1129.4 package.scala 96:25:@1130.4]
  wire [7:0] x32_0_number; // @[FixedPoint.scala 18:52:@1135.4]
  wire [7:0] x32_5_number; // @[FixedPoint.scala 18:52:@1145.4]
  wire [7:0] x32_10_number; // @[FixedPoint.scala 18:52:@1155.4]
  wire [7:0] x32_15_number; // @[FixedPoint.scala 18:52:@1165.4]
  wire [7:0] x32_20_number; // @[FixedPoint.scala 18:52:@1175.4]
  wire [79:0] _T_290; // @[Cat.scala 30:58:@1225.4]
  wire [79:0] _T_299; // @[Cat.scala 30:58:@1234.4]
  wire [159:0] x39_number; // @[Cat.scala 30:58:@1235.4]
  wire  _T_306; // @[package.scala 96:25:@1252.4 package.scala 96:25:@1253.4]
  wire  _T_308; // @[implicits.scala 55:10:@1254.4]
  wire  x43_b29_D1; // @[package.scala 96:25:@1243.4 package.scala 96:25:@1244.4]
  RetimeWrapper_12 RetimeWrapper ( // @[package.scala 93:22:@1124.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@1238.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@1247.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  assign b29 = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 61:17:@1118.4]
  assign x42_x30_D1_0_number = RetimeWrapper_io_out; // @[package.scala 96:25:@1129.4 package.scala 96:25:@1130.4]
  assign x32_0_number = x42_x30_D1_0_number[7:0]; // @[FixedPoint.scala 18:52:@1135.4]
  assign x32_5_number = x42_x30_D1_0_number[47:40]; // @[FixedPoint.scala 18:52:@1145.4]
  assign x32_10_number = x42_x30_D1_0_number[87:80]; // @[FixedPoint.scala 18:52:@1155.4]
  assign x32_15_number = x42_x30_D1_0_number[127:120]; // @[FixedPoint.scala 18:52:@1165.4]
  assign x32_20_number = x42_x30_D1_0_number[167:160]; // @[FixedPoint.scala 18:52:@1175.4]
  assign _T_290 = {x32_10_number,x32_10_number,x32_5_number,x32_5_number,x32_5_number,x32_5_number,x32_0_number,x32_0_number,x32_0_number,x32_0_number}; // @[Cat.scala 30:58:@1225.4]
  assign _T_299 = {x32_20_number,x32_20_number,x32_20_number,x32_20_number,x32_15_number,x32_15_number,x32_15_number,x32_15_number,x32_10_number,x32_10_number}; // @[Cat.scala 30:58:@1234.4]
  assign x39_number = {_T_299,_T_290}; // @[Cat.scala 30:58:@1235.4]
  assign _T_306 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@1252.4 package.scala 96:25:@1253.4]
  assign _T_308 = io_rr ? _T_306 : 1'h0; // @[implicits.scala 55:10:@1254.4]
  assign x43_b29_D1 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@1243.4 package.scala 96:25:@1244.4]
  assign io_in_x24_TREADY = b29 & io_sigsIn_datapathEn; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 63:17:@1121.4]
  assign io_in_x25_TVALID = _T_308 & x43_b29_D1; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 86:17:@1257.4]
  assign io_in_x25_TDATA = {{96'd0}, x39_number}; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 87:19:@1258.4]
  assign RetimeWrapper_clock = clock; // @[:@1125.4]
  assign RetimeWrapper_reset = reset; // @[:@1126.4]
  assign RetimeWrapper_io_in = io_in_x24_TDATA[199:0]; // @[package.scala 94:16:@1127.4]
  assign RetimeWrapper_1_clock = clock; // @[:@1239.4]
  assign RetimeWrapper_1_reset = reset; // @[:@1240.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@1242.4]
  assign RetimeWrapper_1_io_in = ~ io_sigsIn_cchainOutputs_0_oobs_0; // @[package.scala 94:16:@1241.4]
  assign RetimeWrapper_2_clock = clock; // @[:@1248.4]
  assign RetimeWrapper_2_reset = reset; // @[:@1249.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@1251.4]
  assign RetimeWrapper_2_io_in = io_sigsIn_datapathEn; // @[package.scala 94:16:@1250.4]
endmodule
module RootController_kernelRootController_concrete1( // @[:@1268.2]
  input          clock, // @[:@1269.4]
  input          reset, // @[:@1270.4]
  output         io_in_x24_TREADY, // @[:@1271.4]
  input  [255:0] io_in_x24_TDATA, // @[:@1271.4]
  output         io_in_x25_TVALID, // @[:@1271.4]
  output [255:0] io_in_x25_TDATA, // @[:@1271.4]
  input          io_sigsIn_smEnableOuts_0, // @[:@1271.4]
  input          io_sigsIn_smChildAcks_0, // @[:@1271.4]
  output         io_sigsOut_smDoneIn_0, // @[:@1271.4]
  input          io_rr // @[:@1271.4]
);
  wire  x27_ctrchain_clock; // @[SpatialBlocks.scala 37:22:@1281.4]
  wire  x27_ctrchain_reset; // @[SpatialBlocks.scala 37:22:@1281.4]
  wire  x27_ctrchain_io_input_reset; // @[SpatialBlocks.scala 37:22:@1281.4]
  wire  x27_ctrchain_io_input_enable; // @[SpatialBlocks.scala 37:22:@1281.4]
  wire  x27_ctrchain_io_output_oobs_0; // @[SpatialBlocks.scala 37:22:@1281.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_sm_clock; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 32:18:@1333.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_sm_reset; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 32:18:@1333.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_sm_io_enable; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 32:18:@1333.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_sm_io_done; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 32:18:@1333.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_sm_io_ctrDone; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 32:18:@1333.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_sm_io_datapathEn; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 32:18:@1333.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_sm_io_ctrInc; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 32:18:@1333.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_sm_io_ctrRst; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 32:18:@1333.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_sm_io_parentAck; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 32:18:@1333.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1361.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1361.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@1361.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@1361.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@1361.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@1401.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@1401.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@1401.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@1401.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@1401.4]
  wire  RetimeWrapper_2_clock; // @[package.scala 93:22:@1409.4]
  wire  RetimeWrapper_2_reset; // @[package.scala 93:22:@1409.4]
  wire  RetimeWrapper_2_io_flow; // @[package.scala 93:22:@1409.4]
  wire  RetimeWrapper_2_io_in; // @[package.scala 93:22:@1409.4]
  wire  RetimeWrapper_2_io_out; // @[package.scala 93:22:@1409.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_clock; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 95:24:@1440.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_reset; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 95:24:@1440.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x24_TREADY; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 95:24:@1440.4]
  wire [255:0] x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x24_TDATA; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 95:24:@1440.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x25_TVALID; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 95:24:@1440.4]
  wire [255:0] x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x25_TDATA; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 95:24:@1440.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_datapathEn; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 95:24:@1440.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_cchainOutputs_0_oobs_0; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 95:24:@1440.4]
  wire  x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_rr; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 95:24:@1440.4]
  wire  _T_233; // @[package.scala 96:25:@1366.4 package.scala 96:25:@1367.4]
  wire  _T_248; // @[package.scala 96:25:@1406.4 package.scala 96:25:@1407.4]
  wire  _T_254; // @[package.scala 96:25:@1414.4 package.scala 96:25:@1415.4]
  wire  _T_257; // @[SpatialBlocks.scala 110:93:@1417.4]
  wire  _T_259; // @[SpatialBlocks.scala 128:36:@1426.4]
  wire  _T_260; // @[SpatialBlocks.scala 128:78:@1427.4]
  x27_ctrchain x27_ctrchain ( // @[SpatialBlocks.scala 37:22:@1281.4]
    .clock(x27_ctrchain_clock),
    .reset(x27_ctrchain_reset),
    .io_input_reset(x27_ctrchain_io_input_reset),
    .io_input_enable(x27_ctrchain_io_input_enable),
    .io_output_oobs_0(x27_ctrchain_io_output_oobs_0)
  );
  x41_inr_Foreach_SAMPLER_BOX_sm x41_inr_Foreach_SAMPLER_BOX_sm ( // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 32:18:@1333.4]
    .clock(x41_inr_Foreach_SAMPLER_BOX_sm_clock),
    .reset(x41_inr_Foreach_SAMPLER_BOX_sm_reset),
    .io_enable(x41_inr_Foreach_SAMPLER_BOX_sm_io_enable),
    .io_done(x41_inr_Foreach_SAMPLER_BOX_sm_io_done),
    .io_ctrDone(x41_inr_Foreach_SAMPLER_BOX_sm_io_ctrDone),
    .io_datapathEn(x41_inr_Foreach_SAMPLER_BOX_sm_io_datapathEn),
    .io_ctrInc(x41_inr_Foreach_SAMPLER_BOX_sm_io_ctrInc),
    .io_ctrRst(x41_inr_Foreach_SAMPLER_BOX_sm_io_ctrRst),
    .io_parentAck(x41_inr_Foreach_SAMPLER_BOX_sm_io_parentAck)
  );
  RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@1361.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@1401.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RetimeWrapper RetimeWrapper_2 ( // @[package.scala 93:22:@1409.4]
    .clock(RetimeWrapper_2_clock),
    .reset(RetimeWrapper_2_reset),
    .io_flow(RetimeWrapper_2_io_flow),
    .io_in(RetimeWrapper_2_io_in),
    .io_out(RetimeWrapper_2_io_out)
  );
  x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1 x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1 ( // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 95:24:@1440.4]
    .clock(x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_clock),
    .reset(x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_reset),
    .io_in_x24_TREADY(x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x24_TREADY),
    .io_in_x24_TDATA(x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x24_TDATA),
    .io_in_x25_TVALID(x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x25_TVALID),
    .io_in_x25_TDATA(x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x25_TDATA),
    .io_sigsIn_datapathEn(x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_datapathEn),
    .io_sigsIn_cchainOutputs_0_oobs_0(x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_cchainOutputs_0_oobs_0),
    .io_rr(x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_rr)
  );
  assign _T_233 = RetimeWrapper_io_out; // @[package.scala 96:25:@1366.4 package.scala 96:25:@1367.4]
  assign _T_248 = RetimeWrapper_1_io_out; // @[package.scala 96:25:@1406.4 package.scala 96:25:@1407.4]
  assign _T_254 = RetimeWrapper_2_io_out; // @[package.scala 96:25:@1414.4 package.scala 96:25:@1415.4]
  assign _T_257 = ~ _T_254; // @[SpatialBlocks.scala 110:93:@1417.4]
  assign _T_259 = x41_inr_Foreach_SAMPLER_BOX_sm_io_datapathEn; // @[SpatialBlocks.scala 128:36:@1426.4]
  assign _T_260 = ~ x41_inr_Foreach_SAMPLER_BOX_sm_io_ctrDone; // @[SpatialBlocks.scala 128:78:@1427.4]
  assign io_in_x24_TREADY = x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x24_TREADY; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 48:22:@1495.4]
  assign io_in_x25_TVALID = x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x25_TVALID; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 49:22:@1505.4]
  assign io_in_x25_TDATA = x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x25_TDATA; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 49:22:@1503.4]
  assign io_sigsOut_smDoneIn_0 = x41_inr_Foreach_SAMPLER_BOX_sm_io_done; // @[SpatialBlocks.scala 127:53:@1424.4]
  assign x27_ctrchain_clock = clock; // @[:@1282.4]
  assign x27_ctrchain_reset = reset; // @[:@1283.4]
  assign x27_ctrchain_io_input_reset = x41_inr_Foreach_SAMPLER_BOX_sm_io_ctrRst; // @[SpatialBlocks.scala 130:103:@1439.4]
  assign x27_ctrchain_io_input_enable = x41_inr_Foreach_SAMPLER_BOX_sm_io_ctrInc; // @[SpatialBlocks.scala 104:75:@1394.4 SpatialBlocks.scala 130:45:@1438.4]
  assign x41_inr_Foreach_SAMPLER_BOX_sm_clock = clock; // @[:@1334.4]
  assign x41_inr_Foreach_SAMPLER_BOX_sm_reset = reset; // @[:@1335.4]
  assign x41_inr_Foreach_SAMPLER_BOX_sm_io_enable = _T_248 & _T_257; // @[SpatialBlocks.scala 112:18:@1421.4]
  assign x41_inr_Foreach_SAMPLER_BOX_sm_io_ctrDone = io_rr ? _T_233 : 1'h0; // @[sm_RootController.scala 65:49:@1369.4]
  assign x41_inr_Foreach_SAMPLER_BOX_sm_io_parentAck = io_sigsIn_smChildAcks_0; // @[SpatialBlocks.scala 114:21:@1423.4]
  assign RetimeWrapper_clock = clock; // @[:@1362.4]
  assign RetimeWrapper_reset = reset; // @[:@1363.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@1365.4]
  assign RetimeWrapper_io_in = 1'h0; // @[package.scala 94:16:@1364.4]
  assign RetimeWrapper_1_clock = clock; // @[:@1402.4]
  assign RetimeWrapper_1_reset = reset; // @[:@1403.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@1405.4]
  assign RetimeWrapper_1_io_in = io_sigsIn_smEnableOuts_0; // @[package.scala 94:16:@1404.4]
  assign RetimeWrapper_2_clock = clock; // @[:@1410.4]
  assign RetimeWrapper_2_reset = reset; // @[:@1411.4]
  assign RetimeWrapper_2_io_flow = 1'h1; // @[package.scala 95:18:@1413.4]
  assign RetimeWrapper_2_io_in = x41_inr_Foreach_SAMPLER_BOX_sm_io_done; // @[package.scala 94:16:@1412.4]
  assign x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_clock = clock; // @[:@1441.4]
  assign x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_reset = reset; // @[:@1442.4]
  assign x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_in_x24_TDATA = io_in_x24_TDATA; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 48:22:@1494.4]
  assign x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_datapathEn = _T_259 & _T_260; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 99:22:@1518.4]
  assign x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_sigsIn_cchainOutputs_0_oobs_0 = x27_ctrchain_io_output_oobs_0; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 99:22:@1510.4]
  assign x41_inr_Foreach_SAMPLER_BOX_kernelx41_inr_Foreach_SAMPLER_BOX_concrete1_io_rr = io_rr; // @[sm_x41_inr_Foreach_SAMPLER_BOX.scala 98:18:@1506.4]
endmodule
module AccelUnit( // @[:@1533.2]
  input          clock, // @[:@1534.4]
  input          reset, // @[:@1535.4]
  input          io_enable, // @[:@1536.4]
  output         io_done, // @[:@1536.4]
  input          io_reset, // @[:@1536.4]
  input          io_memStreams_loads_0_cmd_ready, // @[:@1536.4]
  output         io_memStreams_loads_0_cmd_valid, // @[:@1536.4]
  output [63:0]  io_memStreams_loads_0_cmd_bits_addr, // @[:@1536.4]
  output [31:0]  io_memStreams_loads_0_cmd_bits_size, // @[:@1536.4]
  output         io_memStreams_loads_0_data_ready, // @[:@1536.4]
  input          io_memStreams_loads_0_data_valid, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_0, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_1, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_2, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_3, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_4, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_5, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_6, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_7, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_8, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_9, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_10, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_11, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_12, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_13, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_14, // @[:@1536.4]
  input  [31:0]  io_memStreams_loads_0_data_bits_rdata_15, // @[:@1536.4]
  input          io_memStreams_stores_0_cmd_ready, // @[:@1536.4]
  output         io_memStreams_stores_0_cmd_valid, // @[:@1536.4]
  output [63:0]  io_memStreams_stores_0_cmd_bits_addr, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_cmd_bits_size, // @[:@1536.4]
  input          io_memStreams_stores_0_data_ready, // @[:@1536.4]
  output         io_memStreams_stores_0_data_valid, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_0, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_1, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_2, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_3, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_4, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_5, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_6, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_7, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_8, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_9, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_10, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_11, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_12, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_13, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_14, // @[:@1536.4]
  output [31:0]  io_memStreams_stores_0_data_bits_wdata_15, // @[:@1536.4]
  output [15:0]  io_memStreams_stores_0_data_bits_wstrb, // @[:@1536.4]
  output         io_memStreams_stores_0_wresp_ready, // @[:@1536.4]
  input          io_memStreams_stores_0_wresp_valid, // @[:@1536.4]
  input          io_memStreams_stores_0_wresp_bits, // @[:@1536.4]
  input          io_memStreams_gathers_0_cmd_ready, // @[:@1536.4]
  output         io_memStreams_gathers_0_cmd_valid, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_0, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_1, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_2, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_3, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_4, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_5, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_6, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_7, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_8, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_9, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_10, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_11, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_12, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_13, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_14, // @[:@1536.4]
  output [63:0]  io_memStreams_gathers_0_cmd_bits_addr_15, // @[:@1536.4]
  output         io_memStreams_gathers_0_data_ready, // @[:@1536.4]
  input          io_memStreams_gathers_0_data_valid, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_0, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_1, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_2, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_3, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_4, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_5, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_6, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_7, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_8, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_9, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_10, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_11, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_12, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_13, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_14, // @[:@1536.4]
  input  [31:0]  io_memStreams_gathers_0_data_bits_15, // @[:@1536.4]
  input          io_memStreams_scatters_0_cmd_ready, // @[:@1536.4]
  output         io_memStreams_scatters_0_cmd_valid, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_0, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_1, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_2, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_3, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_4, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_5, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_6, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_7, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_8, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_9, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_10, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_11, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_12, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_13, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_14, // @[:@1536.4]
  output [63:0]  io_memStreams_scatters_0_cmd_bits_addr_addr_15, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_0, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_1, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_2, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_3, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_4, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_5, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_6, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_7, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_8, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_9, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_10, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_11, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_12, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_13, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_14, // @[:@1536.4]
  output [31:0]  io_memStreams_scatters_0_cmd_bits_wdata_15, // @[:@1536.4]
  output         io_memStreams_scatters_0_wresp_ready, // @[:@1536.4]
  input          io_memStreams_scatters_0_wresp_valid, // @[:@1536.4]
  input          io_memStreams_scatters_0_wresp_bits, // @[:@1536.4]
  input          io_axiStreamsIn_0_TVALID, // @[:@1536.4]
  output         io_axiStreamsIn_0_TREADY, // @[:@1536.4]
  input  [255:0] io_axiStreamsIn_0_TDATA, // @[:@1536.4]
  input  [31:0]  io_axiStreamsIn_0_TSTRB, // @[:@1536.4]
  input  [31:0]  io_axiStreamsIn_0_TKEEP, // @[:@1536.4]
  input          io_axiStreamsIn_0_TLAST, // @[:@1536.4]
  input  [7:0]   io_axiStreamsIn_0_TID, // @[:@1536.4]
  input  [7:0]   io_axiStreamsIn_0_TDEST, // @[:@1536.4]
  input  [31:0]  io_axiStreamsIn_0_TUSER, // @[:@1536.4]
  output         io_axiStreamsOut_0_TVALID, // @[:@1536.4]
  input          io_axiStreamsOut_0_TREADY, // @[:@1536.4]
  output [255:0] io_axiStreamsOut_0_TDATA, // @[:@1536.4]
  output [31:0]  io_axiStreamsOut_0_TSTRB, // @[:@1536.4]
  output [31:0]  io_axiStreamsOut_0_TKEEP, // @[:@1536.4]
  output         io_axiStreamsOut_0_TLAST, // @[:@1536.4]
  output [7:0]   io_axiStreamsOut_0_TID, // @[:@1536.4]
  output [7:0]   io_axiStreamsOut_0_TDEST, // @[:@1536.4]
  output [31:0]  io_axiStreamsOut_0_TUSER, // @[:@1536.4]
  output         io_heap_0_req_valid, // @[:@1536.4]
  output         io_heap_0_req_bits_allocDealloc, // @[:@1536.4]
  output [63:0]  io_heap_0_req_bits_sizeAddr, // @[:@1536.4]
  input          io_heap_0_resp_valid, // @[:@1536.4]
  input          io_heap_0_resp_bits_allocDealloc, // @[:@1536.4]
  input  [63:0]  io_heap_0_resp_bits_sizeAddr, // @[:@1536.4]
  input  [63:0]  io_argIns_0, // @[:@1536.4]
  input          io_argOuts_0_port_ready, // @[:@1536.4]
  output         io_argOuts_0_port_valid, // @[:@1536.4]
  output [63:0]  io_argOuts_0_port_bits, // @[:@1536.4]
  input  [63:0]  io_argOuts_0_echo // @[:@1536.4]
);
  wire  SingleCounter_clock; // @[Main.scala 29:32:@1694.4]
  wire  SingleCounter_reset; // @[Main.scala 29:32:@1694.4]
  wire  SingleCounter_io_input_reset; // @[Main.scala 29:32:@1694.4]
  wire  SingleCounter_io_output_done; // @[Main.scala 29:32:@1694.4]
  wire  RetimeWrapper_clock; // @[package.scala 93:22:@1712.4]
  wire  RetimeWrapper_reset; // @[package.scala 93:22:@1712.4]
  wire  RetimeWrapper_io_flow; // @[package.scala 93:22:@1712.4]
  wire  RetimeWrapper_io_in; // @[package.scala 93:22:@1712.4]
  wire  RetimeWrapper_io_out; // @[package.scala 93:22:@1712.4]
  wire  SRFF_clock; // @[Main.scala 33:28:@1721.4]
  wire  SRFF_reset; // @[Main.scala 33:28:@1721.4]
  wire  SRFF_io_input_set; // @[Main.scala 33:28:@1721.4]
  wire  SRFF_io_input_reset; // @[Main.scala 33:28:@1721.4]
  wire  SRFF_io_input_asyn_reset; // @[Main.scala 33:28:@1721.4]
  wire  SRFF_io_output; // @[Main.scala 33:28:@1721.4]
  wire  RootController_sm_clock; // @[sm_RootController.scala 32:18:@1759.4]
  wire  RootController_sm_reset; // @[sm_RootController.scala 32:18:@1759.4]
  wire  RootController_sm_io_enable; // @[sm_RootController.scala 32:18:@1759.4]
  wire  RootController_sm_io_done; // @[sm_RootController.scala 32:18:@1759.4]
  wire  RootController_sm_io_rst; // @[sm_RootController.scala 32:18:@1759.4]
  wire  RootController_sm_io_ctrDone; // @[sm_RootController.scala 32:18:@1759.4]
  wire  RootController_sm_io_ctrInc; // @[sm_RootController.scala 32:18:@1759.4]
  wire  RootController_sm_io_doneIn_0; // @[sm_RootController.scala 32:18:@1759.4]
  wire  RootController_sm_io_enableOut_0; // @[sm_RootController.scala 32:18:@1759.4]
  wire  RootController_sm_io_childAck_0; // @[sm_RootController.scala 32:18:@1759.4]
  wire  RetimeWrapper_1_clock; // @[package.scala 93:22:@1791.4]
  wire  RetimeWrapper_1_reset; // @[package.scala 93:22:@1791.4]
  wire  RetimeWrapper_1_io_flow; // @[package.scala 93:22:@1791.4]
  wire  RetimeWrapper_1_io_in; // @[package.scala 93:22:@1791.4]
  wire  RetimeWrapper_1_io_out; // @[package.scala 93:22:@1791.4]
  wire  RootController_kernelRootController_concrete1_clock; // @[sm_RootController.scala 74:24:@1850.4]
  wire  RootController_kernelRootController_concrete1_reset; // @[sm_RootController.scala 74:24:@1850.4]
  wire  RootController_kernelRootController_concrete1_io_in_x24_TREADY; // @[sm_RootController.scala 74:24:@1850.4]
  wire [255:0] RootController_kernelRootController_concrete1_io_in_x24_TDATA; // @[sm_RootController.scala 74:24:@1850.4]
  wire  RootController_kernelRootController_concrete1_io_in_x25_TVALID; // @[sm_RootController.scala 74:24:@1850.4]
  wire [255:0] RootController_kernelRootController_concrete1_io_in_x25_TDATA; // @[sm_RootController.scala 74:24:@1850.4]
  wire  RootController_kernelRootController_concrete1_io_sigsIn_smEnableOuts_0; // @[sm_RootController.scala 74:24:@1850.4]
  wire  RootController_kernelRootController_concrete1_io_sigsIn_smChildAcks_0; // @[sm_RootController.scala 74:24:@1850.4]
  wire  RootController_kernelRootController_concrete1_io_sigsOut_smDoneIn_0; // @[sm_RootController.scala 74:24:@1850.4]
  wire  RootController_kernelRootController_concrete1_io_rr; // @[sm_RootController.scala 74:24:@1850.4]
  wire  _T_593; // @[package.scala 96:25:@1717.4 package.scala 96:25:@1718.4]
  wire  _T_658; // @[Main.scala 35:50:@1787.4]
  wire  _T_659; // @[Main.scala 35:59:@1788.4]
  wire  _T_671; // @[package.scala 100:49:@1808.4]
  reg  _T_674; // @[package.scala 48:56:@1809.4]
  reg [31:0] _RAND_0;
  SingleCounter SingleCounter ( // @[Main.scala 29:32:@1694.4]
    .clock(SingleCounter_clock),
    .reset(SingleCounter_reset),
    .io_input_reset(SingleCounter_io_input_reset),
    .io_output_done(SingleCounter_io_output_done)
  );
  RetimeWrapper RetimeWrapper ( // @[package.scala 93:22:@1712.4]
    .clock(RetimeWrapper_clock),
    .reset(RetimeWrapper_reset),
    .io_flow(RetimeWrapper_io_flow),
    .io_in(RetimeWrapper_io_in),
    .io_out(RetimeWrapper_io_out)
  );
  SRFF SRFF ( // @[Main.scala 33:28:@1721.4]
    .clock(SRFF_clock),
    .reset(SRFF_reset),
    .io_input_set(SRFF_io_input_set),
    .io_input_reset(SRFF_io_input_reset),
    .io_input_asyn_reset(SRFF_io_input_asyn_reset),
    .io_output(SRFF_io_output)
  );
  RootController_sm RootController_sm ( // @[sm_RootController.scala 32:18:@1759.4]
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
  RetimeWrapper RetimeWrapper_1 ( // @[package.scala 93:22:@1791.4]
    .clock(RetimeWrapper_1_clock),
    .reset(RetimeWrapper_1_reset),
    .io_flow(RetimeWrapper_1_io_flow),
    .io_in(RetimeWrapper_1_io_in),
    .io_out(RetimeWrapper_1_io_out)
  );
  RootController_kernelRootController_concrete1 RootController_kernelRootController_concrete1 ( // @[sm_RootController.scala 74:24:@1850.4]
    .clock(RootController_kernelRootController_concrete1_clock),
    .reset(RootController_kernelRootController_concrete1_reset),
    .io_in_x24_TREADY(RootController_kernelRootController_concrete1_io_in_x24_TREADY),
    .io_in_x24_TDATA(RootController_kernelRootController_concrete1_io_in_x24_TDATA),
    .io_in_x25_TVALID(RootController_kernelRootController_concrete1_io_in_x25_TVALID),
    .io_in_x25_TDATA(RootController_kernelRootController_concrete1_io_in_x25_TDATA),
    .io_sigsIn_smEnableOuts_0(RootController_kernelRootController_concrete1_io_sigsIn_smEnableOuts_0),
    .io_sigsIn_smChildAcks_0(RootController_kernelRootController_concrete1_io_sigsIn_smChildAcks_0),
    .io_sigsOut_smDoneIn_0(RootController_kernelRootController_concrete1_io_sigsOut_smDoneIn_0),
    .io_rr(RootController_kernelRootController_concrete1_io_rr)
  );
  assign _T_593 = RetimeWrapper_io_out; // @[package.scala 96:25:@1717.4 package.scala 96:25:@1718.4]
  assign _T_658 = io_enable & _T_593; // @[Main.scala 35:50:@1787.4]
  assign _T_659 = ~ SRFF_io_output; // @[Main.scala 35:59:@1788.4]
  assign _T_671 = RootController_sm_io_ctrInc == 1'h0; // @[package.scala 100:49:@1808.4]
  assign io_done = SRFF_io_output; // @[Main.scala 42:23:@1807.4]
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
  assign io_axiStreamsIn_0_TREADY = RootController_kernelRootController_concrete1_io_in_x24_TREADY; // @[sm_RootController.scala 48:22:@1905.4]
  assign io_axiStreamsOut_0_TVALID = RootController_kernelRootController_concrete1_io_in_x25_TVALID; // @[sm_RootController.scala 49:22:@1915.4]
  assign io_axiStreamsOut_0_TDATA = RootController_kernelRootController_concrete1_io_in_x25_TDATA; // @[sm_RootController.scala 49:22:@1913.4]
  assign io_axiStreamsOut_0_TSTRB = 32'hffffffff; // @[sm_RootController.scala 49:22:@1912.4]
  assign io_axiStreamsOut_0_TKEEP = 32'hffffffff; // @[sm_RootController.scala 49:22:@1911.4]
  assign io_axiStreamsOut_0_TLAST = 1'h0; // @[sm_RootController.scala 49:22:@1910.4]
  assign io_axiStreamsOut_0_TID = 8'h0; // @[sm_RootController.scala 49:22:@1909.4]
  assign io_axiStreamsOut_0_TDEST = 8'h0; // @[sm_RootController.scala 49:22:@1908.4]
  assign io_axiStreamsOut_0_TUSER = 32'h4; // @[sm_RootController.scala 49:22:@1907.4]
  assign io_heap_0_req_valid = 1'h0;
  assign io_heap_0_req_bits_allocDealloc = 1'h0;
  assign io_heap_0_req_bits_sizeAddr = 64'h0;
  assign io_argOuts_0_port_valid = 1'h0;
  assign io_argOuts_0_port_bits = 64'h0;
  assign SingleCounter_clock = clock; // @[:@1695.4]
  assign SingleCounter_reset = reset; // @[:@1696.4]
  assign SingleCounter_io_input_reset = reset; // @[Main.scala 30:79:@1710.4]
  assign RetimeWrapper_clock = clock; // @[:@1713.4]
  assign RetimeWrapper_reset = reset; // @[:@1714.4]
  assign RetimeWrapper_io_flow = 1'h1; // @[package.scala 95:18:@1716.4]
  assign RetimeWrapper_io_in = SingleCounter_io_output_done; // @[package.scala 94:16:@1715.4]
  assign SRFF_clock = clock; // @[:@1722.4]
  assign SRFF_reset = reset; // @[:@1723.4]
  assign SRFF_io_input_set = RootController_sm_io_done; // @[Main.scala 51:29:@1942.4]
  assign SRFF_io_input_reset = RetimeWrapper_1_io_out; // @[Main.scala 40:31:@1805.4]
  assign SRFF_io_input_asyn_reset = RetimeWrapper_1_io_out; // @[Main.scala 41:36:@1806.4]
  assign RootController_sm_clock = clock; // @[:@1760.4]
  assign RootController_sm_reset = reset; // @[:@1761.4]
  assign RootController_sm_io_enable = _T_658 & _T_659; // @[Main.scala 39:33:@1804.4 SpatialBlocks.scala 112:18:@1838.4]
  assign RootController_sm_io_rst = RetimeWrapper_1_io_out; // @[SpatialBlocks.scala 106:15:@1832.4]
  assign RootController_sm_io_ctrDone = RootController_sm_io_ctrInc & _T_674; // @[Main.scala 43:34:@1812.4]
  assign RootController_sm_io_doneIn_0 = RootController_kernelRootController_concrete1_io_sigsOut_smDoneIn_0; // @[SpatialBlocks.scala 102:67:@1829.4]
  assign RetimeWrapper_1_clock = clock; // @[:@1792.4]
  assign RetimeWrapper_1_reset = reset; // @[:@1793.4]
  assign RetimeWrapper_1_io_flow = 1'h1; // @[package.scala 95:18:@1795.4]
  assign RetimeWrapper_1_io_in = reset | io_reset; // @[package.scala 94:16:@1794.4]
  assign RootController_kernelRootController_concrete1_clock = clock; // @[:@1851.4]
  assign RootController_kernelRootController_concrete1_reset = reset; // @[:@1852.4]
  assign RootController_kernelRootController_concrete1_io_in_x24_TDATA = io_axiStreamsIn_0_TDATA; // @[sm_RootController.scala 48:22:@1904.4]
  assign RootController_kernelRootController_concrete1_io_sigsIn_smEnableOuts_0 = RootController_sm_io_enableOut_0; // @[sm_RootController.scala 78:22:@1924.4]
  assign RootController_kernelRootController_concrete1_io_sigsIn_smChildAcks_0 = RootController_sm_io_childAck_0; // @[sm_RootController.scala 78:22:@1922.4]
  assign RootController_kernelRootController_concrete1_io_rr = RetimeWrapper_io_out; // @[sm_RootController.scala 77:18:@1916.4]
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
module SpatialIP( // @[:@1944.2]
  input         clock, // @[:@1945.4]
  input         reset, // @[:@1946.4]
  input  [31:0] io_raddr, // @[:@1947.4]
  input         io_wen, // @[:@1947.4]
  input  [31:0] io_waddr, // @[:@1947.4]
  input  [63:0] io_wdata, // @[:@1947.4]
  output [63:0] io_rdata // @[:@1947.4]
);
  wire  accel_clock; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_reset; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_enable; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_done; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_reset; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_loads_0_cmd_ready; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_loads_0_cmd_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_loads_0_cmd_bits_addr; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_cmd_bits_size; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_loads_0_data_ready; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_loads_0_data_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_0; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_1; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_2; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_3; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_4; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_5; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_6; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_7; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_8; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_9; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_10; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_11; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_12; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_13; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_14; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_loads_0_data_bits_rdata_15; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_stores_0_cmd_ready; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_stores_0_cmd_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_stores_0_cmd_bits_addr; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_cmd_bits_size; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_stores_0_data_ready; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_stores_0_data_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_0; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_1; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_2; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_3; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_4; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_5; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_6; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_7; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_8; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_9; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_10; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_11; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_12; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_13; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_14; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_stores_0_data_bits_wdata_15; // @[Instantiator.scala 53:44:@1949.4]
  wire [15:0] accel_io_memStreams_stores_0_data_bits_wstrb; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_stores_0_wresp_ready; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_stores_0_wresp_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_stores_0_wresp_bits; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_gathers_0_cmd_ready; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_gathers_0_cmd_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_0; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_1; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_2; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_3; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_4; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_5; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_6; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_7; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_8; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_9; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_10; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_11; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_12; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_13; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_14; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_gathers_0_cmd_bits_addr_15; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_gathers_0_data_ready; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_gathers_0_data_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_0; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_1; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_2; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_3; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_4; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_5; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_6; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_7; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_8; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_9; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_10; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_11; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_12; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_13; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_14; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_gathers_0_data_bits_15; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_scatters_0_cmd_ready; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_scatters_0_cmd_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_0; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_1; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_2; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_3; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_4; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_5; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_6; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_7; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_8; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_9; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_10; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_11; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_12; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_13; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_14; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_memStreams_scatters_0_cmd_bits_addr_addr_15; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_0; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_1; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_2; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_3; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_4; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_5; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_6; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_7; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_8; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_9; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_10; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_11; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_12; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_13; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_14; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_memStreams_scatters_0_cmd_bits_wdata_15; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_scatters_0_wresp_ready; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_scatters_0_wresp_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_memStreams_scatters_0_wresp_bits; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_axiStreamsIn_0_TVALID; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_axiStreamsIn_0_TREADY; // @[Instantiator.scala 53:44:@1949.4]
  wire [255:0] accel_io_axiStreamsIn_0_TDATA; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_axiStreamsIn_0_TSTRB; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_axiStreamsIn_0_TKEEP; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_axiStreamsIn_0_TLAST; // @[Instantiator.scala 53:44:@1949.4]
  wire [7:0] accel_io_axiStreamsIn_0_TID; // @[Instantiator.scala 53:44:@1949.4]
  wire [7:0] accel_io_axiStreamsIn_0_TDEST; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_axiStreamsIn_0_TUSER; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_axiStreamsOut_0_TVALID; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_axiStreamsOut_0_TREADY; // @[Instantiator.scala 53:44:@1949.4]
  wire [255:0] accel_io_axiStreamsOut_0_TDATA; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_axiStreamsOut_0_TSTRB; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_axiStreamsOut_0_TKEEP; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_axiStreamsOut_0_TLAST; // @[Instantiator.scala 53:44:@1949.4]
  wire [7:0] accel_io_axiStreamsOut_0_TID; // @[Instantiator.scala 53:44:@1949.4]
  wire [7:0] accel_io_axiStreamsOut_0_TDEST; // @[Instantiator.scala 53:44:@1949.4]
  wire [31:0] accel_io_axiStreamsOut_0_TUSER; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_heap_0_req_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_heap_0_req_bits_allocDealloc; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_heap_0_req_bits_sizeAddr; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_heap_0_resp_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_heap_0_resp_bits_allocDealloc; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_heap_0_resp_bits_sizeAddr; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_argIns_0; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_argOuts_0_port_ready; // @[Instantiator.scala 53:44:@1949.4]
  wire  accel_io_argOuts_0_port_valid; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_argOuts_0_port_bits; // @[Instantiator.scala 53:44:@1949.4]
  wire [63:0] accel_io_argOuts_0_echo; // @[Instantiator.scala 53:44:@1949.4]
  AccelUnit accel ( // @[Instantiator.scala 53:44:@1949.4]
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
  assign accel_clock = clock; // @[:@1950.4]
  assign accel_reset = reset; // @[:@1951.4]
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
