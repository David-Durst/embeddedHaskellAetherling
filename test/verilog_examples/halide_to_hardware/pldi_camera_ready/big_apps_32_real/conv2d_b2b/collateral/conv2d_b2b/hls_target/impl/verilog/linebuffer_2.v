// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2017.2
// Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module linebuffer_2 (
        ap_start,
        start_full_n,
        ap_ready,
        start_out,
        start_write,
        in_stream_V_value_V_dout,
        in_stream_V_value_V_empty_n,
        in_stream_V_value_V_read,
        out_stream_V_value_V_din,
        out_stream_V_value_V_full_n,
        out_stream_V_value_V_write,
        ap_clk,
        ap_rst,
        ap_done,
        ap_idle,
        ap_continue
);


input   ap_start;
input   start_full_n;
output   ap_ready;
output   start_out;
output   start_write;
input  [31:0] in_stream_V_value_V_dout;
input   in_stream_V_value_V_empty_n;
output   in_stream_V_value_V_read;
output  [127:0] out_stream_V_value_V_din;
input   out_stream_V_value_V_full_n;
output   out_stream_V_value_V_write;
input   ap_clk;
input   ap_rst;
output   ap_done;
output   ap_idle;
input   ap_continue;

reg    real_start;
reg    real_start_status_reg;
wire    internal_ap_ready;
reg    start_once_reg;
reg    start_control_reg;
wire    call_1_U0_in_stream_V_value_V_read;
wire   [127:0] call_1_U0_out_stream_V_value_V_din;
wire    call_1_U0_out_stream_V_value_V_write;
wire    call_1_U0_ap_done;
wire    call_1_U0_ap_start;
wire    call_1_U0_ap_ready;
wire    call_1_U0_ap_idle;
wire    call_1_U0_ap_continue;
wire    ap_sync_continue;
wire    ap_sync_done;
wire    ap_sync_ready;
wire    call_1_U0_start_full_n;
wire    call_1_U0_start_write;

// power-on initialization
initial begin
#0 real_start_status_reg = 1'b0;
#0 start_once_reg = 1'b0;
#0 start_control_reg = 1'b0;
end

call_1 call_1_U0(
    .in_stream_V_value_V_dout(in_stream_V_value_V_dout),
    .in_stream_V_value_V_empty_n(in_stream_V_value_V_empty_n),
    .in_stream_V_value_V_read(call_1_U0_in_stream_V_value_V_read),
    .out_stream_V_value_V_din(call_1_U0_out_stream_V_value_V_din),
    .out_stream_V_value_V_full_n(out_stream_V_value_V_full_n),
    .out_stream_V_value_V_write(call_1_U0_out_stream_V_value_V_write),
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_done(call_1_U0_ap_done),
    .ap_start(call_1_U0_ap_start),
    .ap_ready(call_1_U0_ap_ready),
    .ap_idle(call_1_U0_ap_idle),
    .ap_continue(call_1_U0_ap_continue)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        real_start_status_reg <= 1'b0;
    end else begin
        if ((start_full_n == 1'b1)) begin
            real_start_status_reg <= 1'b0;
        end else if (((start_full_n == 1'b0) & (internal_ap_ready == 1'b1))) begin
            real_start_status_reg <= 1'b1;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        start_control_reg <= 1'b0;
    end else begin
        if (((real_start == 1'b1) & ((internal_ap_ready == 1'b1) | (1'b0 == start_once_reg)))) begin
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
        if ((real_start == 1'b1)) begin
            start_once_reg <= 1'b1;
        end else if ((ap_start == 1'b0)) begin
            start_once_reg <= 1'b0;
        end
    end
end

always @ (*) begin
    if ((real_start_status_reg == 1'b1)) begin
        real_start = 1'b0;
    end else begin
        real_start = ap_start;
    end
end

assign ap_done = call_1_U0_ap_done;

assign ap_idle = call_1_U0_ap_idle;

assign ap_ready = internal_ap_ready;

assign ap_sync_continue = ap_continue;

assign ap_sync_done = call_1_U0_ap_done;

assign ap_sync_ready = call_1_U0_ap_ready;

assign call_1_U0_ap_continue = ap_continue;

assign call_1_U0_ap_start = real_start;

assign call_1_U0_start_full_n = 1'b0;

assign call_1_U0_start_write = 1'b0;

assign in_stream_V_value_V_read = call_1_U0_in_stream_V_value_V_read;

assign internal_ap_ready = ap_sync_ready;

assign out_stream_V_value_V_din = call_1_U0_out_stream_V_value_V_din;

assign out_stream_V_value_V_write = call_1_U0_out_stream_V_value_V_write;

assign start_out = real_start;

assign start_write = (ap_start & start_control_reg);

endmodule //linebuffer_2
