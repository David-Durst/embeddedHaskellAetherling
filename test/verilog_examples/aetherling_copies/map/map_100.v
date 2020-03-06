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
  output [7:0] O_t0b
);
  assign valid_down = valid_up; // @[Tuple.scala 51:14]
  assign O_t0b = I0; // @[Tuple.scala 49:9]
endmodule
module Add(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_t0b,
  output [7:0] O
);
  assign valid_down = valid_up; // @[Arithmetic.scala 108:14]
  assign O = I_t0b + 8'h5; // @[Arithmetic.scala 106:7]
endmodule
module Module_0(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I,
  output [7:0] O
);
  wire  InitialDelayCounter_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_valid_down; // @[Const.scala 11:33]
  wire  n6_valid_up; // @[Top.scala 16:20]
  wire  n6_valid_down; // @[Top.scala 16:20]
  wire [7:0] n6_I0; // @[Top.scala 16:20]
  wire [7:0] n6_O_t0b; // @[Top.scala 16:20]
  wire  n7_valid_up; // @[Top.scala 20:20]
  wire  n7_valid_down; // @[Top.scala 20:20]
  wire [7:0] n7_I_t0b; // @[Top.scala 20:20]
  wire [7:0] n7_O; // @[Top.scala 20:20]
  InitialDelayCounter InitialDelayCounter ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_clock),
    .reset(InitialDelayCounter_reset),
    .valid_down(InitialDelayCounter_valid_down)
  );
  AtomTuple n6 ( // @[Top.scala 16:20]
    .valid_up(n6_valid_up),
    .valid_down(n6_valid_down),
    .I0(n6_I0),
    .O_t0b(n6_O_t0b)
  );
  Add n7 ( // @[Top.scala 20:20]
    .valid_up(n7_valid_up),
    .valid_down(n7_valid_down),
    .I_t0b(n7_I_t0b),
    .O(n7_O)
  );
  assign valid_down = n7_valid_down; // @[Top.scala 24:16]
  assign O = n7_O; // @[Top.scala 23:7]
  assign InitialDelayCounter_clock = clock;
  assign InitialDelayCounter_reset = reset;
  assign n6_valid_up = valid_up & InitialDelayCounter_valid_down; // @[Top.scala 19:17]
  assign n6_I0 = I; // @[Top.scala 17:11]
  assign n7_valid_up = n6_valid_down; // @[Top.scala 22:17]
  assign n7_I_t0b = n6_O_t0b; // @[Top.scala 21:10]
endmodule
module MapS(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  output [7:0] O_0,
  output [7:0] O_1
);
  wire  fst_op_clock; // @[MapS.scala 9:22]
  wire  fst_op_reset; // @[MapS.scala 9:22]
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O; // @[MapS.scala 9:22]
  wire  other_ops_0_clock; // @[MapS.scala 10:86]
  wire  other_ops_0_reset; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O; // @[MapS.scala 10:86]
  Module_0 fst_op ( // @[MapS.scala 9:22]
    .clock(fst_op_clock),
    .reset(fst_op_reset),
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I(fst_op_I),
    .O(fst_op_O)
  );
  Module_0 other_ops_0 ( // @[MapS.scala 10:86]
    .clock(other_ops_0_clock),
    .reset(other_ops_0_reset),
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I(other_ops_0_I),
    .O(other_ops_0_O)
  );
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[MapS.scala 23:14]
  assign O_0 = fst_op_O; // @[MapS.scala 17:8]
  assign O_1 = other_ops_0_O; // @[MapS.scala 21:12]
  assign fst_op_clock = clock;
  assign fst_op_reset = reset;
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I = I_0; // @[MapS.scala 16:12]
  assign other_ops_0_clock = clock; // @[MapS.scala 10:86]
  assign other_ops_0_reset = reset; // @[MapS.scala 10:86]
  assign other_ops_0_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_0_I = I_1; // @[MapS.scala 20:41]
