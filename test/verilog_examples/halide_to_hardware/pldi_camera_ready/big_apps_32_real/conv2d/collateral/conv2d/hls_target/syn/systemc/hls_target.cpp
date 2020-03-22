// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2017.2
// Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

#include "hls_target.h"
#include "AESL_pkg.h"

using namespace std;

namespace ap_rtl {

const sc_lv<32> hls_target::ap_const_lv32_0 = "00000000000000000000000000000000";
const sc_lv<1> hls_target::ap_const_lv1_0 = "0";
const sc_logic hls_target::ap_const_logic_1 = sc_dt::Log_1;
const sc_logic hls_target::ap_const_logic_0 = sc_dt::Log_0;

hls_target::hls_target(sc_module_name name) : sc_module(name), mVcdFile(0) {
    linebuffer_1_U0 = new linebuffer_1("linebuffer_1_U0");
    linebuffer_1_U0->ap_start(linebuffer_1_U0_ap_start);
    linebuffer_1_U0->start_full_n(linebuffer_1_U0_start_full_n);
    linebuffer_1_U0->ap_ready(linebuffer_1_U0_ap_ready);
    linebuffer_1_U0->start_out(linebuffer_1_U0_start_out);
    linebuffer_1_U0->start_write(linebuffer_1_U0_start_write);
    linebuffer_1_U0->in_axi_stream_V_value_V(hw_input_V_value_V);
    linebuffer_1_U0->in_axi_stream_V_last_V(hw_input_V_last_V);
    linebuffer_1_U0->out_stream_V_value_V_din(linebuffer_1_U0_out_stream_V_value_V_din);
    linebuffer_1_U0->out_stream_V_value_V_full_n(p_hw_input_stencil_st_full_n);
    linebuffer_1_U0->out_stream_V_value_V_write(linebuffer_1_U0_out_stream_V_value_V_write);
    linebuffer_1_U0->ap_clk(ap_clk);
    linebuffer_1_U0->ap_rst(ap_rst);
    linebuffer_1_U0->in_axi_stream_V_value_V_ap_vld(hw_input_V_value_V_ap_vld);
    linebuffer_1_U0->in_axi_stream_V_value_V_ap_ack(linebuffer_1_U0_in_axi_stream_V_value_V_ap_ack);
    linebuffer_1_U0->in_axi_stream_V_last_V_ap_vld(hw_input_V_last_V_ap_vld);
    linebuffer_1_U0->in_axi_stream_V_last_V_ap_ack(linebuffer_1_U0_in_axi_stream_V_last_V_ap_ack);
    linebuffer_1_U0->ap_done(linebuffer_1_U0_ap_done);
    linebuffer_1_U0->ap_idle(linebuffer_1_U0_ap_idle);
    linebuffer_1_U0->ap_continue(linebuffer_1_U0_ap_continue);
    Loop_1_proc_U0 = new Loop_1_proc("Loop_1_proc_U0");
    Loop_1_proc_U0->ap_clk(ap_clk);
    Loop_1_proc_U0->ap_rst(ap_rst);
    Loop_1_proc_U0->ap_start(Loop_1_proc_U0_ap_start);
    Loop_1_proc_U0->ap_done(Loop_1_proc_U0_ap_done);
    Loop_1_proc_U0->ap_continue(Loop_1_proc_U0_ap_continue);
    Loop_1_proc_U0->ap_idle(Loop_1_proc_U0_ap_idle);
    Loop_1_proc_U0->ap_ready(Loop_1_proc_U0_ap_ready);
    Loop_1_proc_U0->p_hw_input_stencil_stream_V_value_V_dout(p_hw_input_stencil_st_dout);
    Loop_1_proc_U0->p_hw_input_stencil_stream_V_value_V_empty_n(p_hw_input_stencil_st_empty_n);
    Loop_1_proc_U0->p_hw_input_stencil_stream_V_value_V_read(Loop_1_proc_U0_p_hw_input_stencil_stream_V_value_V_read);
    Loop_1_proc_U0->hw_output_V_value_V(Loop_1_proc_U0_hw_output_V_value_V);
    Loop_1_proc_U0->hw_output_V_value_V_ap_vld(Loop_1_proc_U0_hw_output_V_value_V_ap_vld);
    Loop_1_proc_U0->hw_output_V_value_V_ap_ack(hw_output_V_value_V_ap_ack);
    Loop_1_proc_U0->hw_output_V_last_V(Loop_1_proc_U0_hw_output_V_last_V);
    Loop_1_proc_U0->hw_output_V_last_V_ap_vld(Loop_1_proc_U0_hw_output_V_last_V_ap_vld);
    Loop_1_proc_U0->hw_output_V_last_V_ap_ack(hw_output_V_last_V_ap_ack);
    p_hw_input_stencil_st_U = new fifo_w288_d1_S("p_hw_input_stencil_st_U");
    p_hw_input_stencil_st_U->clk(ap_clk);
    p_hw_input_stencil_st_U->reset(ap_rst);
    p_hw_input_stencil_st_U->if_read_ce(ap_var_for_const0);
    p_hw_input_stencil_st_U->if_write_ce(ap_var_for_const0);
    p_hw_input_stencil_st_U->if_din(linebuffer_1_U0_out_stream_V_value_V_din);
    p_hw_input_stencil_st_U->if_full_n(p_hw_input_stencil_st_full_n);
    p_hw_input_stencil_st_U->if_write(linebuffer_1_U0_out_stream_V_value_V_write);
    p_hw_input_stencil_st_U->if_dout(p_hw_input_stencil_st_dout);
    p_hw_input_stencil_st_U->if_empty_n(p_hw_input_stencil_st_empty_n);
    p_hw_input_stencil_st_U->if_read(Loop_1_proc_U0_p_hw_input_stencil_stream_V_value_V_read);
    start_for_Loop_1_ibs_U = new start_for_Loop_1_ibs("start_for_Loop_1_ibs_U");
    start_for_Loop_1_ibs_U->clk(ap_clk);
    start_for_Loop_1_ibs_U->reset(ap_rst);
    start_for_Loop_1_ibs_U->if_read_ce(ap_var_for_const0);
    start_for_Loop_1_ibs_U->if_write_ce(ap_var_for_const0);
    start_for_Loop_1_ibs_U->if_din(start_for_Loop_1_proc_U0_din);
    start_for_Loop_1_ibs_U->if_full_n(start_for_Loop_1_proc_U0_full_n);
    start_for_Loop_1_ibs_U->if_write(linebuffer_1_U0_start_write);
    start_for_Loop_1_ibs_U->if_dout(start_for_Loop_1_proc_U0_dout);
    start_for_Loop_1_ibs_U->if_empty_n(start_for_Loop_1_proc_U0_empty_n);
    start_for_Loop_1_ibs_U->if_read(Loop_1_proc_U0_ap_ready);

    SC_METHOD(thread_Loop_1_proc_U0_ap_continue);

    SC_METHOD(thread_Loop_1_proc_U0_ap_start);
    sensitive << ( start_for_Loop_1_proc_U0_empty_n );

    SC_METHOD(thread_Loop_1_proc_U0_start_full_n);

    SC_METHOD(thread_Loop_1_proc_U0_start_write);

    SC_METHOD(thread_ap_done);
    sensitive << ( Loop_1_proc_U0_ap_done );

    SC_METHOD(thread_ap_idle);
    sensitive << ( linebuffer_1_U0_ap_idle );
    sensitive << ( Loop_1_proc_U0_ap_idle );

    SC_METHOD(thread_ap_ready);
    sensitive << ( linebuffer_1_U0_ap_ready );

    SC_METHOD(thread_ap_sync_continue);

    SC_METHOD(thread_ap_sync_done);
    sensitive << ( Loop_1_proc_U0_ap_done );

    SC_METHOD(thread_ap_sync_ready);
    sensitive << ( linebuffer_1_U0_ap_ready );

    SC_METHOD(thread_hw_input_V_last_V_ap_ack);
    sensitive << ( linebuffer_1_U0_in_axi_stream_V_last_V_ap_ack );

    SC_METHOD(thread_hw_input_V_value_V_ap_ack);
    sensitive << ( linebuffer_1_U0_in_axi_stream_V_value_V_ap_ack );

    SC_METHOD(thread_hw_output_V_last_V);
    sensitive << ( Loop_1_proc_U0_hw_output_V_last_V );

    SC_METHOD(thread_hw_output_V_last_V_ap_vld);
    sensitive << ( Loop_1_proc_U0_hw_output_V_last_V_ap_vld );

    SC_METHOD(thread_hw_output_V_value_V);
    sensitive << ( Loop_1_proc_U0_hw_output_V_value_V );

    SC_METHOD(thread_hw_output_V_value_V_ap_vld);
    sensitive << ( Loop_1_proc_U0_hw_output_V_value_V_ap_vld );

    SC_METHOD(thread_linebuffer_1_U0_ap_continue);

    SC_METHOD(thread_linebuffer_1_U0_ap_start);
    sensitive << ( ap_start );

    SC_METHOD(thread_linebuffer_1_U0_start_full_n);
    sensitive << ( start_for_Loop_1_proc_U0_full_n );

    SC_METHOD(thread_start_for_Loop_1_proc_U0_din);

    SC_THREAD(thread_hdltv_gen);
    sensitive << ( ap_clk.pos() );

    SC_THREAD(thread_ap_var_for_const0);

    static int apTFileNum = 0;
    stringstream apTFilenSS;
    apTFilenSS << "hls_target_sc_trace_" << apTFileNum ++;
    string apTFn = apTFilenSS.str();
    mVcdFile = sc_create_vcd_trace_file(apTFn.c_str());
    mVcdFile->set_time_unit(1, SC_PS);
    if (1) {
#ifdef __HLS_TRACE_LEVEL_PORT__
    sc_trace(mVcdFile, hw_input_V_value_V, "(port)hw_input_V_value_V");
    sc_trace(mVcdFile, hw_input_V_last_V, "(port)hw_input_V_last_V");
    sc_trace(mVcdFile, hw_output_V_value_V, "(port)hw_output_V_value_V");
    sc_trace(mVcdFile, hw_output_V_last_V, "(port)hw_output_V_last_V");
    sc_trace(mVcdFile, ap_clk, "(port)ap_clk");
    sc_trace(mVcdFile, ap_rst, "(port)ap_rst");
    sc_trace(mVcdFile, hw_input_V_value_V_ap_vld, "(port)hw_input_V_value_V_ap_vld");
    sc_trace(mVcdFile, hw_input_V_value_V_ap_ack, "(port)hw_input_V_value_V_ap_ack");
    sc_trace(mVcdFile, hw_input_V_last_V_ap_vld, "(port)hw_input_V_last_V_ap_vld");
    sc_trace(mVcdFile, hw_input_V_last_V_ap_ack, "(port)hw_input_V_last_V_ap_ack");
    sc_trace(mVcdFile, hw_output_V_value_V_ap_vld, "(port)hw_output_V_value_V_ap_vld");
    sc_trace(mVcdFile, hw_output_V_value_V_ap_ack, "(port)hw_output_V_value_V_ap_ack");
    sc_trace(mVcdFile, hw_output_V_last_V_ap_vld, "(port)hw_output_V_last_V_ap_vld");
    sc_trace(mVcdFile, hw_output_V_last_V_ap_ack, "(port)hw_output_V_last_V_ap_ack");
    sc_trace(mVcdFile, ap_done, "(port)ap_done");
    sc_trace(mVcdFile, ap_start, "(port)ap_start");
    sc_trace(mVcdFile, ap_ready, "(port)ap_ready");
    sc_trace(mVcdFile, ap_idle, "(port)ap_idle");
#endif
#ifdef __HLS_TRACE_LEVEL_INT__
    sc_trace(mVcdFile, linebuffer_1_U0_ap_start, "linebuffer_1_U0_ap_start");
    sc_trace(mVcdFile, linebuffer_1_U0_start_full_n, "linebuffer_1_U0_start_full_n");
    sc_trace(mVcdFile, linebuffer_1_U0_ap_ready, "linebuffer_1_U0_ap_ready");
    sc_trace(mVcdFile, linebuffer_1_U0_start_out, "linebuffer_1_U0_start_out");
    sc_trace(mVcdFile, linebuffer_1_U0_start_write, "linebuffer_1_U0_start_write");
    sc_trace(mVcdFile, linebuffer_1_U0_out_stream_V_value_V_din, "linebuffer_1_U0_out_stream_V_value_V_din");
    sc_trace(mVcdFile, linebuffer_1_U0_out_stream_V_value_V_write, "linebuffer_1_U0_out_stream_V_value_V_write");
    sc_trace(mVcdFile, linebuffer_1_U0_in_axi_stream_V_value_V_ap_ack, "linebuffer_1_U0_in_axi_stream_V_value_V_ap_ack");
    sc_trace(mVcdFile, linebuffer_1_U0_in_axi_stream_V_last_V_ap_ack, "linebuffer_1_U0_in_axi_stream_V_last_V_ap_ack");
    sc_trace(mVcdFile, linebuffer_1_U0_ap_done, "linebuffer_1_U0_ap_done");
    sc_trace(mVcdFile, linebuffer_1_U0_ap_idle, "linebuffer_1_U0_ap_idle");
    sc_trace(mVcdFile, linebuffer_1_U0_ap_continue, "linebuffer_1_U0_ap_continue");
    sc_trace(mVcdFile, Loop_1_proc_U0_ap_start, "Loop_1_proc_U0_ap_start");
    sc_trace(mVcdFile, Loop_1_proc_U0_ap_done, "Loop_1_proc_U0_ap_done");
    sc_trace(mVcdFile, Loop_1_proc_U0_ap_continue, "Loop_1_proc_U0_ap_continue");
    sc_trace(mVcdFile, Loop_1_proc_U0_ap_idle, "Loop_1_proc_U0_ap_idle");
    sc_trace(mVcdFile, Loop_1_proc_U0_ap_ready, "Loop_1_proc_U0_ap_ready");
    sc_trace(mVcdFile, Loop_1_proc_U0_p_hw_input_stencil_stream_V_value_V_read, "Loop_1_proc_U0_p_hw_input_stencil_stream_V_value_V_read");
    sc_trace(mVcdFile, Loop_1_proc_U0_hw_output_V_value_V, "Loop_1_proc_U0_hw_output_V_value_V");
    sc_trace(mVcdFile, Loop_1_proc_U0_hw_output_V_value_V_ap_vld, "Loop_1_proc_U0_hw_output_V_value_V_ap_vld");
    sc_trace(mVcdFile, Loop_1_proc_U0_hw_output_V_last_V, "Loop_1_proc_U0_hw_output_V_last_V");
    sc_trace(mVcdFile, Loop_1_proc_U0_hw_output_V_last_V_ap_vld, "Loop_1_proc_U0_hw_output_V_last_V_ap_vld");
    sc_trace(mVcdFile, ap_sync_continue, "ap_sync_continue");
    sc_trace(mVcdFile, p_hw_input_stencil_st_full_n, "p_hw_input_stencil_st_full_n");
    sc_trace(mVcdFile, p_hw_input_stencil_st_dout, "p_hw_input_stencil_st_dout");
    sc_trace(mVcdFile, p_hw_input_stencil_st_empty_n, "p_hw_input_stencil_st_empty_n");
    sc_trace(mVcdFile, ap_sync_done, "ap_sync_done");
    sc_trace(mVcdFile, ap_sync_ready, "ap_sync_ready");
    sc_trace(mVcdFile, start_for_Loop_1_proc_U0_din, "start_for_Loop_1_proc_U0_din");
    sc_trace(mVcdFile, start_for_Loop_1_proc_U0_full_n, "start_for_Loop_1_proc_U0_full_n");
    sc_trace(mVcdFile, start_for_Loop_1_proc_U0_dout, "start_for_Loop_1_proc_U0_dout");
    sc_trace(mVcdFile, start_for_Loop_1_proc_U0_empty_n, "start_for_Loop_1_proc_U0_empty_n");
    sc_trace(mVcdFile, Loop_1_proc_U0_start_full_n, "Loop_1_proc_U0_start_full_n");
    sc_trace(mVcdFile, Loop_1_proc_U0_start_write, "Loop_1_proc_U0_start_write");
#endif

    }
    mHdltvinHandle.open("hls_target.hdltvin.dat");
    mHdltvoutHandle.open("hls_target.hdltvout.dat");
}

hls_target::~hls_target() {
    if (mVcdFile) 
        sc_close_vcd_trace_file(mVcdFile);

    mHdltvinHandle << "] " << endl;
    mHdltvoutHandle << "] " << endl;
    mHdltvinHandle.close();
    mHdltvoutHandle.close();
    delete linebuffer_1_U0;
    delete Loop_1_proc_U0;
    delete p_hw_input_stencil_st_U;
    delete start_for_Loop_1_ibs_U;
}

void hls_target::thread_ap_var_for_const0() {
    ap_var_for_const0 = ap_const_logic_1;
}

void hls_target::thread_Loop_1_proc_U0_ap_continue() {
    Loop_1_proc_U0_ap_continue = ap_const_logic_1;
}

void hls_target::thread_Loop_1_proc_U0_ap_start() {
    Loop_1_proc_U0_ap_start = start_for_Loop_1_proc_U0_empty_n.read();
}

void hls_target::thread_Loop_1_proc_U0_start_full_n() {
    Loop_1_proc_U0_start_full_n = ap_const_logic_0;
}

void hls_target::thread_Loop_1_proc_U0_start_write() {
    Loop_1_proc_U0_start_write = ap_const_logic_0;
}

void hls_target::thread_ap_done() {
    ap_done = Loop_1_proc_U0_ap_done.read();
}

void hls_target::thread_ap_idle() {
    ap_idle = (linebuffer_1_U0_ap_idle.read() & Loop_1_proc_U0_ap_idle.read());
}

void hls_target::thread_ap_ready() {
    ap_ready = linebuffer_1_U0_ap_ready.read();
}

void hls_target::thread_ap_sync_continue() {
    ap_sync_continue = ap_const_logic_1;
}

void hls_target::thread_ap_sync_done() {
    ap_sync_done = Loop_1_proc_U0_ap_done.read();
}

void hls_target::thread_ap_sync_ready() {
    ap_sync_ready = linebuffer_1_U0_ap_ready.read();
}

void hls_target::thread_hw_input_V_last_V_ap_ack() {
    hw_input_V_last_V_ap_ack = linebuffer_1_U0_in_axi_stream_V_last_V_ap_ack.read();
}

void hls_target::thread_hw_input_V_value_V_ap_ack() {
    hw_input_V_value_V_ap_ack = linebuffer_1_U0_in_axi_stream_V_value_V_ap_ack.read();
}

void hls_target::thread_hw_output_V_last_V() {
    hw_output_V_last_V = Loop_1_proc_U0_hw_output_V_last_V.read();
}

void hls_target::thread_hw_output_V_last_V_ap_vld() {
    hw_output_V_last_V_ap_vld = Loop_1_proc_U0_hw_output_V_last_V_ap_vld.read();
}

void hls_target::thread_hw_output_V_value_V() {
    hw_output_V_value_V = Loop_1_proc_U0_hw_output_V_value_V.read();
}

void hls_target::thread_hw_output_V_value_V_ap_vld() {
    hw_output_V_value_V_ap_vld = Loop_1_proc_U0_hw_output_V_value_V_ap_vld.read();
}

void hls_target::thread_linebuffer_1_U0_ap_continue() {
    linebuffer_1_U0_ap_continue = ap_const_logic_1;
}

void hls_target::thread_linebuffer_1_U0_ap_start() {
    linebuffer_1_U0_ap_start = ap_start.read();
}

void hls_target::thread_linebuffer_1_U0_start_full_n() {
    linebuffer_1_U0_start_full_n = (start_for_Loop_1_proc_U0_full_n.read() | ap_const_logic_0);
}

void hls_target::thread_start_for_Loop_1_proc_U0_din() {
    start_for_Loop_1_proc_U0_din =  (sc_lv<1>) (ap_const_logic_1);
}

void hls_target::thread_hdltv_gen() {
    const char* dump_tv = std::getenv("AP_WRITE_TV");
    if (!(dump_tv && string(dump_tv) == "on")) return;

    wait();

    mHdltvinHandle << "[ " << endl;
    mHdltvoutHandle << "[ " << endl;
    int ap_cycleNo = 0;
    while (1) {
        wait();
        const char* mComma = ap_cycleNo == 0 ? " " : ", " ;
        mHdltvinHandle << mComma << "{"  <<  " \"hw_input_V_value_V\" :  \"" << hw_input_V_value_V.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"hw_input_V_last_V\" :  \"" << hw_input_V_last_V.read() << "\" ";
        mHdltvoutHandle << mComma << "{"  <<  " \"hw_output_V_value_V\" :  \"" << hw_output_V_value_V.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"hw_output_V_last_V\" :  \"" << hw_output_V_last_V.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"ap_rst\" :  \"" << ap_rst.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"hw_input_V_value_V_ap_vld\" :  \"" << hw_input_V_value_V_ap_vld.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"hw_input_V_value_V_ap_ack\" :  \"" << hw_input_V_value_V_ap_ack.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"hw_input_V_last_V_ap_vld\" :  \"" << hw_input_V_last_V_ap_vld.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"hw_input_V_last_V_ap_ack\" :  \"" << hw_input_V_last_V_ap_ack.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"hw_output_V_value_V_ap_vld\" :  \"" << hw_output_V_value_V_ap_vld.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"hw_output_V_value_V_ap_ack\" :  \"" << hw_output_V_value_V_ap_ack.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"hw_output_V_last_V_ap_vld\" :  \"" << hw_output_V_last_V_ap_vld.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"hw_output_V_last_V_ap_ack\" :  \"" << hw_output_V_last_V_ap_ack.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"ap_done\" :  \"" << ap_done.read() << "\" ";
        mHdltvinHandle << " , " <<  " \"ap_start\" :  \"" << ap_start.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"ap_ready\" :  \"" << ap_ready.read() << "\" ";
        mHdltvoutHandle << " , " <<  " \"ap_idle\" :  \"" << ap_idle.read() << "\" ";
        mHdltvinHandle << "}" << std::endl;
        mHdltvoutHandle << "}" << std::endl;
        ap_cycleNo++;
    }
}

}

