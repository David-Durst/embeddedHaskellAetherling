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
  Remove1S_3 op ( // @[MapT.scala 8:20]
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
  assign MapSNoValid_I_0_t0b = I_1_0; // @[ReduceS.scala 43:18]
  assign MapSNoValid_I_0_t1b = MapSNoValid_1_O_0; // @[ReduceS.scala 36:18]
  assign MapSNoValid_1_I_0_t0b = I_0_0; // @[ReduceS.scala 43:18]
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
module Map2S_11(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0_0,
  input  [7:0] I1_0_0,
  output [7:0] O_0_0_t0b,
  output [7:0] O_0_0_t1b
);
  wire  fst_op_valid_up; // @[Map2S.scala 9:22]
  wire  fst_op_valid_down; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I0_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_I1_0; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_t0b; // @[Map2S.scala 9:22]
  wire [7:0] fst_op_O_0_t1b; // @[Map2S.scala 9:22]
  Map2S_10 fst_op ( // @[Map2S.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I0_0(fst_op_I0_0),
    .I1_0(fst_op_I1_0),
    .O_0_t0b(fst_op_O_0_t0b),
    .O_0_t1b(fst_op_O_0_t1b)
  );
  assign valid_down = fst_op_valid_down; // @[Map2S.scala 26:14]
  assign O_0_0_t0b = fst_op_O_0_t0b; // @[Map2S.scala 19:8]
  assign O_0_0_t1b = fst_op_O_0_t1b; // @[Map2S.scala 19:8]
  assign fst_op_valid_up = valid_up; // @[Map2S.scala 16:19]
  assign fst_op_I0_0 = I0_0_0; // @[Map2S.scala 17:13]
  assign fst_op_I1_0 = I1_0_0; // @[Map2S.scala 18:13]
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
module MapS_7(
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
  MapS_6 fst_op ( // @[MapS.scala 9:22]
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
  wire  n104_valid_up; // @[Top.scala 16:22]
  wire  n104_valid_down; // @[Top.scala 16:22]
  wire [7:0] n104_I0_0_0; // @[Top.scala 16:22]
  wire [7:0] n104_I0_0_1; // @[Top.scala 16:22]
  wire [7:0] n104_I0_0_2; // @[Top.scala 16:22]
  wire [7:0] n104_I0_1_0; // @[Top.scala 16:22]
  wire [7:0] n104_I0_1_1; // @[Top.scala 16:22]
  wire [7:0] n104_I0_1_2; // @[Top.scala 16:22]
  wire [7:0] n104_I0_2_0; // @[Top.scala 16:22]
  wire [7:0] n104_I0_2_1; // @[Top.scala 16:22]
  wire [7:0] n104_I0_2_2; // @[Top.scala 16:22]
  wire [7:0] n104_O_0_0_t0b; // @[Top.scala 16:22]
  wire [7:0] n104_O_0_0_t1b; // @[Top.scala 16:22]
  wire [7:0] n104_O_0_1_t0b; // @[Top.scala 16:22]
  wire [7:0] n104_O_0_1_t1b; // @[Top.scala 16:22]
  wire [7:0] n104_O_0_2_t0b; // @[Top.scala 16:22]
  wire [7:0] n104_O_0_2_t1b; // @[Top.scala 16:22]
  wire [7:0] n104_O_1_0_t0b; // @[Top.scala 16:22]
  wire [7:0] n104_O_1_0_t1b; // @[Top.scala 16:22]
  wire [7:0] n104_O_1_1_t0b; // @[Top.scala 16:22]
  wire [7:0] n104_O_1_1_t1b; // @[Top.scala 16:22]
  wire [7:0] n104_O_1_2_t0b; // @[Top.scala 16:22]
  wire [7:0] n104_O_1_2_t1b; // @[Top.scala 16:22]
  wire [7:0] n104_O_2_0_t0b; // @[Top.scala 16:22]
  wire [7:0] n104_O_2_0_t1b; // @[Top.scala 16:22]
  wire [7:0] n104_O_2_1_t0b; // @[Top.scala 16:22]
  wire [7:0] n104_O_2_1_t1b; // @[Top.scala 16:22]
  wire [7:0] n104_O_2_2_t0b; // @[Top.scala 16:22]
  wire [7:0] n104_O_2_2_t1b; // @[Top.scala 16:22]
  wire  n115_valid_up; // @[Top.scala 20:22]
  wire  n115_valid_down; // @[Top.scala 20:22]
  wire [7:0] n115_I_0_0_t0b; // @[Top.scala 20:22]
  wire [7:0] n115_I_0_0_t1b; // @[Top.scala 20:22]
  wire [7:0] n115_I_0_1_t0b; // @[Top.scala 20:22]
  wire [7:0] n115_I_0_1_t1b; // @[Top.scala 20:22]
  wire [7:0] n115_I_0_2_t0b; // @[Top.scala 20:22]
  wire [7:0] n115_I_0_2_t1b; // @[Top.scala 20:22]
  wire [7:0] n115_I_1_0_t0b; // @[Top.scala 20:22]
  wire [7:0] n115_I_1_0_t1b; // @[Top.scala 20:22]
  wire [7:0] n115_I_1_1_t0b; // @[Top.scala 20:22]
  wire [7:0] n115_I_1_1_t1b; // @[Top.scala 20:22]
  wire [7:0] n115_I_1_2_t0b; // @[Top.scala 20:22]
  wire [7:0] n115_I_1_2_t1b; // @[Top.scala 20:22]
  wire [7:0] n115_I_2_0_t0b; // @[Top.scala 20:22]
  wire [7:0] n115_I_2_0_t1b; // @[Top.scala 20:22]
  wire [7:0] n115_I_2_1_t0b; // @[Top.scala 20:22]
  wire [7:0] n115_I_2_1_t1b; // @[Top.scala 20:22]
  wire [7:0] n115_I_2_2_t0b; // @[Top.scala 20:22]
  wire [7:0] n115_I_2_2_t1b; // @[Top.scala 20:22]
  wire [7:0] n115_O_0_0; // @[Top.scala 20:22]
  wire [7:0] n115_O_0_1; // @[Top.scala 20:22]
  wire [7:0] n115_O_0_2; // @[Top.scala 20:22]
  wire [7:0] n115_O_1_0; // @[Top.scala 20:22]
  wire [7:0] n115_O_1_1; // @[Top.scala 20:22]
  wire [7:0] n115_O_1_2; // @[Top.scala 20:22]
  wire [7:0] n115_O_2_0; // @[Top.scala 20:22]
  wire [7:0] n115_O_2_1; // @[Top.scala 20:22]
  wire [7:0] n115_O_2_2; // @[Top.scala 20:22]
  wire  n120_clock; // @[Top.scala 23:22]
  wire  n120_reset; // @[Top.scala 23:22]
  wire  n120_valid_up; // @[Top.scala 23:22]
  wire  n120_valid_down; // @[Top.scala 23:22]
  wire [7:0] n120_I_0_0; // @[Top.scala 23:22]
  wire [7:0] n120_I_0_1; // @[Top.scala 23:22]
  wire [7:0] n120_I_0_2; // @[Top.scala 23:22]
  wire [7:0] n120_I_1_0; // @[Top.scala 23:22]
  wire [7:0] n120_I_1_1; // @[Top.scala 23:22]
  wire [7:0] n120_I_1_2; // @[Top.scala 23:22]
  wire [7:0] n120_I_2_0; // @[Top.scala 23:22]
  wire [7:0] n120_I_2_1; // @[Top.scala 23:22]
  wire [7:0] n120_I_2_2; // @[Top.scala 23:22]
  wire [7:0] n120_O_0_0; // @[Top.scala 23:22]
  wire [7:0] n120_O_1_0; // @[Top.scala 23:22]
  wire [7:0] n120_O_2_0; // @[Top.scala 23:22]
  wire  n125_clock; // @[Top.scala 26:22]
  wire  n125_reset; // @[Top.scala 26:22]
  wire  n125_valid_up; // @[Top.scala 26:22]
  wire  n125_valid_down; // @[Top.scala 26:22]
  wire [7:0] n125_I_0_0; // @[Top.scala 26:22]
  wire [7:0] n125_I_1_0; // @[Top.scala 26:22]
  wire [7:0] n125_I_2_0; // @[Top.scala 26:22]
  wire [7:0] n125_O_0_0; // @[Top.scala 26:22]
  wire  InitialDelayCounter_1_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_valid_down; // @[Const.scala 11:33]
  wire  n128_valid_up; // @[Top.scala 30:22]
  wire  n128_valid_down; // @[Top.scala 30:22]
  wire [7:0] n128_I0_0_0; // @[Top.scala 30:22]
  wire [7:0] n128_I1_0_0; // @[Top.scala 30:22]
  wire [7:0] n128_O_0_0_t0b; // @[Top.scala 30:22]
  wire [7:0] n128_O_0_0_t1b; // @[Top.scala 30:22]
  wire  n139_valid_up; // @[Top.scala 34:22]
  wire  n139_valid_down; // @[Top.scala 34:22]
  wire [7:0] n139_I_0_0_t0b; // @[Top.scala 34:22]
  wire [7:0] n139_I_0_0_t1b; // @[Top.scala 34:22]
  wire [7:0] n139_O_0_0; // @[Top.scala 34:22]
  InitialDelayCounter InitialDelayCounter ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_clock),
    .reset(InitialDelayCounter_reset),
    .valid_down(InitialDelayCounter_valid_down)
  );
  Map2S_9 n104 ( // @[Top.scala 16:22]
    .valid_up(n104_valid_up),
    .valid_down(n104_valid_down),
    .I0_0_0(n104_I0_0_0),
    .I0_0_1(n104_I0_0_1),
    .I0_0_2(n104_I0_0_2),
    .I0_1_0(n104_I0_1_0),
    .I0_1_1(n104_I0_1_1),
    .I0_1_2(n104_I0_1_2),
    .I0_2_0(n104_I0_2_0),
    .I0_2_1(n104_I0_2_1),
    .I0_2_2(n104_I0_2_2),
    .O_0_0_t0b(n104_O_0_0_t0b),
    .O_0_0_t1b(n104_O_0_0_t1b),
    .O_0_1_t0b(n104_O_0_1_t0b),
    .O_0_1_t1b(n104_O_0_1_t1b),
    .O_0_2_t0b(n104_O_0_2_t0b),
    .O_0_2_t1b(n104_O_0_2_t1b),
    .O_1_0_t0b(n104_O_1_0_t0b),
    .O_1_0_t1b(n104_O_1_0_t1b),
    .O_1_1_t0b(n104_O_1_1_t0b),
    .O_1_1_t1b(n104_O_1_1_t1b),
    .O_1_2_t0b(n104_O_1_2_t0b),
    .O_1_2_t1b(n104_O_1_2_t1b),
    .O_2_0_t0b(n104_O_2_0_t0b),
    .O_2_0_t1b(n104_O_2_0_t1b),
    .O_2_1_t0b(n104_O_2_1_t0b),
    .O_2_1_t1b(n104_O_2_1_t1b),
    .O_2_2_t0b(n104_O_2_2_t0b),
    .O_2_2_t1b(n104_O_2_2_t1b)
  );
  MapS_4 n115 ( // @[Top.scala 20:22]
    .valid_up(n115_valid_up),
    .valid_down(n115_valid_down),
    .I_0_0_t0b(n115_I_0_0_t0b),
    .I_0_0_t1b(n115_I_0_0_t1b),
    .I_0_1_t0b(n115_I_0_1_t0b),
    .I_0_1_t1b(n115_I_0_1_t1b),
    .I_0_2_t0b(n115_I_0_2_t0b),
    .I_0_2_t1b(n115_I_0_2_t1b),
    .I_1_0_t0b(n115_I_1_0_t0b),
    .I_1_0_t1b(n115_I_1_0_t1b),
    .I_1_1_t0b(n115_I_1_1_t0b),
    .I_1_1_t1b(n115_I_1_1_t1b),
    .I_1_2_t0b(n115_I_1_2_t0b),
    .I_1_2_t1b(n115_I_1_2_t1b),
    .I_2_0_t0b(n115_I_2_0_t0b),
    .I_2_0_t1b(n115_I_2_0_t1b),
    .I_2_1_t0b(n115_I_2_1_t0b),
    .I_2_1_t1b(n115_I_2_1_t1b),
    .I_2_2_t0b(n115_I_2_2_t0b),
    .I_2_2_t1b(n115_I_2_2_t1b),
    .O_0_0(n115_O_0_0),
    .O_0_1(n115_O_0_1),
    .O_0_2(n115_O_0_2),
    .O_1_0(n115_O_1_0),
    .O_1_1(n115_O_1_1),
    .O_1_2(n115_O_1_2),
    .O_2_0(n115_O_2_0),
    .O_2_1(n115_O_2_1),
    .O_2_2(n115_O_2_2)
  );
  MapS_5 n120 ( // @[Top.scala 23:22]
    .clock(n120_clock),
    .reset(n120_reset),
    .valid_up(n120_valid_up),
    .valid_down(n120_valid_down),
    .I_0_0(n120_I_0_0),
    .I_0_1(n120_I_0_1),
    .I_0_2(n120_I_0_2),
    .I_1_0(n120_I_1_0),
    .I_1_1(n120_I_1_1),
    .I_1_2(n120_I_1_2),
    .I_2_0(n120_I_2_0),
    .I_2_1(n120_I_2_1),
    .I_2_2(n120_I_2_2),
    .O_0_0(n120_O_0_0),
    .O_1_0(n120_O_1_0),
    .O_2_0(n120_O_2_0)
  );
  ReduceS_1 n125 ( // @[Top.scala 26:22]
    .clock(n125_clock),
    .reset(n125_reset),
    .valid_up(n125_valid_up),
    .valid_down(n125_valid_down),
    .I_0_0(n125_I_0_0),
    .I_1_0(n125_I_1_0),
    .I_2_0(n125_I_2_0),
    .O_0_0(n125_O_0_0)
  );
  InitialDelayCounter_1 InitialDelayCounter_1 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_1_clock),
    .reset(InitialDelayCounter_1_reset),
    .valid_down(InitialDelayCounter_1_valid_down)
  );
  Map2S_11 n128 ( // @[Top.scala 30:22]
    .valid_up(n128_valid_up),
    .valid_down(n128_valid_down),
    .I0_0_0(n128_I0_0_0),
    .I1_0_0(n128_I1_0_0),
    .O_0_0_t0b(n128_O_0_0_t0b),
    .O_0_0_t1b(n128_O_0_0_t1b)
  );
  MapS_7 n139 ( // @[Top.scala 34:22]
    .valid_up(n139_valid_up),
    .valid_down(n139_valid_down),
    .I_0_0_t0b(n139_I_0_0_t0b),
    .I_0_0_t1b(n139_I_0_0_t1b),
    .O_0_0(n139_O_0_0)
  );
  assign valid_down = n139_valid_down; // @[Top.scala 38:16]
  assign O_0_0 = n139_O_0_0; // @[Top.scala 37:7]
  assign InitialDelayCounter_clock = clock;
  assign InitialDelayCounter_reset = reset;
  assign n104_valid_up = valid_up & InitialDelayCounter_valid_down; // @[Top.scala 19:19]
  assign n104_I0_0_0 = I_0_0; // @[Top.scala 17:13]
  assign n104_I0_0_1 = I_0_1; // @[Top.scala 17:13]
  assign n104_I0_0_2 = I_0_2; // @[Top.scala 17:13]
  assign n104_I0_1_0 = I_1_0; // @[Top.scala 17:13]
  assign n104_I0_1_1 = I_1_1; // @[Top.scala 17:13]
  assign n104_I0_1_2 = I_1_2; // @[Top.scala 17:13]
  assign n104_I0_2_0 = I_2_0; // @[Top.scala 17:13]
  assign n104_I0_2_1 = I_2_1; // @[Top.scala 17:13]
  assign n104_I0_2_2 = I_2_2; // @[Top.scala 17:13]
  assign n115_valid_up = n104_valid_down; // @[Top.scala 22:19]
  assign n115_I_0_0_t0b = n104_O_0_0_t0b; // @[Top.scala 21:12]
  assign n115_I_0_0_t1b = n104_O_0_0_t1b; // @[Top.scala 21:12]
  assign n115_I_0_1_t0b = n104_O_0_1_t0b; // @[Top.scala 21:12]
  assign n115_I_0_1_t1b = n104_O_0_1_t1b; // @[Top.scala 21:12]
  assign n115_I_0_2_t0b = n104_O_0_2_t0b; // @[Top.scala 21:12]
  assign n115_I_0_2_t1b = n104_O_0_2_t1b; // @[Top.scala 21:12]
  assign n115_I_1_0_t0b = n104_O_1_0_t0b; // @[Top.scala 21:12]
  assign n115_I_1_0_t1b = n104_O_1_0_t1b; // @[Top.scala 21:12]
  assign n115_I_1_1_t0b = n104_O_1_1_t0b; // @[Top.scala 21:12]
  assign n115_I_1_1_t1b = n104_O_1_1_t1b; // @[Top.scala 21:12]
  assign n115_I_1_2_t0b = n104_O_1_2_t0b; // @[Top.scala 21:12]
  assign n115_I_1_2_t1b = n104_O_1_2_t1b; // @[Top.scala 21:12]
  assign n115_I_2_0_t0b = n104_O_2_0_t0b; // @[Top.scala 21:12]
  assign n115_I_2_0_t1b = n104_O_2_0_t1b; // @[Top.scala 21:12]
  assign n115_I_2_1_t0b = n104_O_2_1_t0b; // @[Top.scala 21:12]
  assign n115_I_2_1_t1b = n104_O_2_1_t1b; // @[Top.scala 21:12]
  assign n115_I_2_2_t0b = n104_O_2_2_t0b; // @[Top.scala 21:12]
  assign n115_I_2_2_t1b = n104_O_2_2_t1b; // @[Top.scala 21:12]
  assign n120_clock = clock;
  assign n120_reset = reset;
  assign n120_valid_up = n115_valid_down; // @[Top.scala 25:19]
  assign n120_I_0_0 = n115_O_0_0; // @[Top.scala 24:12]
  assign n120_I_0_1 = n115_O_0_1; // @[Top.scala 24:12]
  assign n120_I_0_2 = n115_O_0_2; // @[Top.scala 24:12]
  assign n120_I_1_0 = n115_O_1_0; // @[Top.scala 24:12]
  assign n120_I_1_1 = n115_O_1_1; // @[Top.scala 24:12]
  assign n120_I_1_2 = n115_O_1_2; // @[Top.scala 24:12]
  assign n120_I_2_0 = n115_O_2_0; // @[Top.scala 24:12]
  assign n120_I_2_1 = n115_O_2_1; // @[Top.scala 24:12]
  assign n120_I_2_2 = n115_O_2_2; // @[Top.scala 24:12]
  assign n125_clock = clock;
  assign n125_reset = reset;
  assign n125_valid_up = n120_valid_down; // @[Top.scala 28:19]
  assign n125_I_0_0 = n120_O_0_0; // @[Top.scala 27:12]
  assign n125_I_1_0 = n120_O_1_0; // @[Top.scala 27:12]
  assign n125_I_2_0 = n120_O_2_0; // @[Top.scala 27:12]
  assign InitialDelayCounter_1_clock = clock;
  assign InitialDelayCounter_1_reset = reset;
  assign n128_valid_up = n125_valid_down & InitialDelayCounter_1_valid_down; // @[Top.scala 33:19]
  assign n128_I0_0_0 = n125_O_0_0; // @[Top.scala 31:13]
  assign n128_I1_0_0 = 8'h4; // @[Top.scala 32:13]
  assign n139_valid_up = n128_valid_down; // @[Top.scala 36:19]
  assign n139_I_0_0_t0b = n128_O_0_0_t0b; // @[Top.scala 35:12]
  assign n139_I_0_0_t1b = n128_O_0_0_t1b; // @[Top.scala 35:12]
