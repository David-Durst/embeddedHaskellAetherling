// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2018.2
// Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="vhls_target,hls_ip_2018_2,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7k160tfbg484-2,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=dataflow,HLS_SYN_CLOCK=3.814000,HLS_SYN_LAT=10004,HLS_SYN_TPT=10004,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=186,HLS_SYN_LUT=598,HLS_VERSION=2018_2}" *)

module vhls_target (
        s_axi_config_AWVALID,
        s_axi_config_AWREADY,
        s_axi_config_AWADDR,
        s_axi_config_WVALID,
        s_axi_config_WREADY,
        s_axi_config_WDATA,
        s_axi_config_WSTRB,
        s_axi_config_ARVALID,
        s_axi_config_ARREADY,
        s_axi_config_ARADDR,
        s_axi_config_RVALID,
        s_axi_config_RREADY,
        s_axi_config_RDATA,
        s_axi_config_RRESP,
        s_axi_config_BVALID,
        s_axi_config_BREADY,
        s_axi_config_BRESP,
        ap_clk,
        ap_rst_n,
        interrupt,
        arg_0_TDATA,
        arg_0_TLAST,
        arg_1_TDATA,
        arg_1_TLAST,
        arg_0_TVALID,
        arg_0_TREADY,
        arg_1_TVALID,
        arg_1_TREADY
);

parameter    C_S_AXI_CONFIG_DATA_WIDTH = 32;
parameter    C_S_AXI_CONFIG_ADDR_WIDTH = 4;
parameter    C_S_AXI_DATA_WIDTH = 32;
parameter    C_S_AXI_ADDR_WIDTH = 32;

parameter C_S_AXI_CONFIG_WSTRB_WIDTH = (32 / 8);
parameter C_S_AXI_WSTRB_WIDTH = (32 / 8);

input   s_axi_config_AWVALID;
output   s_axi_config_AWREADY;
input  [C_S_AXI_CONFIG_ADDR_WIDTH - 1:0] s_axi_config_AWADDR;
input   s_axi_config_WVALID;
output   s_axi_config_WREADY;
input  [C_S_AXI_CONFIG_DATA_WIDTH - 1:0] s_axi_config_WDATA;
input  [C_S_AXI_CONFIG_WSTRB_WIDTH - 1:0] s_axi_config_WSTRB;
input   s_axi_config_ARVALID;
output   s_axi_config_ARREADY;
input  [C_S_AXI_CONFIG_ADDR_WIDTH - 1:0] s_axi_config_ARADDR;
output   s_axi_config_RVALID;
input   s_axi_config_RREADY;
output  [C_S_AXI_CONFIG_DATA_WIDTH - 1:0] s_axi_config_RDATA;
output  [1:0] s_axi_config_RRESP;
output   s_axi_config_BVALID;
input   s_axi_config_BREADY;
output  [1:0] s_axi_config_BRESP;
input   ap_clk;
input   ap_rst_n;
output   interrupt;
input  [15:0] arg_0_TDATA;
input  [0:0] arg_0_TLAST;
output  [15:0] arg_1_TDATA;
output  [0:0] arg_1_TLAST;
input   arg_0_TVALID;
output   arg_0_TREADY;
output   arg_1_TVALID;
input   arg_1_TREADY;

 reg    ap_rst_n_inv;
wire    ap_start;
wire    ap_ready;
wire    ap_done;
wire    ap_idle;
wire    Loop_1_proc16_U0_ap_start;
wire    Loop_1_proc16_U0_ap_done;
wire    Loop_1_proc16_U0_ap_continue;
wire    Loop_1_proc16_U0_ap_idle;
wire    Loop_1_proc16_U0_ap_ready;
wire    Loop_1_proc16_U0_start_out;
wire    Loop_1_proc16_U0_start_write;
wire    Loop_1_proc16_U0_arg_0_TREADY;
wire   [15:0] Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_value_V_din;
wire    Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_value_V_write;
wire   [0:0] Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_last_V_din;
wire    Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_last_V_write;
wire    Loop_2_proc17_U0_ap_start;
wire    Loop_2_proc17_U0_ap_done;
wire    Loop_2_proc17_U0_ap_continue;
wire    Loop_2_proc17_U0_ap_idle;
wire    Loop_2_proc17_U0_ap_ready;
wire    Loop_2_proc17_U0_p_hw_input_stencil_stream_to_hw_output_V_value_V_read;
wire    Loop_2_proc17_U0_p_hw_input_stencil_stream_to_hw_output_V_last_V_read;
wire   [15:0] Loop_2_proc17_U0_arg_1_TDATA;
wire    Loop_2_proc17_U0_arg_1_TVALID;
wire   [0:0] Loop_2_proc17_U0_arg_1_TLAST;
wire    ap_sync_continue;
wire    p_hw_input_stencil_st_2_full_n;
wire   [15:0] p_hw_input_stencil_st_2_dout;
wire    p_hw_input_stencil_st_2_empty_n;
wire    p_hw_input_stencil_st_3_full_n;
wire   [0:0] p_hw_input_stencil_st_3_dout;
wire    p_hw_input_stencil_st_3_empty_n;
wire    ap_sync_done;
wire    ap_sync_ready;
wire   [0:0] start_for_Loop_2_proc17_U0_din;
wire    start_for_Loop_2_proc17_U0_full_n;
wire   [0:0] start_for_Loop_2_proc17_U0_dout;
wire    start_for_Loop_2_proc17_U0_empty_n;
wire    Loop_2_proc17_U0_start_full_n;
wire    Loop_2_proc17_U0_start_write;