endmodule
module MapT(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  output [7:0] O_0,
  output [7:0] O_1
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1; // @[MapT.scala 8:20]
  MapS op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0(op_I_0),
    .I_1(op_I_1),
    .O_0(op_O_0),
    .O_1(op_O_1)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0 = op_O_0; // @[MapT.scala 15:7]
  assign O_1 = op_O_1; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0 = I_0; // @[MapT.scala 14:10]
  assign op_I_1 = I_1; // @[MapT.scala 14:10]
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
  wire  n1_clock; // @[Top.scala 30:20]
  wire  n1_reset; // @[Top.scala 30:20]
  wire  n1_valid_up; // @[Top.scala 30:20]
  wire  n1_valid_down; // @[Top.scala 30:20]
  wire [7:0] n1_I_0; // @[Top.scala 30:20]
  wire [7:0] n1_I_1; // @[Top.scala 30:20]
  wire [7:0] n1_O_0; // @[Top.scala 30:20]
  wire [7:0] n1_O_1; // @[Top.scala 30:20]
  wire  n9_clock; // @[Top.scala 33:20]
  wire  n9_reset; // @[Top.scala 33:20]
  wire  n9_valid_up; // @[Top.scala 33:20]
  wire  n9_valid_down; // @[Top.scala 33:20]
  wire [7:0] n9_I_0; // @[Top.scala 33:20]
  wire [7:0] n9_I_1; // @[Top.scala 33:20]
  wire [7:0] n9_O_0; // @[Top.scala 33:20]
  wire [7:0] n9_O_1; // @[Top.scala 33:20]
  wire  n10_clock; // @[Top.scala 36:21]
  wire  n10_reset; // @[Top.scala 36:21]
  wire  n10_valid_up; // @[Top.scala 36:21]
  wire  n10_valid_down; // @[Top.scala 36:21]
  wire [7:0] n10_I_0; // @[Top.scala 36:21]
  wire [7:0] n10_I_1; // @[Top.scala 36:21]
  wire [7:0] n10_O_0; // @[Top.scala 36:21]
  wire [7:0] n10_O_1; // @[Top.scala 36:21]
  wire  n11_clock; // @[Top.scala 39:21]
  wire  n11_reset; // @[Top.scala 39:21]
  wire  n11_valid_up; // @[Top.scala 39:21]
  wire  n11_valid_down; // @[Top.scala 39:21]
  wire [7:0] n11_I_0; // @[Top.scala 39:21]
  wire [7:0] n11_I_1; // @[Top.scala 39:21]
  wire [7:0] n11_O_0; // @[Top.scala 39:21]
  wire [7:0] n11_O_1; // @[Top.scala 39:21]
  wire  n12_clock; // @[Top.scala 42:21]
  wire  n12_reset; // @[Top.scala 42:21]
  wire  n12_valid_up; // @[Top.scala 42:21]
  wire  n12_valid_down; // @[Top.scala 42:21]
  wire [7:0] n12_I_0; // @[Top.scala 42:21]
  wire [7:0] n12_I_1; // @[Top.scala 42:21]
  wire [7:0] n12_O_0; // @[Top.scala 42:21]
  wire [7:0] n12_O_1; // @[Top.scala 42:21]
  FIFO n1 ( // @[Top.scala 30:20]
    .clock(n1_clock),
    .reset(n1_reset),
    .valid_up(n1_valid_up),
    .valid_down(n1_valid_down),
    .I_0(n1_I_0),
    .I_1(n1_I_1),
    .O_0(n1_O_0),
    .O_1(n1_O_1)
  );
  MapT n9 ( // @[Top.scala 33:20]
    .clock(n9_clock),
    .reset(n9_reset),
    .valid_up(n9_valid_up),
    .valid_down(n9_valid_down),
    .I_0(n9_I_0),
    .I_1(n9_I_1),
    .O_0(n9_O_0),
    .O_1(n9_O_1)
  );
  FIFO n10 ( // @[Top.scala 36:21]
    .clock(n10_clock),
    .reset(n10_reset),
    .valid_up(n10_valid_up),
    .valid_down(n10_valid_down),
    .I_0(n10_I_0),
    .I_1(n10_I_1),
    .O_0(n10_O_0),
    .O_1(n10_O_1)
  );
  FIFO n11 ( // @[Top.scala 39:21]
    .clock(n11_clock),
    .reset(n11_reset),
    .valid_up(n11_valid_up),
    .valid_down(n11_valid_down),
    .I_0(n11_I_0),
    .I_1(n11_I_1),
    .O_0(n11_O_0),
    .O_1(n11_O_1)
  );
  FIFO n12 ( // @[Top.scala 42:21]
    .clock(n12_clock),
    .reset(n12_reset),
    .valid_up(n12_valid_up),
    .valid_down(n12_valid_down),
    .I_0(n12_I_0),
    .I_1(n12_I_1),
    .O_0(n12_O_0),
    .O_1(n12_O_1)
  );
  assign valid_down = n12_valid_down; // @[Top.scala 46:16]
  assign O_0 = n12_O_0; // @[Top.scala 45:7]
  assign O_1 = n12_O_1; // @[Top.scala 45:7]
  assign n1_clock = clock;
  assign n1_reset = reset;
  assign n1_valid_up = valid_up; // @[Top.scala 32:17]
  assign n1_I_0 = I_0; // @[Top.scala 31:10]
  assign n1_I_1 = I_1; // @[Top.scala 31:10]
  assign n9_clock = clock;
  assign n9_reset = reset;
  assign n9_valid_up = n1_valid_down; // @[Top.scala 35:17]
  assign n9_I_0 = n1_O_0; // @[Top.scala 34:10]
  assign n9_I_1 = n1_O_1; // @[Top.scala 34:10]
  assign n10_clock = clock;
  assign n10_reset = reset;
  assign n10_valid_up = n9_valid_down; // @[Top.scala 38:18]
  assign n10_I_0 = n9_O_0; // @[Top.scala 37:11]
  assign n10_I_1 = n9_O_1; // @[Top.scala 37:11]
  assign n11_clock = clock;
  assign n11_reset = reset;
  assign n11_valid_up = n10_valid_down; // @[Top.scala 41:18]
  assign n11_I_0 = n10_O_0; // @[Top.scala 40:11]
  assign n11_I_1 = n10_O_1; // @[Top.scala 40:11]
  assign n12_clock = clock;
  assign n12_reset = reset;
  assign n12_valid_up = n11_valid_down; // @[Top.scala 44:18]
  assign n12_I_0 = n11_O_0; // @[Top.scala 43:11]
  assign n12_I_1 = n11_O_1; // @[Top.scala 43:11]
endmodule
