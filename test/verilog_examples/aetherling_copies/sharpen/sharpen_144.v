module FIFO(
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
  input  [1:0] RADDR,
  output [7:0] RDATA,
  input        WE,
  input  [1:0] WADDR,
  input  [7:0] WDATA
);
  wire  write_elem_counter_CE; // @[RAM_ST.scala 20:34]
  wire  write_elem_counter_valid; // @[RAM_ST.scala 20:34]
  wire  read_elem_counter_CE; // @[RAM_ST.scala 21:33]
  wire  read_elem_counter_valid; // @[RAM_ST.scala 21:33]
  reg [7:0] ram [0:3]; // @[RAM_ST.scala 29:24]
  reg [31:0] _RAND_0;
  wire [7:0] ram__T_8_data; // @[RAM_ST.scala 29:24]
  wire [1:0] ram__T_8_addr; // @[RAM_ST.scala 29:24]
  wire [7:0] ram__T_2_data; // @[RAM_ST.scala 29:24]
  wire [1:0] ram__T_2_addr; // @[RAM_ST.scala 29:24]
  wire  ram__T_2_mask; // @[RAM_ST.scala 29:24]
  wire  ram__T_2_en; // @[RAM_ST.scala 29:24]
  reg  ram__T_8_en_pipe_0;
  reg [31:0] _RAND_1;
  reg [1:0] ram__T_8_addr_pipe_0;
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
  assign ram__T_8_addr = ram__T_8_addr_pipe_0;
  assign ram__T_8_data = ram[ram__T_8_addr]; // @[RAM_ST.scala 29:24]
  assign ram__T_2_data = WDATA;
  assign ram__T_2_addr = _T[1:0];
  assign ram__T_2_mask = 1'h1;
  assign ram__T_2_en = write_elem_counter_valid;
  assign _GEN_1 = 2'h1 == WADDR ? 2'h1 : 2'h0; // @[RAM_ST.scala 31:71]
  assign _GEN_2 = 2'h2 == WADDR ? 2'h2 : _GEN_1; // @[RAM_ST.scala 31:71]
  assign _GEN_3 = 2'h3 == WADDR ? 2'h3 : _GEN_2; // @[RAM_ST.scala 31:71]
  assign _T = {{1'd0}, _GEN_3}; // @[RAM_ST.scala 31:71]
  assign _GEN_10 = 2'h1 == RADDR ? 2'h1 : 2'h0; // @[RAM_ST.scala 32:46]
  assign _GEN_11 = 2'h2 == RADDR ? 2'h2 : _GEN_10; // @[RAM_ST.scala 32:46]
  assign _GEN_12 = 2'h3 == RADDR ? 2'h3 : _GEN_11; // @[RAM_ST.scala 32:46]
  assign _T_3 = {{1'd0}, _GEN_12}; // @[RAM_ST.scala 32:46]
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
  for (initvar = 0; initvar < 4; initvar = initvar+1)
    ram[initvar] = _RAND_0[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  ram__T_8_en_pipe_0 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  ram__T_8_addr_pipe_0 = _RAND_2[1:0];
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
      ram__T_8_addr_pipe_0 <= _T_3[1:0];
    end
  end
endmodule
module NestedCounters_4(
  input   clock,
  input   reset,
  input   CE,
  output  valid,
  output  last
);
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[Counter.scala 37:24]
  wire [1:0] _T_3; // @[Counter.scala 38:22]
  assign _T_1 = value == 2'h2; // @[Counter.scala 37:24]
  assign _T_3 = value + 2'h1; // @[Counter.scala 38:22]
  assign valid = value < 2'h1; // @[NestedCounters.scala 48:11]
  assign last = value == 2'h2; // @[NestedCounters.scala 47:10]
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
    end else if (CE) begin
      if (_T_1) begin
        value <= 2'h0;
      end else begin
        value <= _T_3;
      end
    end
  end
endmodule
module NestedCounters_5(
  input   clock,
  input   reset,
  input   CE,
  output  valid
);
  wire  NestedCounters_clock; // @[NestedCounters.scala 43:31]
  wire  NestedCounters_reset; // @[NestedCounters.scala 43:31]
  wire  NestedCounters_CE; // @[NestedCounters.scala 43:31]
  wire  NestedCounters_valid; // @[NestedCounters.scala 43:31]
  wire  NestedCounters_last; // @[NestedCounters.scala 43:31]
  wire  _T; // @[NestedCounters.scala 45:47]
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[Counter.scala 37:24]
  wire [1:0] _T_3; // @[Counter.scala 38:22]
  wire  _T_7; // @[NestedCounters.scala 48:35]
  NestedCounters_4 NestedCounters ( // @[NestedCounters.scala 43:31]
    .clock(NestedCounters_clock),
    .reset(NestedCounters_reset),
    .CE(NestedCounters_CE),
    .valid(NestedCounters_valid),
    .last(NestedCounters_last)
  );
  assign _T = CE & NestedCounters_last; // @[NestedCounters.scala 45:47]
  assign _T_1 = value == 2'h2; // @[Counter.scala 37:24]
  assign _T_3 = value + 2'h1; // @[Counter.scala 38:22]
  assign _T_7 = value < 2'h1; // @[NestedCounters.scala 48:35]
  assign valid = _T_7 & NestedCounters_valid; // @[NestedCounters.scala 48:11]
  assign NestedCounters_clock = clock;
  assign NestedCounters_reset = reset;
  assign NestedCounters_CE = CE; // @[NestedCounters.scala 49:22]
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
    end else if (_T) begin
      if (_T_1) begin
        value <= 2'h0;
      end else begin
        value <= _T_3;
      end
    end
  end
endmodule
module ShiftTN(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I,
  output [7:0] O
);
  wire  value_store_clock; // @[ShiftTN.scala 42:27]
  wire  value_store_RE; // @[ShiftTN.scala 42:27]
  wire [1:0] value_store_RADDR; // @[ShiftTN.scala 42:27]
  wire [7:0] value_store_RDATA; // @[ShiftTN.scala 42:27]
  wire  value_store_WE; // @[ShiftTN.scala 42:27]
  wire [1:0] value_store_WADDR; // @[ShiftTN.scala 42:27]
  wire [7:0] value_store_WDATA; // @[ShiftTN.scala 42:27]
  wire  next_ram_addr_CE; // @[ShiftTN.scala 44:29]
  wire  next_ram_addr_valid; // @[ShiftTN.scala 44:29]
  wire  inner_valid_clock; // @[ShiftTN.scala 56:27]
  wire  inner_valid_reset; // @[ShiftTN.scala 56:27]
  wire  inner_valid_CE; // @[ShiftTN.scala 56:27]
  wire  inner_valid_valid; // @[ShiftTN.scala 56:27]
  wire  _T_2; // @[ShiftTN.scala 58:74]
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_3; // @[Counter.scala 37:24]
  wire [1:0] _T_5; // @[Counter.scala 38:22]
  RAM_ST value_store ( // @[ShiftTN.scala 42:27]
    .clock(value_store_clock),
    .RE(value_store_RE),
    .RADDR(value_store_RADDR),
    .RDATA(value_store_RDATA),
    .WE(value_store_WE),
    .WADDR(value_store_WADDR),
    .WDATA(value_store_WDATA)
  );
  NestedCounters next_ram_addr ( // @[ShiftTN.scala 44:29]
    .CE(next_ram_addr_CE),
    .valid(next_ram_addr_valid)
  );
  NestedCounters_5 inner_valid ( // @[ShiftTN.scala 56:27]
    .clock(inner_valid_clock),
    .reset(inner_valid_reset),
    .CE(inner_valid_CE),
    .valid(inner_valid_valid)
  );
  assign _T_2 = valid_up & inner_valid_valid; // @[ShiftTN.scala 58:74]
  assign _T_3 = value == 2'h3; // @[Counter.scala 37:24]
  assign _T_5 = value + 2'h1; // @[Counter.scala 38:22]
  assign valid_down = valid_up; // @[ShiftTN.scala 69:14]
  assign O = value_store_RDATA; // @[ShiftTN.scala 66:5]
  assign value_store_clock = clock;
  assign value_store_RE = valid_up & inner_valid_valid; // @[ShiftTN.scala 64:18]
  assign value_store_RADDR = _T_3 ? 2'h0 : _T_5; // @[ShiftTN.scala 61:74 ShiftTN.scala 62:36]
  assign value_store_WE = valid_up & inner_valid_valid; // @[ShiftTN.scala 63:18]
  assign value_store_WADDR = value; // @[ShiftTN.scala 60:21]
  assign value_store_WDATA = I; // @[ShiftTN.scala 65:21]
  assign next_ram_addr_CE = valid_up; // @[ShiftTN.scala 45:20]
  assign inner_valid_clock = clock;
  assign inner_valid_reset = reset;
  assign inner_valid_CE = valid_up; // @[ShiftTN.scala 57:18]
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
    end else if (_T_2) begin
      value <= _T_5;
    end
  end
endmodule
module RAM_ST_2(
  input        clock,
  input        RE,
  output [7:0] RDATA,
  input        WE,
  input  [7:0] WDATA
);
  wire  write_elem_counter_CE; // @[RAM_ST.scala 20:34]
  wire  write_elem_counter_valid; // @[RAM_ST.scala 20:34]
  wire  read_elem_counter_CE; // @[RAM_ST.scala 21:33]
  wire  read_elem_counter_valid; // @[RAM_ST.scala 21:33]
  reg [7:0] ram [0:0]; // @[RAM_ST.scala 29:24]
  reg [31:0] _RAND_0;
  wire [7:0] ram__T_6_data; // @[RAM_ST.scala 29:24]
  wire  ram__T_6_addr; // @[RAM_ST.scala 29:24]
  wire [7:0] ram__T_2_data; // @[RAM_ST.scala 29:24]
  wire  ram__T_2_addr; // @[RAM_ST.scala 29:24]
  wire  ram__T_2_mask; // @[RAM_ST.scala 29:24]
  wire  ram__T_2_en; // @[RAM_ST.scala 29:24]
  reg  ram__T_6_en_pipe_0;
  reg [31:0] _RAND_1;
  reg  ram__T_6_addr_pipe_0;
  reg [31:0] _RAND_2;
  NestedCountersWithNumValid write_elem_counter ( // @[RAM_ST.scala 20:34]
    .CE(write_elem_counter_CE),
    .valid(write_elem_counter_valid)
  );
  NestedCountersWithNumValid read_elem_counter ( // @[RAM_ST.scala 21:33]
    .CE(read_elem_counter_CE),
    .valid(read_elem_counter_valid)
  );
  assign ram__T_6_addr = ram__T_6_addr_pipe_0;
  assign ram__T_6_data = ram[ram__T_6_addr]; // @[RAM_ST.scala 29:24]
  assign ram__T_2_data = WDATA;
  assign ram__T_2_addr = 1'h0;
  assign ram__T_2_mask = 1'h1;
  assign ram__T_2_en = write_elem_counter_valid;
  assign RDATA = ram__T_6_data; // @[RAM_ST.scala 32:9]
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
  for (initvar = 0; initvar < 1; initvar = initvar+1)
    ram[initvar] = _RAND_0[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  ram__T_6_en_pipe_0 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  ram__T_6_addr_pipe_0 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(ram__T_2_en & ram__T_2_mask) begin
      ram[ram__T_2_addr] <= ram__T_2_data; // @[RAM_ST.scala 29:24]
    end
    ram__T_6_en_pipe_0 <= read_elem_counter_valid;
    if (read_elem_counter_valid) begin
      ram__T_6_addr_pipe_0 <= 1'h0;
    end
  end
endmodule
module ShiftTN_2(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I,
  output [7:0] O
);
  wire  value_store_clock; // @[ShiftTN.scala 42:27]
  wire  value_store_RE; // @[ShiftTN.scala 42:27]
  wire [7:0] value_store_RDATA; // @[ShiftTN.scala 42:27]
  wire  value_store_WE; // @[ShiftTN.scala 42:27]
  wire [7:0] value_store_WDATA; // @[ShiftTN.scala 42:27]
  wire  next_ram_addr_CE; // @[ShiftTN.scala 44:29]
  wire  next_ram_addr_valid; // @[ShiftTN.scala 44:29]
  wire  inner_valid_clock; // @[ShiftTN.scala 56:27]
  wire  inner_valid_reset; // @[ShiftTN.scala 56:27]
  wire  inner_valid_CE; // @[ShiftTN.scala 56:27]
  wire  inner_valid_valid; // @[ShiftTN.scala 56:27]
  RAM_ST_2 value_store ( // @[ShiftTN.scala 42:27]
    .clock(value_store_clock),
    .RE(value_store_RE),
    .RDATA(value_store_RDATA),
    .WE(value_store_WE),
    .WDATA(value_store_WDATA)
  );
  NestedCounters next_ram_addr ( // @[ShiftTN.scala 44:29]
    .CE(next_ram_addr_CE),
    .valid(next_ram_addr_valid)
  );
  NestedCounters_5 inner_valid ( // @[ShiftTN.scala 56:27]
    .clock(inner_valid_clock),
    .reset(inner_valid_reset),
    .CE(inner_valid_CE),
    .valid(inner_valid_valid)
  );
  assign valid_down = valid_up; // @[ShiftTN.scala 69:14]
  assign O = value_store_RDATA; // @[ShiftTN.scala 66:5]
  assign value_store_clock = clock;
  assign value_store_RE = valid_up & inner_valid_valid; // @[ShiftTN.scala 64:18]
  assign value_store_WE = valid_up & inner_valid_valid; // @[ShiftTN.scala 63:18]
  assign value_store_WDATA = I; // @[ShiftTN.scala 65:21]
  assign next_ram_addr_CE = valid_up; // @[ShiftTN.scala 45:20]
  assign inner_valid_clock = clock;
  assign inner_valid_reset = reset;
  assign inner_valid_CE = valid_up; // @[ShiftTN.scala 57:18]
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
module Map2T(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0,
  input  [7:0] I1,
  output [7:0] O_0,
  output [7:0] O_1
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1; // @[Map2T.scala 8:20]
  SSeqTupleCreator op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0(op_I0),
    .I1(op_I1),
    .O_0(op_O_0),
    .O_1(op_O_1)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0 = op_O_0; // @[Map2T.scala 17:7]
  assign O_1 = op_O_1; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0 = I0; // @[Map2T.scala 15:11]
  assign op_I1 = I1; // @[Map2T.scala 16:11]
endmodule
module Map2T_1(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0,
  input  [7:0] I1,
  output [7:0] O_0,
  output [7:0] O_1
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1; // @[Map2T.scala 8:20]
  Map2T op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0(op_I0),
    .I1(op_I1),
    .O_0(op_O_0),
    .O_1(op_O_1)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0 = op_O_0; // @[Map2T.scala 17:7]
  assign O_1 = op_O_1; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0 = I0; // @[Map2T.scala 15:11]
  assign op_I1 = I1; // @[Map2T.scala 16:11]
endmodule
module Map2T_2(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0,
  input  [7:0] I1,
  output [7:0] O_0,
  output [7:0] O_1
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1; // @[Map2T.scala 8:20]
  Map2T_1 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0(op_I0),
    .I1(op_I1),
    .O_0(op_O_0),
    .O_1(op_O_1)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0 = op_O_0; // @[Map2T.scala 17:7]
  assign O_1 = op_O_1; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0 = I0; // @[Map2T.scala 15:11]
  assign op_I1 = I1; // @[Map2T.scala 16:11]
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
module Map2T_3(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I0_1,
  input  [7:0] I1,
  output [7:0] O_0,
  output [7:0] O_1,
  output [7:0] O_2
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_2; // @[Map2T.scala 8:20]
  SSeqTupleAppender op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0(op_I0_0),
    .I0_1(op_I0_1),
    .I1(op_I1),
    .O_0(op_O_0),
    .O_1(op_O_1),
    .O_2(op_O_2)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0 = op_O_0; // @[Map2T.scala 17:7]
  assign O_1 = op_O_1; // @[Map2T.scala 17:7]
  assign O_2 = op_O_2; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0 = I0_0; // @[Map2T.scala 15:11]
  assign op_I0_1 = I0_1; // @[Map2T.scala 15:11]
  assign op_I1 = I1; // @[Map2T.scala 16:11]
endmodule
module Map2T_4(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I0_1,
  input  [7:0] I1,
  output [7:0] O_0,
  output [7:0] O_1,
  output [7:0] O_2
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_2; // @[Map2T.scala 8:20]
  Map2T_3 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0(op_I0_0),
    .I0_1(op_I0_1),
    .I1(op_I1),
    .O_0(op_O_0),
    .O_1(op_O_1),
    .O_2(op_O_2)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0 = op_O_0; // @[Map2T.scala 17:7]
  assign O_1 = op_O_1; // @[Map2T.scala 17:7]
  assign O_2 = op_O_2; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0 = I0_0; // @[Map2T.scala 15:11]
  assign op_I0_1 = I0_1; // @[Map2T.scala 15:11]
  assign op_I1 = I1; // @[Map2T.scala 16:11]
endmodule
module Map2T_5(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0_0,
  input  [7:0] I0_1,
  input  [7:0] I1,
  output [7:0] O_0,
  output [7:0] O_1,
  output [7:0] O_2
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_0; // @[Map2T.scala 8:20]
  wire [7:0] op_I0_1; // @[Map2T.scala 8:20]
  wire [7:0] op_I1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_0; // @[Map2T.scala 8:20]
  wire [7:0] op_O_1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_2; // @[Map2T.scala 8:20]
  Map2T_4 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0_0(op_I0_0),
    .I0_1(op_I0_1),
    .I1(op_I1),
    .O_0(op_O_0),
    .O_1(op_O_1),
    .O_2(op_O_2)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_0 = op_O_0; // @[Map2T.scala 17:7]
  assign O_1 = op_O_1; // @[Map2T.scala 17:7]
  assign O_2 = op_O_2; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0_0 = I0_0; // @[Map2T.scala 15:11]
  assign op_I0_1 = I0_1; // @[Map2T.scala 15:11]
  assign op_I1 = I1; // @[Map2T.scala 16:11]
endmodule
module Serialize(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  input  [7:0] I_2,
  output [7:0] O
);
  wire  elem_counter_CE; // @[Serialize.scala 14:28]
  wire  elem_counter_valid; // @[Serialize.scala 14:28]
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[Counter.scala 37:24]
  wire [1:0] _T_3; // @[Counter.scala 38:22]
  reg [7:0] mux_input_wire_1; // @[Serialize.scala 39:47]
  reg [31:0] _RAND_1;
  reg [7:0] mux_input_wire_2; // @[Serialize.scala 39:47]
  reg [31:0] _RAND_2;
  wire  _T_7; // @[Serialize.scala 42:34]
  wire  _T_8; // @[Serialize.scala 42:42]
  wire  _T_11; // @[Mux.scala 68:19]
  wire  _T_13; // @[Mux.scala 68:19]
  wire  _T_15; // @[Mux.scala 68:19]
  reg [7:0] _T_17; // @[Serialize.scala 53:15]
  reg [31:0] _RAND_3;
  reg  _T_18; // @[Serialize.scala 54:24]
  reg [31:0] _RAND_4;
  NestedCountersWithNumValid elem_counter ( // @[Serialize.scala 14:28]
    .CE(elem_counter_CE),
    .valid(elem_counter_valid)
  );
  assign _T_1 = value == 2'h2; // @[Counter.scala 37:24]
  assign _T_3 = value + 2'h1; // @[Counter.scala 38:22]
  assign _T_7 = value == 2'h0; // @[Serialize.scala 42:34]
  assign _T_8 = _T_7 & valid_up; // @[Serialize.scala 42:42]
  assign _T_11 = 2'h2 == value; // @[Mux.scala 68:19]
  assign _T_13 = 2'h1 == value; // @[Mux.scala 68:19]
  assign _T_15 = 2'h0 == value; // @[Mux.scala 68:19]
  assign valid_down = _T_18; // @[Serialize.scala 54:14]
  assign O = _T_17; // @[Serialize.scala 53:5]
  assign elem_counter_CE = valid_up; // @[Serialize.scala 16:19]
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
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  mux_input_wire_1 = _RAND_1[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  mux_input_wire_2 = _RAND_2[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_17 = _RAND_3[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  _T_18 = _RAND_4[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      value <= 2'h0;
    end else if (valid_up) begin
      if (_T_1) begin
        value <= 2'h0;
      end else begin
        value <= _T_3;
      end
    end
    if (_T_8) begin
      mux_input_wire_1 <= I_1;
    end
    if (_T_8) begin
      mux_input_wire_2 <= I_2;
    end
    if (_T_15) begin
      _T_17 <= I_0;
    end else if (_T_13) begin
      _T_17 <= mux_input_wire_1;
    end else if (_T_11) begin
      _T_17 <= mux_input_wire_2;
    end else begin
      _T_17 <= I_0;
    end
    if (reset) begin
      _T_18 <= 1'h0;
    end else begin
      _T_18 <= valid_up;
    end
  end
endmodule
module MapT(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  input  [7:0] I_2,
  output [7:0] O
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_2; // @[MapT.scala 8:20]
  wire [7:0] op_O; // @[MapT.scala 8:20]
  Serialize op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0(op_I_0),
    .I_1(op_I_1),
    .I_2(op_I_2),
    .O(op_O)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O = op_O; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0 = I_0; // @[MapT.scala 14:10]
  assign op_I_1 = I_1; // @[MapT.scala 14:10]
  assign op_I_2 = I_2; // @[MapT.scala 14:10]
endmodule
module MapT_1(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  input  [7:0] I_2,
  output [7:0] O
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_2; // @[MapT.scala 8:20]
  wire [7:0] op_O; // @[MapT.scala 8:20]
  MapT op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0(op_I_0),
    .I_1(op_I_1),
    .I_2(op_I_2),
    .O(op_O)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O = op_O; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0 = I_0; // @[MapT.scala 14:10]
  assign op_I_1 = I_1; // @[MapT.scala 14:10]
  assign op_I_2 = I_2; // @[MapT.scala 14:10]
endmodule
module NestedCounters_52(
  input   clock,
  input   reset,
  input   CE,
  output  valid,
  output  last
);
  wire  NestedCounters_CE; // @[NestedCounters.scala 43:31]
  wire  NestedCounters_valid; // @[NestedCounters.scala 43:31]
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[Counter.scala 37:24]
  wire [1:0] _T_3; // @[Counter.scala 38:22]
  wire  _T_7; // @[NestedCounters.scala 48:35]
  NestedCounters NestedCounters ( // @[NestedCounters.scala 43:31]
    .CE(NestedCounters_CE),
    .valid(NestedCounters_valid)
  );
  assign _T_1 = value == 2'h2; // @[Counter.scala 37:24]
  assign _T_3 = value + 2'h1; // @[Counter.scala 38:22]
  assign _T_7 = value < 2'h3; // @[NestedCounters.scala 48:35]
  assign valid = _T_7 & NestedCounters_valid; // @[NestedCounters.scala 48:11]
  assign last = value == 2'h2; // @[NestedCounters.scala 47:10]
  assign NestedCounters_CE = CE; // @[NestedCounters.scala 49:22]
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
    end else if (CE) begin
      if (_T_1) begin
        value <= 2'h0;
      end else begin
        value <= _T_3;
      end
    end
  end
endmodule
module NestedCountersWithNumValid_19(
  input        clock,
  input        reset,
  input        CE,
  output       last,
  output [1:0] cur_valid
);
  wire  NestedCounters_clock; // @[NestedCounters.scala 20:44]
  wire  NestedCounters_reset; // @[NestedCounters.scala 20:44]
  wire  NestedCounters_CE; // @[NestedCounters.scala 20:44]
  wire  NestedCounters_valid; // @[NestedCounters.scala 20:44]
  wire  NestedCounters_last; // @[NestedCounters.scala 20:44]
  wire  _T; // @[NestedCounters.scala 25:49]
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[Counter.scala 37:24]
  wire [1:0] _T_3; // @[Counter.scala 38:22]
  NestedCounters_52 NestedCounters ( // @[NestedCounters.scala 20:44]
    .clock(NestedCounters_clock),
    .reset(NestedCounters_reset),
    .CE(NestedCounters_CE),
    .valid(NestedCounters_valid),
    .last(NestedCounters_last)
  );
  assign _T = CE & NestedCounters_valid; // @[NestedCounters.scala 25:49]
  assign _T_1 = value == 2'h2; // @[Counter.scala 37:24]
  assign _T_3 = value + 2'h1; // @[Counter.scala 38:22]
  assign last = NestedCounters_last; // @[NestedCounters.scala 23:8]
  assign cur_valid = value; // @[NestedCounters.scala 27:13]
  assign NestedCounters_clock = clock;
  assign NestedCounters_reset = reset;
  assign NestedCounters_CE = CE; // @[NestedCounters.scala 21:27]
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
    end else if (_T) begin
      if (_T_1) begin
        value <= 2'h0;
      end else begin
        value <= _T_3;
      end
    end
  end
endmodule
module Serialize_3(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  input  [7:0] I_2,
  output [7:0] O
);
  wire  elem_counter_clock; // @[Serialize.scala 14:28]
  wire  elem_counter_reset; // @[Serialize.scala 14:28]
  wire  elem_counter_CE; // @[Serialize.scala 14:28]
  wire  elem_counter_last; // @[Serialize.scala 14:28]
  wire [1:0] elem_counter_cur_valid; // @[Serialize.scala 14:28]
  reg [7:0] _T_5 [0:2]; // @[Serialize.scala 25:55]
  reg [31:0] _RAND_0;
  wire [7:0] _T_5__T_17_data; // @[Serialize.scala 25:55]
  wire [1:0] _T_5__T_17_addr; // @[Serialize.scala 25:55]
  reg [31:0] _RAND_1;
  wire [7:0] _T_5__T_9_data; // @[Serialize.scala 25:55]
  wire [1:0] _T_5__T_9_addr; // @[Serialize.scala 25:55]
  wire  _T_5__T_9_mask; // @[Serialize.scala 25:55]
  wire  _T_5__T_9_en; // @[Serialize.scala 25:55]
  reg  _T_5__T_17_en_pipe_0;
  reg [31:0] _RAND_2;
  reg [1:0] _T_5__T_17_addr_pipe_0;
  reg [31:0] _RAND_3;
  reg [7:0] _T_6 [0:2]; // @[Serialize.scala 25:55]
  reg [31:0] _RAND_4;
  wire [7:0] _T_6__T_28_data; // @[Serialize.scala 25:55]
  wire [1:0] _T_6__T_28_addr; // @[Serialize.scala 25:55]
  reg [31:0] _RAND_5;
  wire [7:0] _T_6__T_20_data; // @[Serialize.scala 25:55]
  wire [1:0] _T_6__T_20_addr; // @[Serialize.scala 25:55]
  wire  _T_6__T_20_mask; // @[Serialize.scala 25:55]
  wire  _T_6__T_20_en; // @[Serialize.scala 25:55]
  reg  _T_6__T_28_en_pipe_0;
  reg [31:0] _RAND_6;
  reg [1:0] _T_6__T_28_addr_pipe_0;
  reg [31:0] _RAND_7;
  wire  _T; // @[Serialize.scala 17:50]
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_8;
  wire  _T_1; // @[Counter.scala 37:24]
  wire [1:0] _T_3; // @[Counter.scala 38:22]
  wire  _T_7; // @[Serialize.scala 28:33]
  wire  _T_11; // @[Serialize.scala 33:37]
  wire [1:0] _T_13; // @[Serialize.scala 34:60]
  wire  _T_29; // @[Mux.scala 68:19]
  wire [7:0] mux_input_wire_2; // @[Serialize.scala 20:28 Serialize.scala 35:29]
  wire  _T_31; // @[Mux.scala 68:19]
  wire [7:0] mux_input_wire_1; // @[Serialize.scala 20:28 Serialize.scala 35:29]
  wire  _T_33; // @[Mux.scala 68:19]
  reg [7:0] _T_35; // @[Serialize.scala 53:15]
  reg [31:0] _RAND_9;
  reg  _T_36; // @[Serialize.scala 54:24]
  reg [31:0] _RAND_10;
  NestedCountersWithNumValid_19 elem_counter ( // @[Serialize.scala 14:28]
    .clock(elem_counter_clock),
    .reset(elem_counter_reset),
    .CE(elem_counter_CE),
    .last(elem_counter_last),
    .cur_valid(elem_counter_cur_valid)
  );
  assign _T_5__T_17_addr = _T_5__T_17_addr_pipe_0;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign _T_5__T_17_data = _T_5[_T_5__T_17_addr]; // @[Serialize.scala 25:55]
  `else
  assign _T_5__T_17_data = _T_5__T_17_addr >= 2'h3 ? _RAND_1[7:0] : _T_5[_T_5__T_17_addr]; // @[Serialize.scala 25:55]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign _T_5__T_9_data = I_1;
  assign _T_5__T_9_addr = elem_counter_cur_valid;
  assign _T_5__T_9_mask = 1'h1;
  assign _T_5__T_9_en = _T_7 & valid_up;
  assign _T_6__T_28_addr = _T_6__T_28_addr_pipe_0;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign _T_6__T_28_data = _T_6[_T_6__T_28_addr]; // @[Serialize.scala 25:55]
  `else
  assign _T_6__T_28_data = _T_6__T_28_addr >= 2'h3 ? _RAND_5[7:0] : _T_6[_T_6__T_28_addr]; // @[Serialize.scala 25:55]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign _T_6__T_20_data = I_2;
  assign _T_6__T_20_addr = elem_counter_cur_valid;
  assign _T_6__T_20_mask = 1'h1;
  assign _T_6__T_20_en = _T_7 & valid_up;
  assign _T = valid_up & elem_counter_last; // @[Serialize.scala 17:50]
  assign _T_1 = value == 2'h2; // @[Counter.scala 37:24]
  assign _T_3 = value + 2'h1; // @[Counter.scala 38:22]
  assign _T_7 = value == 2'h0; // @[Serialize.scala 28:33]
  assign _T_11 = elem_counter_cur_valid == 2'h2; // @[Serialize.scala 33:37]
  assign _T_13 = elem_counter_cur_valid + 2'h1; // @[Serialize.scala 34:60]
  assign _T_29 = 2'h2 == value; // @[Mux.scala 68:19]
  assign mux_input_wire_2 = _T_6__T_28_data; // @[Serialize.scala 20:28 Serialize.scala 35:29]
  assign _T_31 = 2'h1 == value; // @[Mux.scala 68:19]
  assign mux_input_wire_1 = _T_5__T_17_data; // @[Serialize.scala 20:28 Serialize.scala 35:29]
  assign _T_33 = 2'h0 == value; // @[Mux.scala 68:19]
  assign valid_down = _T_36; // @[Serialize.scala 54:14]
  assign O = _T_35; // @[Serialize.scala 53:5]
  assign elem_counter_clock = clock;
  assign elem_counter_reset = reset;
  assign elem_counter_CE = valid_up; // @[Serialize.scala 16:19]
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
    _T_5[initvar] = _RAND_0[7:0];
  `endif // RANDOMIZE_MEM_INIT
  _RAND_1 = {1{`RANDOM}};
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_5__T_17_en_pipe_0 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_5__T_17_addr_pipe_0 = _RAND_3[1:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 3; initvar = initvar+1)
    _T_6[initvar] = _RAND_4[7:0];
  `endif // RANDOMIZE_MEM_INIT
  _RAND_5 = {1{`RANDOM}};
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  _T_6__T_28_en_pipe_0 = _RAND_6[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{`RANDOM}};
  _T_6__T_28_addr_pipe_0 = _RAND_7[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{`RANDOM}};
  value = _RAND_8[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{`RANDOM}};
  _T_35 = _RAND_9[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{`RANDOM}};
  _T_36 = _RAND_10[0:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(_T_5__T_9_en & _T_5__T_9_mask) begin
      _T_5[_T_5__T_9_addr] <= _T_5__T_9_data; // @[Serialize.scala 25:55]
    end
    _T_5__T_17_en_pipe_0 <= valid_up;
    if (valid_up) begin
      if (_T_11) begin
        _T_5__T_17_addr_pipe_0 <= 2'h0;
      end else begin
        _T_5__T_17_addr_pipe_0 <= _T_13;
      end
    end
    if(_T_6__T_20_en & _T_6__T_20_mask) begin
      _T_6[_T_6__T_20_addr] <= _T_6__T_20_data; // @[Serialize.scala 25:55]
    end
    _T_6__T_28_en_pipe_0 <= valid_up;
    if (valid_up) begin
      if (_T_11) begin
        _T_6__T_28_addr_pipe_0 <= 2'h0;
      end else begin
        _T_6__T_28_addr_pipe_0 <= _T_13;
      end
    end
    if (reset) begin
      value <= 2'h0;
    end else if (_T) begin
      if (_T_1) begin
        value <= 2'h0;
      end else begin
        value <= _T_3;
      end
    end
    if (_T_33) begin
      _T_35 <= I_0;
    end else if (_T_31) begin
      _T_35 <= mux_input_wire_1;
    end else if (_T_29) begin
      _T_35 <= mux_input_wire_2;
    end else begin
      _T_35 <= I_0;
    end
    if (reset) begin
      _T_36 <= 1'h0;
    end else begin
      _T_36 <= valid_up;
    end
  end
endmodule
module MapT_6(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I_0,
  input  [7:0] I_1,
  input  [7:0] I_2,
  output [7:0] O
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_0; // @[MapT.scala 8:20]
  wire [7:0] op_I_1; // @[MapT.scala 8:20]
  wire [7:0] op_I_2; // @[MapT.scala 8:20]
  wire [7:0] op_O; // @[MapT.scala 8:20]
  Serialize_3 op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_0(op_I_0),
    .I_1(op_I_1),
    .I_2(op_I_2),
    .O(op_O)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O = op_O; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_0 = I_0; // @[MapT.scala 14:10]
  assign op_I_1 = I_1; // @[MapT.scala 14:10]
  assign op_I_2 = I_2; // @[MapT.scala 14:10]
endmodule
module InitialDelayCounter(
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
module Map2T_22(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0,
  input  [7:0] I1,
  output [7:0] O_t0b,
  output [7:0] O_t1b
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_t1b; // @[Map2T.scala 8:20]
  AtomTuple op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0(op_I0),
    .I1(op_I1),
    .O_t0b(op_O_t0b),
    .O_t1b(op_O_t1b)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_t0b = op_O_t0b; // @[Map2T.scala 17:7]
  assign O_t1b = op_O_t1b; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0 = I0; // @[Map2T.scala 15:11]
  assign op_I1 = I1; // @[Map2T.scala 16:11]
endmodule
module Map2T_23(
  input        valid_up,
  output       valid_down,
  input  [7:0] I0,
  input  [7:0] I1,
  output [7:0] O_t0b,
  output [7:0] O_t1b
);
  wire  op_valid_up; // @[Map2T.scala 8:20]
  wire  op_valid_down; // @[Map2T.scala 8:20]
  wire [7:0] op_I0; // @[Map2T.scala 8:20]
  wire [7:0] op_I1; // @[Map2T.scala 8:20]
  wire [7:0] op_O_t0b; // @[Map2T.scala 8:20]
  wire [7:0] op_O_t1b; // @[Map2T.scala 8:20]
  Map2T_22 op ( // @[Map2T.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I0(op_I0),
    .I1(op_I1),
    .O_t0b(op_O_t0b),
    .O_t1b(op_O_t1b)
  );
  assign valid_down = op_valid_down; // @[Map2T.scala 18:16]
  assign O_t0b = op_O_t0b; // @[Map2T.scala 17:7]
  assign O_t1b = op_O_t1b; // @[Map2T.scala 17:7]
  assign op_valid_up = valid_up; // @[Map2T.scala 14:17]
  assign op_I0 = I0; // @[Map2T.scala 15:11]
  assign op_I1 = I1; // @[Map2T.scala 16:11]
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
module MapT_7(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_O; // @[MapT.scala 8:20]
  LShift op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_t0b(op_I_t0b),
    .I_t1b(op_I_t1b),
    .O(op_O)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O = op_O; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_t0b = I_t0b; // @[MapT.scala 14:10]
  assign op_I_t1b = I_t1b; // @[MapT.scala 14:10]
endmodule
module MapT_8(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_O; // @[MapT.scala 8:20]
  MapT_7 op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_t0b(op_I_t0b),
    .I_t1b(op_I_t1b),
    .O(op_O)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O = op_O; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_t0b = I_t0b; // @[MapT.scala 14:10]
  assign op_I_t1b = I_t1b; // @[MapT.scala 14:10]
endmodule
module AddNoValid(
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  assign O = I_t0b + I_t1b; // @[Arithmetic.scala 122:7]
endmodule
module ReduceT(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I,
  output [7:0] O
);
  wire  NestedCountersWithNumValid_CE; // @[ReduceT.scala 22:34]
  wire  NestedCountersWithNumValid_valid; // @[ReduceT.scala 22:34]
  wire [7:0] AddNoValid_I_t0b; // @[ReduceT.scala 25:25]
  wire [7:0] AddNoValid_I_t1b; // @[ReduceT.scala 25:25]
  wire [7:0] AddNoValid_O; // @[ReduceT.scala 25:25]
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[Counter.scala 37:24]
  wire [1:0] _T_3; // @[Counter.scala 38:22]
  wire  _T_5; // @[ReduceT.scala 34:60]
  reg [7:0] _T_7; // @[ReduceT.scala 35:24]
  reg [31:0] _RAND_1;
  reg  _T_8; // @[ReduceT.scala 50:28]
  reg [31:0] _RAND_2;
  wire  _T_10; // @[ReduceT.scala 51:28]
  reg [7:0] _T_11; // @[ReduceT.scala 55:15]
  reg [31:0] _RAND_3;
  NestedCountersWithNumValid NestedCountersWithNumValid ( // @[ReduceT.scala 22:34]
    .CE(NestedCountersWithNumValid_CE),
    .valid(NestedCountersWithNumValid_valid)
  );
  AddNoValid AddNoValid ( // @[ReduceT.scala 25:25]
    .I_t0b(AddNoValid_I_t0b),
    .I_t1b(AddNoValid_I_t1b),
    .O(AddNoValid_O)
  );
  assign _T_1 = value == 2'h2; // @[Counter.scala 37:24]
  assign _T_3 = value + 2'h1; // @[Counter.scala 38:22]
  assign _T_5 = value == 2'h0; // @[ReduceT.scala 34:60]
  assign _T_10 = _T_8 | _T_1; // @[ReduceT.scala 51:28]
  assign valid_down = _T_8; // @[ReduceT.scala 52:16]
  assign O = _T_11; // @[ReduceT.scala 55:5]
  assign NestedCountersWithNumValid_CE = valid_up; // @[ReduceT.scala 37:25]
  assign AddNoValid_I_t0b = I; // @[ReduceT.scala 43:55]
  assign AddNoValid_I_t1b = _T_7; // @[ReduceT.scala 44:55]
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
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_7 = _RAND_1[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_8 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_11 = _RAND_3[7:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      value <= 2'h0;
    end else if (valid_up) begin
      if (_T_1) begin
        value <= 2'h0;
      end else begin
        value <= _T_3;
      end
    end
    if (NestedCountersWithNumValid_valid) begin
      if (_T_5) begin
        _T_7 <= I;
      end else begin
        _T_7 <= AddNoValid_O;
      end
    end
    if (reset) begin
      _T_8 <= 1'h0;
    end else begin
      _T_8 <= _T_10;
    end
    _T_11 <= AddNoValid_O;
  end
endmodule
module MapT_9(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I,
  output [7:0] O
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I; // @[MapT.scala 8:20]
  wire [7:0] op_O; // @[MapT.scala 8:20]
  ReduceT op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I(op_I),
    .O(op_O)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O = op_O; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I = I; // @[MapT.scala 14:10]
endmodule
module NestedCounters_55(
  input   clock,
  input   reset,
  input   CE,
  output  valid,
  output  last
);
  wire  NestedCounters_CE; // @[NestedCounters.scala 43:31]
  wire  NestedCounters_valid; // @[NestedCounters.scala 43:31]
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[Counter.scala 37:24]
  wire [1:0] _T_3; // @[Counter.scala 38:22]
  wire  _T_7; // @[NestedCounters.scala 48:35]
  NestedCounters NestedCounters ( // @[NestedCounters.scala 43:31]
    .CE(NestedCounters_CE),
    .valid(NestedCounters_valid)
  );
  assign _T_1 = value == 2'h2; // @[Counter.scala 37:24]
  assign _T_3 = value + 2'h1; // @[Counter.scala 38:22]
  assign _T_7 = value < 2'h1; // @[NestedCounters.scala 48:35]
  assign valid = _T_7 & NestedCounters_valid; // @[NestedCounters.scala 48:11]
  assign last = value == 2'h2; // @[NestedCounters.scala 47:10]
  assign NestedCounters_CE = CE; // @[NestedCounters.scala 49:22]
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
    end else if (CE) begin
      if (_T_1) begin
        value <= 2'h0;
      end else begin
        value <= _T_3;
      end
    end
  end
endmodule
module NestedCountersWithNumValid_21(
  input   clock,
  input   reset,
  input   CE,
  output  valid,
  output  last
);
  wire  NestedCounters_clock; // @[NestedCounters.scala 20:44]
  wire  NestedCounters_reset; // @[NestedCounters.scala 20:44]
  wire  NestedCounters_CE; // @[NestedCounters.scala 20:44]
  wire  NestedCounters_valid; // @[NestedCounters.scala 20:44]
  wire  NestedCounters_last; // @[NestedCounters.scala 20:44]
  NestedCounters_55 NestedCounters ( // @[NestedCounters.scala 20:44]
    .clock(NestedCounters_clock),
    .reset(NestedCounters_reset),
    .CE(NestedCounters_CE),
    .valid(NestedCounters_valid),
    .last(NestedCounters_last)
  );
  assign valid = NestedCounters_valid; // @[NestedCounters.scala 22:9]
  assign last = NestedCounters_last; // @[NestedCounters.scala 23:8]
  assign NestedCounters_clock = clock;
  assign NestedCounters_reset = reset;
  assign NestedCounters_CE = CE; // @[NestedCounters.scala 21:27]
endmodule
module MapTNoValid(
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  wire [7:0] op_I_t0b; // @[MapT.scala 21:20]
  wire [7:0] op_I_t1b; // @[MapT.scala 21:20]
  wire [7:0] op_O; // @[MapT.scala 21:20]
  AddNoValid op ( // @[MapT.scala 21:20]
    .I_t0b(op_I_t0b),
    .I_t1b(op_I_t1b),
    .O(op_O)
  );
  assign O = op_O; // @[MapT.scala 27:7]
  assign op_I_t0b = I_t0b; // @[MapT.scala 26:10]
  assign op_I_t1b = I_t1b; // @[MapT.scala 26:10]
endmodule
module ReduceT_1(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I,
  output [7:0] O
);
  wire  NestedCountersWithNumValid_clock; // @[ReduceT.scala 22:34]
  wire  NestedCountersWithNumValid_reset; // @[ReduceT.scala 22:34]
  wire  NestedCountersWithNumValid_CE; // @[ReduceT.scala 22:34]
  wire  NestedCountersWithNumValid_valid; // @[ReduceT.scala 22:34]
  wire  NestedCountersWithNumValid_last; // @[ReduceT.scala 22:34]
  wire [7:0] MapTNoValid_I_t0b; // @[ReduceT.scala 25:25]
  wire [7:0] MapTNoValid_I_t1b; // @[ReduceT.scala 25:25]
  wire [7:0] MapTNoValid_O; // @[ReduceT.scala 25:25]
  wire  _T; // @[ReduceT.scala 26:52]
  reg [1:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[Counter.scala 37:24]
  wire [1:0] _T_3; // @[Counter.scala 38:22]
  wire  _T_5; // @[ReduceT.scala 34:60]
  reg [7:0] _T_7; // @[ReduceT.scala 35:24]
  reg [31:0] _RAND_1;
  reg  _T_8; // @[ReduceT.scala 50:28]
  reg [31:0] _RAND_2;
  wire  _T_10; // @[ReduceT.scala 51:28]
  reg [7:0] _T_11; // @[ReduceT.scala 55:15]
  reg [31:0] _RAND_3;
  NestedCountersWithNumValid_21 NestedCountersWithNumValid ( // @[ReduceT.scala 22:34]
    .clock(NestedCountersWithNumValid_clock),
    .reset(NestedCountersWithNumValid_reset),
    .CE(NestedCountersWithNumValid_CE),
    .valid(NestedCountersWithNumValid_valid),
    .last(NestedCountersWithNumValid_last)
  );
  MapTNoValid MapTNoValid ( // @[ReduceT.scala 25:25]
    .I_t0b(MapTNoValid_I_t0b),
    .I_t1b(MapTNoValid_I_t1b),
    .O(MapTNoValid_O)
  );
  assign _T = valid_up & NestedCountersWithNumValid_last; // @[ReduceT.scala 26:52]
  assign _T_1 = value == 2'h2; // @[Counter.scala 37:24]
  assign _T_3 = value + 2'h1; // @[Counter.scala 38:22]
  assign _T_5 = value == 2'h0; // @[ReduceT.scala 34:60]
  assign _T_10 = _T_8 | _T_1; // @[ReduceT.scala 51:28]
  assign valid_down = _T_8; // @[ReduceT.scala 52:16]
  assign O = _T_11; // @[ReduceT.scala 55:5]
  assign NestedCountersWithNumValid_clock = clock;
  assign NestedCountersWithNumValid_reset = reset;
  assign NestedCountersWithNumValid_CE = valid_up; // @[ReduceT.scala 37:25]
  assign MapTNoValid_I_t0b = I; // @[ReduceT.scala 43:55]
  assign MapTNoValid_I_t1b = _T_7; // @[ReduceT.scala 44:55]
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
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  _T_7 = _RAND_1[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T_8 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_11 = _RAND_3[7:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      value <= 2'h0;
    end else if (_T) begin
      if (_T_1) begin
        value <= 2'h0;
      end else begin
        value <= _T_3;
      end
    end
    if (NestedCountersWithNumValid_valid) begin
      if (_T_5) begin
        _T_7 <= I;
      end else begin
        _T_7 <= MapTNoValid_O;
      end
    end
    if (reset) begin
      _T_8 <= 1'h0;
    end else begin
      _T_8 <= _T_10;
    end
    _T_11 <= MapTNoValid_O;
  end
endmodule
module InitialDelayCounter_1(
  input   clock,
  input   reset,
  output  valid_down
);
  reg [3:0] value; // @[InitialDelayCounter.scala 8:34]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[InitialDelayCounter.scala 17:17]
  wire [3:0] _T_4; // @[InitialDelayCounter.scala 17:53]
  assign _T_1 = value < 4'hd; // @[InitialDelayCounter.scala 17:17]
  assign _T_4 = value + 4'h1; // @[InitialDelayCounter.scala 17:53]
  assign valid_down = value == 4'hd; // @[InitialDelayCounter.scala 16:16]
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
  value = _RAND_0[3:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      value <= 4'h0;
    end else if (_T_1) begin
      value <= _T_4;
    end
  end
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
module MapT_10(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_O; // @[MapT.scala 8:20]
  RShift op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_t0b(op_I_t0b),
    .I_t1b(op_I_t1b),
    .O(op_O)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O = op_O; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_t0b = I_t0b; // @[MapT.scala 14:10]
  assign op_I_t1b = I_t1b; // @[MapT.scala 14:10]
endmodule
module MapT_11(
  input        valid_up,
  output       valid_down,
  input  [7:0] I_t0b,
  input  [7:0] I_t1b,
  output [7:0] O
);
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I_t0b; // @[MapT.scala 8:20]
  wire [7:0] op_I_t1b; // @[MapT.scala 8:20]
  wire [7:0] op_O; // @[MapT.scala 8:20]
  MapT_10 op ( // @[MapT.scala 8:20]
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I_t0b(op_I_t0b),
    .I_t1b(op_I_t1b),
    .O(op_O)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O = op_O; // @[MapT.scala 15:7]
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I_t0b = I_t0b; // @[MapT.scala 14:10]
  assign op_I_t1b = I_t1b; // @[MapT.scala 14:10]
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
  wire  n105_valid_up; // @[Top.scala 17:22]
  wire  n105_valid_down; // @[Top.scala 17:22]
  wire [7:0] n105_I0; // @[Top.scala 17:22]
  wire [7:0] n105_I1; // @[Top.scala 17:22]
  wire [7:0] n105_O_t0b; // @[Top.scala 17:22]
  wire [7:0] n105_O_t1b; // @[Top.scala 17:22]
  wire  n116_valid_up; // @[Top.scala 21:22]
  wire  n116_valid_down; // @[Top.scala 21:22]
  wire [7:0] n116_I_t0b; // @[Top.scala 21:22]
  wire [7:0] n116_I_t1b; // @[Top.scala 21:22]
  wire [7:0] n116_O; // @[Top.scala 21:22]
  wire  n121_clock; // @[Top.scala 24:22]
  wire  n121_reset; // @[Top.scala 24:22]
  wire  n121_valid_up; // @[Top.scala 24:22]
  wire  n121_valid_down; // @[Top.scala 24:22]
  wire [7:0] n121_I; // @[Top.scala 24:22]
  wire [7:0] n121_O; // @[Top.scala 24:22]
  wire  n126_clock; // @[Top.scala 27:22]
  wire  n126_reset; // @[Top.scala 27:22]
  wire  n126_valid_up; // @[Top.scala 27:22]
  wire  n126_valid_down; // @[Top.scala 27:22]
  wire [7:0] n126_I; // @[Top.scala 27:22]
  wire [7:0] n126_O; // @[Top.scala 27:22]
  wire  InitialDelayCounter_1_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_valid_down; // @[Const.scala 11:33]
  wire  n129_valid_up; // @[Top.scala 31:22]
  wire  n129_valid_down; // @[Top.scala 31:22]
  wire [7:0] n129_I0; // @[Top.scala 31:22]
  wire [7:0] n129_I1; // @[Top.scala 31:22]
  wire [7:0] n129_O_t0b; // @[Top.scala 31:22]
  wire [7:0] n129_O_t1b; // @[Top.scala 31:22]
  wire  n140_valid_up; // @[Top.scala 35:22]
  wire  n140_valid_down; // @[Top.scala 35:22]
  wire [7:0] n140_I_t0b; // @[Top.scala 35:22]
  wire [7:0] n140_I_t1b; // @[Top.scala 35:22]
  wire [7:0] n140_O; // @[Top.scala 35:22]
  reg [3:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_0;
  wire  _T_1; // @[Counter.scala 37:24]
  wire [3:0] _T_3; // @[Counter.scala 38:22]
  wire [7:0] _GEN_3; // @[Const.scala 25:72]
  wire [7:0] _GEN_4; // @[Const.scala 25:72]
  wire [7:0] _GEN_5; // @[Const.scala 25:72]
  wire [7:0] _GEN_6; // @[Const.scala 25:72]
  wire [7:0] _GEN_7; // @[Const.scala 25:72]
  wire [7:0] _GEN_8; // @[Const.scala 25:72]
  wire [7:0] _GEN_9; // @[Const.scala 25:72]
  reg [3:0] value_1; // @[Counter.scala 29:33]
  reg [31:0] _RAND_1;
  wire  _T_7; // @[Counter.scala 37:24]
  wire [3:0] _T_9; // @[Counter.scala 38:22]
  wire [7:0] _GEN_14; // @[Const.scala 25:72]
  wire [7:0] _GEN_15; // @[Const.scala 25:72]
  wire [7:0] _GEN_16; // @[Const.scala 25:72]
  wire [7:0] _GEN_17; // @[Const.scala 25:72]
  wire [7:0] _GEN_18; // @[Const.scala 25:72]
  wire [7:0] _GEN_19; // @[Const.scala 25:72]
  wire [7:0] _GEN_20; // @[Const.scala 25:72]
  InitialDelayCounter InitialDelayCounter ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_clock),
    .reset(InitialDelayCounter_reset),
    .valid_down(InitialDelayCounter_valid_down)
  );
  Map2T_23 n105 ( // @[Top.scala 17:22]
    .valid_up(n105_valid_up),
    .valid_down(n105_valid_down),
    .I0(n105_I0),
    .I1(n105_I1),
    .O_t0b(n105_O_t0b),
    .O_t1b(n105_O_t1b)
  );
  MapT_8 n116 ( // @[Top.scala 21:22]
    .valid_up(n116_valid_up),
    .valid_down(n116_valid_down),
    .I_t0b(n116_I_t0b),
    .I_t1b(n116_I_t1b),
    .O(n116_O)
  );
  MapT_9 n121 ( // @[Top.scala 24:22]
    .clock(n121_clock),
    .reset(n121_reset),
    .valid_up(n121_valid_up),
    .valid_down(n121_valid_down),
    .I(n121_I),
    .O(n121_O)
  );
  ReduceT_1 n126 ( // @[Top.scala 27:22]
    .clock(n126_clock),
    .reset(n126_reset),
    .valid_up(n126_valid_up),
    .valid_down(n126_valid_down),
    .I(n126_I),
    .O(n126_O)
  );
  InitialDelayCounter_1 InitialDelayCounter_1 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_1_clock),
    .reset(InitialDelayCounter_1_reset),
    .valid_down(InitialDelayCounter_1_valid_down)
  );
  Map2T_23 n129 ( // @[Top.scala 31:22]
    .valid_up(n129_valid_up),
    .valid_down(n129_valid_down),
    .I0(n129_I0),
    .I1(n129_I1),
    .O_t0b(n129_O_t0b),
    .O_t1b(n129_O_t1b)
  );
  MapT_11 n140 ( // @[Top.scala 35:22]
    .valid_up(n140_valid_up),
    .valid_down(n140_valid_down),
    .I_t0b(n140_I_t0b),
    .I_t1b(n140_I_t1b),
    .O(n140_O)
  );
  assign _T_1 = value == 4'h8; // @[Counter.scala 37:24]
  assign _T_3 = value + 4'h1; // @[Counter.scala 38:22]
  assign _GEN_3 = 4'h1 == value ? 8'h1 : 8'h0; // @[Const.scala 25:72]
  assign _GEN_4 = 4'h2 == value ? 8'h0 : _GEN_3; // @[Const.scala 25:72]
  assign _GEN_5 = 4'h3 == value ? 8'h1 : _GEN_4; // @[Const.scala 25:72]
  assign _GEN_6 = 4'h4 == value ? 8'h2 : _GEN_5; // @[Const.scala 25:72]
  assign _GEN_7 = 4'h5 == value ? 8'h1 : _GEN_6; // @[Const.scala 25:72]
  assign _GEN_8 = 4'h6 == value ? 8'h0 : _GEN_7; // @[Const.scala 25:72]
  assign _GEN_9 = 4'h7 == value ? 8'h1 : _GEN_8; // @[Const.scala 25:72]
  assign _T_7 = value_1 == 4'h8; // @[Counter.scala 37:24]
  assign _T_9 = value_1 + 4'h1; // @[Counter.scala 38:22]
  assign _GEN_14 = 4'h1 == value_1 ? 8'h0 : 8'h4; // @[Const.scala 25:72]
  assign _GEN_15 = 4'h2 == value_1 ? 8'h0 : _GEN_14; // @[Const.scala 25:72]
  assign _GEN_16 = 4'h3 == value_1 ? 8'h0 : _GEN_15; // @[Const.scala 25:72]
  assign _GEN_17 = 4'h4 == value_1 ? 8'h0 : _GEN_16; // @[Const.scala 25:72]
  assign _GEN_18 = 4'h5 == value_1 ? 8'h0 : _GEN_17; // @[Const.scala 25:72]
  assign _GEN_19 = 4'h6 == value_1 ? 8'h0 : _GEN_18; // @[Const.scala 25:72]
  assign _GEN_20 = 4'h7 == value_1 ? 8'h0 : _GEN_19; // @[Const.scala 25:72]
  assign valid_down = n140_valid_down; // @[Top.scala 39:16]
  assign O = n140_O; // @[Top.scala 38:7]
  assign InitialDelayCounter_clock = clock;
  assign InitialDelayCounter_reset = reset;
  assign n105_valid_up = valid_up & InitialDelayCounter_valid_down; // @[Top.scala 20:19]
  assign n105_I0 = I; // @[Top.scala 18:13]
  assign n105_I1 = 4'h8 == value ? 8'h0 : _GEN_9; // @[Top.scala 19:13]
  assign n116_valid_up = n105_valid_down; // @[Top.scala 23:19]
  assign n116_I_t0b = n105_O_t0b; // @[Top.scala 22:12]
  assign n116_I_t1b = n105_O_t1b; // @[Top.scala 22:12]
  assign n121_clock = clock;
  assign n121_reset = reset;
  assign n121_valid_up = n116_valid_down; // @[Top.scala 26:19]
  assign n121_I = n116_O; // @[Top.scala 25:12]
  assign n126_clock = clock;
  assign n126_reset = reset;
  assign n126_valid_up = n121_valid_down; // @[Top.scala 29:19]
  assign n126_I = n121_O; // @[Top.scala 28:12]
  assign InitialDelayCounter_1_clock = clock;
  assign InitialDelayCounter_1_reset = reset;
  assign n129_valid_up = n126_valid_down & InitialDelayCounter_1_valid_down; // @[Top.scala 34:19]
  assign n129_I0 = n126_O; // @[Top.scala 32:13]
  assign n129_I1 = 4'h8 == value_1 ? 8'h0 : _GEN_20; // @[Top.scala 33:13]
  assign n140_valid_up = n129_valid_down; // @[Top.scala 37:19]
  assign n140_I_t0b = n129_O_t0b; // @[Top.scala 36:12]
  assign n140_I_t1b = n129_O_t1b; // @[Top.scala 36:12]
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
  value = _RAND_0[3:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  value_1 = _RAND_1[3:0];
  `endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      value <= 4'h0;
    end else if (InitialDelayCounter_valid_down) begin
      if (_T_1) begin
        value <= 4'h0;
      end else begin
        value <= _T_3;
      end
    end
    if (reset) begin
      value_1 <= 4'h0;
    end else if (InitialDelayCounter_1_valid_down) begin
      if (_T_7) begin
        value_1 <= 4'h0;
      end else begin
        value_1 <= _T_9;
      end
    end
  end
endmodule
module MapT_12(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I,
  output [7:0] O
);
  wire  op_clock; // @[MapT.scala 8:20]
  wire  op_reset; // @[MapT.scala 8:20]
  wire  op_valid_up; // @[MapT.scala 8:20]
  wire  op_valid_down; // @[MapT.scala 8:20]
  wire [7:0] op_I; // @[MapT.scala 8:20]
  wire [7:0] op_O; // @[MapT.scala 8:20]
  Module_0 op ( // @[MapT.scala 8:20]
    .clock(op_clock),
    .reset(op_reset),
    .valid_up(op_valid_up),
    .valid_down(op_valid_down),
    .I(op_I),
    .O(op_O)
  );
  assign valid_down = op_valid_down; // @[MapT.scala 16:16]
  assign O = op_O; // @[MapT.scala 15:7]
  assign op_clock = clock;
  assign op_reset = reset;
  assign op_valid_up = valid_up; // @[MapT.scala 13:17]
  assign op_I = I; // @[MapT.scala 14:10]
endmodule
module Passthrough(
  input        valid_up,
  output       valid_down,
  input  [7:0] I,
  output [7:0] O
);
  assign valid_down = valid_up; // @[Passthrough.scala 18:14]
  assign O = I; // @[Passthrough.scala 17:68]
endmodule
module FIFO_1(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I,
  output [7:0] O
);
  reg [7:0] _T [0:12]; // @[FIFO.scala 23:33]
  reg [31:0] _RAND_0;
  wire [7:0] _T__T_17_data; // @[FIFO.scala 23:33]
  wire [3:0] _T__T_17_addr; // @[FIFO.scala 23:33]
  reg [31:0] _RAND_1;
  wire [7:0] _T__T_5_data; // @[FIFO.scala 23:33]
  wire [3:0] _T__T_5_addr; // @[FIFO.scala 23:33]
  wire  _T__T_5_mask; // @[FIFO.scala 23:33]
  wire  _T__T_5_en; // @[FIFO.scala 23:33]
  reg  _T__T_17_en_pipe_0;
  reg [31:0] _RAND_2;
  reg [3:0] _T__T_17_addr_pipe_0;
  reg [31:0] _RAND_3;
  reg [3:0] value; // @[Counter.scala 29:33]
  reg [31:0] _RAND_4;
  reg [3:0] value_1; // @[Counter.scala 29:33]
  reg [31:0] _RAND_5;
  reg [3:0] value_2; // @[Counter.scala 29:33]
  reg [31:0] _RAND_6;
  wire  _T_1; // @[FIFO.scala 33:46]
  wire  _T_2; // @[Counter.scala 37:24]
  wire [3:0] _T_4; // @[Counter.scala 38:22]
  wire  _T_6; // @[FIFO.scala 38:39]
  wire [3:0] _T_11; // @[Counter.scala 38:22]
  wire  _T_12; // @[FIFO.scala 42:39]
  wire  _T_18; // @[Counter.scala 37:24]
  wire [3:0] _T_20; // @[Counter.scala 38:22]
  wire  _GEN_8; // @[FIFO.scala 42:57]
  wire  _GEN_25; // @[FIFO.scala 39:15]
  assign _T__T_17_addr = _T__T_17_addr_pipe_0;
  `ifndef RANDOMIZE_GARBAGE_ASSIGN
  assign _T__T_17_data = _T[_T__T_17_addr]; // @[FIFO.scala 23:33]
  `else
  assign _T__T_17_data = _T__T_17_addr >= 4'hd ? _RAND_1[7:0] : _T[_T__T_17_addr]; // @[FIFO.scala 23:33]
  `endif // RANDOMIZE_GARBAGE_ASSIGN
  assign _T__T_5_data = I;
  assign _T__T_5_addr = value_2;
  assign _T__T_5_mask = 1'h1;
  assign _T__T_5_en = valid_up;
  assign _T_1 = value == 4'hc; // @[FIFO.scala 33:46]
  assign _T_2 = value_2 == 4'hc; // @[Counter.scala 37:24]
  assign _T_4 = value_2 + 4'h1; // @[Counter.scala 38:22]
  assign _T_6 = value < 4'hc; // @[FIFO.scala 38:39]
  assign _T_11 = value + 4'h1; // @[Counter.scala 38:22]
  assign _T_12 = value >= 4'hb; // @[FIFO.scala 42:39]
  assign _T_18 = value_1 == 4'hc; // @[Counter.scala 37:24]
  assign _T_20 = value_1 + 4'h1; // @[Counter.scala 38:22]
  assign _GEN_8 = _T_12 & _T_12; // @[FIFO.scala 42:57]
  assign valid_down = value == 4'hc; // @[FIFO.scala 33:16]
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
  for (initvar = 0; initvar < 13; initvar = initvar+1)
    _T[initvar] = _RAND_0[7:0];
  `endif // RANDOMIZE_MEM_INIT
  _RAND_1 = {1{`RANDOM}};
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  _T__T_17_en_pipe_0 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T__T_17_addr_pipe_0 = _RAND_3[3:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  value = _RAND_4[3:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{`RANDOM}};
  value_1 = _RAND_5[3:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{`RANDOM}};
  value_2 = _RAND_6[3:0];
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
      value <= 4'h0;
    end else if (valid_up) begin
      if (_T_6) begin
        if (_T_1) begin
          value <= 4'h0;
        end else begin
          value <= _T_11;
        end
      end
    end
    if (reset) begin
      value_1 <= 4'h0;
    end else if (valid_up) begin
      if (_T_12) begin
        if (_T_18) begin
          value_1 <= 4'h0;
        end else begin
          value_1 <= _T_20;
        end
      end
    end
    if (reset) begin
      value_2 <= 4'h0;
    end else if (valid_up) begin
      if (_T_2) begin
        value_2 <= 4'h0;
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
  wire  n154_valid_up; // @[Top.scala 47:22]
  wire  n154_valid_down; // @[Top.scala 47:22]
  wire [7:0] n154_I0; // @[Top.scala 47:22]
  wire [7:0] n154_I1; // @[Top.scala 47:22]
  wire [7:0] n154_O_t0b; // @[Top.scala 47:22]
  wire [7:0] n154_O_t1b; // @[Top.scala 47:22]
  wire  n155_valid_up; // @[Top.scala 51:22]
  wire  n155_valid_down; // @[Top.scala 51:22]
  wire [7:0] n155_I_t0b; // @[Top.scala 51:22]
  wire [7:0] n155_I_t1b; // @[Top.scala 51:22]
  wire [7:0] n155_O; // @[Top.scala 51:22]
  wire  n157_valid_up; // @[Top.scala 54:22]
  wire  n157_valid_down; // @[Top.scala 54:22]
  wire [7:0] n157_I0; // @[Top.scala 54:22]
  wire [7:0] n157_I1; // @[Top.scala 54:22]
  wire [7:0] n157_O_t0b; // @[Top.scala 54:22]
  wire [7:0] n157_O_t1b; // @[Top.scala 54:22]
  wire  n158_valid_up; // @[Top.scala 58:22]
  wire  n158_valid_down; // @[Top.scala 58:22]
  wire [7:0] n158_I_t0b; // @[Top.scala 58:22]
  wire [7:0] n158_I_t1b; // @[Top.scala 58:22]
  wire [7:0] n158_O; // @[Top.scala 58:22]
  wire  InitialDelayCounter_1_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_1_valid_down; // @[Const.scala 11:33]
  wire  n159_valid_up; // @[Top.scala 62:22]
  wire  n159_valid_down; // @[Top.scala 62:22]
  wire [7:0] n159_I0; // @[Top.scala 62:22]
  wire [7:0] n159_I1; // @[Top.scala 62:22]
  wire [7:0] n159_O_t0b; // @[Top.scala 62:22]
  wire [7:0] n159_O_t1b; // @[Top.scala 62:22]
  wire  n160_valid_up; // @[Top.scala 66:22]
  wire  n160_valid_down; // @[Top.scala 66:22]
  wire [7:0] n160_I_t0b; // @[Top.scala 66:22]
  wire [7:0] n160_I_t1b; // @[Top.scala 66:22]
  wire [7:0] n160_O; // @[Top.scala 66:22]
  wire  n162_valid_up; // @[Top.scala 69:22]
  wire  n162_valid_down; // @[Top.scala 69:22]
  wire [7:0] n162_I0; // @[Top.scala 69:22]
  wire [7:0] n162_I1; // @[Top.scala 69:22]
  wire [7:0] n162_O_t0b; // @[Top.scala 69:22]
  wire [7:0] n162_O_t1b; // @[Top.scala 69:22]
  wire  n163_valid_up; // @[Top.scala 73:22]
  wire  n163_valid_down; // @[Top.scala 73:22]
  wire [7:0] n163_I_t0b; // @[Top.scala 73:22]
  wire [7:0] n163_I_t1b; // @[Top.scala 73:22]
  wire [7:0] n163_O; // @[Top.scala 73:22]
  wire  n164_valid_up; // @[Top.scala 76:22]
  wire  n164_valid_down; // @[Top.scala 76:22]
  wire  n164_I0; // @[Top.scala 76:22]
  wire  n164_I1; // @[Top.scala 76:22]
  wire  n164_O_t0b; // @[Top.scala 76:22]
  wire  n164_O_t1b; // @[Top.scala 76:22]
  wire  n165_valid_up; // @[Top.scala 80:22]
  wire  n165_valid_down; // @[Top.scala 80:22]
  wire  n165_I_t0b; // @[Top.scala 80:22]
  wire  n165_I_t1b; // @[Top.scala 80:22]
  wire  n165_O; // @[Top.scala 80:22]
  wire  InitialDelayCounter_2_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_2_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_2_valid_down; // @[Const.scala 11:33]
  wire  n168_valid_up; // @[Top.scala 84:22]
  wire  n168_valid_down; // @[Top.scala 84:22]
  wire [7:0] n168_I0; // @[Top.scala 84:22]
  wire [7:0] n168_I1; // @[Top.scala 84:22]
  wire [7:0] n168_O_t0b; // @[Top.scala 84:22]
  wire [7:0] n168_O_t1b; // @[Top.scala 84:22]
  wire  n169_valid_up; // @[Top.scala 88:22]
  wire  n169_valid_down; // @[Top.scala 88:22]
  wire  n169_I0; // @[Top.scala 88:22]
  wire [7:0] n169_I1_t0b; // @[Top.scala 88:22]
  wire [7:0] n169_I1_t1b; // @[Top.scala 88:22]
  wire  n169_O_t0b; // @[Top.scala 88:22]
  wire [7:0] n169_O_t1b_t0b; // @[Top.scala 88:22]
  wire [7:0] n169_O_t1b_t1b; // @[Top.scala 88:22]
  wire  n170_valid_up; // @[Top.scala 92:22]
  wire  n170_valid_down; // @[Top.scala 92:22]
  wire  n170_I_t0b; // @[Top.scala 92:22]
  wire [7:0] n170_I_t1b_t0b; // @[Top.scala 92:22]
  wire [7:0] n170_I_t1b_t1b; // @[Top.scala 92:22]
  wire [7:0] n170_O; // @[Top.scala 92:22]
  wire  InitialDelayCounter_3_clock; // @[Const.scala 11:33]
  wire  InitialDelayCounter_3_reset; // @[Const.scala 11:33]
  wire  InitialDelayCounter_3_valid_down; // @[Const.scala 11:33]
  wire  n173_valid_up; // @[Top.scala 96:22]
  wire  n173_valid_down; // @[Top.scala 96:22]
  wire [7:0] n173_I0; // @[Top.scala 96:22]
  wire [7:0] n173_I1; // @[Top.scala 96:22]
  wire [7:0] n173_O_t0b; // @[Top.scala 96:22]
  wire [7:0] n173_O_t1b; // @[Top.scala 96:22]
  wire  n174_valid_up; // @[Top.scala 100:22]
  wire  n174_valid_down; // @[Top.scala 100:22]
  wire [7:0] n174_I_t0b; // @[Top.scala 100:22]
  wire [7:0] n174_I_t1b; // @[Top.scala 100:22]
  wire [7:0] n174_O; // @[Top.scala 100:22]
  wire  n175_valid_up; // @[Top.scala 103:22]
  wire  n175_valid_down; // @[Top.scala 103:22]
  wire [7:0] n175_I0; // @[Top.scala 103:22]
  wire [7:0] n175_I1; // @[Top.scala 103:22]
  wire [7:0] n175_O_t0b; // @[Top.scala 103:22]
  wire [7:0] n175_O_t1b; // @[Top.scala 103:22]
  wire  n176_valid_up; // @[Top.scala 107:22]
  wire  n176_valid_down; // @[Top.scala 107:22]
  wire [7:0] n176_I_t0b; // @[Top.scala 107:22]
  wire [7:0] n176_I_t1b; // @[Top.scala 107:22]
  wire [7:0] n176_O; // @[Top.scala 107:22]
  InitialDelayCounter_1 InitialDelayCounter ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_clock),
    .reset(InitialDelayCounter_reset),
    .valid_down(InitialDelayCounter_valid_down)
  );
  AtomTuple n154 ( // @[Top.scala 47:22]
    .valid_up(n154_valid_up),
    .valid_down(n154_valid_down),
    .I0(n154_I0),
    .I1(n154_I1),
    .O_t0b(n154_O_t0b),
    .O_t1b(n154_O_t1b)
  );
  Sub n155 ( // @[Top.scala 51:22]
    .valid_up(n155_valid_up),
    .valid_down(n155_valid_down),
    .I_t0b(n155_I_t0b),
    .I_t1b(n155_I_t1b),
    .O(n155_O)
  );
  AtomTuple n157 ( // @[Top.scala 54:22]
    .valid_up(n157_valid_up),
    .valid_down(n157_valid_down),
    .I0(n157_I0),
    .I1(n157_I1),
    .O_t0b(n157_O_t0b),
    .O_t1b(n157_O_t1b)
  );
  Lt n158 ( // @[Top.scala 58:22]
    .valid_up(n158_valid_up),
    .valid_down(n158_valid_down),
    .I_t0b(n158_I_t0b),
    .I_t1b(n158_I_t1b),
    .O(n158_O)
  );
  InitialDelayCounter_1 InitialDelayCounter_1 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_1_clock),
    .reset(InitialDelayCounter_1_reset),
    .valid_down(InitialDelayCounter_1_valid_down)
  );
  AtomTuple n159 ( // @[Top.scala 62:22]
    .valid_up(n159_valid_up),
    .valid_down(n159_valid_down),
    .I0(n159_I0),
    .I1(n159_I1),
    .O_t0b(n159_O_t0b),
    .O_t1b(n159_O_t1b)
  );
  Sub n160 ( // @[Top.scala 66:22]
    .valid_up(n160_valid_up),
    .valid_down(n160_valid_down),
    .I_t0b(n160_I_t0b),
    .I_t1b(n160_I_t1b),
    .O(n160_O)
  );
  AtomTuple n162 ( // @[Top.scala 69:22]
    .valid_up(n162_valid_up),
    .valid_down(n162_valid_down),
    .I0(n162_I0),
    .I1(n162_I1),
    .O_t0b(n162_O_t0b),
    .O_t1b(n162_O_t1b)
  );
  Lt n163 ( // @[Top.scala 73:22]
    .valid_up(n163_valid_up),
    .valid_down(n163_valid_down),
    .I_t0b(n163_I_t0b),
    .I_t1b(n163_I_t1b),
    .O(n163_O)
  );
  AtomTuple_6 n164 ( // @[Top.scala 76:22]
    .valid_up(n164_valid_up),
    .valid_down(n164_valid_down),
    .I0(n164_I0),
    .I1(n164_I1),
    .O_t0b(n164_O_t0b),
    .O_t1b(n164_O_t1b)
  );
  Or n165 ( // @[Top.scala 80:22]
    .valid_up(n165_valid_up),
    .valid_down(n165_valid_down),
    .I_t0b(n165_I_t0b),
    .I_t1b(n165_I_t1b),
    .O(n165_O)
  );
  InitialDelayCounter_1 InitialDelayCounter_2 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_2_clock),
    .reset(InitialDelayCounter_2_reset),
    .valid_down(InitialDelayCounter_2_valid_down)
  );
  AtomTuple n168 ( // @[Top.scala 84:22]
    .valid_up(n168_valid_up),
    .valid_down(n168_valid_down),
    .I0(n168_I0),
    .I1(n168_I1),
    .O_t0b(n168_O_t0b),
    .O_t1b(n168_O_t1b)
  );
  AtomTuple_8 n169 ( // @[Top.scala 88:22]
    .valid_up(n169_valid_up),
    .valid_down(n169_valid_down),
    .I0(n169_I0),
    .I1_t0b(n169_I1_t0b),
    .I1_t1b(n169_I1_t1b),
    .O_t0b(n169_O_t0b),
    .O_t1b_t0b(n169_O_t1b_t0b),
    .O_t1b_t1b(n169_O_t1b_t1b)
  );
  If n170 ( // @[Top.scala 92:22]
    .valid_up(n170_valid_up),
    .valid_down(n170_valid_down),
    .I_t0b(n170_I_t0b),
    .I_t1b_t0b(n170_I_t1b_t0b),
    .I_t1b_t1b(n170_I_t1b_t1b),
    .O(n170_O)
  );
  InitialDelayCounter_1 InitialDelayCounter_3 ( // @[Const.scala 11:33]
    .clock(InitialDelayCounter_3_clock),
    .reset(InitialDelayCounter_3_reset),
    .valid_down(InitialDelayCounter_3_valid_down)
  );
  AtomTuple n173 ( // @[Top.scala 96:22]
    .valid_up(n173_valid_up),
    .valid_down(n173_valid_down),
    .I0(n173_I0),
    .I1(n173_I1),
    .O_t0b(n173_O_t0b),
    .O_t1b(n173_O_t1b)
  );
  RShift n174 ( // @[Top.scala 100:22]
    .valid_up(n174_valid_up),
    .valid_down(n174_valid_down),
    .I_t0b(n174_I_t0b),
    .I_t1b(n174_I_t1b),
    .O(n174_O)
  );
  AtomTuple n175 ( // @[Top.scala 103:22]
    .valid_up(n175_valid_up),
    .valid_down(n175_valid_down),
    .I0(n175_I0),
    .I1(n175_I1),
    .O_t0b(n175_O_t0b),
    .O_t1b(n175_O_t1b)
  );
  Add n176 ( // @[Top.scala 107:22]
    .valid_up(n176_valid_up),
    .valid_down(n176_valid_down),
    .I_t0b(n176_I_t0b),
    .I_t1b(n176_I_t1b),
    .O(n176_O)
  );
  assign valid_down = n176_valid_down; // @[Top.scala 111:16]
  assign O = n176_O; // @[Top.scala 110:7]
  assign InitialDelayCounter_clock = clock;
  assign InitialDelayCounter_reset = reset;
  assign n154_valid_up = valid_up; // @[Top.scala 50:19]
  assign n154_I0 = I0; // @[Top.scala 48:13]
  assign n154_I1 = I1; // @[Top.scala 49:13]
  assign n155_valid_up = n154_valid_down; // @[Top.scala 53:19]
  assign n155_I_t0b = n154_O_t0b; // @[Top.scala 52:12]
  assign n155_I_t1b = n154_O_t1b; // @[Top.scala 52:12]
  assign n157_valid_up = InitialDelayCounter_valid_down & n155_valid_down; // @[Top.scala 57:19]
  assign n157_I0 = 8'hf; // @[Top.scala 55:13]
  assign n157_I1 = n155_O; // @[Top.scala 56:13]
  assign n158_valid_up = n157_valid_down; // @[Top.scala 60:19]
  assign n158_I_t0b = n157_O_t0b; // @[Top.scala 59:12]
  assign n158_I_t1b = n157_O_t1b; // @[Top.scala 59:12]
  assign InitialDelayCounter_1_clock = clock;
  assign InitialDelayCounter_1_reset = reset;
  assign n159_valid_up = valid_up; // @[Top.scala 65:19]
  assign n159_I0 = I1; // @[Top.scala 63:13]
  assign n159_I1 = I0; // @[Top.scala 64:13]
  assign n160_valid_up = n159_valid_down; // @[Top.scala 68:19]
  assign n160_I_t0b = n159_O_t0b; // @[Top.scala 67:12]
  assign n160_I_t1b = n159_O_t1b; // @[Top.scala 67:12]
  assign n162_valid_up = InitialDelayCounter_1_valid_down & n160_valid_down; // @[Top.scala 72:19]
  assign n162_I0 = 8'hf; // @[Top.scala 70:13]
  assign n162_I1 = n160_O; // @[Top.scala 71:13]
  assign n163_valid_up = n162_valid_down; // @[Top.scala 75:19]
  assign n163_I_t0b = n162_O_t0b; // @[Top.scala 74:12]
  assign n163_I_t1b = n162_O_t1b; // @[Top.scala 74:12]
  assign n164_valid_up = n158_valid_down & n163_valid_down; // @[Top.scala 79:19]
  assign n164_I0 = n158_O[0]; // @[Top.scala 77:13]
  assign n164_I1 = n163_O[0]; // @[Top.scala 78:13]
  assign n165_valid_up = n164_valid_down; // @[Top.scala 82:19]
  assign n165_I_t0b = n164_O_t0b; // @[Top.scala 81:12]
  assign n165_I_t1b = n164_O_t1b; // @[Top.scala 81:12]
  assign InitialDelayCounter_2_clock = clock;
  assign InitialDelayCounter_2_reset = reset;
  assign n168_valid_up = n160_valid_down & InitialDelayCounter_2_valid_down; // @[Top.scala 87:19]
  assign n168_I0 = n160_O; // @[Top.scala 85:13]
  assign n168_I1 = 8'h0; // @[Top.scala 86:13]
  assign n169_valid_up = n165_valid_down & n168_valid_down; // @[Top.scala 91:19]
  assign n169_I0 = n165_O; // @[Top.scala 89:13]
  assign n169_I1_t0b = n168_O_t0b; // @[Top.scala 90:13]
  assign n169_I1_t1b = n168_O_t1b; // @[Top.scala 90:13]
  assign n170_valid_up = n169_valid_down; // @[Top.scala 94:19]
  assign n170_I_t0b = n169_O_t0b; // @[Top.scala 93:12]
  assign n170_I_t1b_t0b = n169_O_t1b_t0b; // @[Top.scala 93:12]
  assign n170_I_t1b_t1b = n169_O_t1b_t1b; // @[Top.scala 93:12]
  assign InitialDelayCounter_3_clock = clock;
  assign InitialDelayCounter_3_reset = reset;
  assign n173_valid_up = n170_valid_down & InitialDelayCounter_3_valid_down; // @[Top.scala 99:19]
  assign n173_I0 = n170_O; // @[Top.scala 97:13]
  assign n173_I1 = 8'h2; // @[Top.scala 98:13]
  assign n174_valid_up = n173_valid_down; // @[Top.scala 102:19]
  assign n174_I_t0b = n173_O_t0b; // @[Top.scala 101:12]
  assign n174_I_t1b = n173_O_t1b; // @[Top.scala 101:12]
  assign n175_valid_up = valid_up & n174_valid_down; // @[Top.scala 106:19]
  assign n175_I0 = I1; // @[Top.scala 104:13]
  assign n175_I1 = n174_O; // @[Top.scala 105:13]
  assign n176_valid_up = n175_valid_down; // @[Top.scala 109:19]
  assign n176_I_t0b = n175_O_t0b; // @[Top.scala 108:12]
  assign n176_I_t1b = n175_O_t1b; // @[Top.scala 108:12]
endmodule
module Map2T_26(
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
module Map2T_27(
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
  Map2T_26 op ( // @[Map2T.scala 8:20]
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
module Map2T_28(
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
  Map2T_27 op ( // @[Map2T.scala 8:20]
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
module Top(
  input        clock,
  input        reset,
  input        valid_up,
  output       valid_down,
  input  [7:0] I,
  output [7:0] O
);
  wire  n1_clock; // @[Top.scala 117:20]
  wire  n1_reset; // @[Top.scala 117:20]
  wire  n1_valid_up; // @[Top.scala 117:20]
  wire  n1_valid_down; // @[Top.scala 117:20]
  wire [7:0] n1_I; // @[Top.scala 117:20]
  wire [7:0] n1_O; // @[Top.scala 117:20]
  wire  n2_clock; // @[Top.scala 120:20]
  wire  n2_reset; // @[Top.scala 120:20]
  wire  n2_valid_up; // @[Top.scala 120:20]
  wire  n2_valid_down; // @[Top.scala 120:20]
  wire [7:0] n2_I; // @[Top.scala 120:20]
  wire [7:0] n2_O; // @[Top.scala 120:20]
  wire  n3_clock; // @[Top.scala 123:20]
  wire  n3_reset; // @[Top.scala 123:20]
  wire  n3_valid_up; // @[Top.scala 123:20]
  wire  n3_valid_down; // @[Top.scala 123:20]
  wire [7:0] n3_I; // @[Top.scala 123:20]
  wire [7:0] n3_O; // @[Top.scala 123:20]
  wire  n4_clock; // @[Top.scala 126:20]
  wire  n4_reset; // @[Top.scala 126:20]
  wire  n4_valid_up; // @[Top.scala 126:20]
  wire  n4_valid_down; // @[Top.scala 126:20]
  wire [7:0] n4_I; // @[Top.scala 126:20]
  wire [7:0] n4_O; // @[Top.scala 126:20]
  wire  n5_clock; // @[Top.scala 129:20]
  wire  n5_reset; // @[Top.scala 129:20]
  wire  n5_valid_up; // @[Top.scala 129:20]
  wire  n5_valid_down; // @[Top.scala 129:20]
  wire [7:0] n5_I; // @[Top.scala 129:20]
  wire [7:0] n5_O; // @[Top.scala 129:20]
  wire  n6_valid_up; // @[Top.scala 132:20]
  wire  n6_valid_down; // @[Top.scala 132:20]
  wire [7:0] n6_I0; // @[Top.scala 132:20]
  wire [7:0] n6_I1; // @[Top.scala 132:20]
  wire [7:0] n6_O_0; // @[Top.scala 132:20]
  wire [7:0] n6_O_1; // @[Top.scala 132:20]
  wire  n16_valid_up; // @[Top.scala 136:21]
  wire  n16_valid_down; // @[Top.scala 136:21]
  wire [7:0] n16_I0_0; // @[Top.scala 136:21]
  wire [7:0] n16_I0_1; // @[Top.scala 136:21]
  wire [7:0] n16_I1; // @[Top.scala 136:21]
  wire [7:0] n16_O_0; // @[Top.scala 136:21]
  wire [7:0] n16_O_1; // @[Top.scala 136:21]
  wire [7:0] n16_O_2; // @[Top.scala 136:21]
  wire  n30_clock; // @[Top.scala 140:21]
  wire  n30_reset; // @[Top.scala 140:21]
  wire  n30_valid_up; // @[Top.scala 140:21]
  wire  n30_valid_down; // @[Top.scala 140:21]
  wire [7:0] n30_I_0; // @[Top.scala 140:21]
  wire [7:0] n30_I_1; // @[Top.scala 140:21]
  wire [7:0] n30_I_2; // @[Top.scala 140:21]
  wire [7:0] n30_O; // @[Top.scala 140:21]
  wire  n31_clock; // @[Top.scala 143:21]
  wire  n31_reset; // @[Top.scala 143:21]
  wire  n31_valid_up; // @[Top.scala 143:21]
  wire  n31_valid_down; // @[Top.scala 143:21]
  wire [7:0] n31_I; // @[Top.scala 143:21]
  wire [7:0] n31_O; // @[Top.scala 143:21]
  wire  n32_clock; // @[Top.scala 146:21]
  wire  n32_reset; // @[Top.scala 146:21]
  wire  n32_valid_up; // @[Top.scala 146:21]
  wire  n32_valid_down; // @[Top.scala 146:21]
  wire [7:0] n32_I; // @[Top.scala 146:21]
  wire [7:0] n32_O; // @[Top.scala 146:21]
  wire  n33_valid_up; // @[Top.scala 149:21]
  wire  n33_valid_down; // @[Top.scala 149:21]
  wire [7:0] n33_I0; // @[Top.scala 149:21]
  wire [7:0] n33_I1; // @[Top.scala 149:21]
  wire [7:0] n33_O_0; // @[Top.scala 149:21]
  wire [7:0] n33_O_1; // @[Top.scala 149:21]
  wire  n43_valid_up; // @[Top.scala 153:21]
  wire  n43_valid_down; // @[Top.scala 153:21]
  wire [7:0] n43_I0_0; // @[Top.scala 153:21]
  wire [7:0] n43_I0_1; // @[Top.scala 153:21]
  wire [7:0] n43_I1; // @[Top.scala 153:21]
  wire [7:0] n43_O_0; // @[Top.scala 153:21]
  wire [7:0] n43_O_1; // @[Top.scala 153:21]
  wire [7:0] n43_O_2; // @[Top.scala 153:21]
  wire  n57_clock; // @[Top.scala 157:21]
  wire  n57_reset; // @[Top.scala 157:21]
  wire  n57_valid_up; // @[Top.scala 157:21]
  wire  n57_valid_down; // @[Top.scala 157:21]
  wire [7:0] n57_I_0; // @[Top.scala 157:21]
  wire [7:0] n57_I_1; // @[Top.scala 157:21]
  wire [7:0] n57_I_2; // @[Top.scala 157:21]
  wire [7:0] n57_O; // @[Top.scala 157:21]
  wire  n58_valid_up; // @[Top.scala 160:21]
  wire  n58_valid_down; // @[Top.scala 160:21]
  wire [7:0] n58_I0; // @[Top.scala 160:21]
  wire [7:0] n58_I1; // @[Top.scala 160:21]
  wire [7:0] n58_O_0; // @[Top.scala 160:21]
  wire [7:0] n58_O_1; // @[Top.scala 160:21]
  wire  n65_clock; // @[Top.scala 164:21]
  wire  n65_reset; // @[Top.scala 164:21]
  wire  n65_valid_up; // @[Top.scala 164:21]
  wire  n65_valid_down; // @[Top.scala 164:21]
  wire [7:0] n65_I; // @[Top.scala 164:21]
  wire [7:0] n65_O; // @[Top.scala 164:21]
  wire  n66_clock; // @[Top.scala 167:21]
  wire  n66_reset; // @[Top.scala 167:21]
  wire  n66_valid_up; // @[Top.scala 167:21]
  wire  n66_valid_down; // @[Top.scala 167:21]
  wire [7:0] n66_I; // @[Top.scala 167:21]
  wire [7:0] n66_O; // @[Top.scala 167:21]
  wire  n67_valid_up; // @[Top.scala 170:21]
  wire  n67_valid_down; // @[Top.scala 170:21]
  wire [7:0] n67_I0; // @[Top.scala 170:21]
  wire [7:0] n67_I1; // @[Top.scala 170:21]
  wire [7:0] n67_O_0; // @[Top.scala 170:21]
  wire [7:0] n67_O_1; // @[Top.scala 170:21]
  wire  n77_valid_up; // @[Top.scala 174:21]
  wire  n77_valid_down; // @[Top.scala 174:21]
  wire [7:0] n77_I0_0; // @[Top.scala 174:21]
  wire [7:0] n77_I0_1; // @[Top.scala 174:21]
  wire [7:0] n77_I1; // @[Top.scala 174:21]
  wire [7:0] n77_O_0; // @[Top.scala 174:21]
  wire [7:0] n77_O_1; // @[Top.scala 174:21]
  wire [7:0] n77_O_2; // @[Top.scala 174:21]
  wire  n91_clock; // @[Top.scala 178:21]
  wire  n91_reset; // @[Top.scala 178:21]
  wire  n91_valid_up; // @[Top.scala 178:21]
  wire  n91_valid_down; // @[Top.scala 178:21]
  wire [7:0] n91_I_0; // @[Top.scala 178:21]
  wire [7:0] n91_I_1; // @[Top.scala 178:21]
  wire [7:0] n91_I_2; // @[Top.scala 178:21]
  wire [7:0] n91_O; // @[Top.scala 178:21]
  wire  n92_valid_up; // @[Top.scala 181:21]
  wire  n92_valid_down; // @[Top.scala 181:21]
  wire [7:0] n92_I0_0; // @[Top.scala 181:21]
  wire [7:0] n92_I0_1; // @[Top.scala 181:21]
  wire [7:0] n92_I1; // @[Top.scala 181:21]
  wire [7:0] n92_O_0; // @[Top.scala 181:21]
  wire [7:0] n92_O_1; // @[Top.scala 181:21]
  wire [7:0] n92_O_2; // @[Top.scala 181:21]
  wire  n101_clock; // @[Top.scala 185:22]
  wire  n101_reset; // @[Top.scala 185:22]
  wire  n101_valid_up; // @[Top.scala 185:22]
  wire  n101_valid_down; // @[Top.scala 185:22]
  wire [7:0] n101_I_0; // @[Top.scala 185:22]
  wire [7:0] n101_I_1; // @[Top.scala 185:22]
  wire [7:0] n101_I_2; // @[Top.scala 185:22]
  wire [7:0] n101_O; // @[Top.scala 185:22]
  wire  n141_clock; // @[Top.scala 188:22]
  wire  n141_reset; // @[Top.scala 188:22]
  wire  n141_valid_up; // @[Top.scala 188:22]
  wire  n141_valid_down; // @[Top.scala 188:22]
  wire [7:0] n141_I; // @[Top.scala 188:22]
  wire [7:0] n141_O; // @[Top.scala 188:22]
  wire  n142_valid_up; // @[Top.scala 191:22]
  wire  n142_valid_down; // @[Top.scala 191:22]
  wire [7:0] n142_I; // @[Top.scala 191:22]
  wire [7:0] n142_O; // @[Top.scala 191:22]
  wire  n143_clock; // @[Top.scala 194:22]
  wire  n143_reset; // @[Top.scala 194:22]
  wire  n143_valid_up; // @[Top.scala 194:22]
  wire  n143_valid_down; // @[Top.scala 194:22]
  wire [7:0] n143_I; // @[Top.scala 194:22]
  wire [7:0] n143_O; // @[Top.scala 194:22]
  wire  n144_clock; // @[Top.scala 197:22]
  wire  n144_reset; // @[Top.scala 197:22]
  wire  n144_valid_up; // @[Top.scala 197:22]
  wire  n144_valid_down; // @[Top.scala 197:22]
  wire [7:0] n144_I0; // @[Top.scala 197:22]
  wire [7:0] n144_I1; // @[Top.scala 197:22]
  wire [7:0] n144_O; // @[Top.scala 197:22]
  wire  n177_clock; // @[Top.scala 201:22]
  wire  n177_reset; // @[Top.scala 201:22]
  wire  n177_valid_up; // @[Top.scala 201:22]
  wire  n177_valid_down; // @[Top.scala 201:22]
  wire [7:0] n177_I; // @[Top.scala 201:22]
  wire [7:0] n177_O; // @[Top.scala 201:22]
  wire  n178_clock; // @[Top.scala 204:22]
  wire  n178_reset; // @[Top.scala 204:22]
  wire  n178_valid_up; // @[Top.scala 204:22]
  wire  n178_valid_down; // @[Top.scala 204:22]
  wire [7:0] n178_I; // @[Top.scala 204:22]
  wire [7:0] n178_O; // @[Top.scala 204:22]
  wire  n179_clock; // @[Top.scala 207:22]
  wire  n179_reset; // @[Top.scala 207:22]
  wire  n179_valid_up; // @[Top.scala 207:22]
  wire  n179_valid_down; // @[Top.scala 207:22]
  wire [7:0] n179_I; // @[Top.scala 207:22]
  wire [7:0] n179_O; // @[Top.scala 207:22]
  FIFO n1 ( // @[Top.scala 117:20]
    .clock(n1_clock),
    .reset(n1_reset),
    .valid_up(n1_valid_up),
    .valid_down(n1_valid_down),
    .I(n1_I),
    .O(n1_O)
  );
  ShiftTN n2 ( // @[Top.scala 120:20]
    .clock(n2_clock),
    .reset(n2_reset),
    .valid_up(n2_valid_up),
    .valid_down(n2_valid_down),
    .I(n2_I),
    .O(n2_O)
  );
  ShiftTN n3 ( // @[Top.scala 123:20]
    .clock(n3_clock),
    .reset(n3_reset),
    .valid_up(n3_valid_up),
    .valid_down(n3_valid_down),
    .I(n3_I),
    .O(n3_O)
  );
  ShiftTN_2 n4 ( // @[Top.scala 126:20]
    .clock(n4_clock),
    .reset(n4_reset),
    .valid_up(n4_valid_up),
    .valid_down(n4_valid_down),
    .I(n4_I),
    .O(n4_O)
  );
  ShiftTN_2 n5 ( // @[Top.scala 129:20]
    .clock(n5_clock),
    .reset(n5_reset),
    .valid_up(n5_valid_up),
    .valid_down(n5_valid_down),
    .I(n5_I),
    .O(n5_O)
  );
  Map2T_2 n6 ( // @[Top.scala 132:20]
    .valid_up(n6_valid_up),
    .valid_down(n6_valid_down),
    .I0(n6_I0),
    .I1(n6_I1),
    .O_0(n6_O_0),
    .O_1(n6_O_1)
  );
  Map2T_5 n16 ( // @[Top.scala 136:21]
    .valid_up(n16_valid_up),
    .valid_down(n16_valid_down),
    .I0_0(n16_I0_0),
    .I0_1(n16_I0_1),
    .I1(n16_I1),
    .O_0(n16_O_0),
    .O_1(n16_O_1),
    .O_2(n16_O_2)
  );
  MapT_1 n30 ( // @[Top.scala 140:21]
    .clock(n30_clock),
    .reset(n30_reset),
    .valid_up(n30_valid_up),
    .valid_down(n30_valid_down),
    .I_0(n30_I_0),
    .I_1(n30_I_1),
    .I_2(n30_I_2),
    .O(n30_O)
  );
  ShiftTN_2 n31 ( // @[Top.scala 143:21]
    .clock(n31_clock),
    .reset(n31_reset),
    .valid_up(n31_valid_up),
    .valid_down(n31_valid_down),
    .I(n31_I),
    .O(n31_O)
  );
  ShiftTN_2 n32 ( // @[Top.scala 146:21]
    .clock(n32_clock),
    .reset(n32_reset),
    .valid_up(n32_valid_up),
    .valid_down(n32_valid_down),
    .I(n32_I),
    .O(n32_O)
  );
  Map2T_2 n33 ( // @[Top.scala 149:21]
    .valid_up(n33_valid_up),
    .valid_down(n33_valid_down),
    .I0(n33_I0),
    .I1(n33_I1),
    .O_0(n33_O_0),
    .O_1(n33_O_1)
  );
  Map2T_5 n43 ( // @[Top.scala 153:21]
    .valid_up(n43_valid_up),
    .valid_down(n43_valid_down),
    .I0_0(n43_I0_0),
    .I0_1(n43_I0_1),
    .I1(n43_I1),
    .O_0(n43_O_0),
    .O_1(n43_O_1),
    .O_2(n43_O_2)
  );
  MapT_1 n57 ( // @[Top.scala 157:21]
    .clock(n57_clock),
    .reset(n57_reset),
    .valid_up(n57_valid_up),
    .valid_down(n57_valid_down),
    .I_0(n57_I_0),
    .I_1(n57_I_1),
    .I_2(n57_I_2),
    .O(n57_O)
  );
  Map2T_1 n58 ( // @[Top.scala 160:21]
    .valid_up(n58_valid_up),
    .valid_down(n58_valid_down),
    .I0(n58_I0),
    .I1(n58_I1),
    .O_0(n58_O_0),
    .O_1(n58_O_1)
  );
  ShiftTN_2 n65 ( // @[Top.scala 164:21]
    .clock(n65_clock),
    .reset(n65_reset),
    .valid_up(n65_valid_up),
    .valid_down(n65_valid_down),
    .I(n65_I),
    .O(n65_O)
  );
  ShiftTN_2 n66 ( // @[Top.scala 167:21]
    .clock(n66_clock),
    .reset(n66_reset),
    .valid_up(n66_valid_up),
    .valid_down(n66_valid_down),
    .I(n66_I),
    .O(n66_O)
  );
  Map2T_2 n67 ( // @[Top.scala 170:21]
    .valid_up(n67_valid_up),
    .valid_down(n67_valid_down),
    .I0(n67_I0),
    .I1(n67_I1),
    .O_0(n67_O_0),
    .O_1(n67_O_1)
  );
  Map2T_5 n77 ( // @[Top.scala 174:21]
    .valid_up(n77_valid_up),
    .valid_down(n77_valid_down),
    .I0_0(n77_I0_0),
    .I0_1(n77_I0_1),
    .I1(n77_I1),
    .O_0(n77_O_0),
    .O_1(n77_O_1),
    .O_2(n77_O_2)
  );
  MapT_1 n91 ( // @[Top.scala 178:21]
    .clock(n91_clock),
    .reset(n91_reset),
    .valid_up(n91_valid_up),
    .valid_down(n91_valid_down),
    .I_0(n91_I_0),
    .I_1(n91_I_1),
    .I_2(n91_I_2),
    .O(n91_O)
  );
  Map2T_4 n92 ( // @[Top.scala 181:21]
    .valid_up(n92_valid_up),
    .valid_down(n92_valid_down),
    .I0_0(n92_I0_0),
    .I0_1(n92_I0_1),
    .I1(n92_I1),
    .O_0(n92_O_0),
    .O_1(n92_O_1),
    .O_2(n92_O_2)
  );
  MapT_6 n101 ( // @[Top.scala 185:22]
    .clock(n101_clock),
    .reset(n101_reset),
    .valid_up(n101_valid_up),
    .valid_down(n101_valid_down),
    .I_0(n101_I_0),
    .I_1(n101_I_1),
    .I_2(n101_I_2),
    .O(n101_O)
  );
  MapT_12 n141 ( // @[Top.scala 188:22]
    .clock(n141_clock),
    .reset(n141_reset),
    .valid_up(n141_valid_up),
    .valid_down(n141_valid_down),
    .I(n141_I),
    .O(n141_O)
  );
  Passthrough n142 ( // @[Top.scala 191:22]
    .valid_up(n142_valid_up),
    .valid_down(n142_valid_down),
    .I(n142_I),
    .O(n142_O)
  );
  FIFO_1 n143 ( // @[Top.scala 194:22]
    .clock(n143_clock),
    .reset(n143_reset),
    .valid_up(n143_valid_up),
    .valid_down(n143_valid_down),
    .I(n143_I),
    .O(n143_O)
  );
  Map2T_28 n144 ( // @[Top.scala 197:22]
    .clock(n144_clock),
    .reset(n144_reset),
    .valid_up(n144_valid_up),
    .valid_down(n144_valid_down),
    .I0(n144_I0),
    .I1(n144_I1),
    .O(n144_O)
  );
  FIFO n177 ( // @[Top.scala 201:22]
    .clock(n177_clock),
    .reset(n177_reset),
    .valid_up(n177_valid_up),
    .valid_down(n177_valid_down),
    .I(n177_I),
    .O(n177_O)
  );
  FIFO n178 ( // @[Top.scala 204:22]
    .clock(n178_clock),
    .reset(n178_reset),
    .valid_up(n178_valid_up),
    .valid_down(n178_valid_down),
    .I(n178_I),
    .O(n178_O)
  );
  FIFO n179 ( // @[Top.scala 207:22]
    .clock(n179_clock),
    .reset(n179_reset),
    .valid_up(n179_valid_up),
    .valid_down(n179_valid_down),
    .I(n179_I),
    .O(n179_O)
  );
  assign valid_down = n179_valid_down; // @[Top.scala 211:16]
  assign O = n179_O; // @[Top.scala 210:7]
  assign n1_clock = clock;
  assign n1_reset = reset;
  assign n1_valid_up = valid_up; // @[Top.scala 119:17]
  assign n1_I = I; // @[Top.scala 118:10]
  assign n2_clock = clock;
  assign n2_reset = reset;
  assign n2_valid_up = n1_valid_down; // @[Top.scala 122:17]
  assign n2_I = n1_O; // @[Top.scala 121:10]
  assign n3_clock = clock;
  assign n3_reset = reset;
  assign n3_valid_up = n2_valid_down; // @[Top.scala 125:17]
  assign n3_I = n2_O; // @[Top.scala 124:10]
  assign n4_clock = clock;
  assign n4_reset = reset;
  assign n4_valid_up = n3_valid_down; // @[Top.scala 128:17]
  assign n4_I = n3_O; // @[Top.scala 127:10]
  assign n5_clock = clock;
  assign n5_reset = reset;
  assign n5_valid_up = n4_valid_down; // @[Top.scala 131:17]
  assign n5_I = n4_O; // @[Top.scala 130:10]
  assign n6_valid_up = n5_valid_down & n4_valid_down; // @[Top.scala 135:17]
  assign n6_I0 = n5_O; // @[Top.scala 133:11]
  assign n6_I1 = n4_O; // @[Top.scala 134:11]
  assign n16_valid_up = n6_valid_down & n3_valid_down; // @[Top.scala 139:18]
  assign n16_I0_0 = n6_O_0; // @[Top.scala 137:12]
  assign n16_I0_1 = n6_O_1; // @[Top.scala 137:12]
  assign n16_I1 = n3_O; // @[Top.scala 138:12]
  assign n30_clock = clock;
  assign n30_reset = reset;
  assign n30_valid_up = n16_valid_down; // @[Top.scala 142:18]
  assign n30_I_0 = n16_O_0; // @[Top.scala 141:11]
  assign n30_I_1 = n16_O_1; // @[Top.scala 141:11]
  assign n30_I_2 = n16_O_2; // @[Top.scala 141:11]
  assign n31_clock = clock;
  assign n31_reset = reset;
  assign n31_valid_up = n2_valid_down; // @[Top.scala 145:18]
  assign n31_I = n2_O; // @[Top.scala 144:11]
  assign n32_clock = clock;
  assign n32_reset = reset;
  assign n32_valid_up = n31_valid_down; // @[Top.scala 148:18]
  assign n32_I = n31_O; // @[Top.scala 147:11]
  assign n33_valid_up = n32_valid_down & n31_valid_down; // @[Top.scala 152:18]
  assign n33_I0 = n32_O; // @[Top.scala 150:12]
  assign n33_I1 = n31_O; // @[Top.scala 151:12]
  assign n43_valid_up = n33_valid_down & n2_valid_down; // @[Top.scala 156:18]
  assign n43_I0_0 = n33_O_0; // @[Top.scala 154:12]
  assign n43_I0_1 = n33_O_1; // @[Top.scala 154:12]
  assign n43_I1 = n2_O; // @[Top.scala 155:12]
  assign n57_clock = clock;
  assign n57_reset = reset;
  assign n57_valid_up = n43_valid_down; // @[Top.scala 159:18]
  assign n57_I_0 = n43_O_0; // @[Top.scala 158:11]
  assign n57_I_1 = n43_O_1; // @[Top.scala 158:11]
  assign n57_I_2 = n43_O_2; // @[Top.scala 158:11]
  assign n58_valid_up = n30_valid_down & n57_valid_down; // @[Top.scala 163:18]
  assign n58_I0 = n30_O; // @[Top.scala 161:12]
  assign n58_I1 = n57_O; // @[Top.scala 162:12]
  assign n65_clock = clock;
  assign n65_reset = reset;
  assign n65_valid_up = n1_valid_down; // @[Top.scala 166:18]
  assign n65_I = n1_O; // @[Top.scala 165:11]
  assign n66_clock = clock;
  assign n66_reset = reset;
  assign n66_valid_up = n65_valid_down; // @[Top.scala 169:18]
  assign n66_I = n65_O; // @[Top.scala 168:11]
  assign n67_valid_up = n66_valid_down & n65_valid_down; // @[Top.scala 173:18]
  assign n67_I0 = n66_O; // @[Top.scala 171:12]
  assign n67_I1 = n65_O; // @[Top.scala 172:12]
  assign n77_valid_up = n67_valid_down & n1_valid_down; // @[Top.scala 177:18]
  assign n77_I0_0 = n67_O_0; // @[Top.scala 175:12]
  assign n77_I0_1 = n67_O_1; // @[Top.scala 175:12]
  assign n77_I1 = n1_O; // @[Top.scala 176:12]
  assign n91_clock = clock;
  assign n91_reset = reset;
  assign n91_valid_up = n77_valid_down; // @[Top.scala 180:18]
  assign n91_I_0 = n77_O_0; // @[Top.scala 179:11]
  assign n91_I_1 = n77_O_1; // @[Top.scala 179:11]
  assign n91_I_2 = n77_O_2; // @[Top.scala 179:11]
  assign n92_valid_up = n58_valid_down & n91_valid_down; // @[Top.scala 184:18]
  assign n92_I0_0 = n58_O_0; // @[Top.scala 182:12]
  assign n92_I0_1 = n58_O_1; // @[Top.scala 182:12]
  assign n92_I1 = n91_O; // @[Top.scala 183:12]
  assign n101_clock = clock;
  assign n101_reset = reset;
  assign n101_valid_up = n92_valid_down; // @[Top.scala 187:19]
  assign n101_I_0 = n92_O_0; // @[Top.scala 186:12]
  assign n101_I_1 = n92_O_1; // @[Top.scala 186:12]
  assign n101_I_2 = n92_O_2; // @[Top.scala 186:12]
  assign n141_clock = clock;
  assign n141_reset = reset;
  assign n141_valid_up = n101_valid_down; // @[Top.scala 190:19]
  assign n141_I = n101_O; // @[Top.scala 189:12]
  assign n142_valid_up = n141_valid_down; // @[Top.scala 193:19]
  assign n142_I = n141_O; // @[Top.scala 192:12]
  assign n143_clock = clock;
  assign n143_reset = reset;
  assign n143_valid_up = n1_valid_down; // @[Top.scala 196:19]
  assign n143_I = n1_O; // @[Top.scala 195:12]
  assign n144_clock = clock;
  assign n144_reset = reset;
  assign n144_valid_up = n142_valid_down & n143_valid_down; // @[Top.scala 200:19]
  assign n144_I0 = n142_O; // @[Top.scala 198:13]
  assign n144_I1 = n143_O; // @[Top.scala 199:13]
  assign n177_clock = clock;
  assign n177_reset = reset;
  assign n177_valid_up = n144_valid_down; // @[Top.scala 203:19]
  assign n177_I = n144_O; // @[Top.scala 202:12]
  assign n178_clock = clock;
  assign n178_reset = reset;
  assign n178_valid_up = n177_valid_down; // @[Top.scala 206:19]
  assign n178_I = n177_O; // @[Top.scala 205:12]
  assign n179_clock = clock;
  assign n179_reset = reset;
  assign n179_valid_up = n178_valid_down; // @[Top.scala 209:19]
  assign n179_I = n178_O; // @[Top.scala 208:12]
endmodule
