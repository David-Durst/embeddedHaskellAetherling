set moduleName Loop_2_proc
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set C_modelName {Loop_2_proc}
set C_modelType { void 0 }
set C_modelArgList {
	{ p_mul_stencil_stream_V_value_V int 128 regular {fifo 0 volatile }  }
	{ p_p2_mul1_stencil_stream_V_value_V int 32 regular {fifo 1 volatile }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "p_mul_stencil_stream_V_value_V", "interface" : "fifo", "bitwidth" : 128, "direction" : "READONLY"} , 
 	{ "Name" : "p_p2_mul1_stencil_stream_V_value_V", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 16
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ start_full_n sc_in sc_logic 1 signal -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ start_out sc_out sc_logic 1 signal -1 } 
	{ start_write sc_out sc_logic 1 signal -1 } 
	{ p_mul_stencil_stream_V_value_V_dout sc_in sc_lv 128 signal 0 } 
	{ p_mul_stencil_stream_V_value_V_empty_n sc_in sc_logic 1 signal 0 } 
	{ p_mul_stencil_stream_V_value_V_read sc_out sc_logic 1 signal 0 } 
	{ p_p2_mul1_stencil_stream_V_value_V_din sc_out sc_lv 32 signal 1 } 
	{ p_p2_mul1_stencil_stream_V_value_V_full_n sc_in sc_logic 1 signal 1 } 
	{ p_p2_mul1_stencil_stream_V_value_V_write sc_out sc_logic 1 signal 1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "start_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_full_n", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "start_out", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_out", "role": "default" }} , 
 	{ "name": "start_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_write", "role": "default" }} , 
 	{ "name": "p_mul_stencil_stream_V_value_V_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "p_mul_stencil_stream_V_value_V", "role": "dout" }} , 
 	{ "name": "p_mul_stencil_stream_V_value_V_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_mul_stencil_stream_V_value_V", "role": "empty_n" }} , 
 	{ "name": "p_mul_stencil_stream_V_value_V_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_mul_stencil_stream_V_value_V", "role": "read" }} , 
 	{ "name": "p_p2_mul1_stencil_stream_V_value_V_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "p_p2_mul1_stencil_stream_V_value_V", "role": "din" }} , 
 	{ "name": "p_p2_mul1_stencil_stream_V_value_V_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_p2_mul1_stencil_stream_V_value_V", "role": "full_n" }} , 
 	{ "name": "p_p2_mul1_stencil_stream_V_value_V_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "p_p2_mul1_stencil_stream_V_value_V", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
		"CDFG" : "Loop_2_proc",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"Port" : [
			{"Name" : "p_mul_stencil_stream_V_value_V", "Type" : "Fifo", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "p_mul_stencil_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_p2_mul1_stencil_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0",
				"BlockSignal" : [
					{"Name" : "p_p2_mul1_stencil_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_sitofphbi_U30", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_sitofphbi_U31", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_sitofphbi_U32", "Parent" : "0"},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_sitofphbi_U33", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_fpext_ibs_U34", "Parent" : "0"},
	{"ID" : "6", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_fpext_ibs_U35", "Parent" : "0"},
	{"ID" : "7", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_fpext_ibs_U36", "Parent" : "0"},
	{"ID" : "8", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_fpext_ibs_U37", "Parent" : "0"},
	{"ID" : "9", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_dmul_6jbC_U38", "Parent" : "0"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_dmul_6jbC_U39", "Parent" : "0"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_dmul_6jbC_U40", "Parent" : "0"},
	{"ID" : "12", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.hls_target_dmul_6jbC_U41", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	Loop_2_proc {
		p_mul_stencil_stream_V_value_V {Type I LastRead 2 FirstWrite -1}
		p_p2_mul1_stencil_stream_V_value_V {Type O LastRead -1 FirstWrite 28}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2064637", "Max" : "2064637"}
	, {"Name" : "Interval", "Min" : "2064637", "Max" : "2064637"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	p_mul_stencil_stream_V_value_V { ap_fifo {  { p_mul_stencil_stream_V_value_V_dout fifo_data 0 128 }  { p_mul_stencil_stream_V_value_V_empty_n fifo_status 0 1 }  { p_mul_stencil_stream_V_value_V_read fifo_update 1 1 } } }
	p_p2_mul1_stencil_stream_V_value_V { ap_fifo {  { p_p2_mul1_stencil_stream_V_value_V_din fifo_data 1 32 }  { p_p2_mul1_stencil_stream_V_value_V_full_n fifo_status 0 1 }  { p_p2_mul1_stencil_stream_V_value_V_write fifo_update 1 1 } } }
}
