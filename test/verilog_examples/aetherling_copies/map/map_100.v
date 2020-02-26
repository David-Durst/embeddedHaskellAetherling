module corebit_and (input in0, input in1, output out);
  assign out = in0 & in1;
endmodule

module atomTupleCreator_t0Int_t1Int (input [7:0] I0, input [7:0] I1, output [7:0] O__0, output [7:0] O__1, output valid_down, input valid_up);
assign O__0 = I0;
assign O__1 = I1;
assign valid_down = valid_up;
endmodule

module coreir_ult #(parameter width = 1) (input [width-1:0] in0, input [width-1:0] in1, output out);
  assign out = in0 < in1;
endmodule

module coreir_term #(parameter width = 1) (input [width-1:0] in);

endmodule

module coreir_reg #(parameter width = 1, parameter clk_posedge = 1, parameter init = 1) (input clk, input [width-1:0] in, output [width-1:0] out);
  reg [width-1:0] outReg=init;
  wire real_clk;
  assign real_clk = clk_posedge ? clk : ~clk;
  always @(posedge real_clk) begin
    outReg <= in;
  end
  assign out = outReg;
endmodule

module coreir_mux #(parameter width = 1) (input [width-1:0] in0, input [width-1:0] in1, input sel, output [width-1:0] out);
  assign out = sel ? in1 : in0;
endmodule

module coreir_eq #(parameter width = 1) (input [width-1:0] in0, input [width-1:0] in1, output out);
  assign out = in0 == in1;
endmodule

module coreir_const #(parameter width = 1, parameter value = 1) (output [width-1:0] out);
  assign out = value;
endmodule

module coreir_add #(parameter width = 1) (input [width-1:0] in0, input [width-1:0] in1, output [width-1:0] out);
  assign out = in0 + in1;
endmodule

module \commonlib_muxn__N2__width1 (input [0:0] in_data_0, input [0:0] in_data_1, input [0:0] in_sel, output [0:0] out);
wire [0:0] _join_out;
coreir_mux #(.width(1)) _join(.in0(in_data_0), .in1(in_data_1), .out(_join_out), .sel(in_sel[0]));
assign out = _join_out;
endmodule

module lutN #(parameter N = 1, parameter init = 1) (input [N-1:0] in, output out);
  assign out = init[in];
endmodule

module \aetherlinglib_hydrate__hydratedTypeBit8 (input [7:0] in, output [7:0] out);
assign out = {in[7],in[6],in[5],in[4],in[3],in[2],in[1],in[0]};
endmodule

module \aetherlinglib_dehydrate__hydratedTypeBit (input in, output [0:0] out);
assign out = in;
endmodule

module Term_Bitt (input I);
wire [0:0] dehydrate_tBit_inst0_out;
\aetherlinglib_dehydrate__hydratedTypeBit dehydrate_tBit_inst0(.in(I), .out(dehydrate_tBit_inst0_out));
coreir_term #(.width(1)) term_w1_inst0(.in(dehydrate_tBit_inst0_out));
endmodule

module SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse (input CE, input CLK, output [0:0] O);
wire [0:0] const_0_1_out;
Term_Bitt Term_Bitt_inst0(.I(CE));
coreir_const #(.value(1'h0), .width(1)) const_0_1(.out(const_0_1_out));
assign O = const_0_1_out;
endmodule

module Mux2xOutBits1 (input [0:0] I0, input [0:0] I1, output [0:0] O, input S);
wire [0:0] coreir_commonlib_mux2x1_inst0_out;
\commonlib_muxn__N2__width1 coreir_commonlib_mux2x1_inst0(.in_data_0(I0), .in_data_1(I1), .in_sel(S), .out(coreir_commonlib_mux2x1_inst0_out));
assign O = coreir_commonlib_mux2x1_inst0_out;
endmodule

