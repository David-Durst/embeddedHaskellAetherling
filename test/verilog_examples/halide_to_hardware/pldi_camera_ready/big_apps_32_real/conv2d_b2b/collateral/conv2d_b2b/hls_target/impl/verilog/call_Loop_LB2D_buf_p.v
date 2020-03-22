// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2017.2
// Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module call_Loop_LB2D_buf_p (
        ap_clk,
        ap_rst,
        ap_start,
        start_full_n,
        ap_ready,
        ap_done,
        ap_continue,
        ap_idle,
        start_out,
        start_write,
        in_stream_V_value_V_dout,
        in_stream_V_value_V_empty_n,
        in_stream_V_value_V_read,
        slice_stream_V_value_V_din,
        slice_stream_V_value_V_full_n,
        slice_stream_V_value_V_write
);

parameter    ap_ST_fsm_state1 = 4'd1;
parameter    ap_ST_fsm_state2 = 4'd2;
parameter    ap_ST_fsm_pp0_stage0 = 4'd4;
parameter    ap_ST_fsm_state6 = 4'd8;

input   ap_clk;
input   ap_rst;
input   ap_start;
input   start_full_n;
output   ap_ready;
output   ap_done;
input   ap_continue;
output   ap_idle;
output   start_out;
output   start_write;
input  [31:0] in_stream_V_value_V_dout;
input   in_stream_V_value_V_empty_n;
output   in_stream_V_value_V_read;
output  [95:0] slice_stream_V_value_V_din;
input   slice_stream_V_value_V_full_n;
output   slice_stream_V_value_V_write;

reg ap_done;
reg ap_idle;
reg in_stream_V_value_V_read;
reg slice_stream_V_value_V_write;

reg    real_start;
reg    real_start_status_reg;
reg    internal_ap_ready;
reg    ap_done_reg;
(* fsm_encoding = "none" *) reg   [3:0] ap_CS_fsm;
wire    ap_CS_fsm_state1;
reg    start_once_reg;
reg    start_control_reg;
reg    in_stream_V_value_V_blk_n;
wire    ap_CS_fsm_pp0_stage0;
reg    ap_enable_reg_pp0_iter1;
wire    ap_block_pp0_stage0_flag00000000;
reg   [0:0] tmp_3_reg_304;
reg    slice_stream_V_value_V_blk_n;
reg    ap_enable_reg_pp0_iter2;
reg   [0:0] icmp_reg_300;
reg   [63:0] write_idx_1_1_reg_158;
reg   [10:0] col_reg_169;
wire   [0:0] tmp_fu_180_p2;
wire    ap_CS_fsm_state2;
wire   [10:0] row_1_fu_186_p2;
reg   [10:0] row_1_reg_295;
wire   [0:0] icmp_fu_202_p2;
wire   [0:0] tmp_3_fu_208_p2;
wire    ap_block_state3_pp0_stage0_iter0;
reg    ap_block_state4_pp0_stage0_iter1;
reg    ap_block_state5_pp0_stage0_iter2;
reg    ap_block_pp0_stage0_flag00011001;
wire   [10:0] col_1_fu_214_p2;
reg    ap_enable_reg_pp0_iter0;
wire   [0:0] icmp1_fu_238_p2;
reg   [0:0] icmp1_reg_313;
reg   [10:0] buffer_0_value_V_ad_reg_328;
reg   [10:0] ap_reg_pp0_iter1_buffer_0_value_V_ad_reg_328;
reg   [10:0] buffer_1_value_V_ad_reg_333;
reg   [10:0] ap_reg_pp0_iter1_buffer_1_value_V_ad_reg_333;
wire   [63:0] p_write_idx_1_1_fu_250_p3;
reg   [31:0] tmp_value_V_4_reg_343;
wire   [0:0] tmp_8_fu_257_p1;
reg   [0:0] tmp_8_reg_350;
wire   [31:0] buffer_1_value_V_q0;
reg   [31:0] buffer_1_value_V_lo_reg_356;
wire   [31:0] buffer_0_value_V_q0;
reg   [31:0] buffer_0_value_V_lo_reg_362;
wire   [0:0] tmp_9_fu_261_p1;
reg   [0:0] tmp_9_reg_368;
wire   [63:0] write_idx_1_2_fu_285_p2;
wire    ap_CS_fsm_state6;
reg    ap_block_pp0_stage0_flag00011011;
reg    ap_condition_pp0_exit_iter0_state3;
wire   [10:0] buffer_0_value_V_address0;
reg    buffer_0_value_V_ce0;
wire   [10:0] buffer_0_value_V_address1;
reg    buffer_0_value_V_ce1;
reg    buffer_0_value_V_we1;
wire   [10:0] buffer_1_value_V_address0;
reg    buffer_1_value_V_ce0;
reg    buffer_1_value_V_ce1;
reg    buffer_1_value_V_we1;
reg   [63:0] write_idx_1_reg_135;
reg    ap_block_state1;
reg   [10:0] row_reg_147;
reg   [63:0] write_idx_1_1_phi_fu_161_p4;
wire   [63:0] col_cast_fu_220_p1;
reg    ap_block_pp0_stage0_flag00001001;
wire   [9:0] tmp_5_fu_192_p4;
wire   [62:0] tmp_7_fu_228_p4;
wire   [63:0] write_idx_1_3_fu_244_p2;
wire   [31:0] p_Val2_14_1_phi_fu_270_p3;
wire   [31:0] p_Val2_14_0_phi_fu_265_p3;
reg   [3:0] ap_NS_fsm;
reg    ap_block_pp0;
reg    ap_enable_operation_57;
reg    ap_enable_state5_pp0_iter2_stage0;
reg    ap_predicate_op38_load_state3;
reg    ap_enable_operation_38;
reg    ap_enable_state3_pp0_iter0_stage0;
reg    ap_enable_operation_46;
reg    ap_enable_state4_pp0_iter1_stage0;
reg    ap_idle_pp0;
wire    ap_enable_pp0;

