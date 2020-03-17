set C_TypeInfoList {{ 
"hls_target" : [[], { "return": [[], "void"]} , [{"ExternC" : 0}], [ {"hw_input": [[], {"reference": "0"}] }, {"hw_output": [[], {"reference": "0"}] }],[],""], 
"0": [ "stream<AxiPackedStencil<unsigned int, 1, 1, 1, 1> >", {"hls_type": {"stream": [[[[],"1"]],"2"]}}], 
"1": [ "AxiPackedStencil<unsigned int, 1, 1, 1, 1>", {"struct": [[],[{"T":[[], {"scalar": "unsigned int"}]},{"EXTENT_0":[[], {"scalar": { "long unsigned int": 1}}]},{"EXTENT_1":[[], {"scalar": { "long unsigned int": 1}}]},{"EXTENT_2":[[], {"scalar": { "long unsigned int": 1}}]},{"EXTENT_3":[[], {"scalar": { "long unsigned int": 1}}]}],[{ "value": [[], "3"]},{ "last": [[], "4"]}],""]}], 
"4": [ "ap_uint<1>", {"hls_type": {"ap_uint": [[[[], {"scalar": { "int": 1}}]],""]}}], 
"3": [ "ap_uint<32>", {"hls_type": {"ap_uint": [[[[], {"scalar": { "int": 32}}]],""]}}],
"2": ["hls", ""]
}}
set moduleName hls_target
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type dataflow
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set C_modelName {hls_target}
set C_modelType { void 0 }
set C_modelArgList {
	{ hw_input_V_value_V int 32 regular {pointer 0 volatile }  }
	{ hw_input_V_last_V int 1 regular {pointer 0 volatile }  }
	{ hw_output_V_value_V int 32 regular {pointer 1 volatile }  }
	{ hw_output_V_last_V int 1 regular {pointer 1 volatile }  }
}
set C_modelArgMapList {[ 
	{ "Name" : "hw_input_V_value_V", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "hw_input.V.value.V","cData": "uint32","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "hw_input_V_last_V", "interface" : "wire", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "hw_input.V.last.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "hw_output_V_value_V", "interface" : "wire", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "hw_output.V.value.V","cData": "uint32","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "hw_output_V_last_V", "interface" : "wire", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "hw_output.V.last.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} ]}