module Register_has_ce_True_has_reset_True_has_async_reset_False_type_Bits_n_1 (input CE, input CLK, input [0:0] I, output [0:0] O, input RESET);
wire [0:0] Mux2xOutBits1_inst0_O;
wire [0:0] const_0_1_out;
wire [0:0] enable_mux_O;
wire [0:0] value_out;
Mux2xOutBits1 Mux2xOutBits1_inst0(.I0(enable_mux_O), .I1(const_0_1_out), .O(Mux2xOutBits1_inst0_O), .S(RESET));
coreir_const #(.value(1'h0), .width(1)) const_0_1(.out(const_0_1_out));
Mux2xOutBits1 enable_mux(.I0(value_out), .I1(I), .O(enable_mux_O), .S(CE));
coreir_reg #(.clk_posedge(1), .init(1'h0), .width(1)) value(.clk(CLK), .in(Mux2xOutBits1_inst0_O), .out(value_out));
assign O = value_out;
endmodule

module LUT1_2 (input I0, output O);
wire coreir_lut1_inst0_out;
lutN #(.init(2'h2), .N(1)) coreir_lut1_inst0(.in(I0), .out(coreir_lut1_inst0_out));
assign O = coreir_lut1_inst0_out;
endmodule

module LUT1_1 (input I0, output O);
wire coreir_lut1_inst0_out;
lutN #(.init(2'h1), .N(1)) coreir_lut1_inst0(.in(I0), .out(coreir_lut1_inst0_out));
assign O = coreir_lut1_inst0_out;
endmodule

module LUT1_0 (input I0, output O);
wire coreir_lut1_inst0_out;
lutN #(.init(2'h0), .N(1)) coreir_lut1_inst0(.in(I0), .out(coreir_lut1_inst0_out));
assign O = coreir_lut1_inst0_out;
endmodule

module LUT_Array_8_Bit_t_1n (input CLK, input [0:0] addr, output [7:0] data);
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

module DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse (input CLK, input I, output O);
wire [0:0] reg_P_inst0_out;
coreir_reg #(.clk_posedge(1), .init(1'h0), .width(1)) reg_P_inst0(.clk(CLK), .in(I), .out(reg_P_inst0_out));
assign O = reg_P_inst0_out[0];
endmodule

module Register8 (input CLK, input [7:0] I, output [7:0] O);
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

module Register_Array_8_Bit_t_0init_FalseCE_FalseRESET (input CLK, input [7:0] I, output [7:0] O);
wire [7:0] Register8_inst0_O;
Register8 Register8_inst0(.CLK(CLK), .I(I), .O(Register8_inst0_O));
assign O = Register8_inst0_O;
endmodule

module Register_Array_2_Array_8_Bit__t_0init_FalseCE_FalseRESET (input CLK, input [7:0] I_0, input [7:0] I_1, output [7:0] O_0, output [7:0] O_1);
wire [7:0] Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0_O;
wire [7:0] Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst1_O;
Register_Array_8_Bit_t_0init_FalseCE_FalseRESET Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0(.CLK(CLK), .I(I_0), .O(Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0_O));
Register_Array_8_Bit_t_0init_FalseCE_FalseRESET Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst1(.CLK(CLK), .I(I_1), .O(Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst1_O));
assign O_0 = Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst0_O;
assign O_1 = Register_Array_8_Bit_t_0init_FalseCE_FalseRESET_inst1_O;
endmodule

module Register1 (input CLK, input [0:0] I, output [0:0] O);
wire DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O;
DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0(.CLK(CLK), .I(I[0]), .O(DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O));
assign O = DFF_init0_has_ceFalse_has_resetFalse_has_async_resetFalse_inst0_O;
endmodule

module Register_Bitt_0init_FalseCE_FalseRESET (input CLK, input I, output O);
wire [0:0] Register1_inst0_O;
Register1 Register1_inst0(.CLK(CLK), .I(I), .O(Register1_inst0_O));
assign O = Register1_inst0_O[0];
endmodule

module FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue (input CLK, input [7:0] I_0, input [7:0] I_1, output [7:0] O_0, output [7:0] O_1, output valid_down, input valid_up);
wire [7:0] Register_Array_2_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_0;
wire [7:0] Register_Array_2_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_1;
wire Register_Bitt_0init_FalseCE_FalseRESET_inst0_O;
Register_Array_2_Array_8_Bit__t_0init_FalseCE_FalseRESET Register_Array_2_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0(.CLK(CLK), .I_0(I_0), .I_1(I_1), .O_0(Register_Array_2_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_0), .O_1(Register_Array_2_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_1));
Register_Bitt_0init_FalseCE_FalseRESET Register_Bitt_0init_FalseCE_FalseRESET_inst0(.CLK(CLK), .I(valid_up), .O(Register_Bitt_0init_FalseCE_FalseRESET_inst0_O));
assign O_0 = Register_Array_2_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_0;
assign O_1 = Register_Array_2_Array_8_Bit__t_0init_FalseCE_FalseRESET_inst0_O_1;
assign valid_down = Register_Bitt_0init_FalseCE_FalseRESET_inst0_O;
endmodule

module Counter1CER (input CE, input CLK, output [0:0] O, input RESET);
wire [0:0] Register_has_ce_True_has_reset_True_has_async_reset_False_type_Bits_n_1_inst0_O;
wire [0:0] const_1_1_out;
wire [0:0] coreir_add1_inst0_out;
Register_has_ce_True_has_reset_True_has_async_reset_False_type_Bits_n_1 Register_has_ce_True_has_reset_True_has_async_reset_False_type_Bits_n_1_inst0(.CE(CE), .CLK(CLK), .I(coreir_add1_inst0_out), .O(Register_has_ce_True_has_reset_True_has_async_reset_False_type_Bits_n_1_inst0_O), .RESET(RESET));
coreir_const #(.value(1'h1), .width(1)) const_1_1(.out(const_1_1_out));
coreir_add #(.width(1)) coreir_add1_inst0(.in0(Register_has_ce_True_has_reset_True_has_async_reset_False_type_Bits_n_1_inst0_O), .in1(const_1_1_out), .out(coreir_add1_inst0_out));
assign O = Register_has_ce_True_has_reset_True_has_async_reset_False_type_Bits_n_1_inst0_O;
endmodule

module Counter1_Mod2CE (input CE, input CLK, output [0:0] O);
wire [0:0] Counter1CER_inst0_O;
wire LUT1_2_inst0_O;
wire and_inst0_out;
Counter1CER Counter1CER_inst0(.CE(CE), .CLK(CLK), .O(Counter1CER_inst0_O), .RESET(and_inst0_out));
LUT1_2 LUT1_2_inst0(.I0(Counter1CER_inst0_O[0]), .O(LUT1_2_inst0_O));
corebit_and and_inst0(.in0(LUT1_2_inst0_O), .in1(CE), .out(and_inst0_out));
assign O = Counter1CER_inst0_O;
endmodule

module InitialDelayCounter_1 (input CE, input CLK, output valid);
wire [0:0] Counter1_Mod2CE_inst0_O;
wire and_inst0_out;
wire [0:0] coreir_const11_inst0_out;
wire coreir_eq_1_inst0_out;
wire coreir_ult1_inst0_out;
Counter1_Mod2CE Counter1_Mod2CE_inst0(.CE(and_inst0_out), .CLK(CLK), .O(Counter1_Mod2CE_inst0_O));
corebit_and and_inst0(.in0(CE), .in1(coreir_ult1_inst0_out), .out(and_inst0_out));
coreir_const #(.value(1'h1), .width(1)) coreir_const11_inst0(.out(coreir_const11_inst0_out));
coreir_eq #(.width(1)) coreir_eq_1_inst0(.in0(Counter1_Mod2CE_inst0_O), .in1(coreir_const11_inst0_out), .out(coreir_eq_1_inst0_out));
coreir_ult #(.width(1)) coreir_ult1_inst0(.in0(Counter1_Mod2CE_inst0_O), .in1(coreir_const11_inst0_out), .out(coreir_ult1_inst0_out));
assign valid = coreir_eq_1_inst0_out;
endmodule

module Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue (input CLK, output [7:0] O, output valid_down, input valid_up);
wire InitialDelayCounter_1_inst0_valid;
wire [7:0] LUT_Array_8_Bit_t_1n_inst0_data;
wire [0:0] SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse_inst0_O;
wire [0:0] coreir_const11_inst0_out;
InitialDelayCounter_1 InitialDelayCounter_1_inst0(.CE(coreir_const11_inst0_out[0]), .CLK(CLK), .valid(InitialDelayCounter_1_inst0_valid));
LUT_Array_8_Bit_t_1n LUT_Array_8_Bit_t_1n_inst0(.CLK(CLK), .addr(SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse_inst0_O), .data(LUT_Array_8_Bit_t_1n_inst0_data));
SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse_inst0(.CE(InitialDelayCounter_1_inst0_valid), .CLK(CLK), .O(SizedCounter_1_cinFalse_coutFalse_incr1_hasCETrue_hasResetFalse_inst0_O));
Term_Bitt Term_Bitt_inst0(.I(valid_up));
coreir_const #(.value(1'h1), .width(1)) coreir_const11_inst0(.out(coreir_const11_inst0_out));
assign O = LUT_Array_8_Bit_t_1n_inst0_data;
assign valid_down = InitialDelayCounter_1_inst0_valid;
endmodule

module Add_Atom (input [7:0] I__0, input [7:0] I__1, output [7:0] O, output valid_down, input valid_up);
wire [7:0] coreir_add8_inst0_out;
coreir_add #(.width(8)) coreir_add8_inst0(.in0(I__0), .in1(I__1), .out(coreir_add8_inst0_out));
assign O = coreir_add8_inst0_out;
assign valid_down = valid_up;
endmodule

module Module_0 (input CLK, input [7:0] I, output [7:0] O, output valid_down, input valid_up);
wire [7:0] Add_Atom_inst0_O;
wire Add_Atom_inst0_valid_down;
wire [7:0] Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O;
wire Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down;
wire and_inst0_out;
wire [7:0] atomTupleCreator_t0Int_t1Int_inst0_O__0;
wire [7:0] atomTupleCreator_t0Int_t1Int_inst0_O__1;
wire atomTupleCreator_t0Int_t1Int_inst0_valid_down;
Add_Atom Add_Atom_inst0(.I__0(atomTupleCreator_t0Int_t1Int_inst0_O__0), .I__1(atomTupleCreator_t0Int_t1Int_inst0_O__1), .O(Add_Atom_inst0_O), .valid_down(Add_Atom_inst0_valid_down), .valid_up(atomTupleCreator_t0Int_t1Int_inst0_valid_down));
Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0(.CLK(CLK), .O(Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O), .valid_down(Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down), .valid_up(valid_up));
corebit_and and_inst0(.in0(valid_up), .in1(Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down), .out(and_inst0_out));
atomTupleCreator_t0Int_t1Int atomTupleCreator_t0Int_t1Int_inst0(.I0(I), .I1(Const_tInt_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O), .O__0(atomTupleCreator_t0Int_t1Int_inst0_O__0), .O__1(atomTupleCreator_t0Int_t1Int_inst0_O__1), .valid_down(atomTupleCreator_t0Int_t1Int_inst0_valid_down), .valid_up(and_inst0_out));
assign O = Add_Atom_inst0_O;
assign valid_down = Add_Atom_inst0_valid_down;
endmodule