// power-on initialization
initial begin
#0 real_start_status_reg = 1'b0;
#0 ap_done_reg = 1'b0;
#0 ap_CS_fsm = 4'd1;
#0 start_once_reg = 1'b0;
#0 start_control_reg = 1'b0;
#0 ap_enable_reg_pp0_iter1 = 1'b0;
#0 ap_enable_reg_pp0_iter2 = 1'b0;
#0 ap_enable_reg_pp0_iter0 = 1'b0;
end

call_Loop_LB2D_bubkb #(
    .DataWidth( 32 ),
    .AddressRange( 1920 ),
    .AddressWidth( 11 ))
buffer_0_value_V_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .address0(buffer_0_value_V_address0),
    .ce0(buffer_0_value_V_ce0),
    .q0(buffer_0_value_V_q0),
    .address1(buffer_0_value_V_address1),
    .ce1(buffer_0_value_V_ce1),
    .we1(buffer_0_value_V_we1),
    .d1(tmp_value_V_4_reg_343)
);

call_Loop_LB2D_bubkb #(
    .DataWidth( 32 ),
    .AddressRange( 1920 ),
    .AddressWidth( 11 ))
buffer_1_value_V_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .address0(buffer_1_value_V_address0),
    .ce0(buffer_1_value_V_ce0),
    .q0(buffer_1_value_V_q0),
    .address1(ap_reg_pp0_iter1_buffer_1_value_V_ad_reg_333),
    .ce1(buffer_1_value_V_ce1),
    .we1(buffer_1_value_V_we1),
    .d1(tmp_value_V_4_reg_343)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_done_reg <= 1'b0;
    end else begin
        if ((1'b1 == ap_continue)) begin
            ap_done_reg <= 1'b0;
        end else if (((1'b1 == ap_CS_fsm_state2) & (tmp_fu_180_p2 == 1'd1))) begin
            ap_done_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter0 <= 1'b0;
    end else begin
        if (((1'b1 == ap_CS_fsm_pp0_stage0) & (ap_block_pp0_stage0_flag00011011 == 1'b0) & (1'b1 == ap_condition_pp0_exit_iter0_state3))) begin
            ap_enable_reg_pp0_iter0 <= 1'b0;
        end else if (((1'b1 == ap_CS_fsm_state2) & (1'd0 == tmp_fu_180_p2))) begin
            ap_enable_reg_pp0_iter0 <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter1 <= 1'b0;
    end else begin
        if ((ap_block_pp0_stage0_flag00011011 == 1'b0)) begin
            if ((1'b1 == ap_condition_pp0_exit_iter0_state3)) begin
                ap_enable_reg_pp0_iter1 <= (ap_condition_pp0_exit_iter0_state3 ^ 1'b1);
            end else if ((1'b1 == 1'b1)) begin
                ap_enable_reg_pp0_iter1 <= ap_enable_reg_pp0_iter0;
            end
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_enable_reg_pp0_iter2 <= 1'b0;
    end else begin
        if ((ap_block_pp0_stage0_flag00011011 == 1'b0)) begin
            ap_enable_reg_pp0_iter2 <= ap_enable_reg_pp0_iter1;
        end else if (((1'b1 == ap_CS_fsm_state2) & (1'd0 == tmp_fu_180_p2))) begin
            ap_enable_reg_pp0_iter2 <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        real_start_status_reg <= 1'b0;
    end else begin
        if ((start_full_n == 1'b1)) begin
            real_start_status_reg <= 1'b0;
        end else if (((1'b0 == start_full_n) & (1'b1 == internal_ap_ready))) begin
            real_start_status_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        start_control_reg <= 1'b0;
    end else begin
        if (((1'b1 == real_start) & ((1'b1 == internal_ap_ready) | (1'b0 == start_once_reg)))) begin
            start_control_reg <= 1'b1;
        end else if ((1'b1 == start_control_reg)) begin
            start_control_reg <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        start_once_reg <= 1'b0;
    end else begin
        if ((1'b1 == real_start)) begin
            start_once_reg <= 1'b1;
        end else if ((1'b0 == ap_start)) begin
            start_once_reg <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (ap_block_pp0_stage0_flag00011001 == 1'b0) & (1'b1 == ap_enable_reg_pp0_iter0) & (1'd0 == tmp_3_fu_208_p2))) begin
        col_reg_169 <= col_1_fu_214_p2;
    end else if (((1'b1 == ap_CS_fsm_state2) & (1'd0 == tmp_fu_180_p2))) begin
        col_reg_169 <= 11'd0;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state6)) begin
        row_reg_147 <= row_1_reg_295;
    end else if (((1'b1 == ap_CS_fsm_state1) & ~((1'b0 == real_start) | (ap_done_reg == 1'b1)))) begin
        row_reg_147 <= 11'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (1'b1 == ap_enable_reg_pp0_iter1) & (tmp_3_reg_304 == 1'd0) & (ap_block_pp0_stage0_flag00011001 == 1'b0))) begin
        write_idx_1_1_reg_158 <= p_write_idx_1_1_fu_250_p3;
    end else if (((1'b1 == ap_CS_fsm_state2) & (1'd0 == tmp_fu_180_p2))) begin
        write_idx_1_1_reg_158 <= write_idx_1_reg_135;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state6)) begin
        write_idx_1_reg_135 <= write_idx_1_2_fu_285_p2;
    end else if (((1'b1 == ap_CS_fsm_state1) & ~((1'b0 == real_start) | (ap_done_reg == 1'b1)))) begin
        write_idx_1_reg_135 <= 64'd0;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (ap_block_pp0_stage0_flag00011001 == 1'b0))) begin
        ap_reg_pp0_iter1_buffer_0_value_V_ad_reg_328 <= buffer_0_value_V_ad_reg_328;
        ap_reg_pp0_iter1_buffer_1_value_V_ad_reg_333 <= buffer_1_value_V_ad_reg_333;
        tmp_3_reg_304 <= tmp_3_fu_208_p2;
        tmp_9_reg_368 <= tmp_9_fu_261_p1;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (ap_block_pp0_stage0_flag00011001 == 1'b0) & (1'd0 == tmp_3_fu_208_p2))) begin
        buffer_0_value_V_ad_reg_328 <= col_cast_fu_220_p1;
        buffer_1_value_V_ad_reg_333 <= col_cast_fu_220_p1;
        icmp1_reg_313 <= icmp1_fu_238_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (1'b1 == ap_enable_reg_pp0_iter1) & (1'd0 == icmp_reg_300) & (ap_block_pp0_stage0_flag00011001 == 1'b0))) begin
        buffer_0_value_V_lo_reg_362 <= buffer_0_value_V_q0;
        buffer_1_value_V_lo_reg_356 <= buffer_1_value_V_q0;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state2) & (1'd0 == tmp_fu_180_p2))) begin
        icmp_reg_300 <= icmp_fu_202_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        row_1_reg_295 <= row_1_fu_186_p2;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (1'd0 == icmp_reg_300) & (ap_block_pp0_stage0_flag00011001 == 1'b0))) begin
        tmp_8_reg_350 <= tmp_8_fu_257_p1;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (tmp_3_reg_304 == 1'd0) & (ap_block_pp0_stage0_flag00011001 == 1'b0))) begin
        tmp_value_V_4_reg_343 <= in_stream_V_value_V_dout;
    end
end

always @ (*) begin
    if ((tmp_3_fu_208_p2 == 1'd1)) begin
        ap_condition_pp0_exit_iter0_state3 = 1'b1;
    end else begin
        ap_condition_pp0_exit_iter0_state3 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state2) & (tmp_fu_180_p2 == 1'd1))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = ap_done_reg;
    end
end

always @ (*) begin
    if (((1'b0 == real_start) & (1'b1 == ap_CS_fsm_state1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_enable_reg_pp0_iter0) & (1'b0 == ap_enable_reg_pp0_iter1) & (1'b0 == ap_enable_reg_pp0_iter2))) begin
        ap_idle_pp0 = 1'b1;
    end else begin
        ap_idle_pp0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (ap_block_pp0_stage0_flag00011001 == 1'b0) & (1'b1 == ap_enable_reg_pp0_iter0))) begin
        buffer_0_value_V_ce0 = 1'b1;
    end else begin
        buffer_0_value_V_ce0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_enable_reg_pp0_iter2) & (ap_block_pp0_stage0_flag00011001 == 1'b0))) begin
        buffer_0_value_V_ce1 = 1'b1;
    end else begin
        buffer_0_value_V_ce1 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_enable_reg_pp0_iter2) & (ap_block_pp0_stage0_flag00011001 == 1'b0) & (1'd0 == tmp_9_reg_368))) begin
        buffer_0_value_V_we1 = 1'b1;
    end else begin
        buffer_0_value_V_we1 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (ap_block_pp0_stage0_flag00011001 == 1'b0) & (1'b1 == ap_enable_reg_pp0_iter0))) begin
        buffer_1_value_V_ce0 = 1'b1;
    end else begin
        buffer_1_value_V_ce0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_enable_reg_pp0_iter2) & (ap_block_pp0_stage0_flag00011001 == 1'b0))) begin
        buffer_1_value_V_ce1 = 1'b1;
    end else begin
        buffer_1_value_V_ce1 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_enable_reg_pp0_iter2) & (ap_block_pp0_stage0_flag00011001 == 1'b0) & (tmp_9_reg_368 == 1'd1))) begin
        buffer_1_value_V_we1 = 1'b1;
    end else begin
        buffer_1_value_V_we1 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (1'b1 == ap_enable_reg_pp0_iter1) & (ap_block_pp0_stage0_flag00000000 == 1'b0) & (tmp_3_reg_304 == 1'd0))) begin
        in_stream_V_value_V_blk_n = in_stream_V_value_V_empty_n;
    end else begin
        in_stream_V_value_V_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (1'b1 == ap_enable_reg_pp0_iter1) & (tmp_3_reg_304 == 1'd0) & (ap_block_pp0_stage0_flag00011001 == 1'b0))) begin
        in_stream_V_value_V_read = 1'b1;
    end else begin
        in_stream_V_value_V_read = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state2) & (tmp_fu_180_p2 == 1'd1))) begin
        internal_ap_ready = 1'b1;
    end else begin
        internal_ap_ready = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == real_start_status_reg)) begin
        real_start = 1'b0;
    end else begin
        real_start = ap_start;
    end
end

always @ (*) begin
    if (((ap_block_pp0_stage0_flag00000000 == 1'b0) & (1'b1 == ap_enable_reg_pp0_iter2) & (1'd0 == icmp_reg_300))) begin
        slice_stream_V_value_V_blk_n = slice_stream_V_value_V_full_n;
    end else begin
        slice_stream_V_value_V_blk_n = 1'b1;
    end
end

always @ (*) begin
    if (((1'b1 == ap_enable_reg_pp0_iter2) & (1'd0 == icmp_reg_300) & (ap_block_pp0_stage0_flag00011001 == 1'b0))) begin
        slice_stream_V_value_V_write = 1'b1;
    end else begin
        slice_stream_V_value_V_write = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_pp0_stage0) & (1'b1 == ap_enable_reg_pp0_iter1) & (ap_block_pp0_stage0_flag00000000 == 1'b0) & (tmp_3_reg_304 == 1'd0))) begin
        write_idx_1_1_phi_fu_161_p4 = p_write_idx_1_1_fu_250_p3;
    end else begin
        write_idx_1_1_phi_fu_161_p4 = write_idx_1_1_reg_158;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if (((1'b1 == ap_CS_fsm_state1) & ~((1'b0 == real_start) | (ap_done_reg == 1'b1)))) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            if (((1'b1 == ap_CS_fsm_state2) & (tmp_fu_180_p2 == 1'd1))) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end
        end
        ap_ST_fsm_pp0_stage0 : begin
            if ((~((1'b1 == ap_enable_reg_pp0_iter2) & (ap_block_pp0_stage0_flag00011011 == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b0)) & ~((1'b1 == ap_enable_reg_pp0_iter0) & (ap_block_pp0_stage0_flag00011011 == 1'b0) & (tmp_3_fu_208_p2 == 1'd1) & (ap_enable_reg_pp0_iter1 == 1'b0)))) begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end else if ((((1'b1 == ap_enable_reg_pp0_iter2) & (ap_block_pp0_stage0_flag00011011 == 1'b0) & (ap_enable_reg_pp0_iter1 == 1'b0)) | ((1'b1 == ap_enable_reg_pp0_iter0) & (ap_block_pp0_stage0_flag00011011 == 1'b0) & (tmp_3_fu_208_p2 == 1'd1) & (ap_enable_reg_pp0_iter1 == 1'b0)))) begin
                ap_NS_fsm = ap_ST_fsm_state6;
            end else begin
                ap_NS_fsm = ap_ST_fsm_pp0_stage0;
            end
        end
        ap_ST_fsm_state6 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_pp0_stage0 = ap_CS_fsm[32'd2];

assign ap_CS_fsm_state1 = ap_CS_fsm[32'd0];

assign ap_CS_fsm_state2 = ap_CS_fsm[32'd1];

assign ap_CS_fsm_state6 = ap_CS_fsm[32'd3];

always @ (*) begin
    ap_block_pp0 = (1'b1 == ap_block_pp0_stage0_flag00011011);
end

assign ap_block_pp0_stage0_flag00000000 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_pp0_stage0_flag00001001 = (((1'b1 == ap_enable_reg_pp0_iter1) & (tmp_3_reg_304 == 1'd0) & (1'b0 == in_stream_V_value_V_empty_n)) | ((1'b1 == ap_enable_reg_pp0_iter2) & (1'd0 == icmp_reg_300) & (1'b0 == slice_stream_V_value_V_full_n)));
end

always @ (*) begin
    ap_block_pp0_stage0_flag00011001 = (((1'b1 == ap_enable_reg_pp0_iter1) & (tmp_3_reg_304 == 1'd0) & (1'b0 == in_stream_V_value_V_empty_n)) | ((1'b1 == ap_enable_reg_pp0_iter2) & (1'd0 == icmp_reg_300) & (1'b0 == slice_stream_V_value_V_full_n)));
end

always @ (*) begin
    ap_block_pp0_stage0_flag00011011 = (((1'b1 == ap_enable_reg_pp0_iter1) & (tmp_3_reg_304 == 1'd0) & (1'b0 == in_stream_V_value_V_empty_n)) | ((1'b1 == ap_enable_reg_pp0_iter2) & (1'd0 == icmp_reg_300) & (1'b0 == slice_stream_V_value_V_full_n)));
end

always @ (*) begin
    ap_block_state1 = ((1'b0 == real_start) | (ap_done_reg == 1'b1));
end

assign ap_block_state3_pp0_stage0_iter0 = ~(1'b1 == 1'b1);

always @ (*) begin
    ap_block_state4_pp0_stage0_iter1 = ((tmp_3_reg_304 == 1'd0) & (1'b0 == in_stream_V_value_V_empty_n));
end

always @ (*) begin
    ap_block_state5_pp0_stage0_iter2 = ((1'd0 == icmp_reg_300) & (1'b0 == slice_stream_V_value_V_full_n));
end

always @ (*) begin
    ap_enable_operation_38 = (1'b1 == ap_predicate_op38_load_state3);
end

always @ (*) begin
    ap_enable_operation_46 = (1'd0 == icmp_reg_300);
end

always @ (*) begin
    ap_enable_operation_57 = (1'd0 == tmp_9_reg_368);
end

assign ap_enable_pp0 = (ap_idle_pp0 ^ 1'b1);

always @ (*) begin
    ap_enable_state3_pp0_iter0_stage0 = ((ap_CS_fsm_pp0_stage0 == 1'b1) & (ap_enable_reg_pp0_iter0 == 1'b1));
end

always @ (*) begin
    ap_enable_state4_pp0_iter1_stage0 = ((ap_CS_fsm_pp0_stage0 == 1'b1) & (ap_enable_reg_pp0_iter1 == 1'b1));
end

always @ (*) begin
    ap_enable_state5_pp0_iter2_stage0 = ((ap_enable_reg_pp0_iter2 == 1'b1) & (ap_CS_fsm_pp0_stage0 == 1'b1));
end

always @ (*) begin
    ap_predicate_op38_load_state3 = ((1'd0 == icmp_reg_300) & (1'd0 == tmp_3_fu_208_p2));
end

assign ap_ready = internal_ap_ready;

assign buffer_0_value_V_address0 = col_cast_fu_220_p1;

assign buffer_0_value_V_address1 = ap_reg_pp0_iter1_buffer_0_value_V_ad_reg_328;

assign buffer_1_value_V_address0 = col_cast_fu_220_p1;

assign col_1_fu_214_p2 = (col_reg_169 + 11'd1);

assign col_cast_fu_220_p1 = col_reg_169;

assign icmp1_fu_238_p2 = ((tmp_7_fu_228_p4 != 63'd0) ? 1'b1 : 1'b0);

assign icmp_fu_202_p2 = ((tmp_5_fu_192_p4 == 10'd0) ? 1'b1 : 1'b0);

assign p_Val2_14_0_phi_fu_265_p3 = ((tmp_8_reg_350[0:0] === 1'b1) ? buffer_1_value_V_lo_reg_356 : buffer_0_value_V_lo_reg_362);

assign p_Val2_14_1_phi_fu_270_p3 = ((tmp_8_reg_350[0:0] === 1'b1) ? buffer_0_value_V_lo_reg_362 : buffer_1_value_V_lo_reg_356);

assign p_write_idx_1_1_fu_250_p3 = ((icmp1_reg_313[0:0] === 1'b1) ? write_idx_1_3_fu_244_p2 : write_idx_1_1_reg_158);

assign row_1_fu_186_p2 = (row_reg_147 + 11'd1);

assign slice_stream_V_value_V_din = {{{tmp_value_V_4_reg_343}, {p_Val2_14_1_phi_fu_270_p3}}, {p_Val2_14_0_phi_fu_265_p3}};

assign start_out = real_start;

assign start_write = (ap_start & start_control_reg);

assign tmp_3_fu_208_p2 = ((col_reg_169 == 11'd1920) ? 1'b1 : 1'b0);

assign tmp_5_fu_192_p4 = {{row_reg_147[10:1]}};

assign tmp_7_fu_228_p4 = {{write_idx_1_1_phi_fu_161_p4[63:1]}};

assign tmp_8_fu_257_p1 = p_write_idx_1_1_fu_250_p3[0:0];

assign tmp_9_fu_261_p1 = p_write_idx_1_1_fu_250_p3[0:0];

assign tmp_fu_180_p2 = ((row_reg_147 == 11'd1080) ? 1'b1 : 1'b0);

assign write_idx_1_2_fu_285_p2 = (write_idx_1_1_reg_158 + 64'd1);

assign write_idx_1_3_fu_244_p2 = ($signed(write_idx_1_1_reg_158) + $signed(64'd18446744073709551614));

endmodule //call_Loop_LB2D_buf_p