vhls_target_config_s_axi #(
    .C_S_AXI_ADDR_WIDTH( C_S_AXI_CONFIG_ADDR_WIDTH ),
    .C_S_AXI_DATA_WIDTH( C_S_AXI_CONFIG_DATA_WIDTH ))
vhls_target_config_s_axi_U(
    .AWVALID(s_axi_config_AWVALID),
    .AWREADY(s_axi_config_AWREADY),
    .AWADDR(s_axi_config_AWADDR),
    .WVALID(s_axi_config_WVALID),
    .WREADY(s_axi_config_WREADY),
    .WDATA(s_axi_config_WDATA),
    .WSTRB(s_axi_config_WSTRB),
    .ARVALID(s_axi_config_ARVALID),
    .ARREADY(s_axi_config_ARREADY),
    .ARADDR(s_axi_config_ARADDR),
    .RVALID(s_axi_config_RVALID),
    .RREADY(s_axi_config_RREADY),
    .RDATA(s_axi_config_RDATA),
    .RRESP(s_axi_config_RRESP),
    .BVALID(s_axi_config_BVALID),
    .BREADY(s_axi_config_BREADY),
    .BRESP(s_axi_config_BRESP),
    .ACLK(ap_clk),
    .ARESET(ap_rst_n_inv),
    .ACLK_EN(1'b1),
    .ap_start(ap_start),
    .interrupt(interrupt),
    .ap_ready(ap_ready),
    .ap_done(ap_done),
    .ap_idle(ap_idle)
);

Loop_1_proc16 Loop_1_proc16_U0(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst_n_inv),
    .ap_start(Loop_1_proc16_U0_ap_start),
    .start_full_n(start_for_Loop_2_proc17_U0_full_n),
    .ap_done(Loop_1_proc16_U0_ap_done),
    .ap_continue(Loop_1_proc16_U0_ap_continue),
    .ap_idle(Loop_1_proc16_U0_ap_idle),
    .ap_ready(Loop_1_proc16_U0_ap_ready),
    .start_out(Loop_1_proc16_U0_start_out),
    .start_write(Loop_1_proc16_U0_start_write),
    .arg_0_TDATA(arg_0_TDATA),
    .arg_0_TVALID(arg_0_TVALID),
    .arg_0_TREADY(Loop_1_proc16_U0_arg_0_TREADY),
    .arg_0_TLAST(arg_0_TLAST),
    .p_hw_input_stencil_stream_to_hw_output_V_value_V_din(Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_value_V_din),
    .p_hw_input_stencil_stream_to_hw_output_V_value_V_full_n(p_hw_input_stencil_st_2_full_n),
    .p_hw_input_stencil_stream_to_hw_output_V_value_V_write(Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_value_V_write),
    .p_hw_input_stencil_stream_to_hw_output_V_last_V_din(Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_last_V_din),
    .p_hw_input_stencil_stream_to_hw_output_V_last_V_full_n(p_hw_input_stencil_st_3_full_n),
    .p_hw_input_stencil_stream_to_hw_output_V_last_V_write(Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_last_V_write)
);

