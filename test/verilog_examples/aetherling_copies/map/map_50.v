module corebit_and (input in0/*verilator public*/, input in1/*verilator public*/, output out/*verilator public*/);
  assign out = in0 & in1;
endmodule

module atomTupleCreator_t0Int_t1Int (input [7:0] I0/*verilator public*/, input [7:0] I1/*verilator public*/, output [7:0] O__0/*verilator public*/, output [7:0] O__1/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
assign O__0 = I0;
assign O__1 = I1;
assign valid_down = valid_up;
endmodule

module coreir_term #(parameter width = 1) (input [width-1:0] in/*verilator public*/);

endmodule

module coreir_reg #(parameter width = 1, parameter clk_posedge = 1, parameter init = 1) (input clk/*verilator public*/, input [width-1:0] in/*verilator public*/, output [width-1:0] out/*verilator public*/);
  reg [width-1:0] outReg/*verilator public*/=init;
  wire real_clk;
  assign real_clk = clk_posedge ? clk : ~clk;
  always @(posedge real_clk) begin
    outReg <= in;
  end
  assign out = outReg;
endmodule

module coreir_const #(parameter width = 1, parameter value = 1) (output [width-1:0] out/*verilator public*/);
  assign out = value;
endmodule

module coreir_add #(parameter width = 1) (input [width-1:0] in0/*verilator public*/, input [width-1:0] in1/*verilator public*/, output [width-1:0] out/*verilator public*/);
  assign out = in0 + in1;
endmodule

module lutN #(parameter N = 1, parameter init = 1) (input [N-1:0] in/*verilator public*/, output out/*verilator public*/);
  assign out = init[in];
endmodule

module \aetherlinglib_hydrate__hydratedTypeBit84 (input [31:0] in/*verilator public*/, output [7:0] out_0/*verilator public*/, output [7:0] out_1/*verilator public*/, output [7:0] out_2/*verilator public*/, output [7:0] out_3/*verilator public*/);
assign out_0 = {in[7],in[6],in[5],in[4],in[3],in[2],in[1],in[0]};
assign out_1 = {in[15],in[14],in[13],in[12],in[11],in[10],in[9],in[8]};
assign out_2 = {in[23],in[22],in[21],in[20],in[19],in[18],in[17],in[16]};
assign out_3 = {in[31],in[30],in[29],in[28],in[27],in[26],in[25],in[24]};
endmodule

module \aetherlinglib_hydrate__hydratedTypeBit8 (input [7:0] in/*verilator public*/, output [7:0] out/*verilator public*/);
assign out = {in[7],in[6],in[5],in[4],in[3],in[2],in[1],in[0]};
endmodule

module \aetherlinglib_hydrate__hydratedTypeBit (input [0:0] in/*verilator public*/, output out/*verilator public*/);
assign out = in[0];
endmodule

module \aetherlinglib_dehydrate__hydratedTypeBit84 (input [7:0] in_0/*verilator public*/, input [7:0] in_1/*verilator public*/, input [7:0] in_2/*verilator public*/, input [7:0] in_3/*verilator public*/, output [31:0] out/*verilator public*/);
assign out = {in_3[7],in_3[6],in_3[5],in_3[4],in_3[3],in_3[2],in_3[1],in_3[0],in_2[7],in_2[6],in_2[5],in_2[4],in_2[3],in_2[2],in_2[1],in_2[0],in_1[7],in_1[6],in_1[5],in_1[4],in_1[3],in_1[2],in_1[1],in_1[0],in_0[7],in_0[6],in_0[5],in_0[4],in_0[3],in_0[2],in_0[1],in_0[0]};
endmodule

module \aetherlinglib_dehydrate__hydratedTypeBit8 (input [7:0] in/*verilator public*/, output [7:0] out/*verilator public*/);
assign out = {in[7],in[6],in[5],in[4],in[3],in[2],in[1],in[0]};
endmodule

module \aetherlinglib_dehydrate__hydratedTypeBit (input in/*verilator public*/, output [0:0] out/*verilator public*/);
assign out = in;
endmodule

module Term_Bitt (input I/*verilator public*/);
wire [0:0] dehydrate_tBit_inst0_out;
\aetherlinglib_dehydrate__hydratedTypeBit dehydrate_tBit_inst0(.in(I), .out(dehydrate_tBit_inst0_out));
coreir_term #(.width(1)) term_w1_inst0(.in(dehydrate_tBit_inst0_out));
endmodule

module SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse (input CE/*verilator public*/, input CLK/*verilator public*/, output [0:0] O/*verilator public*/);
wire [0:0] const_0_1_out;
Term_Bitt Term_Bitt_inst0(.I(CE));
coreir_const #(.value(1'h0), .width(1)) const_0_1(.out(const_0_1_out));
assign O = const_0_1_out;
endmodule

module LUT1_1 (input I0/*verilator public*/, output O/*verilator public*/);
wire coreir_lut1_inst0_out;
lutN #(.init(2'h1), .N(1)) coreir_lut1_inst0(.in(I0), .out(coreir_lut1_inst0_out));
assign O = coreir_lut1_inst0_out;
endmodule

module LUT1_0 (input I0/*verilator public*/, output O/*verilator public*/);
wire coreir_lut1_inst0_out;
lutN #(.init(2'h0), .N(1)) coreir_lut1_inst0(.in(I0), .out(coreir_lut1_inst0_out));
assign O = coreir_lut1_inst0_out;
endmodule

module LUT_Array_8_Bit_t_1n (input CLK/*verilator public*/, input [0:0] addr/*verilator public*/, output [7:0] data/*verilator public*/);
wire LUT1_0_inst0_O;
wire LUT1_0_inst1_O;
wire LUT1_0_inst2_O;
wire LUT1_0_inst3_O;
wire LUT1_0_inst4_O;
wire LUT1_0_inst5_O;
wire LUT1_1_inst0_O;
wire LUT1_1_inst1_O;
wire [7:0] hydrate_tArray_8_Bit__inst0_out;
LUT1_0 LUT1_0_inst0(.I0(addr[0]), .O(LUT1_0_inst0_O));
LUT1_0 LUT1_0_inst1(.I0(addr[0]), .O(LUT1_0_inst1_O));
LUT1_0 LUT1_0_inst2(.I0(addr[0]), .O(LUT1_0_inst2_O));
LUT1_0 LUT1_0_inst3(.I0(addr[0]), .O(LUT1_0_inst3_O));
LUT1_0 LUT1_0_inst4(.I0(addr[0]), .O(LUT1_0_inst4_O));
LUT1_0 LUT1_0_inst5(.I0(addr[0]), .O(LUT1_0_inst5_O));
LUT1_1 LUT1_1_inst0(.I0(addr[0]), .O(LUT1_1_inst0_O));
LUT1_1 LUT1_1_inst1(.I0(addr[0]), .O(LUT1_1_inst1_O));
\aetherlinglib_hydrate__hydratedTypeBit8 hydrate_tArray_8_Bit__inst0(.in({LUT1_0_inst5_O,LUT1_0_inst4_O,LUT1_0_inst3_O,LUT1_0_inst2_O,LUT1_0_inst1_O,LUT1_1_inst1_O,LUT1_0_inst0_O,LUT1_1_inst0_O}), .out(hydrate_tArray_8_Bit__inst0_out));
assign data = hydrate_tArray_8_Bit__inst0_out;
endmodule

module DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse (input CLK/*verilator public*/, input I/*verilator public*/, output O/*verilator public*/);
wire [0:0] reg_P_inst0_out;
coreir_reg #(.clk_posedge(1), .init(1'h0), .width(1)) reg_P_inst0(.clk(CLK), .in(I), .out(reg_P_inst0_out));
assign O = reg_P_inst0_out[0];
endmodule

module Register8 (input CLK/*verilator public*/, input [7:0] I/*verilator public*/, output [7:0] O/*verilator public*/);
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst1_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst2_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst3_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst4_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst5_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst6_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst7_O;
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0(.CLK(CLK), .I(I[0]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst1(.CLK(CLK), .I(I[1]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst1_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst2(.CLK(CLK), .I(I[2]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst2_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst3(.CLK(CLK), .I(I[3]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst3_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst4(.CLK(CLK), .I(I[4]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst4_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst5(.CLK(CLK), .I(I[5]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst5_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst6(.CLK(CLK), .I(I[6]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst6_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst7(.CLK(CLK), .I(I[7]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst7_O));
assign O = {DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst7_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst6_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst5_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst4_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst3_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst2_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst1_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O};
endmodule

module Register_Array_8_Bit_t_0init_FalseCE_FalseRESET (input CLK/*verilator public*/, input [7:0] I/*verilator public*/, output [7:0] O/*verilator public*/);
wire [7:0] Register8_inst0_O;
wire [7:0] dehydrate_tArray_8_Bit__inst0_out;
wire [7:0] hydrate_tArray_8_Bit__inst0_out;
Register8 Register8_inst0(.CLK(CLK), .I(dehydrate_tArray_8_Bit__inst0_out), .O(Register8_inst0_O));
\aetherlinglib_dehydrate__hydratedTypeBit8 dehydrate_tArray_8_Bit__inst0(.in(I), .out(dehydrate_tArray_8_Bit__inst0_out));
\aetherlinglib_hydrate__hydratedTypeBit8 hydrate_tArray_8_Bit__inst0(.in(Register8_inst0_O), .out(hydrate_tArray_8_Bit__inst0_out));
assign O = hydrate_tArray_8_Bit__inst0_out;
endmodule

module Register32 (input CLK/*verilator public*/, input [31:0] I/*verilator public*/, output [31:0] O/*verilator public*/);
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst1_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst10_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst11_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst12_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst13_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst14_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst15_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst16_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst17_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst18_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst19_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst2_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst20_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst21_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst22_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst23_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst24_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst25_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst26_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst27_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst28_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst29_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst3_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst30_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst31_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst4_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst5_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst6_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst7_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst8_O;
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst9_O;
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0(.CLK(CLK), .I(I[0]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst1(.CLK(CLK), .I(I[1]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst1_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst10(.CLK(CLK), .I(I[10]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst10_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst11(.CLK(CLK), .I(I[11]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst11_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst12(.CLK(CLK), .I(I[12]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst12_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst13(.CLK(CLK), .I(I[13]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst13_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst14(.CLK(CLK), .I(I[14]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst14_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst15(.CLK(CLK), .I(I[15]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst15_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst16(.CLK(CLK), .I(I[16]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst16_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst17(.CLK(CLK), .I(I[17]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst17_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst18(.CLK(CLK), .I(I[18]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst18_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst19(.CLK(CLK), .I(I[19]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst19_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst2(.CLK(CLK), .I(I[2]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst2_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst20(.CLK(CLK), .I(I[20]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst20_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst21(.CLK(CLK), .I(I[21]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst21_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst22(.CLK(CLK), .I(I[22]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst22_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst23(.CLK(CLK), .I(I[23]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst23_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst24(.CLK(CLK), .I(I[24]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst24_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst25(.CLK(CLK), .I(I[25]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst25_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst26(.CLK(CLK), .I(I[26]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst26_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst27(.CLK(CLK), .I(I[27]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst27_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst28(.CLK(CLK), .I(I[28]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst28_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst29(.CLK(CLK), .I(I[29]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst29_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst3(.CLK(CLK), .I(I[3]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst3_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst30(.CLK(CLK), .I(I[30]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst30_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst31(.CLK(CLK), .I(I[31]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst31_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst4(.CLK(CLK), .I(I[4]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst4_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst5(.CLK(CLK), .I(I[5]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst5_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst6(.CLK(CLK), .I(I[6]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst6_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst7(.CLK(CLK), .I(I[7]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst7_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst8(.CLK(CLK), .I(I[8]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst8_O));
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst9(.CLK(CLK), .I(I[9]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst9_O));
assign O = {DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst31_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst30_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst29_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst28_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst27_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst26_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst25_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst24_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst23_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst22_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst21_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst20_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst19_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst18_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst17_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst16_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst15_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst14_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst13_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst12_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst11_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst10_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst9_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst8_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst7_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst6_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst5_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst4_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst3_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst2_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst1_O,DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O};
endmodule

module Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET (input CLK/*verilator public*/, input [7:0] I_0/*verilator public*/, input [7:0] I_1/*verilator public*/, input [7:0] I_2/*verilator public*/, input [7:0] I_3/*verilator public*/, output [7:0] O_0/*verilator public*/, output [7:0] O_1/*verilator public*/, output [7:0] O_2/*verilator public*/, output [7:0] O_3/*verilator public*/);
wire [31:0] Register32_inst0_O;
wire [31:0] dehydrate_tArray_4_Array_8_Bit___inst0_out;
wire [7:0] hydrate_tArray_4_Array_8_Bit___inst0_out_0;
wire [7:0] hydrate_tArray_4_Array_8_Bit___inst0_out_1;
wire [7:0] hydrate_tArray_4_Array_8_Bit___inst0_out_2;
wire [7:0] hydrate_tArray_4_Array_8_Bit___inst0_out_3;
Register32 Register32_inst0(.CLK(CLK), .I(dehydrate_tArray_4_Array_8_Bit___inst0_out), .O(Register32_inst0_O));
\aetherlinglib_dehydrate__hydratedTypeBit84 dehydrate_tArray_4_Array_8_Bit___inst0(.in_0(I_0), .in_1(I_1), .in_2(I_2), .in_3(I_3), .out(dehydrate_tArray_4_Array_8_Bit___inst0_out));
\aetherlinglib_hydrate__hydratedTypeBit84 hydrate_tArray_4_Array_8_Bit___inst0(.in(Register32_inst0_O), .out_0(hydrate_tArray_4_Array_8_Bit___inst0_out_0), .out_1(hydrate_tArray_4_Array_8_Bit___inst0_out_1), .out_2(hydrate_tArray_4_Array_8_Bit___inst0_out_2), .out_3(hydrate_tArray_4_Array_8_Bit___inst0_out_3));
assign O_0 = hydrate_tArray_4_Array_8_Bit___inst0_out_0;
assign O_1 = hydrate_tArray_4_Array_8_Bit___inst0_out_1;
assign O_2 = hydrate_tArray_4_Array_8_Bit___inst0_out_2;
assign O_3 = hydrate_tArray_4_Array_8_Bit___inst0_out_3;
endmodule

module Register1 (input CLK/*verilator public*/, input [0:0] I/*verilator public*/, output [0:0] O/*verilator public*/);
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O;
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0(.CLK(CLK), .I(I[0]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O));
assign O = DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O;
endmodule

module Register_Bitt_0init_FalseCE_FalseRESET (input CLK/*verilator public*/, input I/*verilator public*/, output O/*verilator public*/);
wire [0:0] Register1_inst0_O;
wire [0:0] dehydrate_tBit_inst0_out;
wire hydrate_tBit_inst0_out;
Register1 Register1_inst0(.CLK(CLK), .I(dehydrate_tBit_inst0_out), .O(Register1_inst0_O));
\aetherlinglib_dehydrate__hydratedTypeBit dehydrate_tBit_inst0(.in(I), .out(dehydrate_tBit_inst0_out));
\aetherlinglib_hydrate__hydratedTypeBit hydrate_tBit_inst0(.in(Register1_inst0_O), .out(hydrate_tBit_inst0_out));
assign O = hydrate_tBit_inst0_out;
endmodule

module FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue (input CLK/*verilator public*/, input [7:0] I_0/*verilator public*/, input [7:0] I_1/*verilator public*/, input [7:0] I_2/*verilator public*/, input [7:0] I_3/*verilator public*/, output [7:0] O_0/*verilator public*/, output [7:0] O_1/*verilator public*/, output [7:0] O_2/*verilator public*/, output [7:0] O_3/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_0;
wire [7:0] Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_1;
wire [7:0] Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_2;
wire [7:0] Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_3;
wire Register_Bitt_0init_FalseCE_FalseRESET_inst0_O;
Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0(.CLK(CLK), .I_0(I_0), .I_1(I_1), .I_2(I_2), .I_3(I_3), .O_0(Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_0), .O_1(Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_1), .O_2(Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_2), .O_3(Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_3));
Register_Bitt_0init_FalseCE_FalseRESET Register_Bitt_0init_FalseCE_FalseRESET_inst0(.CLK(CLK), .I(valid_up), .O(Register_Bitt_0init_FalseCE_FalseRESET_inst0_O));
assign O_0 = Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_0;
assign O_1 = Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_1;
assign O_2 = Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_2;
assign O_3 = Register_Array_4_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_3;
assign valid_down = Register_Bitt_0init_FalseCE_FalseRESET_inst0_O;
endmodule

module FIFO_tInt_delay1_hasCEFalse_hasResetFalse_hasValidTrue (input CLK/*verilator public*/, input [7:0] I/*verilator public*/, output [7:0] O/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0_O;
wire Register_Bitt_0init_FalseCE_FalseRESET_inst0_O;
Register_Array_8_Bit_t_0init_FalseCE_FalseRESET Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0(.CLK(CLK), .I(I), .O(Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0_O));
Register_Bitt_0init_FalseCE_FalseRESET Register_Bitt_0init_FalseCE_FalseRESET_inst0(.CLK(CLK), .I(valid_up), .O(Register_Bitt_0init_FalseCE_FalseRESET_inst0_O));
assign O = Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0_O;
assign valid_down = Register_Bitt_0init_FalseCE_FalseRESET_inst0_O;
endmodule

module Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue (input CLK/*verilator public*/, output [7:0] O/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] LUT_Array_8_Bit_t_1n_inst0_data;
wire [0:0] SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse_inst0_O;
wire [0:0] coreir_const11_inst0_out;
LUT_Array_8_Bit_t_1n LUT_Array_8_Bit_t_1n_inst0(.CLK(CLK), .addr(SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse_inst0_O), .data(LUT_Array_8_Bit_t_1n_inst0_data));
SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse_inst0(.CE(coreir_const11_inst0_out[0]), .CLK(CLK), .O(SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse_inst0_O));
Term_Bitt Term_Bitt_inst0(.I(valid_up));
coreir_const #(.value(1'h1), .width(1)) coreir_const11_inst0(.out(coreir_const11_inst0_out));
assign O = LUT_Array_8_Bit_t_1n_inst0_data;
assign valid_down = coreir_const11_inst0_out[0];
endmodule

module Add_Atom (input [7:0] I__0/*verilator public*/, input [7:0] I__1/*verilator public*/, output [7:0] O/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] coreir_add8_inst0_out;
coreir_add #(.width(8)) coreir_add8_inst0(.in0(I__0), .in1(I__1), .out(coreir_add8_inst0_out));
assign O = coreir_add8_inst0_out;
assign valid_down = valid_up;
endmodule

module Module_0 (input CLK/*verilator public*/, input [7:0] I/*verilator public*/, output [7:0] O/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] Add_Atom_inst0_O;
wire Add_Atom_inst0_valid_down;
wire [7:0] Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O;
wire Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down;
wire [7:0] FIFO_tInt_delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O;
wire FIFO_tInt_delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down;
wire and_inst0_out;
wire [7:0] atomTupleCreator_t0Int_t1Int_inst0_O__0;
wire [7:0] atomTupleCreator_t0Int_t1Int_inst0_O__1;
wire atomTupleCreator_t0Int_t1Int_inst0_valid_down;
Add_Atom Add_Atom_inst0(.I__0(atomTupleCreator_t0Int_t1Int_inst0_O__0), .I__1(atomTupleCreator_t0Int_t1Int_inst0_O__1), .O(Add_Atom_inst0_O), .valid_down(Add_Atom_inst0_valid_down), .valid_up(atomTupleCreator_t0Int_t1Int_inst0_valid_down));
Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0(.CLK(CLK), .O(Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O), .valid_down(Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down), .valid_up(valid_up));
FIFO_tInt_delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tInt_delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0(.CLK(CLK), .I(Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O), .O(FIFO_tInt_delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O), .valid_down(FIFO_tInt_delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down), .valid_up(Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down));
corebit_and and_inst0(.in0(valid_up), .in1(FIFO_tInt_delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down), .out(and_inst0_out));
atomTupleCreator_t0Int_t1Int atomTupleCreator_t0Int_t1Int_inst0(.I0(I), .I1(FIFO_tInt_delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O), .O__0(atomTupleCreator_t0Int_t1Int_inst0_O__0), .O__1(atomTupleCreator_t0Int_t1Int_inst0_O__1), .valid_down(atomTupleCreator_t0Int_t1Int_inst0_valid_down), .valid_up(and_inst0_out));
assign O = Add_Atom_inst0_O;
assign valid_down = Add_Atom_inst0_valid_down;
endmodule

module NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit__ (input CLK/*verilator public*/, input [7:0] I_0/*verilator public*/, input [7:0] I_1/*verilator public*/, input [7:0] I_2/*verilator public*/, input [7:0] I_3/*verilator public*/, output [7:0] O_0/*verilator public*/, output [7:0] O_1/*verilator public*/, output [7:0] O_2/*verilator public*/, output [7:0] O_3/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] Module_0_inst0_O;
wire Module_0_inst0_valid_down;
wire [7:0] Module_0_inst1_O;
wire Module_0_inst1_valid_down;
wire [7:0] Module_0_inst2_O;
wire Module_0_inst2_valid_down;
wire [7:0] Module_0_inst3_O;
wire Module_0_inst3_valid_down;
wire and_inst0_out;
wire and_inst1_out;
wire and_inst2_out;
Module_0 Module_0_inst0(.CLK(CLK), .I(I_0), .O(Module_0_inst0_O), .valid_down(Module_0_inst0_valid_down), .valid_up(valid_up));
Module_0 Module_0_inst1(.CLK(CLK), .I(I_1), .O(Module_0_inst1_O), .valid_down(Module_0_inst1_valid_down), .valid_up(valid_up));
Module_0 Module_0_inst2(.CLK(CLK), .I(I_2), .O(Module_0_inst2_O), .valid_down(Module_0_inst2_valid_down), .valid_up(valid_up));
Module_0 Module_0_inst3(.CLK(CLK), .I(I_3), .O(Module_0_inst3_O), .valid_down(Module_0_inst3_valid_down), .valid_up(valid_up));
corebit_and and_inst0(.in0(Module_0_inst0_valid_down), .in1(Module_0_inst1_valid_down), .out(and_inst0_out));
corebit_and and_inst1(.in0(and_inst0_out), .in1(Module_0_inst2_valid_down), .out(and_inst1_out));
corebit_and and_inst2(.in0(and_inst1_out), .in1(Module_0_inst3_valid_down), .out(and_inst2_out));
assign O_0 = Module_0_inst0_O;
assign O_1 = Module_0_inst1_O;
assign O_2 = Module_0_inst2_O;
assign O_3 = Module_0_inst3_O;
assign valid_down = and_inst2_out;
endmodule

module Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit__ (input CLK/*verilator public*/, input [7:0] I_0/*verilator public*/, input [7:0] I_1/*verilator public*/, input [7:0] I_2/*verilator public*/, input [7:0] I_3/*verilator public*/, output [7:0] O_0/*verilator public*/, output [7:0] O_1/*verilator public*/, output [7:0] O_2/*verilator public*/, output [7:0] O_3/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_0;
wire [7:0] NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_1;
wire [7:0] NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_2;
wire [7:0] NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_3;
wire NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_valid_down;
NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit__ NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0(.CLK(CLK), .I_0(I_0), .I_1(I_1), .I_2(I_2), .I_3(I_3), .O_0(NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_0), .O_1(NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_1), .O_2(NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_2), .O_3(NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_3), .valid_down(NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_valid_down), .valid_up(valid_up));
assign O_0 = NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_0;
assign O_1 = NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_1;
assign O_2 = NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_2;
assign O_3 = NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_3;
assign valid_down = NativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_valid_down;
endmodule

module top (input CLK/*verilator public*/, output [7:0] O_0/*verilator public*/, output [7:0] O_1/*verilator public*/, output [7:0] O_2/*verilator public*/, output [7:0] O_3/*verilator public*/, input [7:0] hi_0/*verilator public*/, input [7:0] hi_1/*verilator public*/, input [7:0] hi_2/*verilator public*/, input [7:0] hi_3/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_0;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_1;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_2;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_3;
wire FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_0;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_1;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_2;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_3;
wire FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_valid_down;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_0;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_1;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_2;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_3;
wire FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_valid_down;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_0;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_1;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_2;
wire [7:0] FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_3;
wire FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_valid_down;
wire [7:0] Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_0;
wire [7:0] Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_1;
wire [7:0] Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_2;
wire [7:0] Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_3;
wire Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_valid_down;
FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0(.CLK(CLK), .I_0(hi_0), .I_1(hi_1), .I_2(hi_2), .I_3(hi_3), .O_0(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_0), .O_1(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_1), .O_2(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_2), .O_3(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_3), .valid_down(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down), .valid_up(valid_up));
FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1(.CLK(CLK), .I_0(Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_0), .I_1(Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_1), .I_2(Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_2), .I_3(Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_3), .O_0(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_0), .O_1(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_1), .O_2(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_2), .O_3(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_3), .valid_down(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_valid_down), .valid_up(Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_valid_down));
FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2(.CLK(CLK), .I_0(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_0), .I_1(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_1), .I_2(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_2), .I_3(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_3), .O_0(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_0), .O_1(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_1), .O_2(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_2), .O_3(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_3), .valid_down(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_valid_down), .valid_up(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_valid_down));
FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3(.CLK(CLK), .I_0(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_0), .I_1(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_1), .I_2(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_2), .I_3(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_3), .O_0(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_0), .O_1(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_1), .O_2(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_2), .O_3(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_3), .valid_down(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_valid_down), .valid_up(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_valid_down));
Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit__ Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0(.CLK(CLK), .I_0(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_0), .I_1(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_1), .I_2(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_2), .I_3(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_3), .O_0(Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_0), .O_1(Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_1), .O_2(Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_2), .O_3(Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_O_3), .valid_down(Map_T_n50_i0_opNativeMapParallel_n4_opModule_0_I_Array_8_In_Bit___O_Array_8_Out_Bit___CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___I_Array_4_Array_8_In_Bit____O_Array_4_Array_8_Out_Bit____CLK_In_Clock__valid_up_In_Bit__valid_down_Out_Bit___inst0_valid_down), .valid_up(FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down));
assign O_0 = FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_0;
assign O_1 = FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_1;
assign O_2 = FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_2;
assign O_3 = FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_3;
assign valid_down = FIFO_tTSeq_50_0_SSeq_4_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_valid_down;
endmodule

