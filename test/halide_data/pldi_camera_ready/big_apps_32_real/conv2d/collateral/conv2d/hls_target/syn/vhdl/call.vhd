-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2017.2
-- Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity call is
port (
    in_stream_V_value_V_dout : IN STD_LOGIC_VECTOR (31 downto 0);
    in_stream_V_value_V_empty_n : IN STD_LOGIC;
    in_stream_V_value_V_read : OUT STD_LOGIC;
    out_stream_V_value_V_din : OUT STD_LOGIC_VECTOR (287 downto 0);
    out_stream_V_value_V_full_n : IN STD_LOGIC;
    out_stream_V_value_V_write : OUT STD_LOGIC;
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_continue : IN STD_LOGIC );
end;


architecture behav of call is 
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_lv288_lc_1 : STD_LOGIC_VECTOR (287 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    constant ap_const_logic_1 : STD_LOGIC := '1';

    signal call_Loop_LB2D_buf_p_U0_ap_start : STD_LOGIC;
    signal call_Loop_LB2D_buf_p_U0_start_full_n : STD_LOGIC;
    signal call_Loop_LB2D_buf_p_U0_ap_ready : STD_LOGIC;
    signal call_Loop_LB2D_buf_p_U0_ap_done : STD_LOGIC;
    signal call_Loop_LB2D_buf_p_U0_ap_continue : STD_LOGIC;
    signal call_Loop_LB2D_buf_p_U0_ap_idle : STD_LOGIC;
    signal call_Loop_LB2D_buf_p_U0_start_out : STD_LOGIC;
    signal call_Loop_LB2D_buf_p_U0_start_write : STD_LOGIC;
    signal call_Loop_LB2D_buf_p_U0_in_stream_V_value_V_read : STD_LOGIC;
    signal call_Loop_LB2D_buf_p_U0_slice_stream_V_value_V_din : STD_LOGIC_VECTOR (95 downto 0);
    signal call_Loop_LB2D_buf_p_U0_slice_stream_V_value_V_write : STD_LOGIC;
    signal call_Loop_LB2D_shift_U0_ap_start : STD_LOGIC;
    signal call_Loop_LB2D_shift_U0_ap_done : STD_LOGIC;
    signal call_Loop_LB2D_shift_U0_ap_continue : STD_LOGIC;
    signal call_Loop_LB2D_shift_U0_ap_idle : STD_LOGIC;
    signal call_Loop_LB2D_shift_U0_ap_ready : STD_LOGIC;
    signal call_Loop_LB2D_shift_U0_slice_stream_V_value_V_read : STD_LOGIC;
    signal call_Loop_LB2D_shift_U0_out_stream_V_value_V_din : STD_LOGIC_VECTOR (287 downto 0);
    signal call_Loop_LB2D_shift_U0_out_stream_V_value_V_write : STD_LOGIC;
    signal ap_sync_continue : STD_LOGIC;
    signal slice_stream_V_value_full_n : STD_LOGIC;
    signal slice_stream_V_value_dout : STD_LOGIC_VECTOR (95 downto 0);
    signal slice_stream_V_value_empty_n : STD_LOGIC;
    signal ap_sync_done : STD_LOGIC;
    signal ap_sync_ready : STD_LOGIC;
    signal start_for_call_Loop_LB2D_shift_U0_din : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_call_Loop_LB2D_shift_U0_full_n : STD_LOGIC;
    signal start_for_call_Loop_LB2D_shift_U0_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_call_Loop_LB2D_shift_U0_empty_n : STD_LOGIC;
    signal call_Loop_LB2D_shift_U0_start_full_n : STD_LOGIC;
    signal call_Loop_LB2D_shift_U0_start_write : STD_LOGIC;

    component call_Loop_LB2D_buf_p IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        start_full_n : IN STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        start_out : OUT STD_LOGIC;
        start_write : OUT STD_LOGIC;
        in_stream_V_value_V_dout : IN STD_LOGIC_VECTOR (31 downto 0);
        in_stream_V_value_V_empty_n : IN STD_LOGIC;
        in_stream_V_value_V_read : OUT STD_LOGIC;
        slice_stream_V_value_V_din : OUT STD_LOGIC_VECTOR (95 downto 0);
        slice_stream_V_value_V_full_n : IN STD_LOGIC;
        slice_stream_V_value_V_write : OUT STD_LOGIC );
    end component;


    component call_Loop_LB2D_shift IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        slice_stream_V_value_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        slice_stream_V_value_V_empty_n : IN STD_LOGIC;
        slice_stream_V_value_V_read : OUT STD_LOGIC;
        out_stream_V_value_V_din : OUT STD_LOGIC_VECTOR (287 downto 0);
        out_stream_V_value_V_full_n : IN STD_LOGIC;
        out_stream_V_value_V_write : OUT STD_LOGIC );
    end component;


    component fifo_w96_d1_S IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (95 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (95 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component start_for_call_LodEe IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (0 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (0 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;



begin
    call_Loop_LB2D_buf_p_U0 : component call_Loop_LB2D_buf_p
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => call_Loop_LB2D_buf_p_U0_ap_start,
        start_full_n => call_Loop_LB2D_buf_p_U0_start_full_n,
        ap_ready => call_Loop_LB2D_buf_p_U0_ap_ready,
        ap_done => call_Loop_LB2D_buf_p_U0_ap_done,
        ap_continue => call_Loop_LB2D_buf_p_U0_ap_continue,
        ap_idle => call_Loop_LB2D_buf_p_U0_ap_idle,
        start_out => call_Loop_LB2D_buf_p_U0_start_out,
        start_write => call_Loop_LB2D_buf_p_U0_start_write,
        in_stream_V_value_V_dout => in_stream_V_value_V_dout,
        in_stream_V_value_V_empty_n => in_stream_V_value_V_empty_n,
        in_stream_V_value_V_read => call_Loop_LB2D_buf_p_U0_in_stream_V_value_V_read,
        slice_stream_V_value_V_din => call_Loop_LB2D_buf_p_U0_slice_stream_V_value_V_din,
        slice_stream_V_value_V_full_n => slice_stream_V_value_full_n,
        slice_stream_V_value_V_write => call_Loop_LB2D_buf_p_U0_slice_stream_V_value_V_write);

    call_Loop_LB2D_shift_U0 : component call_Loop_LB2D_shift
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => call_Loop_LB2D_shift_U0_ap_start,
        ap_done => call_Loop_LB2D_shift_U0_ap_done,
        ap_continue => call_Loop_LB2D_shift_U0_ap_continue,
        ap_idle => call_Loop_LB2D_shift_U0_ap_idle,
        ap_ready => call_Loop_LB2D_shift_U0_ap_ready,
        slice_stream_V_value_V_dout => slice_stream_V_value_dout,
        slice_stream_V_value_V_empty_n => slice_stream_V_value_empty_n,
        slice_stream_V_value_V_read => call_Loop_LB2D_shift_U0_slice_stream_V_value_V_read,
        out_stream_V_value_V_din => call_Loop_LB2D_shift_U0_out_stream_V_value_V_din,
        out_stream_V_value_V_full_n => out_stream_V_value_V_full_n,
        out_stream_V_value_V_write => call_Loop_LB2D_shift_U0_out_stream_V_value_V_write);

    slice_stream_V_value_U : component fifo_w96_d1_S
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => call_Loop_LB2D_buf_p_U0_slice_stream_V_value_V_din,
        if_full_n => slice_stream_V_value_full_n,
        if_write => call_Loop_LB2D_buf_p_U0_slice_stream_V_value_V_write,
        if_dout => slice_stream_V_value_dout,
        if_empty_n => slice_stream_V_value_empty_n,
        if_read => call_Loop_LB2D_shift_U0_slice_stream_V_value_V_read);

    start_for_call_LodEe_U : component start_for_call_LodEe
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => start_for_call_Loop_LB2D_shift_U0_din,
        if_full_n => start_for_call_Loop_LB2D_shift_U0_full_n,
        if_write => call_Loop_LB2D_buf_p_U0_start_write,
        if_dout => start_for_call_Loop_LB2D_shift_U0_dout,
        if_empty_n => start_for_call_Loop_LB2D_shift_U0_empty_n,
        if_read => call_Loop_LB2D_shift_U0_ap_ready);




    ap_done <= call_Loop_LB2D_shift_U0_ap_done;
    ap_idle <= (call_Loop_LB2D_buf_p_U0_ap_idle and call_Loop_LB2D_shift_U0_ap_idle);
    ap_ready <= call_Loop_LB2D_buf_p_U0_ap_ready;
    ap_sync_continue <= ap_continue;
    ap_sync_done <= call_Loop_LB2D_shift_U0_ap_done;
    ap_sync_ready <= call_Loop_LB2D_buf_p_U0_ap_ready;
    call_Loop_LB2D_buf_p_U0_ap_continue <= ap_const_logic_1;
    call_Loop_LB2D_buf_p_U0_ap_start <= ap_start;
    call_Loop_LB2D_buf_p_U0_start_full_n <= (ap_const_logic_0 or start_for_call_Loop_LB2D_shift_U0_full_n);
    call_Loop_LB2D_shift_U0_ap_continue <= ap_continue;
    call_Loop_LB2D_shift_U0_ap_start <= start_for_call_Loop_LB2D_shift_U0_empty_n;
    call_Loop_LB2D_shift_U0_start_full_n <= ap_const_logic_0;
    call_Loop_LB2D_shift_U0_start_write <= ap_const_logic_0;
    in_stream_V_value_V_read <= call_Loop_LB2D_buf_p_U0_in_stream_V_value_V_read;
    out_stream_V_value_V_din <= call_Loop_LB2D_shift_U0_out_stream_V_value_V_din;
    out_stream_V_value_V_write <= call_Loop_LB2D_shift_U0_out_stream_V_value_V_write;
    start_for_call_Loop_LB2D_shift_U0_din <= (0=>ap_const_logic_1, others=>'-');
end behav;