# RTL Port declarations: 
set portNum 18
set portList { 
	{ hw_input_V_value_V sc_in sc_lv 32 signal 0 } 
	{ hw_input_V_last_V sc_in sc_lv 1 signal 1 } 
	{ hw_output_V_value_V sc_out sc_lv 32 signal 2 } 
	{ hw_output_V_last_V sc_out sc_lv 1 signal 3 } 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ hw_input_V_value_V_ap_vld sc_in sc_logic 1 invld 0 } 
	{ hw_input_V_value_V_ap_ack sc_out sc_logic 1 inacc 0 } 
	{ hw_input_V_last_V_ap_vld sc_in sc_logic 1 invld 1 } 
	{ hw_input_V_last_V_ap_ack sc_out sc_logic 1 inacc 1 } 
	{ hw_output_V_value_V_ap_vld sc_out sc_logic 1 outvld 2 } 
	{ hw_output_V_value_V_ap_ack sc_in sc_logic 1 outacc 2 } 
	{ hw_output_V_last_V_ap_vld sc_out sc_logic 1 outvld 3 } 
	{ hw_output_V_last_V_ap_ack sc_in sc_logic 1 outacc 3 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
}
set NewPortList {[ 
	{ "name": "hw_input_V_value_V", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hw_input_V_value_V", "role": "default" }} , 
 	{ "name": "hw_input_V_last_V", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "hw_input_V_last_V", "role": "default" }} , 
 	{ "name": "hw_output_V_value_V", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "hw_output_V_value_V", "role": "default" }} , 
 	{ "name": "hw_output_V_last_V", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "hw_output_V_last_V", "role": "default" }} , 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "hw_input_V_value_V_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "hw_input_V_value_V", "role": "ap_vld" }} , 
 	{ "name": "hw_input_V_value_V_ap_ack", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "hw_input_V_value_V", "role": "ap_ack" }} , 
 	{ "name": "hw_input_V_last_V_ap_vld", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "hw_input_V_last_V", "role": "ap_vld" }} , 
 	{ "name": "hw_input_V_last_V_ap_ack", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "hw_input_V_last_V", "role": "ap_ack" }} , 
 	{ "name": "hw_output_V_value_V_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "hw_output_V_value_V", "role": "ap_vld" }} , 
 	{ "name": "hw_output_V_value_V_ap_ack", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "hw_output_V_value_V", "role": "ap_ack" }} , 
 	{ "name": "hw_output_V_last_V_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "hw_output_V_last_V", "role": "ap_vld" }} , 
 	{ "name": "hw_output_V_last_V_ap_ack", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "hw_output_V_last_V", "role": "ap_ack" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "13", "14", "21", "34", "38", "39", "40", "41", "42", "43", "44", "45"],
		"CDFG" : "hls_target",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1",
		"Pipeline" : "Dataflow", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"InputProcess" : [
			{"ID" : "1", "Name" : "linebuffer_1_U0"}],
		"OutputProcess" : [
			{"ID" : "34", "Name" : "Loop_3_proc_U0"}],
		"Port" : [
			{"Name" : "hw_input_V_value_V", "Type" : "HS", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "linebuffer_1_U0", "Port" : "in_axi_stream_V_value_V"}]},
			{"Name" : "hw_input_V_last_V", "Type" : "HS", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "1", "SubInstance" : "linebuffer_1_U0", "Port" : "in_axi_stream_V_last_V"}]},
			{"Name" : "hw_output_V_value_V", "Type" : "HS", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "Loop_3_proc_U0", "Port" : "hw_output_V_value_V"}]},
			{"Name" : "hw_output_V_last_V", "Type" : "HS", "Direction" : "O",
				"SubConnect" : [
					{"ID" : "34", "SubInstance" : "Loop_3_proc_U0", "Port" : "hw_output_V_last_V"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0", "Parent" : "0", "Child" : ["2", "3", "11", "12"],
		"CDFG" : "linebuffer_1",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "Dataflow", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"InputProcess" : [
			{"ID" : "2", "Name" : "linebuffer_Loop_1_pr_U0"}],
		"OutputProcess" : [
			{"ID" : "3", "Name" : "linebuffer_U0"}],
		"Port" : [
			{"Name" : "in_axi_stream_V_value_V", "Type" : "HS", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "linebuffer_Loop_1_pr_U0", "Port" : "in_axi_stream_V_value_V"}]},
			{"Name" : "in_axi_stream_V_last_V", "Type" : "HS", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "2", "SubInstance" : "linebuffer_Loop_1_pr_U0", "Port" : "in_axi_stream_V_last_V"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "13", "DependentChan" : "38",
				"SubConnect" : [
					{"ID" : "3", "SubInstance" : "linebuffer_U0", "Port" : "out_stream_V_value_V"}]}]},
	{"ID" : "2", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0.linebuffer_Loop_1_pr_U0", "Parent" : "1",
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
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "5", "DependentChan" : "11",
				"BlockSignal" : [
					{"Name" : "in_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "3", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0.linebuffer_U0", "Parent" : "1", "Child" : ["4"],
		"CDFG" : "linebuffer",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "Dataflow", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"StartSource" : "2",
		"StartFifo" : "start_for_linebufeOg_U",
		"InputProcess" : [
			{"ID" : "4", "Name" : "call_U0"}],
		"OutputProcess" : [
			{"ID" : "4", "Name" : "call_U0"}],
		"Port" : [
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "2", "DependentChan" : "11",
				"SubConnect" : [
					{"ID" : "4", "SubInstance" : "call_U0", "Port" : "in_stream_V_value_V"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "13", "DependentChan" : "38",
				"SubConnect" : [
					{"ID" : "4", "SubInstance" : "call_U0", "Port" : "out_stream_V_value_V"}]}]},
	{"ID" : "4", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0.linebuffer_U0.call_U0", "Parent" : "3", "Child" : ["5", "8", "9", "10"],
		"CDFG" : "call",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "Dataflow", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"InputProcess" : [
			{"ID" : "5", "Name" : "call_Loop_LB2D_buf_p_U0"}],
		"OutputProcess" : [
			{"ID" : "8", "Name" : "call_Loop_LB2D_shift_U0"}],
		"Port" : [
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "2", "DependentChan" : "11",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "call_Loop_LB2D_buf_p_U0", "Port" : "in_stream_V_value_V"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "13", "DependentChan" : "38",
				"SubConnect" : [
					{"ID" : "8", "SubInstance" : "call_Loop_LB2D_shift_U0", "Port" : "out_stream_V_value_V"}]}]},
	{"ID" : "5", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0.linebuffer_U0.call_U0.call_Loop_LB2D_buf_p_U0", "Parent" : "4", "Child" : ["6", "7"],
		"CDFG" : "call_Loop_LB2D_buf_p",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"DependenceCheck" : [
			{"FromInitialState" : "ap_enable_state5_pp0_iter2_stage0", "FromInitialIteration" : "ap_enable_reg_pp0_iter2", "FromInitialOperation" : "ap_enable_operation_57", "FromInitialSV" : "4", "FromFinalState" : "ap_enable_state5_pp0_iter2_stage0", "FromFinalIteration" : "ap_enable_reg_pp0_iter2", "FromFinalOperation" : "ap_enable_operation_57", "FromFinalSV" : "4", "FromAddress" : "buffer_0_value_V_address1", "ToInitialState" : "ap_enable_state3_pp0_iter0_stage0", "ToInitialIteration" : "ap_enable_reg_pp0_iter0", "ToInitialOperation" : "ap_enable_operation_38", "ToInitialSV" : "2", "ToFinalState" : "ap_enable_state4_pp0_iter1_stage0", "ToFinalIteration" : "ap_enable_reg_pp0_iter1", "ToFinalOperation" : "ap_enable_operation_46", "ToFinalSV" : "3", "ToAddress" : "buffer_0_value_V_address0", "PipelineBlock" : "ap_block_pp0", "AddressWidth" : "11", "II" : "1", "Pragma" : "(../../../lib_files/Linebuffer.h:180:1)"}],
		"Port" : [
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "2", "DependentChan" : "11",
				"BlockSignal" : [
					{"Name" : "in_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "slice_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "8", "DependentChan" : "9",
				"BlockSignal" : [
					{"Name" : "slice_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "6", "Level" : "5", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0.linebuffer_U0.call_U0.call_Loop_LB2D_buf_p_U0.buffer_0_value_V_U", "Parent" : "5"},
	{"ID" : "7", "Level" : "5", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0.linebuffer_U0.call_U0.call_Loop_LB2D_buf_p_U0.buffer_1_value_V_U", "Parent" : "5"},
	{"ID" : "8", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0.linebuffer_U0.call_U0.call_Loop_LB2D_shift_U0", "Parent" : "4",
		"CDFG" : "call_Loop_LB2D_shift",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"StartSource" : "5",
		"StartFifo" : "start_for_call_LodEe_U",
		"Port" : [
			{"Name" : "slice_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "5", "DependentChan" : "9",
				"BlockSignal" : [
					{"Name" : "slice_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "13", "DependentChan" : "38",
				"BlockSignal" : [
					{"Name" : "out_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "9", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0.linebuffer_U0.call_U0.slice_stream_V_value_U", "Parent" : "4"},
	{"ID" : "10", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0.linebuffer_U0.call_U0.start_for_call_LodEe_U", "Parent" : "4"},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0.in_stream_V_value_V_U", "Parent" : "1"},
	{"ID" : "12", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.linebuffer_1_U0.start_for_linebufeOg_U", "Parent" : "1"},
	{"ID" : "13", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.Loop_1_proc_U0", "Parent" : "0",
		"CDFG" : "Loop_1_proc",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"StartSource" : "1",
		"StartFifo" : "start_for_Loop_1_kbM_U",
		"Port" : [
			{"Name" : "p_hw_input_stencil_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "8", "DependentChan" : "38",
				"BlockSignal" : [
					{"Name" : "p_hw_input_stencil_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_mul_stencil_update_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "16", "DependentChan" : "39",
				"BlockSignal" : [
					{"Name" : "p_mul_stencil_update_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "14", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.linebuffer_2_U0", "Parent" : "0", "Child" : ["15"],
		"CDFG" : "linebuffer_2",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "Dataflow", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"StartSource" : "13",
		"StartFifo" : "start_for_linebuflbW_U",
		"InputProcess" : [
			{"ID" : "15", "Name" : "call_1_U0"}],
		"OutputProcess" : [
			{"ID" : "15", "Name" : "call_1_U0"}],
		"Port" : [
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "13", "DependentChan" : "39",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "call_1_U0", "Port" : "in_stream_V_value_V"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "21", "DependentChan" : "40",
				"SubConnect" : [
					{"ID" : "15", "SubInstance" : "call_1_U0", "Port" : "out_stream_V_value_V"}]}]},
	{"ID" : "15", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.linebuffer_2_U0.call_1_U0", "Parent" : "14", "Child" : ["16", "18", "19", "20"],
		"CDFG" : "call_1",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "Dataflow", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"InputProcess" : [
			{"ID" : "16", "Name" : "call_Loop_LB2D_buf_p_1_U0"}],
		"OutputProcess" : [
			{"ID" : "18", "Name" : "call_Loop_LB2D_shift_1_U0"}],
		"Port" : [
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "13", "DependentChan" : "39",
				"SubConnect" : [
					{"ID" : "16", "SubInstance" : "call_Loop_LB2D_buf_p_1_U0", "Port" : "in_stream_V_value_V"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "21", "DependentChan" : "40",
				"SubConnect" : [
					{"ID" : "18", "SubInstance" : "call_Loop_LB2D_shift_1_U0", "Port" : "out_stream_V_value_V"}]}]},
	{"ID" : "16", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.linebuffer_2_U0.call_1_U0.call_Loop_LB2D_buf_p_1_U0", "Parent" : "15", "Child" : ["17"],
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
			{"Name" : "in_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "13", "DependentChan" : "39",
				"BlockSignal" : [
					{"Name" : "in_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "slice_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "18", "DependentChan" : "19",
				"BlockSignal" : [
					{"Name" : "slice_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "17", "Level" : "4", "Path" : "`AUTOTB_DUT_INST.linebuffer_2_U0.call_1_U0.call_Loop_LB2D_buf_p_1_U0.buffer_0_value_V_U", "Parent" : "16"},
	{"ID" : "18", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.linebuffer_2_U0.call_1_U0.call_Loop_LB2D_shift_1_U0", "Parent" : "15",
		"CDFG" : "call_Loop_LB2D_shift_1",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"StartSource" : "16",
		"StartFifo" : "start_for_call_Log8j_U",
		"Port" : [
			{"Name" : "slice_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "16", "DependentChan" : "19",
				"BlockSignal" : [
					{"Name" : "slice_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "out_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "21", "DependentChan" : "40",
				"BlockSignal" : [
					{"Name" : "out_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "19", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.linebuffer_2_U0.call_1_U0.slice_stream_V_value_U", "Parent" : "15"},
	{"ID" : "20", "Level" : "3", "Path" : "`AUTOTB_DUT_INST.linebuffer_2_U0.call_1_U0.start_for_call_Log8j_U", "Parent" : "15"},
	{"ID" : "21", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0", "Parent" : "0", "Child" : ["22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33"],
		"CDFG" : "Loop_2_proc",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"StartSource" : "14",
		"StartFifo" : "start_for_Loop_2_mb6_U",
		"Port" : [
			{"Name" : "p_mul_stencil_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "18", "DependentChan" : "40",
				"BlockSignal" : [
					{"Name" : "p_mul_stencil_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "p_p2_mul1_stencil_stream_V_value_V", "Type" : "Fifo", "Direction" : "O", "DependentProc" : "34", "DependentChan" : "41",
				"BlockSignal" : [
					{"Name" : "p_p2_mul1_stencil_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "22", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_sitofphbi_U30", "Parent" : "21"},
	{"ID" : "23", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_sitofphbi_U31", "Parent" : "21"},
	{"ID" : "24", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_sitofphbi_U32", "Parent" : "21"},
	{"ID" : "25", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_sitofphbi_U33", "Parent" : "21"},
	{"ID" : "26", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_fpext_ibs_U34", "Parent" : "21"},
	{"ID" : "27", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_fpext_ibs_U35", "Parent" : "21"},
	{"ID" : "28", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_fpext_ibs_U36", "Parent" : "21"},
	{"ID" : "29", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_fpext_ibs_U37", "Parent" : "21"},
	{"ID" : "30", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_dmul_6jbC_U38", "Parent" : "21"},
	{"ID" : "31", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_dmul_6jbC_U39", "Parent" : "21"},
	{"ID" : "32", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_dmul_6jbC_U40", "Parent" : "21"},
	{"ID" : "33", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_2_proc_U0.hls_target_dmul_6jbC_U41", "Parent" : "21"},
	{"ID" : "34", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.Loop_3_proc_U0", "Parent" : "0", "Child" : ["35", "36", "37"],
		"CDFG" : "Loop_3_proc",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1",
		"Pipeline" : "None", "AlignedPipeline" : "0", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"StartSource" : "21",
		"StartFifo" : "start_for_Loop_3_ncg_U",
		"Port" : [
			{"Name" : "p_p2_mul1_stencil_stream_V_value_V", "Type" : "Fifo", "Direction" : "I", "DependentProc" : "21", "DependentChan" : "41",
				"BlockSignal" : [
					{"Name" : "p_p2_mul1_stencil_stream_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "hw_output_V_value_V", "Type" : "HS", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "hw_output_V_value_V_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "hw_output_V_last_V", "Type" : "HS", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "hw_output_V_last_V_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "35", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_3_proc_U0.hls_target_sitofphbi_x_U44", "Parent" : "34"},
	{"ID" : "36", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_3_proc_U0.hls_target_fpext_ibs_x_U45", "Parent" : "34"},
	{"ID" : "37", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.Loop_3_proc_U0.hls_target_dmul_6jbC_x_U46", "Parent" : "34"},
	{"ID" : "38", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_hw_input_stencil_st_U", "Parent" : "0"},
	{"ID" : "39", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_mul_stencil_update_1_U", "Parent" : "0"},
	{"ID" : "40", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_mul_stencil_stream_s_U", "Parent" : "0"},
	{"ID" : "41", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_p2_mul1_stencil_str_U", "Parent" : "0"},
	{"ID" : "42", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_Loop_1_kbM_U", "Parent" : "0"},
	{"ID" : "43", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_linebuflbW_U", "Parent" : "0"},
	{"ID" : "44", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_Loop_2_mb6_U", "Parent" : "0"},
	{"ID" : "45", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.start_for_Loop_3_ncg_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	hls_target {
		hw_input_V_value_V {Type I LastRead 1 FirstWrite -1}
		hw_input_V_last_V {Type I LastRead 1 FirstWrite -1}
		hw_output_V_value_V {Type O LastRead -1 FirstWrite 24}
		hw_output_V_last_V {Type O LastRead -1 FirstWrite 24}}
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
		out_stream_V_value_V {Type O LastRead -1 FirstWrite 3}}
	Loop_1_proc {
		p_hw_input_stencil_stream_V_value_V {Type I LastRead 2 FirstWrite -1}
		p_mul_stencil_update_stream_V_value_V {Type O LastRead -1 FirstWrite 6}}
	linebuffer_2 {
		in_stream_V_value_V {Type I LastRead 3 FirstWrite -1}
		out_stream_V_value_V {Type O LastRead -1 FirstWrite 3}}
	call_1 {
		in_stream_V_value_V {Type I LastRead 3 FirstWrite -1}
		out_stream_V_value_V {Type O LastRead -1 FirstWrite 3}}
	call_Loop_LB2D_buf_p_1 {
		in_stream_V_value_V {Type I LastRead 3 FirstWrite -1}
		slice_stream_V_value_V {Type O LastRead -1 FirstWrite 4}}
	call_Loop_LB2D_shift_1 {
		slice_stream_V_value_V {Type I LastRead 3 FirstWrite -1}
		out_stream_V_value_V {Type O LastRead -1 FirstWrite 3}}
	Loop_2_proc {
		p_mul_stencil_stream_V_value_V {Type I LastRead 2 FirstWrite -1}
		p_p2_mul1_stencil_stream_V_value_V {Type O LastRead -1 FirstWrite 28}}
	Loop_3_proc {
		p_p2_mul1_stencil_stream_V_value_V {Type I LastRead 2 FirstWrite -1}
		hw_output_V_value_V {Type O LastRead -1 FirstWrite 24}
		hw_output_V_last_V {Type O LastRead -1 FirstWrite 24}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2077921", "Max" : "2077921"}
	, {"Name" : "Interval", "Min" : "2077922", "Max" : "2077922"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	hw_input_V_value_V { ap_hs {  { hw_input_V_value_V in_data 0 32 }  { hw_input_V_value_V_ap_vld in_vld 0 1 }  { hw_input_V_value_V_ap_ack in_acc 1 1 } } }
	hw_input_V_last_V { ap_hs {  { hw_input_V_last_V in_data 0 1 }  { hw_input_V_last_V_ap_vld in_vld 0 1 }  { hw_input_V_last_V_ap_ack in_acc 1 1 } } }
	hw_output_V_value_V { ap_hs {  { hw_output_V_value_V out_data 1 32 }  { hw_output_V_value_V_ap_vld out_vld 1 1 }  { hw_output_V_value_V_ap_ack out_acc 0 1 } } }
	hw_output_V_last_V { ap_hs {  { hw_output_V_last_V out_data 1 1 }  { hw_output_V_last_V_ap_vld out_vld 1 1 }  { hw_output_V_last_V_ap_ack out_acc 0 1 } } }
}

set busDeadlockParameterList { 
}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
