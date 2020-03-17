set moduleName call_1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type dataflow
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set C_modelName {call.1}
set C_modelType { void 0 }
set C_modelArgList {
	{ in_stream_V_value_V int 32 regular {fifo 0 volatile }  }
	{ out_stream_V_value_V int 128 regular {fifo 1 volatile }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "in_stream_V_value_V", "interface" : "fifo", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "out_stream_V_value_V", "interface" : "fifo", "bitwidth" : 128, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 13
set portList { 
	{ in_stream_V_value_V_dout sc_in sc_lv 32 signal 0 } 
	{ in_stream_V_value_V_empty_n sc_in sc_logic 1 signal 0 } 
	{ in_stream_V_value_V_read sc_out sc_logic 1 signal 0 } 
	{ out_stream_V_value_V_din sc_out sc_lv 128 signal 1 } 
	{ out_stream_V_value_V_full_n sc_in sc_logic 1 signal 1 } 
	{ out_stream_V_value_V_write sc_out sc_logic 1 signal 1 } 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
}
set NewPortList {[ 
	{ "name": "in_stream_V_value_V_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_stream_V_value_V", "role": "dout" }} , 
 	{ "name": "in_stream_V_value_V_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_stream_V_value_V", "role": "empty_n" }} , 
 	{ "name": "in_stream_V_value_V_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_stream_V_value_V", "role": "read" }} , 
 	{ "name": "out_stream_V_value_V_din", "direction": "out", "datatype": "sc_lv", "bitwidth":128, "type": "signal", "bundle":{"name": "out_stream_V_value_V", "role": "din" }} , 
 	{ "name": "out_stream_V_value_V_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "out_stream_V_value_V", "role": "full_n" }} , 
 	{ "name": "out_stream_V_value_V_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "out_stream_V_value_V", "role": "write" }} , 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "3", "4", "5"],
		"CDFG" : "call_1",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "Dataflow", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"InputProcess" : [
			{"ID" : "1", "Name" : "call_Loop_LB2D_buf_p_1_U0"}],
		"OutputProcess" : [
			{"ID" : "3", "Name" : "call_Loop_LB2D_shift_1_U0"}],
		"Port" : [
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "call_Loop_LB2D_buf_p_1_U0", "Port" : "in_stream_V_value_V"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_Loop_LB2D_shift_1_U0", "Port" : "out_stream_V_value_V"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.call_Loop_LB2D_buf_p_1_U0", "Parent" : "0", "Child" : ["2"],
		"CDFG" : "call_Loop_LB2D_buf_p_1",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"DependenceCheck" : [
			{"FromInitialState" : "ap_enable_state5_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_40", "FromInitialSV" : "4", "FromFinalState" : "ap_enable_state5_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_40", "FromFinalSV" : "4", "FromAddress" : "buffer_0_value_V_address1", "ToInitialState" : "ap_enable_state3_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialOperation" : "ap_enable_operation_30", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state4_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_32", "ToFinalSV" : "3", "ToAddress" : "buffer_0_value_V_address0", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "11", "II" : "1", "Pragma" : "(../../../lib_files/Linebuffer.h:180:1)"}],
		"Port" : [
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "0", "DependentChan" : "0",
				"BlockSignal" : [
					{"Name" : "in_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "slice_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "3", "DependentChan" : "4",
				"BlockSignal" : [
					{"Name" : "slice_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.call_Loop_LB2D_buf_p_1_U0.buffer_0_value_V_U", "Parent" : "1"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.call_Loop_LB2D_shift_1_U0", "Parent" : "0",
		"CDFG" : "call_Loop_LB2D_shift_1",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"StartSource" : "1",
		"StartFifo" : "start_for_call_Log8j_U",
		"Port" : [
			{"Name" : "slice_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "1", "DependentChan" : "4",
				"BlockSignal" : [
					{"Name" : "slice_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0",
				"BlockSignal" : [
					{"Name" : "out_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.slice_stream_V_value_U", "Parent" : "0"},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_call_Log8j_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	call_1 {
		in_stream_V_value_V {Type I LastRead 3 FirstWrite -1}
		out_stream_V_value_V {Type O LastRead -1 FirstWrite 3}}
	call_Loop_LB2D_buf_p_1 {
		in_stream_V_value_V {Type I LastRead 3 FirstWrite -1}
		slice_stream_V_value_V {Type O LastRead -1 FirstWrite 4}}
	call_Loop_LB2D_shift_1 {
		slice_stream_V_value_V {Type I LastRead 3 FirstWrite -1}
		out_stream_V_value_V {Type O LastRead -1 FirstWrite 3}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2071917", "Max" : "2071917"}
	, {"Name" : "Interval", "Min" : "2071918", "Max" : "2071918"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	in_stream_V_value_V { ap_fifo {  { in_stream_V_value_V_dout fifo_data 0 32 }  { in_stream_V_value_V_empty_n fifo_status 0 1 }  { in_stream_V_value_V_read fifo_update 1 1 } } }
	out_stream_V_value_V { ap_fifo {  { out_stream_V_value_V_din fifo_data 1 128 }  { out_stream_V_value_V_full_n fifo_status 0 1 }  { out_stream_V_value_V_write fifo_update 1 1 } } }
}
