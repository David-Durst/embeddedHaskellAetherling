set moduleName linebuffer_1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type dataflow
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set C_modelName {linebuffer.1}
set C_modelType { void 0 }
set C_modelArgList {
	{ in_axi_stream_V_value_V int 32 regular {pointer 0 volatile }  }
	{ in_axi_stream_V_last_V int 1 regular {pointer 0 volatile }  }
	{ out_stream_V_value_V int 288 regular {fifo 1 volatile }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "in_axi_stream_V_value_V", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_axi_stream_V_last_V", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "out_stream_V_value_V", "interface" : "fifo", "bitwidth" : 288, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 19
set portList { 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ start_full_n sc_in sc_logic 1 signal -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ start_out sc_out sc_logic 1 signal -1 } 
	{ start_write sc_out sc_logic 1 signal -1 } 
	{ in_axi_stream_V_value_V sc_in sc_lv 32 signal 0 } 
	{ in_axi_stream_V_last_V sc_in sc_lv 1 signal 1 } 
	{ out_stream_V_value_V_din sc_out sc_lv 288 signal 2 } 
	{ out_stream_V_value_V_full_n sc_in sc_logic 1 signal 2 } 
	{ out_stream_V_value_V_write sc_out sc_logic 1 signal 2 } 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ in_axi_stream_V_value_V_ap_vld sc_in sc_logic 1 invld 0 } 
	{ in_axi_stream_V_value_V_ap_ack sc_out sc_logic 1 inacc 0 } 
	{ in_axi_stream_V_last_V_ap_vld sc_in sc_logic 1 invld 1 } 
	{ in_axi_stream_V_last_V_ap_ack sc_out sc_logic 1 inacc 1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
}
set NewPortList {[ 
	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "start_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_full_n", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "start_out", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_out", "role": "default" }} , 
 	{ "name": "start_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_write", "role": "default" }} , 
 	{ "name": "in_axi_stream_V_value_V", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_axi_stream_V_value_V", "role": "default" }} , 
 	{ "name": "in_axi_stream_V_last_V", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_axi_stream_V_last_V", "role": "default" }} , 
 	{ "name": "out_stream_V_value_V_din", "direction": "out", "datatype": "sc_lv", "bitwidth":288, "type": "signal", "bundle":{"name": "out_stream_V_value_V", "role": "din" }} , 
 	{ "name": "out_stream_V_value_V_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "out_stream_V_value_V", "role": "full_n" }} , 
 	{ "name": "out_stream_V_value_V_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "out_stream_V_value_V", "role": "write" }} , 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "in_axi_stream_V_value_V_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_axi_stream_V_value_V", "role": "ap_vld" }} , 
 	{ "name": "in_axi_stream_V_value_V_ap_ack", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_axi_stream_V_value_V", "role": "ap_ack" }} , 
 	{ "name": "in_axi_stream_V_last_V_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_axi_stream_V_last_V", "role": "ap_vld" }} , 
 	{ "name": "in_axi_stream_V_last_V_ap_ack", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_axi_stream_V_last_V", "role": "ap_ack" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "10", "11"],
		"CDFG" : "linebuffer_1",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "Dataflow", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"InputProcess" : [
			{"ID" : "1", "Name" : "linebuffer_Loop_1_pr_U0"}],
		"OutputProcess" : [
			{"ID" : "2", "Name" : "linebuffer_U0"}],
		"Port" : [
			{"Name" : "in_axi_stream_V_value_V", "Type" : "HS", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "linebuffer_Loop_1_pr_U0", "Port" : "in_axi_stream_V_value_V"}]},
			{"Name" : "in_axi_stream_V_last_V", "Type" : "HS", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "linebuffer_Loop_1_pr_U0", "Port" : "in_axi_stream_V_last_V"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "linebuffer_U0", "Port" : "out_stream_V_value_V"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.linebuffer_Loop_1_pr_U0", "Parent" : "0",
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
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "4", "DependentChan" : "10",
				"BlockSignal" : [
					{"Name" : "in_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.linebuffer_U0", "Parent" : "0", "Child" : ["3"],
		"CDFG" : "linebuffer",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "Dataflow", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"StartSource" : "1",
		"StartFifo" : "start_for_linebufeOg_U",
		"InputProcess" : [
			{"ID" : "3", "Name" : "call_U0"}],
		"OutputProcess" : [
			{"ID" : "3", "Name" : "call_U0"}],
		"Port" : [
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "1", "DependentChan" : "10",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_U0", "Port" : "in_stream_V_value_V"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "call_U0", "Port" : "out_stream_V_value_V"}]}]},
	{"ID" : "3", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.linebuffer_U0.call_U0", "Parent" : "2", "Child" : ["4", "7", "8", "9"],
		"CDFG" : "call",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "Dataflow", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"InputProcess" : [
			{"ID" : "4", "Name" : "call_Loop_LB2D_buf_p_U0"}],
		"OutputProcess" : [
			{"ID" : "7", "Name" : "call_Loop_LB2D_shift_U0"}],
		"Port" : [
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "1", "DependentChan" : "10",
				"SubConnect" : [
					{"ID" : "4", "SubInstance" : "call_Loop_LB2D_buf_p_U0", "Port" : "in_stream_V_value_V"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0",
				"SubConnect" : [
					{"ID" : "7", "SubInstance" : "call_Loop_LB2D_shift_U0", "Port" : "out_stream_V_value_V"}]}]},
	{"ID" : "4", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.linebuffer_U0.call_U0.call_Loop_LB2D_buf_p_U0", "Parent" : "3", "Child" : ["5", "6"],
		"CDFG" : "call_Loop_LB2D_buf_p",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"DependenceCheck" : [
			{"FromInitialState" : "ap_enable_state5_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_55", "FromInitialSV" : "4", "FromFinalState" : "ap_enable_state5_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_55", "FromFinalSV" : "4", "FromAddress" : "buffer_0_value_V_address1", "ToInitialState" : "ap_enable_state3_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialOperation" : "ap_enable_operation_35", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state4_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_42", "ToFinalSV" : "3", "ToAddress" : "buffer_0_value_V_address0", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "11", "II" : "1", "Pragma" : "(../../../lib_files/Linebuffer.h:180:1)"}],
		"Port" : [
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "1", "DependentChan" : "10",
				"BlockSignal" : [
					{"Name" : "in_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "slice_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "7", "DependentChan" : "8",
				"BlockSignal" : [
					{"Name" : "slice_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "5", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.linebuffer_U0.call_U0.call_Loop_LB2D_buf_p_U0.buffer_0_value_V_U", "Parent" : "4"},
	{"ID" : "6", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.linebuffer_U0.call_U0.call_Loop_LB2D_buf_p_U0.buffer_1_value_V_U", "Parent" : "4"},
	{"ID" : "7", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.linebuffer_U0.call_U0.call_Loop_LB2D_shift_U0", "Parent" : "3",
		"CDFG" : "call_Loop_LB2D_shift",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"StartSource" : "4",
		"StartFifo" : "start_for_call_LodEe_U",
		"Port" : [
			{"Name" : "slice_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "4", "DependentChan" : "8",
				"BlockSignal" : [
					{"Name" : "slice_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "0", "DependentChan" : "0",
				"BlockSignal" : [
					{"Name" : "out_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "8", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.linebuffer_U0.call_U0.slice_stream_V_value_U", "Parent" : "3"},
	{"ID" : "9", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.linebuffer_U0.call_U0.start_for_call_LodEe_U", "Parent" : "3"},
	{"ID" : "10", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.in_stream_V_value_V_U", "Parent" : "0"},
	{"ID" : "11", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_linebufeOg_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	linebuffer_1 {
		in_axi_stream_V_value_V {Type I LastRead 1 FirstWrite -1}
		in_axi_stream_V_last_V {Type I LastRead 1 FirstWrite -1}
		out_stream_V_value_V {Type O LastRead -1 FirstWrite 3}}
	linebuffer_Loop_1_pr {
		in_axi_stream_V_value_V {Type I LastRead 1 FirstWrite -1}
		in_axi_stream_V_last_V {Type I LastRead 1 FirstWrite -1}
		in_stream_V_value_V {Type O LastRead -1 FirstWrite 2}}
	linebuffer {
		in_stream_V_value_V {Type I LastRead 3 FirstWrite -1}
		out_stream_V_value_V {Type O LastRead -1 FirstWrite 3}}
	call {
		in_stream_V_value_V {Type I LastRead 3 FirstWrite -1}
		out_stream_V_value_V {Type O LastRead -1 FirstWrite 3}}
	call_Loop_LB2D_buf_p {
		in_stream_V_value_V {Type I LastRead 3 FirstWrite -1}
		slice_stream_V_value_V {Type O LastRead -1 FirstWrite 4}}
	call_Loop_LB2D_shift {
		slice_stream_V_value_V {Type I LastRead 3 FirstWrite -1}
		out_stream_V_value_V {Type O LastRead -1 FirstWrite 3}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2077921", "Max" : "2077921"}
	, {"Name" : "Interval", "Min" : "2077922", "Max" : "2077922"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	in_axi_stream_V_value_V { ap_hs {  { in_axi_stream_V_value_V in_data 0 32 }  { in_axi_stream_V_value_V_ap_vld in_vld 0 1 }  { in_axi_stream_V_value_V_ap_ack in_acc 1 1 } } }
	in_axi_stream_V_last_V { ap_hs {  { in_axi_stream_V_last_V in_data 0 1 }  { in_axi_stream_V_last_V_ap_vld in_vld 0 1 }  { in_axi_stream_V_last_V_ap_ack in_acc 1 1 } } }
	out_stream_V_value_V { ap_fifo {  { out_stream_V_value_V_din fifo_data 1 288 }  { out_stream_V_value_V_full_n fifo_status 0 1 }  { out_stream_V_value_V_write fifo_update 1 1 } } }
}
