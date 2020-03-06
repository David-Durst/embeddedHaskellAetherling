module FIFO(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  output [7:0] O_0
);
  reg [7:0] _T_0; // @[FIFO.scala 13:26]
  reg [31:0] _RAND_0;
  reg  _T_1; // @[FIFO.scala 15:27]
  reg [31:0] _RAND_1;
  assign valid_down = _T_1; // @[FIFO.scala 16:16]
  assign O_0 = _T_0; // @[FIFO.scala 14:7]
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
    _T_0 <= I_0;
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
module NestedCounters_1(
  input   CE,
  output  valid
);
  wire  NestedCounters_CE; // @[NestedCounters.scala 53:31]
  wire  NestedCounters_valid; // @[NestedCounters.scala 53:31]
  NestedCounters NestedCounters ( // @[NestedCounters.scala 53:31]
    .CE(NestedCounters_CE),
    .valid(NestedCounters_valid)
  );
  assign valid = NestedCounters_valid; // @[NestedCounters.scala 56:11]
  assign NestedCounters_CE = CE; // @[NestedCounters.scala 57:22]
endmodule
module NestedCountersWithNumValid(
  input   CE,
  output  valid
);
  wire  NestedCounters_CE; // @[NestedCounters.scala 20:44]
  wire  NestedCounters_valid; // @[NestedCounters.scala 20:44]
  NestedCounters_1 NestedCounters ( // @[NestedCounters.scala 20:44]
    .CE(NestedCounters_CE),
    .valid(NestedCounters_valid)
  );
  assign valid = NestedCounters_valid; // @[NestedCounters.scala 22:9]
  assign NestedCounters_CE = CE; // @[NestedCounters.scala 21:27]
