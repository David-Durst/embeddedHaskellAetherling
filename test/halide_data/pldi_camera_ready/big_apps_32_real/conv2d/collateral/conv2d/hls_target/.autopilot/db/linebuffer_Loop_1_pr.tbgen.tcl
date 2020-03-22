set moduleName linebuffer_Loop_1_pr
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set C_modelName {linebuffer_Loop_1_pr}
set C_modelType { void 0 }
set C_modelArgList {
	{ in_axi_stream_V_value_V int 32 regular {pointer 0 volatile }  }
	{ in_axi_stream_V_last_V int 1 regular {pointer 0 volatile }  }
	{ in_stream_V_value_V int 32 regular {fifo 1 volatile }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "in_axi_stream_V_value_V", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_axi_stream_V_last_V", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "in_stream_V_value_V", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 19
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
	{ in_axi_stream_V_value_V sc_in sc_lv 32 signal 0 } 
	{ in_axi_stream_V_value_V_ap_vld sc_in sc_logic 1 invld 0 } 
	{ in_axi_stream_V_value_V_ap_ack sc_out sc_logic 1 inacc 0 } 
	{ in_axi_stream_V_last_V sc_in sc_lv 1 signal 1 } 
	{ in_axi_stream_V_last_V_ap_vld sc_in sc_logic 1 invld 1 } 
	{ in_axi_stream_V_last_V_ap_ack sc_out sc_logic 1 inacc 1 } 
	{ in_stream_V_value_V_din sc_out sc_lv 32 signal 2 } 
	{ in_stream_V_value_V_full_n sc_in sc_logic 1 signal 2 } 
	{ in_stream_V_value_V_write sc_out sc_logic 1 signal 2 } 
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
 	{ "name": "in_axi_stream_V_value_V", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_axi_stream_V_value_V", "role": "default" }} , 
 	{ "name": "in_axi_stream_V_value_V_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_axi_stream_V_value_V", "role": "ap_vld" }} , 
 	{ "name": "in_axi_stream_V_value_V_ap_ack", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_axi_stream_V_value_V", "role": "ap_ack" }} , 
 	{ "name": "in_axi_stream_V_last_V", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_axi_stream_V_last_V", "role": "default" }} , 
 	{ "name": "in_axi_stream_V_last_V_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_axi_stream_V_last_V", "role": "ap_vld" }} , 
 	{ "name": "in_axi_stream_V_last_V_ap_ack", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_axi_stream_V_last_V", "role": "ap_ack" }} , 
 	{ "name": "in_stream_V_value_V_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_stream_V_value_V", "role": "din" }} , 
 	{ "name": "in_stream_V_value_V_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_stream_V_value_V", "role": "full_n" }} , 
 	{ "name": "in_stream_V_value_V_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_stream_V_value_V", "role": "write" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "",
		"CDFG" : "linebuffer_Loop_1_pr",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"Port" : [
			{"Name" : "in_axi_stream_V_value_V", "Type" : "HS", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "in_axi_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "in_axi_stream_V_last_V", "Type" : "HS", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "in_axi_stream_V_last_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0",
				"BlockSignal" : [
					{"Name" : "in_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]}]}


set ArgLastReadFirstWriteLatency {
	linebuffer_Loop_1_pr {
		in_axi_stream_V_value_V {Type I LastRead 1 FirstWrite -1}
		in_axi_stream_V_last_V {Type I LastRead 1 FirstWrite -1}
		in_stream_V_value_V {Type O LastRead -1 FirstWrite 2}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2073602", "Max" : "2073602"}
	, {"Name" : "Interval", "Min" : "2073602", "Max" : "2073602"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	in_axi_stream_V_value_V { ap_hs {  { in_axi_stream_V_value_V in_data 0 32 }  { in_axi_stream_V_value_V_ap_vld in_vld 0 1 }  { in_axi_stream_V_value_V_ap_ack in_acc 1 1 } } }
	in_axi_stream_V_last_V { ap_hs {  { in_axi_stream_V_last_V in_data 0 1 }  { in_axi_stream_V_last_V_ap_vld in_vld 0 1 }  { in_axi_stream_V_last_V_ap_ack in_acc 1 1 } } }
	in_stream_V_value_V { ap_fifo {  { in_stream_V_value_V_din fifo_data 1 32 }  { in_stream_V_value_V_full_n fifo_status 0 1 }  { in_stream_V_value_V_write fifo_update 1 1 } } }
}
