module coreir_ugt #(parameter width = 1) (input [width-1:0] in0/*verilator public*/, input [width-1:0] in1/*verilator public*/, output out/*verilator public*/);
  assign out = in0 > in1;
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

module coreir_neg #(parameter width = 1) (input [width-1:0] in/*verilator public*/, output [width-1:0] out/*verilator public*/);
  assign out = -in;
endmodule

module coreir_mux #(parameter width = 1) (input [width-1:0] in0/*verilator public*/, input [width-1:0] in1/*verilator public*/, input sel/*verilator public*/, output [width-1:0] out/*verilator public*/);
  assign out = sel ? in1 : in0;
endmodule

module \commonlib_muxn__N2__width8 (input [7:0] in_data_0/*verilator public*/, input [7:0] in_data_1/*verilator public*/, input [0:0] in_sel/*verilator public*/, output [7:0] out/*verilator public*/);
wire [7:0] _join_out;
coreir_mux #(.width(8)) _join(.in0(in_data_0), .in1(in_data_1), .out(_join_out), .sel(in_sel[0]));
assign out = _join_out;
endmodule

module \aetherlinglib_hydrate__hydratedTypeBit8 (input [7:0] in/*verilator public*/, output [7:0] out/*verilator public*/);
assign out = {in[7],in[6],in[5],in[4],in[3],in[2],in[1],in[0]};
endmodule

module \aetherlinglib_hydrate__hydratedTypeBit (input [0:0] in/*verilator public*/, output out/*verilator public*/);
assign out = in[0];
endmodule

module \aetherlinglib_dehydrate__hydratedTypeBit8 (input [7:0] in/*verilator public*/, output [7:0] out/*verilator public*/);
assign out = {in[7],in[6],in[5],in[4],in[3],in[2],in[1],in[0]};
endmodule

module \aetherlinglib_dehydrate__hydratedTypeBit (input in/*verilator public*/, output [0:0] out/*verilator public*/);
assign out = in;
endmodule

module Negate8 (input [7:0] I/*verilator public*/, output [7:0] O/*verilator public*/);
wire [7:0] coreir_neg_inst0_out;
coreir_neg #(.width(8)) coreir_neg_inst0(.in(I), .out(coreir_neg_inst0_out));
assign O = coreir_neg_inst0_out;
endmodule

module NativeMapParallel_n2_opdehydrate_tArray_8_Bit__I_Array_8_In_Bit___out_Array_8_Out_Bit___ (input [7:0] I_0/*verilator public*/, input [7:0] I_1/*verilator public*/, output [7:0] out_0/*verilator public*/, output [7:0] out_1/*verilator public*/);
wire [7:0] dehydrate_tArray_8_Bit__inst0_out;
wire [7:0] dehydrate_tArray_8_Bit__inst1_out;
\aetherlinglib_dehydrate__hydratedTypeBit8 dehydrate_tArray_8_Bit__inst0(.in(I_0), .out(dehydrate_tArray_8_Bit__inst0_out));
\aetherlinglib_dehydrate__hydratedTypeBit8 dehydrate_tArray_8_Bit__inst1(.in(I_1), .out(dehydrate_tArray_8_Bit__inst1_out));
assign out_0 = dehydrate_tArray_8_Bit__inst0_out;
assign out_1 = dehydrate_tArray_8_Bit__inst1_out;
endmodule

module Mux_Array_8_Bit_t_2n (input [7:0] data_0/*verilator public*/, input [7:0] data_1/*verilator public*/, output [7:0] out/*verilator public*/, input [0:0] sel/*verilator public*/);
wire [7:0] CommonlibMuxN_n2_w8_inst0_out;
wire [7:0] NativeMapParallel_n2_opdehydrate_tArray_8_Bit__I_Array_8_In_Bit___out_Array_8_Out_Bit____inst0_out_0;
wire [7:0] NativeMapParallel_n2_opdehydrate_tArray_8_Bit__I_Array_8_In_Bit___out_Array_8_Out_Bit____inst0_out_1;
wire [7:0] hydrate_tArray_8_Bit__inst0_out;
\commonlib_muxn__N2__width8 CommonlibMuxN_n2_w8_inst0(.in_data_0(NativeMapParallel_n2_opdehydrate_tArray_8_Bit__I_Array_8_In_Bit___out_Array_8_Out_Bit____inst0_out_0), .in_data_1(NativeMapParallel_n2_opdehydrate_tArray_8_Bit__I_Array_8_In_Bit___out_Array_8_Out_Bit____inst0_out_1), .in_sel(sel), .out(CommonlibMuxN_n2_w8_inst0_out));
NativeMapParallel_n2_opdehydrate_tArray_8_Bit__I_Array_8_In_Bit___out_Array_8_Out_Bit___ NativeMapParallel_n2_opdehydrate_tArray_8_Bit__I_Array_8_In_Bit___out_Array_8_Out_Bit____inst0(.I_0(data_0), .I_1(data_1), .out_0(NativeMapParallel_n2_opdehydrate_tArray_8_Bit__I_Array_8_In_Bit___out_Array_8_Out_Bit____inst0_out_0), .out_1(NativeMapParallel_n2_opdehydrate_tArray_8_Bit__I_Array_8_In_Bit___out_Array_8_Out_Bit____inst0_out_1));
\aetherlinglib_hydrate__hydratedTypeBit8 hydrate_tArray_8_Bit__inst0(.in(CommonlibMuxN_n2_w8_inst0_out), .out(hydrate_tArray_8_Bit__inst0_out));
assign out = hydrate_tArray_8_Bit__inst0_out;
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

module FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue (input CLK/*verilator public*/, input [7:0] I/*verilator public*/, output [7:0] O/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0_O;
wire Register_Bitt_0init_FalseCE_FalseRESET_inst0_O;
Register_Array_8_Bit_t_0init_FalseCE_FalseRESET Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0(.CLK(CLK), .I(I), .O(Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0_O));
Register_Bitt_0init_FalseCE_FalseRESET Register_Bitt_0init_FalseCE_FalseRESET_inst0(.CLK(CLK), .I(valid_up), .O(Register_Bitt_0init_FalseCE_FalseRESET_inst0_O));
assign O = Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0_O;
assign valid_down = Register_Bitt_0init_FalseCE_FalseRESET_inst0_O;
endmodule

module Abs_Atom (input [7:0] I/*verilator public*/, output [7:0] O/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] Mux_Array_8_Bit_t_2n_inst0_out;
wire [7:0] Negate8_inst0_O;
wire coreir_ugt8_inst0_out;
Mux_Array_8_Bit_t_2n Mux_Array_8_Bit_t_2n_inst0(.data_0(I), .data_1(Negate8_inst0_O), .out(Mux_Array_8_Bit_t_2n_inst0_out), .sel(coreir_ugt8_inst0_out));
Negate8 Negate8_inst0(.I(I), .O(Negate8_inst0_O));
coreir_ugt #(.width(8)) coreir_ugt8_inst0(.in0(I), .in1(Negate8_inst0_O), .out(coreir_ugt8_inst0_out));
assign O = Mux_Array_8_Bit_t_2n_inst0_out;
assign valid_down = valid_up;
endmodule

module Map_T_n4_i0_opAbs_Atom_I_Array_8_In_Bit___O_Array_8_Out_Bit___valid_up_In_Bit__valid_down_Out_Bit__ (input CLK/*verilator public*/, input [7:0] I/*verilator public*/, output [7:0] O/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] Abs_Atom_inst0_O;
wire Abs_Atom_inst0_valid_down;
Abs_Atom Abs_Atom_inst0(.I(I), .O(Abs_Atom_inst0_O), .valid_down(Abs_Atom_inst0_valid_down), .valid_up(valid_up));
assign O = Abs_Atom_inst0_O;
assign valid_down = Abs_Atom_inst0_valid_down;
endmodule

module top (input CLK/*verilator public*/, output [7:0] O/*verilator public*/, input [7:0] hi/*verilator public*/, output valid_down/*verilator public*/, input valid_up/*verilator public*/);
wire [7:0] FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O;
wire FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down;
wire [7:0] FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O;
wire FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_valid_down;
wire [7:0] FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O;
wire FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_valid_down;
wire [7:0] FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O;
wire FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_valid_down;
wire [7:0] Map_T_n4_i0_opAbs_Atom_I_Array_8_In_Bit___O_Array_8_Out_Bit___valid_up_In_Bit__valid_down_Out_Bit___inst0_O;
wire Map_T_n4_i0_opAbs_Atom_I_Array_8_In_Bit___O_Array_8_Out_Bit___valid_up_In_Bit__valid_down_Out_Bit___inst0_valid_down;
FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0(.CLK(CLK), .I(hi), .O(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O), .valid_down(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down), .valid_up(valid_up));
FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1(.CLK(CLK), .I(Map_T_n4_i0_opAbs_Atom_I_Array_8_In_Bit___O_Array_8_Out_Bit___valid_up_In_Bit__valid_down_Out_Bit___inst0_O), .O(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O), .valid_down(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_valid_down), .valid_up(Map_T_n4_i0_opAbs_Atom_I_Array_8_In_Bit___O_Array_8_Out_Bit___valid_up_In_Bit__valid_down_Out_Bit___inst0_valid_down));
FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2(.CLK(CLK), .I(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O), .O(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O), .valid_down(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_valid_down), .valid_up(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_valid_down));
FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3(.CLK(CLK), .I(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O), .O(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O), .valid_down(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_valid_down), .valid_up(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_valid_down));
Map_T_n4_i0_opAbs_Atom_I_Array_8_In_Bit___O_Array_8_Out_Bit___valid_up_In_Bit__valid_down_Out_Bit__ Map_T_n4_i0_opAbs_Atom_I_Array_8_In_Bit___O_Array_8_Out_Bit___valid_up_In_Bit__valid_down_Out_Bit___inst0(.CLK(CLK), .I(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O), .O(Map_T_n4_i0_opAbs_Atom_I_Array_8_In_Bit___O_Array_8_Out_Bit___valid_up_In_Bit__valid_down_Out_Bit___inst0_O), .valid_down(Map_T_n4_i0_opAbs_Atom_I_Array_8_In_Bit___O_Array_8_Out_Bit___valid_up_In_Bit__valid_down_Out_Bit___inst0_valid_down), .valid_up(FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down));
assign O = FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O;
assign valid_down = FIFO_tTSeq_4_0_Int__delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_valid_down;
endmodule

