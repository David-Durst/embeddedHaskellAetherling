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
  output [7:0] O_0_0
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O_0_0 = I_0_0; // @[Passthrough.scala 17:68]
endmodule
module Passthrough_1(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0_0,
  output [7:0] O
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O = I_0_0; // @[Passthrough.scala 17:68]
endmodule
module Passthrough_2(
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
  reg [7:0] _T [0:2]; // @[FIFO.scala 23:33]
  reg [31:0] _RAND_0;
  wire [7:0] _T__T_17_data; // @[FIFO.scala 23:33]
  wire [1:0] _T__T_17_addr; // @[FIFO.scala 23:33]
  reg [31:0] _RAND_1;
  wire [7:0] _T__T_5_data; // @[FIFO.scala 23:33]
  wire [1:0] _T__T_5_addr; // @[FIFO.scala 23:33]
  wire  _T__T_5_mask; // @[FIFO.scala 23:33]
  wire  _T__T_5_en; // @[FIFO.scala 23:33]
  reg  _T__T_17_en_pipe_0;
  reg [31:0] _RAND_2;
  reg [1:0] _T__T_17_addr_pipe_0;
  reg [31:0] _RAND_3;
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_4;
  reg [1:0] value_1; // @[Counter.scala 29:33]
  reg [31:0] _RAND_5;
  reg [1:0] value_2; // @[Counter.scala 29:33]
  reg [31:0] _RAND_6;
  wire  _T_1; // @[FIFO.scala 33:46]
  wire  _T_2; // @[Counter.scala 37:24]
  wire [1:0] _T_4; // @[Counter.scala 38:22]
  wire  _T_6; // @[FIFO.scala 38:39]
  wire [1:0] _T_11; // @[Counter.scala 38:22]
  wire  _T_12; // @[FIFO.scala 42:39]
  wire  _T_18; // @[Counter.scala 37:24]
  wire [1:0] _T_20; // @[Counter.scala 38:22]
  wire  _GEN_8; // @[FIFO.scala 42:57]
  wire  _GEN_25; // @[FIFO.scala 39:15]
  assign _T__T_17_addr = _T__T_17_addr_pipe_0;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign _T__T_17_data = _T[_T__T_17_addr]; // @[FIFO.scala 23:33]
  `else
  assign _T__T_17_data = _T__T_17_addr >= 2'h3 ? _RAND_1[7:0] : _T[_T__T_17_addr]; // @[FIFO.scala 23:33]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign _T__T_5_data = I;
  assign _T__T_5_addr = value_2;
  assign _T__T_5_mask = 1'h1;
  assign _T__T_5_en = valid_up;
  assign _T_1 = value == 2'h2; // @[FIFO.scala 33:46]
  assign _T_2 = value_2 == 2'h2; // @[Counter.scala 37:24]
  assign _T_4 = value_2 + 2'h1; // @[Counter.scala 38:22]
  assign _T_6 = value < 2'h2; // @[FIFO.scala 38:39]
  assign _T_11 = value + 2'h1; // @[Counter.scala 38:22]
  assign _T_12 = value >= 2'h1; // @[FIFO.scala 42:39]
  assign _T_18 = value_1 == 2'h2; // @[Counter.scala 37:24]
  assign _T_20 = value_1 + 2'h1; // @[Counter.scala 38:22]
  assign _GEN_8 = _T_12 & _T_12; // @[FIFO.scala 42:57]
  assign valid_down = value == 2'h2; // @[FIFO.scala 33:16]
  assign O = _T__T_17_data; // @[FIFO.scala 43:11]
  assign _GEN_25 = valid_up & _T_6; // @[FIFO.scala 39:15]
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
  for (initvar = 0; initvar < 3; initvar = initvar+1)
    _T[initvar] = _RAND_0[7:0];
  `endif // RANDOMIZE_MEM_INIT
  _RAND_1 = {1{`RANDOM}};
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T__T_17_en_pipe_0 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T__T_17_addr_pipe_0 = _RAND_3[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  value = _RAND_4[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  value_1 = _RAND_5[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  value_2 = _RAND_6[1:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(_T__T_5_en & _T__T_5_mask) begin
      _T[_T__T_5_addr] <= _T__T_5_data; // @[FIFO.scala 23:33]
    end
    _T__T_17_en_pipe_0 <= valid_up & _GEN_8;
    if (valid_up & _GEN_8) begin
      _T__T_17_addr_pipe_0 <= value_1;
    end
    if (reset) begin
      value <= 2'h0;
    end else if (valid_up) begin
      if (_T_6) begin
        if (_T_1) begin
          value <= 2'h0;
        end else begin
          value <= _T_11;
        end
      end
    end
    if (reset) begin
      value_1 <= 2'h0;
    end else if (valid_up) begin
      if (_T_12) begin
        if (_T_18) begin
          value_1 <= 2'h0;
        end else begin
          value_1 <= _T_20;
        end
      end
    end
    if (reset) begin
      value_2 <= 2'h0;
    end else if (valid_up) begin
      if (_T_2) begin
        value_2 <= 2'h0;
      end else begin
        value_2 <= _T_4;
      end
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_25 & ~reset) begin
          $fwrite(32'h80000002,"idc inc\n"); // @[FIFO.scala 39:15]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
endmodule
module Sub(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  assign valid_down = valid_up; // @[Arithmetic.scala 139:14]
  assign O = I_t0b - I_t1b; // @[Arithmetic.scala 137:7]
endmodule
module Lt(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  wire  _T; // @[Arithmetic.scala 332:25]
  assign _T = I_t0b < I_t1b; // @[Arithmetic.scala 332:25]
  assign valid_down = valid_up; // @[Arithmetic.scala 334:14]
  assign O = {{7'd0}, _T}; // @[Arithmetic.scala 332:7]
endmodule
module AtomTuple_6(
  input   valid_up,
  output  valid_down,
  input   I0,
  input   I1,
  output  O_t0b,
  output  O_t1b
);
  assign valid_down = valid_up; // @[Tuple.scala 51:14]
  assign O_t0b = I0; // @[Tuple.scala 49:9]
  assign O_t1b = I1; // @[Tuple.scala 50:9]
endmodule
module Or(
  input   valid_up,
  output  valid_down,
  input   I_t0b,
  input   I_t1b,
  output  O
);
  assign valid_down = valid_up; // @[Arithmetic.scala 83:14]
  assign O = I_t0b | I_t1b; // @[Arithmetic.scala 82:5]
endmodule
module AtomTuple_8(
  input        valid_up,
  output       valid_down,
  input        I0,
  input  [7:0] I1_t0b,
  input  [7:0] I1_t1b,
  output       O_t0b,
  output [7:0] O_t1b_t0b,
  output [7:0] O_t1b_t1b
);
  assign valid_down = valid_up; // @[Tuple.scala 51:14]
  assign O_t0b = I0; // @[Tuple.scala 49:9]
  assign O_t1b_t0b = I1_t0b; // @[Tuple.scala 50:9]
  assign O_t1b_t1b = I1_t1b; // @[Tuple.scala 50:9]
endmodule
module If(
  input        valid_up,
  output       valid_down,
  input        I_t0b,
  input  [7:0] I_t1b_t0b,
  input  [7:0] I_t1b_t1b,
  output [7:0] O
);
  assign valid_down = valid_up; // @[Arithmetic.scala 395:14]
  assign O = I_t0b ? I_t1b_t0b : I_t1b_t1b; // @[Arithmetic.scala 393:9 Arithmetic.scala 394:20]
endmodule
module Add(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  assign valid_down = valid_up; // @[Arithmetic.scala 108:14]
  assign O = I_t0b + I_t1b; // @[Arithmetic.scala 106:7]
endmodule
module Module_1(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I0,
  input  [7:0] I1,
  output [7:0] O
);
  wire  InitialDelayCounter_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_valid_down; // @[Const.scala 11:33]
  wire  n152_valid_up; // @[Top.scala 46:22]
  wire  n152_valid_down; // @[Top.scala 46:22]
  wire [7:0] n152_I0; // @[Top.scala 46:22]
  wire [7:0] n152_I1; // @[Top.scala 46:22]
  wire [7:0] n152_O_t0b; // @[Top.scala 46:22]
  wire [7:0] n152_O_t1b; // @[Top.scala 46:22]
  wire  n153_valid_up; // @[Top.scala 50:22]
  wire  n153_valid_down; // @[Top.scala 50:22]
  wire [7:0] n153_I_t0b; // @[Top.scala 50:22]
  wire [7:0] n153_I_t1b; // @[Top.scala 50:22]
  wire [7:0] n153_O; // @[Top.scala 50:22]
  wire  n155_valid_up; // @[Top.scala 53:22]
  wire  n155_valid_down; // @[Top.scala 53:22]
  wire [7:0] n155_I0; // @[Top.scala 53:22]
  wire [7:0] n155_I1; // @[Top.scala 53:22]
  wire [7:0] n155_O_t0b; // @[Top.scala 53:22]
  wire [7:0] n155_O_t1b; // @[Top.scala 53:22]
  wire  n156_valid_up; // @[Top.scala 57:22]
  wire  n156_valid_down; // @[Top.scala 57:22]
  wire [7:0] n156_I_t0b; // @[Top.scala 57:22]
  wire [7:0] n156_I_t1b; // @[Top.scala 57:22]
  wire [7:0] n156_O; // @[Top.scala 57:22]
  wire  InitialDelayCounter_1_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_valid_down; // @[Const.scala 11:33]
  wire  n157_valid_up; // @[Top.scala 61:22]
  wire  n157_valid_down; // @[Top.scala 61:22]
  wire [7:0] n157_I0; // @[Top.scala 61:22]
  wire [7:0] n157_I1; // @[Top.scala 61:22]
  wire [7:0] n157_O_t0b; // @[Top.scala 61:22]
  wire [7:0] n157_O_t1b; // @[Top.scala 61:22]
  wire  n158_valid_up; // @[Top.scala 65:22]
  wire  n158_valid_down; // @[Top.scala 65:22]
  wire [7:0] n158_I_t0b; // @[Top.scala 65:22]
  wire [7:0] n158_I_t1b; // @[Top.scala 65:22]
  wire [7:0] n158_O; // @[Top.scala 65:22]
  wire  n160_valid_up; // @[Top.scala 68:22]
  wire  n160_valid_down; // @[Top.scala 68:22]
  wire [7:0] n160_I0; // @[Top.scala 68:22]
  wire [7:0] n160_I1; // @[Top.scala 68:22]
  wire [7:0] n160_O_t0b; // @[Top.scala 68:22]
  wire [7:0] n160_O_t1b; // @[Top.scala 68:22]
  wire  n161_valid_up; // @[Top.scala 72:22]
  wire  n161_valid_down; // @[Top.scala 72:22]
  wire [7:0] n161_I_t0b; // @[Top.scala 72:22]
  wire [7:0] n161_I_t1b; // @[Top.scala 72:22]
  wire [7:0] n161_O; // @[Top.scala 72:22]
  wire  n162_valid_up; // @[Top.scala 75:22]
  wire  n162_valid_down; // @[Top.scala 75:22]
  wire  n162_I0; // @[Top.scala 75:22]
  wire  n162_I1; // @[Top.scala 75:22]
  wire  n162_O_t0b; // @[Top.scala 75:22]
  wire  n162_O_t1b; // @[Top.scala 75:22]
  wire  n163_valid_up; // @[Top.scala 79:22]
  wire  n163_valid_down; // @[Top.scala 79:22]
  wire  n163_I_t0b; // @[Top.scala 79:22]
  wire  n163_I_t1b; // @[Top.scala 79:22]
  wire  n163_O; // @[Top.scala 79:22]
  wire  InitialDelayCounter_2_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_2_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_2_valid_down; // @[Const.scala 11:33]
  wire  n166_valid_up; // @[Top.scala 83:22]
  wire  n166_valid_down; // @[Top.scala 83:22]
  wire [7:0] n166_I0; // @[Top.scala 83:22]
  wire [7:0] n166_I1; // @[Top.scala 83:22]
  wire [7:0] n166_O_t0b; // @[Top.scala 83:22]
  wire [7:0] n166_O_t1b; // @[Top.scala 83:22]
  wire  n167_valid_up; // @[Top.scala 87:22]
  wire  n167_valid_down; // @[Top.scala 87:22]
  wire  n167_I0; // @[Top.scala 87:22]
  wire [7:0] n167_I1_t0b; // @[Top.scala 87:22]
  wire [7:0] n167_I1_t1b; // @[Top.scala 87:22]
  wire  n167_O_t0b; // @[Top.scala 87:22]
  wire [7:0] n167_O_t1b_t0b; // @[Top.scala 87:22]
  wire [7:0] n167_O_t1b_t1b; // @[Top.scala 87:22]
  wire  n168_valid_up; // @[Top.scala 91:22]
  wire  n168_valid_down; // @[Top.scala 91:22]
  wire  n168_I_t0b; // @[Top.scala 91:22]
  wire [7:0] n168_I_t1b_t0b; // @[Top.scala 91:22]
  wire [7:0] n168_I_t1b_t1b; // @[Top.scala 91:22]
  wire [7:0] n168_O; // @[Top.scala 91:22]
  wire  InitialDelayCounter_3_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_3_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_3_valid_down; // @[Const.scala 11:33]
  wire  n171_valid_up; // @[Top.scala 95:22]
  wire  n171_valid_down; // @[Top.scala 95:22]
  wire [7:0] n171_I0; // @[Top.scala 95:22]
  wire [7:0] n171_I1; // @[Top.scala 95:22]
  wire [7:0] n171_O_t0b; // @[Top.scala 95:22]
  wire [7:0] n171_O_t1b; // @[Top.scala 95:22]
  wire  n172_valid_up; // @[Top.scala 99:22]
  wire  n172_valid_down; // @[Top.scala 99:22]
  wire [7:0] n172_I_t0b; // @[Top.scala 99:22]
  wire [7:0] n172_I_t1b; // @[Top.scala 99:22]
  wire [7:0] n172_O; // @[Top.scala 99:22]
  wire  n173_valid_up; // @[Top.scala 102:22]
  wire  n173_valid_down; // @[Top.scala 102:22]
  wire [7:0] n173_I0; // @[Top.scala 102:22]
  wire [7:0] n173_I1; // @[Top.scala 102:22]
  wire [7:0] n173_O_t0b; // @[Top.scala 102:22]
  wire [7:0] n173_O_t1b; // @[Top.scala 102:22]
  wire  n174_valid_up; // @[Top.scala 106:22]
  wire  n174_valid_down; // @[Top.scala 106:22]
  wire [7:0] n174_I_t0b; // @[Top.scala 106:22]
  wire [7:0] n174_I_t1b; // @[Top.scala 106:22]
  wire [7:0] n174_O; // @[Top.scala 106:22]
  InitialDelayCounter_1 InitialDelayCounter ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_clock),
    .reset(InitialDelayCounter_reset),
    .valid_down(InitialDelayCounter_valid_down)
  );
  AtomTuple n152 ( // @[Top.scala 46:22]
    .valid_up(n152_valid_up),
    .valid_down(n152_valid_down),
    .I0(n152_I0),
    .I1(n152_I1),
    .O_t0b(n152_O_t0b),
    .O_t1b(n152_O_t1b)
  );
  Sub n153 ( // @[Top.scala 50:22]
    .valid_up(n153_valid_up),
    .valid_down(n153_valid_down),
    .I_t0b(n153_I_t0b),
    .I_t1b(n153_I_t1b),
    .O(n153_O)
  );
  AtomTuple n155 ( // @[Top.scala 53:22]
    .valid_up(n155_valid_up),
    .valid_down(n155_valid_down),
    .I0(n155_I0),
    .I1(n155_I1),
    .O_t0b(n155_O_t0b),
    .O_t1b(n155_O_t1b)
  );
  Lt n156 ( // @[Top.scala 57:22]
    .valid_up(n156_valid_up),
    .valid_down(n156_valid_down),
    .I_t0b(n156_I_t0b),
    .I_t1b(n156_I_t1b),
    .O(n156_O)
  );
  InitialDelayCounter_1 InitialDelayCounter_1 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_1_clock),
    .reset(InitialDelayCounter_1_reset),
    .valid_down(InitialDelayCounter_1_valid_down)
  );
  AtomTuple n157 ( // @[Top.scala 61:22]
    .valid_up(n157_valid_up),
    .valid_down(n157_valid_down),
    .I0(n157_I0),
    .I1(n157_I1),
    .O_t0b(n157_O_t0b),
    .O_t1b(n157_O_t1b)
  );
  Sub n158 ( // @[Top.scala 65:22]
    .valid_up(n158_valid_up),
    .valid_down(n158_valid_down),
    .I_t0b(n158_I_t0b),
    .I_t1b(n158_I_t1b),
    .O(n158_O)
  );
  AtomTuple n160 ( // @[Top.scala 68:22]
    .valid_up(n160_valid_up),
    .valid_down(n160_valid_down),
    .I0(n160_I0),
    .I1(n160_I1),
    .O_t0b(n160_O_t0b),
    .O_t1b(n160_O_t1b)
  );
  Lt n161 ( // @[Top.scala 72:22]
    .valid_up(n161_valid_up),
    .valid_down(n161_valid_down),
    .I_t0b(n161_I_t0b),
    .I_t1b(n161_I_t1b),
    .O(n161_O)
  );
  AtomTuple_6 n162 ( // @[Top.scala 75:22]
    .valid_up(n162_valid_up),
    .valid_down(n162_valid_down),
    .I0(n162_I0),
    .I1(n162_I1),
    .O_t0b(n162_O_t0b),
    .O_t1b(n162_O_t1b)
  );
  Or n163 ( // @[Top.scala 79:22]
    .valid_up(n163_valid_up),
    .valid_down(n163_valid_down),
    .I_t0b(n163_I_t0b),
    .I_t1b(n163_I_t1b),
    .O(n163_O)
  );
  InitialDelayCounter_1 InitialDelayCounter_2 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_2_clock),
    .reset(InitialDelayCounter_2_reset),
    .valid_down(InitialDelayCounter_2_valid_down)
  );
  AtomTuple n166 ( // @[Top.scala 83:22]
    .valid_up(n166_valid_up),
    .valid_down(n166_valid_down),
    .I0(n166_I0),
    .I1(n166_I1),
    .O_t0b(n166_O_t0b),
    .O_t1b(n166_O_t1b)
  );
  AtomTuple_8 n167 ( // @[Top.scala 87:22]
    .valid_up(n167_valid_up),
    .valid_down(n167_valid_down),
    .I0(n167_I0),
    .I1_t0b(n167_I1_t0b),
    .I1_t1b(n167_I1_t1b),
    .O_t0b(n167_O_t0b),
    .O_t1b_t0b(n167_O_t1b_t0b),
    .O_t1b_t1b(n167_O_t1b_t1b)
  );
  If n168 ( // @[Top.scala 91:22]
    .valid_up(n168_valid_up),
    .valid_down(n168_valid_down),
    .I_t0b(n168_I_t0b),
    .I_t1b_t0b(n168_I_t1b_t0b),
    .I_t1b_t1b(n168_I_t1b_t1b),
    .O(n168_O)
  );
  InitialDelayCounter_1 InitialDelayCounter_3 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_3_clock),
    .reset(InitialDelayCounter_3_reset),
    .valid_down(InitialDelayCounter_3_valid_down)
  );
  AtomTuple n171 ( // @[Top.scala 95:22]
    .valid_up(n171_valid_up),
    .valid_down(n171_valid_down),
    .I0(n171_I0),
    .I1(n171_I1),
    .O_t0b(n171_O_t0b),
    .O_t1b(n171_O_t1b)
  );
  RShift n172 ( // @[Top.scala 99:22]
    .valid_up(n172_valid_up),
    .valid_down(n172_valid_down),
    .I_t0b(n172_I_t0b),
    .I_t1b(n172_I_t1b),
    .O(n172_O)
  );
  AtomTuple n173 ( // @[Top.scala 102:22]
    .valid_up(n173_valid_up),
    .valid_down(n173_valid_down),
    .I0(n173_I0),
    .I1(n173_I1),
    .O_t0b(n173_O_t0b),
    .O_t1b(n173_O_t1b)
  );
  Add n174 ( // @[Top.scala 106:22]
    .valid_up(n174_valid_up),
    .valid_down(n174_valid_down),
    .I_t0b(n174_I_t0b),
    .I_t1b(n174_I_t1b),
    .O(n174_O)
  );
  assign valid_down = n174_valid_down; // @[Top.scala 110:16]
  assign O = n174_O; // @[Top.scala 109:7]
  assign InitialDelayCounter_clock = clock;
  assign InitialDelayCounter_reset = reset;
  assign n152_valid_up = valid_up; // @[Top.scala 49:19]
  assign n152_I0 = I0; // @[Top.scala 47:13]
  assign n152_I1 = I1; // @[Top.scala 48:13]
  assign n153_valid_up = n152_valid_down; // @[Top.scala 52:19]
  assign n153_I_t0b = n152_O_t0b; // @[Top.scala 51:12]
  assign n153_I_t1b = n152_O_t1b; // @[Top.scala 51:12]
  assign n155_valid_up = InitialDelayCounter_valid_down & n153_valid_down; // @[Top.scala 56:19]
  assign n155_I0 = 8'hf; // @[Top.scala 54:13]
  assign n155_I1 = n153_O; // @[Top.scala 55:13]
  assign n156_valid_up = n155_valid_down; // @[Top.scala 59:19]
  assign n156_I_t0b = n155_O_t0b; // @[Top.scala 58:12]
  assign n156_I_t1b = n155_O_t1b; // @[Top.scala 58:12]
  assign InitialDelayCounter_1_clock = clock;
  assign InitialDelayCounter_1_reset = reset;
  assign n157_valid_up = valid_up; // @[Top.scala 64:19]
  assign n157_I0 = I1; // @[Top.scala 62:13]
  assign n157_I1 = I0; // @[Top.scala 63:13]
  assign n158_valid_up = n157_valid_down; // @[Top.scala 67:19]
  assign n158_I_t0b = n157_O_t0b; // @[Top.scala 66:12]
  assign n158_I_t1b = n157_O_t1b; // @[Top.scala 66:12]
  assign n160_valid_up = InitialDelayCounter_1_valid_down & n158_valid_down; // @[Top.scala 71:19]
  assign n160_I0 = 8'hf; // @[Top.scala 69:13]
  assign n160_I1 = n158_O; // @[Top.scala 70:13]
  assign n161_valid_up = n160_valid_down; // @[Top.scala 74:19]
  assign n161_I_t0b = n160_O_t0b; // @[Top.scala 73:12]
  assign n161_I_t1b = n160_O_t1b; // @[Top.scala 73:12]
  assign n162_valid_up = n156_valid_down & n161_valid_down; // @[Top.scala 78:19]
  assign n162_I0 = n156_O[0]; // @[Top.scala 76:13]
  assign n162_I1 = n161_O[0]; // @[Top.scala 77:13]
  assign n163_valid_up = n162_valid_down; // @[Top.scala 81:19]
  assign n163_I_t0b = n162_O_t0b; // @[Top.scala 80:12]
  assign n163_I_t1b = n162_O_t1b; // @[Top.scala 80:12]
  assign InitialDelayCounter_2_clock = clock;
  assign InitialDelayCounter_2_reset = reset;
  assign n166_valid_up = n158_valid_down & InitialDelayCounter_2_valid_down; // @[Top.scala 86:19]
  assign n166_I0 = n158_O; // @[Top.scala 84:13]
  assign n166_I1 = 8'h0; // @[Top.scala 85:13]
  assign n167_valid_up = n163_valid_down & n166_valid_down; // @[Top.scala 90:19]
  assign n167_I0 = n163_O; // @[Top.scala 88:13]
  assign n167_I1_t0b = n166_O_t0b; // @[Top.scala 89:13]
  assign n167_I1_t1b = n166_O_t1b; // @[Top.scala 89:13]
  assign n168_valid_up = n167_valid_down; // @[Top.scala 93:19]
  assign n168_I_t0b = n167_O_t0b; // @[Top.scala 92:12]
  assign n168_I_t1b_t0b = n167_O_t1b_t0b; // @[Top.scala 92:12]
  assign n168_I_t1b_t1b = n167_O_t1b_t1b; // @[Top.scala 92:12]
  assign InitialDelayCounter_3_clock = clock;
  assign InitialDelayCounter_3_reset = reset;
  assign n171_valid_up = n168_valid_down & InitialDelayCounter_3_valid_down; // @[Top.scala 98:19]
  assign n171_I0 = n168_O; // @[Top.scala 96:13]
  assign n171_I1 = 8'h2; // @[Top.scala 97:13]
  assign n172_valid_up = n171_valid_down; // @[Top.scala 101:19]
  assign n172_I_t0b = n171_O_t0b; // @[Top.scala 100:12]
  assign n172_I_t1b = n171_O_t1b; // @[Top.scala 100:12]
  assign n173_valid_up = valid_up & n172_valid_down; // @[Top.scala 105:19]
  assign n173_I0 = I1; // @[Top.scala 103:13]
  assign n173_I1 = n172_O; // @[Top.scala 104:13]
  assign n174_valid_up = n173_valid_down; // @[Top.scala 108:19]
  assign n174_I_t0b = n173_O_t0b; // @[Top.scala 107:12]
  assign n174_I_t1b = n173_O_t1b; // @[Top.scala 107:12]
endmodule
module Map2T_8(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I0,
  input  [7:0] I1,
  output [7:0] O
);
  wire  op_clock; // @[Map2T.scala 8:20]
  wire  op_reset; // @[Map2T.scala 8:20]
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1; // @[Map2T.scala 8:20]
  wire [7:0] op_O; // @[Map2T.scala 8:20]
  Module_1 op ( // @[Map2T.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0(op_I0),
    .I1(op_I1),
    .O(op_O)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O = op_O; // @[Map2T.scala 17:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0 = I0; // @[Map2T.scala 15:11]
  assign op_I1 = I1; // @[Map2T.scala 16:11]
endmodule
module Map2T_9(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I0,
  input  [7:0] I1,
  output [7:0] O
);
  wire  op_clock; // @[Map2T.scala 8:20]
  wire  op_reset; // @[Map2T.scala 8:20]
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1; // @[Map2T.scala 8:20]
  wire [7:0] op_O; // @[Map2T.scala 8:20]
  Map2T_8 op ( // @[Map2T.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0(op_I0),
    .I1(op_I1),
    .O(op_O)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O = op_O; // @[Map2T.scala 17:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0 = I0; // @[Map2T.scala 15:11]
  assign op_I1 = I1; // @[Map2T.scala 16:11]
endmodule
module FIFO_2(
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
  wire  n1_clock; // @[Top.scala 116:20]
  wire  n1_reset; // @[Top.scala 116:20]
  wire  n1_valid_up; // @[Top.scala 116:20]
  wire  n1_valid_down; // @[Top.scala 116:20]
  wire [7:0] n1_I_0; // @[Top.scala 116:20]
  wire [7:0] n1_O_0; // @[Top.scala 116:20]
  wire  n2_clock; // @[Top.scala 119:20]
  wire  n2_reset; // @[Top.scala 119:20]
  wire  n2_valid_up; // @[Top.scala 119:20]
  wire  n2_valid_down; // @[Top.scala 119:20]
  wire [7:0] n2_I_0; // @[Top.scala 119:20]
  wire [7:0] n2_O_0; // @[Top.scala 119:20]
  wire  n3_clock; // @[Top.scala 122:20]
  wire  n3_reset; // @[Top.scala 122:20]
  wire  n3_valid_up; // @[Top.scala 122:20]
  wire  n3_valid_down; // @[Top.scala 122:20]
  wire [7:0] n3_I_0; // @[Top.scala 122:20]
  wire [7:0] n3_O_0; // @[Top.scala 122:20]
  wire  n4_clock; // @[Top.scala 125:20]
  wire  n4_valid_up; // @[Top.scala 125:20]
  wire  n4_valid_down; // @[Top.scala 125:20]
  wire [7:0] n4_I_0; // @[Top.scala 125:20]
  wire [7:0] n4_O_0; // @[Top.scala 125:20]
  wire  n5_clock; // @[Top.scala 128:20]
  wire  n5_valid_up; // @[Top.scala 128:20]
  wire  n5_valid_down; // @[Top.scala 128:20]
  wire [7:0] n5_I_0; // @[Top.scala 128:20]
  wire [7:0] n5_O_0; // @[Top.scala 128:20]
  wire  n6_valid_up; // @[Top.scala 131:20]
  wire  n6_valid_down; // @[Top.scala 131:20]
  wire [7:0] n6_I0_0; // @[Top.scala 131:20]
  wire [7:0] n6_I1_0; // @[Top.scala 131:20]
  wire [7:0] n6_O_0_0; // @[Top.scala 131:20]
  wire [7:0] n6_O_0_1; // @[Top.scala 131:20]
  wire  n13_valid_up; // @[Top.scala 135:21]
  wire  n13_valid_down; // @[Top.scala 135:21]
  wire [7:0] n13_I0_0_0; // @[Top.scala 135:21]
  wire [7:0] n13_I0_0_1; // @[Top.scala 135:21]
  wire [7:0] n13_I1_0; // @[Top.scala 135:21]
  wire [7:0] n13_O_0_0; // @[Top.scala 135:21]
  wire [7:0] n13_O_0_1; // @[Top.scala 135:21]
  wire [7:0] n13_O_0_2; // @[Top.scala 135:21]
  wire  n22_valid_up; // @[Top.scala 139:21]
  wire  n22_valid_down; // @[Top.scala 139:21]
  wire [7:0] n22_I_0_0; // @[Top.scala 139:21]
  wire [7:0] n22_I_0_1; // @[Top.scala 139:21]
  wire [7:0] n22_I_0_2; // @[Top.scala 139:21]
  wire [7:0] n22_O_0_0_0; // @[Top.scala 139:21]
  wire [7:0] n22_O_0_0_1; // @[Top.scala 139:21]
  wire [7:0] n22_O_0_0_2; // @[Top.scala 139:21]
  wire  n29_valid_up; // @[Top.scala 142:21]
  wire  n29_valid_down; // @[Top.scala 142:21]
  wire [7:0] n29_I_0_0_0; // @[Top.scala 142:21]
  wire [7:0] n29_I_0_0_1; // @[Top.scala 142:21]
  wire [7:0] n29_I_0_0_2; // @[Top.scala 142:21]
  wire [7:0] n29_O_0_0; // @[Top.scala 142:21]
  wire [7:0] n29_O_0_1; // @[Top.scala 142:21]
  wire [7:0] n29_O_0_2; // @[Top.scala 142:21]
  wire  n30_clock; // @[Top.scala 145:21]
  wire  n30_valid_up; // @[Top.scala 145:21]
  wire  n30_valid_down; // @[Top.scala 145:21]
  wire [7:0] n30_I_0; // @[Top.scala 145:21]
  wire [7:0] n30_O_0; // @[Top.scala 145:21]
  wire  n31_clock; // @[Top.scala 148:21]
  wire  n31_valid_up; // @[Top.scala 148:21]
  wire  n31_valid_down; // @[Top.scala 148:21]
  wire [7:0] n31_I_0; // @[Top.scala 148:21]
  wire [7:0] n31_O_0; // @[Top.scala 148:21]
  wire  n32_valid_up; // @[Top.scala 151:21]
  wire  n32_valid_down; // @[Top.scala 151:21]
  wire [7:0] n32_I0_0; // @[Top.scala 151:21]
  wire [7:0] n32_I1_0; // @[Top.scala 151:21]
  wire [7:0] n32_O_0_0; // @[Top.scala 151:21]
  wire [7:0] n32_O_0_1; // @[Top.scala 151:21]
  wire  n39_valid_up; // @[Top.scala 155:21]
  wire  n39_valid_down; // @[Top.scala 155:21]
  wire [7:0] n39_I0_0_0; // @[Top.scala 155:21]
  wire [7:0] n39_I0_0_1; // @[Top.scala 155:21]
  wire [7:0] n39_I1_0; // @[Top.scala 155:21]
  wire [7:0] n39_O_0_0; // @[Top.scala 155:21]
  wire [7:0] n39_O_0_1; // @[Top.scala 155:21]
  wire [7:0] n39_O_0_2; // @[Top.scala 155:21]
  wire  n48_valid_up; // @[Top.scala 159:21]
  wire  n48_valid_down; // @[Top.scala 159:21]
  wire [7:0] n48_I_0_0; // @[Top.scala 159:21]
  wire [7:0] n48_I_0_1; // @[Top.scala 159:21]
  wire [7:0] n48_I_0_2; // @[Top.scala 159:21]
  wire [7:0] n48_O_0_0_0; // @[Top.scala 159:21]
  wire [7:0] n48_O_0_0_1; // @[Top.scala 159:21]
  wire [7:0] n48_O_0_0_2; // @[Top.scala 159:21]
  wire  n55_valid_up; // @[Top.scala 162:21]
  wire  n55_valid_down; // @[Top.scala 162:21]
  wire [7:0] n55_I_0_0_0; // @[Top.scala 162:21]
  wire [7:0] n55_I_0_0_1; // @[Top.scala 162:21]
  wire [7:0] n55_I_0_0_2; // @[Top.scala 162:21]
  wire [7:0] n55_O_0_0; // @[Top.scala 162:21]
  wire [7:0] n55_O_0_1; // @[Top.scala 162:21]
  wire [7:0] n55_O_0_2; // @[Top.scala 162:21]
  wire  n56_valid_up; // @[Top.scala 165:21]
  wire  n56_valid_down; // @[Top.scala 165:21]
  wire [7:0] n56_I0_0_0; // @[Top.scala 165:21]
  wire [7:0] n56_I0_0_1; // @[Top.scala 165:21]
  wire [7:0] n56_I0_0_2; // @[Top.scala 165:21]
  wire [7:0] n56_I1_0_0; // @[Top.scala 165:21]
  wire [7:0] n56_I1_0_1; // @[Top.scala 165:21]
  wire [7:0] n56_I1_0_2; // @[Top.scala 165:21]
  wire [7:0] n56_O_0_0_0; // @[Top.scala 165:21]
  wire [7:0] n56_O_0_0_1; // @[Top.scala 165:21]
  wire [7:0] n56_O_0_0_2; // @[Top.scala 165:21]
  wire [7:0] n56_O_0_1_0; // @[Top.scala 165:21]
  wire [7:0] n56_O_0_1_1; // @[Top.scala 165:21]
  wire [7:0] n56_O_0_1_2; // @[Top.scala 165:21]
  wire  n63_clock; // @[Top.scala 169:21]
  wire  n63_valid_up; // @[Top.scala 169:21]
  wire  n63_valid_down; // @[Top.scala 169:21]
  wire [7:0] n63_I_0; // @[Top.scala 169:21]
  wire [7:0] n63_O_0; // @[Top.scala 169:21]
  wire  n64_clock; // @[Top.scala 172:21]
  wire  n64_valid_up; // @[Top.scala 172:21]
  wire  n64_valid_down; // @[Top.scala 172:21]
  wire [7:0] n64_I_0; // @[Top.scala 172:21]
  wire [7:0] n64_O_0; // @[Top.scala 172:21]
  wire  n65_valid_up; // @[Top.scala 175:21]
  wire  n65_valid_down; // @[Top.scala 175:21]
  wire [7:0] n65_I0_0; // @[Top.scala 175:21]
  wire [7:0] n65_I1_0; // @[Top.scala 175:21]
  wire [7:0] n65_O_0_0; // @[Top.scala 175:21]
  wire [7:0] n65_O_0_1; // @[Top.scala 175:21]
  wire  n72_valid_up; // @[Top.scala 179:21]
  wire  n72_valid_down; // @[Top.scala 179:21]
  wire [7:0] n72_I0_0_0; // @[Top.scala 179:21]
  wire [7:0] n72_I0_0_1; // @[Top.scala 179:21]
  wire [7:0] n72_I1_0; // @[Top.scala 179:21]
  wire [7:0] n72_O_0_0; // @[Top.scala 179:21]
  wire [7:0] n72_O_0_1; // @[Top.scala 179:21]
  wire [7:0] n72_O_0_2; // @[Top.scala 179:21]
  wire  n81_valid_up; // @[Top.scala 183:21]
  wire  n81_valid_down; // @[Top.scala 183:21]
  wire [7:0] n81_I_0_0; // @[Top.scala 183:21]
  wire [7:0] n81_I_0_1; // @[Top.scala 183:21]
  wire [7:0] n81_I_0_2; // @[Top.scala 183:21]
  wire [7:0] n81_O_0_0_0; // @[Top.scala 183:21]
  wire [7:0] n81_O_0_0_1; // @[Top.scala 183:21]
  wire [7:0] n81_O_0_0_2; // @[Top.scala 183:21]
  wire  n88_valid_up; // @[Top.scala 186:21]
  wire  n88_valid_down; // @[Top.scala 186:21]
  wire [7:0] n88_I_0_0_0; // @[Top.scala 186:21]
  wire [7:0] n88_I_0_0_1; // @[Top.scala 186:21]
  wire [7:0] n88_I_0_0_2; // @[Top.scala 186:21]
  wire [7:0] n88_O_0_0; // @[Top.scala 186:21]
  wire [7:0] n88_O_0_1; // @[Top.scala 186:21]
  wire [7:0] n88_O_0_2; // @[Top.scala 186:21]
  wire  n89_valid_up; // @[Top.scala 189:21]
  wire  n89_valid_down; // @[Top.scala 189:21]
  wire [7:0] n89_I0_0_0_0; // @[Top.scala 189:21]
  wire [7:0] n89_I0_0_0_1; // @[Top.scala 189:21]
  wire [7:0] n89_I0_0_0_2; // @[Top.scala 189:21]
  wire [7:0] n89_I0_0_1_0; // @[Top.scala 189:21]
  wire [7:0] n89_I0_0_1_1; // @[Top.scala 189:21]
  wire [7:0] n89_I0_0_1_2; // @[Top.scala 189:21]
  wire [7:0] n89_I1_0_0; // @[Top.scala 189:21]
  wire [7:0] n89_I1_0_1; // @[Top.scala 189:21]
  wire [7:0] n89_I1_0_2; // @[Top.scala 189:21]
  wire [7:0] n89_O_0_0_0; // @[Top.scala 189:21]
  wire [7:0] n89_O_0_0_1; // @[Top.scala 189:21]
  wire [7:0] n89_O_0_0_2; // @[Top.scala 189:21]
  wire [7:0] n89_O_0_1_0; // @[Top.scala 189:21]
  wire [7:0] n89_O_0_1_1; // @[Top.scala 189:21]
  wire [7:0] n89_O_0_1_2; // @[Top.scala 189:21]
  wire [7:0] n89_O_0_2_0; // @[Top.scala 189:21]
  wire [7:0] n89_O_0_2_1; // @[Top.scala 189:21]
  wire [7:0] n89_O_0_2_2; // @[Top.scala 189:21]
  wire  n100_valid_up; // @[Top.scala 193:22]
  wire  n100_valid_down; // @[Top.scala 193:22]
  wire [7:0] n100_I_0_0_0; // @[Top.scala 193:22]
  wire [7:0] n100_I_0_0_1; // @[Top.scala 193:22]
  wire [7:0] n100_I_0_0_2; // @[Top.scala 193:22]
  wire [7:0] n100_I_0_1_0; // @[Top.scala 193:22]
  wire [7:0] n100_I_0_1_1; // @[Top.scala 193:22]
  wire [7:0] n100_I_0_1_2; // @[Top.scala 193:22]
  wire [7:0] n100_I_0_2_0; // @[Top.scala 193:22]
  wire [7:0] n100_I_0_2_1; // @[Top.scala 193:22]
  wire [7:0] n100_I_0_2_2; // @[Top.scala 193:22]
  wire [7:0] n100_O_0_0; // @[Top.scala 193:22]
  wire [7:0] n100_O_0_1; // @[Top.scala 193:22]
  wire [7:0] n100_O_0_2; // @[Top.scala 193:22]
  wire [7:0] n100_O_1_0; // @[Top.scala 193:22]
  wire [7:0] n100_O_1_1; // @[Top.scala 193:22]
  wire [7:0] n100_O_1_2; // @[Top.scala 193:22]
  wire [7:0] n100_O_2_0; // @[Top.scala 193:22]
  wire [7:0] n100_O_2_1; // @[Top.scala 193:22]
  wire [7:0] n100_O_2_2; // @[Top.scala 193:22]
  wire  n140_clock; // @[Top.scala 196:22]
  wire  n140_reset; // @[Top.scala 196:22]
  wire  n140_valid_up; // @[Top.scala 196:22]
  wire  n140_valid_down; // @[Top.scala 196:22]
  wire [7:0] n140_I_0_0; // @[Top.scala 196:22]
  wire [7:0] n140_I_0_1; // @[Top.scala 196:22]
  wire [7:0] n140_I_0_2; // @[Top.scala 196:22]
  wire [7:0] n140_I_1_0; // @[Top.scala 196:22]
  wire [7:0] n140_I_1_1; // @[Top.scala 196:22]
  wire [7:0] n140_I_1_2; // @[Top.scala 196:22]
  wire [7:0] n140_I_2_0; // @[Top.scala 196:22]
  wire [7:0] n140_I_2_1; // @[Top.scala 196:22]
  wire [7:0] n140_I_2_2; // @[Top.scala 196:22]
  wire [7:0] n140_O_0_0; // @[Top.scala 196:22]
  wire  n141_valid_up; // @[Top.scala 199:22]
  wire  n141_valid_down; // @[Top.scala 199:22]
  wire [7:0] n141_I_0_0; // @[Top.scala 199:22]
  wire [7:0] n141_O_0_0; // @[Top.scala 199:22]
  wire  n142_valid_up; // @[Top.scala 202:22]
  wire  n142_valid_down; // @[Top.scala 202:22]
  wire [7:0] n142_I_0_0; // @[Top.scala 202:22]
  wire [7:0] n142_O; // @[Top.scala 202:22]
  wire  n143_valid_up; // @[Top.scala 205:22]
  wire  n143_valid_down; // @[Top.scala 205:22]
  wire [7:0] n143_I_0; // @[Top.scala 205:22]
  wire [7:0] n143_O; // @[Top.scala 205:22]
  wire  n144_clock; // @[Top.scala 208:22]
  wire  n144_reset; // @[Top.scala 208:22]
  wire  n144_valid_up; // @[Top.scala 208:22]
  wire  n144_valid_down; // @[Top.scala 208:22]
  wire [7:0] n144_I; // @[Top.scala 208:22]
  wire [7:0] n144_O; // @[Top.scala 208:22]
  wire  n145_clock; // @[Top.scala 211:22]
  wire  n145_reset; // @[Top.scala 211:22]
  wire  n145_valid_up; // @[Top.scala 211:22]
  wire  n145_valid_down; // @[Top.scala 211:22]
  wire [7:0] n145_I0; // @[Top.scala 211:22]
  wire [7:0] n145_I1; // @[Top.scala 211:22]
  wire [7:0] n145_O; // @[Top.scala 211:22]
  wire  n175_clock; // @[Top.scala 215:22]
  wire  n175_reset; // @[Top.scala 215:22]
  wire  n175_valid_up; // @[Top.scala 215:22]
  wire  n175_valid_down; // @[Top.scala 215:22]
  wire [7:0] n175_I; // @[Top.scala 215:22]
  wire [7:0] n175_O; // @[Top.scala 215:22]
  wire  n176_clock; // @[Top.scala 218:22]
  wire  n176_reset; // @[Top.scala 218:22]
  wire  n176_valid_up; // @[Top.scala 218:22]
  wire  n176_valid_down; // @[Top.scala 218:22]
  wire [7:0] n176_I; // @[Top.scala 218:22]
  wire [7:0] n176_O; // @[Top.scala 218:22]
  wire  n177_clock; // @[Top.scala 221:22]
  wire  n177_reset; // @[Top.scala 221:22]
  wire  n177_valid_up; // @[Top.scala 221:22]
  wire  n177_valid_down; // @[Top.scala 221:22]
  wire [7:0] n177_I; // @[Top.scala 221:22]
  wire [7:0] n177_O; // @[Top.scala 221:22]
  FIFO n1 ( // @[Top.scala 116:20]
    .clock(n1_clock),
    .reset(n1_reset),
    .valid_up(n1_valid_up),
    .valid_down(n1_valid_down),
    .I_0(n1_I_0),
    .O_0(n1_O_0)
  );
  ShiftT n2 ( // @[Top.scala 119:20]
    .clock(n2_clock),
    .reset(n2_reset),
    .valid_up(n2_valid_up),
    .valid_down(n2_valid_down),
    .I_0(n2_I_0),
    .O_0(n2_O_0)
  );
  ShiftT n3 ( // @[Top.scala 122:20]
    .clock(n3_clock),
    .reset(n3_reset),
    .valid_up(n3_valid_up),
    .valid_down(n3_valid_down),
    .I_0(n3_I_0),
    .O_0(n3_O_0)
  );
  ShiftT_2 n4 ( // @[Top.scala 125:20]
    .clock(n4_clock),
    .valid_up(n4_valid_up),
    .valid_down(n4_valid_down),
    .I_0(n4_I_0),
    .O_0(n4_O_0)
  );
  ShiftT_2 n5 ( // @[Top.scala 128:20]
    .clock(n5_clock),
    .valid_up(n5_valid_up),
    .valid_down(n5_valid_down),
    .I_0(n5_I_0),
    .O_0(n5_O_0)
  );
  Map2T n6 ( // @[Top.scala 131:20]
    .valid_up(n6_valid_up),
    .valid_down(n6_valid_down),
    .I0_0(n6_I0_0),
    .I1_0(n6_I1_0),
    .O_0_0(n6_O_0_0),
    .O_0_1(n6_O_0_1)
  );
  Map2T_1 n13 ( // @[Top.scala 135:21]
    .valid_up(n13_valid_up),
    .valid_down(n13_valid_down),
    .I0_0_0(n13_I0_0_0),
    .I0_0_1(n13_I0_0_1),
    .I1_0(n13_I1_0),
    .O_0_0(n13_O_0_0),
    .O_0_1(n13_O_0_1),
    .O_0_2(n13_O_0_2)
  );
  MapT n22 ( // @[Top.scala 139:21]
    .valid_up(n22_valid_up),
    .valid_down(n22_valid_down),
    .I_0_0(n22_I_0_0),
    .I_0_1(n22_I_0_1),
    .I_0_2(n22_I_0_2),
    .O_0_0_0(n22_O_0_0_0),
    .O_0_0_1(n22_O_0_0_1),
    .O_0_0_2(n22_O_0_0_2)
  );
  MapT_1 n29 ( // @[Top.scala 142:21]
    .valid_up(n29_valid_up),
    .valid_down(n29_valid_down),
    .I_0_0_0(n29_I_0_0_0),
    .I_0_0_1(n29_I_0_0_1),
    .I_0_0_2(n29_I_0_0_2),
    .O_0_0(n29_O_0_0),
    .O_0_1(n29_O_0_1),
    .O_0_2(n29_O_0_2)
  );
  ShiftT_2 n30 ( // @[Top.scala 145:21]
    .clock(n30_clock),
    .valid_up(n30_valid_up),
    .valid_down(n30_valid_down),
    .I_0(n30_I_0),
    .O_0(n30_O_0)
  );
  ShiftT_2 n31 ( // @[Top.scala 148:21]
    .clock(n31_clock),
    .valid_up(n31_valid_up),
    .valid_down(n31_valid_down),
    .I_0(n31_I_0),
    .O_0(n31_O_0)
  );
  Map2T n32 ( // @[Top.scala 151:21]
    .valid_up(n32_valid_up),
    .valid_down(n32_valid_down),
    .I0_0(n32_I0_0),
    .I1_0(n32_I1_0),
    .O_0_0(n32_O_0_0),
    .O_0_1(n32_O_0_1)
  );
  Map2T_1 n39 ( // @[Top.scala 155:21]
    .valid_up(n39_valid_up),
    .valid_down(n39_valid_down),
    .I0_0_0(n39_I0_0_0),
    .I0_0_1(n39_I0_0_1),
    .I1_0(n39_I1_0),
    .O_0_0(n39_O_0_0),
    .O_0_1(n39_O_0_1),
    .O_0_2(n39_O_0_2)
  );
  MapT n48 ( // @[Top.scala 159:21]
    .valid_up(n48_valid_up),
    .valid_down(n48_valid_down),
    .I_0_0(n48_I_0_0),
    .I_0_1(n48_I_0_1),
    .I_0_2(n48_I_0_2),
    .O_0_0_0(n48_O_0_0_0),
    .O_0_0_1(n48_O_0_0_1),
    .O_0_0_2(n48_O_0_0_2)
  );
  MapT_1 n55 ( // @[Top.scala 162:21]
    .valid_up(n55_valid_up),
    .valid_down(n55_valid_down),
    .I_0_0_0(n55_I_0_0_0),
    .I_0_0_1(n55_I_0_0_1),
    .I_0_0_2(n55_I_0_0_2),
    .O_0_0(n55_O_0_0),
    .O_0_1(n55_O_0_1),
    .O_0_2(n55_O_0_2)
  );
  Map2T_4 n56 ( // @[Top.scala 165:21]
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
  ShiftT_2 n63 ( // @[Top.scala 169:21]
    .clock(n63_clock),
    .valid_up(n63_valid_up),
    .valid_down(n63_valid_down),
    .I_0(n63_I_0),
    .O_0(n63_O_0)
  );
  ShiftT_2 n64 ( // @[Top.scala 172:21]
    .clock(n64_clock),
    .valid_up(n64_valid_up),
    .valid_down(n64_valid_down),
    .I_0(n64_I_0),
    .O_0(n64_O_0)
  );
  Map2T n65 ( // @[Top.scala 175:21]
    .valid_up(n65_valid_up),
    .valid_down(n65_valid_down),
    .I0_0(n65_I0_0),
    .I1_0(n65_I1_0),
    .O_0_0(n65_O_0_0),
    .O_0_1(n65_O_0_1)
  );
  Map2T_1 n72 ( // @[Top.scala 179:21]
    .valid_up(n72_valid_up),
    .valid_down(n72_valid_down),
    .I0_0_0(n72_I0_0_0),
    .I0_0_1(n72_I0_0_1),
    .I1_0(n72_I1_0),
    .O_0_0(n72_O_0_0),
    .O_0_1(n72_O_0_1),
    .O_0_2(n72_O_0_2)
  );
  MapT n81 ( // @[Top.scala 183:21]
    .valid_up(n81_valid_up),
    .valid_down(n81_valid_down),
    .I_0_0(n81_I_0_0),
    .I_0_1(n81_I_0_1),
    .I_0_2(n81_I_0_2),
    .O_0_0_0(n81_O_0_0_0),
    .O_0_0_1(n81_O_0_0_1),
    .O_0_0_2(n81_O_0_0_2)
  );
  MapT_1 n88 ( // @[Top.scala 186:21]
    .valid_up(n88_valid_up),
    .valid_down(n88_valid_down),
    .I_0_0_0(n88_I_0_0_0),
    .I_0_0_1(n88_I_0_0_1),
    .I_0_0_2(n88_I_0_0_2),
    .O_0_0(n88_O_0_0),
    .O_0_1(n88_O_0_1),
    .O_0_2(n88_O_0_2)
  );
  Map2T_7 n89 ( // @[Top.scala 189:21]
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
  MapT_6 n100 ( // @[Top.scala 193:22]
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
  MapT_7 n140 ( // @[Top.scala 196:22]
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
  Passthrough n141 ( // @[Top.scala 199:22]
    .valid_up(n141_valid_up),
    .valid_down(n141_valid_down),
    .I_0_0(n141_I_0_0),
    .O_0_0(n141_O_0_0)
  );
  Passthrough_1 n142 ( // @[Top.scala 202:22]
    .valid_up(n142_valid_up),
    .valid_down(n142_valid_down),
    .I_0_0(n142_I_0_0),
    .O(n142_O)
  );
  Passthrough_2 n143 ( // @[Top.scala 205:22]
    .valid_up(n143_valid_up),
    .valid_down(n143_valid_down),
    .I_0(n143_I_0),
    .O(n143_O)
  );
  FIFO_1 n144 ( // @[Top.scala 208:22]
    .clock(n144_clock),
    .reset(n144_reset),
    .valid_up(n144_valid_up),
    .valid_down(n144_valid_down),
    .I(n144_I),
    .O(n144_O)
  );
  Map2T_9 n145 ( // @[Top.scala 211:22]
    .clock(n145_clock),
    .reset(n145_reset),
    .valid_up(n145_valid_up),
    .valid_down(n145_valid_down),
    .I0(n145_I0),
    .I1(n145_I1),
    .O(n145_O)
  );
  FIFO_2 n175 ( // @[Top.scala 215:22]
    .clock(n175_clock),
    .reset(n175_reset),
    .valid_up(n175_valid_up),
    .valid_down(n175_valid_down),
    .I(n175_I),
    .O(n175_O)
  );
  FIFO_2 n176 ( // @[Top.scala 218:22]
    .clock(n176_clock),
    .reset(n176_reset),
    .valid_up(n176_valid_up),
    .valid_down(n176_valid_down),
    .I(n176_I),
    .O(n176_O)
  );
  FIFO_2 n177 ( // @[Top.scala 221:22]
    .clock(n177_clock),
    .reset(n177_reset),
    .valid_up(n177_valid_up),
    .valid_down(n177_valid_down),
    .I(n177_I),
    .O(n177_O)
  );
  assign valid_down = n177_valid_down; // @[Top.scala 225:16]
  assign O = n177_O; // @[Top.scala 224:7]
  assign n1_clock = clock;
  assign n1_reset = reset;
  assign n1_valid_up = valid_up; // @[Top.scala 118:17]
  assign n1_I_0 = I_0; // @[Top.scala 117:10]
  assign n2_clock = clock;
  assign n2_reset = reset;
  assign n2_valid_up = n1_valid_down; // @[Top.scala 121:17]
  assign n2_I_0 = n1_O_0; // @[Top.scala 120:10]
  assign n3_clock = clock;
  assign n3_reset = reset;
  assign n3_valid_up = n2_valid_down; // @[Top.scala 124:17]
  assign n3_I_0 = n2_O_0; // @[Top.scala 123:10]
  assign n4_clock = clock;
  assign n4_valid_up = n3_valid_down; // @[Top.scala 127:17]
  assign n4_I_0 = n3_O_0; // @[Top.scala 126:10]
  assign n5_clock = clock;
  assign n5_valid_up = n4_valid_down; // @[Top.scala 130:17]
  assign n5_I_0 = n4_O_0; // @[Top.scala 129:10]
  assign n6_valid_up = n5_valid_down & n4_valid_down; // @[Top.scala 134:17]
  assign n6_I0_0 = n5_O_0; // @[Top.scala 132:11]
  assign n6_I1_0 = n4_O_0; // @[Top.scala 133:11]
  assign n13_valid_up = n6_valid_down & n3_valid_down; // @[Top.scala 138:18]
  assign n13_I0_0_0 = n6_O_0_0; // @[Top.scala 136:12]
  assign n13_I0_0_1 = n6_O_0_1; // @[Top.scala 136:12]
  assign n13_I1_0 = n3_O_0; // @[Top.scala 137:12]
  assign n22_valid_up = n13_valid_down; // @[Top.scala 141:18]
  assign n22_I_0_0 = n13_O_0_0; // @[Top.scala 140:11]
  assign n22_I_0_1 = n13_O_0_1; // @[Top.scala 140:11]
  assign n22_I_0_2 = n13_O_0_2; // @[Top.scala 140:11]
  assign n29_valid_up = n22_valid_down; // @[Top.scala 144:18]
  assign n29_I_0_0_0 = n22_O_0_0_0; // @[Top.scala 143:11]
  assign n29_I_0_0_1 = n22_O_0_0_1; // @[Top.scala 143:11]
  assign n29_I_0_0_2 = n22_O_0_0_2; // @[Top.scala 143:11]
  assign n30_clock = clock;
  assign n30_valid_up = n2_valid_down; // @[Top.scala 147:18]
  assign n30_I_0 = n2_O_0; // @[Top.scala 146:11]
  assign n31_clock = clock;
  assign n31_valid_up = n30_valid_down; // @[Top.scala 150:18]
  assign n31_I_0 = n30_O_0; // @[Top.scala 149:11]
  assign n32_valid_up = n31_valid_down & n30_valid_down; // @[Top.scala 154:18]
  assign n32_I0_0 = n31_O_0; // @[Top.scala 152:12]
  assign n32_I1_0 = n30_O_0; // @[Top.scala 153:12]
  assign n39_valid_up = n32_valid_down & n2_valid_down; // @[Top.scala 158:18]
  assign n39_I0_0_0 = n32_O_0_0; // @[Top.scala 156:12]
  assign n39_I0_0_1 = n32_O_0_1; // @[Top.scala 156:12]
  assign n39_I1_0 = n2_O_0; // @[Top.scala 157:12]
  assign n48_valid_up = n39_valid_down; // @[Top.scala 161:18]
  assign n48_I_0_0 = n39_O_0_0; // @[Top.scala 160:11]
  assign n48_I_0_1 = n39_O_0_1; // @[Top.scala 160:11]
  assign n48_I_0_2 = n39_O_0_2; // @[Top.scala 160:11]
  assign n55_valid_up = n48_valid_down; // @[Top.scala 164:18]
  assign n55_I_0_0_0 = n48_O_0_0_0; // @[Top.scala 163:11]
  assign n55_I_0_0_1 = n48_O_0_0_1; // @[Top.scala 163:11]
  assign n55_I_0_0_2 = n48_O_0_0_2; // @[Top.scala 163:11]
  assign n56_valid_up = n29_valid_down & n55_valid_down; // @[Top.scala 168:18]
  assign n56_I0_0_0 = n29_O_0_0; // @[Top.scala 166:12]
  assign n56_I0_0_1 = n29_O_0_1; // @[Top.scala 166:12]
  assign n56_I0_0_2 = n29_O_0_2; // @[Top.scala 166:12]
  assign n56_I1_0_0 = n55_O_0_0; // @[Top.scala 167:12]
  assign n56_I1_0_1 = n55_O_0_1; // @[Top.scala 167:12]
  assign n56_I1_0_2 = n55_O_0_2; // @[Top.scala 167:12]
  assign n63_clock = clock;
  assign n63_valid_up = n1_valid_down; // @[Top.scala 171:18]
  assign n63_I_0 = n1_O_0; // @[Top.scala 170:11]
  assign n64_clock = clock;
  assign n64_valid_up = n63_valid_down; // @[Top.scala 174:18]
  assign n64_I_0 = n63_O_0; // @[Top.scala 173:11]
  assign n65_valid_up = n64_valid_down & n63_valid_down; // @[Top.scala 178:18]
  assign n65_I0_0 = n64_O_0; // @[Top.scala 176:12]
  assign n65_I1_0 = n63_O_0; // @[Top.scala 177:12]
  assign n72_valid_up = n65_valid_down & n1_valid_down; // @[Top.scala 182:18]
  assign n72_I0_0_0 = n65_O_0_0; // @[Top.scala 180:12]
  assign n72_I0_0_1 = n65_O_0_1; // @[Top.scala 180:12]
  assign n72_I1_0 = n1_O_0; // @[Top.scala 181:12]
  assign n81_valid_up = n72_valid_down; // @[Top.scala 185:18]
  assign n81_I_0_0 = n72_O_0_0; // @[Top.scala 184:11]
  assign n81_I_0_1 = n72_O_0_1; // @[Top.scala 184:11]
  assign n81_I_0_2 = n72_O_0_2; // @[Top.scala 184:11]
  assign n88_valid_up = n81_valid_down; // @[Top.scala 188:18]
  assign n88_I_0_0_0 = n81_O_0_0_0; // @[Top.scala 187:11]
  assign n88_I_0_0_1 = n81_O_0_0_1; // @[Top.scala 187:11]
  assign n88_I_0_0_2 = n81_O_0_0_2; // @[Top.scala 187:11]
  assign n89_valid_up = n56_valid_down & n88_valid_down; // @[Top.scala 192:18]
  assign n89_I0_0_0_0 = n56_O_0_0_0; // @[Top.scala 190:12]
  assign n89_I0_0_0_1 = n56_O_0_0_1; // @[Top.scala 190:12]
  assign n89_I0_0_0_2 = n56_O_0_0_2; // @[Top.scala 190:12]
  assign n89_I0_0_1_0 = n56_O_0_1_0; // @[Top.scala 190:12]
  assign n89_I0_0_1_1 = n56_O_0_1_1; // @[Top.scala 190:12]
  assign n89_I0_0_1_2 = n56_O_0_1_2; // @[Top.scala 190:12]
  assign n89_I1_0_0 = n88_O_0_0; // @[Top.scala 191:12]
  assign n89_I1_0_1 = n88_O_0_1; // @[Top.scala 191:12]
  assign n89_I1_0_2 = n88_O_0_2; // @[Top.scala 191:12]
  assign n100_valid_up = n89_valid_down; // @[Top.scala 195:19]
  assign n100_I_0_0_0 = n89_O_0_0_0; // @[Top.scala 194:12]
  assign n100_I_0_0_1 = n89_O_0_0_1; // @[Top.scala 194:12]
  assign n100_I_0_0_2 = n89_O_0_0_2; // @[Top.scala 194:12]
  assign n100_I_0_1_0 = n89_O_0_1_0; // @[Top.scala 194:12]
  assign n100_I_0_1_1 = n89_O_0_1_1; // @[Top.scala 194:12]
  assign n100_I_0_1_2 = n89_O_0_1_2; // @[Top.scala 194:12]
  assign n100_I_0_2_0 = n89_O_0_2_0; // @[Top.scala 194:12]
  assign n100_I_0_2_1 = n89_O_0_2_1; // @[Top.scala 194:12]
  assign n100_I_0_2_2 = n89_O_0_2_2; // @[Top.scala 194:12]
  assign n140_clock = clock;
  assign n140_reset = reset;
  assign n140_valid_up = n100_valid_down; // @[Top.scala 198:19]
  assign n140_I_0_0 = n100_O_0_0; // @[Top.scala 197:12]
  assign n140_I_0_1 = n100_O_0_1; // @[Top.scala 197:12]
  assign n140_I_0_2 = n100_O_0_2; // @[Top.scala 197:12]
  assign n140_I_1_0 = n100_O_1_0; // @[Top.scala 197:12]
  assign n140_I_1_1 = n100_O_1_1; // @[Top.scala 197:12]
  assign n140_I_1_2 = n100_O_1_2; // @[Top.scala 197:12]
  assign n140_I_2_0 = n100_O_2_0; // @[Top.scala 197:12]
  assign n140_I_2_1 = n100_O_2_1; // @[Top.scala 197:12]
  assign n140_I_2_2 = n100_O_2_2; // @[Top.scala 197:12]
  assign n141_valid_up = n140_valid_down; // @[Top.scala 201:19]
  assign n141_I_0_0 = n140_O_0_0; // @[Top.scala 200:12]
  assign n142_valid_up = n141_valid_down; // @[Top.scala 204:19]
  assign n142_I_0_0 = n141_O_0_0; // @[Top.scala 203:12]
  assign n143_valid_up = n1_valid_down; // @[Top.scala 207:19]
  assign n143_I_0 = n1_O_0; // @[Top.scala 206:12]
  assign n144_clock = clock;
  assign n144_reset = reset;
  assign n144_valid_up = n143_valid_down; // @[Top.scala 210:19]
  assign n144_I = n143_O; // @[Top.scala 209:12]
  assign n145_clock = clock;
  assign n145_reset = reset;
  assign n145_valid_up = n142_valid_down & n144_valid_down; // @[Top.scala 214:19]
  assign n145_I0 = n142_O; // @[Top.scala 212:13]
  assign n145_I1 = n144_O; // @[Top.scala 213:13]
  assign n175_clock = clock;
  assign n175_reset = reset;
  assign n175_valid_up = n145_valid_down; // @[Top.scala 217:19]
  assign n175_I = n145_O; // @[Top.scala 216:12]
  assign n176_clock = clock;
  assign n176_reset = reset;
  assign n176_valid_up = n175_valid_down; // @[Top.scala 220:19]
  assign n176_I = n175_O; // @[Top.scala 219:12]
  assign n177_clock = clock;
  assign n177_reset = reset;
  assign n177_valid_up = n176_valid_down; // @[Top.scala 223:19]
  assign n177_I = n176_O; // @[Top.scala 222:12]
endmodule