Loop_2_proc17 Loop_2_proc17_U0(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst_n_inv),
    .ap_start(Loop_2_proc17_U0_ap_start),
    .ap_done(Loop_2_proc17_U0_ap_done),
    .ap_continue(Loop_2_proc17_U0_ap_continue),
    .ap_idle(Loop_2_proc17_U0_ap_idle),
    .ap_ready(Loop_2_proc17_U0_ap_ready),
    .p_hw_input_stencil_stream_to_hw_output_V_value_V_dout(p_hw_input_stencil_st_2_dout),
    .p_hw_input_stencil_stream_to_hw_output_V_value_V_empty_n(p_hw_input_stencil_st_2_empty_n),
    .p_hw_input_stencil_stream_to_hw_output_V_value_V_read(Loop_2_proc17_U0_p_hw_input_stencil_stream_to_hw_output_V_value_V_read),
    .p_hw_input_stencil_stream_to_hw_output_V_last_V_dout(p_hw_input_stencil_st_3_dout),
    .p_hw_input_stencil_stream_to_hw_output_V_last_V_empty_n(p_hw_input_stencil_st_3_empty_n),
    .p_hw_input_stencil_stream_to_hw_output_V_last_V_read(Loop_2_proc17_U0_p_hw_input_stencil_stream_to_hw_output_V_last_V_read),
    .arg_1_TDATA(Loop_2_proc17_U0_arg_1_TDATA),
    .arg_1_TVALID(Loop_2_proc17_U0_arg_1_TVALID),
    .arg_1_TREADY(arg_1_TREADY),
    .arg_1_TLAST(Loop_2_proc17_U0_arg_1_TLAST)
);

fifo_w16_d1_S p_hw_input_stencil_st_2_U(
    .clk(ap_clk),
    .reset(ap_rst_n_inv),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_value_V_din),
    .if_full_n(p_hw_input_stencil_st_2_full_n),
    .if_write(Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_value_V_write),
    .if_dout(p_hw_input_stencil_st_2_dout),
    .if_empty_n(p_hw_input_stencil_st_2_empty_n),
    .if_read(Loop_2_proc17_U0_p_hw_input_stencil_stream_to_hw_output_V_value_V_read)
);

fifo_w1_d1_S p_hw_input_stencil_st_3_U(
    .clk(ap_clk),
    .reset(ap_rst_n_inv),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_last_V_din),
    .if_full_n(p_hw_input_stencil_st_3_full_n),
    .if_write(Loop_1_proc16_U0_p_hw_input_stencil_stream_to_hw_output_V_last_V_write),
    .if_dout(p_hw_input_stencil_st_3_dout),
    .if_empty_n(p_hw_input_stencil_st_3_empty_n),
    .if_read(Loop_2_proc17_U0_p_hw_input_stencil_stream_to_hw_output_V_last_V_read)
);

start_for_Loop_2_bkb start_for_Loop_2_bkb_U(
    .clk(ap_clk),
    .reset(ap_rst_n_inv),
    .if_read_ce(1'b1),
    .if_write_ce(1'b1),
    .if_din(start_for_Loop_2_proc17_U0_din),
    .if_full_n(start_for_Loop_2_proc17_U0_full_n),
    .if_write(Loop_1_proc16_U0_start_write),
    .if_dout(start_for_Loop_2_proc17_U0_dout),
    .if_empty_n(start_for_Loop_2_proc17_U0_empty_n),
    .if_read(Loop_2_proc17_U0_ap_ready)
);

assign Loop_1_proc16_U0_ap_continue = 1'b1;

assign Loop_1_proc16_U0_ap_start = ap_start;

assign Loop_2_proc17_U0_ap_continue = 1'b1;

assign Loop_2_proc17_U0_ap_start = start_for_Loop_2_proc17_U0_empty_n;

assign Loop_2_proc17_U0_start_full_n = 1'b1;

assign Loop_2_proc17_U0_start_write = 1'b0;

assign ap_done = Loop_2_proc17_U0_ap_done;

assign ap_idle = (Loop_2_proc17_U0_ap_idle & Loop_1_proc16_U0_ap_idle);

assign ap_ready = Loop_1_proc16_U0_ap_ready;

always @ (*) begin
    ap_rst_n_inv = ~ap_rst_n;
end

assign ap_sync_continue = 1'b1;

assign ap_sync_done = Loop_2_proc17_U0_ap_done;

assign ap_sync_ready = Loop_1_proc16_U0_ap_ready;

assign arg_0_TREADY = Loop_1_proc16_U0_arg_0_TREADY;

assign arg_1_TDATA = Loop_2_proc17_U0_arg_1_TDATA;

assign arg_1_TLAST = Loop_2_proc17_U0_arg_1_TLAST;

assign arg_1_TVALID = Loop_2_proc17_U0_arg_1_TVALID;

assign start_for_Loop_2_proc17_U0_din = 1'b1;

endmodule //vhls_target