endmodule
module MapT_7(
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
    .O_0_0(op_O_0_0)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
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
module Passthrough(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  output [7:0] O_0
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O_0 = I_0_0; // @[Passthrough.scala 17:68]
endmodule
module Passthrough_1(
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
module MapT_8(
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
module SSeqTupleToSSeq_4(
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
module Remove1S_4(
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
  SSeqTupleToSSeq_4 op_inst ( // @[Remove1S.scala 9:23]
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
module MapS_8(
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
  Remove1S_4 fst_op ( // @[MapS.scala 9:22]
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
module MapT_9(
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
  MapS_8 op ( // @[MapT.scala 8:20]
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
module Map2S_14(
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
module Map2T_10(
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
  Map2S_14 op ( // @[Map2T.scala 8:20]
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
module SSeqTupleToSSeq_6(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_1_0,
  input  [7:0] I_1_1,
  output [7:0] O_0_0,
  output [7:0] O_0_1,
  output [7:0] O_1_0,
  output [7:0] O_1_1
);
  assign valid_down = valid_up; // @[Tuple.scala 42:14]
  assign O_0_0 = I_0_0; // @[Tuple.scala 41:5]
  assign O_0_1 = I_0_1; // @[Tuple.scala 41:5]
  assign O_1_0 = I_1_0; // @[Tuple.scala 41:5]
  assign O_1_1 = I_1_1; // @[Tuple.scala 41:5]
endmodule
module Remove1S_6(
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
  wire  op_inst_valid_up; // @[Remove1S.scala 9:23]
  wire  op_inst_valid_down; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_0_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_0_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_1_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_I_1_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_0_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_0_1; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_1_0; // @[Remove1S.scala 9:23]
  wire [7:0] op_inst_O_1_1; // @[Remove1S.scala 9:23]
  SSeqTupleToSSeq_6 op_inst ( // @[Remove1S.scala 9:23]
    .valid_up(op_inst_valid_up),
    .valid_down(op_inst_valid_down),
    .I_0_0(op_inst_I_0_0),
    .I_0_1(op_inst_I_0_1),
    .I_1_0(op_inst_I_1_0),
    .I_1_1(op_inst_I_1_1),
    .O_0_0(op_inst_O_0_0),
    .O_0_1(op_inst_O_0_1),
    .O_1_0(op_inst_O_1_0),
    .O_1_1(op_inst_O_1_1)
  );
  assign valid_down = op_inst_valid_down; // @[Remove1S.scala 16:14]
  assign O_0_0 = op_inst_O_0_0; // @[Remove1S.scala 14:5]
  assign O_0_1 = op_inst_O_0_1; // @[Remove1S.scala 14:5]
  assign O_1_0 = op_inst_O_1_0; // @[Remove1S.scala 14:5]
  assign O_1_1 = op_inst_O_1_1; // @[Remove1S.scala 14:5]
  assign op_inst_valid_up = valid_up; // @[Remove1S.scala 15:20]
  assign op_inst_I_0_0 = I_0_0_0; // @[Remove1S.scala 13:13]
  assign op_inst_I_0_1 = I_0_0_1; // @[Remove1S.scala 13:13]
  assign op_inst_I_1_0 = I_0_1_0; // @[Remove1S.scala 13:13]
  assign op_inst_I_1_1 = I_0_1_1; // @[Remove1S.scala 13:13]
endmodule
module MapT_12(
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
  Remove1S_6 op ( // @[MapT.scala 8:20]
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
module Map2S_15(
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
module Map2S_16(
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
  Map2S_15 fst_op ( // @[Map2S.scala 9:22]
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
  Map2S_15 other_ops_0 ( // @[Map2S.scala 10:86]
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
module MapS_10(
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
module MapS_11(
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
  MapS_10 fst_op ( // @[MapS.scala 9:22]
    .valid_up(fst_op_valid_up),
    .valid_down(fst_op_valid_down),
    .I_0_t0b(fst_op_I_0_t0b),
    .I_0_t1b(fst_op_I_0_t1b),
    .I_1_t0b(fst_op_I_1_t0b),
    .I_1_t1b(fst_op_I_1_t1b),
    .O_0(fst_op_O_0),
    .O_1(fst_op_O_1)
  );
  MapS_10 other_ops_0 ( // @[MapS.scala 10:86]
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
  assign AddNoValid_I_t0b = I_1; // @[ReduceS.scala 43:18]
  assign AddNoValid_I_t1b = I_0; // @[ReduceS.scala 43:18]
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
module MapS_12(
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
module InitialDelayCounter_3(
  input   clock,
  input   reset,
  output  valid_down
);
  reg [2:0] value; // @[InitialDelayCounter.scala 8:34]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[InitialDelayCounter.scala 17:17]
  wire [2:0] _T_4; // @[InitialDelayCounter.scala 17:53]
  assign _T_1 = value < 3'h5; // @[InitialDelayCounter.scala 17:17]
  assign _T_4 = value + 3'h1; // @[InitialDelayCounter.scala 17:53]
  assign valid_down = value == 3'h5; // @[InitialDelayCounter.scala 16:16]
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
  output [7:0] O_0_0
);
  wire  InitialDelayCounter_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_valid_down; // @[Const.scala 11:33]
  wire  n195_valid_up; // @[Top.scala 45:22]
  wire  n195_valid_down; // @[Top.scala 45:22]
  wire [7:0] n195_I0_0_0; // @[Top.scala 45:22]
  wire [7:0] n195_I0_0_1; // @[Top.scala 45:22]
  wire [7:0] n195_I0_1_0; // @[Top.scala 45:22]
  wire [7:0] n195_I0_1_1; // @[Top.scala 45:22]
  wire [7:0] n195_O_0_0_t0b; // @[Top.scala 45:22]
  wire [7:0] n195_O_0_0_t1b; // @[Top.scala 45:22]
  wire [7:0] n195_O_0_1_t0b; // @[Top.scala 45:22]
  wire [7:0] n195_O_0_1_t1b; // @[Top.scala 45:22]
  wire [7:0] n195_O_1_0_t0b; // @[Top.scala 45:22]
  wire [7:0] n195_O_1_0_t1b; // @[Top.scala 45:22]
  wire [7:0] n195_O_1_1_t0b; // @[Top.scala 45:22]
  wire [7:0] n195_O_1_1_t1b; // @[Top.scala 45:22]
  wire  n206_valid_up; // @[Top.scala 49:22]
  wire  n206_valid_down; // @[Top.scala 49:22]
  wire [7:0] n206_I_0_0_t0b; // @[Top.scala 49:22]
  wire [7:0] n206_I_0_0_t1b; // @[Top.scala 49:22]
  wire [7:0] n206_I_0_1_t0b; // @[Top.scala 49:22]
  wire [7:0] n206_I_0_1_t1b; // @[Top.scala 49:22]
  wire [7:0] n206_I_1_0_t0b; // @[Top.scala 49:22]
  wire [7:0] n206_I_1_0_t1b; // @[Top.scala 49:22]
  wire [7:0] n206_I_1_1_t0b; // @[Top.scala 49:22]
  wire [7:0] n206_I_1_1_t1b; // @[Top.scala 49:22]
  wire [7:0] n206_O_0_0; // @[Top.scala 49:22]
  wire [7:0] n206_O_0_1; // @[Top.scala 49:22]
  wire [7:0] n206_O_1_0; // @[Top.scala 49:22]
  wire [7:0] n206_O_1_1; // @[Top.scala 49:22]
  wire  n211_clock; // @[Top.scala 52:22]
  wire  n211_reset; // @[Top.scala 52:22]
  wire  n211_valid_up; // @[Top.scala 52:22]
  wire  n211_valid_down; // @[Top.scala 52:22]
  wire [7:0] n211_I_0_0; // @[Top.scala 52:22]
  wire [7:0] n211_I_0_1; // @[Top.scala 52:22]
  wire [7:0] n211_I_1_0; // @[Top.scala 52:22]
  wire [7:0] n211_I_1_1; // @[Top.scala 52:22]
  wire [7:0] n211_O_0_0; // @[Top.scala 52:22]
  wire [7:0] n211_O_1_0; // @[Top.scala 52:22]
  wire  n216_clock; // @[Top.scala 55:22]
  wire  n216_reset; // @[Top.scala 55:22]
  wire  n216_valid_up; // @[Top.scala 55:22]
  wire  n216_valid_down; // @[Top.scala 55:22]
  wire [7:0] n216_I_0_0; // @[Top.scala 55:22]
  wire [7:0] n216_I_1_0; // @[Top.scala 55:22]
  wire [7:0] n216_O_0_0; // @[Top.scala 55:22]
  wire  InitialDelayCounter_1_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_valid_down; // @[Const.scala 11:33]
  wire  n219_valid_up; // @[Top.scala 59:22]
  wire  n219_valid_down; // @[Top.scala 59:22]
  wire [7:0] n219_I0_0_0; // @[Top.scala 59:22]
  wire [7:0] n219_I1_0_0; // @[Top.scala 59:22]
  wire [7:0] n219_O_0_0_t0b; // @[Top.scala 59:22]
  wire [7:0] n219_O_0_0_t1b; // @[Top.scala 59:22]
  wire  n230_valid_up; // @[Top.scala 63:22]
  wire  n230_valid_down; // @[Top.scala 63:22]
  wire [7:0] n230_I_0_0_t0b; // @[Top.scala 63:22]
  wire [7:0] n230_I_0_0_t1b; // @[Top.scala 63:22]
  wire [7:0] n230_O_0_0; // @[Top.scala 63:22]
  InitialDelayCounter_1 InitialDelayCounter ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_clock),
    .reset(InitialDelayCounter_reset),
    .valid_down(InitialDelayCounter_valid_down)
  );
  Map2S_16 n195 ( // @[Top.scala 45:22]
    .valid_up(n195_valid_up),
    .valid_down(n195_valid_down),
    .I0_0_0(n195_I0_0_0),
    .I0_0_1(n195_I0_0_1),
    .I0_1_0(n195_I0_1_0),
    .I0_1_1(n195_I0_1_1),
    .O_0_0_t0b(n195_O_0_0_t0b),
    .O_0_0_t1b(n195_O_0_0_t1b),
    .O_0_1_t0b(n195_O_0_1_t0b),
    .O_0_1_t1b(n195_O_0_1_t1b),
    .O_1_0_t0b(n195_O_1_0_t0b),
    .O_1_0_t1b(n195_O_1_0_t1b),
    .O_1_1_t0b(n195_O_1_1_t0b),
    .O_1_1_t1b(n195_O_1_1_t1b)
  );
  MapS_11 n206 ( // @[Top.scala 49:22]
    .valid_up(n206_valid_up),
    .valid_down(n206_valid_down),
    .I_0_0_t0b(n206_I_0_0_t0b),
    .I_0_0_t1b(n206_I_0_0_t1b),
    .I_0_1_t0b(n206_I_0_1_t0b),
    .I_0_1_t1b(n206_I_0_1_t1b),
    .I_1_0_t0b(n206_I_1_0_t0b),
    .I_1_0_t1b(n206_I_1_0_t1b),
    .I_1_1_t0b(n206_I_1_1_t0b),
    .I_1_1_t1b(n206_I_1_1_t1b),
    .O_0_0(n206_O_0_0),
    .O_0_1(n206_O_0_1),
    .O_1_0(n206_O_1_0),
    .O_1_1(n206_O_1_1)
  );
  MapS_12 n211 ( // @[Top.scala 52:22]
    .clock(n211_clock),
    .reset(n211_reset),
    .valid_up(n211_valid_up),
    .valid_down(n211_valid_down),
    .I_0_0(n211_I_0_0),
    .I_0_1(n211_I_0_1),
    .I_1_0(n211_I_1_0),
    .I_1_1(n211_I_1_1),
    .O_0_0(n211_O_0_0),
    .O_1_0(n211_O_1_0)
  );
  ReduceS_3 n216 ( // @[Top.scala 55:22]
    .clock(n216_clock),
    .reset(n216_reset),
    .valid_up(n216_valid_up),
    .valid_down(n216_valid_down),
    .I_0_0(n216_I_0_0),
    .I_1_0(n216_I_1_0),
    .O_0_0(n216_O_0_0)
  );
  InitialDelayCounter_3 InitialDelayCounter_1 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_1_clock),
    .reset(InitialDelayCounter_1_reset),
    .valid_down(InitialDelayCounter_1_valid_down)
  );
  Map2S_11 n219 ( // @[Top.scala 59:22]
    .valid_up(n219_valid_up),
    .valid_down(n219_valid_down),
    .I0_0_0(n219_I0_0_0),
    .I1_0_0(n219_I1_0_0),
    .O_0_0_t0b(n219_O_0_0_t0b),
    .O_0_0_t1b(n219_O_0_0_t1b)
  );
  MapS_7 n230 ( // @[Top.scala 63:22]
    .valid_up(n230_valid_up),
    .valid_down(n230_valid_down),
    .I_0_0_t0b(n230_I_0_0_t0b),
    .I_0_0_t1b(n230_I_0_0_t1b),
    .O_0_0(n230_O_0_0)
  );
  assign valid_down = n230_valid_down; // @[Top.scala 67:16]
  assign O_0_0 = n230_O_0_0; // @[Top.scala 66:7]
  assign InitialDelayCounter_clock = clock;
  assign InitialDelayCounter_reset = reset;
  assign n195_valid_up = valid_up & InitialDelayCounter_valid_down; // @[Top.scala 48:19]
  assign n195_I0_0_0 = I_0_0; // @[Top.scala 46:13]
  assign n195_I0_0_1 = I_0_1; // @[Top.scala 46:13]
  assign n195_I0_1_0 = I_1_0; // @[Top.scala 46:13]
  assign n195_I0_1_1 = I_1_1; // @[Top.scala 46:13]
  assign n206_valid_up = n195_valid_down; // @[Top.scala 51:19]
  assign n206_I_0_0_t0b = n195_O_0_0_t0b; // @[Top.scala 50:12]
  assign n206_I_0_0_t1b = n195_O_0_0_t1b; // @[Top.scala 50:12]
  assign n206_I_0_1_t0b = n195_O_0_1_t0b; // @[Top.scala 50:12]
  assign n206_I_0_1_t1b = n195_O_0_1_t1b; // @[Top.scala 50:12]
  assign n206_I_1_0_t0b = n195_O_1_0_t0b; // @[Top.scala 50:12]
  assign n206_I_1_0_t1b = n195_O_1_0_t1b; // @[Top.scala 50:12]
  assign n206_I_1_1_t0b = n195_O_1_1_t0b; // @[Top.scala 50:12]
  assign n206_I_1_1_t1b = n195_O_1_1_t1b; // @[Top.scala 50:12]
  assign n211_clock = clock;
  assign n211_reset = reset;
  assign n211_valid_up = n206_valid_down; // @[Top.scala 54:19]
  assign n211_I_0_0 = n206_O_0_0; // @[Top.scala 53:12]
  assign n211_I_0_1 = n206_O_0_1; // @[Top.scala 53:12]
  assign n211_I_1_0 = n206_O_1_0; // @[Top.scala 53:12]
  assign n211_I_1_1 = n206_O_1_1; // @[Top.scala 53:12]
  assign n216_clock = clock;
  assign n216_reset = reset;
  assign n216_valid_up = n211_valid_down; // @[Top.scala 57:19]
  assign n216_I_0_0 = n211_O_0_0; // @[Top.scala 56:12]
  assign n216_I_1_0 = n211_O_1_0; // @[Top.scala 56:12]
  assign InitialDelayCounter_1_clock = clock;
  assign InitialDelayCounter_1_reset = reset;
  assign n219_valid_up = n216_valid_down & InitialDelayCounter_1_valid_down; // @[Top.scala 62:19]
  assign n219_I0_0_0 = n216_O_0_0; // @[Top.scala 60:13]
  assign n219_I1_0_0 = 8'h3; // @[Top.scala 61:13]
  assign n230_valid_up = n219_valid_down; // @[Top.scala 65:19]
  assign n230_I_0_0_t0b = n219_O_0_0_t0b; // @[Top.scala 64:12]
  assign n230_I_0_0_t1b = n219_O_0_0_t1b; // @[Top.scala 64:12]
endmodule
module MapT_13(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  input  [7:0] I_0_1,
  input  [7:0] I_1_0,
  input  [7:0] I_1_1,
  output [7:0] O_0_0
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
  Module_1 op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0_0(op_I_0_0),
    .I_0_1(op_I_0_1),
    .I_1_0(op_I_1_0),
    .I_1_1(op_I_1_1),
    .O_0_0(op_O_0_0)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O_0_0 = op_O_0_0; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0_0 = I_0_0; // @[MapT.scala 14:10]
  assign op_I_0_1 = I_0_1; // @[MapT.scala 14:10]
  assign op_I_1_0 = I_1_0; // @[MapT.scala 14:10]
  assign op_I_1_1 = I_1_1; // @[MapT.scala 14:10]
endmodule
module Passthrough_3(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  output [7:0] O
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O = I_0; // @[Passthrough.scala 17:68]
endmodule
module FIFO_1(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I,
  output [7:0] O
);
  reg [7:0] _T; // @[FIFO.scala 13:26]
  reg [31:0] _RAND_0;
  reg  _T_1; // @[FIFO.scala 15:27]
  reg [31:0] _RAND_1;
  assign valid_down = _T_1; // @[FIFO.scala 16:16]
  assign O = _T; // @[FIFO.scala 14:7]
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
    _T <= I;
    if (reset) begin
      _T_1 <= 1'h0;
    end else begin
      _T_1 <= valid_up;
    end
  end
endmodule
module Top(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  output [7:0] O
);
  wire  n1_clock; // @[Top.scala 73:20]
  wire  n1_reset; // @[Top.scala 73:20]
  wire  n1_valid_up; // @[Top.scala 73:20]
  wire  n1_valid_down; // @[Top.scala 73:20]
  wire [7:0] n1_I_0; // @[Top.scala 73:20]
  wire [7:0] n1_O_0; // @[Top.scala 73:20]
  wire  n2_clock; // @[Top.scala 76:20]
  wire  n2_reset; // @[Top.scala 76:20]
  wire  n2_valid_up; // @[Top.scala 76:20]
  wire  n2_valid_down; // @[Top.scala 76:20]
  wire [7:0] n2_I_0; // @[Top.scala 76:20]
  wire [7:0] n2_O_0; // @[Top.scala 76:20]
  wire  n3_clock; // @[Top.scala 79:20]
  wire  n3_reset; // @[Top.scala 79:20]
  wire  n3_valid_up; // @[Top.scala 79:20]
  wire  n3_valid_down; // @[Top.scala 79:20]
  wire [7:0] n3_I_0; // @[Top.scala 79:20]
  wire [7:0] n3_O_0; // @[Top.scala 79:20]
  wire  n4_clock; // @[Top.scala 82:20]
  wire  n4_valid_up; // @[Top.scala 82:20]
  wire  n4_valid_down; // @[Top.scala 82:20]
  wire [7:0] n4_I_0; // @[Top.scala 82:20]
  wire [7:0] n4_O_0; // @[Top.scala 82:20]
  wire  n5_clock; // @[Top.scala 85:20]
  wire  n5_valid_up; // @[Top.scala 85:20]
  wire  n5_valid_down; // @[Top.scala 85:20]
  wire [7:0] n5_I_0; // @[Top.scala 85:20]
  wire [7:0] n5_O_0; // @[Top.scala 85:20]
  wire  n6_valid_up; // @[Top.scala 88:20]
  wire  n6_valid_down; // @[Top.scala 88:20]
  wire [7:0] n6_I0_0; // @[Top.scala 88:20]
  wire [7:0] n6_I1_0; // @[Top.scala 88:20]
  wire [7:0] n6_O_0_0; // @[Top.scala 88:20]
  wire [7:0] n6_O_0_1; // @[Top.scala 88:20]
  wire  n13_valid_up; // @[Top.scala 92:21]
  wire  n13_valid_down; // @[Top.scala 92:21]
  wire [7:0] n13_I0_0_0; // @[Top.scala 92:21]
  wire [7:0] n13_I0_0_1; // @[Top.scala 92:21]
  wire [7:0] n13_I1_0; // @[Top.scala 92:21]
  wire [7:0] n13_O_0_0; // @[Top.scala 92:21]
  wire [7:0] n13_O_0_1; // @[Top.scala 92:21]
  wire [7:0] n13_O_0_2; // @[Top.scala 92:21]
  wire  n22_valid_up; // @[Top.scala 96:21]
  wire  n22_valid_down; // @[Top.scala 96:21]
  wire [7:0] n22_I_0_0; // @[Top.scala 96:21]
  wire [7:0] n22_I_0_1; // @[Top.scala 96:21]
  wire [7:0] n22_I_0_2; // @[Top.scala 96:21]
  wire [7:0] n22_O_0_0_0; // @[Top.scala 96:21]
  wire [7:0] n22_O_0_0_1; // @[Top.scala 96:21]
  wire [7:0] n22_O_0_0_2; // @[Top.scala 96:21]
  wire  n29_valid_up; // @[Top.scala 99:21]
  wire  n29_valid_down; // @[Top.scala 99:21]
  wire [7:0] n29_I_0_0_0; // @[Top.scala 99:21]
  wire [7:0] n29_I_0_0_1; // @[Top.scala 99:21]
  wire [7:0] n29_I_0_0_2; // @[Top.scala 99:21]
  wire [7:0] n29_O_0_0; // @[Top.scala 99:21]
  wire [7:0] n29_O_0_1; // @[Top.scala 99:21]
  wire [7:0] n29_O_0_2; // @[Top.scala 99:21]
  wire  n30_clock; // @[Top.scala 102:21]
  wire  n30_valid_up; // @[Top.scala 102:21]
  wire  n30_valid_down; // @[Top.scala 102:21]
  wire [7:0] n30_I_0; // @[Top.scala 102:21]
  wire [7:0] n30_O_0; // @[Top.scala 102:21]
  wire  n31_clock; // @[Top.scala 105:21]
  wire  n31_valid_up; // @[Top.scala 105:21]
  wire  n31_valid_down; // @[Top.scala 105:21]
  wire [7:0] n31_I_0; // @[Top.scala 105:21]
  wire [7:0] n31_O_0; // @[Top.scala 105:21]
  wire  n32_valid_up; // @[Top.scala 108:21]
  wire  n32_valid_down; // @[Top.scala 108:21]
  wire [7:0] n32_I0_0; // @[Top.scala 108:21]
  wire [7:0] n32_I1_0; // @[Top.scala 108:21]
  wire [7:0] n32_O_0_0; // @[Top.scala 108:21]
  wire [7:0] n32_O_0_1; // @[Top.scala 108:21]
  wire  n39_valid_up; // @[Top.scala 112:21]
  wire  n39_valid_down; // @[Top.scala 112:21]
  wire [7:0] n39_I0_0_0; // @[Top.scala 112:21]
  wire [7:0] n39_I0_0_1; // @[Top.scala 112:21]
  wire [7:0] n39_I1_0; // @[Top.scala 112:21]
  wire [7:0] n39_O_0_0; // @[Top.scala 112:21]
  wire [7:0] n39_O_0_1; // @[Top.scala 112:21]
  wire [7:0] n39_O_0_2; // @[Top.scala 112:21]
  wire  n48_valid_up; // @[Top.scala 116:21]
  wire  n48_valid_down; // @[Top.scala 116:21]
  wire [7:0] n48_I_0_0; // @[Top.scala 116:21]
  wire [7:0] n48_I_0_1; // @[Top.scala 116:21]
  wire [7:0] n48_I_0_2; // @[Top.scala 116:21]
  wire [7:0] n48_O_0_0_0; // @[Top.scala 116:21]
  wire [7:0] n48_O_0_0_1; // @[Top.scala 116:21]
  wire [7:0] n48_O_0_0_2; // @[Top.scala 116:21]
  wire  n55_valid_up; // @[Top.scala 119:21]
  wire  n55_valid_down; // @[Top.scala 119:21]
  wire [7:0] n55_I_0_0_0; // @[Top.scala 119:21]
  wire [7:0] n55_I_0_0_1; // @[Top.scala 119:21]
  wire [7:0] n55_I_0_0_2; // @[Top.scala 119:21]
  wire [7:0] n55_O_0_0; // @[Top.scala 119:21]
  wire [7:0] n55_O_0_1; // @[Top.scala 119:21]
  wire [7:0] n55_O_0_2; // @[Top.scala 119:21]
  wire  n56_valid_up; // @[Top.scala 122:21]
  wire  n56_valid_down; // @[Top.scala 122:21]
  wire [7:0] n56_I0_0_0; // @[Top.scala 122:21]
  wire [7:0] n56_I0_0_1; // @[Top.scala 122:21]
  wire [7:0] n56_I0_0_2; // @[Top.scala 122:21]
  wire [7:0] n56_I1_0_0; // @[Top.scala 122:21]
  wire [7:0] n56_I1_0_1; // @[Top.scala 122:21]
  wire [7:0] n56_I1_0_2; // @[Top.scala 122:21]
  wire [7:0] n56_O_0_0_0; // @[Top.scala 122:21]
  wire [7:0] n56_O_0_0_1; // @[Top.scala 122:21]
  wire [7:0] n56_O_0_0_2; // @[Top.scala 122:21]
  wire [7:0] n56_O_0_1_0; // @[Top.scala 122:21]
  wire [7:0] n56_O_0_1_1; // @[Top.scala 122:21]
  wire [7:0] n56_O_0_1_2; // @[Top.scala 122:21]
  wire  n63_clock; // @[Top.scala 126:21]
  wire  n63_valid_up; // @[Top.scala 126:21]
  wire  n63_valid_down; // @[Top.scala 126:21]
  wire [7:0] n63_I_0; // @[Top.scala 126:21]
  wire [7:0] n63_O_0; // @[Top.scala 126:21]
  wire  n64_clock; // @[Top.scala 129:21]
  wire  n64_valid_up; // @[Top.scala 129:21]
  wire  n64_valid_down; // @[Top.scala 129:21]
  wire [7:0] n64_I_0; // @[Top.scala 129:21]
  wire [7:0] n64_O_0; // @[Top.scala 129:21]
  wire  n65_valid_up; // @[Top.scala 132:21]
  wire  n65_valid_down; // @[Top.scala 132:21]
  wire [7:0] n65_I0_0; // @[Top.scala 132:21]
  wire [7:0] n65_I1_0; // @[Top.scala 132:21]
  wire [7:0] n65_O_0_0; // @[Top.scala 132:21]
  wire [7:0] n65_O_0_1; // @[Top.scala 132:21]
  wire  n72_valid_up; // @[Top.scala 136:21]
  wire  n72_valid_down; // @[Top.scala 136:21]
  wire [7:0] n72_I0_0_0; // @[Top.scala 136:21]
  wire [7:0] n72_I0_0_1; // @[Top.scala 136:21]
  wire [7:0] n72_I1_0; // @[Top.scala 136:21]
  wire [7:0] n72_O_0_0; // @[Top.scala 136:21]
  wire [7:0] n72_O_0_1; // @[Top.scala 136:21]
  wire [7:0] n72_O_0_2; // @[Top.scala 136:21]
  wire  n81_valid_up; // @[Top.scala 140:21]
  wire  n81_valid_down; // @[Top.scala 140:21]
  wire [7:0] n81_I_0_0; // @[Top.scala 140:21]
  wire [7:0] n81_I_0_1; // @[Top.scala 140:21]
  wire [7:0] n81_I_0_2; // @[Top.scala 140:21]
  wire [7:0] n81_O_0_0_0; // @[Top.scala 140:21]
  wire [7:0] n81_O_0_0_1; // @[Top.scala 140:21]
  wire [7:0] n81_O_0_0_2; // @[Top.scala 140:21]
  wire  n88_valid_up; // @[Top.scala 143:21]
  wire  n88_valid_down; // @[Top.scala 143:21]
  wire [7:0] n88_I_0_0_0; // @[Top.scala 143:21]
  wire [7:0] n88_I_0_0_1; // @[Top.scala 143:21]
  wire [7:0] n88_I_0_0_2; // @[Top.scala 143:21]
  wire [7:0] n88_O_0_0; // @[Top.scala 143:21]
  wire [7:0] n88_O_0_1; // @[Top.scala 143:21]
  wire [7:0] n88_O_0_2; // @[Top.scala 143:21]
  wire  n89_valid_up; // @[Top.scala 146:21]
  wire  n89_valid_down; // @[Top.scala 146:21]
  wire [7:0] n89_I0_0_0_0; // @[Top.scala 146:21]
  wire [7:0] n89_I0_0_0_1; // @[Top.scala 146:21]
  wire [7:0] n89_I0_0_0_2; // @[Top.scala 146:21]
  wire [7:0] n89_I0_0_1_0; // @[Top.scala 146:21]
  wire [7:0] n89_I0_0_1_1; // @[Top.scala 146:21]
  wire [7:0] n89_I0_0_1_2; // @[Top.scala 146:21]
  wire [7:0] n89_I1_0_0; // @[Top.scala 146:21]
  wire [7:0] n89_I1_0_1; // @[Top.scala 146:21]
  wire [7:0] n89_I1_0_2; // @[Top.scala 146:21]
  wire [7:0] n89_O_0_0_0; // @[Top.scala 146:21]
  wire [7:0] n89_O_0_0_1; // @[Top.scala 146:21]
  wire [7:0] n89_O_0_0_2; // @[Top.scala 146:21]
  wire [7:0] n89_O_0_1_0; // @[Top.scala 146:21]
  wire [7:0] n89_O_0_1_1; // @[Top.scala 146:21]
  wire [7:0] n89_O_0_1_2; // @[Top.scala 146:21]
  wire [7:0] n89_O_0_2_0; // @[Top.scala 146:21]
  wire [7:0] n89_O_0_2_1; // @[Top.scala 146:21]
  wire [7:0] n89_O_0_2_2; // @[Top.scala 146:21]
  wire  n100_valid_up; // @[Top.scala 150:22]
  wire  n100_valid_down; // @[Top.scala 150:22]
  wire [7:0] n100_I_0_0_0; // @[Top.scala 150:22]
  wire [7:0] n100_I_0_0_1; // @[Top.scala 150:22]
  wire [7:0] n100_I_0_0_2; // @[Top.scala 150:22]
  wire [7:0] n100_I_0_1_0; // @[Top.scala 150:22]
  wire [7:0] n100_I_0_1_1; // @[Top.scala 150:22]
  wire [7:0] n100_I_0_1_2; // @[Top.scala 150:22]
  wire [7:0] n100_I_0_2_0; // @[Top.scala 150:22]
  wire [7:0] n100_I_0_2_1; // @[Top.scala 150:22]
  wire [7:0] n100_I_0_2_2; // @[Top.scala 150:22]
  wire [7:0] n100_O_0_0; // @[Top.scala 150:22]
  wire [7:0] n100_O_0_1; // @[Top.scala 150:22]
  wire [7:0] n100_O_0_2; // @[Top.scala 150:22]
  wire [7:0] n100_O_1_0; // @[Top.scala 150:22]
  wire [7:0] n100_O_1_1; // @[Top.scala 150:22]
  wire [7:0] n100_O_1_2; // @[Top.scala 150:22]
  wire [7:0] n100_O_2_0; // @[Top.scala 150:22]
  wire [7:0] n100_O_2_1; // @[Top.scala 150:22]
  wire [7:0] n100_O_2_2; // @[Top.scala 150:22]
  wire  n140_clock; // @[Top.scala 153:22]
  wire  n140_reset; // @[Top.scala 153:22]
  wire  n140_valid_up; // @[Top.scala 153:22]
  wire  n140_valid_down; // @[Top.scala 153:22]
  wire [7:0] n140_I_0_0; // @[Top.scala 153:22]
  wire [7:0] n140_I_0_1; // @[Top.scala 153:22]
  wire [7:0] n140_I_0_2; // @[Top.scala 153:22]
  wire [7:0] n140_I_1_0; // @[Top.scala 153:22]
  wire [7:0] n140_I_1_1; // @[Top.scala 153:22]
  wire [7:0] n140_I_1_2; // @[Top.scala 153:22]
  wire [7:0] n140_I_2_0; // @[Top.scala 153:22]
  wire [7:0] n140_I_2_1; // @[Top.scala 153:22]
  wire [7:0] n140_I_2_2; // @[Top.scala 153:22]
  wire [7:0] n140_O_0_0; // @[Top.scala 153:22]
  wire  n141_valid_up; // @[Top.scala 156:22]
  wire  n141_valid_down; // @[Top.scala 156:22]
  wire [7:0] n141_I_0_0; // @[Top.scala 156:22]
  wire [7:0] n141_O_0; // @[Top.scala 156:22]
  wire  n142_valid_up; // @[Top.scala 159:22]
  wire  n142_valid_down; // @[Top.scala 159:22]
  wire [7:0] n142_I_0; // @[Top.scala 159:22]
  wire [7:0] n142_O_0; // @[Top.scala 159:22]
  wire  n143_clock; // @[Top.scala 162:22]
  wire  n143_reset; // @[Top.scala 162:22]
  wire  n143_valid_up; // @[Top.scala 162:22]
  wire  n143_valid_down; // @[Top.scala 162:22]
  wire [7:0] n143_I_0; // @[Top.scala 162:22]
  wire [7:0] n143_O_0; // @[Top.scala 162:22]
  wire  n144_clock; // @[Top.scala 165:22]
  wire  n144_valid_up; // @[Top.scala 165:22]
  wire  n144_valid_down; // @[Top.scala 165:22]
  wire [7:0] n144_I_0; // @[Top.scala 165:22]
  wire [7:0] n144_O_0; // @[Top.scala 165:22]
  wire  n145_valid_up; // @[Top.scala 168:22]
  wire  n145_valid_down; // @[Top.scala 168:22]
  wire [7:0] n145_I0_0; // @[Top.scala 168:22]
  wire [7:0] n145_I1_0; // @[Top.scala 168:22]
  wire [7:0] n145_O_0_0; // @[Top.scala 168:22]
  wire [7:0] n145_O_0_1; // @[Top.scala 168:22]
  wire  n154_valid_up; // @[Top.scala 172:22]
  wire  n154_valid_down; // @[Top.scala 172:22]
  wire [7:0] n154_I_0_0; // @[Top.scala 172:22]
  wire [7:0] n154_I_0_1; // @[Top.scala 172:22]
  wire [7:0] n154_O_0_0_0; // @[Top.scala 172:22]
  wire [7:0] n154_O_0_0_1; // @[Top.scala 172:22]
  wire  n161_valid_up; // @[Top.scala 175:22]
  wire  n161_valid_down; // @[Top.scala 175:22]
  wire [7:0] n161_I_0_0_0; // @[Top.scala 175:22]
  wire [7:0] n161_I_0_0_1; // @[Top.scala 175:22]
  wire [7:0] n161_O_0_0; // @[Top.scala 175:22]
  wire [7:0] n161_O_0_1; // @[Top.scala 175:22]
  wire  n162_clock; // @[Top.scala 178:22]
  wire  n162_valid_up; // @[Top.scala 178:22]
  wire  n162_valid_down; // @[Top.scala 178:22]
  wire [7:0] n162_I_0; // @[Top.scala 178:22]
  wire [7:0] n162_O_0; // @[Top.scala 178:22]
  wire  n163_valid_up; // @[Top.scala 181:22]
  wire  n163_valid_down; // @[Top.scala 181:22]
  wire [7:0] n163_I0_0; // @[Top.scala 181:22]
  wire [7:0] n163_I1_0; // @[Top.scala 181:22]
  wire [7:0] n163_O_0_0; // @[Top.scala 181:22]
  wire [7:0] n163_O_0_1; // @[Top.scala 181:22]
  wire  n172_valid_up; // @[Top.scala 185:22]
  wire  n172_valid_down; // @[Top.scala 185:22]
  wire [7:0] n172_I_0_0; // @[Top.scala 185:22]
  wire [7:0] n172_I_0_1; // @[Top.scala 185:22]
  wire [7:0] n172_O_0_0_0; // @[Top.scala 185:22]
  wire [7:0] n172_O_0_0_1; // @[Top.scala 185:22]
  wire  n179_valid_up; // @[Top.scala 188:22]
  wire  n179_valid_down; // @[Top.scala 188:22]
  wire [7:0] n179_I_0_0_0; // @[Top.scala 188:22]
  wire [7:0] n179_I_0_0_1; // @[Top.scala 188:22]
  wire [7:0] n179_O_0_0; // @[Top.scala 188:22]
  wire [7:0] n179_O_0_1; // @[Top.scala 188:22]
  wire  n180_valid_up; // @[Top.scala 191:22]
  wire  n180_valid_down; // @[Top.scala 191:22]
  wire [7:0] n180_I0_0_0; // @[Top.scala 191:22]
  wire [7:0] n180_I0_0_1; // @[Top.scala 191:22]
  wire [7:0] n180_I1_0_0; // @[Top.scala 191:22]
  wire [7:0] n180_I1_0_1; // @[Top.scala 191:22]
  wire [7:0] n180_O_0_0_0; // @[Top.scala 191:22]
  wire [7:0] n180_O_0_0_1; // @[Top.scala 191:22]
  wire [7:0] n180_O_0_1_0; // @[Top.scala 191:22]
  wire [7:0] n180_O_0_1_1; // @[Top.scala 191:22]
  wire  n191_valid_up; // @[Top.scala 195:22]
  wire  n191_valid_down; // @[Top.scala 195:22]
  wire [7:0] n191_I_0_0_0; // @[Top.scala 195:22]
  wire [7:0] n191_I_0_0_1; // @[Top.scala 195:22]
  wire [7:0] n191_I_0_1_0; // @[Top.scala 195:22]
  wire [7:0] n191_I_0_1_1; // @[Top.scala 195:22]
  wire [7:0] n191_O_0_0; // @[Top.scala 195:22]
  wire [7:0] n191_O_0_1; // @[Top.scala 195:22]
  wire [7:0] n191_O_1_0; // @[Top.scala 195:22]
  wire [7:0] n191_O_1_1; // @[Top.scala 195:22]
  wire  n231_clock; // @[Top.scala 198:22]
  wire  n231_reset; // @[Top.scala 198:22]
  wire  n231_valid_up; // @[Top.scala 198:22]
  wire  n231_valid_down; // @[Top.scala 198:22]
  wire [7:0] n231_I_0_0; // @[Top.scala 198:22]
  wire [7:0] n231_I_0_1; // @[Top.scala 198:22]
  wire [7:0] n231_I_1_0; // @[Top.scala 198:22]
  wire [7:0] n231_I_1_1; // @[Top.scala 198:22]
  wire [7:0] n231_O_0_0; // @[Top.scala 198:22]
  wire  n232_valid_up; // @[Top.scala 201:22]
  wire  n232_valid_down; // @[Top.scala 201:22]
  wire [7:0] n232_I_0_0; // @[Top.scala 201:22]
  wire [7:0] n232_O_0; // @[Top.scala 201:22]
  wire  n233_valid_up; // @[Top.scala 204:22]
  wire  n233_valid_down; // @[Top.scala 204:22]
  wire [7:0] n233_I_0; // @[Top.scala 204:22]
  wire [7:0] n233_O; // @[Top.scala 204:22]
  wire  n234_clock; // @[Top.scala 207:22]
  wire  n234_reset; // @[Top.scala 207:22]
  wire  n234_valid_up; // @[Top.scala 207:22]
  wire  n234_valid_down; // @[Top.scala 207:22]
  wire [7:0] n234_I; // @[Top.scala 207:22]
  wire [7:0] n234_O; // @[Top.scala 207:22]
  wire  n235_clock; // @[Top.scala 210:22]
  wire  n235_reset; // @[Top.scala 210:22]
  wire  n235_valid_up; // @[Top.scala 210:22]
  wire  n235_valid_down; // @[Top.scala 210:22]
  wire [7:0] n235_I; // @[Top.scala 210:22]
  wire [7:0] n235_O; // @[Top.scala 210:22]
  wire  n236_clock; // @[Top.scala 213:22]
  wire  n236_reset; // @[Top.scala 213:22]
  wire  n236_valid_up; // @[Top.scala 213:22]
  wire  n236_valid_down; // @[Top.scala 213:22]
  wire [7:0] n236_I; // @[Top.scala 213:22]
  wire [7:0] n236_O; // @[Top.scala 213:22]
  FIFO n1 ( // @[Top.scala 73:20]
    .clock(n1_clock),
    .reset(n1_reset),
    .valid_up(n1_valid_up),
    .valid_down(n1_valid_down),
    .I_0(n1_I_0),
    .O_0(n1_O_0)
  );
  ShiftT n2 ( // @[Top.scala 76:20]
    .clock(n2_clock),
    .reset(n2_reset),
    .valid_up(n2_valid_up),
    .valid_down(n2_valid_down),
    .I_0(n2_I_0),
    .O_0(n2_O_0)
  );
  ShiftT n3 ( // @[Top.scala 79:20]
    .clock(n3_clock),
    .reset(n3_reset),
    .valid_up(n3_valid_up),
    .valid_down(n3_valid_down),
    .I_0(n3_I_0),
    .O_0(n3_O_0)
  );
  ShiftT_2 n4 ( // @[Top.scala 82:20]
    .clock(n4_clock),
    .valid_up(n4_valid_up),
    .valid_down(n4_valid_down),
    .I_0(n4_I_0),
    .O_0(n4_O_0)
  );
  ShiftT_2 n5 ( // @[Top.scala 85:20]
    .clock(n5_clock),
    .valid_up(n5_valid_up),
    .valid_down(n5_valid_down),
    .I_0(n5_I_0),
    .O_0(n5_O_0)
  );
  Map2T n6 ( // @[Top.scala 88:20]
    .valid_up(n6_valid_up),
    .valid_down(n6_valid_down),
    .I0_0(n6_I0_0),
    .I1_0(n6_I1_0),
    .O_0_0(n6_O_0_0),
    .O_0_1(n6_O_0_1)
  );
  Map2T_1 n13 ( // @[Top.scala 92:21]
    .valid_up(n13_valid_up),
    .valid_down(n13_valid_down),
    .I0_0_0(n13_I0_0_0),
    .I0_0_1(n13_I0_0_1),
    .I1_0(n13_I1_0),
    .O_0_0(n13_O_0_0),
    .O_0_1(n13_O_0_1),
    .O_0_2(n13_O_0_2)
  );
  MapT n22 ( // @[Top.scala 96:21]
    .valid_up(n22_valid_up),
    .valid_down(n22_valid_down),
    .I_0_0(n22_I_0_0),
    .I_0_1(n22_I_0_1),
    .I_0_2(n22_I_0_2),
    .O_0_0_0(n22_O_0_0_0),
    .O_0_0_1(n22_O_0_0_1),
    .O_0_0_2(n22_O_0_0_2)
  );
  MapT_1 n29 ( // @[Top.scala 99:21]
    .valid_up(n29_valid_up),
    .valid_down(n29_valid_down),
    .I_0_0_0(n29_I_0_0_0),
    .I_0_0_1(n29_I_0_0_1),
    .I_0_0_2(n29_I_0_0_2),
    .O_0_0(n29_O_0_0),
    .O_0_1(n29_O_0_1),
    .O_0_2(n29_O_0_2)
  );
  ShiftT_2 n30 ( // @[Top.scala 102:21]
    .clock(n30_clock),
    .valid_up(n30_valid_up),
    .valid_down(n30_valid_down),
    .I_0(n30_I_0),
    .O_0(n30_O_0)
  );
  ShiftT_2 n31 ( // @[Top.scala 105:21]
    .clock(n31_clock),
    .valid_up(n31_valid_up),
    .valid_down(n31_valid_down),
    .I_0(n31_I_0),
    .O_0(n31_O_0)
  );
  Map2T n32 ( // @[Top.scala 108:21]
    .valid_up(n32_valid_up),
    .valid_down(n32_valid_down),
    .I0_0(n32_I0_0),
    .I1_0(n32_I1_0),
    .O_0_0(n32_O_0_0),
    .O_0_1(n32_O_0_1)
  );
  Map2T_1 n39 ( // @[Top.scala 112:21]
    .valid_up(n39_valid_up),
    .valid_down(n39_valid_down),
    .I0_0_0(n39_I0_0_0),
    .I0_0_1(n39_I0_0_1),
    .I1_0(n39_I1_0),
    .O_0_0(n39_O_0_0),
    .O_0_1(n39_O_0_1),
    .O_0_2(n39_O_0_2)
  );
  MapT n48 ( // @[Top.scala 116:21]
    .valid_up(n48_valid_up),
    .valid_down(n48_valid_down),
    .I_0_0(n48_I_0_0),
    .I_0_1(n48_I_0_1),
    .I_0_2(n48_I_0_2),
    .O_0_0_0(n48_O_0_0_0),
    .O_0_0_1(n48_O_0_0_1),
    .O_0_0_2(n48_O_0_0_2)
  );
  MapT_1 n55 ( // @[Top.scala 119:21]
    .valid_up(n55_valid_up),
    .valid_down(n55_valid_down),
    .I_0_0_0(n55_I_0_0_0),
    .I_0_0_1(n55_I_0_0_1),
    .I_0_0_2(n55_I_0_0_2),
    .O_0_0(n55_O_0_0),
    .O_0_1(n55_O_0_1),
    .O_0_2(n55_O_0_2)
  );
  Map2T_4 n56 ( // @[Top.scala 122:21]
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
  ShiftT_2 n63 ( // @[Top.scala 126:21]
    .clock(n63_clock),
    .valid_up(n63_valid_up),
    .valid_down(n63_valid_down),
    .I_0(n63_I_0),
    .O_0(n63_O_0)
  );
  ShiftT_2 n64 ( // @[Top.scala 129:21]
    .clock(n64_clock),
    .valid_up(n64_valid_up),
    .valid_down(n64_valid_down),
    .I_0(n64_I_0),
    .O_0(n64_O_0)
  );
  Map2T n65 ( // @[Top.scala 132:21]
    .valid_up(n65_valid_up),
    .valid_down(n65_valid_down),
    .I0_0(n65_I0_0),
    .I1_0(n65_I1_0),
    .O_0_0(n65_O_0_0),
    .O_0_1(n65_O_0_1)
  );
  Map2T_1 n72 ( // @[Top.scala 136:21]
    .valid_up(n72_valid_up),
    .valid_down(n72_valid_down),
    .I0_0_0(n72_I0_0_0),
    .I0_0_1(n72_I0_0_1),
    .I1_0(n72_I1_0),
    .O_0_0(n72_O_0_0),
    .O_0_1(n72_O_0_1),
    .O_0_2(n72_O_0_2)
  );
  MapT n81 ( // @[Top.scala 140:21]
    .valid_up(n81_valid_up),
    .valid_down(n81_valid_down),
    .I_0_0(n81_I_0_0),
    .I_0_1(n81_I_0_1),
    .I_0_2(n81_I_0_2),
    .O_0_0_0(n81_O_0_0_0),
    .O_0_0_1(n81_O_0_0_1),
    .O_0_0_2(n81_O_0_0_2)
  );
  MapT_1 n88 ( // @[Top.scala 143:21]
    .valid_up(n88_valid_up),
    .valid_down(n88_valid_down),
    .I_0_0_0(n88_I_0_0_0),
    .I_0_0_1(n88_I_0_0_1),
    .I_0_0_2(n88_I_0_0_2),
    .O_0_0(n88_O_0_0),
    .O_0_1(n88_O_0_1),
    .O_0_2(n88_O_0_2)
  );
  Map2T_7 n89 ( // @[Top.scala 146:21]
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
  MapT_6 n100 ( // @[Top.scala 150:22]
    .valid_up(n100_valid_up),
    .valid_down(n100_valid_down),
    .I_0_0_0(n100_I_0_0_0),
    .I_0_0_1(n100_I_0_0_1),
    .I_0_0_2(n100_I_0_0_2),
    .I_0_1_0(n100_I_0_1_0),
    .I_0_1_1(n100_I_0_1_1),
    .I_0_1_2(n100_I_0_1_2),
    .I_0_2_0(n100_I_0_2_0),
    .I_0_2_1(n100_I_0_2_1),
    .I_0_2_2(n100_I_0_2_2),
    .O_0_0(n100_O_0_0),
    .O_0_1(n100_O_0_1),
    .O_0_2(n100_O_0_2),
    .O_1_0(n100_O_1_0),
    .O_1_1(n100_O_1_1),
    .O_1_2(n100_O_1_2),
    .O_2_0(n100_O_2_0),
    .O_2_1(n100_O_2_1),
    .O_2_2(n100_O_2_2)
  );
  MapT_7 n140 ( // @[Top.scala 153:22]
    .clock(n140_clock),
    .reset(n140_reset),
    .valid_up(n140_valid_up),
    .valid_down(n140_valid_down),
    .I_0_0(n140_I_0_0),
    .I_0_1(n140_I_0_1),
    .I_0_2(n140_I_0_2),
    .I_1_0(n140_I_1_0),
    .I_1_1(n140_I_1_1),
    .I_1_2(n140_I_1_2),
    .I_2_0(n140_I_2_0),
    .I_2_1(n140_I_2_1),
    .I_2_2(n140_I_2_2),
    .O_0_0(n140_O_0_0)
  );
  Passthrough n141 ( // @[Top.scala 156:22]
    .valid_up(n141_valid_up),
    .valid_down(n141_valid_down),
    .I_0_0(n141_I_0_0),
    .O_0(n141_O_0)
  );
  Passthrough_1 n142 ( // @[Top.scala 159:22]
    .valid_up(n142_valid_up),
    .valid_down(n142_valid_down),
    .I_0(n142_I_0),
    .O_0(n142_O_0)
  );
  ShiftT n143 ( // @[Top.scala 162:22]
    .clock(n143_clock),
    .reset(n143_reset),
    .valid_up(n143_valid_up),
    .valid_down(n143_valid_down),
    .I_0(n143_I_0),
    .O_0(n143_O_0)
  );
  ShiftT_2 n144 ( // @[Top.scala 165:22]
    .clock(n144_clock),
    .valid_up(n144_valid_up),
    .valid_down(n144_valid_down),
    .I_0(n144_I_0),
    .O_0(n144_O_0)
  );
  Map2T n145 ( // @[Top.scala 168:22]
    .valid_up(n145_valid_up),
    .valid_down(n145_valid_down),
    .I0_0(n145_I0_0),
    .I1_0(n145_I1_0),
    .O_0_0(n145_O_0_0),
    .O_0_1(n145_O_0_1)
  );
  MapT_8 n154 ( // @[Top.scala 172:22]
    .valid_up(n154_valid_up),
    .valid_down(n154_valid_down),
    .I_0_0(n154_I_0_0),
    .I_0_1(n154_I_0_1),
    .O_0_0_0(n154_O_0_0_0),
    .O_0_0_1(n154_O_0_0_1)
  );
  MapT_9 n161 ( // @[Top.scala 175:22]
    .valid_up(n161_valid_up),
    .valid_down(n161_valid_down),
    .I_0_0_0(n161_I_0_0_0),
    .I_0_0_1(n161_I_0_0_1),
    .O_0_0(n161_O_0_0),
    .O_0_1(n161_O_0_1)
  );
  ShiftT_2 n162 ( // @[Top.scala 178:22]
    .clock(n162_clock),
    .valid_up(n162_valid_up),
    .valid_down(n162_valid_down),
    .I_0(n162_I_0),
    .O_0(n162_O_0)
  );
  Map2T n163 ( // @[Top.scala 181:22]
    .valid_up(n163_valid_up),
    .valid_down(n163_valid_down),
    .I0_0(n163_I0_0),
    .I1_0(n163_I1_0),
    .O_0_0(n163_O_0_0),
    .O_0_1(n163_O_0_1)
  );
  MapT_8 n172 ( // @[Top.scala 185:22]
    .valid_up(n172_valid_up),
    .valid_down(n172_valid_down),
    .I_0_0(n172_I_0_0),
    .I_0_1(n172_I_0_1),
    .O_0_0_0(n172_O_0_0_0),
    .O_0_0_1(n172_O_0_0_1)
  );
  MapT_9 n179 ( // @[Top.scala 188:22]
    .valid_up(n179_valid_up),
    .valid_down(n179_valid_down),
    .I_0_0_0(n179_I_0_0_0),
    .I_0_0_1(n179_I_0_0_1),
    .O_0_0(n179_O_0_0),
    .O_0_1(n179_O_0_1)
  );
  Map2T_10 n180 ( // @[Top.scala 191:22]
    .valid_up(n180_valid_up),
    .valid_down(n180_valid_down),
    .I0_0_0(n180_I0_0_0),
    .I0_0_1(n180_I0_0_1),
    .I1_0_0(n180_I1_0_0),
    .I1_0_1(n180_I1_0_1),
    .O_0_0_0(n180_O_0_0_0),
    .O_0_0_1(n180_O_0_0_1),
    .O_0_1_0(n180_O_0_1_0),
    .O_0_1_1(n180_O_0_1_1)
  );
  MapT_12 n191 ( // @[Top.scala 195:22]
    .valid_up(n191_valid_up),
    .valid_down(n191_valid_down),
    .I_0_0_0(n191_I_0_0_0),
    .I_0_0_1(n191_I_0_0_1),
    .I_0_1_0(n191_I_0_1_0),
    .I_0_1_1(n191_I_0_1_1),
    .O_0_0(n191_O_0_0),
    .O_0_1(n191_O_0_1),
    .O_1_0(n191_O_1_0),
    .O_1_1(n191_O_1_1)
  );
  MapT_13 n231 ( // @[Top.scala 198:22]
    .clock(n231_clock),
    .reset(n231_reset),
    .valid_up(n231_valid_up),
    .valid_down(n231_valid_down),
    .I_0_0(n231_I_0_0),
    .I_0_1(n231_I_0_1),
    .I_1_0(n231_I_1_0),
    .I_1_1(n231_I_1_1),
    .O_0_0(n231_O_0_0)
  );
  Passthrough n232 ( // @[Top.scala 201:22]
    .valid_up(n232_valid_up),
    .valid_down(n232_valid_down),
    .I_0_0(n232_I_0_0),
    .O_0(n232_O_0)
  );
  Passthrough_3 n233 ( // @[Top.scala 204:22]
    .valid_up(n233_valid_up),
    .valid_down(n233_valid_down),
    .I_0(n233_I_0),
    .O(n233_O)
  );
  FIFO_1 n234 ( // @[Top.scala 207:22]
    .clock(n234_clock),
    .reset(n234_reset),
    .valid_up(n234_valid_up),
    .valid_down(n234_valid_down),
    .I(n234_I),
    .O(n234_O)
  );
  FIFO_1 n235 ( // @[Top.scala 210:22]
    .clock(n235_clock),
    .reset(n235_reset),
    .valid_up(n235_valid_up),
    .valid_down(n235_valid_down),
    .I(n235_I),
    .O(n235_O)
  );
  FIFO_1 n236 ( // @[Top.scala 213:22]
    .clock(n236_clock),
    .reset(n236_reset),
    .valid_up(n236_valid_up),
    .valid_down(n236_valid_down),
    .I(n236_I),
    .O(n236_O)
  );
  assign valid_down = n236_valid_down; // @[Top.scala 217:16]
  assign O = n236_O; // @[Top.scala 216:7]
  assign n1_clock = clock;
  assign n1_reset = reset;
  assign n1_valid_up = valid_up; // @[Top.scala 75:17]
  assign n1_I_0 = I_0; // @[Top.scala 74:10]
  assign n2_clock = clock;
  assign n2_reset = reset;
  assign n2_valid_up = n1_valid_down; // @[Top.scala 78:17]
  assign n2_I_0 = n1_O_0; // @[Top.scala 77:10]
  assign n3_clock = clock;
  assign n3_reset = reset;
  assign n3_valid_up = n2_valid_down; // @[Top.scala 81:17]
  assign n3_I_0 = n2_O_0; // @[Top.scala 80:10]
  assign n4_clock = clock;
  assign n4_valid_up = n3_valid_down; // @[Top.scala 84:17]
  assign n4_I_0 = n3_O_0; // @[Top.scala 83:10]
  assign n5_clock = clock;
  assign n5_valid_up = n4_valid_down; // @[Top.scala 87:17]
  assign n5_I_0 = n4_O_0; // @[Top.scala 86:10]
  assign n6_valid_up = n5_valid_down & n4_valid_down; // @[Top.scala 91:17]
  assign n6_I0_0 = n5_O_0; // @[Top.scala 89:11]
  assign n6_I1_0 = n4_O_0; // @[Top.scala 90:11]
  assign n13_valid_up = n6_valid_down & n3_valid_down; // @[Top.scala 95:18]
  assign n13_I0_0_0 = n6_O_0_0; // @[Top.scala 93:12]
  assign n13_I0_0_1 = n6_O_0_1; // @[Top.scala 93:12]
  assign n13_I1_0 = n3_O_0; // @[Top.scala 94:12]
  assign n22_valid_up = n13_valid_down; // @[Top.scala 98:18]
  assign n22_I_0_0 = n13_O_0_0; // @[Top.scala 97:11]
  assign n22_I_0_1 = n13_O_0_1; // @[Top.scala 97:11]
  assign n22_I_0_2 = n13_O_0_2; // @[Top.scala 97:11]
  assign n29_valid_up = n22_valid_down; // @[Top.scala 101:18]
  assign n29_I_0_0_0 = n22_O_0_0_0; // @[Top.scala 100:11]
  assign n29_I_0_0_1 = n22_O_0_0_1; // @[Top.scala 100:11]
  assign n29_I_0_0_2 = n22_O_0_0_2; // @[Top.scala 100:11]
  assign n30_clock = clock;
  assign n30_valid_up = n2_valid_down; // @[Top.scala 104:18]
  assign n30_I_0 = n2_O_0; // @[Top.scala 103:11]
  assign n31_clock = clock;
  assign n31_valid_up = n30_valid_down; // @[Top.scala 107:18]
  assign n31_I_0 = n30_O_0; // @[Top.scala 106:11]
  assign n32_valid_up = n31_valid_down & n30_valid_down; // @[Top.scala 111:18]
  assign n32_I0_0 = n31_O_0; // @[Top.scala 109:12]
  assign n32_I1_0 = n30_O_0; // @[Top.scala 110:12]
  assign n39_valid_up = n32_valid_down & n2_valid_down; // @[Top.scala 115:18]
  assign n39_I0_0_0 = n32_O_0_0; // @[Top.scala 113:12]
  assign n39_I0_0_1 = n32_O_0_1; // @[Top.scala 113:12]
  assign n39_I1_0 = n2_O_0; // @[Top.scala 114:12]
  assign n48_valid_up = n39_valid_down; // @[Top.scala 118:18]
  assign n48_I_0_0 = n39_O_0_0; // @[Top.scala 117:11]
  assign n48_I_0_1 = n39_O_0_1; // @[Top.scala 117:11]
  assign n48_I_0_2 = n39_O_0_2; // @[Top.scala 117:11]
  assign n55_valid_up = n48_valid_down; // @[Top.scala 121:18]
  assign n55_I_0_0_0 = n48_O_0_0_0; // @[Top.scala 120:11]
  assign n55_I_0_0_1 = n48_O_0_0_1; // @[Top.scala 120:11]
  assign n55_I_0_0_2 = n48_O_0_0_2; // @[Top.scala 120:11]
  assign n56_valid_up = n29_valid_down & n55_valid_down; // @[Top.scala 125:18]
  assign n56_I0_0_0 = n29_O_0_0; // @[Top.scala 123:12]
  assign n56_I0_0_1 = n29_O_0_1; // @[Top.scala 123:12]
  assign n56_I0_0_2 = n29_O_0_2; // @[Top.scala 123:12]
  assign n56_I1_0_0 = n55_O_0_0; // @[Top.scala 124:12]
  assign n56_I1_0_1 = n55_O_0_1; // @[Top.scala 124:12]
  assign n56_I1_0_2 = n55_O_0_2; // @[Top.scala 124:12]
  assign n63_clock = clock;
  assign n63_valid_up = n1_valid_down; // @[Top.scala 128:18]
  assign n63_I_0 = n1_O_0; // @[Top.scala 127:11]
  assign n64_clock = clock;
  assign n64_valid_up = n63_valid_down; // @[Top.scala 131:18]
  assign n64_I_0 = n63_O_0; // @[Top.scala 130:11]
  assign n65_valid_up = n64_valid_down & n63_valid_down; // @[Top.scala 135:18]
  assign n65_I0_0 = n64_O_0; // @[Top.scala 133:12]
  assign n65_I1_0 = n63_O_0; // @[Top.scala 134:12]
  assign n72_valid_up = n65_valid_down & n1_valid_down; // @[Top.scala 139:18]
  assign n72_I0_0_0 = n65_O_0_0; // @[Top.scala 137:12]
  assign n72_I0_0_1 = n65_O_0_1; // @[Top.scala 137:12]
  assign n72_I1_0 = n1_O_0; // @[Top.scala 138:12]
  assign n81_valid_up = n72_valid_down; // @[Top.scala 142:18]
  assign n81_I_0_0 = n72_O_0_0; // @[Top.scala 141:11]
  assign n81_I_0_1 = n72_O_0_1; // @[Top.scala 141:11]
  assign n81_I_0_2 = n72_O_0_2; // @[Top.scala 141:11]
  assign n88_valid_up = n81_valid_down; // @[Top.scala 145:18]
  assign n88_I_0_0_0 = n81_O_0_0_0; // @[Top.scala 144:11]
  assign n88_I_0_0_1 = n81_O_0_0_1; // @[Top.scala 144:11]
  assign n88_I_0_0_2 = n81_O_0_0_2; // @[Top.scala 144:11]
  assign n89_valid_up = n56_valid_down & n88_valid_down; // @[Top.scala 149:18]
  assign n89_I0_0_0_0 = n56_O_0_0_0; // @[Top.scala 147:12]
  assign n89_I0_0_0_1 = n56_O_0_0_1; // @[Top.scala 147:12]
  assign n89_I0_0_0_2 = n56_O_0_0_2; // @[Top.scala 147:12]
  assign n89_I0_0_1_0 = n56_O_0_1_0; // @[Top.scala 147:12]
  assign n89_I0_0_1_1 = n56_O_0_1_1; // @[Top.scala 147:12]
  assign n89_I0_0_1_2 = n56_O_0_1_2; // @[Top.scala 147:12]
  assign n89_I1_0_0 = n88_O_0_0; // @[Top.scala 148:12]
  assign n89_I1_0_1 = n88_O_0_1; // @[Top.scala 148:12]
  assign n89_I1_0_2 = n88_O_0_2; // @[Top.scala 148:12]
  assign n100_valid_up = n89_valid_down; // @[Top.scala 152:19]
  assign n100_I_0_0_0 = n89_O_0_0_0; // @[Top.scala 151:12]
  assign n100_I_0_0_1 = n89_O_0_0_1; // @[Top.scala 151:12]
  assign n100_I_0_0_2 = n89_O_0_0_2; // @[Top.scala 151:12]
  assign n100_I_0_1_0 = n89_O_0_1_0; // @[Top.scala 151:12]
  assign n100_I_0_1_1 = n89_O_0_1_1; // @[Top.scala 151:12]
  assign n100_I_0_1_2 = n89_O_0_1_2; // @[Top.scala 151:12]
  assign n100_I_0_2_0 = n89_O_0_2_0; // @[Top.scala 151:12]
  assign n100_I_0_2_1 = n89_O_0_2_1; // @[Top.scala 151:12]
  assign n100_I_0_2_2 = n89_O_0_2_2; // @[Top.scala 151:12]
  assign n140_clock = clock;
  assign n140_reset = reset;
  assign n140_valid_up = n100_valid_down; // @[Top.scala 155:19]
  assign n140_I_0_0 = n100_O_0_0; // @[Top.scala 154:12]
  assign n140_I_0_1 = n100_O_0_1; // @[Top.scala 154:12]
  assign n140_I_0_2 = n100_O_0_2; // @[Top.scala 154:12]
  assign n140_I_1_0 = n100_O_1_0; // @[Top.scala 154:12]
  assign n140_I_1_1 = n100_O_1_1; // @[Top.scala 154:12]
  assign n140_I_1_2 = n100_O_1_2; // @[Top.scala 154:12]
  assign n140_I_2_0 = n100_O_2_0; // @[Top.scala 154:12]
  assign n140_I_2_1 = n100_O_2_1; // @[Top.scala 154:12]
  assign n140_I_2_2 = n100_O_2_2; // @[Top.scala 154:12]
  assign n141_valid_up = n140_valid_down; // @[Top.scala 158:19]
  assign n141_I_0_0 = n140_O_0_0; // @[Top.scala 157:12]
  assign n142_valid_up = n141_valid_down; // @[Top.scala 161:19]
  assign n142_I_0 = n141_O_0; // @[Top.scala 160:12]
  assign n143_clock = clock;
  assign n143_reset = reset;
  assign n143_valid_up = n142_valid_down; // @[Top.scala 164:19]
  assign n143_I_0 = n142_O_0; // @[Top.scala 163:12]
  assign n144_clock = clock;
  assign n144_valid_up = n143_valid_down; // @[Top.scala 167:19]
  assign n144_I_0 = n143_O_0; // @[Top.scala 166:12]
  assign n145_valid_up = n144_valid_down & n143_valid_down; // @[Top.scala 171:19]
  assign n145_I0_0 = n144_O_0; // @[Top.scala 169:13]
  assign n145_I1_0 = n143_O_0; // @[Top.scala 170:13]
  assign n154_valid_up = n145_valid_down; // @[Top.scala 174:19]
  assign n154_I_0_0 = n145_O_0_0; // @[Top.scala 173:12]
  assign n154_I_0_1 = n145_O_0_1; // @[Top.scala 173:12]
  assign n161_valid_up = n154_valid_down; // @[Top.scala 177:19]
  assign n161_I_0_0_0 = n154_O_0_0_0; // @[Top.scala 176:12]
  assign n161_I_0_0_1 = n154_O_0_0_1; // @[Top.scala 176:12]
  assign n162_clock = clock;
  assign n162_valid_up = n142_valid_down; // @[Top.scala 180:19]
  assign n162_I_0 = n142_O_0; // @[Top.scala 179:12]
  assign n163_valid_up = n162_valid_down & n142_valid_down; // @[Top.scala 184:19]
  assign n163_I0_0 = n162_O_0; // @[Top.scala 182:13]
  assign n163_I1_0 = n142_O_0; // @[Top.scala 183:13]
  assign n172_valid_up = n163_valid_down; // @[Top.scala 187:19]
  assign n172_I_0_0 = n163_O_0_0; // @[Top.scala 186:12]
  assign n172_I_0_1 = n163_O_0_1; // @[Top.scala 186:12]
  assign n179_valid_up = n172_valid_down; // @[Top.scala 190:19]
  assign n179_I_0_0_0 = n172_O_0_0_0; // @[Top.scala 189:12]
  assign n179_I_0_0_1 = n172_O_0_0_1; // @[Top.scala 189:12]
  assign n180_valid_up = n161_valid_down & n179_valid_down; // @[Top.scala 194:19]
  assign n180_I0_0_0 = n161_O_0_0; // @[Top.scala 192:13]
  assign n180_I0_0_1 = n161_O_0_1; // @[Top.scala 192:13]
  assign n180_I1_0_0 = n179_O_0_0; // @[Top.scala 193:13]
  assign n180_I1_0_1 = n179_O_0_1; // @[Top.scala 193:13]
  assign n191_valid_up = n180_valid_down; // @[Top.scala 197:19]
  assign n191_I_0_0_0 = n180_O_0_0_0; // @[Top.scala 196:12]
  assign n191_I_0_0_1 = n180_O_0_0_1; // @[Top.scala 196:12]
  assign n191_I_0_1_0 = n180_O_0_1_0; // @[Top.scala 196:12]
  assign n191_I_0_1_1 = n180_O_0_1_1; // @[Top.scala 196:12]
  assign n231_clock = clock;
  assign n231_reset = reset;
  assign n231_valid_up = n191_valid_down; // @[Top.scala 200:19]
  assign n231_I_0_0 = n191_O_0_0; // @[Top.scala 199:12]
  assign n231_I_0_1 = n191_O_0_1; // @[Top.scala 199:12]
  assign n231_I_1_0 = n191_O_1_0; // @[Top.scala 199:12]
  assign n231_I_1_1 = n191_O_1_1; // @[Top.scala 199:12]
  assign n232_valid_up = n231_valid_down; // @[Top.scala 203:19]
  assign n232_I_0_0 = n231_O_0_0; // @[Top.scala 202:12]
  assign n233_valid_up = n232_valid_down; // @[Top.scala 206:19]
  assign n233_I_0 = n232_O_0; // @[Top.scala 205:12]
  assign n234_clock = clock;
  assign n234_reset = reset;
  assign n234_valid_up = n233_valid_down; // @[Top.scala 209:19]
  assign n234_I = n233_O; // @[Top.scala 208:12]
  assign n235_clock = clock;
  assign n235_reset = reset;
  assign n235_valid_up = n234_valid_down; // @[Top.scala 212:19]
  assign n235_I = n234_O; // @[Top.scala 211:12]
  assign n236_clock = clock;
  assign n236_reset = reset;
  assign n236_valid_up = n235_valid_down; // @[Top.scala 215:19]
  assign n236_I = n235_O; // @[Top.scala 214:12]
endmodule
