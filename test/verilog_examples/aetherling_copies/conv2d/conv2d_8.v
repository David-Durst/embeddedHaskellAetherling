module FIFO(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  output [7:0] O_0,
  output [7:0] O_1
);
  reg [7:0] _T__0; // @[FIFO.scala 13:26]
  reg [31:0] _RAND_0;
  reg [7:0] _T__1; // @[FIFO.scala 13:26]
  reg [31:0] _RAND_1;
  reg  _T_1; // @[FIFO.scala 15:27]
  reg [31:0] _RAND_2;
  assign valid_down = _T_1; // @[FIFO.scala 16:16]
  assign O_0 = _T__0; // @[FIFO.scala 14:7]
  assign O_1 = _T__1; // @[FIFO.scala 14:7]
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
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T__0 = _RAND_0[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T__1 = _RAND_1[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_1 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    _T__0 <= I_0;
    _T__1 <= I_1;
    if (reset) begin
      _T_1 <= 1'h0;
    end else begin
      _T_1 <= valid_up;
    end
  end
endmodule
module NestedCounters(
  input   CE,
  output  valid
);
  assign valid = CE; // @[NestedCounters.scala 65:13]
endmodule
module NestedCountersWithNumValid(
  input   CE,
  output  valid
);
  wire  NestedCounters_CE; // @[NestedCounters.scala 20:44]
  wire  NestedCounters_valid; // @[NestedCounters.scala 20:44]
  NestedCounters NestedCounters ( // @[NestedCounters.scala 20:44]
    .CE(NestedCounters_CE),
    .valid(NestedCounters_valid)
  );
  assign valid = NestedCounters_valid; // @[NestedCounters.scala 22:9]
  assign NestedCounters_CE = CE; // @[NestedCounters.scala 21:27]
endmodule
module RAM_ST(
  input        clock,
  input        RE,
  input        RADDR,
  output [7:0] RDATA,
  input        WE,
  input        WADDR,
  input  [7:0] WDATA
);
  wire  write_elem_counter_CE; // @[RAM_ST.scala 20:34]
  wire  write_elem_counter_valid; // @[RAM_ST.scala 20:34]
  wire  read_elem_counter_CE; // @[RAM_ST.scala 21:33]
  wire  read_elem_counter_valid; // @[RAM_ST.scala 21:33]
  reg [7:0] ram [0:1]; // @[RAM_ST.scala 29:24]
  reg [31:0] _RAND_0;
  wire [7:0] ram__T_8_data; // @[RAM_ST.scala 29:24]
  wire  ram__T_8_addr; // @[RAM_ST.scala 29:24]
  wire [7:0] ram__T_2_data; // @[RAM_ST.scala 29:24]
  wire  ram__T_2_addr; // @[RAM_ST.scala 29:24]
  wire  ram__T_2_mask; // @[RAM_ST.scala 29:24]
  wire  ram__T_2_en; // @[RAM_ST.scala 29:24]
  reg  ram__T_8_en_pipe_0;
  reg [31:0] _RAND_1;
  reg  ram__T_8_addr_pipe_0;
  reg [31:0] _RAND_2;
  wire [1:0] _T; // @[RAM_ST.scala 31:71]
  wire [1:0] _T_3; // @[RAM_ST.scala 32:46]
  NestedCountersWithNumValid write_elem_counter ( // @[RAM_ST.scala 20:34]
    .CE(write_elem_counter_CE),
    .valid(write_elem_counter_valid)
  );
  NestedCountersWithNumValid read_elem_counter ( // @[RAM_ST.scala 21:33]
    .CE(read_elem_counter_CE),
    .valid(read_elem_counter_valid)
  );
  assign ram__T_8_addr = ram__T_8_addr_pipe_0;
  assign ram__T_8_data = ram[ram__T_8_addr]; // @[RAM_ST.scala 29:24]
  assign ram__T_2_data = WDATA;
  assign ram__T_2_addr = _T[0];
  assign ram__T_2_mask = 1'h1;
  assign ram__T_2_en = write_elem_counter_valid;
  assign _T = {{1'd0}, WADDR}; // @[RAM_ST.scala 31:71]
  assign _T_3 = {{1'd0}, RADDR}; // @[RAM_ST.scala 32:46]
  assign RDATA = ram__T_8_data; // @[RAM_ST.scala 32:9]
  assign write_elem_counter_CE = WE; // @[RAM_ST.scala 23:25]
  assign read_elem_counter_CE = RE; // @[RAM_ST.scala 24:24]
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
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  _RAND_0 = {1{`RANDOM}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 2; initvar = initvar+1)
    ram[initvar] = _RAND_0[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  ram__T_8_en_pipe_0 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  ram__T_8_addr_pipe_0 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(ram__T_2_en & ram__T_2_mask) begin
      ram[ram__T_2_addr] <= ram__T_2_data; // @[RAM_ST.scala 29:24]
    end
    ram__T_8_en_pipe_0 <= read_elem_counter_valid;
    if (read_elem_counter_valid) begin
      ram__T_8_addr_pipe_0 <= _T_3[0];
    end
  end
endmodule
module ShiftT(
  input        clock,
  input        reset,
  input        valid_up,
  input  [7:0] I,
  output [7:0] O
);
  wire  RAM_ST_clock; // @[ShiftT.scala 39:29]
  wire  RAM_ST_RE; // @[ShiftT.scala 39:29]
  wire  RAM_ST_RADDR; // @[ShiftT.scala 39:29]
  wire [7:0] RAM_ST_RDATA; // @[ShiftT.scala 39:29]
  wire  RAM_ST_WE; // @[ShiftT.scala 39:29]
  wire  RAM_ST_WADDR; // @[ShiftT.scala 39:29]
  wire [7:0] RAM_ST_WDATA; // @[ShiftT.scala 39:29]
  wire  NestedCounters_CE; // @[ShiftT.scala 41:31]
  wire  NestedCounters_valid; // @[ShiftT.scala 41:31]
  reg  value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_3; // @[Counter.scala 38:22]
  RAM_ST RAM_ST ( // @[ShiftT.scala 39:29]
    .clock(RAM_ST_clock),
    .RE(RAM_ST_RE),
    .RADDR(RAM_ST_RADDR),
    .RDATA(RAM_ST_RDATA),
    .WE(RAM_ST_WE),
    .WADDR(RAM_ST_WADDR),
    .WDATA(RAM_ST_WDATA)
  );
  NestedCounters NestedCounters ( // @[ShiftT.scala 41:31]
    .CE(NestedCounters_CE),
    .valid(NestedCounters_valid)
  );
  assign _T_3 = value + 1'h1; // @[Counter.scala 38:22]
  assign O = RAM_ST_RDATA; // @[ShiftT.scala 51:7]
  assign RAM_ST_clock = clock;
  assign RAM_ST_RE = valid_up; // @[ShiftT.scala 49:20]
  assign RAM_ST_RADDR = value ? 1'h0 : _T_3; // @[ShiftT.scala 46:76 ShiftT.scala 47:38]
  assign RAM_ST_WE = valid_up; // @[ShiftT.scala 48:20]
  assign RAM_ST_WADDR = value; // @[ShiftT.scala 45:23]
  assign RAM_ST_WDATA = I; // @[ShiftT.scala 50:23]
  assign NestedCounters_CE = valid_up; // @[ShiftT.scala 42:22]
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
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  value = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      value <= 1'h0;
    end else if (valid_up) begin
      value <= _T_3;
    end
  end
endmodule
module ShiftTS(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  output [7:0] O_0,
  output [7:0] O_1
);
  wire  ShiftT_clock; // @[ShiftTS.scala 32:34]
  wire  ShiftT_reset; // @[ShiftTS.scala 32:34]
  wire  ShiftT_valid_up; // @[ShiftTS.scala 32:34]
  wire [7:0] ShiftT_I; // @[ShiftTS.scala 32:34]
  wire [7:0] ShiftT_O; // @[ShiftTS.scala 32:34]
  wire  ShiftT_1_clock; // @[ShiftTS.scala 32:34]
  wire  ShiftT_1_reset; // @[ShiftTS.scala 32:34]
  wire  ShiftT_1_valid_up; // @[ShiftTS.scala 32:34]
  wire [7:0] ShiftT_1_I; // @[ShiftTS.scala 32:34]
  wire [7:0] ShiftT_1_O; // @[ShiftTS.scala 32:34]
  ShiftT ShiftT ( // @[ShiftTS.scala 32:34]
    .clock(ShiftT_clock),
    .reset(ShiftT_reset),
    .valid_up(ShiftT_valid_up),
    .I(ShiftT_I),
    .O(ShiftT_O)
  );
  ShiftT ShiftT_1 ( // @[ShiftTS.scala 32:34]
    .clock(ShiftT_1_clock),
    .reset(ShiftT_1_reset),
    .valid_up(ShiftT_1_valid_up),
    .I(ShiftT_1_I),
    .O(ShiftT_1_O)
  );
  assign valid_down = valid_up; // @[ShiftTS.scala 39:14]
  assign O_0 = ShiftT_O; // @[ShiftTS.scala 34:36]
  assign O_1 = ShiftT_1_O; // @[ShiftTS.scala 34:36]
  assign ShiftT_clock = clock;
  assign ShiftT_reset = reset;
  assign ShiftT_valid_up = valid_up; // @[ShiftTS.scala 35:31]
  assign ShiftT_I = I_0; // @[ShiftTS.scala 33:24]
  assign ShiftT_1_clock = clock;
  assign ShiftT_1_reset = reset;
  assign ShiftT_1_valid_up = valid_up; // @[ShiftTS.scala 35:31]
  assign ShiftT_1_I = I_1; // @[ShiftTS.scala 33:24]
endmodule
module ShiftT_4(
  input        clock,
  input  [7:0] I,
  output [7:0] O
);
  reg [7:0] _T; // @[ShiftT.scala 24:82]
  reg [31:0] _RAND_0;
  assign O = _T; // @[ShiftT.scala 24:7]
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
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T = _RAND_0[7:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    _T <= I;
  end
endmodule
module ShiftTS_2(
  input        clock,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  output [7:0] O_0,
  output [7:0] O_1
);
  wire  ShiftT_clock; // @[ShiftTS.scala 32:34]
  wire [7:0] ShiftT_I; // @[ShiftTS.scala 32:34]
  wire [7:0] ShiftT_O; // @[ShiftTS.scala 32:34]
  ShiftT_4 ShiftT ( // @[ShiftTS.scala 32:34]
    .clock(ShiftT_clock),
    .I(ShiftT_I),
    .O(ShiftT_O)
  );
  assign valid_down = valid_up; // @[ShiftTS.scala 39:14]
  assign O_0 = ShiftT_O; // @[ShiftTS.scala 34:36]
  assign O_1 = I_0; // @[ShiftTS.scala 29:36]
  assign ShiftT_clock = clock;
  assign ShiftT_I = I_1; // @[ShiftTS.scala 33:24]
endmodule
module SSeqTupleCreator(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0,
  input  [7:0] I1,
  output [7:0] O_0,
  output [7:0] O_1
);
  assign valid_down = valid_up; // @[Tuple.scala 15:14]
  assign O_0 = I0; // @[Tuple.scala 12:32]
  assign O_1 = I1; // @[Tuple.scala 13:32]
endmodule
module Map2S(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I0_1,
  input  [7:0] I1_0,
  input  [7:0] I1_1,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_1_0,
  output [7:0] O_1_1
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1; // @[Map2S.scala 9:22]
  wire  other_ops_0_valid_up; // @[Map2S.scala 10:86]
  wire  other_ops_0_valid_down; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1; // @[Map2S.scala 10:86]
  SSeqTupleCreator fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0(fst_op_I0),
    .I1(fst_op_I1),
    .O_0(fst_op_O_0),
    .O_1(fst_op_O_1)
  );
  SSeqTupleCreator other_ops_0 ( // @[Map2S.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I0(other_ops_0_I0),
    .I1(other_ops_0_I1),
    .O_0(other_ops_0_O_0),
    .O_1(other_ops_0_O_1)
  );
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0 = fst_op_O_0; // @[Map2S.scala 19:8]
  assign O_0_1 = fst_op_O_1; // @[Map2S.scala 19:8]
  assign O_1_0 = other_ops_0_O_0; // @[Map2S.scala 24:12]
  assign O_1_1 = other_ops_0_O_1; // @[Map2S.scala 24:12]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0 = I0_0; // @[Map2S.scala 17:13]
  assign fst_op_I1 = I1_0; // @[Map2S.scala 18:13]
  assign other_ops_0_valid_up = valid_up; // @[Map2S.scala 21:39]
  assign other_ops_0_I0 = I0_1; // @[Map2S.scala 22:43]
  assign other_ops_0_I1 = I1_1; // @[Map2S.scala 23:43]
endmodule
module Map2T(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I0_1,
  input  [7:0] I1_0,
  input  [7:0] I1_1,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_1_0,
  output [7:0] O_1_1
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1; // @[Map2T.scala 8:20]
  Map2S op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0(op_I0_0),
    .I0_1(op_I0_1),
    .I1_0(op_I1_0),
    .I1_1(op_I1_1),
    .O_0_0(op_O_0_0),
    .O_0_1(op_O_0_1),
    .O_1_0(op_O_1_0),
    .O_1_1(op_O_1_1)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0_0 = op_O_0_0; // @[Map2T.scala 17:7]
  assign O_0_1 = op_O_0_1; // @[Map2T.scala 17:7]
  assign O_1_0 = op_O_1_0; // @[Map2T.scala 17:7]
  assign O_1_1 = op_O_1_1; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0 = I0_0; // @[Map2T.scala 15:11]
  assign op_I0_1 = I0_1; // @[Map2T.scala 15:11]
  assign op_I1_0 = I1_0; // @[Map2T.scala 16:11]
  assign op_I1_1 = I1_1; // @[Map2T.scala 16:11]
endmodule
module SSeqTupleAppender(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I0_1,
  input  [7:0] I1,
  output [7:0] O_0,
  output [7:0] O_1,
  output [7:0] O_2
);
  assign valid_down = valid_up; // @[Tuple.scala 28:14]
  assign O_0 = I0_0; // @[Tuple.scala 24:34]
  assign O_1 = I0_1; // @[Tuple.scala 24:34]
  assign O_2 = I1; // @[Tuple.scala 26:32]
endmodule
module Map2S_1(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I0_1_0,
  input  [7:0] I0_1_1,
  input  [7:0] I1_0,
  input  [7:0] I1_1,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2,
  output [7:0] O_1_0,
  output [7:0] O_1_1,
  output [7:0] O_1_2
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_2; // @[Map2S.scala 9:22]
  wire  other_ops_0_valid_up; // @[Map2S.scala 10:86]
  wire  other_ops_0_valid_down; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_2; // @[Map2S.scala 10:86]
  SSeqTupleAppender fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0_0(fst_op_I0_0),
    .I0_1(fst_op_I0_1),
    .I1(fst_op_I1),
    .O_0(fst_op_O_0),
    .O_1(fst_op_O_1),
    .O_2(fst_op_O_2)
  );
  SSeqTupleAppender other_ops_0 ( // @[Map2S.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I0_0(other_ops_0_I0_0),
    .I0_1(other_ops_0_I0_1),
    .I1(other_ops_0_I1),
    .O_0(other_ops_0_O_0),
    .O_1(other_ops_0_O_1),
    .O_2(other_ops_0_O_2)
  );
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0 = fst_op_O_0; // @[Map2S.scala 19:8]
  assign O_0_1 = fst_op_O_1; // @[Map2S.scala 19:8]
  assign O_0_2 = fst_op_O_2; // @[Map2S.scala 19:8]
  assign O_1_0 = other_ops_0_O_0; // @[Map2S.scala 24:12]
  assign O_1_1 = other_ops_0_O_1; // @[Map2S.scala 24:12]
  assign O_1_2 = other_ops_0_O_2; // @[Map2S.scala 24:12]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0_0 = I0_0_0; // @[Map2S.scala 17:13]
  assign fst_op_I0_1 = I0_0_1; // @[Map2S.scala 17:13]
  assign fst_op_I1 = I1_0; // @[Map2S.scala 18:13]
  assign other_ops_0_valid_up = valid_up; // @[Map2S.scala 21:39]
  assign other_ops_0_I0_0 = I0_1_0; // @[Map2S.scala 22:43]
  assign other_ops_0_I0_1 = I0_1_1; // @[Map2S.scala 22:43]
  assign other_ops_0_I1 = I1_1; // @[Map2S.scala 23:43]
endmodule
module Map2T_1(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I0_1_0,
  input  [7:0] I0_1_1,
  input  [7:0] I1_0,
  input  [7:0] I1_1,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2,
  output [7:0] O_1_0,
  output [7:0] O_1_1,
  output [7:0] O_1_2
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_2; // @[Map2T.scala 8:20]
  Map2S_1 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0_0(op_I0_0_0),
    .I0_0_1(op_I0_0_1),
    .I0_1_0(op_I0_1_0),
    .I0_1_1(op_I0_1_1),
    .I1_0(op_I1_0),
    .I1_1(op_I1_1),
    .O_0_0(op_O_0_0),
    .O_0_1(op_O_0_1),
    .O_0_2(op_O_0_2),
    .O_1_0(op_O_1_0),
    .O_1_1(op_O_1_1),
    .O_1_2(op_O_1_2)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0_0 = op_O_0_0; // @[Map2T.scala 17:7]
  assign O_0_1 = op_O_0_1; // @[Map2T.scala 17:7]
  assign O_0_2 = op_O_0_2; // @[Map2T.scala 17:7]
  assign O_1_0 = op_O_1_0; // @[Map2T.scala 17:7]
  assign O_1_1 = op_O_1_1; // @[Map2T.scala 17:7]
  assign O_1_2 = op_O_1_2; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0_0 = I0_0_0; // @[Map2T.scala 15:11]
  assign op_I0_0_1 = I0_0_1; // @[Map2T.scala 15:11]
  assign op_I0_1_0 = I0_1_0; // @[Map2T.scala 15:11]
  assign op_I0_1_1 = I0_1_1; // @[Map2T.scala 15:11]
  assign op_I1_0 = I1_0; // @[Map2T.scala 16:11]
  assign op_I1_1 = I1_1; // @[Map2T.scala 16:11]
endmodule
module PartitionS(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_0_2,
  input  [7:0] I_1_0,
  input  [7:0] I_1_1,
  input  [7:0] I_1_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_1_0_0,
  output [7:0] O_1_0_1,
  output [7:0] O_1_0_2
);
  assign valid_down = valid_up; // @[Partition.scala 18:14]
  assign O_0_0_0 = I_0_0; // @[Partition.scala 15:39]
  assign O_0_0_1 = I_0_1; // @[Partition.scala 15:39]
  assign O_0_0_2 = I_0_2; // @[Partition.scala 15:39]
  assign O_1_0_0 = I_1_0; // @[Partition.scala 15:39]
  assign O_1_0_1 = I_1_1; // @[Partition.scala 15:39]
  assign O_1_0_2 = I_1_2; // @[Partition.scala 15:39]
endmodule
module MapT(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_0_2,
  input  [7:0] I_1_0,
  input  [7:0] I_1_1,
  input  [7:0] I_1_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_1_0_0,
  output [7:0] O_1_0_1,
  output [7:0] O_1_0_2
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_2; // @[MapT.scala 8:20]
  PartitionS op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0(op_I_0_0),
    .I_0_1(op_I_0_1),
    .I_0_2(op_I_0_2),
    .I_1_0(op_I_1_0),
    .I_1_1(op_I_1_1),
    .I_1_2(op_I_1_2),
    .O_0_0_0(op_O_0_0_0),
    .O_0_0_1(op_O_0_0_1),
    .O_0_0_2(op_O_0_0_2),
    .O_1_0_0(op_O_1_0_0),
    .O_1_0_1(op_O_1_0_1),
    .O_1_0_2(op_O_1_0_2)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0_0 = op_O_0_0_0; // @[MapT.scala 15:7]
  assign O_0_0_1 = op_O_0_0_1; // @[MapT.scala 15:7]
  assign O_0_0_2 = op_O_0_0_2; // @[MapT.scala 15:7]
  assign O_1_0_0 = op_O_1_0_0; // @[MapT.scala 15:7]
  assign O_1_0_1 = op_O_1_0_1; // @[MapT.scala 15:7]
  assign O_1_0_2 = op_O_1_0_2; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0 = I_0_0; // @[MapT.scala 14:10]
  assign op_I_0_1 = I_0_1; // @[MapT.scala 14:10]
  assign op_I_0_2 = I_0_2; // @[MapT.scala 14:10]
  assign op_I_1_0 = I_1_0; // @[MapT.scala 14:10]
  assign op_I_1_1 = I_1_1; // @[MapT.scala 14:10]
  assign op_I_1_2 = I_1_2; // @[MapT.scala 14:10]
endmodule
module SSeqTupleToSSeq(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  input  [7:0] I_2,
  output [7:0] O_0,
  output [7:0] O_1,
  output [7:0] O_2
);
  assign valid_down = valid_up; // @[Tuple.scala 42:14]
  assign O_0 = I_0; // @[Tuple.scala 41:5]
  assign O_1 = I_1; // @[Tuple.scala 41:5]
  assign O_2 = I_2; // @[Tuple.scala 41:5]
endmodule
module Remove1S(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_0_2,
  output [7:0] O_0,
  output [7:0] O_1,
  output [7:0] O_2
);
  wire  op_inst_valid_up; // @[Remove1S.scala 9:23]
  wire  op_inst_valid_down; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_2; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_2; // @[Remove1S.scala 9:23]
  SSeqTupleToSSeq op_inst ( // @[Remove1S.scala 9:23]
    .valid_up(op_inst_valid_up),
    .valid_down(op_inst_valid_down),
    .I_0(op_inst_I_0),
    .I_1(op_inst_I_1),
    .I_2(op_inst_I_2),
    .O_0(op_inst_O_0),
    .O_1(op_inst_O_1),
    .O_2(op_inst_O_2)
  );
  assign valid_down = op_inst_valid_down; // @[Remove1S.scala 16:14]
  assign O_0 = op_inst_O_0; // @[Remove1S.scala 14:5]
  assign O_1 = op_inst_O_1; // @[Remove1S.scala 14:5]
  assign O_2 = op_inst_O_2; // @[Remove1S.scala 14:5]
  assign op_inst_valid_up = valid_up; // @[Remove1S.scala 15:20]
  assign op_inst_I_0 = I_0_0; // @[Remove1S.scala 13:13]
  assign op_inst_I_1 = I_0_1; // @[Remove1S.scala 13:13]
  assign op_inst_I_2 = I_0_2; // @[Remove1S.scala 13:13]
endmodule
module MapS(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  input  [7:0] I_0_0_2,
  input  [7:0] I_1_0_0,
  input  [7:0] I_1_0_1,
  input  [7:0] I_1_0_2,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2,
  output [7:0] O_1_0,
  output [7:0] O_1_1,
  output [7:0] O_1_2
);
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_2; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_2; // @[MapS.scala 9:22]
  wire  other_ops_0_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_2; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_2; // @[MapS.scala 10:86]
  Remove1S fst_op ( // @[MapS.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_0_0(fst_op_I_0_0),
    .I_0_1(fst_op_I_0_1),
    .I_0_2(fst_op_I_0_2),
    .O_0(fst_op_O_0),
    .O_1(fst_op_O_1),
    .O_2(fst_op_O_2)
  );
  Remove1S other_ops_0 ( // @[MapS.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I_0_0(other_ops_0_I_0_0),
    .I_0_1(other_ops_0_I_0_1),
    .I_0_2(other_ops_0_I_0_2),
    .O_0(other_ops_0_O_0),
    .O_1(other_ops_0_O_1),
    .O_2(other_ops_0_O_2)
  );
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[MapS.scala 23:14]
  assign O_0_0 = fst_op_O_0; // @[MapS.scala 17:8]
  assign O_0_1 = fst_op_O_1; // @[MapS.scala 17:8]
  assign O_0_2 = fst_op_O_2; // @[MapS.scala 17:8]
  assign O_1_0 = other_ops_0_O_0; // @[MapS.scala 21:12]
  assign O_1_1 = other_ops_0_O_1; // @[MapS.scala 21:12]
  assign O_1_2 = other_ops_0_O_2; // @[MapS.scala 21:12]
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_0_0 = I_0_0_0; // @[MapS.scala 16:12]
  assign fst_op_I_0_1 = I_0_0_1; // @[MapS.scala 16:12]
  assign fst_op_I_0_2 = I_0_0_2; // @[MapS.scala 16:12]
  assign other_ops_0_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_0_I_0_0 = I_1_0_0; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_1 = I_1_0_1; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_2 = I_1_0_2; // @[MapS.scala 20:41]
endmodule
module MapT_1(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  input  [7:0] I_0_0_2,
  input  [7:0] I_1_0_0,
  input  [7:0] I_1_0_1,
  input  [7:0] I_1_0_2,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2,
  output [7:0] O_1_0,
  output [7:0] O_1_1,
  output [7:0] O_1_2
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_2; // @[MapT.scala 8:20]
  MapS op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0_0(op_I_0_0_0),
    .I_0_0_1(op_I_0_0_1),
    .I_0_0_2(op_I_0_0_2),
    .I_1_0_0(op_I_1_0_0),
    .I_1_0_1(op_I_1_0_1),
    .I_1_0_2(op_I_1_0_2),
    .O_0_0(op_O_0_0),
    .O_0_1(op_O_0_1),
    .O_0_2(op_O_0_2),
    .O_1_0(op_O_1_0),
    .O_1_1(op_O_1_1),
    .O_1_2(op_O_1_2)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign O_0_1 = op_O_0_1; // @[MapT.scala 15:7]
  assign O_0_2 = op_O_0_2; // @[MapT.scala 15:7]
  assign O_1_0 = op_O_1_0; // @[MapT.scala 15:7]
  assign O_1_1 = op_O_1_1; // @[MapT.scala 15:7]
  assign O_1_2 = op_O_1_2; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0_0 = I_0_0_0; // @[MapT.scala 14:10]
  assign op_I_0_0_1 = I_0_0_1; // @[MapT.scala 14:10]
  assign op_I_0_0_2 = I_0_0_2; // @[MapT.scala 14:10]
  assign op_I_1_0_0 = I_1_0_0; // @[MapT.scala 14:10]
  assign op_I_1_0_1 = I_1_0_1; // @[MapT.scala 14:10]
  assign op_I_1_0_2 = I_1_0_2; // @[MapT.scala 14:10]
endmodule
module SSeqTupleCreator_2(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I0_1,
  input  [7:0] I0_2,
  input  [7:0] I1_0,
  input  [7:0] I1_1,
  input  [7:0] I1_2,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2,
  output [7:0] O_1_0,
  output [7:0] O_1_1,
  output [7:0] O_1_2
);
  assign valid_down = valid_up; // @[Tuple.scala 15:14]
  assign O_0_0 = I0_0; // @[Tuple.scala 12:32]
  assign O_0_1 = I0_1; // @[Tuple.scala 12:32]
  assign O_0_2 = I0_2; // @[Tuple.scala 12:32]
  assign O_1_0 = I1_0; // @[Tuple.scala 13:32]
  assign O_1_1 = I1_1; // @[Tuple.scala 13:32]
  assign O_1_2 = I1_2; // @[Tuple.scala 13:32]
endmodule
module Map2S_4(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I0_0_2,
  input  [7:0] I0_1_0,
  input  [7:0] I0_1_1,
  input  [7:0] I0_1_2,
  input  [7:0] I1_0_0,
  input  [7:0] I1_0_1,
  input  [7:0] I1_0_2,
  input  [7:0] I1_1_0,
  input  [7:0] I1_1_1,
  input  [7:0] I1_1_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1,
  output [7:0] O_0_1_2,
  output [7:0] O_1_0_0,
  output [7:0] O_1_0_1,
  output [7:0] O_1_0_2,
  output [7:0] O_1_1_0,
  output [7:0] O_1_1_1,
  output [7:0] O_1_1_2
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_2; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_2; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_2; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_2; // @[Map2S.scala 9:22]
  wire  other_ops_0_valid_up; // @[Map2S.scala 10:86]
  wire  other_ops_0_valid_down; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1_2; // @[Map2S.scala 10:86]
  SSeqTupleCreator_2 fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0_0(fst_op_I0_0),
    .I0_1(fst_op_I0_1),
    .I0_2(fst_op_I0_2),
    .I1_0(fst_op_I1_0),
    .I1_1(fst_op_I1_1),
    .I1_2(fst_op_I1_2),
    .O_0_0(fst_op_O_0_0),
    .O_0_1(fst_op_O_0_1),
    .O_0_2(fst_op_O_0_2),
    .O_1_0(fst_op_O_1_0),
    .O_1_1(fst_op_O_1_1),
    .O_1_2(fst_op_O_1_2)
  );
  SSeqTupleCreator_2 other_ops_0 ( // @[Map2S.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I0_0(other_ops_0_I0_0),
    .I0_1(other_ops_0_I0_1),
    .I0_2(other_ops_0_I0_2),
    .I1_0(other_ops_0_I1_0),
    .I1_1(other_ops_0_I1_1),
    .I1_2(other_ops_0_I1_2),
    .O_0_0(other_ops_0_O_0_0),
    .O_0_1(other_ops_0_O_0_1),
    .O_0_2(other_ops_0_O_0_2),
    .O_1_0(other_ops_0_O_1_0),
    .O_1_1(other_ops_0_O_1_1),
    .O_1_2(other_ops_0_O_1_2)
  );
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0_0 = fst_op_O_0_0; // @[Map2S.scala 19:8]
  assign O_0_0_1 = fst_op_O_0_1; // @[Map2S.scala 19:8]
  assign O_0_0_2 = fst_op_O_0_2; // @[Map2S.scala 19:8]
  assign O_0_1_0 = fst_op_O_1_0; // @[Map2S.scala 19:8]
  assign O_0_1_1 = fst_op_O_1_1; // @[Map2S.scala 19:8]
  assign O_0_1_2 = fst_op_O_1_2; // @[Map2S.scala 19:8]
  assign O_1_0_0 = other_ops_0_O_0_0; // @[Map2S.scala 24:12]
  assign O_1_0_1 = other_ops_0_O_0_1; // @[Map2S.scala 24:12]
  assign O_1_0_2 = other_ops_0_O_0_2; // @[Map2S.scala 24:12]
  assign O_1_1_0 = other_ops_0_O_1_0; // @[Map2S.scala 24:12]
  assign O_1_1_1 = other_ops_0_O_1_1; // @[Map2S.scala 24:12]
  assign O_1_1_2 = other_ops_0_O_1_2; // @[Map2S.scala 24:12]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0_0 = I0_0_0; // @[Map2S.scala 17:13]
  assign fst_op_I0_1 = I0_0_1; // @[Map2S.scala 17:13]
  assign fst_op_I0_2 = I0_0_2; // @[Map2S.scala 17:13]
  assign fst_op_I1_0 = I1_0_0; // @[Map2S.scala 18:13]
  assign fst_op_I1_1 = I1_0_1; // @[Map2S.scala 18:13]
  assign fst_op_I1_2 = I1_0_2; // @[Map2S.scala 18:13]
  assign other_ops_0_valid_up = valid_up; // @[Map2S.scala 21:39]
  assign other_ops_0_I0_0 = I0_1_0; // @[Map2S.scala 22:43]
  assign other_ops_0_I0_1 = I0_1_1; // @[Map2S.scala 22:43]
  assign other_ops_0_I0_2 = I0_1_2; // @[Map2S.scala 22:43]
  assign other_ops_0_I1_0 = I1_1_0; // @[Map2S.scala 23:43]
  assign other_ops_0_I1_1 = I1_1_1; // @[Map2S.scala 23:43]
  assign other_ops_0_I1_2 = I1_1_2; // @[Map2S.scala 23:43]
endmodule
module Map2T_4(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I0_0_2,
  input  [7:0] I0_1_0,
  input  [7:0] I0_1_1,
  input  [7:0] I0_1_2,
  input  [7:0] I1_0_0,
  input  [7:0] I1_0_1,
  input  [7:0] I1_0_2,
  input  [7:0] I1_1_0,
  input  [7:0] I1_1_1,
  input  [7:0] I1_1_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1,
  output [7:0] O_0_1_2,
  output [7:0] O_1_0_0,
  output [7:0] O_1_0_1,
  output [7:0] O_1_0_2,
  output [7:0] O_1_1_0,
  output [7:0] O_1_1_1,
  output [7:0] O_1_1_2
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_1_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1_2; // @[Map2T.scala 8:20]
  Map2S_4 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0_0(op_I0_0_0),
    .I0_0_1(op_I0_0_1),
    .I0_0_2(op_I0_0_2),
    .I0_1_0(op_I0_1_0),
    .I0_1_1(op_I0_1_1),
    .I0_1_2(op_I0_1_2),
    .I1_0_0(op_I1_0_0),
    .I1_0_1(op_I1_0_1),
    .I1_0_2(op_I1_0_2),
    .I1_1_0(op_I1_1_0),
    .I1_1_1(op_I1_1_1),
    .I1_1_2(op_I1_1_2),
    .O_0_0_0(op_O_0_0_0),
    .O_0_0_1(op_O_0_0_1),
    .O_0_0_2(op_O_0_0_2),
    .O_0_1_0(op_O_0_1_0),
    .O_0_1_1(op_O_0_1_1),
    .O_0_1_2(op_O_0_1_2),
    .O_1_0_0(op_O_1_0_0),
    .O_1_0_1(op_O_1_0_1),
    .O_1_0_2(op_O_1_0_2),
    .O_1_1_0(op_O_1_1_0),
    .O_1_1_1(op_O_1_1_1),
    .O_1_1_2(op_O_1_1_2)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0_0_0 = op_O_0_0_0; // @[Map2T.scala 17:7]
  assign O_0_0_1 = op_O_0_0_1; // @[Map2T.scala 17:7]
  assign O_0_0_2 = op_O_0_0_2; // @[Map2T.scala 17:7]
  assign O_0_1_0 = op_O_0_1_0; // @[Map2T.scala 17:7]
  assign O_0_1_1 = op_O_0_1_1; // @[Map2T.scala 17:7]
  assign O_0_1_2 = op_O_0_1_2; // @[Map2T.scala 17:7]
  assign O_1_0_0 = op_O_1_0_0; // @[Map2T.scala 17:7]
  assign O_1_0_1 = op_O_1_0_1; // @[Map2T.scala 17:7]
  assign O_1_0_2 = op_O_1_0_2; // @[Map2T.scala 17:7]
  assign O_1_1_0 = op_O_1_1_0; // @[Map2T.scala 17:7]
  assign O_1_1_1 = op_O_1_1_1; // @[Map2T.scala 17:7]
  assign O_1_1_2 = op_O_1_1_2; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0_0 = I0_0_0; // @[Map2T.scala 15:11]
  assign op_I0_0_1 = I0_0_1; // @[Map2T.scala 15:11]
  assign op_I0_0_2 = I0_0_2; // @[Map2T.scala 15:11]
  assign op_I0_1_0 = I0_1_0; // @[Map2T.scala 15:11]
  assign op_I0_1_1 = I0_1_1; // @[Map2T.scala 15:11]
  assign op_I0_1_2 = I0_1_2; // @[Map2T.scala 15:11]
  assign op_I1_0_0 = I1_0_0; // @[Map2T.scala 16:11]
  assign op_I1_0_1 = I1_0_1; // @[Map2T.scala 16:11]
  assign op_I1_0_2 = I1_0_2; // @[Map2T.scala 16:11]
  assign op_I1_1_0 = I1_1_0; // @[Map2T.scala 16:11]
  assign op_I1_1_1 = I1_1_1; // @[Map2T.scala 16:11]
  assign op_I1_1_2 = I1_1_2; // @[Map2T.scala 16:11]
endmodule
module SSeqTupleAppender_3(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I0_0_2,
  input  [7:0] I0_1_0,
  input  [7:0] I0_1_1,
  input  [7:0] I0_1_2,
  input  [7:0] I1_0,
  input  [7:0] I1_1,
  input  [7:0] I1_2,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2,
  output [7:0] O_1_0,
  output [7:0] O_1_1,
  output [7:0] O_1_2,
  output [7:0] O_2_0,
  output [7:0] O_2_1,
  output [7:0] O_2_2
);
  assign valid_down = valid_up; // @[Tuple.scala 28:14]
  assign O_0_0 = I0_0_0; // @[Tuple.scala 24:34]
  assign O_0_1 = I0_0_1; // @[Tuple.scala 24:34]
  assign O_0_2 = I0_0_2; // @[Tuple.scala 24:34]
  assign O_1_0 = I0_1_0; // @[Tuple.scala 24:34]
  assign O_1_1 = I0_1_1; // @[Tuple.scala 24:34]
  assign O_1_2 = I0_1_2; // @[Tuple.scala 24:34]
  assign O_2_0 = I1_0; // @[Tuple.scala 26:32]
  assign O_2_1 = I1_1; // @[Tuple.scala 26:32]
  assign O_2_2 = I1_2; // @[Tuple.scala 26:32]
endmodule
module Map2S_7(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0_0,
  input  [7:0] I0_0_0_1,
  input  [7:0] I0_0_0_2,
  input  [7:0] I0_0_1_0,
  input  [7:0] I0_0_1_1,
  input  [7:0] I0_0_1_2,
  input  [7:0] I0_1_0_0,
  input  [7:0] I0_1_0_1,
  input  [7:0] I0_1_0_2,
  input  [7:0] I0_1_1_0,
  input  [7:0] I0_1_1_1,
  input  [7:0] I0_1_1_2,
  input  [7:0] I1_0_0,
  input  [7:0] I1_0_1,
  input  [7:0] I1_0_2,
  input  [7:0] I1_1_0,
  input  [7:0] I1_1_1,
  input  [7:0] I1_1_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1,
  output [7:0] O_0_1_2,
  output [7:0] O_0_2_0,
  output [7:0] O_0_2_1,
  output [7:0] O_0_2_2,
  output [7:0] O_1_0_0,
  output [7:0] O_1_0_1,
  output [7:0] O_1_0_2,
  output [7:0] O_1_1_0,
  output [7:0] O_1_1_1,
  output [7:0] O_1_1_2,
  output [7:0] O_1_2_0,
  output [7:0] O_1_2_1,
  output [7:0] O_1_2_2
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_0_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_0_2; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_1_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_1_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_1_2; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_2; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_2; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_2; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_2_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_2_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_2_2; // @[Map2S.scala 9:22]
  wire  other_ops_0_valid_up; // @[Map2S.scala 10:86]
  wire  other_ops_0_valid_down; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_0_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_0_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_0_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_1_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_1_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_1_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_2_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_2_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_2_2; // @[Map2S.scala 10:86]
  SSeqTupleAppender_3 fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0_0_0(fst_op_I0_0_0),
    .I0_0_1(fst_op_I0_0_1),
    .I0_0_2(fst_op_I0_0_2),
    .I0_1_0(fst_op_I0_1_0),
    .I0_1_1(fst_op_I0_1_1),
    .I0_1_2(fst_op_I0_1_2),
    .I1_0(fst_op_I1_0),
    .I1_1(fst_op_I1_1),
    .I1_2(fst_op_I1_2),
    .O_0_0(fst_op_O_0_0),
    .O_0_1(fst_op_O_0_1),
    .O_0_2(fst_op_O_0_2),
    .O_1_0(fst_op_O_1_0),
    .O_1_1(fst_op_O_1_1),
    .O_1_2(fst_op_O_1_2),
    .O_2_0(fst_op_O_2_0),
    .O_2_1(fst_op_O_2_1),
    .O_2_2(fst_op_O_2_2)
  );
  SSeqTupleAppender_3 other_ops_0 ( // @[Map2S.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I0_0_0(other_ops_0_I0_0_0),
    .I0_0_1(other_ops_0_I0_0_1),
    .I0_0_2(other_ops_0_I0_0_2),
    .I0_1_0(other_ops_0_I0_1_0),
    .I0_1_1(other_ops_0_I0_1_1),
    .I0_1_2(other_ops_0_I0_1_2),
    .I1_0(other_ops_0_I1_0),
    .I1_1(other_ops_0_I1_1),
    .I1_2(other_ops_0_I1_2),
    .O_0_0(other_ops_0_O_0_0),
    .O_0_1(other_ops_0_O_0_1),
    .O_0_2(other_ops_0_O_0_2),
    .O_1_0(other_ops_0_O_1_0),
    .O_1_1(other_ops_0_O_1_1),
    .O_1_2(other_ops_0_O_1_2),
    .O_2_0(other_ops_0_O_2_0),
    .O_2_1(other_ops_0_O_2_1),
    .O_2_2(other_ops_0_O_2_2)
  );
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0_0 = fst_op_O_0_0; // @[Map2S.scala 19:8]
  assign O_0_0_1 = fst_op_O_0_1; // @[Map2S.scala 19:8]
  assign O_0_0_2 = fst_op_O_0_2; // @[Map2S.scala 19:8]
  assign O_0_1_0 = fst_op_O_1_0; // @[Map2S.scala 19:8]
  assign O_0_1_1 = fst_op_O_1_1; // @[Map2S.scala 19:8]
  assign O_0_1_2 = fst_op_O_1_2; // @[Map2S.scala 19:8]
  assign O_0_2_0 = fst_op_O_2_0; // @[Map2S.scala 19:8]
  assign O_0_2_1 = fst_op_O_2_1; // @[Map2S.scala 19:8]
  assign O_0_2_2 = fst_op_O_2_2; // @[Map2S.scala 19:8]
  assign O_1_0_0 = other_ops_0_O_0_0; // @[Map2S.scala 24:12]
  assign O_1_0_1 = other_ops_0_O_0_1; // @[Map2S.scala 24:12]
  assign O_1_0_2 = other_ops_0_O_0_2; // @[Map2S.scala 24:12]
  assign O_1_1_0 = other_ops_0_O_1_0; // @[Map2S.scala 24:12]
  assign O_1_1_1 = other_ops_0_O_1_1; // @[Map2S.scala 24:12]
  assign O_1_1_2 = other_ops_0_O_1_2; // @[Map2S.scala 24:12]
  assign O_1_2_0 = other_ops_0_O_2_0; // @[Map2S.scala 24:12]
  assign O_1_2_1 = other_ops_0_O_2_1; // @[Map2S.scala 24:12]
  assign O_1_2_2 = other_ops_0_O_2_2; // @[Map2S.scala 24:12]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0_0_0 = I0_0_0_0; // @[Map2S.scala 17:13]
  assign fst_op_I0_0_1 = I0_0_0_1; // @[Map2S.scala 17:13]
  assign fst_op_I0_0_2 = I0_0_0_2; // @[Map2S.scala 17:13]
  assign fst_op_I0_1_0 = I0_0_1_0; // @[Map2S.scala 17:13]
  assign fst_op_I0_1_1 = I0_0_1_1; // @[Map2S.scala 17:13]
  assign fst_op_I0_1_2 = I0_0_1_2; // @[Map2S.scala 17:13]
  assign fst_op_I1_0 = I1_0_0; // @[Map2S.scala 18:13]
  assign fst_op_I1_1 = I1_0_1; // @[Map2S.scala 18:13]
  assign fst_op_I1_2 = I1_0_2; // @[Map2S.scala 18:13]
  assign other_ops_0_valid_up = valid_up; // @[Map2S.scala 21:39]
  assign other_ops_0_I0_0_0 = I0_1_0_0; // @[Map2S.scala 22:43]
  assign other_ops_0_I0_0_1 = I0_1_0_1; // @[Map2S.scala 22:43]
  assign other_ops_0_I0_0_2 = I0_1_0_2; // @[Map2S.scala 22:43]
  assign other_ops_0_I0_1_0 = I0_1_1_0; // @[Map2S.scala 22:43]
  assign other_ops_0_I0_1_1 = I0_1_1_1; // @[Map2S.scala 22:43]
  assign other_ops_0_I0_1_2 = I0_1_1_2; // @[Map2S.scala 22:43]
  assign other_ops_0_I1_0 = I1_1_0; // @[Map2S.scala 23:43]
  assign other_ops_0_I1_1 = I1_1_1; // @[Map2S.scala 23:43]
  assign other_ops_0_I1_2 = I1_1_2; // @[Map2S.scala 23:43]
endmodule
module Map2T_7(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0_0,
  input  [7:0] I0_0_0_1,
  input  [7:0] I0_0_0_2,
  input  [7:0] I0_0_1_0,
  input  [7:0] I0_0_1_1,
  input  [7:0] I0_0_1_2,
  input  [7:0] I0_1_0_0,
  input  [7:0] I0_1_0_1,
  input  [7:0] I0_1_0_2,
  input  [7:0] I0_1_1_0,
  input  [7:0] I0_1_1_1,
  input  [7:0] I0_1_1_2,
  input  [7:0] I1_0_0,
  input  [7:0] I1_0_1,
  input  [7:0] I1_0_2,
  input  [7:0] I1_1_0,
  input  [7:0] I1_1_1,
  input  [7:0] I1_1_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1,
  output [7:0] O_0_1_2,
  output [7:0] O_0_2_0,
  output [7:0] O_0_2_1,
  output [7:0] O_0_2_2,
  output [7:0] O_1_0_0,
  output [7:0] O_1_0_1,
  output [7:0] O_1_0_2,
  output [7:0] O_1_1_0,
  output [7:0] O_1_1_1,
  output [7:0] O_1_1_2,
  output [7:0] O_1_2_0,
  output [7:0] O_1_2_1,
  output [7:0] O_1_2_2
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_1_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_1_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_2_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_2_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_2_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_2_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_2_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_2_2; // @[Map2T.scala 8:20]
  Map2S_7 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0_0_0(op_I0_0_0_0),
    .I0_0_0_1(op_I0_0_0_1),
    .I0_0_0_2(op_I0_0_0_2),
    .I0_0_1_0(op_I0_0_1_0),
    .I0_0_1_1(op_I0_0_1_1),
    .I0_0_1_2(op_I0_0_1_2),
    .I0_1_0_0(op_I0_1_0_0),
    .I0_1_0_1(op_I0_1_0_1),
    .I0_1_0_2(op_I0_1_0_2),
    .I0_1_1_0(op_I0_1_1_0),
    .I0_1_1_1(op_I0_1_1_1),
    .I0_1_1_2(op_I0_1_1_2),
    .I1_0_0(op_I1_0_0),
    .I1_0_1(op_I1_0_1),
    .I1_0_2(op_I1_0_2),
    .I1_1_0(op_I1_1_0),
    .I1_1_1(op_I1_1_1),
    .I1_1_2(op_I1_1_2),
    .O_0_0_0(op_O_0_0_0),
    .O_0_0_1(op_O_0_0_1),
    .O_0_0_2(op_O_0_0_2),
    .O_0_1_0(op_O_0_1_0),
    .O_0_1_1(op_O_0_1_1),
    .O_0_1_2(op_O_0_1_2),
    .O_0_2_0(op_O_0_2_0),
    .O_0_2_1(op_O_0_2_1),
    .O_0_2_2(op_O_0_2_2),
    .O_1_0_0(op_O_1_0_0),
    .O_1_0_1(op_O_1_0_1),
    .O_1_0_2(op_O_1_0_2),
    .O_1_1_0(op_O_1_1_0),
    .O_1_1_1(op_O_1_1_1),
    .O_1_1_2(op_O_1_1_2),
    .O_1_2_0(op_O_1_2_0),
    .O_1_2_1(op_O_1_2_1),
    .O_1_2_2(op_O_1_2_2)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0_0_0 = op_O_0_0_0; // @[Map2T.scala 17:7]
  assign O_0_0_1 = op_O_0_0_1; // @[Map2T.scala 17:7]
  assign O_0_0_2 = op_O_0_0_2; // @[Map2T.scala 17:7]
  assign O_0_1_0 = op_O_0_1_0; // @[Map2T.scala 17:7]
  assign O_0_1_1 = op_O_0_1_1; // @[Map2T.scala 17:7]
  assign O_0_1_2 = op_O_0_1_2; // @[Map2T.scala 17:7]
  assign O_0_2_0 = op_O_0_2_0; // @[Map2T.scala 17:7]
  assign O_0_2_1 = op_O_0_2_1; // @[Map2T.scala 17:7]
  assign O_0_2_2 = op_O_0_2_2; // @[Map2T.scala 17:7]
  assign O_1_0_0 = op_O_1_0_0; // @[Map2T.scala 17:7]
  assign O_1_0_1 = op_O_1_0_1; // @[Map2T.scala 17:7]
  assign O_1_0_2 = op_O_1_0_2; // @[Map2T.scala 17:7]
  assign O_1_1_0 = op_O_1_1_0; // @[Map2T.scala 17:7]
  assign O_1_1_1 = op_O_1_1_1; // @[Map2T.scala 17:7]
  assign O_1_1_2 = op_O_1_1_2; // @[Map2T.scala 17:7]
  assign O_1_2_0 = op_O_1_2_0; // @[Map2T.scala 17:7]
  assign O_1_2_1 = op_O_1_2_1; // @[Map2T.scala 17:7]
  assign O_1_2_2 = op_O_1_2_2; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0_0_0 = I0_0_0_0; // @[Map2T.scala 15:11]
  assign op_I0_0_0_1 = I0_0_0_1; // @[Map2T.scala 15:11]
  assign op_I0_0_0_2 = I0_0_0_2; // @[Map2T.scala 15:11]
  assign op_I0_0_1_0 = I0_0_1_0; // @[Map2T.scala 15:11]
  assign op_I0_0_1_1 = I0_0_1_1; // @[Map2T.scala 15:11]
  assign op_I0_0_1_2 = I0_0_1_2; // @[Map2T.scala 15:11]
  assign op_I0_1_0_0 = I0_1_0_0; // @[Map2T.scala 15:11]
  assign op_I0_1_0_1 = I0_1_0_1; // @[Map2T.scala 15:11]
  assign op_I0_1_0_2 = I0_1_0_2; // @[Map2T.scala 15:11]
  assign op_I0_1_1_0 = I0_1_1_0; // @[Map2T.scala 15:11]
  assign op_I0_1_1_1 = I0_1_1_1; // @[Map2T.scala 15:11]
  assign op_I0_1_1_2 = I0_1_1_2; // @[Map2T.scala 15:11]
  assign op_I1_0_0 = I1_0_0; // @[Map2T.scala 16:11]
  assign op_I1_0_1 = I1_0_1; // @[Map2T.scala 16:11]
  assign op_I1_0_2 = I1_0_2; // @[Map2T.scala 16:11]
  assign op_I1_1_0 = I1_1_0; // @[Map2T.scala 16:11]
  assign op_I1_1_1 = I1_1_1; // @[Map2T.scala 16:11]
  assign op_I1_1_2 = I1_1_2; // @[Map2T.scala 16:11]
endmodule
module PartitionS_3(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  input  [7:0] I_0_0_2,
  input  [7:0] I_0_1_0,
  input  [7:0] I_0_1_1,
  input  [7:0] I_0_1_2,
  input  [7:0] I_0_2_0,
  input  [7:0] I_0_2_1,
  input  [7:0] I_0_2_2,
  input  [7:0] I_1_0_0,
  input  [7:0] I_1_0_1,
  input  [7:0] I_1_0_2,
  input  [7:0] I_1_1_0,
  input  [7:0] I_1_1_1,
  input  [7:0] I_1_1_2,
  input  [7:0] I_1_2_0,
  input  [7:0] I_1_2_1,
  input  [7:0] I_1_2_2,
  output [7:0] O_0_0_0_0,
  output [7:0] O_0_0_0_1,
  output [7:0] O_0_0_0_2,
  output [7:0] O_0_0_1_0,
  output [7:0] O_0_0_1_1,
  output [7:0] O_0_0_1_2,
  output [7:0] O_0_0_2_0,
  output [7:0] O_0_0_2_1,
  output [7:0] O_0_0_2_2,
  output [7:0] O_1_0_0_0,
  output [7:0] O_1_0_0_1,
  output [7:0] O_1_0_0_2,
  output [7:0] O_1_0_1_0,
  output [7:0] O_1_0_1_1,
  output [7:0] O_1_0_1_2,
  output [7:0] O_1_0_2_0,
  output [7:0] O_1_0_2_1,
  output [7:0] O_1_0_2_2
);
  assign valid_down = valid_up; // @[Partition.scala 18:14]
  assign O_0_0_0_0 = I_0_0_0; // @[Partition.scala 15:39]
  assign O_0_0_0_1 = I_0_0_1; // @[Partition.scala 15:39]
  assign O_0_0_0_2 = I_0_0_2; // @[Partition.scala 15:39]
  assign O_0_0_1_0 = I_0_1_0; // @[Partition.scala 15:39]
  assign O_0_0_1_1 = I_0_1_1; // @[Partition.scala 15:39]
  assign O_0_0_1_2 = I_0_1_2; // @[Partition.scala 15:39]
  assign O_0_0_2_0 = I_0_2_0; // @[Partition.scala 15:39]
  assign O_0_0_2_1 = I_0_2_1; // @[Partition.scala 15:39]
  assign O_0_0_2_2 = I_0_2_2; // @[Partition.scala 15:39]
  assign O_1_0_0_0 = I_1_0_0; // @[Partition.scala 15:39]
  assign O_1_0_0_1 = I_1_0_1; // @[Partition.scala 15:39]
  assign O_1_0_0_2 = I_1_0_2; // @[Partition.scala 15:39]
  assign O_1_0_1_0 = I_1_1_0; // @[Partition.scala 15:39]
  assign O_1_0_1_1 = I_1_1_1; // @[Partition.scala 15:39]
  assign O_1_0_1_2 = I_1_1_2; // @[Partition.scala 15:39]
  assign O_1_0_2_0 = I_1_2_0; // @[Partition.scala 15:39]
  assign O_1_0_2_1 = I_1_2_1; // @[Partition.scala 15:39]
  assign O_1_0_2_2 = I_1_2_2; // @[Partition.scala 15:39]
endmodule
module MapT_6(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  input  [7:0] I_0_0_2,
  input  [7:0] I_0_1_0,
  input  [7:0] I_0_1_1,
  input  [7:0] I_0_1_2,
  input  [7:0] I_0_2_0,
  input  [7:0] I_0_2_1,
  input  [7:0] I_0_2_2,
  input  [7:0] I_1_0_0,
  input  [7:0] I_1_0_1,
  input  [7:0] I_1_0_2,
  input  [7:0] I_1_1_0,
  input  [7:0] I_1_1_1,
  input  [7:0] I_1_1_2,
  input  [7:0] I_1_2_0,
  input  [7:0] I_1_2_1,
  input  [7:0] I_1_2_2,
  output [7:0] O_0_0_0_0,
  output [7:0] O_0_0_0_1,
  output [7:0] O_0_0_0_2,
  output [7:0] O_0_0_1_0,
  output [7:0] O_0_0_1_1,
  output [7:0] O_0_0_1_2,
  output [7:0] O_0_0_2_0,
  output [7:0] O_0_0_2_1,
  output [7:0] O_0_0_2_2,
  output [7:0] O_1_0_0_0,
  output [7:0] O_1_0_0_1,
  output [7:0] O_1_0_0_2,
  output [7:0] O_1_0_1_0,
  output [7:0] O_1_0_1_1,
  output [7:0] O_1_0_1_2,
  output [7:0] O_1_0_2_0,
  output [7:0] O_1_0_2_1,
  output [7:0] O_1_0_2_2
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_2_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_2_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_2_2; // @[MapT.scala 8:20]
  PartitionS_3 op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0_0(op_I_0_0_0),
    .I_0_0_1(op_I_0_0_1),
    .I_0_0_2(op_I_0_0_2),
    .I_0_1_0(op_I_0_1_0),
    .I_0_1_1(op_I_0_1_1),
    .I_0_1_2(op_I_0_1_2),
    .I_0_2_0(op_I_0_2_0),
    .I_0_2_1(op_I_0_2_1),
    .I_0_2_2(op_I_0_2_2),
    .I_1_0_0(op_I_1_0_0),
    .I_1_0_1(op_I_1_0_1),
    .I_1_0_2(op_I_1_0_2),
    .I_1_1_0(op_I_1_1_0),
    .I_1_1_1(op_I_1_1_1),
    .I_1_1_2(op_I_1_1_2),
    .I_1_2_0(op_I_1_2_0),
    .I_1_2_1(op_I_1_2_1),
    .I_1_2_2(op_I_1_2_2),
    .O_0_0_0_0(op_O_0_0_0_0),
    .O_0_0_0_1(op_O_0_0_0_1),
    .O_0_0_0_2(op_O_0_0_0_2),
    .O_0_0_1_0(op_O_0_0_1_0),
    .O_0_0_1_1(op_O_0_0_1_1),
    .O_0_0_1_2(op_O_0_0_1_2),
    .O_0_0_2_0(op_O_0_0_2_0),
    .O_0_0_2_1(op_O_0_0_2_1),
    .O_0_0_2_2(op_O_0_0_2_2),
    .O_1_0_0_0(op_O_1_0_0_0),
    .O_1_0_0_1(op_O_1_0_0_1),
    .O_1_0_0_2(op_O_1_0_0_2),
    .O_1_0_1_0(op_O_1_0_1_0),
    .O_1_0_1_1(op_O_1_0_1_1),
    .O_1_0_1_2(op_O_1_0_1_2),
    .O_1_0_2_0(op_O_1_0_2_0),
    .O_1_0_2_1(op_O_1_0_2_1),
    .O_1_0_2_2(op_O_1_0_2_2)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0_0_0 = op_O_0_0_0_0; // @[MapT.scala 15:7]
  assign O_0_0_0_1 = op_O_0_0_0_1; // @[MapT.scala 15:7]
  assign O_0_0_0_2 = op_O_0_0_0_2; // @[MapT.scala 15:7]
  assign O_0_0_1_0 = op_O_0_0_1_0; // @[MapT.scala 15:7]
  assign O_0_0_1_1 = op_O_0_0_1_1; // @[MapT.scala 15:7]
  assign O_0_0_1_2 = op_O_0_0_1_2; // @[MapT.scala 15:7]
  assign O_0_0_2_0 = op_O_0_0_2_0; // @[MapT.scala 15:7]
  assign O_0_0_2_1 = op_O_0_0_2_1; // @[MapT.scala 15:7]
  assign O_0_0_2_2 = op_O_0_0_2_2; // @[MapT.scala 15:7]
  assign O_1_0_0_0 = op_O_1_0_0_0; // @[MapT.scala 15:7]
  assign O_1_0_0_1 = op_O_1_0_0_1; // @[MapT.scala 15:7]
  assign O_1_0_0_2 = op_O_1_0_0_2; // @[MapT.scala 15:7]
  assign O_1_0_1_0 = op_O_1_0_1_0; // @[MapT.scala 15:7]
  assign O_1_0_1_1 = op_O_1_0_1_1; // @[MapT.scala 15:7]
  assign O_1_0_1_2 = op_O_1_0_1_2; // @[MapT.scala 15:7]
  assign O_1_0_2_0 = op_O_1_0_2_0; // @[MapT.scala 15:7]
  assign O_1_0_2_1 = op_O_1_0_2_1; // @[MapT.scala 15:7]
  assign O_1_0_2_2 = op_O_1_0_2_2; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0_0 = I_0_0_0; // @[MapT.scala 14:10]
  assign op_I_0_0_1 = I_0_0_1; // @[MapT.scala 14:10]
  assign op_I_0_0_2 = I_0_0_2; // @[MapT.scala 14:10]
  assign op_I_0_1_0 = I_0_1_0; // @[MapT.scala 14:10]
  assign op_I_0_1_1 = I_0_1_1; // @[MapT.scala 14:10]
  assign op_I_0_1_2 = I_0_1_2; // @[MapT.scala 14:10]
  assign op_I_0_2_0 = I_0_2_0; // @[MapT.scala 14:10]
  assign op_I_0_2_1 = I_0_2_1; // @[MapT.scala 14:10]
  assign op_I_0_2_2 = I_0_2_2; // @[MapT.scala 14:10]
  assign op_I_1_0_0 = I_1_0_0; // @[MapT.scala 14:10]
  assign op_I_1_0_1 = I_1_0_1; // @[MapT.scala 14:10]
  assign op_I_1_0_2 = I_1_0_2; // @[MapT.scala 14:10]
  assign op_I_1_1_0 = I_1_1_0; // @[MapT.scala 14:10]
  assign op_I_1_1_1 = I_1_1_1; // @[MapT.scala 14:10]
  assign op_I_1_1_2 = I_1_1_2; // @[MapT.scala 14:10]
  assign op_I_1_2_0 = I_1_2_0; // @[MapT.scala 14:10]
  assign op_I_1_2_1 = I_1_2_1; // @[MapT.scala 14:10]
  assign op_I_1_2_2 = I_1_2_2; // @[MapT.scala 14:10]
endmodule
module SSeqTupleToSSeq_3(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_0_2,
  input  [7:0] I_1_0,
  input  [7:0] I_1_1,
  input  [7:0] I_1_2,
  input  [7:0] I_2_0,
  input  [7:0] I_2_1,
  input  [7:0] I_2_2,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2,
  output [7:0] O_1_0,
  output [7:0] O_1_1,
  output [7:0] O_1_2,
  output [7:0] O_2_0,
  output [7:0] O_2_1,
  output [7:0] O_2_2
);
  assign valid_down = valid_up; // @[Tuple.scala 42:14]
  assign O_0_0 = I_0_0; // @[Tuple.scala 41:5]
  assign O_0_1 = I_0_1; // @[Tuple.scala 41:5]
  assign O_0_2 = I_0_2; // @[Tuple.scala 41:5]
  assign O_1_0 = I_1_0; // @[Tuple.scala 41:5]
  assign O_1_1 = I_1_1; // @[Tuple.scala 41:5]
  assign O_1_2 = I_1_2; // @[Tuple.scala 41:5]
  assign O_2_0 = I_2_0; // @[Tuple.scala 41:5]
  assign O_2_1 = I_2_1; // @[Tuple.scala 41:5]
  assign O_2_2 = I_2_2; // @[Tuple.scala 41:5]
endmodule
module Remove1S_3(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  input  [7:0] I_0_0_2,
  input  [7:0] I_0_1_0,
  input  [7:0] I_0_1_1,
  input  [7:0] I_0_1_2,
  input  [7:0] I_0_2_0,
  input  [7:0] I_0_2_1,
  input  [7:0] I_0_2_2,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2,
  output [7:0] O_1_0,
  output [7:0] O_1_1,
  output [7:0] O_1_2,
  output [7:0] O_2_0,
  output [7:0] O_2_1,
  output [7:0] O_2_2
);
  wire  op_inst_valid_up; // @[Remove1S.scala 9:23]
  wire  op_inst_valid_down; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_0_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_0_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_0_2; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_1_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_1_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_1_2; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_2_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_2_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_2_2; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_0_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_0_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_0_2; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_1_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_1_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_1_2; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_2_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_2_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_2_2; // @[Remove1S.scala 9:23]
  SSeqTupleToSSeq_3 op_inst ( // @[Remove1S.scala 9:23]
    .valid_up(op_inst_valid_up),
    .valid_down(op_inst_valid_down),
    .I_0_0(op_inst_I_0_0),
    .I_0_1(op_inst_I_0_1),
    .I_0_2(op_inst_I_0_2),
    .I_1_0(op_inst_I_1_0),
    .I_1_1(op_inst_I_1_1),
    .I_1_2(op_inst_I_1_2),
    .I_2_0(op_inst_I_2_0),
    .I_2_1(op_inst_I_2_1),
    .I_2_2(op_inst_I_2_2),
    .O_0_0(op_inst_O_0_0),
    .O_0_1(op_inst_O_0_1),
    .O_0_2(op_inst_O_0_2),
    .O_1_0(op_inst_O_1_0),
    .O_1_1(op_inst_O_1_1),
    .O_1_2(op_inst_O_1_2),
    .O_2_0(op_inst_O_2_0),
    .O_2_1(op_inst_O_2_1),
    .O_2_2(op_inst_O_2_2)
  );
  assign valid_down = op_inst_valid_down; // @[Remove1S.scala 16:14]
  assign O_0_0 = op_inst_O_0_0; // @[Remove1S.scala 14:5]
  assign O_0_1 = op_inst_O_0_1; // @[Remove1S.scala 14:5]
  assign O_0_2 = op_inst_O_0_2; // @[Remove1S.scala 14:5]
  assign O_1_0 = op_inst_O_1_0; // @[Remove1S.scala 14:5]
  assign O_1_1 = op_inst_O_1_1; // @[Remove1S.scala 14:5]
  assign O_1_2 = op_inst_O_1_2; // @[Remove1S.scala 14:5]
  assign O_2_0 = op_inst_O_2_0; // @[Remove1S.scala 14:5]
  assign O_2_1 = op_inst_O_2_1; // @[Remove1S.scala 14:5]
  assign O_2_2 = op_inst_O_2_2; // @[Remove1S.scala 14:5]
  assign op_inst_valid_up = valid_up; // @[Remove1S.scala 15:20]
  assign op_inst_I_0_0 = I_0_0_0; // @[Remove1S.scala 13:13]
  assign op_inst_I_0_1 = I_0_0_1; // @[Remove1S.scala 13:13]
  assign op_inst_I_0_2 = I_0_0_2; // @[Remove1S.scala 13:13]
  assign op_inst_I_1_0 = I_0_1_0; // @[Remove1S.scala 13:13]
  assign op_inst_I_1_1 = I_0_1_1; // @[Remove1S.scala 13:13]
  assign op_inst_I_1_2 = I_0_1_2; // @[Remove1S.scala 13:13]
  assign op_inst_I_2_0 = I_0_2_0; // @[Remove1S.scala 13:13]
  assign op_inst_I_2_1 = I_0_2_1; // @[Remove1S.scala 13:13]
  assign op_inst_I_2_2 = I_0_2_2; // @[Remove1S.scala 13:13]
endmodule
module MapS_3(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0_0,
  input  [7:0] I_0_0_0_1,
  input  [7:0] I_0_0_0_2,
  input  [7:0] I_0_0_1_0,
  input  [7:0] I_0_0_1_1,
  input  [7:0] I_0_0_1_2,
  input  [7:0] I_0_0_2_0,
  input  [7:0] I_0_0_2_1,
  input  [7:0] I_0_0_2_2,
  input  [7:0] I_1_0_0_0,
  input  [7:0] I_1_0_0_1,
  input  [7:0] I_1_0_0_2,
  input  [7:0] I_1_0_1_0,
  input  [7:0] I_1_0_1_1,
  input  [7:0] I_1_0_1_2,
  input  [7:0] I_1_0_2_0,
  input  [7:0] I_1_0_2_1,
  input  [7:0] I_1_0_2_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1,
  output [7:0] O_0_1_2,
  output [7:0] O_0_2_0,
  output [7:0] O_0_2_1,
  output [7:0] O_0_2_2,
  output [7:0] O_1_0_0,
  output [7:0] O_1_0_1,
  output [7:0] O_1_0_2,
  output [7:0] O_1_1_0,
  output [7:0] O_1_1_1,
  output [7:0] O_1_1_2,
  output [7:0] O_1_2_0,
  output [7:0] O_1_2_1,
  output [7:0] O_1_2_2
);
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_0_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_0_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_0_2; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_1_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_1_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_1_2; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_2_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_2_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_2_2; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0_2; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_1_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_1_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_1_2; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_2_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_2_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_2_2; // @[MapS.scala 9:22]
  wire  other_ops_0_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_0_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_0_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_0_2; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_1_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_1_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_1_2; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_2_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_2_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_2_2; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_0_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_0_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_0_2; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_1_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_1_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_1_2; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_2_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_2_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_2_2; // @[MapS.scala 10:86]
  Remove1S_3 fst_op ( // @[MapS.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_0_0_0(fst_op_I_0_0_0),
    .I_0_0_1(fst_op_I_0_0_1),
    .I_0_0_2(fst_op_I_0_0_2),
    .I_0_1_0(fst_op_I_0_1_0),
    .I_0_1_1(fst_op_I_0_1_1),
    .I_0_1_2(fst_op_I_0_1_2),
    .I_0_2_0(fst_op_I_0_2_0),
    .I_0_2_1(fst_op_I_0_2_1),
    .I_0_2_2(fst_op_I_0_2_2),
    .O_0_0(fst_op_O_0_0),
    .O_0_1(fst_op_O_0_1),
    .O_0_2(fst_op_O_0_2),
    .O_1_0(fst_op_O_1_0),
    .O_1_1(fst_op_O_1_1),
    .O_1_2(fst_op_O_1_2),
    .O_2_0(fst_op_O_2_0),
    .O_2_1(fst_op_O_2_1),
    .O_2_2(fst_op_O_2_2)
  );
  Remove1S_3 other_ops_0 ( // @[MapS.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I_0_0_0(other_ops_0_I_0_0_0),
    .I_0_0_1(other_ops_0_I_0_0_1),
    .I_0_0_2(other_ops_0_I_0_0_2),
    .I_0_1_0(other_ops_0_I_0_1_0),
    .I_0_1_1(other_ops_0_I_0_1_1),
    .I_0_1_2(other_ops_0_I_0_1_2),
    .I_0_2_0(other_ops_0_I_0_2_0),
    .I_0_2_1(other_ops_0_I_0_2_1),
    .I_0_2_2(other_ops_0_I_0_2_2),
    .O_0_0(other_ops_0_O_0_0),
    .O_0_1(other_ops_0_O_0_1),
    .O_0_2(other_ops_0_O_0_2),
    .O_1_0(other_ops_0_O_1_0),
    .O_1_1(other_ops_0_O_1_1),
    .O_1_2(other_ops_0_O_1_2),
    .O_2_0(other_ops_0_O_2_0),
    .O_2_1(other_ops_0_O_2_1),
    .O_2_2(other_ops_0_O_2_2)
  );
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[MapS.scala 23:14]
  assign O_0_0_0 = fst_op_O_0_0; // @[MapS.scala 17:8]
  assign O_0_0_1 = fst_op_O_0_1; // @[MapS.scala 17:8]
  assign O_0_0_2 = fst_op_O_0_2; // @[MapS.scala 17:8]
  assign O_0_1_0 = fst_op_O_1_0; // @[MapS.scala 17:8]
  assign O_0_1_1 = fst_op_O_1_1; // @[MapS.scala 17:8]
  assign O_0_1_2 = fst_op_O_1_2; // @[MapS.scala 17:8]
  assign O_0_2_0 = fst_op_O_2_0; // @[MapS.scala 17:8]
  assign O_0_2_1 = fst_op_O_2_1; // @[MapS.scala 17:8]
  assign O_0_2_2 = fst_op_O_2_2; // @[MapS.scala 17:8]
  assign O_1_0_0 = other_ops_0_O_0_0; // @[MapS.scala 21:12]
  assign O_1_0_1 = other_ops_0_O_0_1; // @[MapS.scala 21:12]
  assign O_1_0_2 = other_ops_0_O_0_2; // @[MapS.scala 21:12]
  assign O_1_1_0 = other_ops_0_O_1_0; // @[MapS.scala 21:12]
  assign O_1_1_1 = other_ops_0_O_1_1; // @[MapS.scala 21:12]
  assign O_1_1_2 = other_ops_0_O_1_2; // @[MapS.scala 21:12]
  assign O_1_2_0 = other_ops_0_O_2_0; // @[MapS.scala 21:12]
  assign O_1_2_1 = other_ops_0_O_2_1; // @[MapS.scala 21:12]
  assign O_1_2_2 = other_ops_0_O_2_2; // @[MapS.scala 21:12]
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_0_0_0 = I_0_0_0_0; // @[MapS.scala 16:12]
  assign fst_op_I_0_0_1 = I_0_0_0_1; // @[MapS.scala 16:12]
  assign fst_op_I_0_0_2 = I_0_0_0_2; // @[MapS.scala 16:12]
  assign fst_op_I_0_1_0 = I_0_0_1_0; // @[MapS.scala 16:12]
  assign fst_op_I_0_1_1 = I_0_0_1_1; // @[MapS.scala 16:12]
  assign fst_op_I_0_1_2 = I_0_0_1_2; // @[MapS.scala 16:12]
  assign fst_op_I_0_2_0 = I_0_0_2_0; // @[MapS.scala 16:12]
  assign fst_op_I_0_2_1 = I_0_0_2_1; // @[MapS.scala 16:12]
  assign fst_op_I_0_2_2 = I_0_0_2_2; // @[MapS.scala 16:12]
  assign other_ops_0_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_0_I_0_0_0 = I_1_0_0_0; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_0_1 = I_1_0_0_1; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_0_2 = I_1_0_0_2; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_1_0 = I_1_0_1_0; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_1_1 = I_1_0_1_1; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_1_2 = I_1_0_1_2; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_2_0 = I_1_0_2_0; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_2_1 = I_1_0_2_1; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_2_2 = I_1_0_2_2; // @[MapS.scala 20:41]
endmodule
module MapT_7(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0_0,
  input  [7:0] I_0_0_0_1,
  input  [7:0] I_0_0_0_2,
  input  [7:0] I_0_0_1_0,
  input  [7:0] I_0_0_1_1,
  input  [7:0] I_0_0_1_2,
  input  [7:0] I_0_0_2_0,
  input  [7:0] I_0_0_2_1,
  input  [7:0] I_0_0_2_2,
  input  [7:0] I_1_0_0_0,
  input  [7:0] I_1_0_0_1,
  input  [7:0] I_1_0_0_2,
  input  [7:0] I_1_0_1_0,
  input  [7:0] I_1_0_1_1,
  input  [7:0] I_1_0_1_2,
  input  [7:0] I_1_0_2_0,
  input  [7:0] I_1_0_2_1,
  input  [7:0] I_1_0_2_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1,
  output [7:0] O_0_1_2,
  output [7:0] O_0_2_0,
  output [7:0] O_0_2_1,
  output [7:0] O_0_2_2,
  output [7:0] O_1_0_0,
  output [7:0] O_1_0_1,
  output [7:0] O_1_0_2,
  output [7:0] O_1_1_0,
  output [7:0] O_1_1_1,
  output [7:0] O_1_1_2,
  output [7:0] O_1_2_0,
  output [7:0] O_1_2_1,
  output [7:0] O_1_2_2
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_2_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_2_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_2_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_2_2; // @[MapT.scala 8:20]
  MapS_3 op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0_0_0(op_I_0_0_0_0),
    .I_0_0_0_1(op_I_0_0_0_1),
    .I_0_0_0_2(op_I_0_0_0_2),
    .I_0_0_1_0(op_I_0_0_1_0),
    .I_0_0_1_1(op_I_0_0_1_1),
    .I_0_0_1_2(op_I_0_0_1_2),
    .I_0_0_2_0(op_I_0_0_2_0),
    .I_0_0_2_1(op_I_0_0_2_1),
    .I_0_0_2_2(op_I_0_0_2_2),
    .I_1_0_0_0(op_I_1_0_0_0),
    .I_1_0_0_1(op_I_1_0_0_1),
    .I_1_0_0_2(op_I_1_0_0_2),
    .I_1_0_1_0(op_I_1_0_1_0),
    .I_1_0_1_1(op_I_1_0_1_1),
    .I_1_0_1_2(op_I_1_0_1_2),
    .I_1_0_2_0(op_I_1_0_2_0),
    .I_1_0_2_1(op_I_1_0_2_1),
    .I_1_0_2_2(op_I_1_0_2_2),
    .O_0_0_0(op_O_0_0_0),
    .O_0_0_1(op_O_0_0_1),
    .O_0_0_2(op_O_0_0_2),
    .O_0_1_0(op_O_0_1_0),
    .O_0_1_1(op_O_0_1_1),
    .O_0_1_2(op_O_0_1_2),
    .O_0_2_0(op_O_0_2_0),
    .O_0_2_1(op_O_0_2_1),
    .O_0_2_2(op_O_0_2_2),
    .O_1_0_0(op_O_1_0_0),
    .O_1_0_1(op_O_1_0_1),
    .O_1_0_2(op_O_1_0_2),
    .O_1_1_0(op_O_1_1_0),
    .O_1_1_1(op_O_1_1_1),
    .O_1_1_2(op_O_1_1_2),
    .O_1_2_0(op_O_1_2_0),
    .O_1_2_1(op_O_1_2_1),
    .O_1_2_2(op_O_1_2_2)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0_0 = op_O_0_0_0; // @[MapT.scala 15:7]
  assign O_0_0_1 = op_O_0_0_1; // @[MapT.scala 15:7]
  assign O_0_0_2 = op_O_0_0_2; // @[MapT.scala 15:7]
  assign O_0_1_0 = op_O_0_1_0; // @[MapT.scala 15:7]
  assign O_0_1_1 = op_O_0_1_1; // @[MapT.scala 15:7]
  assign O_0_1_2 = op_O_0_1_2; // @[MapT.scala 15:7]
  assign O_0_2_0 = op_O_0_2_0; // @[MapT.scala 15:7]
  assign O_0_2_1 = op_O_0_2_1; // @[MapT.scala 15:7]
  assign O_0_2_2 = op_O_0_2_2; // @[MapT.scala 15:7]
  assign O_1_0_0 = op_O_1_0_0; // @[MapT.scala 15:7]
  assign O_1_0_1 = op_O_1_0_1; // @[MapT.scala 15:7]
  assign O_1_0_2 = op_O_1_0_2; // @[MapT.scala 15:7]
  assign O_1_1_0 = op_O_1_1_0; // @[MapT.scala 15:7]
  assign O_1_1_1 = op_O_1_1_1; // @[MapT.scala 15:7]
  assign O_1_1_2 = op_O_1_1_2; // @[MapT.scala 15:7]
  assign O_1_2_0 = op_O_1_2_0; // @[MapT.scala 15:7]
  assign O_1_2_1 = op_O_1_2_1; // @[MapT.scala 15:7]
  assign O_1_2_2 = op_O_1_2_2; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0_0_0 = I_0_0_0_0; // @[MapT.scala 14:10]
  assign op_I_0_0_0_1 = I_0_0_0_1; // @[MapT.scala 14:10]
  assign op_I_0_0_0_2 = I_0_0_0_2; // @[MapT.scala 14:10]
  assign op_I_0_0_1_0 = I_0_0_1_0; // @[MapT.scala 14:10]
  assign op_I_0_0_1_1 = I_0_0_1_1; // @[MapT.scala 14:10]
  assign op_I_0_0_1_2 = I_0_0_1_2; // @[MapT.scala 14:10]
  assign op_I_0_0_2_0 = I_0_0_2_0; // @[MapT.scala 14:10]
  assign op_I_0_0_2_1 = I_0_0_2_1; // @[MapT.scala 14:10]
  assign op_I_0_0_2_2 = I_0_0_2_2; // @[MapT.scala 14:10]
  assign op_I_1_0_0_0 = I_1_0_0_0; // @[MapT.scala 14:10]
  assign op_I_1_0_0_1 = I_1_0_0_1; // @[MapT.scala 14:10]
  assign op_I_1_0_0_2 = I_1_0_0_2; // @[MapT.scala 14:10]
  assign op_I_1_0_1_0 = I_1_0_1_0; // @[MapT.scala 14:10]
  assign op_I_1_0_1_1 = I_1_0_1_1; // @[MapT.scala 14:10]
  assign op_I_1_0_1_2 = I_1_0_1_2; // @[MapT.scala 14:10]
  assign op_I_1_0_2_0 = I_1_0_2_0; // @[MapT.scala 14:10]
  assign op_I_1_0_2_1 = I_1_0_2_1; // @[MapT.scala 14:10]
  assign op_I_1_0_2_2 = I_1_0_2_2; // @[MapT.scala 14:10]
endmodule
module InitialDelayCounter(
  input   clock,
  input   reset,
  output  valid_down
);
  reg  value; // @[InitialDelayCounter.scala 8:34]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[InitialDelayCounter.scala 17:17]
  wire  _T_4; // @[InitialDelayCounter.scala 17:53]
  assign _T_1 = value < 1'h1; // @[InitialDelayCounter.scala 17:17]
  assign _T_4 = value + 1'h1; // @[InitialDelayCounter.scala 17:53]
  assign valid_down = value; // @[InitialDelayCounter.scala 16:16]
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
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  value = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      value <= 1'h0;
    end else if (_T_1) begin
      value <= _T_4;
    end
  end
endmodule
module AtomTuple(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0,
  input  [7:0] I1,
  output [7:0] O_t0b,
  output [7:0] O_t1b
);
  assign valid_down = valid_up; // @[Tuple.scala 51:14]
  assign O_t0b = I0; // @[Tuple.scala 49:9]
  assign O_t1b = I1; // @[Tuple.scala 50:9]
endmodule
module Map2S_8(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I0_1,
  input  [7:0] I0_2,
  input  [7:0] I1_0,
  input  [7:0] I1_1,
  input  [7:0] I1_2,
  output [7:0] O_0_t0b,
  output [7:0] O_0_t1b,
  output [7:0] O_1_t0b,
  output [7:0] O_1_t1b,
  output [7:0] O_2_t0b,
  output [7:0] O_2_t1b
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_t0b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_t1b; // @[Map2S.scala 9:22]
  wire  other_ops_0_valid_up; // @[Map2S.scala 10:86]
  wire  other_ops_0_valid_down; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_t0b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_t1b; // @[Map2S.scala 10:86]
  wire  other_ops_1_valid_up; // @[Map2S.scala 10:86]
  wire  other_ops_1_valid_down; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_I0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_I1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_O_t0b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_O_t1b; // @[Map2S.scala 10:86]
  wire  _T; // @[Map2S.scala 26:83]
  AtomTuple fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0(fst_op_I0),
    .I1(fst_op_I1),
    .O_t0b(fst_op_O_t0b),
    .O_t1b(fst_op_O_t1b)
  );
  AtomTuple other_ops_0 ( // @[Map2S.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I0(other_ops_0_I0),
    .I1(other_ops_0_I1),
    .O_t0b(other_ops_0_O_t0b),
    .O_t1b(other_ops_0_O_t1b)
  );
  AtomTuple other_ops_1 ( // @[Map2S.scala 10:86]
    .valid_up(other_ops_1_valid_up),
    .valid_down(other_ops_1_valid_down),
    .I0(other_ops_1_I0),
    .I1(other_ops_1_I1),
    .O_t0b(other_ops_1_O_t0b),
    .O_t1b(other_ops_1_O_t1b)
  );
  assign _T = fst_op_valid_down & other_ops_0_valid_down; // @[Map2S.scala 26:83]
  assign valid_down = _T & other_ops_1_valid_down; // @[Map2S.scala 26:14]
  assign O_0_t0b = fst_op_O_t0b; // @[Map2S.scala 19:8]
  assign O_0_t1b = fst_op_O_t1b; // @[Map2S.scala 19:8]
  assign O_1_t0b = other_ops_0_O_t0b; // @[Map2S.scala 24:12]
  assign O_1_t1b = other_ops_0_O_t1b; // @[Map2S.scala 24:12]
  assign O_2_t0b = other_ops_1_O_t0b; // @[Map2S.scala 24:12]
  assign O_2_t1b = other_ops_1_O_t1b; // @[Map2S.scala 24:12]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0 = I0_0; // @[Map2S.scala 17:13]
  assign fst_op_I1 = I1_0; // @[Map2S.scala 18:13]
  assign other_ops_0_valid_up = valid_up; // @[Map2S.scala 21:39]
  assign other_ops_0_I0 = I0_1; // @[Map2S.scala 22:43]
  assign other_ops_0_I1 = I1_1; // @[Map2S.scala 23:43]
  assign other_ops_1_valid_up = valid_up; // @[Map2S.scala 21:39]
  assign other_ops_1_I0 = I0_2; // @[Map2S.scala 22:43]
  assign other_ops_1_I1 = I1_2; // @[Map2S.scala 23:43]
endmodule
module Map2S_9(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I0_0_2,
  input  [7:0] I0_1_0,
  input  [7:0] I0_1_1,
  input  [7:0] I0_1_2,
  input  [7:0] I0_2_0,
  input  [7:0] I0_2_1,
  input  [7:0] I0_2_2,
  output [7:0] O_0_0_t0b,
  output [7:0] O_0_0_t1b,
  output [7:0] O_0_1_t0b,
  output [7:0] O_0_1_t1b,
  output [7:0] O_0_2_t0b,
  output [7:0] O_0_2_t1b,
  output [7:0] O_1_0_t0b,
  output [7:0] O_1_0_t1b,
  output [7:0] O_1_1_t0b,
  output [7:0] O_1_1_t1b,
  output [7:0] O_1_2_t0b,
  output [7:0] O_1_2_t1b,
  output [7:0] O_2_0_t0b,
  output [7:0] O_2_0_t1b,
  output [7:0] O_2_1_t0b,
  output [7:0] O_2_1_t1b,
  output [7:0] O_2_2_t0b,
  output [7:0] O_2_2_t1b
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_2; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_2; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_t0b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_t1b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_t0b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_t1b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_2_t0b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_2_t1b; // @[Map2S.scala 9:22]
  wire  other_ops_0_valid_up; // @[Map2S.scala 10:86]
  wire  other_ops_0_valid_down; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0_t0b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0_t1b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1_t0b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1_t1b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_2_t0b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_2_t1b; // @[Map2S.scala 10:86]
  wire  other_ops_1_valid_up; // @[Map2S.scala 10:86]
  wire  other_ops_1_valid_down; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_I0_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_I0_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_I0_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_I1_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_I1_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_I1_2; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_O_0_t0b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_O_0_t1b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_O_1_t0b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_O_1_t1b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_O_2_t0b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_1_O_2_t1b; // @[Map2S.scala 10:86]
  wire  _T; // @[Map2S.scala 26:83]
  Map2S_8 fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0_0(fst_op_I0_0),
    .I0_1(fst_op_I0_1),
    .I0_2(fst_op_I0_2),
    .I1_0(fst_op_I1_0),
    .I1_1(fst_op_I1_1),
    .I1_2(fst_op_I1_2),
    .O_0_t0b(fst_op_O_0_t0b),
    .O_0_t1b(fst_op_O_0_t1b),
    .O_1_t0b(fst_op_O_1_t0b),
    .O_1_t1b(fst_op_O_1_t1b),
    .O_2_t0b(fst_op_O_2_t0b),
    .O_2_t1b(fst_op_O_2_t1b)
  );
  Map2S_8 other_ops_0 ( // @[Map2S.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I0_0(other_ops_0_I0_0),
    .I0_1(other_ops_0_I0_1),
    .I0_2(other_ops_0_I0_2),
    .I1_0(other_ops_0_I1_0),
    .I1_1(other_ops_0_I1_1),
    .I1_2(other_ops_0_I1_2),
    .O_0_t0b(other_ops_0_O_0_t0b),
    .O_0_t1b(other_ops_0_O_0_t1b),
    .O_1_t0b(other_ops_0_O_1_t0b),
    .O_1_t1b(other_ops_0_O_1_t1b),
    .O_2_t0b(other_ops_0_O_2_t0b),
    .O_2_t1b(other_ops_0_O_2_t1b)
  );
  Map2S_8 other_ops_1 ( // @[Map2S.scala 10:86]
    .valid_up(other_ops_1_valid_up),
    .valid_down(other_ops_1_valid_down),
    .I0_0(other_ops_1_I0_0),
    .I0_1(other_ops_1_I0_1),
    .I0_2(other_ops_1_I0_2),
    .I1_0(other_ops_1_I1_0),
    .I1_1(other_ops_1_I1_1),
    .I1_2(other_ops_1_I1_2),
    .O_0_t0b(other_ops_1_O_0_t0b),
    .O_0_t1b(other_ops_1_O_0_t1b),
    .O_1_t0b(other_ops_1_O_1_t0b),
    .O_1_t1b(other_ops_1_O_1_t1b),
    .O_2_t0b(other_ops_1_O_2_t0b),
    .O_2_t1b(other_ops_1_O_2_t1b)
  );
  assign _T = fst_op_valid_down & other_ops_0_valid_down; // @[Map2S.scala 26:83]
  assign valid_down = _T & other_ops_1_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0_t0b = fst_op_O_0_t0b; // @[Map2S.scala 19:8]
  assign O_0_0_t1b = fst_op_O_0_t1b; // @[Map2S.scala 19:8]
  assign O_0_1_t0b = fst_op_O_1_t0b; // @[Map2S.scala 19:8]
  assign O_0_1_t1b = fst_op_O_1_t1b; // @[Map2S.scala 19:8]
  assign O_0_2_t0b = fst_op_O_2_t0b; // @[Map2S.scala 19:8]
  assign O_0_2_t1b = fst_op_O_2_t1b; // @[Map2S.scala 19:8]
  assign O_1_0_t0b = other_ops_0_O_0_t0b; // @[Map2S.scala 24:12]
  assign O_1_0_t1b = other_ops_0_O_0_t1b; // @[Map2S.scala 24:12]
  assign O_1_1_t0b = other_ops_0_O_1_t0b; // @[Map2S.scala 24:12]
  assign O_1_1_t1b = other_ops_0_O_1_t1b; // @[Map2S.scala 24:12]
  assign O_1_2_t0b = other_ops_0_O_2_t0b; // @[Map2S.scala 24:12]
  assign O_1_2_t1b = other_ops_0_O_2_t1b; // @[Map2S.scala 24:12]
  assign O_2_0_t0b = other_ops_1_O_0_t0b; // @[Map2S.scala 24:12]
  assign O_2_0_t1b = other_ops_1_O_0_t1b; // @[Map2S.scala 24:12]
  assign O_2_1_t0b = other_ops_1_O_1_t0b; // @[Map2S.scala 24:12]
  assign O_2_1_t1b = other_ops_1_O_1_t1b; // @[Map2S.scala 24:12]
  assign O_2_2_t0b = other_ops_1_O_2_t0b; // @[Map2S.scala 24:12]
  assign O_2_2_t1b = other_ops_1_O_2_t1b; // @[Map2S.scala 24:12]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0_0 = I0_0_0; // @[Map2S.scala 17:13]
  assign fst_op_I0_1 = I0_0_1; // @[Map2S.scala 17:13]
  assign fst_op_I0_2 = I0_0_2; // @[Map2S.scala 17:13]
  assign fst_op_I1_0 = 8'h0; // @[Map2S.scala 18:13]
  assign fst_op_I1_1 = 8'h1; // @[Map2S.scala 18:13]
  assign fst_op_I1_2 = 8'h0; // @[Map2S.scala 18:13]
  assign other_ops_0_valid_up = valid_up; // @[Map2S.scala 21:39]
  assign other_ops_0_I0_0 = I0_1_0; // @[Map2S.scala 22:43]
  assign other_ops_0_I0_1 = I0_1_1; // @[Map2S.scala 22:43]
  assign other_ops_0_I0_2 = I0_1_2; // @[Map2S.scala 22:43]
  assign other_ops_0_I1_0 = 8'h1; // @[Map2S.scala 23:43]
  assign other_ops_0_I1_1 = 8'h2; // @[Map2S.scala 23:43]
  assign other_ops_0_I1_2 = 8'h1; // @[Map2S.scala 23:43]
  assign other_ops_1_valid_up = valid_up; // @[Map2S.scala 21:39]
  assign other_ops_1_I0_0 = I0_2_0; // @[Map2S.scala 22:43]
  assign other_ops_1_I0_1 = I0_2_1; // @[Map2S.scala 22:43]
  assign other_ops_1_I0_2 = I0_2_2; // @[Map2S.scala 22:43]
  assign other_ops_1_I1_0 = 8'h0; // @[Map2S.scala 23:43]
  assign other_ops_1_I1_1 = 8'h1; // @[Map2S.scala 23:43]
  assign other_ops_1_I1_2 = 8'h0; // @[Map2S.scala 23:43]
endmodule
module LShift(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  wire [262:0] _GEN_0; // @[Arithmetic.scala 301:25]
  wire [262:0] _T; // @[Arithmetic.scala 301:25]
  assign _GEN_0 = {{255'd0}, I_t0b}; // @[Arithmetic.scala 301:25]
  assign _T = _GEN_0 << I_t1b; // @[Arithmetic.scala 301:25]
  assign valid_down = valid_up; // @[Arithmetic.scala 303:14]
  assign O = _T[7:0]; // @[Arithmetic.scala 301:7]
endmodule
module MapS_4(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_t0b,
  input  [7:0] I_0_t1b,
  input  [7:0] I_1_t0b,
  input  [7:0] I_1_t1b,
  input  [7:0] I_2_t0b,
  input  [7:0] I_2_t1b,
  output [7:0] O_0,
  output [7:0] O_1,
  output [7:0] O_2
);
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_t0b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_t1b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O; // @[MapS.scala 9:22]
  wire  other_ops_0_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_t0b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_t1b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O; // @[MapS.scala 10:86]
  wire  other_ops_1_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_1_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_I_t0b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_I_t1b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_O; // @[MapS.scala 10:86]
  wire  _T; // @[MapS.scala 23:83]
  LShift fst_op ( // @[MapS.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_t0b(fst_op_I_t0b),
    .I_t1b(fst_op_I_t1b),
    .O(fst_op_O)
  );
  LShift other_ops_0 ( // @[MapS.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I_t0b(other_ops_0_I_t0b),
    .I_t1b(other_ops_0_I_t1b),
    .O(other_ops_0_O)
  );
  LShift other_ops_1 ( // @[MapS.scala 10:86]
    .valid_up(other_ops_1_valid_up),
    .valid_down(other_ops_1_valid_down),
    .I_t0b(other_ops_1_I_t0b),
    .I_t1b(other_ops_1_I_t1b),
    .O(other_ops_1_O)
  );
  assign _T = fst_op_valid_down & other_ops_0_valid_down; // @[MapS.scala 23:83]
  assign valid_down = _T & other_ops_1_valid_down; // @[MapS.scala 23:14]
  assign O_0 = fst_op_O; // @[MapS.scala 17:8]
  assign O_1 = other_ops_0_O; // @[MapS.scala 21:12]
  assign O_2 = other_ops_1_O; // @[MapS.scala 21:12]
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_t0b = I_0_t0b; // @[MapS.scala 16:12]
  assign fst_op_I_t1b = I_0_t1b; // @[MapS.scala 16:12]
  assign other_ops_0_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_0_I_t0b = I_1_t0b; // @[MapS.scala 20:41]
  assign other_ops_0_I_t1b = I_1_t1b; // @[MapS.scala 20:41]
  assign other_ops_1_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_1_I_t0b = I_2_t0b; // @[MapS.scala 20:41]
  assign other_ops_1_I_t1b = I_2_t1b; // @[MapS.scala 20:41]
endmodule
module MapS_5(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_t0b,
  input  [7:0] I_0_0_t1b,
  input  [7:0] I_0_1_t0b,
  input  [7:0] I_0_1_t1b,
  input  [7:0] I_0_2_t0b,
  input  [7:0] I_0_2_t1b,
  input  [7:0] I_1_0_t0b,
  input  [7:0] I_1_0_t1b,
  input  [7:0] I_1_1_t0b,
  input  [7:0] I_1_1_t1b,
  input  [7:0] I_1_2_t0b,
  input  [7:0] I_1_2_t1b,
  input  [7:0] I_2_0_t0b,
  input  [7:0] I_2_0_t1b,
  input  [7:0] I_2_1_t0b,
  input  [7:0] I_2_1_t1b,
  input  [7:0] I_2_2_t0b,
  input  [7:0] I_2_2_t1b,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2,
  output [7:0] O_1_0,
  output [7:0] O_1_1,
  output [7:0] O_1_2,
  output [7:0] O_2_0,
  output [7:0] O_2_1,
  output [7:0] O_2_2
);
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_t0b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_t1b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_1_t0b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_1_t1b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_2_t0b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_2_t1b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_2; // @[MapS.scala 9:22]
  wire  other_ops_0_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_t0b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_t1b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_1_t0b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_1_t1b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_2_t0b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_2_t1b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_2; // @[MapS.scala 10:86]
  wire  other_ops_1_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_1_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_I_0_t0b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_I_0_t1b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_I_1_t0b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_I_1_t1b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_I_2_t0b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_I_2_t1b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_O_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_O_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_O_2; // @[MapS.scala 10:86]
  wire  _T; // @[MapS.scala 23:83]
  MapS_4 fst_op ( // @[MapS.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_0_t0b(fst_op_I_0_t0b),
    .I_0_t1b(fst_op_I_0_t1b),
    .I_1_t0b(fst_op_I_1_t0b),
    .I_1_t1b(fst_op_I_1_t1b),
    .I_2_t0b(fst_op_I_2_t0b),
    .I_2_t1b(fst_op_I_2_t1b),
    .O_0(fst_op_O_0),
    .O_1(fst_op_O_1),
    .O_2(fst_op_O_2)
  );
  MapS_4 other_ops_0 ( // @[MapS.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I_0_t0b(other_ops_0_I_0_t0b),
    .I_0_t1b(other_ops_0_I_0_t1b),
    .I_1_t0b(other_ops_0_I_1_t0b),
    .I_1_t1b(other_ops_0_I_1_t1b),
    .I_2_t0b(other_ops_0_I_2_t0b),
    .I_2_t1b(other_ops_0_I_2_t1b),
    .O_0(other_ops_0_O_0),
    .O_1(other_ops_0_O_1),
    .O_2(other_ops_0_O_2)
  );
  MapS_4 other_ops_1 ( // @[MapS.scala 10:86]
    .valid_up(other_ops_1_valid_up),
    .valid_down(other_ops_1_valid_down),
    .I_0_t0b(other_ops_1_I_0_t0b),
    .I_0_t1b(other_ops_1_I_0_t1b),
    .I_1_t0b(other_ops_1_I_1_t0b),
    .I_1_t1b(other_ops_1_I_1_t1b),
    .I_2_t0b(other_ops_1_I_2_t0b),
    .I_2_t1b(other_ops_1_I_2_t1b),
    .O_0(other_ops_1_O_0),
    .O_1(other_ops_1_O_1),
    .O_2(other_ops_1_O_2)
  );
  assign _T = fst_op_valid_down & other_ops_0_valid_down; // @[MapS.scala 23:83]
  assign valid_down = _T & other_ops_1_valid_down; // @[MapS.scala 23:14]
  assign O_0_0 = fst_op_O_0; // @[MapS.scala 17:8]
  assign O_0_1 = fst_op_O_1; // @[MapS.scala 17:8]
  assign O_0_2 = fst_op_O_2; // @[MapS.scala 17:8]
  assign O_1_0 = other_ops_0_O_0; // @[MapS.scala 21:12]
  assign O_1_1 = other_ops_0_O_1; // @[MapS.scala 21:12]
  assign O_1_2 = other_ops_0_O_2; // @[MapS.scala 21:12]
  assign O_2_0 = other_ops_1_O_0; // @[MapS.scala 21:12]
  assign O_2_1 = other_ops_1_O_1; // @[MapS.scala 21:12]
  assign O_2_2 = other_ops_1_O_2; // @[MapS.scala 21:12]
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_0_t0b = I_0_0_t0b; // @[MapS.scala 16:12]
  assign fst_op_I_0_t1b = I_0_0_t1b; // @[MapS.scala 16:12]
  assign fst_op_I_1_t0b = I_0_1_t0b; // @[MapS.scala 16:12]
  assign fst_op_I_1_t1b = I_0_1_t1b; // @[MapS.scala 16:12]
  assign fst_op_I_2_t0b = I_0_2_t0b; // @[MapS.scala 16:12]
  assign fst_op_I_2_t1b = I_0_2_t1b; // @[MapS.scala 16:12]
  assign other_ops_0_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_0_I_0_t0b = I_1_0_t0b; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_t1b = I_1_0_t1b; // @[MapS.scala 20:41]
  assign other_ops_0_I_1_t0b = I_1_1_t0b; // @[MapS.scala 20:41]
  assign other_ops_0_I_1_t1b = I_1_1_t1b; // @[MapS.scala 20:41]
  assign other_ops_0_I_2_t0b = I_1_2_t0b; // @[MapS.scala 20:41]
  assign other_ops_0_I_2_t1b = I_1_2_t1b; // @[MapS.scala 20:41]
  assign other_ops_1_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_1_I_0_t0b = I_2_0_t0b; // @[MapS.scala 20:41]
  assign other_ops_1_I_0_t1b = I_2_0_t1b; // @[MapS.scala 20:41]
  assign other_ops_1_I_1_t0b = I_2_1_t0b; // @[MapS.scala 20:41]
  assign other_ops_1_I_1_t1b = I_2_1_t1b; // @[MapS.scala 20:41]
  assign other_ops_1_I_2_t0b = I_2_2_t0b; // @[MapS.scala 20:41]
  assign other_ops_1_I_2_t1b = I_2_2_t1b; // @[MapS.scala 20:41]
endmodule
module AddNoValid(
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  assign O = I_t0b + I_t1b; // @[Arithmetic.scala 122:7]
endmodule
module ReduceS(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  input  [7:0] I_2,
  output [7:0] O_0
);
  wire [7:0] AddNoValid_I_t0b; // @[ReduceS.scala 20:43]
  wire [7:0] AddNoValid_I_t1b; // @[ReduceS.scala 20:43]
  wire [7:0] AddNoValid_O; // @[ReduceS.scala 20:43]
  wire [7:0] AddNoValid_1_I_t0b; // @[ReduceS.scala 20:43]
  wire [7:0] AddNoValid_1_I_t1b; // @[ReduceS.scala 20:43]
  wire [7:0] AddNoValid_1_O; // @[ReduceS.scala 20:43]
  reg [7:0] _T; // @[ReduceS.scala 27:24]
  reg [31:0] _RAND_0;
  reg  _T_1; // @[ReduceS.scala 47:24]
  reg [31:0] _RAND_1;
  AddNoValid AddNoValid ( // @[ReduceS.scala 20:43]
    .I_t0b(AddNoValid_I_t0b),
    .I_t1b(AddNoValid_I_t1b),
    .O(AddNoValid_O)
  );
  AddNoValid AddNoValid_1 ( // @[ReduceS.scala 20:43]
    .I_t0b(AddNoValid_1_I_t0b),
    .I_t1b(AddNoValid_1_I_t1b),
    .O(AddNoValid_1_O)
  );
  assign valid_down = _T_1; // @[ReduceS.scala 47:14]
  assign O_0 = _T; // @[ReduceS.scala 27:14]
  assign AddNoValid_I_t0b = I_1; // @[ReduceS.scala 43:18]
  assign AddNoValid_I_t1b = AddNoValid_1_O; // @[ReduceS.scala 36:18]
  assign AddNoValid_1_I_t0b = I_0; // @[ReduceS.scala 43:18]
  assign AddNoValid_1_I_t1b = I_2; // @[ReduceS.scala 43:18]
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
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T = _RAND_0[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_1 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    _T <= AddNoValid_O;
    if (reset) begin
      _T_1 <= 1'h0;
    end else begin
      _T_1 <= valid_up;
    end
  end
endmodule
module MapS_6(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_0_2,
  input  [7:0] I_1_0,
  input  [7:0] I_1_1,
  input  [7:0] I_1_2,
  input  [7:0] I_2_0,
  input  [7:0] I_2_1,
  input  [7:0] I_2_2,
  output [7:0] O_0_0,
  output [7:0] O_1_0,
  output [7:0] O_2_0
);
  wire  fst_op_clock; // @[MapS.scala 9:22]
  wire  fst_op_reset; // @[MapS.scala 9:22]
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_2; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0; // @[MapS.scala 9:22]
  wire  other_ops_0_clock; // @[MapS.scala 10:86]
  wire  other_ops_0_reset; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_2; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_0; // @[MapS.scala 10:86]
  wire  other_ops_1_clock; // @[MapS.scala 10:86]
  wire  other_ops_1_reset; // @[MapS.scala 10:86]
  wire  other_ops_1_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_1_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_I_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_I_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_I_2; // @[MapS.scala 10:86]
  wire [7:0] other_ops_1_O_0; // @[MapS.scala 10:86]
  wire  _T; // @[MapS.scala 23:83]
  ReduceS fst_op ( // @[MapS.scala 9:22]
    .clock(fst_op_clock),
    .reset(fst_op_reset),
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_0(fst_op_I_0),
    .I_1(fst_op_I_1),
    .I_2(fst_op_I_2),
    .O_0(fst_op_O_0)
  );
  ReduceS other_ops_0 ( // @[MapS.scala 10:86]
    .clock(other_ops_0_clock),
    .reset(other_ops_0_reset),
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I_0(other_ops_0_I_0),
    .I_1(other_ops_0_I_1),
    .I_2(other_ops_0_I_2),
    .O_0(other_ops_0_O_0)
  );
  ReduceS other_ops_1 ( // @[MapS.scala 10:86]
    .clock(other_ops_1_clock),
    .reset(other_ops_1_reset),
    .valid_up(other_ops_1_valid_up),
    .valid_down(other_ops_1_valid_down),
    .I_0(other_ops_1_I_0),
    .I_1(other_ops_1_I_1),
    .I_2(other_ops_1_I_2),
    .O_0(other_ops_1_O_0)
  );
  assign _T = fst_op_valid_down & other_ops_0_valid_down; // @[MapS.scala 23:83]
  assign valid_down = _T & other_ops_1_valid_down; // @[MapS.scala 23:14]
  assign O_0_0 = fst_op_O_0; // @[MapS.scala 17:8]
  assign O_1_0 = other_ops_0_O_0; // @[MapS.scala 21:12]
  assign O_2_0 = other_ops_1_O_0; // @[MapS.scala 21:12]
  assign fst_op_clock = clock;
  assign fst_op_reset = reset;
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_0 = I_0_0; // @[MapS.scala 16:12]
  assign fst_op_I_1 = I_0_1; // @[MapS.scala 16:12]
  assign fst_op_I_2 = I_0_2; // @[MapS.scala 16:12]
  assign other_ops_0_clock = clock; // @[MapS.scala 10:86]
  assign other_ops_0_reset = reset; // @[MapS.scala 10:86]
  assign other_ops_0_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_0_I_0 = I_1_0; // @[MapS.scala 20:41]
  assign other_ops_0_I_1 = I_1_1; // @[MapS.scala 20:41]
  assign other_ops_0_I_2 = I_1_2; // @[MapS.scala 20:41]
  assign other_ops_1_clock = clock; // @[MapS.scala 10:86]
  assign other_ops_1_reset = reset; // @[MapS.scala 10:86]
  assign other_ops_1_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_1_I_0 = I_2_0; // @[MapS.scala 20:41]
  assign other_ops_1_I_1 = I_2_1; // @[MapS.scala 20:41]
  assign other_ops_1_I_2 = I_2_2; // @[MapS.scala 20:41]
endmodule
module MapSNoValid(
  input  [7:0] I_0_t0b,
  input  [7:0] I_0_t1b,
  output [7:0] O_0
);
  wire [7:0] fst_op_I_t0b; // @[MapS.scala 28:22]
  wire [7:0] fst_op_I_t1b; // @[MapS.scala 28:22]
  wire [7:0] fst_op_O; // @[MapS.scala 28:22]
  AddNoValid fst_op ( // @[MapS.scala 28:22]
    .I_t0b(fst_op_I_t0b),
    .I_t1b(fst_op_I_t1b),
    .O(fst_op_O)
  );
  assign O_0 = fst_op_O; // @[MapS.scala 35:8]
  assign fst_op_I_t0b = I_0_t0b; // @[MapS.scala 34:12]
  assign fst_op_I_t1b = I_0_t1b; // @[MapS.scala 34:12]
endmodule
module ReduceS_1(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_1_0,
  input  [7:0] I_2_0,
  output [7:0] O_0_0
);
  wire [7:0] MapSNoValid_I_0_t0b; // @[ReduceS.scala 20:43]
  wire [7:0] MapSNoValid_I_0_t1b; // @[ReduceS.scala 20:43]
  wire [7:0] MapSNoValid_O_0; // @[ReduceS.scala 20:43]
  wire [7:0] MapSNoValid_1_I_0_t0b; // @[ReduceS.scala 20:43]
  wire [7:0] MapSNoValid_1_I_0_t1b; // @[ReduceS.scala 20:43]
  wire [7:0] MapSNoValid_1_O_0; // @[ReduceS.scala 20:43]
  reg [7:0] _T_0; // @[ReduceS.scala 27:24]
  reg [31:0] _RAND_0;
  reg  _T_1; // @[ReduceS.scala 47:24]
  reg [31:0] _RAND_1;
  MapSNoValid MapSNoValid ( // @[ReduceS.scala 20:43]
    .I_0_t0b(MapSNoValid_I_0_t0b),
    .I_0_t1b(MapSNoValid_I_0_t1b),
    .O_0(MapSNoValid_O_0)
  );
  MapSNoValid MapSNoValid_1 ( // @[ReduceS.scala 20:43]
    .I_0_t0b(MapSNoValid_1_I_0_t0b),
    .I_0_t1b(MapSNoValid_1_I_0_t1b),
    .O_0(MapSNoValid_1_O_0)
  );
  assign valid_down = _T_1; // @[ReduceS.scala 47:14]
  assign O_0_0 = _T_0; // @[ReduceS.scala 27:14]
  assign MapSNoValid_I_0_t0b = I_0_0; // @[ReduceS.scala 43:18]
  assign MapSNoValid_I_0_t1b = MapSNoValid_1_O_0; // @[ReduceS.scala 36:18]
  assign MapSNoValid_1_I_0_t0b = I_2_0; // @[ReduceS.scala 43:18]
  assign MapSNoValid_1_I_0_t1b = I_1_0; // @[ReduceS.scala 43:18]
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
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_0 = _RAND_0[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_1 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    _T_0 <= MapSNoValid_O_0;
    if (reset) begin
      _T_1 <= 1'h0;
    end else begin
      _T_1 <= valid_up;
    end
  end
endmodule
module InitialDelayCounter_1(
  input   clock,
  input   reset,
  output  valid_down
);
  reg [1:0] value; // @[InitialDelayCounter.scala 8:34]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[InitialDelayCounter.scala 17:17]
  wire [1:0] _T_4; // @[InitialDelayCounter.scala 17:53]
  assign _T_1 = value < 2'h3; // @[InitialDelayCounter.scala 17:17]
  assign _T_4 = value + 2'h1; // @[InitialDelayCounter.scala 17:53]
  assign valid_down = value == 2'h3; // @[InitialDelayCounter.scala 16:16]
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
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  value = _RAND_0[1:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      value <= 2'h0;
    end else if (_T_1) begin
      value <= _T_4;
    end
  end
endmodule
module Map2S_10(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  output [7:0] O_0_t0b,
  output [7:0] O_0_t1b
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_t0b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_t1b; // @[Map2S.scala 9:22]
  AtomTuple fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0(fst_op_I0),
    .I1(fst_op_I1),
    .O_t0b(fst_op_O_t0b),
    .O_t1b(fst_op_O_t1b)
  );
  assign valid_down = fst_op_valid_down; // @[Map2S.scala 26:14]
  assign O_0_t0b = fst_op_O_t0b; // @[Map2S.scala 19:8]
  assign O_0_t1b = fst_op_O_t1b; // @[Map2S.scala 19:8]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0 = I0_0; // @[Map2S.scala 17:13]
  assign fst_op_I1 = 8'h4; // @[Map2S.scala 18:13]
endmodule
module Map2S_11(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  output [7:0] O_0_0_t0b,
  output [7:0] O_0_0_t1b
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_t0b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_t1b; // @[Map2S.scala 9:22]
  Map2S_10 fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0_0(fst_op_I0_0),
    .O_0_t0b(fst_op_O_0_t0b),
    .O_0_t1b(fst_op_O_0_t1b)
  );
  assign valid_down = fst_op_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0_t0b = fst_op_O_0_t0b; // @[Map2S.scala 19:8]
  assign O_0_0_t1b = fst_op_O_0_t1b; // @[Map2S.scala 19:8]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0_0 = I0_0_0; // @[Map2S.scala 17:13]
endmodule
module RShift(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  assign valid_down = valid_up; // @[Arithmetic.scala 272:14]
  assign O = I_t0b >> I_t1b; // @[Arithmetic.scala 270:7]
endmodule
module MapS_7(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_t0b,
  input  [7:0] I_0_t1b,
  output [7:0] O_0
);
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_t0b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_t1b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O; // @[MapS.scala 9:22]
  RShift fst_op ( // @[MapS.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_t0b(fst_op_I_t0b),
    .I_t1b(fst_op_I_t1b),
    .O(fst_op_O)
  );
  assign valid_down = fst_op_valid_down; // @[MapS.scala 23:14]
  assign O_0 = fst_op_O; // @[MapS.scala 17:8]
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_t0b = I_0_t0b; // @[MapS.scala 16:12]
  assign fst_op_I_t1b = I_0_t1b; // @[MapS.scala 16:12]
endmodule
module MapS_8(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_t0b,
  input  [7:0] I_0_0_t1b,
  output [7:0] O_0_0
);
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_t0b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_t1b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0; // @[MapS.scala 9:22]
  MapS_7 fst_op ( // @[MapS.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_0_t0b(fst_op_I_0_t0b),
    .I_0_t1b(fst_op_I_0_t1b),
    .O_0(fst_op_O_0)
  );
  assign valid_down = fst_op_valid_down; // @[MapS.scala 23:14]
  assign O_0_0 = fst_op_O_0; // @[MapS.scala 17:8]
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_0_t0b = I_0_0_t0b; // @[MapS.scala 16:12]
  assign fst_op_I_0_t1b = I_0_0_t1b; // @[MapS.scala 16:12]
endmodule
module Module_0(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_0_2,
  input  [7:0] I_1_0,
  input  [7:0] I_1_1,
  input  [7:0] I_1_2,
  input  [7:0] I_2_0,
  input  [7:0] I_2_1,
  input  [7:0] I_2_2,
  output [7:0] O_0_0
);
  wire  InitialDelayCounter_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_valid_down; // @[Const.scala 11:33]
  wire  n110_valid_up; // @[Top.scala 17:22]
  wire  n110_valid_down; // @[Top.scala 17:22]
  wire [7:0] n110_I0_0_0; // @[Top.scala 17:22]
  wire [7:0] n110_I0_0_1; // @[Top.scala 17:22]
  wire [7:0] n110_I0_0_2; // @[Top.scala 17:22]
  wire [7:0] n110_I0_1_0; // @[Top.scala 17:22]
  wire [7:0] n110_I0_1_1; // @[Top.scala 17:22]
  wire [7:0] n110_I0_1_2; // @[Top.scala 17:22]
  wire [7:0] n110_I0_2_0; // @[Top.scala 17:22]
  wire [7:0] n110_I0_2_1; // @[Top.scala 17:22]
  wire [7:0] n110_I0_2_2; // @[Top.scala 17:22]
  wire [7:0] n110_O_0_0_t0b; // @[Top.scala 17:22]
  wire [7:0] n110_O_0_0_t1b; // @[Top.scala 17:22]
  wire [7:0] n110_O_0_1_t0b; // @[Top.scala 17:22]
  wire [7:0] n110_O_0_1_t1b; // @[Top.scala 17:22]
  wire [7:0] n110_O_0_2_t0b; // @[Top.scala 17:22]
  wire [7:0] n110_O_0_2_t1b; // @[Top.scala 17:22]
  wire [7:0] n110_O_1_0_t0b; // @[Top.scala 17:22]
  wire [7:0] n110_O_1_0_t1b; // @[Top.scala 17:22]
  wire [7:0] n110_O_1_1_t0b; // @[Top.scala 17:22]
  wire [7:0] n110_O_1_1_t1b; // @[Top.scala 17:22]
  wire [7:0] n110_O_1_2_t0b; // @[Top.scala 17:22]
  wire [7:0] n110_O_1_2_t1b; // @[Top.scala 17:22]
  wire [7:0] n110_O_2_0_t0b; // @[Top.scala 17:22]
  wire [7:0] n110_O_2_0_t1b; // @[Top.scala 17:22]
  wire [7:0] n110_O_2_1_t0b; // @[Top.scala 17:22]
  wire [7:0] n110_O_2_1_t1b; // @[Top.scala 17:22]
  wire [7:0] n110_O_2_2_t0b; // @[Top.scala 17:22]
  wire [7:0] n110_O_2_2_t1b; // @[Top.scala 17:22]
  wire  n121_valid_up; // @[Top.scala 21:22]
  wire  n121_valid_down; // @[Top.scala 21:22]
  wire [7:0] n121_I_0_0_t0b; // @[Top.scala 21:22]
  wire [7:0] n121_I_0_0_t1b; // @[Top.scala 21:22]
  wire [7:0] n121_I_0_1_t0b; // @[Top.scala 21:22]
  wire [7:0] n121_I_0_1_t1b; // @[Top.scala 21:22]
  wire [7:0] n121_I_0_2_t0b; // @[Top.scala 21:22]
  wire [7:0] n121_I_0_2_t1b; // @[Top.scala 21:22]
  wire [7:0] n121_I_1_0_t0b; // @[Top.scala 21:22]
  wire [7:0] n121_I_1_0_t1b; // @[Top.scala 21:22]
  wire [7:0] n121_I_1_1_t0b; // @[Top.scala 21:22]
  wire [7:0] n121_I_1_1_t1b; // @[Top.scala 21:22]
  wire [7:0] n121_I_1_2_t0b; // @[Top.scala 21:22]
  wire [7:0] n121_I_1_2_t1b; // @[Top.scala 21:22]
  wire [7:0] n121_I_2_0_t0b; // @[Top.scala 21:22]
  wire [7:0] n121_I_2_0_t1b; // @[Top.scala 21:22]
  wire [7:0] n121_I_2_1_t0b; // @[Top.scala 21:22]
  wire [7:0] n121_I_2_1_t1b; // @[Top.scala 21:22]
  wire [7:0] n121_I_2_2_t0b; // @[Top.scala 21:22]
  wire [7:0] n121_I_2_2_t1b; // @[Top.scala 21:22]
  wire [7:0] n121_O_0_0; // @[Top.scala 21:22]
  wire [7:0] n121_O_0_1; // @[Top.scala 21:22]
  wire [7:0] n121_O_0_2; // @[Top.scala 21:22]
  wire [7:0] n121_O_1_0; // @[Top.scala 21:22]
  wire [7:0] n121_O_1_1; // @[Top.scala 21:22]
  wire [7:0] n121_O_1_2; // @[Top.scala 21:22]
  wire [7:0] n121_O_2_0; // @[Top.scala 21:22]
  wire [7:0] n121_O_2_1; // @[Top.scala 21:22]
  wire [7:0] n121_O_2_2; // @[Top.scala 21:22]
  wire  n126_clock; // @[Top.scala 24:22]
  wire  n126_reset; // @[Top.scala 24:22]
  wire  n126_valid_up; // @[Top.scala 24:22]
  wire  n126_valid_down; // @[Top.scala 24:22]
  wire [7:0] n126_I_0_0; // @[Top.scala 24:22]
  wire [7:0] n126_I_0_1; // @[Top.scala 24:22]
  wire [7:0] n126_I_0_2; // @[Top.scala 24:22]
  wire [7:0] n126_I_1_0; // @[Top.scala 24:22]
  wire [7:0] n126_I_1_1; // @[Top.scala 24:22]
  wire [7:0] n126_I_1_2; // @[Top.scala 24:22]
  wire [7:0] n126_I_2_0; // @[Top.scala 24:22]
  wire [7:0] n126_I_2_1; // @[Top.scala 24:22]
  wire [7:0] n126_I_2_2; // @[Top.scala 24:22]
  wire [7:0] n126_O_0_0; // @[Top.scala 24:22]
  wire [7:0] n126_O_1_0; // @[Top.scala 24:22]
  wire [7:0] n126_O_2_0; // @[Top.scala 24:22]
  wire  n131_clock; // @[Top.scala 27:22]
  wire  n131_reset; // @[Top.scala 27:22]
  wire  n131_valid_up; // @[Top.scala 27:22]
  wire  n131_valid_down; // @[Top.scala 27:22]
  wire [7:0] n131_I_0_0; // @[Top.scala 27:22]
  wire [7:0] n131_I_1_0; // @[Top.scala 27:22]
  wire [7:0] n131_I_2_0; // @[Top.scala 27:22]
  wire [7:0] n131_O_0_0; // @[Top.scala 27:22]
  wire  InitialDelayCounter_1_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_valid_down; // @[Const.scala 11:33]
  wire  n134_valid_up; // @[Top.scala 31:22]
  wire  n134_valid_down; // @[Top.scala 31:22]
  wire [7:0] n134_I0_0_0; // @[Top.scala 31:22]
  wire [7:0] n134_O_0_0_t0b; // @[Top.scala 31:22]
  wire [7:0] n134_O_0_0_t1b; // @[Top.scala 31:22]
  wire  n145_valid_up; // @[Top.scala 35:22]
  wire  n145_valid_down; // @[Top.scala 35:22]
  wire [7:0] n145_I_0_0_t0b; // @[Top.scala 35:22]
  wire [7:0] n145_I_0_0_t1b; // @[Top.scala 35:22]
  wire [7:0] n145_O_0_0; // @[Top.scala 35:22]
  InitialDelayCounter InitialDelayCounter ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_clock),
    .reset(InitialDelayCounter_reset),
    .valid_down(InitialDelayCounter_valid_down)
  );
  Map2S_9 n110 ( // @[Top.scala 17:22]
    .valid_up(n110_valid_up),
    .valid_down(n110_valid_down),
    .I0_0_0(n110_I0_0_0),
    .I0_0_1(n110_I0_0_1),
    .I0_0_2(n110_I0_0_2),
    .I0_1_0(n110_I0_1_0),
    .I0_1_1(n110_I0_1_1),
    .I0_1_2(n110_I0_1_2),
    .I0_2_0(n110_I0_2_0),
    .I0_2_1(n110_I0_2_1),
    .I0_2_2(n110_I0_2_2),
    .O_0_0_t0b(n110_O_0_0_t0b),
    .O_0_0_t1b(n110_O_0_0_t1b),
    .O_0_1_t0b(n110_O_0_1_t0b),
    .O_0_1_t1b(n110_O_0_1_t1b),
    .O_0_2_t0b(n110_O_0_2_t0b),
    .O_0_2_t1b(n110_O_0_2_t1b),
    .O_1_0_t0b(n110_O_1_0_t0b),
    .O_1_0_t1b(n110_O_1_0_t1b),
    .O_1_1_t0b(n110_O_1_1_t0b),
    .O_1_1_t1b(n110_O_1_1_t1b),
    .O_1_2_t0b(n110_O_1_2_t0b),
    .O_1_2_t1b(n110_O_1_2_t1b),
    .O_2_0_t0b(n110_O_2_0_t0b),
    .O_2_0_t1b(n110_O_2_0_t1b),
    .O_2_1_t0b(n110_O_2_1_t0b),
    .O_2_1_t1b(n110_O_2_1_t1b),
    .O_2_2_t0b(n110_O_2_2_t0b),
    .O_2_2_t1b(n110_O_2_2_t1b)
  );
  MapS_5 n121 ( // @[Top.scala 21:22]
    .valid_up(n121_valid_up),
    .valid_down(n121_valid_down),
    .I_0_0_t0b(n121_I_0_0_t0b),
    .I_0_0_t1b(n121_I_0_0_t1b),
    .I_0_1_t0b(n121_I_0_1_t0b),
    .I_0_1_t1b(n121_I_0_1_t1b),
    .I_0_2_t0b(n121_I_0_2_t0b),
    .I_0_2_t1b(n121_I_0_2_t1b),
    .I_1_0_t0b(n121_I_1_0_t0b),
    .I_1_0_t1b(n121_I_1_0_t1b),
    .I_1_1_t0b(n121_I_1_1_t0b),
    .I_1_1_t1b(n121_I_1_1_t1b),
    .I_1_2_t0b(n121_I_1_2_t0b),
    .I_1_2_t1b(n121_I_1_2_t1b),
    .I_2_0_t0b(n121_I_2_0_t0b),
    .I_2_0_t1b(n121_I_2_0_t1b),
    .I_2_1_t0b(n121_I_2_1_t0b),
    .I_2_1_t1b(n121_I_2_1_t1b),
    .I_2_2_t0b(n121_I_2_2_t0b),
    .I_2_2_t1b(n121_I_2_2_t1b),
    .O_0_0(n121_O_0_0),
    .O_0_1(n121_O_0_1),
    .O_0_2(n121_O_0_2),
    .O_1_0(n121_O_1_0),
    .O_1_1(n121_O_1_1),
    .O_1_2(n121_O_1_2),
    .O_2_0(n121_O_2_0),
    .O_2_1(n121_O_2_1),
    .O_2_2(n121_O_2_2)
  );
  MapS_6 n126 ( // @[Top.scala 24:22]
    .clock(n126_clock),
    .reset(n126_reset),
    .valid_up(n126_valid_up),
    .valid_down(n126_valid_down),
    .I_0_0(n126_I_0_0),
    .I_0_1(n126_I_0_1),
    .I_0_2(n126_I_0_2),
    .I_1_0(n126_I_1_0),
    .I_1_1(n126_I_1_1),
    .I_1_2(n126_I_1_2),
    .I_2_0(n126_I_2_0),
    .I_2_1(n126_I_2_1),
    .I_2_2(n126_I_2_2),
    .O_0_0(n126_O_0_0),
    .O_1_0(n126_O_1_0),
    .O_2_0(n126_O_2_0)
  );
  ReduceS_1 n131 ( // @[Top.scala 27:22]
    .clock(n131_clock),
    .reset(n131_reset),
    .valid_up(n131_valid_up),
    .valid_down(n131_valid_down),
    .I_0_0(n131_I_0_0),
    .I_1_0(n131_I_1_0),
    .I_2_0(n131_I_2_0),
    .O_0_0(n131_O_0_0)
  );
  InitialDelayCounter_1 InitialDelayCounter_1 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_1_clock),
    .reset(InitialDelayCounter_1_reset),
    .valid_down(InitialDelayCounter_1_valid_down)
  );
  Map2S_11 n134 ( // @[Top.scala 31:22]
    .valid_up(n134_valid_up),
    .valid_down(n134_valid_down),
    .I0_0_0(n134_I0_0_0),
    .O_0_0_t0b(n134_O_0_0_t0b),
    .O_0_0_t1b(n134_O_0_0_t1b)
  );
  MapS_8 n145 ( // @[Top.scala 35:22]
    .valid_up(n145_valid_up),
    .valid_down(n145_valid_down),
    .I_0_0_t0b(n145_I_0_0_t0b),
    .I_0_0_t1b(n145_I_0_0_t1b),
    .O_0_0(n145_O_0_0)
  );
  assign valid_down = n145_valid_down; // @[Top.scala 39:16]
  assign O_0_0 = n145_O_0_0; // @[Top.scala 38:7]
  assign InitialDelayCounter_clock = clock;
  assign InitialDelayCounter_reset = reset;
  assign n110_valid_up = valid_up & InitialDelayCounter_valid_down; // @[Top.scala 20:19]
  assign n110_I0_0_0 = I_0_0; // @[Top.scala 18:13]
  assign n110_I0_0_1 = I_0_1; // @[Top.scala 18:13]
  assign n110_I0_0_2 = I_0_2; // @[Top.scala 18:13]
  assign n110_I0_1_0 = I_1_0; // @[Top.scala 18:13]
  assign n110_I0_1_1 = I_1_1; // @[Top.scala 18:13]
  assign n110_I0_1_2 = I_1_2; // @[Top.scala 18:13]
  assign n110_I0_2_0 = I_2_0; // @[Top.scala 18:13]
  assign n110_I0_2_1 = I_2_1; // @[Top.scala 18:13]
  assign n110_I0_2_2 = I_2_2; // @[Top.scala 18:13]
  assign n121_valid_up = n110_valid_down; // @[Top.scala 23:19]
  assign n121_I_0_0_t0b = n110_O_0_0_t0b; // @[Top.scala 22:12]
  assign n121_I_0_0_t1b = n110_O_0_0_t1b; // @[Top.scala 22:12]
  assign n121_I_0_1_t0b = n110_O_0_1_t0b; // @[Top.scala 22:12]
  assign n121_I_0_1_t1b = n110_O_0_1_t1b; // @[Top.scala 22:12]
  assign n121_I_0_2_t0b = n110_O_0_2_t0b; // @[Top.scala 22:12]
  assign n121_I_0_2_t1b = n110_O_0_2_t1b; // @[Top.scala 22:12]
  assign n121_I_1_0_t0b = n110_O_1_0_t0b; // @[Top.scala 22:12]
  assign n121_I_1_0_t1b = n110_O_1_0_t1b; // @[Top.scala 22:12]
  assign n121_I_1_1_t0b = n110_O_1_1_t0b; // @[Top.scala 22:12]
  assign n121_I_1_1_t1b = n110_O_1_1_t1b; // @[Top.scala 22:12]
  assign n121_I_1_2_t0b = n110_O_1_2_t0b; // @[Top.scala 22:12]
  assign n121_I_1_2_t1b = n110_O_1_2_t1b; // @[Top.scala 22:12]
  assign n121_I_2_0_t0b = n110_O_2_0_t0b; // @[Top.scala 22:12]
  assign n121_I_2_0_t1b = n110_O_2_0_t1b; // @[Top.scala 22:12]
  assign n121_I_2_1_t0b = n110_O_2_1_t0b; // @[Top.scala 22:12]
  assign n121_I_2_1_t1b = n110_O_2_1_t1b; // @[Top.scala 22:12]
  assign n121_I_2_2_t0b = n110_O_2_2_t0b; // @[Top.scala 22:12]
  assign n121_I_2_2_t1b = n110_O_2_2_t1b; // @[Top.scala 22:12]
  assign n126_clock = clock;
  assign n126_reset = reset;
  assign n126_valid_up = n121_valid_down; // @[Top.scala 26:19]
  assign n126_I_0_0 = n121_O_0_0; // @[Top.scala 25:12]
  assign n126_I_0_1 = n121_O_0_1; // @[Top.scala 25:12]
  assign n126_I_0_2 = n121_O_0_2; // @[Top.scala 25:12]
  assign n126_I_1_0 = n121_O_1_0; // @[Top.scala 25:12]
  assign n126_I_1_1 = n121_O_1_1; // @[Top.scala 25:12]
  assign n126_I_1_2 = n121_O_1_2; // @[Top.scala 25:12]
  assign n126_I_2_0 = n121_O_2_0; // @[Top.scala 25:12]
  assign n126_I_2_1 = n121_O_2_1; // @[Top.scala 25:12]
  assign n126_I_2_2 = n121_O_2_2; // @[Top.scala 25:12]
  assign n131_clock = clock;
  assign n131_reset = reset;
  assign n131_valid_up = n126_valid_down; // @[Top.scala 29:19]
  assign n131_I_0_0 = n126_O_0_0; // @[Top.scala 28:12]
  assign n131_I_1_0 = n126_O_1_0; // @[Top.scala 28:12]
  assign n131_I_2_0 = n126_O_2_0; // @[Top.scala 28:12]
  assign InitialDelayCounter_1_clock = clock;
  assign InitialDelayCounter_1_reset = reset;
  assign n134_valid_up = n131_valid_down & InitialDelayCounter_1_valid_down; // @[Top.scala 34:19]
  assign n134_I0_0_0 = n131_O_0_0; // @[Top.scala 32:13]
  assign n145_valid_up = n134_valid_down; // @[Top.scala 37:19]
  assign n145_I_0_0_t0b = n134_O_0_0_t0b; // @[Top.scala 36:12]
  assign n145_I_0_0_t1b = n134_O_0_0_t1b; // @[Top.scala 36:12]
endmodule
module MapS_9(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  input  [7:0] I_0_0_2,
  input  [7:0] I_0_1_0,
  input  [7:0] I_0_1_1,
  input  [7:0] I_0_1_2,
  input  [7:0] I_0_2_0,
  input  [7:0] I_0_2_1,
  input  [7:0] I_0_2_2,
  input  [7:0] I_1_0_0,
  input  [7:0] I_1_0_1,
  input  [7:0] I_1_0_2,
  input  [7:0] I_1_1_0,
  input  [7:0] I_1_1_1,
  input  [7:0] I_1_1_2,
  input  [7:0] I_1_2_0,
  input  [7:0] I_1_2_1,
  input  [7:0] I_1_2_2,
  output [7:0] O_0_0_0,
  output [7:0] O_1_0_0
);
  wire  fst_op_clock; // @[MapS.scala 9:22]
  wire  fst_op_reset; // @[MapS.scala 9:22]
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_2; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_1_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_1_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_1_2; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_2_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_2_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_2_2; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0_0; // @[MapS.scala 9:22]
  wire  other_ops_0_clock; // @[MapS.scala 10:86]
  wire  other_ops_0_reset; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_2; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_1_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_1_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_1_2; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_2_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_2_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_2_2; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_0_0; // @[MapS.scala 10:86]
  Module_0 fst_op ( // @[MapS.scala 9:22]
    .clock(fst_op_clock),
    .reset(fst_op_reset),
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_0_0(fst_op_I_0_0),
    .I_0_1(fst_op_I_0_1),
    .I_0_2(fst_op_I_0_2),
    .I_1_0(fst_op_I_1_0),
    .I_1_1(fst_op_I_1_1),
    .I_1_2(fst_op_I_1_2),
    .I_2_0(fst_op_I_2_0),
    .I_2_1(fst_op_I_2_1),
    .I_2_2(fst_op_I_2_2),
    .O_0_0(fst_op_O_0_0)
  );
  Module_0 other_ops_0 ( // @[MapS.scala 10:86]
    .clock(other_ops_0_clock),
    .reset(other_ops_0_reset),
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I_0_0(other_ops_0_I_0_0),
    .I_0_1(other_ops_0_I_0_1),
    .I_0_2(other_ops_0_I_0_2),
    .I_1_0(other_ops_0_I_1_0),
    .I_1_1(other_ops_0_I_1_1),
    .I_1_2(other_ops_0_I_1_2),
    .I_2_0(other_ops_0_I_2_0),
    .I_2_1(other_ops_0_I_2_1),
    .I_2_2(other_ops_0_I_2_2),
    .O_0_0(other_ops_0_O_0_0)
  );
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[MapS.scala 23:14]
  assign O_0_0_0 = fst_op_O_0_0; // @[MapS.scala 17:8]
  assign O_1_0_0 = other_ops_0_O_0_0; // @[MapS.scala 21:12]
  assign fst_op_clock = clock;
  assign fst_op_reset = reset;
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_0_0 = I_0_0_0; // @[MapS.scala 16:12]
  assign fst_op_I_0_1 = I_0_0_1; // @[MapS.scala 16:12]
  assign fst_op_I_0_2 = I_0_0_2; // @[MapS.scala 16:12]
  assign fst_op_I_1_0 = I_0_1_0; // @[MapS.scala 16:12]
  assign fst_op_I_1_1 = I_0_1_1; // @[MapS.scala 16:12]
  assign fst_op_I_1_2 = I_0_1_2; // @[MapS.scala 16:12]
  assign fst_op_I_2_0 = I_0_2_0; // @[MapS.scala 16:12]
  assign fst_op_I_2_1 = I_0_2_1; // @[MapS.scala 16:12]
  assign fst_op_I_2_2 = I_0_2_2; // @[MapS.scala 16:12]
  assign other_ops_0_clock = clock; // @[MapS.scala 10:86]
  assign other_ops_0_reset = reset; // @[MapS.scala 10:86]
  assign other_ops_0_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_0_I_0_0 = I_1_0_0; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_1 = I_1_0_1; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_2 = I_1_0_2; // @[MapS.scala 20:41]
  assign other_ops_0_I_1_0 = I_1_1_0; // @[MapS.scala 20:41]
  assign other_ops_0_I_1_1 = I_1_1_1; // @[MapS.scala 20:41]
  assign other_ops_0_I_1_2 = I_1_1_2; // @[MapS.scala 20:41]
  assign other_ops_0_I_2_0 = I_1_2_0; // @[MapS.scala 20:41]
  assign other_ops_0_I_2_1 = I_1_2_1; // @[MapS.scala 20:41]
  assign other_ops_0_I_2_2 = I_1_2_2; // @[MapS.scala 20:41]
endmodule
module MapT_8(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  input  [7:0] I_0_0_2,
  input  [7:0] I_0_1_0,
  input  [7:0] I_0_1_1,
  input  [7:0] I_0_1_2,
  input  [7:0] I_0_2_0,
  input  [7:0] I_0_2_1,
  input  [7:0] I_0_2_2,
  input  [7:0] I_1_0_0,
  input  [7:0] I_1_0_1,
  input  [7:0] I_1_0_2,
  input  [7:0] I_1_1_0,
  input  [7:0] I_1_1_1,
  input  [7:0] I_1_1_2,
  input  [7:0] I_1_2_0,
  input  [7:0] I_1_2_1,
  input  [7:0] I_1_2_2,
  output [7:0] O_0_0_0,
  output [7:0] O_1_0_0
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_2_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0_0; // @[MapT.scala 8:20]
  MapS_9 op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0_0(op_I_0_0_0),
    .I_0_0_1(op_I_0_0_1),
    .I_0_0_2(op_I_0_0_2),
    .I_0_1_0(op_I_0_1_0),
    .I_0_1_1(op_I_0_1_1),
    .I_0_1_2(op_I_0_1_2),
    .I_0_2_0(op_I_0_2_0),
    .I_0_2_1(op_I_0_2_1),
    .I_0_2_2(op_I_0_2_2),
    .I_1_0_0(op_I_1_0_0),
    .I_1_0_1(op_I_1_0_1),
    .I_1_0_2(op_I_1_0_2),
    .I_1_1_0(op_I_1_1_0),
    .I_1_1_1(op_I_1_1_1),
    .I_1_1_2(op_I_1_1_2),
    .I_1_2_0(op_I_1_2_0),
    .I_1_2_1(op_I_1_2_1),
    .I_1_2_2(op_I_1_2_2),
    .O_0_0_0(op_O_0_0_0),
    .O_1_0_0(op_O_1_0_0)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0_0 = op_O_0_0_0; // @[MapT.scala 15:7]
  assign O_1_0_0 = op_O_1_0_0; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0_0 = I_0_0_0; // @[MapT.scala 14:10]
  assign op_I_0_0_1 = I_0_0_1; // @[MapT.scala 14:10]
  assign op_I_0_0_2 = I_0_0_2; // @[MapT.scala 14:10]
  assign op_I_0_1_0 = I_0_1_0; // @[MapT.scala 14:10]
  assign op_I_0_1_1 = I_0_1_1; // @[MapT.scala 14:10]
  assign op_I_0_1_2 = I_0_1_2; // @[MapT.scala 14:10]
  assign op_I_0_2_0 = I_0_2_0; // @[MapT.scala 14:10]
  assign op_I_0_2_1 = I_0_2_1; // @[MapT.scala 14:10]
  assign op_I_0_2_2 = I_0_2_2; // @[MapT.scala 14:10]
  assign op_I_1_0_0 = I_1_0_0; // @[MapT.scala 14:10]
  assign op_I_1_0_1 = I_1_0_1; // @[MapT.scala 14:10]
  assign op_I_1_0_2 = I_1_0_2; // @[MapT.scala 14:10]
  assign op_I_1_1_0 = I_1_1_0; // @[MapT.scala 14:10]
  assign op_I_1_1_1 = I_1_1_1; // @[MapT.scala 14:10]
  assign op_I_1_1_2 = I_1_1_2; // @[MapT.scala 14:10]
  assign op_I_1_2_0 = I_1_2_0; // @[MapT.scala 14:10]
  assign op_I_1_2_1 = I_1_2_1; // @[MapT.scala 14:10]
  assign op_I_1_2_2 = I_1_2_2; // @[MapT.scala 14:10]
endmodule
module Passthrough(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_1_0_0,
  output [7:0] O_0_0,
  output [7:0] O_1_0
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O_0_0 = I_0_0_0; // @[Passthrough.scala 17:68]
  assign O_1_0 = I_1_0_0; // @[Passthrough.scala 17:68]
endmodule
module Passthrough_1(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_1_0,
  output [7:0] O_0,
  output [7:0] O_1
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O_0 = I_0_0; // @[Passthrough.scala 17:68]
  assign O_1 = I_1_0; // @[Passthrough.scala 17:68]
endmodule
module Top(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  output [7:0] O_0,
  output [7:0] O_1
);
  wire  n1_clock; // @[Top.scala 45:20]
  wire  n1_reset; // @[Top.scala 45:20]
  wire  n1_valid_up; // @[Top.scala 45:20]
  wire  n1_valid_down; // @[Top.scala 45:20]
  wire [7:0] n1_I_0; // @[Top.scala 45:20]
  wire [7:0] n1_I_1; // @[Top.scala 45:20]
  wire [7:0] n1_O_0; // @[Top.scala 45:20]
  wire [7:0] n1_O_1; // @[Top.scala 45:20]
  wire  n2_clock; // @[Top.scala 48:20]
  wire  n2_reset; // @[Top.scala 48:20]
  wire  n2_valid_up; // @[Top.scala 48:20]
  wire  n2_valid_down; // @[Top.scala 48:20]
  wire [7:0] n2_I_0; // @[Top.scala 48:20]
  wire [7:0] n2_I_1; // @[Top.scala 48:20]
  wire [7:0] n2_O_0; // @[Top.scala 48:20]
  wire [7:0] n2_O_1; // @[Top.scala 48:20]
  wire  n3_clock; // @[Top.scala 51:20]
  wire  n3_reset; // @[Top.scala 51:20]
  wire  n3_valid_up; // @[Top.scala 51:20]
  wire  n3_valid_down; // @[Top.scala 51:20]
  wire [7:0] n3_I_0; // @[Top.scala 51:20]
  wire [7:0] n3_I_1; // @[Top.scala 51:20]
  wire [7:0] n3_O_0; // @[Top.scala 51:20]
  wire [7:0] n3_O_1; // @[Top.scala 51:20]
  wire  n4_clock; // @[Top.scala 54:20]
  wire  n4_valid_up; // @[Top.scala 54:20]
  wire  n4_valid_down; // @[Top.scala 54:20]
  wire [7:0] n4_I_0; // @[Top.scala 54:20]
  wire [7:0] n4_I_1; // @[Top.scala 54:20]
  wire [7:0] n4_O_0; // @[Top.scala 54:20]
  wire [7:0] n4_O_1; // @[Top.scala 54:20]
  wire  n5_clock; // @[Top.scala 57:20]
  wire  n5_valid_up; // @[Top.scala 57:20]
  wire  n5_valid_down; // @[Top.scala 57:20]
  wire [7:0] n5_I_0; // @[Top.scala 57:20]
  wire [7:0] n5_I_1; // @[Top.scala 57:20]
  wire [7:0] n5_O_0; // @[Top.scala 57:20]
  wire [7:0] n5_O_1; // @[Top.scala 57:20]
  wire  n6_valid_up; // @[Top.scala 60:20]
  wire  n6_valid_down; // @[Top.scala 60:20]
  wire [7:0] n6_I0_0; // @[Top.scala 60:20]
  wire [7:0] n6_I0_1; // @[Top.scala 60:20]
  wire [7:0] n6_I1_0; // @[Top.scala 60:20]
  wire [7:0] n6_I1_1; // @[Top.scala 60:20]
  wire [7:0] n6_O_0_0; // @[Top.scala 60:20]
  wire [7:0] n6_O_0_1; // @[Top.scala 60:20]
  wire [7:0] n6_O_1_0; // @[Top.scala 60:20]
  wire [7:0] n6_O_1_1; // @[Top.scala 60:20]
  wire  n13_valid_up; // @[Top.scala 64:21]
  wire  n13_valid_down; // @[Top.scala 64:21]
  wire [7:0] n13_I0_0_0; // @[Top.scala 64:21]
  wire [7:0] n13_I0_0_1; // @[Top.scala 64:21]
  wire [7:0] n13_I0_1_0; // @[Top.scala 64:21]
  wire [7:0] n13_I0_1_1; // @[Top.scala 64:21]
  wire [7:0] n13_I1_0; // @[Top.scala 64:21]
  wire [7:0] n13_I1_1; // @[Top.scala 64:21]
  wire [7:0] n13_O_0_0; // @[Top.scala 64:21]
  wire [7:0] n13_O_0_1; // @[Top.scala 64:21]
  wire [7:0] n13_O_0_2; // @[Top.scala 64:21]
  wire [7:0] n13_O_1_0; // @[Top.scala 64:21]
  wire [7:0] n13_O_1_1; // @[Top.scala 64:21]
  wire [7:0] n13_O_1_2; // @[Top.scala 64:21]
  wire  n22_valid_up; // @[Top.scala 68:21]
  wire  n22_valid_down; // @[Top.scala 68:21]
  wire [7:0] n22_I_0_0; // @[Top.scala 68:21]
  wire [7:0] n22_I_0_1; // @[Top.scala 68:21]
  wire [7:0] n22_I_0_2; // @[Top.scala 68:21]
  wire [7:0] n22_I_1_0; // @[Top.scala 68:21]
  wire [7:0] n22_I_1_1; // @[Top.scala 68:21]
  wire [7:0] n22_I_1_2; // @[Top.scala 68:21]
  wire [7:0] n22_O_0_0_0; // @[Top.scala 68:21]
  wire [7:0] n22_O_0_0_1; // @[Top.scala 68:21]
  wire [7:0] n22_O_0_0_2; // @[Top.scala 68:21]
  wire [7:0] n22_O_1_0_0; // @[Top.scala 68:21]
  wire [7:0] n22_O_1_0_1; // @[Top.scala 68:21]
  wire [7:0] n22_O_1_0_2; // @[Top.scala 68:21]
  wire  n29_valid_up; // @[Top.scala 71:21]
  wire  n29_valid_down; // @[Top.scala 71:21]
  wire [7:0] n29_I_0_0_0; // @[Top.scala 71:21]
  wire [7:0] n29_I_0_0_1; // @[Top.scala 71:21]
  wire [7:0] n29_I_0_0_2; // @[Top.scala 71:21]
  wire [7:0] n29_I_1_0_0; // @[Top.scala 71:21]
  wire [7:0] n29_I_1_0_1; // @[Top.scala 71:21]
  wire [7:0] n29_I_1_0_2; // @[Top.scala 71:21]
  wire [7:0] n29_O_0_0; // @[Top.scala 71:21]
  wire [7:0] n29_O_0_1; // @[Top.scala 71:21]
  wire [7:0] n29_O_0_2; // @[Top.scala 71:21]
  wire [7:0] n29_O_1_0; // @[Top.scala 71:21]
  wire [7:0] n29_O_1_1; // @[Top.scala 71:21]
  wire [7:0] n29_O_1_2; // @[Top.scala 71:21]
  wire  n30_clock; // @[Top.scala 74:21]
  wire  n30_valid_up; // @[Top.scala 74:21]
  wire  n30_valid_down; // @[Top.scala 74:21]
  wire [7:0] n30_I_0; // @[Top.scala 74:21]
  wire [7:0] n30_I_1; // @[Top.scala 74:21]
  wire [7:0] n30_O_0; // @[Top.scala 74:21]
  wire [7:0] n30_O_1; // @[Top.scala 74:21]
  wire  n31_clock; // @[Top.scala 77:21]
  wire  n31_valid_up; // @[Top.scala 77:21]
  wire  n31_valid_down; // @[Top.scala 77:21]
  wire [7:0] n31_I_0; // @[Top.scala 77:21]
  wire [7:0] n31_I_1; // @[Top.scala 77:21]
  wire [7:0] n31_O_0; // @[Top.scala 77:21]
  wire [7:0] n31_O_1; // @[Top.scala 77:21]
  wire  n32_valid_up; // @[Top.scala 80:21]
  wire  n32_valid_down; // @[Top.scala 80:21]
  wire [7:0] n32_I0_0; // @[Top.scala 80:21]
  wire [7:0] n32_I0_1; // @[Top.scala 80:21]
  wire [7:0] n32_I1_0; // @[Top.scala 80:21]
  wire [7:0] n32_I1_1; // @[Top.scala 80:21]
  wire [7:0] n32_O_0_0; // @[Top.scala 80:21]
  wire [7:0] n32_O_0_1; // @[Top.scala 80:21]
  wire [7:0] n32_O_1_0; // @[Top.scala 80:21]
  wire [7:0] n32_O_1_1; // @[Top.scala 80:21]
  wire  n39_valid_up; // @[Top.scala 84:21]
  wire  n39_valid_down; // @[Top.scala 84:21]
  wire [7:0] n39_I0_0_0; // @[Top.scala 84:21]
  wire [7:0] n39_I0_0_1; // @[Top.scala 84:21]
  wire [7:0] n39_I0_1_0; // @[Top.scala 84:21]
  wire [7:0] n39_I0_1_1; // @[Top.scala 84:21]
  wire [7:0] n39_I1_0; // @[Top.scala 84:21]
  wire [7:0] n39_I1_1; // @[Top.scala 84:21]
  wire [7:0] n39_O_0_0; // @[Top.scala 84:21]
  wire [7:0] n39_O_0_1; // @[Top.scala 84:21]
  wire [7:0] n39_O_0_2; // @[Top.scala 84:21]
  wire [7:0] n39_O_1_0; // @[Top.scala 84:21]
  wire [7:0] n39_O_1_1; // @[Top.scala 84:21]
  wire [7:0] n39_O_1_2; // @[Top.scala 84:21]
  wire  n48_valid_up; // @[Top.scala 88:21]
  wire  n48_valid_down; // @[Top.scala 88:21]
  wire [7:0] n48_I_0_0; // @[Top.scala 88:21]
  wire [7:0] n48_I_0_1; // @[Top.scala 88:21]
  wire [7:0] n48_I_0_2; // @[Top.scala 88:21]
  wire [7:0] n48_I_1_0; // @[Top.scala 88:21]
  wire [7:0] n48_I_1_1; // @[Top.scala 88:21]
  wire [7:0] n48_I_1_2; // @[Top.scala 88:21]
  wire [7:0] n48_O_0_0_0; // @[Top.scala 88:21]
  wire [7:0] n48_O_0_0_1; // @[Top.scala 88:21]
  wire [7:0] n48_O_0_0_2; // @[Top.scala 88:21]
  wire [7:0] n48_O_1_0_0; // @[Top.scala 88:21]
  wire [7:0] n48_O_1_0_1; // @[Top.scala 88:21]
  wire [7:0] n48_O_1_0_2; // @[Top.scala 88:21]
  wire  n55_valid_up; // @[Top.scala 91:21]
  wire  n55_valid_down; // @[Top.scala 91:21]
  wire [7:0] n55_I_0_0_0; // @[Top.scala 91:21]
  wire [7:0] n55_I_0_0_1; // @[Top.scala 91:21]
  wire [7:0] n55_I_0_0_2; // @[Top.scala 91:21]
  wire [7:0] n55_I_1_0_0; // @[Top.scala 91:21]
  wire [7:0] n55_I_1_0_1; // @[Top.scala 91:21]
  wire [7:0] n55_I_1_0_2; // @[Top.scala 91:21]
  wire [7:0] n55_O_0_0; // @[Top.scala 91:21]
  wire [7:0] n55_O_0_1; // @[Top.scala 91:21]
  wire [7:0] n55_O_0_2; // @[Top.scala 91:21]
  wire [7:0] n55_O_1_0; // @[Top.scala 91:21]
  wire [7:0] n55_O_1_1; // @[Top.scala 91:21]
  wire [7:0] n55_O_1_2; // @[Top.scala 91:21]
  wire  n56_valid_up; // @[Top.scala 94:21]
  wire  n56_valid_down; // @[Top.scala 94:21]
  wire [7:0] n56_I0_0_0; // @[Top.scala 94:21]
  wire [7:0] n56_I0_0_1; // @[Top.scala 94:21]
  wire [7:0] n56_I0_0_2; // @[Top.scala 94:21]
  wire [7:0] n56_I0_1_0; // @[Top.scala 94:21]
  wire [7:0] n56_I0_1_1; // @[Top.scala 94:21]
  wire [7:0] n56_I0_1_2; // @[Top.scala 94:21]
  wire [7:0] n56_I1_0_0; // @[Top.scala 94:21]
  wire [7:0] n56_I1_0_1; // @[Top.scala 94:21]
  wire [7:0] n56_I1_0_2; // @[Top.scala 94:21]
  wire [7:0] n56_I1_1_0; // @[Top.scala 94:21]
  wire [7:0] n56_I1_1_1; // @[Top.scala 94:21]
  wire [7:0] n56_I1_1_2; // @[Top.scala 94:21]
  wire [7:0] n56_O_0_0_0; // @[Top.scala 94:21]
  wire [7:0] n56_O_0_0_1; // @[Top.scala 94:21]
  wire [7:0] n56_O_0_0_2; // @[Top.scala 94:21]
  wire [7:0] n56_O_0_1_0; // @[Top.scala 94:21]
  wire [7:0] n56_O_0_1_1; // @[Top.scala 94:21]
  wire [7:0] n56_O_0_1_2; // @[Top.scala 94:21]
  wire [7:0] n56_O_1_0_0; // @[Top.scala 94:21]
  wire [7:0] n56_O_1_0_1; // @[Top.scala 94:21]
  wire [7:0] n56_O_1_0_2; // @[Top.scala 94:21]
  wire [7:0] n56_O_1_1_0; // @[Top.scala 94:21]
  wire [7:0] n56_O_1_1_1; // @[Top.scala 94:21]
  wire [7:0] n56_O_1_1_2; // @[Top.scala 94:21]
  wire  n63_clock; // @[Top.scala 98:21]
  wire  n63_valid_up; // @[Top.scala 98:21]
  wire  n63_valid_down; // @[Top.scala 98:21]
  wire [7:0] n63_I_0; // @[Top.scala 98:21]
  wire [7:0] n63_I_1; // @[Top.scala 98:21]
  wire [7:0] n63_O_0; // @[Top.scala 98:21]
  wire [7:0] n63_O_1; // @[Top.scala 98:21]
  wire  n64_clock; // @[Top.scala 101:21]
  wire  n64_valid_up; // @[Top.scala 101:21]
  wire  n64_valid_down; // @[Top.scala 101:21]
  wire [7:0] n64_I_0; // @[Top.scala 101:21]
  wire [7:0] n64_I_1; // @[Top.scala 101:21]
  wire [7:0] n64_O_0; // @[Top.scala 101:21]
  wire [7:0] n64_O_1; // @[Top.scala 101:21]
  wire  n65_valid_up; // @[Top.scala 104:21]
  wire  n65_valid_down; // @[Top.scala 104:21]
  wire [7:0] n65_I0_0; // @[Top.scala 104:21]
  wire [7:0] n65_I0_1; // @[Top.scala 104:21]
  wire [7:0] n65_I1_0; // @[Top.scala 104:21]
  wire [7:0] n65_I1_1; // @[Top.scala 104:21]
  wire [7:0] n65_O_0_0; // @[Top.scala 104:21]
  wire [7:0] n65_O_0_1; // @[Top.scala 104:21]
  wire [7:0] n65_O_1_0; // @[Top.scala 104:21]
  wire [7:0] n65_O_1_1; // @[Top.scala 104:21]
  wire  n72_valid_up; // @[Top.scala 108:21]
  wire  n72_valid_down; // @[Top.scala 108:21]
  wire [7:0] n72_I0_0_0; // @[Top.scala 108:21]
  wire [7:0] n72_I0_0_1; // @[Top.scala 108:21]
  wire [7:0] n72_I0_1_0; // @[Top.scala 108:21]
  wire [7:0] n72_I0_1_1; // @[Top.scala 108:21]
  wire [7:0] n72_I1_0; // @[Top.scala 108:21]
  wire [7:0] n72_I1_1; // @[Top.scala 108:21]
  wire [7:0] n72_O_0_0; // @[Top.scala 108:21]
  wire [7:0] n72_O_0_1; // @[Top.scala 108:21]
  wire [7:0] n72_O_0_2; // @[Top.scala 108:21]
  wire [7:0] n72_O_1_0; // @[Top.scala 108:21]
  wire [7:0] n72_O_1_1; // @[Top.scala 108:21]
  wire [7:0] n72_O_1_2; // @[Top.scala 108:21]
  wire  n81_valid_up; // @[Top.scala 112:21]
  wire  n81_valid_down; // @[Top.scala 112:21]
  wire [7:0] n81_I_0_0; // @[Top.scala 112:21]
  wire [7:0] n81_I_0_1; // @[Top.scala 112:21]
  wire [7:0] n81_I_0_2; // @[Top.scala 112:21]
  wire [7:0] n81_I_1_0; // @[Top.scala 112:21]
  wire [7:0] n81_I_1_1; // @[Top.scala 112:21]
  wire [7:0] n81_I_1_2; // @[Top.scala 112:21]
  wire [7:0] n81_O_0_0_0; // @[Top.scala 112:21]
  wire [7:0] n81_O_0_0_1; // @[Top.scala 112:21]
  wire [7:0] n81_O_0_0_2; // @[Top.scala 112:21]
  wire [7:0] n81_O_1_0_0; // @[Top.scala 112:21]
  wire [7:0] n81_O_1_0_1; // @[Top.scala 112:21]
  wire [7:0] n81_O_1_0_2; // @[Top.scala 112:21]
  wire  n88_valid_up; // @[Top.scala 115:21]
  wire  n88_valid_down; // @[Top.scala 115:21]
  wire [7:0] n88_I_0_0_0; // @[Top.scala 115:21]
  wire [7:0] n88_I_0_0_1; // @[Top.scala 115:21]
  wire [7:0] n88_I_0_0_2; // @[Top.scala 115:21]
  wire [7:0] n88_I_1_0_0; // @[Top.scala 115:21]
  wire [7:0] n88_I_1_0_1; // @[Top.scala 115:21]
  wire [7:0] n88_I_1_0_2; // @[Top.scala 115:21]
  wire [7:0] n88_O_0_0; // @[Top.scala 115:21]
  wire [7:0] n88_O_0_1; // @[Top.scala 115:21]
  wire [7:0] n88_O_0_2; // @[Top.scala 115:21]
  wire [7:0] n88_O_1_0; // @[Top.scala 115:21]
  wire [7:0] n88_O_1_1; // @[Top.scala 115:21]
  wire [7:0] n88_O_1_2; // @[Top.scala 115:21]
  wire  n89_valid_up; // @[Top.scala 118:21]
  wire  n89_valid_down; // @[Top.scala 118:21]
  wire [7:0] n89_I0_0_0_0; // @[Top.scala 118:21]
  wire [7:0] n89_I0_0_0_1; // @[Top.scala 118:21]
  wire [7:0] n89_I0_0_0_2; // @[Top.scala 118:21]
  wire [7:0] n89_I0_0_1_0; // @[Top.scala 118:21]
  wire [7:0] n89_I0_0_1_1; // @[Top.scala 118:21]
  wire [7:0] n89_I0_0_1_2; // @[Top.scala 118:21]
  wire [7:0] n89_I0_1_0_0; // @[Top.scala 118:21]
  wire [7:0] n89_I0_1_0_1; // @[Top.scala 118:21]
  wire [7:0] n89_I0_1_0_2; // @[Top.scala 118:21]
  wire [7:0] n89_I0_1_1_0; // @[Top.scala 118:21]
  wire [7:0] n89_I0_1_1_1; // @[Top.scala 118:21]
  wire [7:0] n89_I0_1_1_2; // @[Top.scala 118:21]
  wire [7:0] n89_I1_0_0; // @[Top.scala 118:21]
  wire [7:0] n89_I1_0_1; // @[Top.scala 118:21]
  wire [7:0] n89_I1_0_2; // @[Top.scala 118:21]
  wire [7:0] n89_I1_1_0; // @[Top.scala 118:21]
  wire [7:0] n89_I1_1_1; // @[Top.scala 118:21]
  wire [7:0] n89_I1_1_2; // @[Top.scala 118:21]
  wire [7:0] n89_O_0_0_0; // @[Top.scala 118:21]
  wire [7:0] n89_O_0_0_1; // @[Top.scala 118:21]
  wire [7:0] n89_O_0_0_2; // @[Top.scala 118:21]
  wire [7:0] n89_O_0_1_0; // @[Top.scala 118:21]
  wire [7:0] n89_O_0_1_1; // @[Top.scala 118:21]
  wire [7:0] n89_O_0_1_2; // @[Top.scala 118:21]
  wire [7:0] n89_O_0_2_0; // @[Top.scala 118:21]
  wire [7:0] n89_O_0_2_1; // @[Top.scala 118:21]
  wire [7:0] n89_O_0_2_2; // @[Top.scala 118:21]
  wire [7:0] n89_O_1_0_0; // @[Top.scala 118:21]
  wire [7:0] n89_O_1_0_1; // @[Top.scala 118:21]
  wire [7:0] n89_O_1_0_2; // @[Top.scala 118:21]
  wire [7:0] n89_O_1_1_0; // @[Top.scala 118:21]
  wire [7:0] n89_O_1_1_1; // @[Top.scala 118:21]
  wire [7:0] n89_O_1_1_2; // @[Top.scala 118:21]
  wire [7:0] n89_O_1_2_0; // @[Top.scala 118:21]
  wire [7:0] n89_O_1_2_1; // @[Top.scala 118:21]
  wire [7:0] n89_O_1_2_2; // @[Top.scala 118:21]
  wire  n98_valid_up; // @[Top.scala 122:21]
  wire  n98_valid_down; // @[Top.scala 122:21]
  wire [7:0] n98_I_0_0_0; // @[Top.scala 122:21]
  wire [7:0] n98_I_0_0_1; // @[Top.scala 122:21]
  wire [7:0] n98_I_0_0_2; // @[Top.scala 122:21]
  wire [7:0] n98_I_0_1_0; // @[Top.scala 122:21]
  wire [7:0] n98_I_0_1_1; // @[Top.scala 122:21]
  wire [7:0] n98_I_0_1_2; // @[Top.scala 122:21]
  wire [7:0] n98_I_0_2_0; // @[Top.scala 122:21]
  wire [7:0] n98_I_0_2_1; // @[Top.scala 122:21]
  wire [7:0] n98_I_0_2_2; // @[Top.scala 122:21]
  wire [7:0] n98_I_1_0_0; // @[Top.scala 122:21]
  wire [7:0] n98_I_1_0_1; // @[Top.scala 122:21]
  wire [7:0] n98_I_1_0_2; // @[Top.scala 122:21]
  wire [7:0] n98_I_1_1_0; // @[Top.scala 122:21]
  wire [7:0] n98_I_1_1_1; // @[Top.scala 122:21]
  wire [7:0] n98_I_1_1_2; // @[Top.scala 122:21]
  wire [7:0] n98_I_1_2_0; // @[Top.scala 122:21]
  wire [7:0] n98_I_1_2_1; // @[Top.scala 122:21]
  wire [7:0] n98_I_1_2_2; // @[Top.scala 122:21]
  wire [7:0] n98_O_0_0_0_0; // @[Top.scala 122:21]
  wire [7:0] n98_O_0_0_0_1; // @[Top.scala 122:21]
  wire [7:0] n98_O_0_0_0_2; // @[Top.scala 122:21]
  wire [7:0] n98_O_0_0_1_0; // @[Top.scala 122:21]
  wire [7:0] n98_O_0_0_1_1; // @[Top.scala 122:21]
  wire [7:0] n98_O_0_0_1_2; // @[Top.scala 122:21]
  wire [7:0] n98_O_0_0_2_0; // @[Top.scala 122:21]
  wire [7:0] n98_O_0_0_2_1; // @[Top.scala 122:21]
  wire [7:0] n98_O_0_0_2_2; // @[Top.scala 122:21]
  wire [7:0] n98_O_1_0_0_0; // @[Top.scala 122:21]
  wire [7:0] n98_O_1_0_0_1; // @[Top.scala 122:21]
  wire [7:0] n98_O_1_0_0_2; // @[Top.scala 122:21]
  wire [7:0] n98_O_1_0_1_0; // @[Top.scala 122:21]
  wire [7:0] n98_O_1_0_1_1; // @[Top.scala 122:21]
  wire [7:0] n98_O_1_0_1_2; // @[Top.scala 122:21]
  wire [7:0] n98_O_1_0_2_0; // @[Top.scala 122:21]
  wire [7:0] n98_O_1_0_2_1; // @[Top.scala 122:21]
  wire [7:0] n98_O_1_0_2_2; // @[Top.scala 122:21]
  wire  n105_valid_up; // @[Top.scala 125:22]
  wire  n105_valid_down; // @[Top.scala 125:22]
  wire [7:0] n105_I_0_0_0_0; // @[Top.scala 125:22]
  wire [7:0] n105_I_0_0_0_1; // @[Top.scala 125:22]
  wire [7:0] n105_I_0_0_0_2; // @[Top.scala 125:22]
  wire [7:0] n105_I_0_0_1_0; // @[Top.scala 125:22]
  wire [7:0] n105_I_0_0_1_1; // @[Top.scala 125:22]
  wire [7:0] n105_I_0_0_1_2; // @[Top.scala 125:22]
  wire [7:0] n105_I_0_0_2_0; // @[Top.scala 125:22]
  wire [7:0] n105_I_0_0_2_1; // @[Top.scala 125:22]
  wire [7:0] n105_I_0_0_2_2; // @[Top.scala 125:22]
  wire [7:0] n105_I_1_0_0_0; // @[Top.scala 125:22]
  wire [7:0] n105_I_1_0_0_1; // @[Top.scala 125:22]
  wire [7:0] n105_I_1_0_0_2; // @[Top.scala 125:22]
  wire [7:0] n105_I_1_0_1_0; // @[Top.scala 125:22]
  wire [7:0] n105_I_1_0_1_1; // @[Top.scala 125:22]
  wire [7:0] n105_I_1_0_1_2; // @[Top.scala 125:22]
  wire [7:0] n105_I_1_0_2_0; // @[Top.scala 125:22]
  wire [7:0] n105_I_1_0_2_1; // @[Top.scala 125:22]
  wire [7:0] n105_I_1_0_2_2; // @[Top.scala 125:22]
  wire [7:0] n105_O_0_0_0; // @[Top.scala 125:22]
  wire [7:0] n105_O_0_0_1; // @[Top.scala 125:22]
  wire [7:0] n105_O_0_0_2; // @[Top.scala 125:22]
  wire [7:0] n105_O_0_1_0; // @[Top.scala 125:22]
  wire [7:0] n105_O_0_1_1; // @[Top.scala 125:22]
  wire [7:0] n105_O_0_1_2; // @[Top.scala 125:22]
  wire [7:0] n105_O_0_2_0; // @[Top.scala 125:22]
  wire [7:0] n105_O_0_2_1; // @[Top.scala 125:22]
  wire [7:0] n105_O_0_2_2; // @[Top.scala 125:22]
  wire [7:0] n105_O_1_0_0; // @[Top.scala 125:22]
  wire [7:0] n105_O_1_0_1; // @[Top.scala 125:22]
  wire [7:0] n105_O_1_0_2; // @[Top.scala 125:22]
  wire [7:0] n105_O_1_1_0; // @[Top.scala 125:22]
  wire [7:0] n105_O_1_1_1; // @[Top.scala 125:22]
  wire [7:0] n105_O_1_1_2; // @[Top.scala 125:22]
  wire [7:0] n105_O_1_2_0; // @[Top.scala 125:22]
  wire [7:0] n105_O_1_2_1; // @[Top.scala 125:22]
  wire [7:0] n105_O_1_2_2; // @[Top.scala 125:22]
  wire  n147_clock; // @[Top.scala 128:22]
  wire  n147_reset; // @[Top.scala 128:22]
  wire  n147_valid_up; // @[Top.scala 128:22]
  wire  n147_valid_down; // @[Top.scala 128:22]
  wire [7:0] n147_I_0_0_0; // @[Top.scala 128:22]
  wire [7:0] n147_I_0_0_1; // @[Top.scala 128:22]
  wire [7:0] n147_I_0_0_2; // @[Top.scala 128:22]
  wire [7:0] n147_I_0_1_0; // @[Top.scala 128:22]
  wire [7:0] n147_I_0_1_1; // @[Top.scala 128:22]
  wire [7:0] n147_I_0_1_2; // @[Top.scala 128:22]
  wire [7:0] n147_I_0_2_0; // @[Top.scala 128:22]
  wire [7:0] n147_I_0_2_1; // @[Top.scala 128:22]
  wire [7:0] n147_I_0_2_2; // @[Top.scala 128:22]
  wire [7:0] n147_I_1_0_0; // @[Top.scala 128:22]
  wire [7:0] n147_I_1_0_1; // @[Top.scala 128:22]
  wire [7:0] n147_I_1_0_2; // @[Top.scala 128:22]
  wire [7:0] n147_I_1_1_0; // @[Top.scala 128:22]
  wire [7:0] n147_I_1_1_1; // @[Top.scala 128:22]
  wire [7:0] n147_I_1_1_2; // @[Top.scala 128:22]
  wire [7:0] n147_I_1_2_0; // @[Top.scala 128:22]
  wire [7:0] n147_I_1_2_1; // @[Top.scala 128:22]
  wire [7:0] n147_I_1_2_2; // @[Top.scala 128:22]
  wire [7:0] n147_O_0_0_0; // @[Top.scala 128:22]
  wire [7:0] n147_O_1_0_0; // @[Top.scala 128:22]
  wire  n148_valid_up; // @[Top.scala 131:22]
  wire  n148_valid_down; // @[Top.scala 131:22]
  wire [7:0] n148_I_0_0_0; // @[Top.scala 131:22]
  wire [7:0] n148_I_1_0_0; // @[Top.scala 131:22]
  wire [7:0] n148_O_0_0; // @[Top.scala 131:22]
  wire [7:0] n148_O_1_0; // @[Top.scala 131:22]
  wire  n149_valid_up; // @[Top.scala 134:22]
  wire  n149_valid_down; // @[Top.scala 134:22]
  wire [7:0] n149_I_0_0; // @[Top.scala 134:22]
  wire [7:0] n149_I_1_0; // @[Top.scala 134:22]
  wire [7:0] n149_O_0; // @[Top.scala 134:22]
  wire [7:0] n149_O_1; // @[Top.scala 134:22]
  wire  n150_clock; // @[Top.scala 137:22]
  wire  n150_reset; // @[Top.scala 137:22]
  wire  n150_valid_up; // @[Top.scala 137:22]
  wire  n150_valid_down; // @[Top.scala 137:22]
  wire [7:0] n150_I_0; // @[Top.scala 137:22]
  wire [7:0] n150_I_1; // @[Top.scala 137:22]
  wire [7:0] n150_O_0; // @[Top.scala 137:22]
  wire [7:0] n150_O_1; // @[Top.scala 137:22]
  wire  n151_clock; // @[Top.scala 140:22]
  wire  n151_reset; // @[Top.scala 140:22]
  wire  n151_valid_up; // @[Top.scala 140:22]
  wire  n151_valid_down; // @[Top.scala 140:22]
  wire [7:0] n151_I_0; // @[Top.scala 140:22]
  wire [7:0] n151_I_1; // @[Top.scala 140:22]
  wire [7:0] n151_O_0; // @[Top.scala 140:22]
  wire [7:0] n151_O_1; // @[Top.scala 140:22]
  wire  n152_clock; // @[Top.scala 143:22]
  wire  n152_reset; // @[Top.scala 143:22]
  wire  n152_valid_up; // @[Top.scala 143:22]
  wire  n152_valid_down; // @[Top.scala 143:22]
  wire [7:0] n152_I_0; // @[Top.scala 143:22]
  wire [7:0] n152_I_1; // @[Top.scala 143:22]
  wire [7:0] n152_O_0; // @[Top.scala 143:22]
  wire [7:0] n152_O_1; // @[Top.scala 143:22]
  FIFO n1 ( // @[Top.scala 45:20]
    .clock(n1_clock),
    .reset(n1_reset),
    .valid_up(n1_valid_up),
    .valid_down(n1_valid_down),
    .I_0(n1_I_0),
    .I_1(n1_I_1),
    .O_0(n1_O_0),
    .O_1(n1_O_1)
  );
  ShiftTS n2 ( // @[Top.scala 48:20]
    .clock(n2_clock),
    .reset(n2_reset),
    .valid_up(n2_valid_up),
    .valid_down(n2_valid_down),
    .I_0(n2_I_0),
    .I_1(n2_I_1),
    .O_0(n2_O_0),
    .O_1(n2_O_1)
  );
  ShiftTS n3 ( // @[Top.scala 51:20]
    .clock(n3_clock),
    .reset(n3_reset),
    .valid_up(n3_valid_up),
    .valid_down(n3_valid_down),
    .I_0(n3_I_0),
    .I_1(n3_I_1),
    .O_0(n3_O_0),
    .O_1(n3_O_1)
  );
  ShiftTS_2 n4 ( // @[Top.scala 54:20]
    .clock(n4_clock),
    .valid_up(n4_valid_up),
    .valid_down(n4_valid_down),
    .I_0(n4_I_0),
    .I_1(n4_I_1),
    .O_0(n4_O_0),
    .O_1(n4_O_1)
  );
  ShiftTS_2 n5 ( // @[Top.scala 57:20]
    .clock(n5_clock),
    .valid_up(n5_valid_up),
    .valid_down(n5_valid_down),
    .I_0(n5_I_0),
    .I_1(n5_I_1),
    .O_0(n5_O_0),
    .O_1(n5_O_1)
  );
  Map2T n6 ( // @[Top.scala 60:20]
    .valid_up(n6_valid_up),
    .valid_down(n6_valid_down),
    .I0_0(n6_I0_0),
    .I0_1(n6_I0_1),
    .I1_0(n6_I1_0),
    .I1_1(n6_I1_1),
    .O_0_0(n6_O_0_0),
    .O_0_1(n6_O_0_1),
    .O_1_0(n6_O_1_0),
    .O_1_1(n6_O_1_1)
  );
  Map2T_1 n13 ( // @[Top.scala 64:21]
    .valid_up(n13_valid_up),
    .valid_down(n13_valid_down),
    .I0_0_0(n13_I0_0_0),
    .I0_0_1(n13_I0_0_1),
    .I0_1_0(n13_I0_1_0),
    .I0_1_1(n13_I0_1_1),
    .I1_0(n13_I1_0),
    .I1_1(n13_I1_1),
    .O_0_0(n13_O_0_0),
    .O_0_1(n13_O_0_1),
    .O_0_2(n13_O_0_2),
    .O_1_0(n13_O_1_0),
    .O_1_1(n13_O_1_1),
    .O_1_2(n13_O_1_2)
  );
  MapT n22 ( // @[Top.scala 68:21]
    .valid_up(n22_valid_up),
    .valid_down(n22_valid_down),
    .I_0_0(n22_I_0_0),
    .I_0_1(n22_I_0_1),
    .I_0_2(n22_I_0_2),
    .I_1_0(n22_I_1_0),
    .I_1_1(n22_I_1_1),
    .I_1_2(n22_I_1_2),
    .O_0_0_0(n22_O_0_0_0),
    .O_0_0_1(n22_O_0_0_1),
    .O_0_0_2(n22_O_0_0_2),
    .O_1_0_0(n22_O_1_0_0),
    .O_1_0_1(n22_O_1_0_1),
    .O_1_0_2(n22_O_1_0_2)
  );
  MapT_1 n29 ( // @[Top.scala 71:21]
    .valid_up(n29_valid_up),
    .valid_down(n29_valid_down),
    .I_0_0_0(n29_I_0_0_0),
    .I_0_0_1(n29_I_0_0_1),
    .I_0_0_2(n29_I_0_0_2),
    .I_1_0_0(n29_I_1_0_0),
    .I_1_0_1(n29_I_1_0_1),
    .I_1_0_2(n29_I_1_0_2),
    .O_0_0(n29_O_0_0),
    .O_0_1(n29_O_0_1),
    .O_0_2(n29_O_0_2),
    .O_1_0(n29_O_1_0),
    .O_1_1(n29_O_1_1),
    .O_1_2(n29_O_1_2)
  );
  ShiftTS_2 n30 ( // @[Top.scala 74:21]
    .clock(n30_clock),
    .valid_up(n30_valid_up),
    .valid_down(n30_valid_down),
    .I_0(n30_I_0),
    .I_1(n30_I_1),
    .O_0(n30_O_0),
    .O_1(n30_O_1)
  );
  ShiftTS_2 n31 ( // @[Top.scala 77:21]
    .clock(n31_clock),
    .valid_up(n31_valid_up),
    .valid_down(n31_valid_down),
    .I_0(n31_I_0),
    .I_1(n31_I_1),
    .O_0(n31_O_0),
    .O_1(n31_O_1)
  );
  Map2T n32 ( // @[Top.scala 80:21]
    .valid_up(n32_valid_up),
    .valid_down(n32_valid_down),
    .I0_0(n32_I0_0),
    .I0_1(n32_I0_1),
    .I1_0(n32_I1_0),
    .I1_1(n32_I1_1),
    .O_0_0(n32_O_0_0),
    .O_0_1(n32_O_0_1),
    .O_1_0(n32_O_1_0),
    .O_1_1(n32_O_1_1)
  );
  Map2T_1 n39 ( // @[Top.scala 84:21]
    .valid_up(n39_valid_up),
    .valid_down(n39_valid_down),
    .I0_0_0(n39_I0_0_0),
    .I0_0_1(n39_I0_0_1),
    .I0_1_0(n39_I0_1_0),
    .I0_1_1(n39_I0_1_1),
    .I1_0(n39_I1_0),
    .I1_1(n39_I1_1),
    .O_0_0(n39_O_0_0),
    .O_0_1(n39_O_0_1),
    .O_0_2(n39_O_0_2),
    .O_1_0(n39_O_1_0),
    .O_1_1(n39_O_1_1),
    .O_1_2(n39_O_1_2)
  );
  MapT n48 ( // @[Top.scala 88:21]
    .valid_up(n48_valid_up),
    .valid_down(n48_valid_down),
    .I_0_0(n48_I_0_0),
    .I_0_1(n48_I_0_1),
    .I_0_2(n48_I_0_2),
    .I_1_0(n48_I_1_0),
    .I_1_1(n48_I_1_1),
    .I_1_2(n48_I_1_2),
    .O_0_0_0(n48_O_0_0_0),
    .O_0_0_1(n48_O_0_0_1),
    .O_0_0_2(n48_O_0_0_2),
    .O_1_0_0(n48_O_1_0_0),
    .O_1_0_1(n48_O_1_0_1),
    .O_1_0_2(n48_O_1_0_2)
  );
  MapT_1 n55 ( // @[Top.scala 91:21]
    .valid_up(n55_valid_up),
    .valid_down(n55_valid_down),
    .I_0_0_0(n55_I_0_0_0),
    .I_0_0_1(n55_I_0_0_1),
    .I_0_0_2(n55_I_0_0_2),
    .I_1_0_0(n55_I_1_0_0),
    .I_1_0_1(n55_I_1_0_1),
    .I_1_0_2(n55_I_1_0_2),
    .O_0_0(n55_O_0_0),
    .O_0_1(n55_O_0_1),
    .O_0_2(n55_O_0_2),
    .O_1_0(n55_O_1_0),
    .O_1_1(n55_O_1_1),
    .O_1_2(n55_O_1_2)
  );
  Map2T_4 n56 ( // @[Top.scala 94:21]
    .valid_up(n56_valid_up),
    .valid_down(n56_valid_down),
    .I0_0_0(n56_I0_0_0),
    .I0_0_1(n56_I0_0_1),
    .I0_0_2(n56_I0_0_2),
    .I0_1_0(n56_I0_1_0),
    .I0_1_1(n56_I0_1_1),
    .I0_1_2(n56_I0_1_2),
    .I1_0_0(n56_I1_0_0),
    .I1_0_1(n56_I1_0_1),
    .I1_0_2(n56_I1_0_2),
    .I1_1_0(n56_I1_1_0),
    .I1_1_1(n56_I1_1_1),
    .I1_1_2(n56_I1_1_2),
    .O_0_0_0(n56_O_0_0_0),
    .O_0_0_1(n56_O_0_0_1),
    .O_0_0_2(n56_O_0_0_2),
    .O_0_1_0(n56_O_0_1_0),
    .O_0_1_1(n56_O_0_1_1),
    .O_0_1_2(n56_O_0_1_2),
    .O_1_0_0(n56_O_1_0_0),
    .O_1_0_1(n56_O_1_0_1),
    .O_1_0_2(n56_O_1_0_2),
    .O_1_1_0(n56_O_1_1_0),
    .O_1_1_1(n56_O_1_1_1),
    .O_1_1_2(n56_O_1_1_2)
  );
  ShiftTS_2 n63 ( // @[Top.scala 98:21]
    .clock(n63_clock),
    .valid_up(n63_valid_up),
    .valid_down(n63_valid_down),
    .I_0(n63_I_0),
    .I_1(n63_I_1),
    .O_0(n63_O_0),
    .O_1(n63_O_1)
  );
  ShiftTS_2 n64 ( // @[Top.scala 101:21]
    .clock(n64_clock),
    .valid_up(n64_valid_up),
    .valid_down(n64_valid_down),
    .I_0(n64_I_0),
    .I_1(n64_I_1),
    .O_0(n64_O_0),
    .O_1(n64_O_1)
  );
  Map2T n65 ( // @[Top.scala 104:21]
    .valid_up(n65_valid_up),
    .valid_down(n65_valid_down),
    .I0_0(n65_I0_0),
    .I0_1(n65_I0_1),
    .I1_0(n65_I1_0),
    .I1_1(n65_I1_1),
    .O_0_0(n65_O_0_0),
    .O_0_1(n65_O_0_1),
    .O_1_0(n65_O_1_0),
    .O_1_1(n65_O_1_1)
  );
  Map2T_1 n72 ( // @[Top.scala 108:21]
    .valid_up(n72_valid_up),
    .valid_down(n72_valid_down),
    .I0_0_0(n72_I0_0_0),
    .I0_0_1(n72_I0_0_1),
    .I0_1_0(n72_I0_1_0),
    .I0_1_1(n72_I0_1_1),
    .I1_0(n72_I1_0),
    .I1_1(n72_I1_1),
    .O_0_0(n72_O_0_0),
    .O_0_1(n72_O_0_1),
    .O_0_2(n72_O_0_2),
    .O_1_0(n72_O_1_0),
    .O_1_1(n72_O_1_1),
    .O_1_2(n72_O_1_2)
  );
  MapT n81 ( // @[Top.scala 112:21]
    .valid_up(n81_valid_up),
    .valid_down(n81_valid_down),
    .I_0_0(n81_I_0_0),
    .I_0_1(n81_I_0_1),
    .I_0_2(n81_I_0_2),
    .I_1_0(n81_I_1_0),
    .I_1_1(n81_I_1_1),
    .I_1_2(n81_I_1_2),
    .O_0_0_0(n81_O_0_0_0),
    .O_0_0_1(n81_O_0_0_1),
    .O_0_0_2(n81_O_0_0_2),
    .O_1_0_0(n81_O_1_0_0),
    .O_1_0_1(n81_O_1_0_1),
    .O_1_0_2(n81_O_1_0_2)
  );
  MapT_1 n88 ( // @[Top.scala 115:21]
    .valid_up(n88_valid_up),
    .valid_down(n88_valid_down),
    .I_0_0_0(n88_I_0_0_0),
    .I_0_0_1(n88_I_0_0_1),
    .I_0_0_2(n88_I_0_0_2),
    .I_1_0_0(n88_I_1_0_0),
    .I_1_0_1(n88_I_1_0_1),
    .I_1_0_2(n88_I_1_0_2),
    .O_0_0(n88_O_0_0),
    .O_0_1(n88_O_0_1),
    .O_0_2(n88_O_0_2),
    .O_1_0(n88_O_1_0),
    .O_1_1(n88_O_1_1),
    .O_1_2(n88_O_1_2)
  );
  Map2T_7 n89 ( // @[Top.scala 118:21]
    .valid_up(n89_valid_up),
    .valid_down(n89_valid_down),
    .I0_0_0_0(n89_I0_0_0_0),
    .I0_0_0_1(n89_I0_0_0_1),
    .I0_0_0_2(n89_I0_0_0_2),
    .I0_0_1_0(n89_I0_0_1_0),
    .I0_0_1_1(n89_I0_0_1_1),
    .I0_0_1_2(n89_I0_0_1_2),
    .I0_1_0_0(n89_I0_1_0_0),
    .I0_1_0_1(n89_I0_1_0_1),
    .I0_1_0_2(n89_I0_1_0_2),
    .I0_1_1_0(n89_I0_1_1_0),
    .I0_1_1_1(n89_I0_1_1_1),
    .I0_1_1_2(n89_I0_1_1_2),
    .I1_0_0(n89_I1_0_0),
    .I1_0_1(n89_I1_0_1),
    .I1_0_2(n89_I1_0_2),
    .I1_1_0(n89_I1_1_0),
    .I1_1_1(n89_I1_1_1),
    .I1_1_2(n89_I1_1_2),
    .O_0_0_0(n89_O_0_0_0),
    .O_0_0_1(n89_O_0_0_1),
    .O_0_0_2(n89_O_0_0_2),
    .O_0_1_0(n89_O_0_1_0),
    .O_0_1_1(n89_O_0_1_1),
    .O_0_1_2(n89_O_0_1_2),
    .O_0_2_0(n89_O_0_2_0),
    .O_0_2_1(n89_O_0_2_1),
    .O_0_2_2(n89_O_0_2_2),
    .O_1_0_0(n89_O_1_0_0),
    .O_1_0_1(n89_O_1_0_1),
    .O_1_0_2(n89_O_1_0_2),
    .O_1_1_0(n89_O_1_1_0),
    .O_1_1_1(n89_O_1_1_1),
    .O_1_1_2(n89_O_1_1_2),
    .O_1_2_0(n89_O_1_2_0),
    .O_1_2_1(n89_O_1_2_1),
    .O_1_2_2(n89_O_1_2_2)
  );
  MapT_6 n98 ( // @[Top.scala 122:21]
    .valid_up(n98_valid_up),
    .valid_down(n98_valid_down),
    .I_0_0_0(n98_I_0_0_0),
    .I_0_0_1(n98_I_0_0_1),
    .I_0_0_2(n98_I_0_0_2),
    .I_0_1_0(n98_I_0_1_0),
    .I_0_1_1(n98_I_0_1_1),
    .I_0_1_2(n98_I_0_1_2),
    .I_0_2_0(n98_I_0_2_0),
    .I_0_2_1(n98_I_0_2_1),
    .I_0_2_2(n98_I_0_2_2),
    .I_1_0_0(n98_I_1_0_0),
    .I_1_0_1(n98_I_1_0_1),
    .I_1_0_2(n98_I_1_0_2),
    .I_1_1_0(n98_I_1_1_0),
    .I_1_1_1(n98_I_1_1_1),
    .I_1_1_2(n98_I_1_1_2),
    .I_1_2_0(n98_I_1_2_0),
    .I_1_2_1(n98_I_1_2_1),
    .I_1_2_2(n98_I_1_2_2),
    .O_0_0_0_0(n98_O_0_0_0_0),
    .O_0_0_0_1(n98_O_0_0_0_1),
    .O_0_0_0_2(n98_O_0_0_0_2),
    .O_0_0_1_0(n98_O_0_0_1_0),
    .O_0_0_1_1(n98_O_0_0_1_1),
    .O_0_0_1_2(n98_O_0_0_1_2),
    .O_0_0_2_0(n98_O_0_0_2_0),
    .O_0_0_2_1(n98_O_0_0_2_1),
    .O_0_0_2_2(n98_O_0_0_2_2),
    .O_1_0_0_0(n98_O_1_0_0_0),
    .O_1_0_0_1(n98_O_1_0_0_1),
    .O_1_0_0_2(n98_O_1_0_0_2),
    .O_1_0_1_0(n98_O_1_0_1_0),
    .O_1_0_1_1(n98_O_1_0_1_1),
    .O_1_0_1_2(n98_O_1_0_1_2),
    .O_1_0_2_0(n98_O_1_0_2_0),
    .O_1_0_2_1(n98_O_1_0_2_1),
    .O_1_0_2_2(n98_O_1_0_2_2)
  );
  MapT_7 n105 ( // @[Top.scala 125:22]
    .valid_up(n105_valid_up),
    .valid_down(n105_valid_down),
    .I_0_0_0_0(n105_I_0_0_0_0),
    .I_0_0_0_1(n105_I_0_0_0_1),
    .I_0_0_0_2(n105_I_0_0_0_2),
    .I_0_0_1_0(n105_I_0_0_1_0),
    .I_0_0_1_1(n105_I_0_0_1_1),
    .I_0_0_1_2(n105_I_0_0_1_2),
    .I_0_0_2_0(n105_I_0_0_2_0),
    .I_0_0_2_1(n105_I_0_0_2_1),
    .I_0_0_2_2(n105_I_0_0_2_2),
    .I_1_0_0_0(n105_I_1_0_0_0),
    .I_1_0_0_1(n105_I_1_0_0_1),
    .I_1_0_0_2(n105_I_1_0_0_2),
    .I_1_0_1_0(n105_I_1_0_1_0),
    .I_1_0_1_1(n105_I_1_0_1_1),
    .I_1_0_1_2(n105_I_1_0_1_2),
    .I_1_0_2_0(n105_I_1_0_2_0),
    .I_1_0_2_1(n105_I_1_0_2_1),
    .I_1_0_2_2(n105_I_1_0_2_2),
    .O_0_0_0(n105_O_0_0_0),
    .O_0_0_1(n105_O_0_0_1),
    .O_0_0_2(n105_O_0_0_2),
    .O_0_1_0(n105_O_0_1_0),
    .O_0_1_1(n105_O_0_1_1),
    .O_0_1_2(n105_O_0_1_2),
    .O_0_2_0(n105_O_0_2_0),
    .O_0_2_1(n105_O_0_2_1),
    .O_0_2_2(n105_O_0_2_2),
    .O_1_0_0(n105_O_1_0_0),
    .O_1_0_1(n105_O_1_0_1),
    .O_1_0_2(n105_O_1_0_2),
    .O_1_1_0(n105_O_1_1_0),
    .O_1_1_1(n105_O_1_1_1),
    .O_1_1_2(n105_O_1_1_2),
    .O_1_2_0(n105_O_1_2_0),
    .O_1_2_1(n105_O_1_2_1),
    .O_1_2_2(n105_O_1_2_2)
  );
  MapT_8 n147 ( // @[Top.scala 128:22]
    .clock(n147_clock),
    .reset(n147_reset),
    .valid_up(n147_valid_up),
    .valid_down(n147_valid_down),
    .I_0_0_0(n147_I_0_0_0),
    .I_0_0_1(n147_I_0_0_1),
    .I_0_0_2(n147_I_0_0_2),
    .I_0_1_0(n147_I_0_1_0),
    .I_0_1_1(n147_I_0_1_1),
    .I_0_1_2(n147_I_0_1_2),
    .I_0_2_0(n147_I_0_2_0),
    .I_0_2_1(n147_I_0_2_1),
    .I_0_2_2(n147_I_0_2_2),
    .I_1_0_0(n147_I_1_0_0),
    .I_1_0_1(n147_I_1_0_1),
    .I_1_0_2(n147_I_1_0_2),
    .I_1_1_0(n147_I_1_1_0),
    .I_1_1_1(n147_I_1_1_1),
    .I_1_1_2(n147_I_1_1_2),
    .I_1_2_0(n147_I_1_2_0),
    .I_1_2_1(n147_I_1_2_1),
    .I_1_2_2(n147_I_1_2_2),
    .O_0_0_0(n147_O_0_0_0),
    .O_1_0_0(n147_O_1_0_0)
  );
  Passthrough n148 ( // @[Top.scala 131:22]
    .valid_up(n148_valid_up),
    .valid_down(n148_valid_down),
    .I_0_0_0(n148_I_0_0_0),
    .I_1_0_0(n148_I_1_0_0),
    .O_0_0(n148_O_0_0),
    .O_1_0(n148_O_1_0)
  );
  Passthrough_1 n149 ( // @[Top.scala 134:22]
    .valid_up(n149_valid_up),
    .valid_down(n149_valid_down),
    .I_0_0(n149_I_0_0),
    .I_1_0(n149_I_1_0),
    .O_0(n149_O_0),
    .O_1(n149_O_1)
  );
  FIFO n150 ( // @[Top.scala 137:22]
    .clock(n150_clock),
    .reset(n150_reset),
    .valid_up(n150_valid_up),
    .valid_down(n150_valid_down),
    .I_0(n150_I_0),
    .I_1(n150_I_1),
    .O_0(n150_O_0),
    .O_1(n150_O_1)
  );
  FIFO n151 ( // @[Top.scala 140:22]
    .clock(n151_clock),
    .reset(n151_reset),
    .valid_up(n151_valid_up),
    .valid_down(n151_valid_down),
    .I_0(n151_I_0),
    .I_1(n151_I_1),
    .O_0(n151_O_0),
    .O_1(n151_O_1)
  );
  FIFO n152 ( // @[Top.scala 143:22]
    .clock(n152_clock),
    .reset(n152_reset),
    .valid_up(n152_valid_up),
    .valid_down(n152_valid_down),
    .I_0(n152_I_0),
    .I_1(n152_I_1),
    .O_0(n152_O_0),
    .O_1(n152_O_1)
  );
  assign valid_down = n152_valid_down; // @[Top.scala 147:16]
  assign O_0 = n152_O_0; // @[Top.scala 146:7]
  assign O_1 = n152_O_1; // @[Top.scala 146:7]
  assign n1_clock = clock;
  assign n1_reset = reset;
  assign n1_valid_up = valid_up; // @[Top.scala 47:17]
  assign n1_I_0 = I_0; // @[Top.scala 46:10]
  assign n1_I_1 = I_1; // @[Top.scala 46:10]
  assign n2_clock = clock;
  assign n2_reset = reset;
  assign n2_valid_up = n1_valid_down; // @[Top.scala 50:17]
  assign n2_I_0 = n1_O_0; // @[Top.scala 49:10]
  assign n2_I_1 = n1_O_1; // @[Top.scala 49:10]
  assign n3_clock = clock;
  assign n3_reset = reset;
  assign n3_valid_up = n2_valid_down; // @[Top.scala 53:17]
  assign n3_I_0 = n2_O_0; // @[Top.scala 52:10]
  assign n3_I_1 = n2_O_1; // @[Top.scala 52:10]
  assign n4_clock = clock;
  assign n4_valid_up = n3_valid_down; // @[Top.scala 56:17]
  assign n4_I_0 = n3_O_0; // @[Top.scala 55:10]
  assign n4_I_1 = n3_O_1; // @[Top.scala 55:10]
  assign n5_clock = clock;
  assign n5_valid_up = n4_valid_down; // @[Top.scala 59:17]
  assign n5_I_0 = n4_O_0; // @[Top.scala 58:10]
  assign n5_I_1 = n4_O_1; // @[Top.scala 58:10]
  assign n6_valid_up = n5_valid_down & n4_valid_down; // @[Top.scala 63:17]
  assign n6_I0_0 = n5_O_0; // @[Top.scala 61:11]
  assign n6_I0_1 = n5_O_1; // @[Top.scala 61:11]
  assign n6_I1_0 = n4_O_0; // @[Top.scala 62:11]
  assign n6_I1_1 = n4_O_1; // @[Top.scala 62:11]
  assign n13_valid_up = n6_valid_down & n3_valid_down; // @[Top.scala 67:18]
  assign n13_I0_0_0 = n6_O_0_0; // @[Top.scala 65:12]
  assign n13_I0_0_1 = n6_O_0_1; // @[Top.scala 65:12]
  assign n13_I0_1_0 = n6_O_1_0; // @[Top.scala 65:12]
  assign n13_I0_1_1 = n6_O_1_1; // @[Top.scala 65:12]
  assign n13_I1_0 = n3_O_0; // @[Top.scala 66:12]
  assign n13_I1_1 = n3_O_1; // @[Top.scala 66:12]
  assign n22_valid_up = n13_valid_down; // @[Top.scala 70:18]
  assign n22_I_0_0 = n13_O_0_0; // @[Top.scala 69:11]
  assign n22_I_0_1 = n13_O_0_1; // @[Top.scala 69:11]
  assign n22_I_0_2 = n13_O_0_2; // @[Top.scala 69:11]
  assign n22_I_1_0 = n13_O_1_0; // @[Top.scala 69:11]
  assign n22_I_1_1 = n13_O_1_1; // @[Top.scala 69:11]
  assign n22_I_1_2 = n13_O_1_2; // @[Top.scala 69:11]
  assign n29_valid_up = n22_valid_down; // @[Top.scala 73:18]
  assign n29_I_0_0_0 = n22_O_0_0_0; // @[Top.scala 72:11]
  assign n29_I_0_0_1 = n22_O_0_0_1; // @[Top.scala 72:11]
  assign n29_I_0_0_2 = n22_O_0_0_2; // @[Top.scala 72:11]
  assign n29_I_1_0_0 = n22_O_1_0_0; // @[Top.scala 72:11]
  assign n29_I_1_0_1 = n22_O_1_0_1; // @[Top.scala 72:11]
  assign n29_I_1_0_2 = n22_O_1_0_2; // @[Top.scala 72:11]
  assign n30_clock = clock;
  assign n30_valid_up = n2_valid_down; // @[Top.scala 76:18]
  assign n30_I_0 = n2_O_0; // @[Top.scala 75:11]
  assign n30_I_1 = n2_O_1; // @[Top.scala 75:11]
  assign n31_clock = clock;
  assign n31_valid_up = n30_valid_down; // @[Top.scala 79:18]
  assign n31_I_0 = n30_O_0; // @[Top.scala 78:11]
  assign n31_I_1 = n30_O_1; // @[Top.scala 78:11]
  assign n32_valid_up = n31_valid_down & n30_valid_down; // @[Top.scala 83:18]
  assign n32_I0_0 = n31_O_0; // @[Top.scala 81:12]
  assign n32_I0_1 = n31_O_1; // @[Top.scala 81:12]
  assign n32_I1_0 = n30_O_0; // @[Top.scala 82:12]
  assign n32_I1_1 = n30_O_1; // @[Top.scala 82:12]
  assign n39_valid_up = n32_valid_down & n2_valid_down; // @[Top.scala 87:18]
  assign n39_I0_0_0 = n32_O_0_0; // @[Top.scala 85:12]
  assign n39_I0_0_1 = n32_O_0_1; // @[Top.scala 85:12]
  assign n39_I0_1_0 = n32_O_1_0; // @[Top.scala 85:12]
  assign n39_I0_1_1 = n32_O_1_1; // @[Top.scala 85:12]
  assign n39_I1_0 = n2_O_0; // @[Top.scala 86:12]
  assign n39_I1_1 = n2_O_1; // @[Top.scala 86:12]
  assign n48_valid_up = n39_valid_down; // @[Top.scala 90:18]
  assign n48_I_0_0 = n39_O_0_0; // @[Top.scala 89:11]
  assign n48_I_0_1 = n39_O_0_1; // @[Top.scala 89:11]
  assign n48_I_0_2 = n39_O_0_2; // @[Top.scala 89:11]
  assign n48_I_1_0 = n39_O_1_0; // @[Top.scala 89:11]
  assign n48_I_1_1 = n39_O_1_1; // @[Top.scala 89:11]
  assign n48_I_1_2 = n39_O_1_2; // @[Top.scala 89:11]
  assign n55_valid_up = n48_valid_down; // @[Top.scala 93:18]
  assign n55_I_0_0_0 = n48_O_0_0_0; // @[Top.scala 92:11]
  assign n55_I_0_0_1 = n48_O_0_0_1; // @[Top.scala 92:11]
  assign n55_I_0_0_2 = n48_O_0_0_2; // @[Top.scala 92:11]
  assign n55_I_1_0_0 = n48_O_1_0_0; // @[Top.scala 92:11]
  assign n55_I_1_0_1 = n48_O_1_0_1; // @[Top.scala 92:11]
  assign n55_I_1_0_2 = n48_O_1_0_2; // @[Top.scala 92:11]
  assign n56_valid_up = n29_valid_down & n55_valid_down; // @[Top.scala 97:18]
  assign n56_I0_0_0 = n29_O_0_0; // @[Top.scala 95:12]
  assign n56_I0_0_1 = n29_O_0_1; // @[Top.scala 95:12]
  assign n56_I0_0_2 = n29_O_0_2; // @[Top.scala 95:12]
  assign n56_I0_1_0 = n29_O_1_0; // @[Top.scala 95:12]
  assign n56_I0_1_1 = n29_O_1_1; // @[Top.scala 95:12]
  assign n56_I0_1_2 = n29_O_1_2; // @[Top.scala 95:12]
  assign n56_I1_0_0 = n55_O_0_0; // @[Top.scala 96:12]
  assign n56_I1_0_1 = n55_O_0_1; // @[Top.scala 96:12]
  assign n56_I1_0_2 = n55_O_0_2; // @[Top.scala 96:12]
  assign n56_I1_1_0 = n55_O_1_0; // @[Top.scala 96:12]
  assign n56_I1_1_1 = n55_O_1_1; // @[Top.scala 96:12]
  assign n56_I1_1_2 = n55_O_1_2; // @[Top.scala 96:12]
  assign n63_clock = clock;
  assign n63_valid_up = n1_valid_down; // @[Top.scala 100:18]
  assign n63_I_0 = n1_O_0; // @[Top.scala 99:11]
  assign n63_I_1 = n1_O_1; // @[Top.scala 99:11]
  assign n64_clock = clock;
  assign n64_valid_up = n63_valid_down; // @[Top.scala 103:18]
  assign n64_I_0 = n63_O_0; // @[Top.scala 102:11]
  assign n64_I_1 = n63_O_1; // @[Top.scala 102:11]
  assign n65_valid_up = n64_valid_down & n63_valid_down; // @[Top.scala 107:18]
  assign n65_I0_0 = n64_O_0; // @[Top.scala 105:12]
  assign n65_I0_1 = n64_O_1; // @[Top.scala 105:12]
  assign n65_I1_0 = n63_O_0; // @[Top.scala 106:12]
  assign n65_I1_1 = n63_O_1; // @[Top.scala 106:12]
  assign n72_valid_up = n65_valid_down & n1_valid_down; // @[Top.scala 111:18]
  assign n72_I0_0_0 = n65_O_0_0; // @[Top.scala 109:12]
  assign n72_I0_0_1 = n65_O_0_1; // @[Top.scala 109:12]
  assign n72_I0_1_0 = n65_O_1_0; // @[Top.scala 109:12]
  assign n72_I0_1_1 = n65_O_1_1; // @[Top.scala 109:12]
  assign n72_I1_0 = n1_O_0; // @[Top.scala 110:12]
  assign n72_I1_1 = n1_O_1; // @[Top.scala 110:12]
  assign n81_valid_up = n72_valid_down; // @[Top.scala 114:18]
  assign n81_I_0_0 = n72_O_0_0; // @[Top.scala 113:11]
  assign n81_I_0_1 = n72_O_0_1; // @[Top.scala 113:11]
  assign n81_I_0_2 = n72_O_0_2; // @[Top.scala 113:11]
  assign n81_I_1_0 = n72_O_1_0; // @[Top.scala 113:11]
  assign n81_I_1_1 = n72_O_1_1; // @[Top.scala 113:11]
  assign n81_I_1_2 = n72_O_1_2; // @[Top.scala 113:11]
  assign n88_valid_up = n81_valid_down; // @[Top.scala 117:18]
  assign n88_I_0_0_0 = n81_O_0_0_0; // @[Top.scala 116:11]
  assign n88_I_0_0_1 = n81_O_0_0_1; // @[Top.scala 116:11]
  assign n88_I_0_0_2 = n81_O_0_0_2; // @[Top.scala 116:11]
  assign n88_I_1_0_0 = n81_O_1_0_0; // @[Top.scala 116:11]
  assign n88_I_1_0_1 = n81_O_1_0_1; // @[Top.scala 116:11]
  assign n88_I_1_0_2 = n81_O_1_0_2; // @[Top.scala 116:11]
  assign n89_valid_up = n56_valid_down & n88_valid_down; // @[Top.scala 121:18]
  assign n89_I0_0_0_0 = n56_O_0_0_0; // @[Top.scala 119:12]
  assign n89_I0_0_0_1 = n56_O_0_0_1; // @[Top.scala 119:12]
  assign n89_I0_0_0_2 = n56_O_0_0_2; // @[Top.scala 119:12]
  assign n89_I0_0_1_0 = n56_O_0_1_0; // @[Top.scala 119:12]
  assign n89_I0_0_1_1 = n56_O_0_1_1; // @[Top.scala 119:12]
  assign n89_I0_0_1_2 = n56_O_0_1_2; // @[Top.scala 119:12]
  assign n89_I0_1_0_0 = n56_O_1_0_0; // @[Top.scala 119:12]
  assign n89_I0_1_0_1 = n56_O_1_0_1; // @[Top.scala 119:12]
  assign n89_I0_1_0_2 = n56_O_1_0_2; // @[Top.scala 119:12]
  assign n89_I0_1_1_0 = n56_O_1_1_0; // @[Top.scala 119:12]
  assign n89_I0_1_1_1 = n56_O_1_1_1; // @[Top.scala 119:12]
  assign n89_I0_1_1_2 = n56_O_1_1_2; // @[Top.scala 119:12]
  assign n89_I1_0_0 = n88_O_0_0; // @[Top.scala 120:12]
  assign n89_I1_0_1 = n88_O_0_1; // @[Top.scala 120:12]
  assign n89_I1_0_2 = n88_O_0_2; // @[Top.scala 120:12]
  assign n89_I1_1_0 = n88_O_1_0; // @[Top.scala 120:12]
  assign n89_I1_1_1 = n88_O_1_1; // @[Top.scala 120:12]
  assign n89_I1_1_2 = n88_O_1_2; // @[Top.scala 120:12]
  assign n98_valid_up = n89_valid_down; // @[Top.scala 124:18]
  assign n98_I_0_0_0 = n89_O_0_0_0; // @[Top.scala 123:11]
  assign n98_I_0_0_1 = n89_O_0_0_1; // @[Top.scala 123:11]
  assign n98_I_0_0_2 = n89_O_0_0_2; // @[Top.scala 123:11]
  assign n98_I_0_1_0 = n89_O_0_1_0; // @[Top.scala 123:11]
  assign n98_I_0_1_1 = n89_O_0_1_1; // @[Top.scala 123:11]
  assign n98_I_0_1_2 = n89_O_0_1_2; // @[Top.scala 123:11]
  assign n98_I_0_2_0 = n89_O_0_2_0; // @[Top.scala 123:11]
  assign n98_I_0_2_1 = n89_O_0_2_1; // @[Top.scala 123:11]
  assign n98_I_0_2_2 = n89_O_0_2_2; // @[Top.scala 123:11]
  assign n98_I_1_0_0 = n89_O_1_0_0; // @[Top.scala 123:11]
  assign n98_I_1_0_1 = n89_O_1_0_1; // @[Top.scala 123:11]
  assign n98_I_1_0_2 = n89_O_1_0_2; // @[Top.scala 123:11]
  assign n98_I_1_1_0 = n89_O_1_1_0; // @[Top.scala 123:11]
  assign n98_I_1_1_1 = n89_O_1_1_1; // @[Top.scala 123:11]
  assign n98_I_1_1_2 = n89_O_1_1_2; // @[Top.scala 123:11]
  assign n98_I_1_2_0 = n89_O_1_2_0; // @[Top.scala 123:11]
  assign n98_I_1_2_1 = n89_O_1_2_1; // @[Top.scala 123:11]
  assign n98_I_1_2_2 = n89_O_1_2_2; // @[Top.scala 123:11]
  assign n105_valid_up = n98_valid_down; // @[Top.scala 127:19]
  assign n105_I_0_0_0_0 = n98_O_0_0_0_0; // @[Top.scala 126:12]
  assign n105_I_0_0_0_1 = n98_O_0_0_0_1; // @[Top.scala 126:12]
  assign n105_I_0_0_0_2 = n98_O_0_0_0_2; // @[Top.scala 126:12]
  assign n105_I_0_0_1_0 = n98_O_0_0_1_0; // @[Top.scala 126:12]
  assign n105_I_0_0_1_1 = n98_O_0_0_1_1; // @[Top.scala 126:12]
  assign n105_I_0_0_1_2 = n98_O_0_0_1_2; // @[Top.scala 126:12]
  assign n105_I_0_0_2_0 = n98_O_0_0_2_0; // @[Top.scala 126:12]
  assign n105_I_0_0_2_1 = n98_O_0_0_2_1; // @[Top.scala 126:12]
  assign n105_I_0_0_2_2 = n98_O_0_0_2_2; // @[Top.scala 126:12]
  assign n105_I_1_0_0_0 = n98_O_1_0_0_0; // @[Top.scala 126:12]
  assign n105_I_1_0_0_1 = n98_O_1_0_0_1; // @[Top.scala 126:12]
  assign n105_I_1_0_0_2 = n98_O_1_0_0_2; // @[Top.scala 126:12]
  assign n105_I_1_0_1_0 = n98_O_1_0_1_0; // @[Top.scala 126:12]
  assign n105_I_1_0_1_1 = n98_O_1_0_1_1; // @[Top.scala 126:12]
  assign n105_I_1_0_1_2 = n98_O_1_0_1_2; // @[Top.scala 126:12]
  assign n105_I_1_0_2_0 = n98_O_1_0_2_0; // @[Top.scala 126:12]
  assign n105_I_1_0_2_1 = n98_O_1_0_2_1; // @[Top.scala 126:12]
  assign n105_I_1_0_2_2 = n98_O_1_0_2_2; // @[Top.scala 126:12]
  assign n147_clock = clock;
  assign n147_reset = reset;
  assign n147_valid_up = n105_valid_down; // @[Top.scala 130:19]
  assign n147_I_0_0_0 = n105_O_0_0_0; // @[Top.scala 129:12]
  assign n147_I_0_0_1 = n105_O_0_0_1; // @[Top.scala 129:12]
  assign n147_I_0_0_2 = n105_O_0_0_2; // @[Top.scala 129:12]
  assign n147_I_0_1_0 = n105_O_0_1_0; // @[Top.scala 129:12]
  assign n147_I_0_1_1 = n105_O_0_1_1; // @[Top.scala 129:12]
  assign n147_I_0_1_2 = n105_O_0_1_2; // @[Top.scala 129:12]
  assign n147_I_0_2_0 = n105_O_0_2_0; // @[Top.scala 129:12]
  assign n147_I_0_2_1 = n105_O_0_2_1; // @[Top.scala 129:12]
  assign n147_I_0_2_2 = n105_O_0_2_2; // @[Top.scala 129:12]
  assign n147_I_1_0_0 = n105_O_1_0_0; // @[Top.scala 129:12]
  assign n147_I_1_0_1 = n105_O_1_0_1; // @[Top.scala 129:12]
  assign n147_I_1_0_2 = n105_O_1_0_2; // @[Top.scala 129:12]
  assign n147_I_1_1_0 = n105_O_1_1_0; // @[Top.scala 129:12]
  assign n147_I_1_1_1 = n105_O_1_1_1; // @[Top.scala 129:12]
  assign n147_I_1_1_2 = n105_O_1_1_2; // @[Top.scala 129:12]
  assign n147_I_1_2_0 = n105_O_1_2_0; // @[Top.scala 129:12]
  assign n147_I_1_2_1 = n105_O_1_2_1; // @[Top.scala 129:12]
  assign n147_I_1_2_2 = n105_O_1_2_2; // @[Top.scala 129:12]
  assign n148_valid_up = n147_valid_down; // @[Top.scala 133:19]
  assign n148_I_0_0_0 = n147_O_0_0_0; // @[Top.scala 132:12]
  assign n148_I_1_0_0 = n147_O_1_0_0; // @[Top.scala 132:12]
  assign n149_valid_up = n148_valid_down; // @[Top.scala 136:19]
  assign n149_I_0_0 = n148_O_0_0; // @[Top.scala 135:12]
  assign n149_I_1_0 = n148_O_1_0; // @[Top.scala 135:12]
  assign n150_clock = clock;
  assign n150_reset = reset;
  assign n150_valid_up = n149_valid_down; // @[Top.scala 139:19]
  assign n150_I_0 = n149_O_0; // @[Top.scala 138:12]
  assign n150_I_1 = n149_O_1; // @[Top.scala 138:12]
  assign n151_clock = clock;
  assign n151_reset = reset;
  assign n151_valid_up = n150_valid_down; // @[Top.scala 142:19]
  assign n151_I_0 = n150_O_0; // @[Top.scala 141:12]
  assign n151_I_1 = n150_O_1; // @[Top.scala 141:12]
  assign n152_clock = clock;
  assign n152_reset = reset;
  assign n152_valid_up = n151_valid_down; // @[Top.scala 145:19]
  assign n152_I_0 = n151_O_0; // @[Top.scala 144:12]
  assign n152_I_1 = n151_O_1; // @[Top.scala 144:12]
endmodule