module NativeMapParallel_n2 (input CLK, input [7:0] I_0, input [7:0] I_1, output [7:0] O_0, output [7:0] O_1, output valid_down, input valid_up);
wire [7:0] Module_0_inst0_O;
wire Module_0_inst0_valid_down;
wire [7:0] Module_0_inst1_O;
wire Module_0_inst1_valid_down;
wire and_inst0_out;
Module_0 Module_0_inst0(.CLK(CLK), .I(I_0), .O(Module_0_inst0_O), .valid_down(Module_0_inst0_valid_down), .valid_up(valid_up));
Module_0 Module_0_inst1(.CLK(CLK), .I(I_1), .O(Module_0_inst1_O), .valid_down(Module_0_inst1_valid_down), .valid_up(valid_up));
corebit_and and_inst0(.in0(Module_0_inst0_valid_down), .in1(Module_0_inst1_valid_down), .out(and_inst0_out));
assign O_0 = Module_0_inst0_O;
assign O_1 = Module_0_inst1_O;
assign valid_down = and_inst0_out;
endmodule

module Map_T_n100_i0 (input CLK, input [7:0] I_0, input [7:0] I_1, output [7:0] O_0, output [7:0] O_1, output valid_down, input valid_up);
wire [7:0] NativeMapParallel_n2_inst0_O_0;
wire [7:0] NativeMapParallel_n2_inst0_O_1;
wire NativeMapParallel_n2_inst0_valid_down;
NativeMapParallel_n2 NativeMapParallel_n2_inst0(.CLK(CLK), .I_0(I_0), .I_1(I_1), .O_0(NativeMapParallel_n2_inst0_O_0), .O_1(NativeMapParallel_n2_inst0_O_1), .valid_down(NativeMapParallel_n2_inst0_valid_down), .valid_up(valid_up));
assign O_0 = NativeMapParallel_n2_inst0_O_0;
assign O_1 = NativeMapParallel_n2_inst0_O_1;
assign valid_down = NativeMapParallel_n2_inst0_valid_down;
endmodule

module top (input CLK, input [7:0] I_0, input [7:0] I_1, output [7:0] O_0, output [7:0] O_1, output valid_down, input valid_up);
wire [7:0] FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_0;
wire [7:0] FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_1;
wire FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down;
wire [7:0] FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_0;
wire [7:0] FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_1;
wire FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_valid_down;
wire [7:0] FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_0;
wire [7:0] FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_1;
wire FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_valid_down;
wire [7:0] FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_0;
wire [7:0] FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_1;
wire FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_valid_down;
wire [7:0] Map_T_n100_i0_inst0_O_0;
wire [7:0] Map_T_n100_i0_inst0_O_1;
wire Map_T_n100_i0_inst0_valid_down;
FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0(.CLK(CLK), .I_0(I_0), .I_1(I_1), .O_0(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_0), .O_1(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_1), .valid_down(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down), .valid_up(valid_up));
FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1(.CLK(CLK), .I_0(Map_T_n100_i0_inst0_O_0), .I_1(Map_T_n100_i0_inst0_O_1), .O_0(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_0), .O_1(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_1), .valid_down(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_valid_down), .valid_up(Map_T_n100_i0_inst0_valid_down));
FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2(.CLK(CLK), .I_0(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_0), .I_1(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_O_1), .O_0(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_0), .O_1(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_1), .valid_down(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_valid_down), .valid_up(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst1_valid_down));
FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3(.CLK(CLK), .I_0(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_0), .I_1(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_O_1), .O_0(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_0), .O_1(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_1), .valid_down(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_valid_down), .valid_up(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst2_valid_down));
Map_T_n100_i0 Map_T_n100_i0_inst0(.CLK(CLK), .I_0(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_0), .I_1(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_O_1), .O_0(Map_T_n100_i0_inst0_O_0), .O_1(Map_T_n100_i0_inst0_O_1), .valid_down(Map_T_n100_i0_inst0_valid_down), .valid_up(FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst0_valid_down));
assign O_0 = FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_0;
assign O_1 = FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_O_1;
assign valid_down = FIFO_tTSeq_100_0_SSeq_2_Int___delay1_hasCEFalse_hasResetFalse_hasValidTrue_inst3_valid_down;
endmodule