endmodule
module RAM_ST(
  input        clock,
  input        RE,
  input  [1:0] RADDR,
  output [7:0] RDATA_0,
  input        WE,
  input  [1:0] WADDR,
  input  [7:0] WDATA_0
);
  wire  write_elem_counter_CE; // @[RAM_ST.scala 20:34]
  wire  write_elem_counter_valid; // @[RAM_ST.scala 20:34]
  wire  read_elem_counter_CE; // @[RAM_ST.scala 21:33]
  wire  read_elem_counter_valid; // @[RAM_ST.scala 21:33]
  reg [7:0] ram_0 [0:3]; // @[RAM_ST.scala 29:24]
  reg [31:0] _RAND_0;
  wire [7:0] ram_0__T_8_data; // @[RAM_ST.scala 29:24]
  wire [1:0] ram_0__T_8_addr; // @[RAM_ST.scala 29:24]
  wire [7:0] ram_0__T_2_data; // @[RAM_ST.scala 29:24]
  wire [1:0] ram_0__T_2_addr; // @[RAM_ST.scala 29:24]
  wire  ram_0__T_2_mask; // @[RAM_ST.scala 29:24]
  wire  ram_0__T_2_en; // @[RAM_ST.scala 29:24]
  reg  ram_0__T_8_en_pipe_0;
  reg [31:0] _RAND_1;
  reg [1:0] ram_0__T_8_addr_pipe_0;
  reg [31:0] _RAND_2;
  wire [1:0] _GEN_1; // @[RAM_ST.scala 31:71]
  wire [1:0] _GEN_2; // @[RAM_ST.scala 31:71]
  wire [1:0] _GEN_3; // @[RAM_ST.scala 31:71]
  wire [2:0] _T; // @[RAM_ST.scala 31:71]
  wire [1:0] _GEN_10; // @[RAM_ST.scala 32:46]
  wire [1:0] _GEN_11; // @[RAM_ST.scala 32:46]
  wire [1:0] _GEN_12; // @[RAM_ST.scala 32:46]
  wire [2:0] _T_3; // @[RAM_ST.scala 32:46]
  NestedCountersWithNumValid write_elem_counter ( // @[RAM_ST.scala 20:34]
    .CE(write_elem_counter_CE),
    .valid(write_elem_counter_valid)
  );
  NestedCountersWithNumValid read_elem_counter ( // @[RAM_ST.scala 21:33]
    .CE(read_elem_counter_CE),
    .valid(read_elem_counter_valid)
  );
  assign ram_0__T_8_addr = ram_0__T_8_addr_pipe_0;
  assign ram_0__T_8_data = ram_0[ram_0__T_8_addr]; // @[RAM_ST.scala 29:24]
  assign ram_0__T_2_data = WDATA_0;
  assign ram_0__T_2_addr = _T[1:0];
  assign ram_0__T_2_mask = 1'h1;
  assign ram_0__T_2_en = write_elem_counter_valid;
  assign _GEN_1 = 2'h1 == WADDR ? 2'h1 : 2'h0; // @[RAM_ST.scala 31:71]
  assign _GEN_2 = 2'h2 == WADDR ? 2'h2 : _GEN_1; // @[RAM_ST.scala 31:71]
  assign _GEN_3 = 2'h3 == WADDR ? 2'h3 : _GEN_2; // @[RAM_ST.scala 31:71]
  assign _T = {{1'd0}, _GEN_3}; // @[RAM_ST.scala 31:71]
  assign _GEN_10 = 2'h1 == RADDR ? 2'h1 : 2'h0; // @[RAM_ST.scala 32:46]
  assign _GEN_11 = 2'h2 == RADDR ? 2'h2 : _GEN_10; // @[RAM_ST.scala 32:46]
  assign _GEN_12 = 2'h3 == RADDR ? 2'h3 : _GEN_11; // @[RAM_ST.scala 32:46]
  assign _T_3 = {{1'd0}, _GEN_12}; // @[RAM_ST.scala 32:46]
  assign RDATA_0 = ram_0__T_8_data; // @[RAM_ST.scala 32:9]
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
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    ram_0[initvar] = _RAND_0[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  ram_0__T_8_en_pipe_0 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  ram_0__T_8_addr_pipe_0 = _RAND_2[1:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(ram_0__T_2_en & ram_0__T_2_mask) begin
      ram_0[ram_0__T_2_addr] <= ram_0__T_2_data; // @[RAM_ST.scala 29:24]
    end
    ram_0__T_8_en_pipe_0 <= read_elem_counter_valid;
    if (read_elem_counter_valid) begin
      ram_0__T_8_addr_pipe_0 <= _T_3[1:0];
    end
  end
endmodule
module ShiftT(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  output [7:0] O_0
);
  wire  RAM_ST_clock; // @[ShiftT.scala 39:29]
  wire  RAM_ST_RE; // @[ShiftT.scala 39:29]
  wire [1:0] RAM_ST_RADDR; // @[ShiftT.scala 39:29]
  wire [7:0] RAM_ST_RDATA_0; // @[ShiftT.scala 39:29]
  wire  RAM_ST_WE; // @[ShiftT.scala 39:29]
  wire [1:0] RAM_ST_WADDR; // @[ShiftT.scala 39:29]
  wire [7:0] RAM_ST_WDATA_0; // @[ShiftT.scala 39:29]
  wire  NestedCounters_CE; // @[ShiftT.scala 41:31]
  wire  NestedCounters_valid; // @[ShiftT.scala 41:31]
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[Counter.scala 37:24]
  wire [1:0] _T_3; // @[Counter.scala 38:22]
  RAM_ST RAM_ST ( // @[ShiftT.scala 39:29]
    .clock(RAM_ST_clock),
    .RE(RAM_ST_RE),
    .RADDR(RAM_ST_RADDR),
    .RDATA_0(RAM_ST_RDATA_0),
    .WE(RAM_ST_WE),
    .WADDR(RAM_ST_WADDR),
    .WDATA_0(RAM_ST_WDATA_0)
  );
  NestedCounters_1 NestedCounters ( // @[ShiftT.scala 41:31]
    .CE(NestedCounters_CE),
    .valid(NestedCounters_valid)
  );
  assign _T_1 = value == 2'h3; // @[Counter.scala 37:24]
  assign _T_3 = value + 2'h1; // @[Counter.scala 38:22]
  assign valid_down = valid_up; // @[ShiftT.scala 55:14]
  assign O_0 = RAM_ST_RDATA_0; // @[ShiftT.scala 51:7]
  assign RAM_ST_clock = clock;
  assign RAM_ST_RE = valid_up; // @[ShiftT.scala 49:20]
  assign RAM_ST_RADDR = _T_1 ? 2'h0 : _T_3; // @[ShiftT.scala 46:76 ShiftT.scala 47:38]
  assign RAM_ST_WE = valid_up; // @[ShiftT.scala 48:20]
  assign RAM_ST_WADDR = value; // @[ShiftT.scala 45:23]
  assign RAM_ST_WDATA_0 = I_0; // @[ShiftT.scala 50:23]
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
  value = _RAND_0[1:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      value <= 2'h0;
    end else if (valid_up) begin
      value <= _T_3;
    end
  end
endmodule
module ShiftT_2(
  input        clock,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  output [7:0] O_0
);
  reg [7:0] _T_0; // @[ShiftT.scala 24:82]
  reg [31:0] _RAND_0;
  assign valid_down = valid_up; // @[ShiftT.scala 55:14]
  assign O_0 = _T_0; // @[ShiftT.scala 24:7]
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
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    _T_0 <= I_0;
  end
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
  input  [7:0] I1_0,
  output [7:0] O_0_0,
  output [7:0] O_0_1
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1; // @[Map2S.scala 9:22]
  SSeqTupleCreator fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0(fst_op_I0),
    .I1(fst_op_I1),
    .O_0(fst_op_O_0),
    .O_1(fst_op_O_1)
  );
  assign valid_down = fst_op_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0 = fst_op_O_0; // @[Map2S.scala 19:8]
  assign O_0_1 = fst_op_O_1; // @[Map2S.scala 19:8]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0 = I0_0; // @[Map2S.scala 17:13]
  assign fst_op_I1 = I1_0; // @[Map2S.scala 18:13]
endmodule
module Map2T(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I1_0,
  output [7:0] O_0_0,
  output [7:0] O_0_1
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1; // @[Map2T.scala 8:20]
  Map2S op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0(op_I0_0),
    .I1_0(op_I1_0),
    .O_0_0(op_O_0_0),
    .O_0_1(op_O_0_1)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0_0 = op_O_0_0; // @[Map2T.scala 17:7]
  assign O_0_1 = op_O_0_1; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0 = I0_0; // @[Map2T.scala 15:11]
  assign op_I1_0 = I1_0; // @[Map2T.scala 16:11]
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
  input  [7:0] I1_0,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_2; // @[Map2S.scala 9:22]
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
  assign valid_down = fst_op_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0 = fst_op_O_0; // @[Map2S.scala 19:8]
  assign O_0_1 = fst_op_O_1; // @[Map2S.scala 19:8]
  assign O_0_2 = fst_op_O_2; // @[Map2S.scala 19:8]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0_0 = I0_0_0; // @[Map2S.scala 17:13]
  assign fst_op_I0_1 = I0_0_1; // @[Map2S.scala 17:13]
  assign fst_op_I1 = I1_0; // @[Map2S.scala 18:13]
endmodule
module Map2T_1(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I1_0,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_2; // @[Map2T.scala 8:20]
  Map2S_1 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0_0(op_I0_0_0),
    .I0_0_1(op_I0_0_1),
    .I1_0(op_I1_0),
    .O_0_0(op_O_0_0),
    .O_0_1(op_O_0_1),
    .O_0_2(op_O_0_2)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0_0 = op_O_0_0; // @[Map2T.scala 17:7]
  assign O_0_1 = op_O_0_1; // @[Map2T.scala 17:7]
  assign O_0_2 = op_O_0_2; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0_0 = I0_0_0; // @[Map2T.scala 15:11]
  assign op_I0_0_1 = I0_0_1; // @[Map2T.scala 15:11]
  assign op_I1_0 = I1_0; // @[Map2T.scala 16:11]
endmodule
module PartitionS(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_0_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2
);
  assign valid_down = valid_up; // @[Partition.scala 18:14]
  assign O_0_0_0 = I_0_0; // @[Partition.scala 15:39]
  assign O_0_0_1 = I_0_1; // @[Partition.scala 15:39]
  assign O_0_0_2 = I_0_2; // @[Partition.scala 15:39]
endmodule
module MapT(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_0_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_2; // @[MapT.scala 8:20]
  PartitionS op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0(op_I_0_0),
    .I_0_1(op_I_0_1),
    .I_0_2(op_I_0_2),
    .O_0_0_0(op_O_0_0_0),
    .O_0_0_1(op_O_0_0_1),
    .O_0_0_2(op_O_0_0_2)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0_0 = op_O_0_0_0; // @[MapT.scala 15:7]
  assign O_0_0_1 = op_O_0_0_1; // @[MapT.scala 15:7]
  assign O_0_0_2 = op_O_0_0_2; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0 = I_0_0; // @[MapT.scala 14:10]
  assign op_I_0_1 = I_0_1; // @[MapT.scala 14:10]
  assign op_I_0_2 = I_0_2; // @[MapT.scala 14:10]
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
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2
);
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_2; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_2; // @[MapS.scala 9:22]
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
  assign valid_down = fst_op_valid_down; // @[MapS.scala 23:14]
  assign O_0_0 = fst_op_O_0; // @[MapS.scala 17:8]
  assign O_0_1 = fst_op_O_1; // @[MapS.scala 17:8]
  assign O_0_2 = fst_op_O_2; // @[MapS.scala 17:8]
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_0_0 = I_0_0_0; // @[MapS.scala 16:12]
  assign fst_op_I_0_1 = I_0_0_1; // @[MapS.scala 16:12]
  assign fst_op_I_0_2 = I_0_0_2; // @[MapS.scala 16:12]
endmodule
module MapT_1(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  input  [7:0] I_0_0_2,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_0_2
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_2; // @[MapT.scala 8:20]
  MapS op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0_0(op_I_0_0_0),
    .I_0_0_1(op_I_0_0_1),
    .I_0_0_2(op_I_0_0_2),
    .O_0_0(op_O_0_0),
    .O_0_1(op_O_0_1),
    .O_0_2(op_O_0_2)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign O_0_1 = op_O_0_1; // @[MapT.scala 15:7]
  assign O_0_2 = op_O_0_2; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0_0 = I_0_0_0; // @[MapT.scala 14:10]
  assign op_I_0_0_1 = I_0_0_1; // @[MapT.scala 14:10]
  assign op_I_0_0_2 = I_0_0_2; // @[MapT.scala 14:10]
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
  input  [7:0] I1_0_0,
  input  [7:0] I1_0_1,
  input  [7:0] I1_0_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1,
  output [7:0] O_0_1_2
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
  assign valid_down = fst_op_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0_0 = fst_op_O_0_0; // @[Map2S.scala 19:8]
  assign O_0_0_1 = fst_op_O_0_1; // @[Map2S.scala 19:8]
  assign O_0_0_2 = fst_op_O_0_2; // @[Map2S.scala 19:8]
  assign O_0_1_0 = fst_op_O_1_0; // @[Map2S.scala 19:8]
  assign O_0_1_1 = fst_op_O_1_1; // @[Map2S.scala 19:8]
  assign O_0_1_2 = fst_op_O_1_2; // @[Map2S.scala 19:8]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0_0 = I0_0_0; // @[Map2S.scala 17:13]
  assign fst_op_I0_1 = I0_0_1; // @[Map2S.scala 17:13]
  assign fst_op_I0_2 = I0_0_2; // @[Map2S.scala 17:13]
  assign fst_op_I1_0 = I1_0_0; // @[Map2S.scala 18:13]
  assign fst_op_I1_1 = I1_0_1; // @[Map2S.scala 18:13]
  assign fst_op_I1_2 = I1_0_2; // @[Map2S.scala 18:13]
endmodule
module Map2T_4(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I0_0_2,
  input  [7:0] I1_0_0,
  input  [7:0] I1_0_1,
  input  [7:0] I1_0_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1,
  output [7:0] O_0_1_2
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_2; // @[Map2T.scala 8:20]
  Map2S_4 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0_0(op_I0_0_0),
    .I0_0_1(op_I0_0_1),
    .I0_0_2(op_I0_0_2),
    .I1_0_0(op_I1_0_0),
    .I1_0_1(op_I1_0_1),
    .I1_0_2(op_I1_0_2),
    .O_0_0_0(op_O_0_0_0),
    .O_0_0_1(op_O_0_0_1),
    .O_0_0_2(op_O_0_0_2),
    .O_0_1_0(op_O_0_1_0),
    .O_0_1_1(op_O_0_1_1),
    .O_0_1_2(op_O_0_1_2)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0_0_0 = op_O_0_0_0; // @[Map2T.scala 17:7]
  assign O_0_0_1 = op_O_0_0_1; // @[Map2T.scala 17:7]
  assign O_0_0_2 = op_O_0_0_2; // @[Map2T.scala 17:7]
  assign O_0_1_0 = op_O_0_1_0; // @[Map2T.scala 17:7]
  assign O_0_1_1 = op_O_0_1_1; // @[Map2T.scala 17:7]
  assign O_0_1_2 = op_O_0_1_2; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0_0 = I0_0_0; // @[Map2T.scala 15:11]
  assign op_I0_0_1 = I0_0_1; // @[Map2T.scala 15:11]
  assign op_I0_0_2 = I0_0_2; // @[Map2T.scala 15:11]
  assign op_I1_0_0 = I1_0_0; // @[Map2T.scala 16:11]
  assign op_I1_0_1 = I1_0_1; // @[Map2T.scala 16:11]
  assign op_I1_0_2 = I1_0_2; // @[Map2T.scala 16:11]
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
  input  [7:0] I1_0_0,
  input  [7:0] I1_0_1,
  input  [7:0] I1_0_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1,
  output [7:0] O_0_1_2,
  output [7:0] O_0_2_0,
  output [7:0] O_0_2_1,
  output [7:0] O_0_2_2
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
  assign valid_down = fst_op_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0_0 = fst_op_O_0_0; // @[Map2S.scala 19:8]
  assign O_0_0_1 = fst_op_O_0_1; // @[Map2S.scala 19:8]
  assign O_0_0_2 = fst_op_O_0_2; // @[Map2S.scala 19:8]
  assign O_0_1_0 = fst_op_O_1_0; // @[Map2S.scala 19:8]
  assign O_0_1_1 = fst_op_O_1_1; // @[Map2S.scala 19:8]
  assign O_0_1_2 = fst_op_O_1_2; // @[Map2S.scala 19:8]
  assign O_0_2_0 = fst_op_O_2_0; // @[Map2S.scala 19:8]
  assign O_0_2_1 = fst_op_O_2_1; // @[Map2S.scala 19:8]
  assign O_0_2_2 = fst_op_O_2_2; // @[Map2S.scala 19:8]
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
  input  [7:0] I1_0_0,
  input  [7:0] I1_0_1,
  input  [7:0] I1_0_2,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1,
  output [7:0] O_0_1_2,
  output [7:0] O_0_2_0,
  output [7:0] O_0_2_1,
  output [7:0] O_0_2_2
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_2_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_2_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_2_2; // @[Map2T.scala 8:20]
  Map2S_7 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0_0_0(op_I0_0_0_0),
    .I0_0_0_1(op_I0_0_0_1),
    .I0_0_0_2(op_I0_0_0_2),
    .I0_0_1_0(op_I0_0_1_0),
    .I0_0_1_1(op_I0_0_1_1),
    .I0_0_1_2(op_I0_0_1_2),
    .I1_0_0(op_I1_0_0),
    .I1_0_1(op_I1_0_1),
    .I1_0_2(op_I1_0_2),
    .O_0_0_0(op_O_0_0_0),
    .O_0_0_1(op_O_0_0_1),
    .O_0_0_2(op_O_0_0_2),
    .O_0_1_0(op_O_0_1_0),
    .O_0_1_1(op_O_0_1_1),
    .O_0_1_2(op_O_0_1_2),
    .O_0_2_0(op_O_0_2_0),
    .O_0_2_1(op_O_0_2_1),
    .O_0_2_2(op_O_0_2_2)
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
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0_0_0 = I0_0_0_0; // @[Map2T.scala 15:11]
  assign op_I0_0_0_1 = I0_0_0_1; // @[Map2T.scala 15:11]
  assign op_I0_0_0_2 = I0_0_0_2; // @[Map2T.scala 15:11]
  assign op_I0_0_1_0 = I0_0_1_0; // @[Map2T.scala 15:11]
  assign op_I0_0_1_1 = I0_0_1_1; // @[Map2T.scala 15:11]
  assign op_I0_0_1_2 = I0_0_1_2; // @[Map2T.scala 15:11]
  assign op_I1_0_0 = I1_0_0; // @[Map2T.scala 16:11]
  assign op_I1_0_1 = I1_0_1; // @[Map2T.scala 16:11]
  assign op_I1_0_2 = I1_0_2; // @[Map2T.scala 16:11]
endmodule
module Passthrough(
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
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_0_2,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1,
  output [7:0] O_0_1_2,
  output [7:0] O_0_2_0,
  output [7:0] O_0_2_1,
  output [7:0] O_0_2_2
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O_0_0_0 = I_0_0_0; // @[Passthrough.scala 17:68]
  assign O_0_0_1 = I_0_0_1; // @[Passthrough.scala 17:68]
  assign O_0_0_2 = I_0_0_2; // @[Passthrough.scala 17:68]
  assign O_0_1_0 = I_0_1_0; // @[Passthrough.scala 17:68]
  assign O_0_1_1 = I_0_1_1; // @[Passthrough.scala 17:68]
  assign O_0_1_2 = I_0_1_2; // @[Passthrough.scala 17:68]
  assign O_0_2_0 = I_0_2_0; // @[Passthrough.scala 17:68]
  assign O_0_2_1 = I_0_2_1; // @[Passthrough.scala 17:68]
  assign O_0_2_2 = I_0_2_2; // @[Passthrough.scala 17:68]
endmodule
module Passthrough_1(
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
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O_0_0 = I_0_0_0; // @[Passthrough.scala 17:68]
  assign O_0_1 = I_0_0_1; // @[Passthrough.scala 17:68]
  assign O_0_2 = I_0_0_2; // @[Passthrough.scala 17:68]
  assign O_1_0 = I_0_1_0; // @[Passthrough.scala 17:68]
  assign O_1_1 = I_0_1_1; // @[Passthrough.scala 17:68]
  assign O_1_2 = I_0_1_2; // @[Passthrough.scala 17:68]
  assign O_2_0 = I_0_2_0; // @[Passthrough.scala 17:68]
  assign O_2_1 = I_0_2_1; // @[Passthrough.scala 17:68]
  assign O_2_2 = I_0_2_2; // @[Passthrough.scala 17:68]
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
  wire [7:0] op_O_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_2_2; // @[MapT.scala 8:20]
  Passthrough_1 op ( // @[MapT.scala 8:20]
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
    .O_0_0(op_O_0_0),
    .O_0_1(op_O_0_1),
    .O_0_2(op_O_0_2),
    .O_1_0(op_O_1_0),
    .O_1_1(op_O_1_1),
    .O_1_2(op_O_1_2),
    .O_2_0(op_O_2_0),
    .O_2_1(op_O_2_1),
    .O_2_2(op_O_2_2)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign O_0_1 = op_O_0_1; // @[MapT.scala 15:7]
  assign O_0_2 = op_O_0_2; // @[MapT.scala 15:7]
  assign O_1_0 = op_O_1_0; // @[MapT.scala 15:7]
  assign O_1_1 = op_O_1_1; // @[MapT.scala 15:7]
  assign O_1_2 = op_O_1_2; // @[MapT.scala 15:7]
  assign O_2_0 = op_O_2_0; // @[MapT.scala 15:7]
  assign O_2_1 = op_O_2_1; // @[MapT.scala 15:7]
  assign O_2_2 = op_O_2_2; // @[MapT.scala 15:7]
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
module Map2T_8(
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
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_2; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_2_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_2_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_2_2; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_t1b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_t1b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_2_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_2_t1b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0_t1b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1_t1b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_2_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_2_t1b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_2_0_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_2_0_t1b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_2_1_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_2_1_t1b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_2_2_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_2_2_t1b; // @[Map2T.scala 8:20]
  Map2S_9 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0_0(op_I0_0_0),
    .I0_0_1(op_I0_0_1),
    .I0_0_2(op_I0_0_2),
    .I0_1_0(op_I0_1_0),
    .I0_1_1(op_I0_1_1),
    .I0_1_2(op_I0_1_2),
    .I0_2_0(op_I0_2_0),
    .I0_2_1(op_I0_2_1),
    .I0_2_2(op_I0_2_2),
    .O_0_0_t0b(op_O_0_0_t0b),
    .O_0_0_t1b(op_O_0_0_t1b),
    .O_0_1_t0b(op_O_0_1_t0b),
    .O_0_1_t1b(op_O_0_1_t1b),
    .O_0_2_t0b(op_O_0_2_t0b),
    .O_0_2_t1b(op_O_0_2_t1b),
    .O_1_0_t0b(op_O_1_0_t0b),
    .O_1_0_t1b(op_O_1_0_t1b),
    .O_1_1_t0b(op_O_1_1_t0b),
    .O_1_1_t1b(op_O_1_1_t1b),
    .O_1_2_t0b(op_O_1_2_t0b),
    .O_1_2_t1b(op_O_1_2_t1b),
    .O_2_0_t0b(op_O_2_0_t0b),
    .O_2_0_t1b(op_O_2_0_t1b),
    .O_2_1_t0b(op_O_2_1_t0b),
    .O_2_1_t1b(op_O_2_1_t1b),
    .O_2_2_t0b(op_O_2_2_t0b),
    .O_2_2_t1b(op_O_2_2_t1b)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0_0_t0b = op_O_0_0_t0b; // @[Map2T.scala 17:7]
  assign O_0_0_t1b = op_O_0_0_t1b; // @[Map2T.scala 17:7]
  assign O_0_1_t0b = op_O_0_1_t0b; // @[Map2T.scala 17:7]
  assign O_0_1_t1b = op_O_0_1_t1b; // @[Map2T.scala 17:7]
  assign O_0_2_t0b = op_O_0_2_t0b; // @[Map2T.scala 17:7]
  assign O_0_2_t1b = op_O_0_2_t1b; // @[Map2T.scala 17:7]
  assign O_1_0_t0b = op_O_1_0_t0b; // @[Map2T.scala 17:7]
  assign O_1_0_t1b = op_O_1_0_t1b; // @[Map2T.scala 17:7]
  assign O_1_1_t0b = op_O_1_1_t0b; // @[Map2T.scala 17:7]
  assign O_1_1_t1b = op_O_1_1_t1b; // @[Map2T.scala 17:7]
  assign O_1_2_t0b = op_O_1_2_t0b; // @[Map2T.scala 17:7]
  assign O_1_2_t1b = op_O_1_2_t1b; // @[Map2T.scala 17:7]
  assign O_2_0_t0b = op_O_2_0_t0b; // @[Map2T.scala 17:7]
  assign O_2_0_t1b = op_O_2_0_t1b; // @[Map2T.scala 17:7]
  assign O_2_1_t0b = op_O_2_1_t0b; // @[Map2T.scala 17:7]
  assign O_2_1_t1b = op_O_2_1_t1b; // @[Map2T.scala 17:7]
  assign O_2_2_t0b = op_O_2_2_t0b; // @[Map2T.scala 17:7]
  assign O_2_2_t1b = op_O_2_2_t1b; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0_0 = I0_0_0; // @[Map2T.scala 15:11]
  assign op_I0_0_1 = I0_0_1; // @[Map2T.scala 15:11]
  assign op_I0_0_2 = I0_0_2; // @[Map2T.scala 15:11]
  assign op_I0_1_0 = I0_1_0; // @[Map2T.scala 15:11]
  assign op_I0_1_1 = I0_1_1; // @[Map2T.scala 15:11]
  assign op_I0_1_2 = I0_1_2; // @[Map2T.scala 15:11]
  assign op_I0_2_0 = I0_2_0; // @[Map2T.scala 15:11]
  assign op_I0_2_1 = I0_2_1; // @[Map2T.scala 15:11]
  assign op_I0_2_2 = I0_2_2; // @[Map2T.scala 15:11]
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
module MapS_3(
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
module MapS_4(
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
  MapS_3 fst_op ( // @[MapS.scala 9:22]
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
  MapS_3 other_ops_0 ( // @[MapS.scala 10:86]
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
  MapS_3 other_ops_1 ( // @[MapS.scala 10:86]
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
module MapT_7(
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
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_2_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_2_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_0_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_0_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_1_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_1_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_2_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_2_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_2_2; // @[MapT.scala 8:20]
  MapS_4 op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0_t0b(op_I_0_0_t0b),
    .I_0_0_t1b(op_I_0_0_t1b),
    .I_0_1_t0b(op_I_0_1_t0b),
    .I_0_1_t1b(op_I_0_1_t1b),
    .I_0_2_t0b(op_I_0_2_t0b),
    .I_0_2_t1b(op_I_0_2_t1b),
    .I_1_0_t0b(op_I_1_0_t0b),
    .I_1_0_t1b(op_I_1_0_t1b),
    .I_1_1_t0b(op_I_1_1_t0b),
    .I_1_1_t1b(op_I_1_1_t1b),
    .I_1_2_t0b(op_I_1_2_t0b),
    .I_1_2_t1b(op_I_1_2_t1b),
    .I_2_0_t0b(op_I_2_0_t0b),
    .I_2_0_t1b(op_I_2_0_t1b),
    .I_2_1_t0b(op_I_2_1_t0b),
    .I_2_1_t1b(op_I_2_1_t1b),
    .I_2_2_t0b(op_I_2_2_t0b),
    .I_2_2_t1b(op_I_2_2_t1b),
    .O_0_0(op_O_0_0),
    .O_0_1(op_O_0_1),
    .O_0_2(op_O_0_2),
    .O_1_0(op_O_1_0),
    .O_1_1(op_O_1_1),
    .O_1_2(op_O_1_2),
    .O_2_0(op_O_2_0),
    .O_2_1(op_O_2_1),
    .O_2_2(op_O_2_2)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign O_0_1 = op_O_0_1; // @[MapT.scala 15:7]
  assign O_0_2 = op_O_0_2; // @[MapT.scala 15:7]
  assign O_1_0 = op_O_1_0; // @[MapT.scala 15:7]
  assign O_1_1 = op_O_1_1; // @[MapT.scala 15:7]
  assign O_1_2 = op_O_1_2; // @[MapT.scala 15:7]
  assign O_2_0 = op_O_2_0; // @[MapT.scala 15:7]
  assign O_2_1 = op_O_2_1; // @[MapT.scala 15:7]
  assign O_2_2 = op_O_2_2; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0_t0b = I_0_0_t0b; // @[MapT.scala 14:10]
  assign op_I_0_0_t1b = I_0_0_t1b; // @[MapT.scala 14:10]
  assign op_I_0_1_t0b = I_0_1_t0b; // @[MapT.scala 14:10]
  assign op_I_0_1_t1b = I_0_1_t1b; // @[MapT.scala 14:10]
  assign op_I_0_2_t0b = I_0_2_t0b; // @[MapT.scala 14:10]
  assign op_I_0_2_t1b = I_0_2_t1b; // @[MapT.scala 14:10]
  assign op_I_1_0_t0b = I_1_0_t0b; // @[MapT.scala 14:10]
  assign op_I_1_0_t1b = I_1_0_t1b; // @[MapT.scala 14:10]
  assign op_I_1_1_t0b = I_1_1_t0b; // @[MapT.scala 14:10]
  assign op_I_1_1_t1b = I_1_1_t1b; // @[MapT.scala 14:10]
  assign op_I_1_2_t0b = I_1_2_t0b; // @[MapT.scala 14:10]
  assign op_I_1_2_t1b = I_1_2_t1b; // @[MapT.scala 14:10]
  assign op_I_2_0_t0b = I_2_0_t0b; // @[MapT.scala 14:10]
  assign op_I_2_0_t1b = I_2_0_t1b; // @[MapT.scala 14:10]
  assign op_I_2_1_t0b = I_2_1_t0b; // @[MapT.scala 14:10]
  assign op_I_2_1_t1b = I_2_1_t1b; // @[MapT.scala 14:10]
  assign op_I_2_2_t0b = I_2_2_t0b; // @[MapT.scala 14:10]
  assign op_I_2_2_t1b = I_2_2_t1b; // @[MapT.scala 14:10]
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
  assign AddNoValid_I_t0b = I_0; // @[ReduceS.scala 43:18]
  assign AddNoValid_I_t1b = AddNoValid_1_O; // @[ReduceS.scala 36:18]
  assign AddNoValid_1_I_t0b = I_2; // @[ReduceS.scala 43:18]
  assign AddNoValid_1_I_t1b = I_1; // @[ReduceS.scala 43:18]
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
module MapS_5(
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
module MapT_8(
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
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_2_0; // @[MapT.scala 8:20]
  MapS_5 op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0(op_I_0_0),
    .I_0_1(op_I_0_1),
    .I_0_2(op_I_0_2),
    .I_1_0(op_I_1_0),
    .I_1_1(op_I_1_1),
    .I_1_2(op_I_1_2),
    .I_2_0(op_I_2_0),
    .I_2_1(op_I_2_1),
    .I_2_2(op_I_2_2),
    .O_0_0(op_O_0_0),
    .O_1_0(op_O_1_0),
    .O_2_0(op_O_2_0)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign O_1_0 = op_O_1_0; // @[MapT.scala 15:7]
  assign O_2_0 = op_O_2_0; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0 = I_0_0; // @[MapT.scala 14:10]
  assign op_I_0_1 = I_0_1; // @[MapT.scala 14:10]
  assign op_I_0_2 = I_0_2; // @[MapT.scala 14:10]
  assign op_I_1_0 = I_1_0; // @[MapT.scala 14:10]
  assign op_I_1_1 = I_1_1; // @[MapT.scala 14:10]
  assign op_I_1_2 = I_1_2; // @[MapT.scala 14:10]
  assign op_I_2_0 = I_2_0; // @[MapT.scala 14:10]
  assign op_I_2_1 = I_2_1; // @[MapT.scala 14:10]
  assign op_I_2_2 = I_2_2; // @[MapT.scala 14:10]
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
  assign MapSNoValid_1_I_0_t0b = I_1_0; // @[ReduceS.scala 43:18]
  assign MapSNoValid_1_I_0_t1b = I_2_0; // @[ReduceS.scala 43:18]
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
module MapT_9(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_1_0,
  input  [7:0] I_2_0,
  output [7:0] O_0_0
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0; // @[MapT.scala 8:20]
  ReduceS_1 op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0(op_I_0_0),
    .I_1_0(op_I_1_0),
    .I_2_0(op_I_2_0),
    .O_0_0(op_O_0_0)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0 = I_0_0; // @[MapT.scala 14:10]
  assign op_I_1_0 = I_1_0; // @[MapT.scala 14:10]
  assign op_I_2_0 = I_2_0; // @[MapT.scala 14:10]
endmodule
module ReduceT(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  output [7:0] O_0_0
);
  reg  _T; // @[ReduceT.scala 18:26]
  reg [31:0] _RAND_0;
  reg [7:0] _T_1_0_0; // @[ReduceT.scala 45:15]
  reg [31:0] _RAND_1;
  assign valid_down = _T; // @[ReduceT.scala 18:16]
  assign O_0_0 = _T_1_0_0; // @[ReduceT.scala 45:5]
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
  _T = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_1_0_0 = _RAND_1[7:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      _T <= 1'h0;
    end else begin
      _T <= valid_up;
    end
    _T_1_0_0 <= I_0_0;
  end
endmodule
module Passthrough_2(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  output [7:0] O_0
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O_0 = I_0_0; // @[Passthrough.scala 17:68]
endmodule
module InitialDelayCounter_1(
  input   clock,
  input   reset,
  output  valid_down
);
  reg [2:0] value; // @[InitialDelayCounter.scala 8:34]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[InitialDelayCounter.scala 17:17]
  wire [2:0] _T_4; // @[InitialDelayCounter.scala 17:53]
  assign _T_1 = value < 3'h4; // @[InitialDelayCounter.scala 17:17]
  assign _T_4 = value + 3'h1; // @[InitialDelayCounter.scala 17:53]
  assign valid_down = value == 3'h4; // @[InitialDelayCounter.scala 16:16]
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
  value = _RAND_0[2:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      value <= 3'h0;
    end else if (_T_1) begin
      value <= _T_4;
    end
  end
endmodule
module Map2S_10(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I1_0,
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
  assign fst_op_I1 = I1_0; // @[Map2S.scala 18:13]
endmodule
module Map2T_9(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I1_0,
  output [7:0] O_0_t0b,
  output [7:0] O_0_t1b
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_t1b; // @[Map2T.scala 8:20]
  Map2S_10 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0(op_I0_0),
    .I1_0(op_I1_0),
    .O_0_t0b(op_O_0_t0b),
    .O_0_t1b(op_O_0_t1b)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0_t0b = op_O_0_t0b; // @[Map2T.scala 17:7]
  assign O_0_t1b = op_O_0_t1b; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0 = I0_0; // @[Map2T.scala 15:11]
  assign op_I1_0 = I1_0; // @[Map2T.scala 16:11]
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
module MapS_6(
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
module MapT_10(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_t0b,
  input  [7:0] I_0_t1b,
  output [7:0] O_0
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_O_0; // @[MapT.scala 8:20]
  MapS_6 op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_t0b(op_I_0_t0b),
    .I_0_t1b(op_I_0_t1b),
    .O_0(op_O_0)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0 = op_O_0; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_t0b = I_0_t0b; // @[MapT.scala 14:10]
  assign op_I_0_t1b = I_0_t1b; // @[MapT.scala 14:10]
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
  output [7:0] O_0
);
  wire  InitialDelayCounter_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_valid_down; // @[Const.scala 11:33]
  wire  n103_valid_up; // @[Top.scala 16:22]
  wire  n103_valid_down; // @[Top.scala 16:22]
  wire [7:0] n103_I0_0_0; // @[Top.scala 16:22]
  wire [7:0] n103_I0_0_1; // @[Top.scala 16:22]
  wire [7:0] n103_I0_0_2; // @[Top.scala 16:22]
  wire [7:0] n103_I0_1_0; // @[Top.scala 16:22]
  wire [7:0] n103_I0_1_1; // @[Top.scala 16:22]
  wire [7:0] n103_I0_1_2; // @[Top.scala 16:22]
  wire [7:0] n103_I0_2_0; // @[Top.scala 16:22]
  wire [7:0] n103_I0_2_1; // @[Top.scala 16:22]
  wire [7:0] n103_I0_2_2; // @[Top.scala 16:22]
  wire [7:0] n103_O_0_0_t0b; // @[Top.scala 16:22]
  wire [7:0] n103_O_0_0_t1b; // @[Top.scala 16:22]
  wire [7:0] n103_O_0_1_t0b; // @[Top.scala 16:22]
  wire [7:0] n103_O_0_1_t1b; // @[Top.scala 16:22]
  wire [7:0] n103_O_0_2_t0b; // @[Top.scala 16:22]
  wire [7:0] n103_O_0_2_t1b; // @[Top.scala 16:22]
  wire [7:0] n103_O_1_0_t0b; // @[Top.scala 16:22]
  wire [7:0] n103_O_1_0_t1b; // @[Top.scala 16:22]
  wire [7:0] n103_O_1_1_t0b; // @[Top.scala 16:22]
  wire [7:0] n103_O_1_1_t1b; // @[Top.scala 16:22]
  wire [7:0] n103_O_1_2_t0b; // @[Top.scala 16:22]
  wire [7:0] n103_O_1_2_t1b; // @[Top.scala 16:22]
  wire [7:0] n103_O_2_0_t0b; // @[Top.scala 16:22]
  wire [7:0] n103_O_2_0_t1b; // @[Top.scala 16:22]
  wire [7:0] n103_O_2_1_t0b; // @[Top.scala 16:22]
  wire [7:0] n103_O_2_1_t1b; // @[Top.scala 16:22]
  wire [7:0] n103_O_2_2_t0b; // @[Top.scala 16:22]
  wire [7:0] n103_O_2_2_t1b; // @[Top.scala 16:22]
  wire  n119_valid_up; // @[Top.scala 20:22]
  wire  n119_valid_down; // @[Top.scala 20:22]
  wire [7:0] n119_I_0_0_t0b; // @[Top.scala 20:22]
  wire [7:0] n119_I_0_0_t1b; // @[Top.scala 20:22]
  wire [7:0] n119_I_0_1_t0b; // @[Top.scala 20:22]
  wire [7:0] n119_I_0_1_t1b; // @[Top.scala 20:22]
  wire [7:0] n119_I_0_2_t0b; // @[Top.scala 20:22]
  wire [7:0] n119_I_0_2_t1b; // @[Top.scala 20:22]
  wire [7:0] n119_I_1_0_t0b; // @[Top.scala 20:22]
  wire [7:0] n119_I_1_0_t1b; // @[Top.scala 20:22]
  wire [7:0] n119_I_1_1_t0b; // @[Top.scala 20:22]
  wire [7:0] n119_I_1_1_t1b; // @[Top.scala 20:22]
  wire [7:0] n119_I_1_2_t0b; // @[Top.scala 20:22]
  wire [7:0] n119_I_1_2_t1b; // @[Top.scala 20:22]
  wire [7:0] n119_I_2_0_t0b; // @[Top.scala 20:22]
  wire [7:0] n119_I_2_0_t1b; // @[Top.scala 20:22]
  wire [7:0] n119_I_2_1_t0b; // @[Top.scala 20:22]
  wire [7:0] n119_I_2_1_t1b; // @[Top.scala 20:22]
  wire [7:0] n119_I_2_2_t0b; // @[Top.scala 20:22]
  wire [7:0] n119_I_2_2_t1b; // @[Top.scala 20:22]
  wire [7:0] n119_O_0_0; // @[Top.scala 20:22]
  wire [7:0] n119_O_0_1; // @[Top.scala 20:22]
  wire [7:0] n119_O_0_2; // @[Top.scala 20:22]
  wire [7:0] n119_O_1_0; // @[Top.scala 20:22]
  wire [7:0] n119_O_1_1; // @[Top.scala 20:22]
  wire [7:0] n119_O_1_2; // @[Top.scala 20:22]
  wire [7:0] n119_O_2_0; // @[Top.scala 20:22]
  wire [7:0] n119_O_2_1; // @[Top.scala 20:22]
  wire [7:0] n119_O_2_2; // @[Top.scala 20:22]
  wire  n126_clock; // @[Top.scala 23:22]
  wire  n126_reset; // @[Top.scala 23:22]
  wire  n126_valid_up; // @[Top.scala 23:22]
  wire  n126_valid_down; // @[Top.scala 23:22]
  wire [7:0] n126_I_0_0; // @[Top.scala 23:22]
  wire [7:0] n126_I_0_1; // @[Top.scala 23:22]
  wire [7:0] n126_I_0_2; // @[Top.scala 23:22]
  wire [7:0] n126_I_1_0; // @[Top.scala 23:22]
  wire [7:0] n126_I_1_1; // @[Top.scala 23:22]
  wire [7:0] n126_I_1_2; // @[Top.scala 23:22]
  wire [7:0] n126_I_2_0; // @[Top.scala 23:22]
  wire [7:0] n126_I_2_1; // @[Top.scala 23:22]
  wire [7:0] n126_I_2_2; // @[Top.scala 23:22]
  wire [7:0] n126_O_0_0; // @[Top.scala 23:22]
  wire [7:0] n126_O_1_0; // @[Top.scala 23:22]
  wire [7:0] n126_O_2_0; // @[Top.scala 23:22]
  wire  n133_clock; // @[Top.scala 26:22]
  wire  n133_reset; // @[Top.scala 26:22]
  wire  n133_valid_up; // @[Top.scala 26:22]
  wire  n133_valid_down; // @[Top.scala 26:22]
  wire [7:0] n133_I_0_0; // @[Top.scala 26:22]
  wire [7:0] n133_I_1_0; // @[Top.scala 26:22]
  wire [7:0] n133_I_2_0; // @[Top.scala 26:22]
  wire [7:0] n133_O_0_0; // @[Top.scala 26:22]
  wire  n136_clock; // @[Top.scala 29:22]
  wire  n136_reset; // @[Top.scala 29:22]
  wire  n136_valid_up; // @[Top.scala 29:22]
  wire  n136_valid_down; // @[Top.scala 29:22]
  wire [7:0] n136_I_0_0; // @[Top.scala 29:22]
  wire [7:0] n136_O_0_0; // @[Top.scala 29:22]
  wire  n137_valid_up; // @[Top.scala 32:22]
  wire  n137_valid_down; // @[Top.scala 32:22]
  wire [7:0] n137_I_0_0; // @[Top.scala 32:22]
  wire [7:0] n137_O_0; // @[Top.scala 32:22]
  wire  InitialDelayCounter_1_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_valid_down; // @[Const.scala 11:33]
  wire  n140_valid_up; // @[Top.scala 36:22]
  wire  n140_valid_down; // @[Top.scala 36:22]
  wire [7:0] n140_I0_0; // @[Top.scala 36:22]
  wire [7:0] n140_I1_0; // @[Top.scala 36:22]
  wire [7:0] n140_O_0_t0b; // @[Top.scala 36:22]
  wire [7:0] n140_O_0_t1b; // @[Top.scala 36:22]
  wire  n151_valid_up; // @[Top.scala 40:22]
  wire  n151_valid_down; // @[Top.scala 40:22]
  wire [7:0] n151_I_0_t0b; // @[Top.scala 40:22]
  wire [7:0] n151_I_0_t1b; // @[Top.scala 40:22]
  wire [7:0] n151_O_0; // @[Top.scala 40:22]
  InitialDelayCounter InitialDelayCounter ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_clock),
    .reset(InitialDelayCounter_reset),
    .valid_down(InitialDelayCounter_valid_down)
  );
  Map2T_8 n103 ( // @[Top.scala 16:22]
    .valid_up(n103_valid_up),
    .valid_down(n103_valid_down),
    .I0_0_0(n103_I0_0_0),
    .I0_0_1(n103_I0_0_1),
    .I0_0_2(n103_I0_0_2),
    .I0_1_0(n103_I0_1_0),
    .I0_1_1(n103_I0_1_1),
    .I0_1_2(n103_I0_1_2),
    .I0_2_0(n103_I0_2_0),
    .I0_2_1(n103_I0_2_1),
    .I0_2_2(n103_I0_2_2),
    .O_0_0_t0b(n103_O_0_0_t0b),
    .O_0_0_t1b(n103_O_0_0_t1b),
    .O_0_1_t0b(n103_O_0_1_t0b),
    .O_0_1_t1b(n103_O_0_1_t1b),
    .O_0_2_t0b(n103_O_0_2_t0b),
    .O_0_2_t1b(n103_O_0_2_t1b),
    .O_1_0_t0b(n103_O_1_0_t0b),
    .O_1_0_t1b(n103_O_1_0_t1b),
    .O_1_1_t0b(n103_O_1_1_t0b),
    .O_1_1_t1b(n103_O_1_1_t1b),
    .O_1_2_t0b(n103_O_1_2_t0b),
    .O_1_2_t1b(n103_O_1_2_t1b),
    .O_2_0_t0b(n103_O_2_0_t0b),
    .O_2_0_t1b(n103_O_2_0_t1b),
    .O_2_1_t0b(n103_O_2_1_t0b),
    .O_2_1_t1b(n103_O_2_1_t1b),
    .O_2_2_t0b(n103_O_2_2_t0b),
    .O_2_2_t1b(n103_O_2_2_t1b)
  );
  MapT_7 n119 ( // @[Top.scala 20:22]
    .valid_up(n119_valid_up),
    .valid_down(n119_valid_down),
    .I_0_0_t0b(n119_I_0_0_t0b),
    .I_0_0_t1b(n119_I_0_0_t1b),
    .I_0_1_t0b(n119_I_0_1_t0b),
    .I_0_1_t1b(n119_I_0_1_t1b),
    .I_0_2_t0b(n119_I_0_2_t0b),
    .I_0_2_t1b(n119_I_0_2_t1b),
    .I_1_0_t0b(n119_I_1_0_t0b),
    .I_1_0_t1b(n119_I_1_0_t1b),
    .I_1_1_t0b(n119_I_1_1_t0b),
    .I_1_1_t1b(n119_I_1_1_t1b),
    .I_1_2_t0b(n119_I_1_2_t0b),
    .I_1_2_t1b(n119_I_1_2_t1b),
    .I_2_0_t0b(n119_I_2_0_t0b),
    .I_2_0_t1b(n119_I_2_0_t1b),
    .I_2_1_t0b(n119_I_2_1_t0b),
    .I_2_1_t1b(n119_I_2_1_t1b),
    .I_2_2_t0b(n119_I_2_2_t0b),
    .I_2_2_t1b(n119_I_2_2_t1b),
    .O_0_0(n119_O_0_0),
    .O_0_1(n119_O_0_1),
    .O_0_2(n119_O_0_2),
    .O_1_0(n119_O_1_0),
    .O_1_1(n119_O_1_1),
    .O_1_2(n119_O_1_2),
    .O_2_0(n119_O_2_0),
    .O_2_1(n119_O_2_1),
    .O_2_2(n119_O_2_2)
  );
  MapT_8 n126 ( // @[Top.scala 23:22]
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
  MapT_9 n133 ( // @[Top.scala 26:22]
    .clock(n133_clock),
    .reset(n133_reset),
    .valid_up(n133_valid_up),
    .valid_down(n133_valid_down),
    .I_0_0(n133_I_0_0),
    .I_1_0(n133_I_1_0),
    .I_2_0(n133_I_2_0),
    .O_0_0(n133_O_0_0)
  );
  ReduceT n136 ( // @[Top.scala 29:22]
    .clock(n136_clock),
    .reset(n136_reset),
    .valid_up(n136_valid_up),
    .valid_down(n136_valid_down),
    .I_0_0(n136_I_0_0),
    .O_0_0(n136_O_0_0)
  );
  Passthrough_2 n137 ( // @[Top.scala 32:22]
    .valid_up(n137_valid_up),
    .valid_down(n137_valid_down),
    .I_0_0(n137_I_0_0),
    .O_0(n137_O_0)
  );
  InitialDelayCounter_1 InitialDelayCounter_1 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_1_clock),
    .reset(InitialDelayCounter_1_reset),
    .valid_down(InitialDelayCounter_1_valid_down)
  );
  Map2T_9 n140 ( // @[Top.scala 36:22]
    .valid_up(n140_valid_up),
    .valid_down(n140_valid_down),
    .I0_0(n140_I0_0),
    .I1_0(n140_I1_0),
    .O_0_t0b(n140_O_0_t0b),
    .O_0_t1b(n140_O_0_t1b)
  );
  MapT_10 n151 ( // @[Top.scala 40:22]
    .valid_up(n151_valid_up),
    .valid_down(n151_valid_down),
    .I_0_t0b(n151_I_0_t0b),
    .I_0_t1b(n151_I_0_t1b),
    .O_0(n151_O_0)
  );
  assign valid_down = n151_valid_down; // @[Top.scala 44:16]
  assign O_0 = n151_O_0; // @[Top.scala 43:7]
  assign InitialDelayCounter_clock = clock;
  assign InitialDelayCounter_reset = reset;
  assign n103_valid_up = valid_up & InitialDelayCounter_valid_down; // @[Top.scala 19:19]
  assign n103_I0_0_0 = I_0_0; // @[Top.scala 17:13]
  assign n103_I0_0_1 = I_0_1; // @[Top.scala 17:13]
  assign n103_I0_0_2 = I_0_2; // @[Top.scala 17:13]
  assign n103_I0_1_0 = I_1_0; // @[Top.scala 17:13]
  assign n103_I0_1_1 = I_1_1; // @[Top.scala 17:13]
  assign n103_I0_1_2 = I_1_2; // @[Top.scala 17:13]
  assign n103_I0_2_0 = I_2_0; // @[Top.scala 17:13]
  assign n103_I0_2_1 = I_2_1; // @[Top.scala 17:13]
  assign n103_I0_2_2 = I_2_2; // @[Top.scala 17:13]
  assign n119_valid_up = n103_valid_down; // @[Top.scala 22:19]
  assign n119_I_0_0_t0b = n103_O_0_0_t0b; // @[Top.scala 21:12]
  assign n119_I_0_0_t1b = n103_O_0_0_t1b; // @[Top.scala 21:12]
  assign n119_I_0_1_t0b = n103_O_0_1_t0b; // @[Top.scala 21:12]
  assign n119_I_0_1_t1b = n103_O_0_1_t1b; // @[Top.scala 21:12]
  assign n119_I_0_2_t0b = n103_O_0_2_t0b; // @[Top.scala 21:12]
  assign n119_I_0_2_t1b = n103_O_0_2_t1b; // @[Top.scala 21:12]
  assign n119_I_1_0_t0b = n103_O_1_0_t0b; // @[Top.scala 21:12]
  assign n119_I_1_0_t1b = n103_O_1_0_t1b; // @[Top.scala 21:12]
  assign n119_I_1_1_t0b = n103_O_1_1_t0b; // @[Top.scala 21:12]
  assign n119_I_1_1_t1b = n103_O_1_1_t1b; // @[Top.scala 21:12]
  assign n119_I_1_2_t0b = n103_O_1_2_t0b; // @[Top.scala 21:12]
  assign n119_I_1_2_t1b = n103_O_1_2_t1b; // @[Top.scala 21:12]
  assign n119_I_2_0_t0b = n103_O_2_0_t0b; // @[Top.scala 21:12]
  assign n119_I_2_0_t1b = n103_O_2_0_t1b; // @[Top.scala 21:12]
  assign n119_I_2_1_t0b = n103_O_2_1_t0b; // @[Top.scala 21:12]
  assign n119_I_2_1_t1b = n103_O_2_1_t1b; // @[Top.scala 21:12]
  assign n119_I_2_2_t0b = n103_O_2_2_t0b; // @[Top.scala 21:12]
  assign n119_I_2_2_t1b = n103_O_2_2_t1b; // @[Top.scala 21:12]
  assign n126_clock = clock;
  assign n126_reset = reset;
  assign n126_valid_up = n119_valid_down; // @[Top.scala 25:19]
  assign n126_I_0_0 = n119_O_0_0; // @[Top.scala 24:12]
  assign n126_I_0_1 = n119_O_0_1; // @[Top.scala 24:12]
  assign n126_I_0_2 = n119_O_0_2; // @[Top.scala 24:12]
  assign n126_I_1_0 = n119_O_1_0; // @[Top.scala 24:12]
  assign n126_I_1_1 = n119_O_1_1; // @[Top.scala 24:12]
  assign n126_I_1_2 = n119_O_1_2; // @[Top.scala 24:12]
  assign n126_I_2_0 = n119_O_2_0; // @[Top.scala 24:12]
  assign n126_I_2_1 = n119_O_2_1; // @[Top.scala 24:12]
  assign n126_I_2_2 = n119_O_2_2; // @[Top.scala 24:12]
  assign n133_clock = clock;
  assign n133_reset = reset;
  assign n133_valid_up = n126_valid_down; // @[Top.scala 28:19]
  assign n133_I_0_0 = n126_O_0_0; // @[Top.scala 27:12]
  assign n133_I_1_0 = n126_O_1_0; // @[Top.scala 27:12]
  assign n133_I_2_0 = n126_O_2_0; // @[Top.scala 27:12]
  assign n136_clock = clock;
  assign n136_reset = reset;
  assign n136_valid_up = n133_valid_down; // @[Top.scala 31:19]
  assign n136_I_0_0 = n133_O_0_0; // @[Top.scala 30:12]
  assign n137_valid_up = n136_valid_down; // @[Top.scala 34:19]
  assign n137_I_0_0 = n136_O_0_0; // @[Top.scala 33:12]
  assign InitialDelayCounter_1_clock = clock;
  assign InitialDelayCounter_1_reset = reset;
  assign n140_valid_up = n137_valid_down & InitialDelayCounter_1_valid_down; // @[Top.scala 39:19]
  assign n140_I0_0 = n137_O_0; // @[Top.scala 37:13]
  assign n140_I1_0 = 8'h4; // @[Top.scala 38:13]
  assign n151_valid_up = n140_valid_down; // @[Top.scala 42:19]
  assign n151_I_0_t0b = n140_O_0_t0b; // @[Top.scala 41:12]
  assign n151_I_0_t1b = n140_O_0_t1b; // @[Top.scala 41:12]
endmodule
module MapT_11(
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
  output [7:0] O_0
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_2; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_2_2; // @[MapT.scala 8:20]
  wire [7:0] op_O_0; // @[MapT.scala 8:20]
  Module_0 op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0(op_I_0_0),
    .I_0_1(op_I_0_1),
    .I_0_2(op_I_0_2),
    .I_1_0(op_I_1_0),
    .I_1_1(op_I_1_1),
    .I_1_2(op_I_1_2),
    .I_2_0(op_I_2_0),
    .I_2_1(op_I_2_1),
    .I_2_2(op_I_2_2),
    .O_0(op_O_0)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0 = op_O_0; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0 = I_0_0; // @[MapT.scala 14:10]
  assign op_I_0_1 = I_0_1; // @[MapT.scala 14:10]
  assign op_I_0_2 = I_0_2; // @[MapT.scala 14:10]
  assign op_I_1_0 = I_1_0; // @[MapT.scala 14:10]
  assign op_I_1_1 = I_1_1; // @[MapT.scala 14:10]
  assign op_I_1_2 = I_1_2; // @[MapT.scala 14:10]
  assign op_I_2_0 = I_2_0; // @[MapT.scala 14:10]
  assign op_I_2_1 = I_2_1; // @[MapT.scala 14:10]
  assign op_I_2_2 = I_2_2; // @[MapT.scala 14:10]
endmodule
module Passthrough_3(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  output [7:0] O_0
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O_0 = I_0; // @[Passthrough.scala 17:68]
endmodule
module PartitionS_3(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1
);
  assign valid_down = valid_up; // @[Partition.scala 18:14]
  assign O_0_0_0 = I_0_0; // @[Partition.scala 15:39]
  assign O_0_0_1 = I_0_1; // @[Partition.scala 15:39]
endmodule
module MapT_12(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0_1; // @[MapT.scala 8:20]
  PartitionS_3 op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0(op_I_0_0),
    .I_0_1(op_I_0_1),
    .O_0_0_0(op_O_0_0_0),
    .O_0_0_1(op_O_0_0_1)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0_0 = op_O_0_0_0; // @[MapT.scala 15:7]
  assign O_0_0_1 = op_O_0_0_1; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0 = I_0_0; // @[MapT.scala 14:10]
  assign op_I_0_1 = I_0_1; // @[MapT.scala 14:10]
endmodule
module SSeqTupleToSSeq_3(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  output [7:0] O_0,
  output [7:0] O_1
);
  assign valid_down = valid_up; // @[Tuple.scala 42:14]
  assign O_0 = I_0; // @[Tuple.scala 41:5]
  assign O_1 = I_1; // @[Tuple.scala 41:5]
endmodule
module Remove1S_3(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  output [7:0] O_0,
  output [7:0] O_1
);
  wire  op_inst_valid_up; // @[Remove1S.scala 9:23]
  wire  op_inst_valid_down; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_1; // @[Remove1S.scala 9:23]
  SSeqTupleToSSeq_3 op_inst ( // @[Remove1S.scala 9:23]
    .valid_up(op_inst_valid_up),
    .valid_down(op_inst_valid_down),
    .I_0(op_inst_I_0),
    .I_1(op_inst_I_1),
    .O_0(op_inst_O_0),
    .O_1(op_inst_O_1)
  );
  assign valid_down = op_inst_valid_down; // @[Remove1S.scala 16:14]
  assign O_0 = op_inst_O_0; // @[Remove1S.scala 14:5]
  assign O_1 = op_inst_O_1; // @[Remove1S.scala 14:5]
  assign op_inst_valid_up = valid_up; // @[Remove1S.scala 15:20]
  assign op_inst_I_0 = I_0_0; // @[Remove1S.scala 13:13]
  assign op_inst_I_1 = I_0_1; // @[Remove1S.scala 13:13]
endmodule
module MapS_7(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  output [7:0] O_0_0,
  output [7:0] O_0_1
);
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_1; // @[MapS.scala 9:22]
  Remove1S_3 fst_op ( // @[MapS.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_0_0(fst_op_I_0_0),
    .I_0_1(fst_op_I_0_1),
    .O_0(fst_op_O_0),
    .O_1(fst_op_O_1)
  );
  assign valid_down = fst_op_valid_down; // @[MapS.scala 23:14]
  assign O_0_0 = fst_op_O_0; // @[MapS.scala 17:8]
  assign O_0_1 = fst_op_O_1; // @[MapS.scala 17:8]
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_0_0 = I_0_0_0; // @[MapS.scala 16:12]
  assign fst_op_I_0_1 = I_0_0_1; // @[MapS.scala 16:12]
endmodule
module MapT_13(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  output [7:0] O_0_0,
  output [7:0] O_0_1
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_1; // @[MapT.scala 8:20]
  MapS_7 op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0_0(op_I_0_0_0),
    .I_0_0_1(op_I_0_0_1),
    .O_0_0(op_O_0_0),
    .O_0_1(op_O_0_1)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign O_0_1 = op_O_0_1; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0_0 = I_0_0_0; // @[MapT.scala 14:10]
  assign op_I_0_0_1 = I_0_0_1; // @[MapT.scala 14:10]
endmodule
module SSeqTupleCreator_6(
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
  assign valid_down = valid_up; // @[Tuple.scala 15:14]
  assign O_0_0 = I0_0; // @[Tuple.scala 12:32]
  assign O_0_1 = I0_1; // @[Tuple.scala 12:32]
  assign O_1_0 = I1_0; // @[Tuple.scala 13:32]
  assign O_1_1 = I1_1; // @[Tuple.scala 13:32]
endmodule
module Map2S_13(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I1_0_0,
  input  [7:0] I1_0_1,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_1; // @[Map2S.scala 9:22]
  SSeqTupleCreator_6 fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0_0(fst_op_I0_0),
    .I0_1(fst_op_I0_1),
    .I1_0(fst_op_I1_0),
    .I1_1(fst_op_I1_1),
    .O_0_0(fst_op_O_0_0),
    .O_0_1(fst_op_O_0_1),
    .O_1_0(fst_op_O_1_0),
    .O_1_1(fst_op_O_1_1)
  );
  assign valid_down = fst_op_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0_0 = fst_op_O_0_0; // @[Map2S.scala 19:8]
  assign O_0_0_1 = fst_op_O_0_1; // @[Map2S.scala 19:8]
  assign O_0_1_0 = fst_op_O_1_0; // @[Map2S.scala 19:8]
  assign O_0_1_1 = fst_op_O_1_1; // @[Map2S.scala 19:8]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0_0 = I0_0_0; // @[Map2S.scala 17:13]
  assign fst_op_I0_1 = I0_0_1; // @[Map2S.scala 17:13]
  assign fst_op_I1_0 = I1_0_0; // @[Map2S.scala 18:13]
  assign fst_op_I1_1 = I1_0_1; // @[Map2S.scala 18:13]
endmodule
module Map2T_12(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I1_0_0,
  input  [7:0] I1_0_1,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_1; // @[Map2T.scala 8:20]
  Map2S_13 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0_0(op_I0_0_0),
    .I0_0_1(op_I0_0_1),
    .I1_0_0(op_I1_0_0),
    .I1_0_1(op_I1_0_1),
    .O_0_0_0(op_O_0_0_0),
    .O_0_0_1(op_O_0_0_1),
    .O_0_1_0(op_O_0_1_0),
    .O_0_1_1(op_O_0_1_1)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0_0_0 = op_O_0_0_0; // @[Map2T.scala 17:7]
  assign O_0_0_1 = op_O_0_0_1; // @[Map2T.scala 17:7]
  assign O_0_1_0 = op_O_0_1_0; // @[Map2T.scala 17:7]
  assign O_0_1_1 = op_O_0_1_1; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0_0 = I0_0_0; // @[Map2T.scala 15:11]
  assign op_I0_0_1 = I0_0_1; // @[Map2T.scala 15:11]
  assign op_I1_0_0 = I1_0_0; // @[Map2T.scala 16:11]
  assign op_I1_0_1 = I1_0_1; // @[Map2T.scala 16:11]
endmodule
module Passthrough_5(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  input  [7:0] I_0_1_0,
  input  [7:0] I_0_1_1,
  output [7:0] O_0_0_0,
  output [7:0] O_0_0_1,
  output [7:0] O_0_1_0,
  output [7:0] O_0_1_1
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O_0_0_0 = I_0_0_0; // @[Passthrough.scala 17:68]
  assign O_0_0_1 = I_0_0_1; // @[Passthrough.scala 17:68]
  assign O_0_1_0 = I_0_1_0; // @[Passthrough.scala 17:68]
  assign O_0_1_1 = I_0_1_1; // @[Passthrough.scala 17:68]
endmodule
module Passthrough_6(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  input  [7:0] I_0_1_0,
  input  [7:0] I_0_1_1,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_1_0,
  output [7:0] O_1_1
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O_0_0 = I_0_0_0; // @[Passthrough.scala 17:68]
  assign O_0_1 = I_0_0_1; // @[Passthrough.scala 17:68]
  assign O_1_0 = I_0_1_0; // @[Passthrough.scala 17:68]
  assign O_1_1 = I_0_1_1; // @[Passthrough.scala 17:68]
endmodule
module MapT_16(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_0,
  input  [7:0] I_0_0_1,
  input  [7:0] I_0_1_0,
  input  [7:0] I_0_1_1,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_1_0,
  output [7:0] O_1_1
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_1; // @[MapT.scala 8:20]
  Passthrough_6 op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0_0(op_I_0_0_0),
    .I_0_0_1(op_I_0_0_1),
    .I_0_1_0(op_I_0_1_0),
    .I_0_1_1(op_I_0_1_1),
    .O_0_0(op_O_0_0),
    .O_0_1(op_O_0_1),
    .O_1_0(op_O_1_0),
    .O_1_1(op_O_1_1)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign O_0_1 = op_O_0_1; // @[MapT.scala 15:7]
  assign O_1_0 = op_O_1_0; // @[MapT.scala 15:7]
  assign O_1_1 = op_O_1_1; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0_0 = I_0_0_0; // @[MapT.scala 14:10]
  assign op_I_0_0_1 = I_0_0_1; // @[MapT.scala 14:10]
  assign op_I_0_1_0 = I_0_1_0; // @[MapT.scala 14:10]
  assign op_I_0_1_1 = I_0_1_1; // @[MapT.scala 14:10]
endmodule
module Map2S_14(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I0_1,
  input  [7:0] I1_0,
  input  [7:0] I1_1,
  output [7:0] O_0_t0b,
  output [7:0] O_0_t1b,
  output [7:0] O_1_t0b,
  output [7:0] O_1_t1b
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
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[Map2S.scala 26:14]
  assign O_0_t0b = fst_op_O_t0b; // @[Map2S.scala 19:8]
  assign O_0_t1b = fst_op_O_t1b; // @[Map2S.scala 19:8]
  assign O_1_t0b = other_ops_0_O_t0b; // @[Map2S.scala 24:12]
  assign O_1_t1b = other_ops_0_O_t1b; // @[Map2S.scala 24:12]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0 = I0_0; // @[Map2S.scala 17:13]
  assign fst_op_I1 = I1_0; // @[Map2S.scala 18:13]
  assign other_ops_0_valid_up = valid_up; // @[Map2S.scala 21:39]
  assign other_ops_0_I0 = I0_1; // @[Map2S.scala 22:43]
  assign other_ops_0_I1 = I1_1; // @[Map2S.scala 23:43]
endmodule
module Map2S_15(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I0_1_0,
  input  [7:0] I0_1_1,
  output [7:0] O_0_0_t0b,
  output [7:0] O_0_0_t1b,
  output [7:0] O_0_1_t0b,
  output [7:0] O_0_1_t1b,
  output [7:0] O_1_0_t0b,
  output [7:0] O_1_0_t1b,
  output [7:0] O_1_1_t0b,
  output [7:0] O_1_1_t1b
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_1; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_t0b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_t1b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_t0b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_1_t1b; // @[Map2S.scala 9:22]
  wire  other_ops_0_valid_up; // @[Map2S.scala 10:86]
  wire  other_ops_0_valid_down; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I0_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1_0; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_I1_1; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0_t0b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_0_t1b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1_t0b; // @[Map2S.scala 10:86]
  wire [7:0] other_ops_0_O_1_t1b; // @[Map2S.scala 10:86]
  Map2S_14 fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0_0(fst_op_I0_0),
    .I0_1(fst_op_I0_1),
    .I1_0(fst_op_I1_0),
    .I1_1(fst_op_I1_1),
    .O_0_t0b(fst_op_O_0_t0b),
    .O_0_t1b(fst_op_O_0_t1b),
    .O_1_t0b(fst_op_O_1_t0b),
    .O_1_t1b(fst_op_O_1_t1b)
  );
  Map2S_14 other_ops_0 ( // @[Map2S.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I0_0(other_ops_0_I0_0),
    .I0_1(other_ops_0_I0_1),
    .I1_0(other_ops_0_I1_0),
    .I1_1(other_ops_0_I1_1),
    .O_0_t0b(other_ops_0_O_0_t0b),
    .O_0_t1b(other_ops_0_O_0_t1b),
    .O_1_t0b(other_ops_0_O_1_t0b),
    .O_1_t1b(other_ops_0_O_1_t1b)
  );
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0_t0b = fst_op_O_0_t0b; // @[Map2S.scala 19:8]
  assign O_0_0_t1b = fst_op_O_0_t1b; // @[Map2S.scala 19:8]
  assign O_0_1_t0b = fst_op_O_1_t0b; // @[Map2S.scala 19:8]
  assign O_0_1_t1b = fst_op_O_1_t1b; // @[Map2S.scala 19:8]
  assign O_1_0_t0b = other_ops_0_O_0_t0b; // @[Map2S.scala 24:12]
  assign O_1_0_t1b = other_ops_0_O_0_t1b; // @[Map2S.scala 24:12]
  assign O_1_1_t0b = other_ops_0_O_1_t0b; // @[Map2S.scala 24:12]
  assign O_1_1_t1b = other_ops_0_O_1_t1b; // @[Map2S.scala 24:12]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0_0 = I0_0_0; // @[Map2S.scala 17:13]
  assign fst_op_I0_1 = I0_0_1; // @[Map2S.scala 17:13]
  assign fst_op_I1_0 = 8'h0; // @[Map2S.scala 18:13]
  assign fst_op_I1_1 = 8'h2; // @[Map2S.scala 18:13]
  assign other_ops_0_valid_up = valid_up; // @[Map2S.scala 21:39]
  assign other_ops_0_I0_0 = I0_1_0; // @[Map2S.scala 22:43]
  assign other_ops_0_I0_1 = I0_1_1; // @[Map2S.scala 22:43]
  assign other_ops_0_I1_0 = 8'h1; // @[Map2S.scala 23:43]
  assign other_ops_0_I1_1 = 8'h0; // @[Map2S.scala 23:43]
endmodule
module Map2T_13(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I0_0_1,
  input  [7:0] I0_1_0,
  input  [7:0] I0_1_1,
  output [7:0] O_0_0_t0b,
  output [7:0] O_0_0_t1b,
  output [7:0] O_0_1_t0b,
  output [7:0] O_0_1_t1b,
  output [7:0] O_1_0_t0b,
  output [7:0] O_1_0_t1b,
  output [7:0] O_1_1_t0b,
  output [7:0] O_1_1_t1b
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_0_t1b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0_1_t1b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_0_t1b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1_1_t1b; // @[Map2T.scala 8:20]
  Map2S_15 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0_0(op_I0_0_0),
    .I0_0_1(op_I0_0_1),
    .I0_1_0(op_I0_1_0),
    .I0_1_1(op_I0_1_1),
    .O_0_0_t0b(op_O_0_0_t0b),
    .O_0_0_t1b(op_O_0_0_t1b),
    .O_0_1_t0b(op_O_0_1_t0b),
    .O_0_1_t1b(op_O_0_1_t1b),
    .O_1_0_t0b(op_O_1_0_t0b),
    .O_1_0_t1b(op_O_1_0_t1b),
    .O_1_1_t0b(op_O_1_1_t0b),
    .O_1_1_t1b(op_O_1_1_t1b)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0_0_t0b = op_O_0_0_t0b; // @[Map2T.scala 17:7]
  assign O_0_0_t1b = op_O_0_0_t1b; // @[Map2T.scala 17:7]
  assign O_0_1_t0b = op_O_0_1_t0b; // @[Map2T.scala 17:7]
  assign O_0_1_t1b = op_O_0_1_t1b; // @[Map2T.scala 17:7]
  assign O_1_0_t0b = op_O_1_0_t0b; // @[Map2T.scala 17:7]
  assign O_1_0_t1b = op_O_1_0_t1b; // @[Map2T.scala 17:7]
  assign O_1_1_t0b = op_O_1_1_t0b; // @[Map2T.scala 17:7]
  assign O_1_1_t1b = op_O_1_1_t1b; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0_0 = I0_0_0; // @[Map2T.scala 15:11]
  assign op_I0_0_1 = I0_0_1; // @[Map2T.scala 15:11]
  assign op_I0_1_0 = I0_1_0; // @[Map2T.scala 15:11]
  assign op_I0_1_1 = I0_1_1; // @[Map2T.scala 15:11]
endmodule
module MapS_9(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_t0b,
  input  [7:0] I_0_t1b,
  input  [7:0] I_1_t0b,
  input  [7:0] I_1_t1b,
  output [7:0] O_0,
  output [7:0] O_1
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
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[MapS.scala 23:14]
  assign O_0 = fst_op_O; // @[MapS.scala 17:8]
  assign O_1 = other_ops_0_O; // @[MapS.scala 21:12]
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_t0b = I_0_t0b; // @[MapS.scala 16:12]
  assign fst_op_I_t1b = I_0_t1b; // @[MapS.scala 16:12]
  assign other_ops_0_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_0_I_t0b = I_1_t0b; // @[MapS.scala 20:41]
  assign other_ops_0_I_t1b = I_1_t1b; // @[MapS.scala 20:41]
endmodule
module MapS_10(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_t0b,
  input  [7:0] I_0_0_t1b,
  input  [7:0] I_0_1_t0b,
  input  [7:0] I_0_1_t1b,
  input  [7:0] I_1_0_t0b,
  input  [7:0] I_1_0_t1b,
  input  [7:0] I_1_1_t0b,
  input  [7:0] I_1_1_t1b,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_1_0,
  output [7:0] O_1_1
);
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_t0b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0_t1b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_1_t0b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_1_t1b; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_1; // @[MapS.scala 9:22]
  wire  other_ops_0_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_t0b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0_t1b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_1_t0b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_1_t1b; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_1; // @[MapS.scala 10:86]
  MapS_9 fst_op ( // @[MapS.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_0_t0b(fst_op_I_0_t0b),
    .I_0_t1b(fst_op_I_0_t1b),
    .I_1_t0b(fst_op_I_1_t0b),
    .I_1_t1b(fst_op_I_1_t1b),
    .O_0(fst_op_O_0),
    .O_1(fst_op_O_1)
  );
  MapS_9 other_ops_0 ( // @[MapS.scala 10:86]
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I_0_t0b(other_ops_0_I_0_t0b),
    .I_0_t1b(other_ops_0_I_0_t1b),
    .I_1_t0b(other_ops_0_I_1_t0b),
    .I_1_t1b(other_ops_0_I_1_t1b),
    .O_0(other_ops_0_O_0),
    .O_1(other_ops_0_O_1)
  );
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[MapS.scala 23:14]
  assign O_0_0 = fst_op_O_0; // @[MapS.scala 17:8]
  assign O_0_1 = fst_op_O_1; // @[MapS.scala 17:8]
  assign O_1_0 = other_ops_0_O_0; // @[MapS.scala 21:12]
  assign O_1_1 = other_ops_0_O_1; // @[MapS.scala 21:12]
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_0_t0b = I_0_0_t0b; // @[MapS.scala 16:12]
  assign fst_op_I_0_t1b = I_0_0_t1b; // @[MapS.scala 16:12]
  assign fst_op_I_1_t0b = I_0_1_t0b; // @[MapS.scala 16:12]
  assign fst_op_I_1_t1b = I_0_1_t1b; // @[MapS.scala 16:12]
  assign other_ops_0_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_0_I_0_t0b = I_1_0_t0b; // @[MapS.scala 20:41]
  assign other_ops_0_I_0_t1b = I_1_0_t1b; // @[MapS.scala 20:41]
  assign other_ops_0_I_1_t0b = I_1_1_t0b; // @[MapS.scala 20:41]
  assign other_ops_0_I_1_t1b = I_1_1_t1b; // @[MapS.scala 20:41]
endmodule
module MapT_17(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0_t0b,
  input  [7:0] I_0_0_t1b,
  input  [7:0] I_0_1_t0b,
  input  [7:0] I_0_1_t1b,
  input  [7:0] I_1_0_t0b,
  input  [7:0] I_1_0_t1b,
  input  [7:0] I_1_1_t0b,
  input  [7:0] I_1_1_t1b,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_1_0,
  output [7:0] O_1_1
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_1; // @[MapT.scala 8:20]
  MapS_10 op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0_t0b(op_I_0_0_t0b),
    .I_0_0_t1b(op_I_0_0_t1b),
    .I_0_1_t0b(op_I_0_1_t0b),
    .I_0_1_t1b(op_I_0_1_t1b),
    .I_1_0_t0b(op_I_1_0_t0b),
    .I_1_0_t1b(op_I_1_0_t1b),
    .I_1_1_t0b(op_I_1_1_t0b),
    .I_1_1_t1b(op_I_1_1_t1b),
    .O_0_0(op_O_0_0),
    .O_0_1(op_O_0_1),
    .O_1_0(op_O_1_0),
    .O_1_1(op_O_1_1)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign O_0_1 = op_O_0_1; // @[MapT.scala 15:7]
  assign O_1_0 = op_O_1_0; // @[MapT.scala 15:7]
  assign O_1_1 = op_O_1_1; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0_t0b = I_0_0_t0b; // @[MapT.scala 14:10]
  assign op_I_0_0_t1b = I_0_0_t1b; // @[MapT.scala 14:10]
  assign op_I_0_1_t0b = I_0_1_t0b; // @[MapT.scala 14:10]
  assign op_I_0_1_t1b = I_0_1_t1b; // @[MapT.scala 14:10]
  assign op_I_1_0_t0b = I_1_0_t0b; // @[MapT.scala 14:10]
  assign op_I_1_0_t1b = I_1_0_t1b; // @[MapT.scala 14:10]
  assign op_I_1_1_t0b = I_1_1_t0b; // @[MapT.scala 14:10]
  assign op_I_1_1_t1b = I_1_1_t1b; // @[MapT.scala 14:10]
endmodule
module ReduceS_2(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  output [7:0] O_0
);
  wire [7:0] AddNoValid_I_t0b; // @[ReduceS.scala 20:43]
  wire [7:0] AddNoValid_I_t1b; // @[ReduceS.scala 20:43]
  wire [7:0] AddNoValid_O; // @[ReduceS.scala 20:43]
  reg [7:0] _T; // @[ReduceS.scala 27:24]
  reg [31:0] _RAND_0;
  reg  _T_1; // @[ReduceS.scala 47:24]
  reg [31:0] _RAND_1;
  AddNoValid AddNoValid ( // @[ReduceS.scala 20:43]
    .I_t0b(AddNoValid_I_t0b),
    .I_t1b(AddNoValid_I_t1b),
    .O(AddNoValid_O)
  );
  assign valid_down = _T_1; // @[ReduceS.scala 47:14]
  assign O_0 = _T; // @[ReduceS.scala 27:14]
  assign AddNoValid_I_t0b = I_0; // @[ReduceS.scala 43:18]
  assign AddNoValid_I_t1b = I_1; // @[ReduceS.scala 43:18]
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
module MapS_11(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_1_0,
  input  [7:0] I_1_1,
  output [7:0] O_0_0,
  output [7:0] O_1_0
);
  wire  fst_op_clock; // @[MapS.scala 9:22]
  wire  fst_op_reset; // @[MapS.scala 9:22]
  wire  fst_op_valid_up; // @[MapS.scala 9:22]
  wire  fst_op_valid_down; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_0; // @[MapS.scala 9:22]
  wire [7:0] fst_op_I_1; // @[MapS.scala 9:22]
  wire [7:0] fst_op_O_0; // @[MapS.scala 9:22]
  wire  other_ops_0_clock; // @[MapS.scala 10:86]
  wire  other_ops_0_reset; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_up; // @[MapS.scala 10:86]
  wire  other_ops_0_valid_down; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_0; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_I_1; // @[MapS.scala 10:86]
  wire [7:0] other_ops_0_O_0; // @[MapS.scala 10:86]
  ReduceS_2 fst_op ( // @[MapS.scala 9:22]
    .clock(fst_op_clock),
    .reset(fst_op_reset),
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_0(fst_op_I_0),
    .I_1(fst_op_I_1),
    .O_0(fst_op_O_0)
  );
  ReduceS_2 other_ops_0 ( // @[MapS.scala 10:86]
    .clock(other_ops_0_clock),
    .reset(other_ops_0_reset),
    .valid_up(other_ops_0_valid_up),
    .valid_down(other_ops_0_valid_down),
    .I_0(other_ops_0_I_0),
    .I_1(other_ops_0_I_1),
    .O_0(other_ops_0_O_0)
  );
  assign valid_down = fst_op_valid_down & other_ops_0_valid_down; // @[MapS.scala 23:14]
  assign O_0_0 = fst_op_O_0; // @[MapS.scala 17:8]
  assign O_1_0 = other_ops_0_O_0; // @[MapS.scala 21:12]
  assign fst_op_clock = clock;
  assign fst_op_reset = reset;
  assign fst_op_valid_up = valid_up; // @[MapS.scala 15:19]
  assign fst_op_I_0 = I_0_0; // @[MapS.scala 16:12]
  assign fst_op_I_1 = I_0_1; // @[MapS.scala 16:12]
  assign other_ops_0_clock = clock; // @[MapS.scala 10:86]
  assign other_ops_0_reset = reset; // @[MapS.scala 10:86]
  assign other_ops_0_valid_up = valid_up; // @[MapS.scala 19:39]
  assign other_ops_0_I_0 = I_1_0; // @[MapS.scala 20:41]
  assign other_ops_0_I_1 = I_1_1; // @[MapS.scala 20:41]
endmodule
module MapT_18(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_1_0,
  input  [7:0] I_1_1,
  output [7:0] O_0_0,
  output [7:0] O_1_0
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_1_0; // @[MapT.scala 8:20]
  MapS_11 op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0(op_I_0_0),
    .I_0_1(op_I_0_1),
    .I_1_0(op_I_1_0),
    .I_1_1(op_I_1_1),
    .O_0_0(op_O_0_0),
    .O_1_0(op_O_1_0)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign O_1_0 = op_O_1_0; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0 = I_0_0; // @[MapT.scala 14:10]
  assign op_I_0_1 = I_0_1; // @[MapT.scala 14:10]
  assign op_I_1_0 = I_1_0; // @[MapT.scala 14:10]
  assign op_I_1_1 = I_1_1; // @[MapT.scala 14:10]
endmodule
module ReduceS_3(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_1_0,
  output [7:0] O_0_0
);
  wire [7:0] MapSNoValid_I_0_t0b; // @[ReduceS.scala 20:43]
  wire [7:0] MapSNoValid_I_0_t1b; // @[ReduceS.scala 20:43]
  wire [7:0] MapSNoValid_O_0; // @[ReduceS.scala 20:43]
  reg [7:0] _T_0; // @[ReduceS.scala 27:24]
  reg [31:0] _RAND_0;
  reg  _T_1; // @[ReduceS.scala 47:24]
  reg [31:0] _RAND_1;
  MapSNoValid MapSNoValid ( // @[ReduceS.scala 20:43]
    .I_0_t0b(MapSNoValid_I_0_t0b),
    .I_0_t1b(MapSNoValid_I_0_t1b),
    .O_0(MapSNoValid_O_0)
  );
  assign valid_down = _T_1; // @[ReduceS.scala 47:14]
  assign O_0_0 = _T_0; // @[ReduceS.scala 27:14]
  assign MapSNoValid_I_0_t0b = I_1_0; // @[ReduceS.scala 43:18]
  assign MapSNoValid_I_0_t1b = I_0_0; // @[ReduceS.scala 43:18]
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
module MapT_19(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_1_0,
  output [7:0] O_0_0
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_O_0_0; // @[MapT.scala 8:20]
  ReduceS_3 op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0(op_I_0_0),
    .I_1_0(op_I_1_0),
    .O_0_0(op_O_0_0)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0 = I_0_0; // @[MapT.scala 14:10]
  assign op_I_1_0 = I_1_0; // @[MapT.scala 14:10]
endmodule
module InitialDelayCounter_3(
  input   clock,
  input   reset,
  output  valid_down
);
  reg [2:0] value; // @[InitialDelayCounter.scala 8:34]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[InitialDelayCounter.scala 17:17]
  wire [2:0] _T_4; // @[InitialDelayCounter.scala 17:53]
  assign _T_1 = value < 3'h7; // @[InitialDelayCounter.scala 17:17]
  assign _T_4 = value + 3'h1; // @[InitialDelayCounter.scala 17:53]
  assign valid_down = value == 3'h7; // @[InitialDelayCounter.scala 16:16]
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
  value = _RAND_0[2:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      value <= 3'h0;
    end else if (_T_1) begin
      value <= _T_4;
    end
  end
endmodule
module Module_1(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_1_0,
  input  [7:0] I_1_1,
  output [7:0] O_0
);
  wire  InitialDelayCounter_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_valid_down; // @[Const.scala 11:33]
  wire  n206_valid_up; // @[Top.scala 51:22]
  wire  n206_valid_down; // @[Top.scala 51:22]
  wire [7:0] n206_I0_0_0; // @[Top.scala 51:22]
  wire [7:0] n206_I0_0_1; // @[Top.scala 51:22]
  wire [7:0] n206_I0_1_0; // @[Top.scala 51:22]
  wire [7:0] n206_I0_1_1; // @[Top.scala 51:22]
  wire [7:0] n206_O_0_0_t0b; // @[Top.scala 51:22]
  wire [7:0] n206_O_0_0_t1b; // @[Top.scala 51:22]
  wire [7:0] n206_O_0_1_t0b; // @[Top.scala 51:22]
  wire [7:0] n206_O_0_1_t1b; // @[Top.scala 51:22]
  wire [7:0] n206_O_1_0_t0b; // @[Top.scala 51:22]
  wire [7:0] n206_O_1_0_t1b; // @[Top.scala 51:22]
  wire [7:0] n206_O_1_1_t0b; // @[Top.scala 51:22]
  wire [7:0] n206_O_1_1_t1b; // @[Top.scala 51:22]
  wire  n222_valid_up; // @[Top.scala 55:22]
  wire  n222_valid_down; // @[Top.scala 55:22]
  wire [7:0] n222_I_0_0_t0b; // @[Top.scala 55:22]
  wire [7:0] n222_I_0_0_t1b; // @[Top.scala 55:22]
  wire [7:0] n222_I_0_1_t0b; // @[Top.scala 55:22]
  wire [7:0] n222_I_0_1_t1b; // @[Top.scala 55:22]
  wire [7:0] n222_I_1_0_t0b; // @[Top.scala 55:22]
  wire [7:0] n222_I_1_0_t1b; // @[Top.scala 55:22]
  wire [7:0] n222_I_1_1_t0b; // @[Top.scala 55:22]
  wire [7:0] n222_I_1_1_t1b; // @[Top.scala 55:22]
  wire [7:0] n222_O_0_0; // @[Top.scala 55:22]
  wire [7:0] n222_O_0_1; // @[Top.scala 55:22]
  wire [7:0] n222_O_1_0; // @[Top.scala 55:22]
  wire [7:0] n222_O_1_1; // @[Top.scala 55:22]
  wire  n229_clock; // @[Top.scala 58:22]
  wire  n229_reset; // @[Top.scala 58:22]
  wire  n229_valid_up; // @[Top.scala 58:22]
  wire  n229_valid_down; // @[Top.scala 58:22]
  wire [7:0] n229_I_0_0; // @[Top.scala 58:22]
  wire [7:0] n229_I_0_1; // @[Top.scala 58:22]
  wire [7:0] n229_I_1_0; // @[Top.scala 58:22]
  wire [7:0] n229_I_1_1; // @[Top.scala 58:22]
  wire [7:0] n229_O_0_0; // @[Top.scala 58:22]
  wire [7:0] n229_O_1_0; // @[Top.scala 58:22]
  wire  n236_clock; // @[Top.scala 61:22]
  wire  n236_reset; // @[Top.scala 61:22]
  wire  n236_valid_up; // @[Top.scala 61:22]
  wire  n236_valid_down; // @[Top.scala 61:22]
  wire [7:0] n236_I_0_0; // @[Top.scala 61:22]
  wire [7:0] n236_I_1_0; // @[Top.scala 61:22]
  wire [7:0] n236_O_0_0; // @[Top.scala 61:22]
  wire  n239_clock; // @[Top.scala 64:22]
  wire  n239_reset; // @[Top.scala 64:22]
  wire  n239_valid_up; // @[Top.scala 64:22]
  wire  n239_valid_down; // @[Top.scala 64:22]
  wire [7:0] n239_I_0_0; // @[Top.scala 64:22]
  wire [7:0] n239_O_0_0; // @[Top.scala 64:22]
  wire  n240_valid_up; // @[Top.scala 67:22]
  wire  n240_valid_down; // @[Top.scala 67:22]
  wire [7:0] n240_I_0_0; // @[Top.scala 67:22]
  wire [7:0] n240_O_0; // @[Top.scala 67:22]
  wire  InitialDelayCounter_1_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_valid_down; // @[Const.scala 11:33]
  wire  n243_valid_up; // @[Top.scala 71:22]
  wire  n243_valid_down; // @[Top.scala 71:22]
  wire [7:0] n243_I0_0; // @[Top.scala 71:22]
  wire [7:0] n243_I1_0; // @[Top.scala 71:22]
  wire [7:0] n243_O_0_t0b; // @[Top.scala 71:22]
  wire [7:0] n243_O_0_t1b; // @[Top.scala 71:22]
  wire  n254_valid_up; // @[Top.scala 75:22]
  wire  n254_valid_down; // @[Top.scala 75:22]
  wire [7:0] n254_I_0_t0b; // @[Top.scala 75:22]
  wire [7:0] n254_I_0_t1b; // @[Top.scala 75:22]
  wire [7:0] n254_O_0; // @[Top.scala 75:22]
  InitialDelayCounter_1 InitialDelayCounter ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_clock),
    .reset(InitialDelayCounter_reset),
    .valid_down(InitialDelayCounter_valid_down)
  );
  Map2T_13 n206 ( // @[Top.scala 51:22]
    .valid_up(n206_valid_up),
    .valid_down(n206_valid_down),
    .I0_0_0(n206_I0_0_0),
    .I0_0_1(n206_I0_0_1),
    .I0_1_0(n206_I0_1_0),
    .I0_1_1(n206_I0_1_1),
    .O_0_0_t0b(n206_O_0_0_t0b),
    .O_0_0_t1b(n206_O_0_0_t1b),
    .O_0_1_t0b(n206_O_0_1_t0b),
    .O_0_1_t1b(n206_O_0_1_t1b),
    .O_1_0_t0b(n206_O_1_0_t0b),
    .O_1_0_t1b(n206_O_1_0_t1b),
    .O_1_1_t0b(n206_O_1_1_t0b),
    .O_1_1_t1b(n206_O_1_1_t1b)
  );
  MapT_17 n222 ( // @[Top.scala 55:22]
    .valid_up(n222_valid_up),
    .valid_down(n222_valid_down),
    .I_0_0_t0b(n222_I_0_0_t0b),
    .I_0_0_t1b(n222_I_0_0_t1b),
    .I_0_1_t0b(n222_I_0_1_t0b),
    .I_0_1_t1b(n222_I_0_1_t1b),
    .I_1_0_t0b(n222_I_1_0_t0b),
    .I_1_0_t1b(n222_I_1_0_t1b),
    .I_1_1_t0b(n222_I_1_1_t0b),
    .I_1_1_t1b(n222_I_1_1_t1b),
    .O_0_0(n222_O_0_0),
    .O_0_1(n222_O_0_1),
    .O_1_0(n222_O_1_0),
    .O_1_1(n222_O_1_1)
  );
  MapT_18 n229 ( // @[Top.scala 58:22]
    .clock(n229_clock),
    .reset(n229_reset),
    .valid_up(n229_valid_up),
    .valid_down(n229_valid_down),
    .I_0_0(n229_I_0_0),
    .I_0_1(n229_I_0_1),
    .I_1_0(n229_I_1_0),
    .I_1_1(n229_I_1_1),
    .O_0_0(n229_O_0_0),
    .O_1_0(n229_O_1_0)
  );
  MapT_19 n236 ( // @[Top.scala 61:22]
    .clock(n236_clock),
    .reset(n236_reset),
    .valid_up(n236_valid_up),
    .valid_down(n236_valid_down),
    .I_0_0(n236_I_0_0),
    .I_1_0(n236_I_1_0),
    .O_0_0(n236_O_0_0)
  );
  ReduceT n239 ( // @[Top.scala 64:22]
    .clock(n239_clock),
    .reset(n239_reset),
    .valid_up(n239_valid_up),
    .valid_down(n239_valid_down),
    .I_0_0(n239_I_0_0),
    .O_0_0(n239_O_0_0)
  );
  Passthrough_2 n240 ( // @[Top.scala 67:22]
    .valid_up(n240_valid_up),
    .valid_down(n240_valid_down),
    .I_0_0(n240_I_0_0),
    .O_0(n240_O_0)
  );
  InitialDelayCounter_3 InitialDelayCounter_1 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_1_clock),
    .reset(InitialDelayCounter_1_reset),
    .valid_down(InitialDelayCounter_1_valid_down)
  );
  Map2T_9 n243 ( // @[Top.scala 71:22]
    .valid_up(n243_valid_up),
    .valid_down(n243_valid_down),
    .I0_0(n243_I0_0),
    .I1_0(n243_I1_0),
    .O_0_t0b(n243_O_0_t0b),
    .O_0_t1b(n243_O_0_t1b)
  );
  MapT_10 n254 ( // @[Top.scala 75:22]
    .valid_up(n254_valid_up),
    .valid_down(n254_valid_down),
    .I_0_t0b(n254_I_0_t0b),
    .I_0_t1b(n254_I_0_t1b),
    .O_0(n254_O_0)
  );
  assign valid_down = n254_valid_down; // @[Top.scala 79:16]
  assign O_0 = n254_O_0; // @[Top.scala 78:7]
  assign InitialDelayCounter_clock = clock;
  assign InitialDelayCounter_reset = reset;
  assign n206_valid_up = valid_up & InitialDelayCounter_valid_down; // @[Top.scala 54:19]
  assign n206_I0_0_0 = I_0_0; // @[Top.scala 52:13]
  assign n206_I0_0_1 = I_0_1; // @[Top.scala 52:13]
  assign n206_I0_1_0 = I_1_0; // @[Top.scala 52:13]
  assign n206_I0_1_1 = I_1_1; // @[Top.scala 52:13]
  assign n222_valid_up = n206_valid_down; // @[Top.scala 57:19]
  assign n222_I_0_0_t0b = n206_O_0_0_t0b; // @[Top.scala 56:12]
  assign n222_I_0_0_t1b = n206_O_0_0_t1b; // @[Top.scala 56:12]
  assign n222_I_0_1_t0b = n206_O_0_1_t0b; // @[Top.scala 56:12]
  assign n222_I_0_1_t1b = n206_O_0_1_t1b; // @[Top.scala 56:12]
  assign n222_I_1_0_t0b = n206_O_1_0_t0b; // @[Top.scala 56:12]
  assign n222_I_1_0_t1b = n206_O_1_0_t1b; // @[Top.scala 56:12]
  assign n222_I_1_1_t0b = n206_O_1_1_t0b; // @[Top.scala 56:12]
  assign n222_I_1_1_t1b = n206_O_1_1_t1b; // @[Top.scala 56:12]
  assign n229_clock = clock;
  assign n229_reset = reset;
  assign n229_valid_up = n222_valid_down; // @[Top.scala 60:19]
  assign n229_I_0_0 = n222_O_0_0; // @[Top.scala 59:12]
  assign n229_I_0_1 = n222_O_0_1; // @[Top.scala 59:12]
  assign n229_I_1_0 = n222_O_1_0; // @[Top.scala 59:12]
  assign n229_I_1_1 = n222_O_1_1; // @[Top.scala 59:12]
  assign n236_clock = clock;
  assign n236_reset = reset;
  assign n236_valid_up = n229_valid_down; // @[Top.scala 63:19]
  assign n236_I_0_0 = n229_O_0_0; // @[Top.scala 62:12]
  assign n236_I_1_0 = n229_O_1_0; // @[Top.scala 62:12]
  assign n239_clock = clock;
  assign n239_reset = reset;
  assign n239_valid_up = n236_valid_down; // @[Top.scala 66:19]
  assign n239_I_0_0 = n236_O_0_0; // @[Top.scala 65:12]
  assign n240_valid_up = n239_valid_down; // @[Top.scala 69:19]
  assign n240_I_0_0 = n239_O_0_0; // @[Top.scala 68:12]
  assign InitialDelayCounter_1_clock = clock;
  assign InitialDelayCounter_1_reset = reset;
  assign n243_valid_up = n240_valid_down & InitialDelayCounter_1_valid_down; // @[Top.scala 74:19]
  assign n243_I0_0 = n240_O_0; // @[Top.scala 72:13]
  assign n243_I1_0 = 8'h3; // @[Top.scala 73:13]
  assign n254_valid_up = n243_valid_down; // @[Top.scala 77:19]
  assign n254_I_0_t0b = n243_O_0_t0b; // @[Top.scala 76:12]
  assign n254_I_0_t1b = n243_O_0_t1b; // @[Top.scala 76:12]
endmodule
module MapT_21(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_1_0,
  input  [7:0] I_1_1,
  output [7:0] O_0
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_0_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1_1; // @[MapT.scala 8:20]
  wire [7:0] op_O_0; // @[MapT.scala 8:20]
  Module_1 op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0(op_I_0_0),
    .I_0_1(op_I_0_1),
    .I_1_0(op_I_1_0),
    .I_1_1(op_I_1_1),
    .O_0(op_O_0)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0 = op_O_0; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0 = I_0_0; // @[MapT.scala 14:10]
  assign op_I_0_1 = I_0_1; // @[MapT.scala 14:10]
  assign op_I_1_0 = I_1_0; // @[MapT.scala 14:10]
  assign op_I_1_1 = I_1_1; // @[MapT.scala 14:10]
endmodule
module Top(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  output [7:0] O_0
);
  wire  n1_clock; // @[Top.scala 85:20]
  wire  n1_reset; // @[Top.scala 85:20]
  wire  n1_valid_up; // @[Top.scala 85:20]
  wire  n1_valid_down; // @[Top.scala 85:20]
  wire [7:0] n1_I_0; // @[Top.scala 85:20]
  wire [7:0] n1_O_0; // @[Top.scala 85:20]
  wire  n2_clock; // @[Top.scala 88:20]
  wire  n2_reset; // @[Top.scala 88:20]
  wire  n2_valid_up; // @[Top.scala 88:20]
  wire  n2_valid_down; // @[Top.scala 88:20]
  wire [7:0] n2_I_0; // @[Top.scala 88:20]
  wire [7:0] n2_O_0; // @[Top.scala 88:20]
  wire  n3_clock; // @[Top.scala 91:20]
  wire  n3_reset; // @[Top.scala 91:20]
  wire  n3_valid_up; // @[Top.scala 91:20]
  wire  n3_valid_down; // @[Top.scala 91:20]
  wire [7:0] n3_I_0; // @[Top.scala 91:20]
  wire [7:0] n3_O_0; // @[Top.scala 91:20]
  wire  n4_clock; // @[Top.scala 94:20]
  wire  n4_valid_up; // @[Top.scala 94:20]
  wire  n4_valid_down; // @[Top.scala 94:20]
  wire [7:0] n4_I_0; // @[Top.scala 94:20]
  wire [7:0] n4_O_0; // @[Top.scala 94:20]
  wire  n5_clock; // @[Top.scala 97:20]
  wire  n5_valid_up; // @[Top.scala 97:20]
  wire  n5_valid_down; // @[Top.scala 97:20]
  wire [7:0] n5_I_0; // @[Top.scala 97:20]
  wire [7:0] n5_O_0; // @[Top.scala 97:20]
  wire  n6_valid_up; // @[Top.scala 100:20]
  wire  n6_valid_down; // @[Top.scala 100:20]
  wire [7:0] n6_I0_0; // @[Top.scala 100:20]
  wire [7:0] n6_I1_0; // @[Top.scala 100:20]
  wire [7:0] n6_O_0_0; // @[Top.scala 100:20]
  wire [7:0] n6_O_0_1; // @[Top.scala 100:20]
  wire  n13_valid_up; // @[Top.scala 104:21]
  wire  n13_valid_down; // @[Top.scala 104:21]
  wire [7:0] n13_I0_0_0; // @[Top.scala 104:21]
  wire [7:0] n13_I0_0_1; // @[Top.scala 104:21]
  wire [7:0] n13_I1_0; // @[Top.scala 104:21]
  wire [7:0] n13_O_0_0; // @[Top.scala 104:21]
  wire [7:0] n13_O_0_1; // @[Top.scala 104:21]
  wire [7:0] n13_O_0_2; // @[Top.scala 104:21]
  wire  n22_valid_up; // @[Top.scala 108:21]
  wire  n22_valid_down; // @[Top.scala 108:21]
  wire [7:0] n22_I_0_0; // @[Top.scala 108:21]
  wire [7:0] n22_I_0_1; // @[Top.scala 108:21]
  wire [7:0] n22_I_0_2; // @[Top.scala 108:21]
  wire [7:0] n22_O_0_0_0; // @[Top.scala 108:21]
  wire [7:0] n22_O_0_0_1; // @[Top.scala 108:21]
  wire [7:0] n22_O_0_0_2; // @[Top.scala 108:21]
  wire  n29_valid_up; // @[Top.scala 111:21]
  wire  n29_valid_down; // @[Top.scala 111:21]
  wire [7:0] n29_I_0_0_0; // @[Top.scala 111:21]
  wire [7:0] n29_I_0_0_1; // @[Top.scala 111:21]
  wire [7:0] n29_I_0_0_2; // @[Top.scala 111:21]
  wire [7:0] n29_O_0_0; // @[Top.scala 111:21]
  wire [7:0] n29_O_0_1; // @[Top.scala 111:21]
  wire [7:0] n29_O_0_2; // @[Top.scala 111:21]
  wire  n30_clock; // @[Top.scala 114:21]
  wire  n30_valid_up; // @[Top.scala 114:21]
  wire  n30_valid_down; // @[Top.scala 114:21]
  wire [7:0] n30_I_0; // @[Top.scala 114:21]
  wire [7:0] n30_O_0; // @[Top.scala 114:21]
  wire  n31_clock; // @[Top.scala 117:21]
  wire  n31_valid_up; // @[Top.scala 117:21]
  wire  n31_valid_down; // @[Top.scala 117:21]
  wire [7:0] n31_I_0; // @[Top.scala 117:21]
  wire [7:0] n31_O_0; // @[Top.scala 117:21]
  wire  n32_valid_up; // @[Top.scala 120:21]
  wire  n32_valid_down; // @[Top.scala 120:21]
  wire [7:0] n32_I0_0; // @[Top.scala 120:21]
  wire [7:0] n32_I1_0; // @[Top.scala 120:21]
  wire [7:0] n32_O_0_0; // @[Top.scala 120:21]
  wire [7:0] n32_O_0_1; // @[Top.scala 120:21]
  wire  n39_valid_up; // @[Top.scala 124:21]
  wire  n39_valid_down; // @[Top.scala 124:21]
  wire [7:0] n39_I0_0_0; // @[Top.scala 124:21]
  wire [7:0] n39_I0_0_1; // @[Top.scala 124:21]
  wire [7:0] n39_I1_0; // @[Top.scala 124:21]
  wire [7:0] n39_O_0_0; // @[Top.scala 124:21]
  wire [7:0] n39_O_0_1; // @[Top.scala 124:21]
  wire [7:0] n39_O_0_2; // @[Top.scala 124:21]
  wire  n48_valid_up; // @[Top.scala 128:21]
  wire  n48_valid_down; // @[Top.scala 128:21]
  wire [7:0] n48_I_0_0; // @[Top.scala 128:21]
  wire [7:0] n48_I_0_1; // @[Top.scala 128:21]
  wire [7:0] n48_I_0_2; // @[Top.scala 128:21]
  wire [7:0] n48_O_0_0_0; // @[Top.scala 128:21]
  wire [7:0] n48_O_0_0_1; // @[Top.scala 128:21]
  wire [7:0] n48_O_0_0_2; // @[Top.scala 128:21]
  wire  n55_valid_up; // @[Top.scala 131:21]
  wire  n55_valid_down; // @[Top.scala 131:21]
  wire [7:0] n55_I_0_0_0; // @[Top.scala 131:21]
  wire [7:0] n55_I_0_0_1; // @[Top.scala 131:21]
  wire [7:0] n55_I_0_0_2; // @[Top.scala 131:21]
  wire [7:0] n55_O_0_0; // @[Top.scala 131:21]
  wire [7:0] n55_O_0_1; // @[Top.scala 131:21]
  wire [7:0] n55_O_0_2; // @[Top.scala 131:21]
  wire  n56_valid_up; // @[Top.scala 134:21]
  wire  n56_valid_down; // @[Top.scala 134:21]
  wire [7:0] n56_I0_0_0; // @[Top.scala 134:21]
  wire [7:0] n56_I0_0_1; // @[Top.scala 134:21]
  wire [7:0] n56_I0_0_2; // @[Top.scala 134:21]
  wire [7:0] n56_I1_0_0; // @[Top.scala 134:21]
  wire [7:0] n56_I1_0_1; // @[Top.scala 134:21]
  wire [7:0] n56_I1_0_2; // @[Top.scala 134:21]
  wire [7:0] n56_O_0_0_0; // @[Top.scala 134:21]
  wire [7:0] n56_O_0_0_1; // @[Top.scala 134:21]
  wire [7:0] n56_O_0_0_2; // @[Top.scala 134:21]
  wire [7:0] n56_O_0_1_0; // @[Top.scala 134:21]
  wire [7:0] n56_O_0_1_1; // @[Top.scala 134:21]
  wire [7:0] n56_O_0_1_2; // @[Top.scala 134:21]
  wire  n63_clock; // @[Top.scala 138:21]
  wire  n63_valid_up; // @[Top.scala 138:21]
  wire  n63_valid_down; // @[Top.scala 138:21]
  wire [7:0] n63_I_0; // @[Top.scala 138:21]
  wire [7:0] n63_O_0; // @[Top.scala 138:21]
  wire  n64_clock; // @[Top.scala 141:21]
  wire  n64_valid_up; // @[Top.scala 141:21]
  wire  n64_valid_down; // @[Top.scala 141:21]
  wire [7:0] n64_I_0; // @[Top.scala 141:21]
  wire [7:0] n64_O_0; // @[Top.scala 141:21]
  wire  n65_valid_up; // @[Top.scala 144:21]
  wire  n65_valid_down; // @[Top.scala 144:21]
  wire [7:0] n65_I0_0; // @[Top.scala 144:21]
  wire [7:0] n65_I1_0; // @[Top.scala 144:21]
  wire [7:0] n65_O_0_0; // @[Top.scala 144:21]
  wire [7:0] n65_O_0_1; // @[Top.scala 144:21]
  wire  n72_valid_up; // @[Top.scala 148:21]
  wire  n72_valid_down; // @[Top.scala 148:21]
  wire [7:0] n72_I0_0_0; // @[Top.scala 148:21]
  wire [7:0] n72_I0_0_1; // @[Top.scala 148:21]
  wire [7:0] n72_I1_0; // @[Top.scala 148:21]
  wire [7:0] n72_O_0_0; // @[Top.scala 148:21]
  wire [7:0] n72_O_0_1; // @[Top.scala 148:21]
  wire [7:0] n72_O_0_2; // @[Top.scala 148:21]
  wire  n81_valid_up; // @[Top.scala 152:21]
  wire  n81_valid_down; // @[Top.scala 152:21]
  wire [7:0] n81_I_0_0; // @[Top.scala 152:21]
  wire [7:0] n81_I_0_1; // @[Top.scala 152:21]
  wire [7:0] n81_I_0_2; // @[Top.scala 152:21]
  wire [7:0] n81_O_0_0_0; // @[Top.scala 152:21]
  wire [7:0] n81_O_0_0_1; // @[Top.scala 152:21]
  wire [7:0] n81_O_0_0_2; // @[Top.scala 152:21]
  wire  n88_valid_up; // @[Top.scala 155:21]
  wire  n88_valid_down; // @[Top.scala 155:21]
  wire [7:0] n88_I_0_0_0; // @[Top.scala 155:21]
  wire [7:0] n88_I_0_0_1; // @[Top.scala 155:21]
  wire [7:0] n88_I_0_0_2; // @[Top.scala 155:21]
  wire [7:0] n88_O_0_0; // @[Top.scala 155:21]
  wire [7:0] n88_O_0_1; // @[Top.scala 155:21]
  wire [7:0] n88_O_0_2; // @[Top.scala 155:21]
  wire  n89_valid_up; // @[Top.scala 158:21]
  wire  n89_valid_down; // @[Top.scala 158:21]
  wire [7:0] n89_I0_0_0_0; // @[Top.scala 158:21]
  wire [7:0] n89_I0_0_0_1; // @[Top.scala 158:21]
  wire [7:0] n89_I0_0_0_2; // @[Top.scala 158:21]
  wire [7:0] n89_I0_0_1_0; // @[Top.scala 158:21]
  wire [7:0] n89_I0_0_1_1; // @[Top.scala 158:21]
  wire [7:0] n89_I0_0_1_2; // @[Top.scala 158:21]
  wire [7:0] n89_I1_0_0; // @[Top.scala 158:21]
  wire [7:0] n89_I1_0_1; // @[Top.scala 158:21]
  wire [7:0] n89_I1_0_2; // @[Top.scala 158:21]
  wire [7:0] n89_O_0_0_0; // @[Top.scala 158:21]
  wire [7:0] n89_O_0_0_1; // @[Top.scala 158:21]
  wire [7:0] n89_O_0_0_2; // @[Top.scala 158:21]
  wire [7:0] n89_O_0_1_0; // @[Top.scala 158:21]
  wire [7:0] n89_O_0_1_1; // @[Top.scala 158:21]
  wire [7:0] n89_O_0_1_2; // @[Top.scala 158:21]
  wire [7:0] n89_O_0_2_0; // @[Top.scala 158:21]
  wire [7:0] n89_O_0_2_1; // @[Top.scala 158:21]
  wire [7:0] n89_O_0_2_2; // @[Top.scala 158:21]
  wire  n96_valid_up; // @[Top.scala 162:21]
  wire  n96_valid_down; // @[Top.scala 162:21]
  wire [7:0] n96_I_0_0_0; // @[Top.scala 162:21]
  wire [7:0] n96_I_0_0_1; // @[Top.scala 162:21]
  wire [7:0] n96_I_0_0_2; // @[Top.scala 162:21]
  wire [7:0] n96_I_0_1_0; // @[Top.scala 162:21]
  wire [7:0] n96_I_0_1_1; // @[Top.scala 162:21]
  wire [7:0] n96_I_0_1_2; // @[Top.scala 162:21]
  wire [7:0] n96_I_0_2_0; // @[Top.scala 162:21]
  wire [7:0] n96_I_0_2_1; // @[Top.scala 162:21]
  wire [7:0] n96_I_0_2_2; // @[Top.scala 162:21]
  wire [7:0] n96_O_0_0_0; // @[Top.scala 162:21]
  wire [7:0] n96_O_0_0_1; // @[Top.scala 162:21]
  wire [7:0] n96_O_0_0_2; // @[Top.scala 162:21]
  wire [7:0] n96_O_0_1_0; // @[Top.scala 162:21]
  wire [7:0] n96_O_0_1_1; // @[Top.scala 162:21]
  wire [7:0] n96_O_0_1_2; // @[Top.scala 162:21]
  wire [7:0] n96_O_0_2_0; // @[Top.scala 162:21]
  wire [7:0] n96_O_0_2_1; // @[Top.scala 162:21]
  wire [7:0] n96_O_0_2_2; // @[Top.scala 162:21]
  wire  n99_valid_up; // @[Top.scala 165:21]
  wire  n99_valid_down; // @[Top.scala 165:21]
  wire [7:0] n99_I_0_0_0; // @[Top.scala 165:21]
  wire [7:0] n99_I_0_0_1; // @[Top.scala 165:21]
  wire [7:0] n99_I_0_0_2; // @[Top.scala 165:21]
  wire [7:0] n99_I_0_1_0; // @[Top.scala 165:21]
  wire [7:0] n99_I_0_1_1; // @[Top.scala 165:21]
  wire [7:0] n99_I_0_1_2; // @[Top.scala 165:21]
  wire [7:0] n99_I_0_2_0; // @[Top.scala 165:21]
  wire [7:0] n99_I_0_2_1; // @[Top.scala 165:21]
  wire [7:0] n99_I_0_2_2; // @[Top.scala 165:21]
  wire [7:0] n99_O_0_0; // @[Top.scala 165:21]
  wire [7:0] n99_O_0_1; // @[Top.scala 165:21]
  wire [7:0] n99_O_0_2; // @[Top.scala 165:21]
  wire [7:0] n99_O_1_0; // @[Top.scala 165:21]
  wire [7:0] n99_O_1_1; // @[Top.scala 165:21]
  wire [7:0] n99_O_1_2; // @[Top.scala 165:21]
  wire [7:0] n99_O_2_0; // @[Top.scala 165:21]
  wire [7:0] n99_O_2_1; // @[Top.scala 165:21]
  wire [7:0] n99_O_2_2; // @[Top.scala 165:21]
  wire  n152_clock; // @[Top.scala 168:22]
  wire  n152_reset; // @[Top.scala 168:22]
  wire  n152_valid_up; // @[Top.scala 168:22]
  wire  n152_valid_down; // @[Top.scala 168:22]
  wire [7:0] n152_I_0_0; // @[Top.scala 168:22]
  wire [7:0] n152_I_0_1; // @[Top.scala 168:22]
  wire [7:0] n152_I_0_2; // @[Top.scala 168:22]
  wire [7:0] n152_I_1_0; // @[Top.scala 168:22]
  wire [7:0] n152_I_1_1; // @[Top.scala 168:22]
  wire [7:0] n152_I_1_2; // @[Top.scala 168:22]
  wire [7:0] n152_I_2_0; // @[Top.scala 168:22]
  wire [7:0] n152_I_2_1; // @[Top.scala 168:22]
  wire [7:0] n152_I_2_2; // @[Top.scala 168:22]
  wire [7:0] n152_O_0; // @[Top.scala 168:22]
  wire  n153_valid_up; // @[Top.scala 171:22]
  wire  n153_valid_down; // @[Top.scala 171:22]
  wire [7:0] n153_I_0; // @[Top.scala 171:22]
  wire [7:0] n153_O_0; // @[Top.scala 171:22]
  wire  n154_valid_up; // @[Top.scala 174:22]
  wire  n154_valid_down; // @[Top.scala 174:22]
  wire [7:0] n154_I_0; // @[Top.scala 174:22]
  wire [7:0] n154_O_0; // @[Top.scala 174:22]
  wire  n155_clock; // @[Top.scala 177:22]
  wire  n155_reset; // @[Top.scala 177:22]
  wire  n155_valid_up; // @[Top.scala 177:22]
  wire  n155_valid_down; // @[Top.scala 177:22]
  wire [7:0] n155_I_0; // @[Top.scala 177:22]
  wire [7:0] n155_O_0; // @[Top.scala 177:22]
  wire  n156_clock; // @[Top.scala 180:22]
  wire  n156_valid_up; // @[Top.scala 180:22]
  wire  n156_valid_down; // @[Top.scala 180:22]
  wire [7:0] n156_I_0; // @[Top.scala 180:22]
  wire [7:0] n156_O_0; // @[Top.scala 180:22]
  wire  n157_valid_up; // @[Top.scala 183:22]
  wire  n157_valid_down; // @[Top.scala 183:22]
  wire [7:0] n157_I0_0; // @[Top.scala 183:22]
  wire [7:0] n157_I1_0; // @[Top.scala 183:22]
  wire [7:0] n157_O_0_0; // @[Top.scala 183:22]
  wire [7:0] n157_O_0_1; // @[Top.scala 183:22]
  wire  n166_valid_up; // @[Top.scala 187:22]
  wire  n166_valid_down; // @[Top.scala 187:22]
  wire [7:0] n166_I_0_0; // @[Top.scala 187:22]
  wire [7:0] n166_I_0_1; // @[Top.scala 187:22]
  wire [7:0] n166_O_0_0_0; // @[Top.scala 187:22]
  wire [7:0] n166_O_0_0_1; // @[Top.scala 187:22]
  wire  n173_valid_up; // @[Top.scala 190:22]
  wire  n173_valid_down; // @[Top.scala 190:22]
  wire [7:0] n173_I_0_0_0; // @[Top.scala 190:22]
  wire [7:0] n173_I_0_0_1; // @[Top.scala 190:22]
  wire [7:0] n173_O_0_0; // @[Top.scala 190:22]
  wire [7:0] n173_O_0_1; // @[Top.scala 190:22]
  wire  n174_clock; // @[Top.scala 193:22]
  wire  n174_valid_up; // @[Top.scala 193:22]
  wire  n174_valid_down; // @[Top.scala 193:22]
  wire [7:0] n174_I_0; // @[Top.scala 193:22]
  wire [7:0] n174_O_0; // @[Top.scala 193:22]
  wire  n175_valid_up; // @[Top.scala 196:22]
  wire  n175_valid_down; // @[Top.scala 196:22]
  wire [7:0] n175_I0_0; // @[Top.scala 196:22]
  wire [7:0] n175_I1_0; // @[Top.scala 196:22]
  wire [7:0] n175_O_0_0; // @[Top.scala 196:22]
  wire [7:0] n175_O_0_1; // @[Top.scala 196:22]
  wire  n184_valid_up; // @[Top.scala 200:22]
  wire  n184_valid_down; // @[Top.scala 200:22]
  wire [7:0] n184_I_0_0; // @[Top.scala 200:22]
  wire [7:0] n184_I_0_1; // @[Top.scala 200:22]
  wire [7:0] n184_O_0_0_0; // @[Top.scala 200:22]
  wire [7:0] n184_O_0_0_1; // @[Top.scala 200:22]
  wire  n191_valid_up; // @[Top.scala 203:22]
  wire  n191_valid_down; // @[Top.scala 203:22]
  wire [7:0] n191_I_0_0_0; // @[Top.scala 203:22]
  wire [7:0] n191_I_0_0_1; // @[Top.scala 203:22]
  wire [7:0] n191_O_0_0; // @[Top.scala 203:22]
  wire [7:0] n191_O_0_1; // @[Top.scala 203:22]
  wire  n192_valid_up; // @[Top.scala 206:22]
  wire  n192_valid_down; // @[Top.scala 206:22]
  wire [7:0] n192_I0_0_0; // @[Top.scala 206:22]
  wire [7:0] n192_I0_0_1; // @[Top.scala 206:22]
  wire [7:0] n192_I1_0_0; // @[Top.scala 206:22]
  wire [7:0] n192_I1_0_1; // @[Top.scala 206:22]
  wire [7:0] n192_O_0_0_0; // @[Top.scala 206:22]
  wire [7:0] n192_O_0_0_1; // @[Top.scala 206:22]
  wire [7:0] n192_O_0_1_0; // @[Top.scala 206:22]
  wire [7:0] n192_O_0_1_1; // @[Top.scala 206:22]
  wire  n199_valid_up; // @[Top.scala 210:22]
  wire  n199_valid_down; // @[Top.scala 210:22]
  wire [7:0] n199_I_0_0_0; // @[Top.scala 210:22]
  wire [7:0] n199_I_0_0_1; // @[Top.scala 210:22]
  wire [7:0] n199_I_0_1_0; // @[Top.scala 210:22]
  wire [7:0] n199_I_0_1_1; // @[Top.scala 210:22]
  wire [7:0] n199_O_0_0_0; // @[Top.scala 210:22]
  wire [7:0] n199_O_0_0_1; // @[Top.scala 210:22]
  wire [7:0] n199_O_0_1_0; // @[Top.scala 210:22]
  wire [7:0] n199_O_0_1_1; // @[Top.scala 210:22]
  wire  n202_valid_up; // @[Top.scala 213:22]
  wire  n202_valid_down; // @[Top.scala 213:22]
  wire [7:0] n202_I_0_0_0; // @[Top.scala 213:22]
  wire [7:0] n202_I_0_0_1; // @[Top.scala 213:22]
  wire [7:0] n202_I_0_1_0; // @[Top.scala 213:22]
  wire [7:0] n202_I_0_1_1; // @[Top.scala 213:22]
  wire [7:0] n202_O_0_0; // @[Top.scala 213:22]
  wire [7:0] n202_O_0_1; // @[Top.scala 213:22]
  wire [7:0] n202_O_1_0; // @[Top.scala 213:22]
  wire [7:0] n202_O_1_1; // @[Top.scala 213:22]
  wire  n255_clock; // @[Top.scala 216:22]
  wire  n255_reset; // @[Top.scala 216:22]
  wire  n255_valid_up; // @[Top.scala 216:22]
  wire  n255_valid_down; // @[Top.scala 216:22]
  wire [7:0] n255_I_0_0; // @[Top.scala 216:22]
  wire [7:0] n255_I_0_1; // @[Top.scala 216:22]
  wire [7:0] n255_I_1_0; // @[Top.scala 216:22]
  wire [7:0] n255_I_1_1; // @[Top.scala 216:22]
  wire [7:0] n255_O_0; // @[Top.scala 216:22]
  wire  n256_valid_up; // @[Top.scala 219:22]
  wire  n256_valid_down; // @[Top.scala 219:22]
  wire [7:0] n256_I_0; // @[Top.scala 219:22]
  wire [7:0] n256_O_0; // @[Top.scala 219:22]
  wire  n257_valid_up; // @[Top.scala 222:22]
  wire  n257_valid_down; // @[Top.scala 222:22]
  wire [7:0] n257_I_0; // @[Top.scala 222:22]
  wire [7:0] n257_O_0; // @[Top.scala 222:22]
  wire  n258_clock; // @[Top.scala 225:22]
  wire  n258_reset; // @[Top.scala 225:22]
  wire  n258_valid_up; // @[Top.scala 225:22]
  wire  n258_valid_down; // @[Top.scala 225:22]
  wire [7:0] n258_I_0; // @[Top.scala 225:22]
  wire [7:0] n258_O_0; // @[Top.scala 225:22]
  wire  n259_clock; // @[Top.scala 228:22]
  wire  n259_reset; // @[Top.scala 228:22]
  wire  n259_valid_up; // @[Top.scala 228:22]
  wire  n259_valid_down; // @[Top.scala 228:22]
  wire [7:0] n259_I_0; // @[Top.scala 228:22]
  wire [7:0] n259_O_0; // @[Top.scala 228:22]
  wire  n260_clock; // @[Top.scala 231:22]
  wire  n260_reset; // @[Top.scala 231:22]
  wire  n260_valid_up; // @[Top.scala 231:22]
  wire  n260_valid_down; // @[Top.scala 231:22]
  wire [7:0] n260_I_0; // @[Top.scala 231:22]
  wire [7:0] n260_O_0; // @[Top.scala 231:22]
  FIFO n1 ( // @[Top.scala 85:20]
    .clock(n1_clock),
    .reset(n1_reset),
    .valid_up(n1_valid_up),
    .valid_down(n1_valid_down),
    .I_0(n1_I_0),
    .O_0(n1_O_0)
  );
  ShiftT n2 ( // @[Top.scala 88:20]
    .clock(n2_clock),
    .reset(n2_reset),
    .valid_up(n2_valid_up),
    .valid_down(n2_valid_down),
    .I_0(n2_I_0),
    .O_0(n2_O_0)
  );
  ShiftT n3 ( // @[Top.scala 91:20]
    .clock(n3_clock),
    .reset(n3_reset),
    .valid_up(n3_valid_up),
    .valid_down(n3_valid_down),
    .I_0(n3_I_0),
    .O_0(n3_O_0)
  );
  ShiftT_2 n4 ( // @[Top.scala 94:20]
    .clock(n4_clock),
    .valid_up(n4_valid_up),
    .valid_down(n4_valid_down),
    .I_0(n4_I_0),
    .O_0(n4_O_0)
  );
  ShiftT_2 n5 ( // @[Top.scala 97:20]
    .clock(n5_clock),
    .valid_up(n5_valid_up),
    .valid_down(n5_valid_down),
    .I_0(n5_I_0),
    .O_0(n5_O_0)
  );
  Map2T n6 ( // @[Top.scala 100:20]
    .valid_up(n6_valid_up),
    .valid_down(n6_valid_down),
    .I0_0(n6_I0_0),
    .I1_0(n6_I1_0),
    .O_0_0(n6_O_0_0),
    .O_0_1(n6_O_0_1)
  );
  Map2T_1 n13 ( // @[Top.scala 104:21]
    .valid_up(n13_valid_up),
    .valid_down(n13_valid_down),
    .I0_0_0(n13_I0_0_0),
    .I0_0_1(n13_I0_0_1),
    .I1_0(n13_I1_0),
    .O_0_0(n13_O_0_0),
    .O_0_1(n13_O_0_1),
    .O_0_2(n13_O_0_2)
  );
  MapT n22 ( // @[Top.scala 108:21]
    .valid_up(n22_valid_up),
    .valid_down(n22_valid_down),
    .I_0_0(n22_I_0_0),
    .I_0_1(n22_I_0_1),
    .I_0_2(n22_I_0_2),
    .O_0_0_0(n22_O_0_0_0),
    .O_0_0_1(n22_O_0_0_1),
    .O_0_0_2(n22_O_0_0_2)
  );
  MapT_1 n29 ( // @[Top.scala 111:21]
    .valid_up(n29_valid_up),
    .valid_down(n29_valid_down),
    .I_0_0_0(n29_I_0_0_0),
    .I_0_0_1(n29_I_0_0_1),
    .I_0_0_2(n29_I_0_0_2),
    .O_0_0(n29_O_0_0),
    .O_0_1(n29_O_0_1),
    .O_0_2(n29_O_0_2)
  );
  ShiftT_2 n30 ( // @[Top.scala 114:21]
    .clock(n30_clock),
    .valid_up(n30_valid_up),
    .valid_down(n30_valid_down),
    .I_0(n30_I_0),
    .O_0(n30_O_0)
  );
  ShiftT_2 n31 ( // @[Top.scala 117:21]
    .clock(n31_clock),
    .valid_up(n31_valid_up),
    .valid_down(n31_valid_down),
    .I_0(n31_I_0),
    .O_0(n31_O_0)
  );
  Map2T n32 ( // @[Top.scala 120:21]
    .valid_up(n32_valid_up),
    .valid_down(n32_valid_down),
    .I0_0(n32_I0_0),
    .I1_0(n32_I1_0),
    .O_0_0(n32_O_0_0),
    .O_0_1(n32_O_0_1)
  );
  Map2T_1 n39 ( // @[Top.scala 124:21]
    .valid_up(n39_valid_up),
    .valid_down(n39_valid_down),
    .I0_0_0(n39_I0_0_0),
    .I0_0_1(n39_I0_0_1),
    .I1_0(n39_I1_0),
    .O_0_0(n39_O_0_0),
    .O_0_1(n39_O_0_1),
    .O_0_2(n39_O_0_2)
  );
  MapT n48 ( // @[Top.scala 128:21]
    .valid_up(n48_valid_up),
    .valid_down(n48_valid_down),
    .I_0_0(n48_I_0_0),
    .I_0_1(n48_I_0_1),
    .I_0_2(n48_I_0_2),
    .O_0_0_0(n48_O_0_0_0),
    .O_0_0_1(n48_O_0_0_1),
    .O_0_0_2(n48_O_0_0_2)
  );
  MapT_1 n55 ( // @[Top.scala 131:21]
    .valid_up(n55_valid_up),
    .valid_down(n55_valid_down),
    .I_0_0_0(n55_I_0_0_0),
    .I_0_0_1(n55_I_0_0_1),
    .I_0_0_2(n55_I_0_0_2),
    .O_0_0(n55_O_0_0),
    .O_0_1(n55_O_0_1),
    .O_0_2(n55_O_0_2)
  );
  Map2T_4 n56 ( // @[Top.scala 134:21]
    .valid_up(n56_valid_up),
    .valid_down(n56_valid_down),
    .I0_0_0(n56_I0_0_0),
    .I0_0_1(n56_I0_0_1),
    .I0_0_2(n56_I0_0_2),
    .I1_0_0(n56_I1_0_0),
    .I1_0_1(n56_I1_0_1),
    .I1_0_2(n56_I1_0_2),
    .O_0_0_0(n56_O_0_0_0),
    .O_0_0_1(n56_O_0_0_1),
    .O_0_0_2(n56_O_0_0_2),
    .O_0_1_0(n56_O_0_1_0),
    .O_0_1_1(n56_O_0_1_1),
    .O_0_1_2(n56_O_0_1_2)
  );
  ShiftT_2 n63 ( // @[Top.scala 138:21]
    .clock(n63_clock),
    .valid_up(n63_valid_up),
    .valid_down(n63_valid_down),
    .I_0(n63_I_0),
    .O_0(n63_O_0)
  );
  ShiftT_2 n64 ( // @[Top.scala 141:21]
    .clock(n64_clock),
    .valid_up(n64_valid_up),
    .valid_down(n64_valid_down),
    .I_0(n64_I_0),
    .O_0(n64_O_0)
  );
  Map2T n65 ( // @[Top.scala 144:21]
    .valid_up(n65_valid_up),
    .valid_down(n65_valid_down),
    .I0_0(n65_I0_0),
    .I1_0(n65_I1_0),
    .O_0_0(n65_O_0_0),
    .O_0_1(n65_O_0_1)
  );
  Map2T_1 n72 ( // @[Top.scala 148:21]
    .valid_up(n72_valid_up),
    .valid_down(n72_valid_down),
    .I0_0_0(n72_I0_0_0),
    .I0_0_1(n72_I0_0_1),
    .I1_0(n72_I1_0),
    .O_0_0(n72_O_0_0),
    .O_0_1(n72_O_0_1),
    .O_0_2(n72_O_0_2)
  );
  MapT n81 ( // @[Top.scala 152:21]
    .valid_up(n81_valid_up),
    .valid_down(n81_valid_down),
    .I_0_0(n81_I_0_0),
    .I_0_1(n81_I_0_1),
    .I_0_2(n81_I_0_2),
    .O_0_0_0(n81_O_0_0_0),
    .O_0_0_1(n81_O_0_0_1),
    .O_0_0_2(n81_O_0_0_2)
  );
  MapT_1 n88 ( // @[Top.scala 155:21]
    .valid_up(n88_valid_up),
    .valid_down(n88_valid_down),
    .I_0_0_0(n88_I_0_0_0),
    .I_0_0_1(n88_I_0_0_1),
    .I_0_0_2(n88_I_0_0_2),
    .O_0_0(n88_O_0_0),
    .O_0_1(n88_O_0_1),
    .O_0_2(n88_O_0_2)
  );
  Map2T_7 n89 ( // @[Top.scala 158:21]
    .valid_up(n89_valid_up),
    .valid_down(n89_valid_down),
    .I0_0_0_0(n89_I0_0_0_0),
    .I0_0_0_1(n89_I0_0_0_1),
    .I0_0_0_2(n89_I0_0_0_2),
    .I0_0_1_0(n89_I0_0_1_0),
    .I0_0_1_1(n89_I0_0_1_1),
    .I0_0_1_2(n89_I0_0_1_2),
    .I1_0_0(n89_I1_0_0),
    .I1_0_1(n89_I1_0_1),
    .I1_0_2(n89_I1_0_2),
    .O_0_0_0(n89_O_0_0_0),
    .O_0_0_1(n89_O_0_0_1),
    .O_0_0_2(n89_O_0_0_2),
    .O_0_1_0(n89_O_0_1_0),
    .O_0_1_1(n89_O_0_1_1),
    .O_0_1_2(n89_O_0_1_2),
    .O_0_2_0(n89_O_0_2_0),
    .O_0_2_1(n89_O_0_2_1),
    .O_0_2_2(n89_O_0_2_2)
  );
  Passthrough n96 ( // @[Top.scala 162:21]
    .valid_up(n96_valid_up),
    .valid_down(n96_valid_down),
    .I_0_0_0(n96_I_0_0_0),
    .I_0_0_1(n96_I_0_0_1),
    .I_0_0_2(n96_I_0_0_2),
    .I_0_1_0(n96_I_0_1_0),
    .I_0_1_1(n96_I_0_1_1),
    .I_0_1_2(n96_I_0_1_2),
    .I_0_2_0(n96_I_0_2_0),
    .I_0_2_1(n96_I_0_2_1),
    .I_0_2_2(n96_I_0_2_2),
    .O_0_0_0(n96_O_0_0_0),
    .O_0_0_1(n96_O_0_0_1),
    .O_0_0_2(n96_O_0_0_2),
    .O_0_1_0(n96_O_0_1_0),
    .O_0_1_1(n96_O_0_1_1),
    .O_0_1_2(n96_O_0_1_2),
    .O_0_2_0(n96_O_0_2_0),
    .O_0_2_1(n96_O_0_2_1),
    .O_0_2_2(n96_O_0_2_2)
  );
  MapT_6 n99 ( // @[Top.scala 165:21]
    .valid_up(n99_valid_up),
    .valid_down(n99_valid_down),
    .I_0_0_0(n99_I_0_0_0),
    .I_0_0_1(n99_I_0_0_1),
    .I_0_0_2(n99_I_0_0_2),
    .I_0_1_0(n99_I_0_1_0),
    .I_0_1_1(n99_I_0_1_1),
    .I_0_1_2(n99_I_0_1_2),
    .I_0_2_0(n99_I_0_2_0),
    .I_0_2_1(n99_I_0_2_1),
    .I_0_2_2(n99_I_0_2_2),
    .O_0_0(n99_O_0_0),
    .O_0_1(n99_O_0_1),
    .O_0_2(n99_O_0_2),
    .O_1_0(n99_O_1_0),
    .O_1_1(n99_O_1_1),
    .O_1_2(n99_O_1_2),
    .O_2_0(n99_O_2_0),
    .O_2_1(n99_O_2_1),
    .O_2_2(n99_O_2_2)
  );
  MapT_11 n152 ( // @[Top.scala 168:22]
    .clock(n152_clock),
    .reset(n152_reset),
    .valid_up(n152_valid_up),
    .valid_down(n152_valid_down),
    .I_0_0(n152_I_0_0),
    .I_0_1(n152_I_0_1),
    .I_0_2(n152_I_0_2),
    .I_1_0(n152_I_1_0),
    .I_1_1(n152_I_1_1),
    .I_1_2(n152_I_1_2),
    .I_2_0(n152_I_2_0),
    .I_2_1(n152_I_2_1),
    .I_2_2(n152_I_2_2),
    .O_0(n152_O_0)
  );
  Passthrough_3 n153 ( // @[Top.scala 171:22]
    .valid_up(n153_valid_up),
    .valid_down(n153_valid_down),
    .I_0(n153_I_0),
    .O_0(n153_O_0)
  );
  Passthrough_3 n154 ( // @[Top.scala 174:22]
    .valid_up(n154_valid_up),
    .valid_down(n154_valid_down),
    .I_0(n154_I_0),
    .O_0(n154_O_0)
  );
  ShiftT n155 ( // @[Top.scala 177:22]
    .clock(n155_clock),
    .reset(n155_reset),
    .valid_up(n155_valid_up),
    .valid_down(n155_valid_down),
    .I_0(n155_I_0),
    .O_0(n155_O_0)
  );
  ShiftT_2 n156 ( // @[Top.scala 180:22]
    .clock(n156_clock),
    .valid_up(n156_valid_up),
    .valid_down(n156_valid_down),
    .I_0(n156_I_0),
    .O_0(n156_O_0)
  );
  Map2T n157 ( // @[Top.scala 183:22]
    .valid_up(n157_valid_up),
    .valid_down(n157_valid_down),
    .I0_0(n157_I0_0),
    .I1_0(n157_I1_0),
    .O_0_0(n157_O_0_0),
    .O_0_1(n157_O_0_1)
  );
  MapT_12 n166 ( // @[Top.scala 187:22]
    .valid_up(n166_valid_up),
    .valid_down(n166_valid_down),
    .I_0_0(n166_I_0_0),
    .I_0_1(n166_I_0_1),
    .O_0_0_0(n166_O_0_0_0),
    .O_0_0_1(n166_O_0_0_1)
  );
  MapT_13 n173 ( // @[Top.scala 190:22]
    .valid_up(n173_valid_up),
    .valid_down(n173_valid_down),
    .I_0_0_0(n173_I_0_0_0),
    .I_0_0_1(n173_I_0_0_1),
    .O_0_0(n173_O_0_0),
    .O_0_1(n173_O_0_1)
  );
  ShiftT_2 n174 ( // @[Top.scala 193:22]
    .clock(n174_clock),
    .valid_up(n174_valid_up),
    .valid_down(n174_valid_down),
    .I_0(n174_I_0),
    .O_0(n174_O_0)
  );
  Map2T n175 ( // @[Top.scala 196:22]
    .valid_up(n175_valid_up),
    .valid_down(n175_valid_down),
    .I0_0(n175_I0_0),
    .I1_0(n175_I1_0),
    .O_0_0(n175_O_0_0),
    .O_0_1(n175_O_0_1)
  );
  MapT_12 n184 ( // @[Top.scala 200:22]
    .valid_up(n184_valid_up),
    .valid_down(n184_valid_down),
    .I_0_0(n184_I_0_0),
    .I_0_1(n184_I_0_1),
    .O_0_0_0(n184_O_0_0_0),
    .O_0_0_1(n184_O_0_0_1)
  );
  MapT_13 n191 ( // @[Top.scala 203:22]
    .valid_up(n191_valid_up),
    .valid_down(n191_valid_down),
    .I_0_0_0(n191_I_0_0_0),
    .I_0_0_1(n191_I_0_0_1),
    .O_0_0(n191_O_0_0),
    .O_0_1(n191_O_0_1)
  );
  Map2T_12 n192 ( // @[Top.scala 206:22]
    .valid_up(n192_valid_up),
    .valid_down(n192_valid_down),
    .I0_0_0(n192_I0_0_0),
    .I0_0_1(n192_I0_0_1),
    .I1_0_0(n192_I1_0_0),
    .I1_0_1(n192_I1_0_1),
    .O_0_0_0(n192_O_0_0_0),
    .O_0_0_1(n192_O_0_0_1),
    .O_0_1_0(n192_O_0_1_0),
    .O_0_1_1(n192_O_0_1_1)
  );
  Passthrough_5 n199 ( // @[Top.scala 210:22]
    .valid_up(n199_valid_up),
    .valid_down(n199_valid_down),
    .I_0_0_0(n199_I_0_0_0),
    .I_0_0_1(n199_I_0_0_1),
    .I_0_1_0(n199_I_0_1_0),
    .I_0_1_1(n199_I_0_1_1),
    .O_0_0_0(n199_O_0_0_0),
    .O_0_0_1(n199_O_0_0_1),
    .O_0_1_0(n199_O_0_1_0),
    .O_0_1_1(n199_O_0_1_1)
  );
  MapT_16 n202 ( // @[Top.scala 213:22]
    .valid_up(n202_valid_up),
    .valid_down(n202_valid_down),
    .I_0_0_0(n202_I_0_0_0),
    .I_0_0_1(n202_I_0_0_1),
    .I_0_1_0(n202_I_0_1_0),
    .I_0_1_1(n202_I_0_1_1),
    .O_0_0(n202_O_0_0),
    .O_0_1(n202_O_0_1),
    .O_1_0(n202_O_1_0),
    .O_1_1(n202_O_1_1)
  );
  MapT_21 n255 ( // @[Top.scala 216:22]
    .clock(n255_clock),
    .reset(n255_reset),
    .valid_up(n255_valid_up),
    .valid_down(n255_valid_down),
    .I_0_0(n255_I_0_0),
    .I_0_1(n255_I_0_1),
    .I_1_0(n255_I_1_0),
    .I_1_1(n255_I_1_1),
    .O_0(n255_O_0)
  );
  Passthrough_3 n256 ( // @[Top.scala 219:22]
    .valid_up(n256_valid_up),
    .valid_down(n256_valid_down),
    .I_0(n256_I_0),
    .O_0(n256_O_0)
  );
  Passthrough_3 n257 ( // @[Top.scala 222:22]
    .valid_up(n257_valid_up),
    .valid_down(n257_valid_down),
    .I_0(n257_I_0),
    .O_0(n257_O_0)
  );
  FIFO n258 ( // @[Top.scala 225:22]
    .clock(n258_clock),
    .reset(n258_reset),
    .valid_up(n258_valid_up),
    .valid_down(n258_valid_down),
    .I_0(n258_I_0),
    .O_0(n258_O_0)
  );
  FIFO n259 ( // @[Top.scala 228:22]
    .clock(n259_clock),
    .reset(n259_reset),
    .valid_up(n259_valid_up),
    .valid_down(n259_valid_down),
    .I_0(n259_I_0),
    .O_0(n259_O_0)
  );
  FIFO n260 ( // @[Top.scala 231:22]
    .clock(n260_clock),
    .reset(n260_reset),
    .valid_up(n260_valid_up),
    .valid_down(n260_valid_down),
    .I_0(n260_I_0),
    .O_0(n260_O_0)
  );
  assign valid_down = n260_valid_down; // @[Top.scala 235:16]
  assign O_0 = n260_O_0; // @[Top.scala 234:7]
  assign n1_clock = clock;
  assign n1_reset = reset;
  assign n1_valid_up = valid_up; // @[Top.scala 87:17]
  assign n1_I_0 = I_0; // @[Top.scala 86:10]
  assign n2_clock = clock;
  assign n2_reset = reset;
  assign n2_valid_up = n1_valid_down; // @[Top.scala 90:17]
  assign n2_I_0 = n1_O_0; // @[Top.scala 89:10]
  assign n3_clock = clock;
  assign n3_reset = reset;
  assign n3_valid_up = n2_valid_down; // @[Top.scala 93:17]
  assign n3_I_0 = n2_O_0; // @[Top.scala 92:10]
  assign n4_clock = clock;
  assign n4_valid_up = n3_valid_down; // @[Top.scala 96:17]
  assign n4_I_0 = n3_O_0; // @[Top.scala 95:10]
  assign n5_clock = clock;
  assign n5_valid_up = n4_valid_down; // @[Top.scala 99:17]
  assign n5_I_0 = n4_O_0; // @[Top.scala 98:10]
  assign n6_valid_up = n5_valid_down & n4_valid_down; // @[Top.scala 103:17]
  assign n6_I0_0 = n5_O_0; // @[Top.scala 101:11]
  assign n6_I1_0 = n4_O_0; // @[Top.scala 102:11]
  assign n13_valid_up = n6_valid_down & n3_valid_down; // @[Top.scala 107:18]
  assign n13_I0_0_0 = n6_O_0_0; // @[Top.scala 105:12]
  assign n13_I0_0_1 = n6_O_0_1; // @[Top.scala 105:12]
  assign n13_I1_0 = n3_O_0; // @[Top.scala 106:12]
  assign n22_valid_up = n13_valid_down; // @[Top.scala 110:18]
  assign n22_I_0_0 = n13_O_0_0; // @[Top.scala 109:11]
  assign n22_I_0_1 = n13_O_0_1; // @[Top.scala 109:11]
  assign n22_I_0_2 = n13_O_0_2; // @[Top.scala 109:11]
  assign n29_valid_up = n22_valid_down; // @[Top.scala 113:18]
  assign n29_I_0_0_0 = n22_O_0_0_0; // @[Top.scala 112:11]
  assign n29_I_0_0_1 = n22_O_0_0_1; // @[Top.scala 112:11]
  assign n29_I_0_0_2 = n22_O_0_0_2; // @[Top.scala 112:11]
  assign n30_clock = clock;
  assign n30_valid_up = n2_valid_down; // @[Top.scala 116:18]
  assign n30_I_0 = n2_O_0; // @[Top.scala 115:11]
  assign n31_clock = clock;
  assign n31_valid_up = n30_valid_down; // @[Top.scala 119:18]
  assign n31_I_0 = n30_O_0; // @[Top.scala 118:11]
  assign n32_valid_up = n31_valid_down & n30_valid_down; // @[Top.scala 123:18]
  assign n32_I0_0 = n31_O_0; // @[Top.scala 121:12]
  assign n32_I1_0 = n30_O_0; // @[Top.scala 122:12]
  assign n39_valid_up = n32_valid_down & n2_valid_down; // @[Top.scala 127:18]
  assign n39_I0_0_0 = n32_O_0_0; // @[Top.scala 125:12]
  assign n39_I0_0_1 = n32_O_0_1; // @[Top.scala 125:12]
  assign n39_I1_0 = n2_O_0; // @[Top.scala 126:12]
  assign n48_valid_up = n39_valid_down; // @[Top.scala 130:18]
  assign n48_I_0_0 = n39_O_0_0; // @[Top.scala 129:11]
  assign n48_I_0_1 = n39_O_0_1; // @[Top.scala 129:11]
  assign n48_I_0_2 = n39_O_0_2; // @[Top.scala 129:11]
  assign n55_valid_up = n48_valid_down; // @[Top.scala 133:18]
  assign n55_I_0_0_0 = n48_O_0_0_0; // @[Top.scala 132:11]
  assign n55_I_0_0_1 = n48_O_0_0_1; // @[Top.scala 132:11]
  assign n55_I_0_0_2 = n48_O_0_0_2; // @[Top.scala 132:11]
  assign n56_valid_up = n29_valid_down & n55_valid_down; // @[Top.scala 137:18]
  assign n56_I0_0_0 = n29_O_0_0; // @[Top.scala 135:12]
  assign n56_I0_0_1 = n29_O_0_1; // @[Top.scala 135:12]
  assign n56_I0_0_2 = n29_O_0_2; // @[Top.scala 135:12]
  assign n56_I1_0_0 = n55_O_0_0; // @[Top.scala 136:12]
  assign n56_I1_0_1 = n55_O_0_1; // @[Top.scala 136:12]
  assign n56_I1_0_2 = n55_O_0_2; // @[Top.scala 136:12]
  assign n63_clock = clock;
  assign n63_valid_up = n1_valid_down; // @[Top.scala 140:18]
  assign n63_I_0 = n1_O_0; // @[Top.scala 139:11]
  assign n64_clock = clock;
  assign n64_valid_up = n63_valid_down; // @[Top.scala 143:18]
  assign n64_I_0 = n63_O_0; // @[Top.scala 142:11]
  assign n65_valid_up = n64_valid_down & n63_valid_down; // @[Top.scala 147:18]
  assign n65_I0_0 = n64_O_0; // @[Top.scala 145:12]
  assign n65_I1_0 = n63_O_0; // @[Top.scala 146:12]
  assign n72_valid_up = n65_valid_down & n1_valid_down; // @[Top.scala 151:18]
  assign n72_I0_0_0 = n65_O_0_0; // @[Top.scala 149:12]
  assign n72_I0_0_1 = n65_O_0_1; // @[Top.scala 149:12]
  assign n72_I1_0 = n1_O_0; // @[Top.scala 150:12]
  assign n81_valid_up = n72_valid_down; // @[Top.scala 154:18]
  assign n81_I_0_0 = n72_O_0_0; // @[Top.scala 153:11]
  assign n81_I_0_1 = n72_O_0_1; // @[Top.scala 153:11]
  assign n81_I_0_2 = n72_O_0_2; // @[Top.scala 153:11]
  assign n88_valid_up = n81_valid_down; // @[Top.scala 157:18]
  assign n88_I_0_0_0 = n81_O_0_0_0; // @[Top.scala 156:11]
  assign n88_I_0_0_1 = n81_O_0_0_1; // @[Top.scala 156:11]
  assign n88_I_0_0_2 = n81_O_0_0_2; // @[Top.scala 156:11]
  assign n89_valid_up = n56_valid_down & n88_valid_down; // @[Top.scala 161:18]
  assign n89_I0_0_0_0 = n56_O_0_0_0; // @[Top.scala 159:12]
  assign n89_I0_0_0_1 = n56_O_0_0_1; // @[Top.scala 159:12]
  assign n89_I0_0_0_2 = n56_O_0_0_2; // @[Top.scala 159:12]
  assign n89_I0_0_1_0 = n56_O_0_1_0; // @[Top.scala 159:12]
  assign n89_I0_0_1_1 = n56_O_0_1_1; // @[Top.scala 159:12]
  assign n89_I0_0_1_2 = n56_O_0_1_2; // @[Top.scala 159:12]
  assign n89_I1_0_0 = n88_O_0_0; // @[Top.scala 160:12]
  assign n89_I1_0_1 = n88_O_0_1; // @[Top.scala 160:12]
  assign n89_I1_0_2 = n88_O_0_2; // @[Top.scala 160:12]
  assign n96_valid_up = n89_valid_down; // @[Top.scala 164:18]
  assign n96_I_0_0_0 = n89_O_0_0_0; // @[Top.scala 163:11]
  assign n96_I_0_0_1 = n89_O_0_0_1; // @[Top.scala 163:11]
  assign n96_I_0_0_2 = n89_O_0_0_2; // @[Top.scala 163:11]
  assign n96_I_0_1_0 = n89_O_0_1_0; // @[Top.scala 163:11]
  assign n96_I_0_1_1 = n89_O_0_1_1; // @[Top.scala 163:11]
  assign n96_I_0_1_2 = n89_O_0_1_2; // @[Top.scala 163:11]
  assign n96_I_0_2_0 = n89_O_0_2_0; // @[Top.scala 163:11]
  assign n96_I_0_2_1 = n89_O_0_2_1; // @[Top.scala 163:11]
  assign n96_I_0_2_2 = n89_O_0_2_2; // @[Top.scala 163:11]
  assign n99_valid_up = n96_valid_down; // @[Top.scala 167:18]
  assign n99_I_0_0_0 = n96_O_0_0_0; // @[Top.scala 166:11]
  assign n99_I_0_0_1 = n96_O_0_0_1; // @[Top.scala 166:11]
  assign n99_I_0_0_2 = n96_O_0_0_2; // @[Top.scala 166:11]
  assign n99_I_0_1_0 = n96_O_0_1_0; // @[Top.scala 166:11]
  assign n99_I_0_1_1 = n96_O_0_1_1; // @[Top.scala 166:11]
  assign n99_I_0_1_2 = n96_O_0_1_2; // @[Top.scala 166:11]
  assign n99_I_0_2_0 = n96_O_0_2_0; // @[Top.scala 166:11]
  assign n99_I_0_2_1 = n96_O_0_2_1; // @[Top.scala 166:11]
  assign n99_I_0_2_2 = n96_O_0_2_2; // @[Top.scala 166:11]
  assign n152_clock = clock;
  assign n152_reset = reset;
  assign n152_valid_up = n99_valid_down; // @[Top.scala 170:19]
  assign n152_I_0_0 = n99_O_0_0; // @[Top.scala 169:12]
  assign n152_I_0_1 = n99_O_0_1; // @[Top.scala 169:12]
  assign n152_I_0_2 = n99_O_0_2; // @[Top.scala 169:12]
  assign n152_I_1_0 = n99_O_1_0; // @[Top.scala 169:12]
  assign n152_I_1_1 = n99_O_1_1; // @[Top.scala 169:12]
  assign n152_I_1_2 = n99_O_1_2; // @[Top.scala 169:12]
  assign n152_I_2_0 = n99_O_2_0; // @[Top.scala 169:12]
  assign n152_I_2_1 = n99_O_2_1; // @[Top.scala 169:12]
  assign n152_I_2_2 = n99_O_2_2; // @[Top.scala 169:12]
  assign n153_valid_up = n152_valid_down; // @[Top.scala 173:19]
  assign n153_I_0 = n152_O_0; // @[Top.scala 172:12]
  assign n154_valid_up = n153_valid_down; // @[Top.scala 176:19]
  assign n154_I_0 = n153_O_0; // @[Top.scala 175:12]
  assign n155_clock = clock;
  assign n155_reset = reset;
  assign n155_valid_up = n154_valid_down; // @[Top.scala 179:19]
  assign n155_I_0 = n154_O_0; // @[Top.scala 178:12]
  assign n156_clock = clock;
  assign n156_valid_up = n155_valid_down; // @[Top.scala 182:19]
  assign n156_I_0 = n155_O_0; // @[Top.scala 181:12]
  assign n157_valid_up = n156_valid_down & n155_valid_down; // @[Top.scala 186:19]
  assign n157_I0_0 = n156_O_0; // @[Top.scala 184:13]
  assign n157_I1_0 = n155_O_0; // @[Top.scala 185:13]
  assign n166_valid_up = n157_valid_down; // @[Top.scala 189:19]
  assign n166_I_0_0 = n157_O_0_0; // @[Top.scala 188:12]
  assign n166_I_0_1 = n157_O_0_1; // @[Top.scala 188:12]
  assign n173_valid_up = n166_valid_down; // @[Top.scala 192:19]
  assign n173_I_0_0_0 = n166_O_0_0_0; // @[Top.scala 191:12]
  assign n173_I_0_0_1 = n166_O_0_0_1; // @[Top.scala 191:12]
  assign n174_clock = clock;
  assign n174_valid_up = n154_valid_down; // @[Top.scala 195:19]
  assign n174_I_0 = n154_O_0; // @[Top.scala 194:12]
  assign n175_valid_up = n174_valid_down & n154_valid_down; // @[Top.scala 199:19]
  assign n175_I0_0 = n174_O_0; // @[Top.scala 197:13]
  assign n175_I1_0 = n154_O_0; // @[Top.scala 198:13]
  assign n184_valid_up = n175_valid_down; // @[Top.scala 202:19]
  assign n184_I_0_0 = n175_O_0_0; // @[Top.scala 201:12]
  assign n184_I_0_1 = n175_O_0_1; // @[Top.scala 201:12]
  assign n191_valid_up = n184_valid_down; // @[Top.scala 205:19]
  assign n191_I_0_0_0 = n184_O_0_0_0; // @[Top.scala 204:12]
  assign n191_I_0_0_1 = n184_O_0_0_1; // @[Top.scala 204:12]
  assign n192_valid_up = n173_valid_down & n191_valid_down; // @[Top.scala 209:19]
  assign n192_I0_0_0 = n173_O_0_0; // @[Top.scala 207:13]
  assign n192_I0_0_1 = n173_O_0_1; // @[Top.scala 207:13]
  assign n192_I1_0_0 = n191_O_0_0; // @[Top.scala 208:13]
  assign n192_I1_0_1 = n191_O_0_1; // @[Top.scala 208:13]
  assign n199_valid_up = n192_valid_down; // @[Top.scala 212:19]
  assign n199_I_0_0_0 = n192_O_0_0_0; // @[Top.scala 211:12]
  assign n199_I_0_0_1 = n192_O_0_0_1; // @[Top.scala 211:12]
  assign n199_I_0_1_0 = n192_O_0_1_0; // @[Top.scala 211:12]
  assign n199_I_0_1_1 = n192_O_0_1_1; // @[Top.scala 211:12]
  assign n202_valid_up = n199_valid_down; // @[Top.scala 215:19]
  assign n202_I_0_0_0 = n199_O_0_0_0; // @[Top.scala 214:12]
  assign n202_I_0_0_1 = n199_O_0_0_1; // @[Top.scala 214:12]
  assign n202_I_0_1_0 = n199_O_0_1_0; // @[Top.scala 214:12]
  assign n202_I_0_1_1 = n199_O_0_1_1; // @[Top.scala 214:12]
  assign n255_clock = clock;
  assign n255_reset = reset;
  assign n255_valid_up = n202_valid_down; // @[Top.scala 218:19]
  assign n255_I_0_0 = n202_O_0_0; // @[Top.scala 217:12]
  assign n255_I_0_1 = n202_O_0_1; // @[Top.scala 217:12]
  assign n255_I_1_0 = n202_O_1_0; // @[Top.scala 217:12]
  assign n255_I_1_1 = n202_O_1_1; // @[Top.scala 217:12]
  assign n256_valid_up = n255_valid_down; // @[Top.scala 221:19]
  assign n256_I_0 = n255_O_0; // @[Top.scala 220:12]
  assign n257_valid_up = n256_valid_down; // @[Top.scala 224:19]
  assign n257_I_0 = n256_O_0; // @[Top.scala 223:12]
  assign n258_clock = clock;
  assign n258_reset = reset;
  assign n258_valid_up = n257_valid_down; // @[Top.scala 227:19]
  assign n258_I_0 = n257_O_0; // @[Top.scala 226:12]
  assign n259_clock = clock;
  assign n259_reset = reset;
  assign n259_valid_up = n258_valid_down; // @[Top.scala 230:19]
  assign n259_I_0 = n258_O_0; // @[Top.scala 229:12]
  assign n260_clock = clock;
  assign n260_reset = reset;
  assign n260_valid_up = n259_valid_down; // @[Top.scala 233:19]
  assign n260_I_0 = n259_O_0; // @[Top.scala 232:12]
endmodule
