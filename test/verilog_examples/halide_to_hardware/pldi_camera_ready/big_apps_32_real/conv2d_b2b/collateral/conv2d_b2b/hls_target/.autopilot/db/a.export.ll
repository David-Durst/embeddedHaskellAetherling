; ModuleID = '/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d_b2b/conv2d_b2b/hls_target/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@slice_stream_OC_V_OC = internal unnamed_addr constant [23 x i8] c"slice_stream.V.value.V\00"
@llvm_global_ctors_1 = appending global [2 x void ()*] [void ()* @_GLOBAL__I_a, void ()* @_GLOBAL__I_a110]
@llvm_global_ctors_0 = appending global [2 x i32] [i32 65535, i32 65535]
@in_stream_OC_V_OC_va = internal unnamed_addr constant [20 x i8] c"in_stream.V.value.V\00"
@hls_target_str = internal unnamed_addr constant [11 x i8] c"hls_target\00"
@ap_fifo_str = internal unnamed_addr constant [8 x i8] c"ap_fifo\00"
@p_p2_mul1_stencil_str = internal unnamed_addr constant [34 x i8] c"_p2_mul1_stencil_stream.V.value.V\00"
@p_mul_stencil_update_s = internal unnamed_addr constant [37 x i8] c"_mul_stencil_update_stream.V.value.V\00"
@p_mul_stencil_stream_s = internal unnamed_addr constant [30 x i8] c"_mul_stencil_stream.V.value.V\00"
@p_hw_input_stencil_st = internal unnamed_addr constant [35 x i8] c"_hw_input_stencil_stream.V.value.V\00"
@p_str6 = private unnamed_addr constant [12 x i8] c"hls_label_4\00", align 1
@p_str5 = private unnamed_addr constant [12 x i8] c"hls_label_5\00", align 1
@p_str36 = private unnamed_addr constant [12 x i8] c"hls_label_8\00", align 1
@p_str35 = private unnamed_addr constant [12 x i8] c"hls_label_7\00", align 1
@p_str3 = private unnamed_addr constant [12 x i8] c"hls_label_6\00", align 1
@p_str26 = private unnamed_addr constant [14 x i8] c"LB1D_shiftreg\00", align 1
@p_str25 = private unnamed_addr constant [11 x i8] c"LB2D_shift\00", align 1
@p_str24 = private unnamed_addr constant [13 x i8] c"hls_label_17\00", align 1
@p_str23 = private unnamed_addr constant [9 x i8] c"LB2D_buf\00", align 1
@p_str22 = private unnamed_addr constant [11 x i8] c"LB_3D_pass\00", align 1
@p_str21 = private unnamed_addr constant [11 x i8] c"LB_4D_pass\00", align 1
@p_str2 = private unnamed_addr constant [9 x i8] c"FIFO_SRL\00", align 1
@p_str1 = private unnamed_addr constant [6 x i8] c"ap_hs\00", align 1
@p_str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare i96 @llvm.part.select.i96(i96, i32, i32) nounwind readnone

declare i64 @llvm.part.select.i64(i64, i32, i32) nounwind readnone

declare i288 @llvm.part.select.i288(i288, i32, i32) nounwind readnone

declare i137 @llvm.part.select.i137(i137, i32, i32) nounwind readnone

declare i128 @llvm.part.select.i128(i128, i32, i32) nounwind readnone

declare i11 @llvm.part.select.i11(i11, i32, i32) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define internal fastcc void @linebuffer_Loop_1_pr(i32* %in_axi_stream_V_value_V, i1* %in_axi_stream_V_last_V, i32* %in_stream_V_value_V) {
newFuncRoot:
  call void (...)* @_ssdm_op_SpecMemCore(i32* %in_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i32* %in_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  br label %.preheader.i

.critedge.exitStub:                               ; preds = %.preheader.i
  ret void

.preheader4.i:                                    ; preds = %.preheader.i
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 2073600, i64 2073600, i64 2073600)
  %tmp = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str35)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %empty_20 = call { i32, i1 } @_ssdm_op_Read.ap_auto.volatile.i32P.i1P(i32* %in_axi_stream_V_value_V, i1* %in_axi_stream_V_last_V)
  %tmp_value_V = extractvalue { i32, i1 } %empty_20, 0
  call void @_ssdm_op_Write.ap_fifo.volatile.i32P(i32* %in_stream_V_value_V, i32 %tmp_value_V)
  %empty_21 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str35, i32 %tmp)
  br label %.preheader.i

.preheader.i:                                     ; preds = %newFuncRoot, %.preheader4.i
  %indvar_flatten = phi i21 [ 0, %newFuncRoot ], [ %indvar_flatten_next, %.preheader4.i ]
  %exitcond_flatten = icmp eq i21 %indvar_flatten, -23552
  %indvar_flatten_next = add i21 %indvar_flatten, 1
  br i1 %exitcond_flatten, label %.critedge.exitStub, label %.preheader4.i
}

define internal fastcc void @linebuffer.2(i32* %in_stream_V_value_V, i128* %out_stream_V_value_V) {
  call void (...)* @_ssdm_op_SpecInterface(i128* %out_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i32* %in_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecDataflowPipeline(i32 -1, [1 x i8]* @p_str) nounwind
  call void (...)* @_ssdm_op_SpecMemCore(i128* %out_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i32* %in_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str21) nounwind
  %tmp = call i32 (...)* @_ssdm_op_SpecRegionBegin([11 x i8]* @p_str21)
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str22) nounwind
  %empty = call i32 (...)* @_ssdm_op_SpecRegionEnd([11 x i8]* @p_str21, i32 %tmp)
  call fastcc void @call.1(i32* %in_stream_V_value_V, i128* %out_stream_V_value_V)
  ret void
}

define internal fastcc void @linebuffer.1(i32* %in_axi_stream_V_value_V, i1* %in_axi_stream_V_last_V, i288* %out_stream_V_value_V) {
.preheader5.preheader.critedge:
  call void (...)* @_ssdm_op_SpecInterface(i288* %out_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecDataflowPipeline(i32 -1, [1 x i8]* @p_str) nounwind
  call void (...)* @_ssdm_op_SpecMemCore(i288* %out_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  %in_stream_V_value_V = alloca i32, align 4
  %empty = call i32 (...)* @_ssdm_op_SpecChannel([20 x i8]* @in_stream_OC_V_OC_va, i32 1, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 1, i32 1, i32* %in_stream_V_value_V, i32* %in_stream_V_value_V)
  call void (...)* @_ssdm_op_SpecInterface(i32* %in_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i32* %in_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call fastcc void @linebuffer_Loop_1_pr(i32* %in_axi_stream_V_value_V, i1* %in_axi_stream_V_last_V, i32* %in_stream_V_value_V)
  call fastcc void @linebuffer(i32* %in_stream_V_value_V, i288* %out_stream_V_value_V)
  ret void
}

define internal fastcc void @linebuffer(i32* %in_stream_V_value_V, i288* %out_stream_V_value_V) {
  call void (...)* @_ssdm_op_SpecInterface(i32* %in_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i288* %out_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecDataflowPipeline(i32 -1, [1 x i8]* @p_str) nounwind
  call void (...)* @_ssdm_op_SpecMemCore(i32* %in_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i288* %out_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str21) nounwind
  %tmp = call i32 (...)* @_ssdm_op_SpecRegionBegin([11 x i8]* @p_str21)
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str22) nounwind
  %empty = call i32 (...)* @_ssdm_op_SpecRegionEnd([11 x i8]* @p_str21, i32 %tmp)
  call fastcc void @call(i32* %in_stream_V_value_V, i288* %out_stream_V_value_V)
  ret void
}

define void @hls_target(i32* %hw_input_V_value_V, i1* %hw_input_V_last_V, i32* %hw_output_V_value_V, i1* %hw_output_V_last_V) {
codeRepl:
  call void (...)* @_ssdm_op_SpecDataflowPipeline(i32 -1, [1 x i8]* @p_str) nounwind
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %hw_input_V_value_V), !map !534
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %hw_input_V_last_V), !map !540
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %hw_output_V_value_V), !map !544
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %hw_output_V_last_V), !map !548
  call void (...)* @_ssdm_op_SpecTopModule([11 x i8]* @hls_target_str) nounwind
  %p_hw_input_stencil_st = alloca i288, align 8
  %empty = call i32 (...)* @_ssdm_op_SpecChannel([35 x i8]* @p_hw_input_stencil_st, i32 1, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 1, i32 1, i288* %p_hw_input_stencil_st, i288* %p_hw_input_stencil_st)
  call void (...)* @_ssdm_op_SpecInterface(i288* %p_hw_input_stencil_st, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i288* %p_hw_input_stencil_st, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  %p_mul_stencil_update_1 = alloca i32, align 4
  %empty_22 = call i32 (...)* @_ssdm_op_SpecChannel([37 x i8]* @p_mul_stencil_update_s, i32 1, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 1, i32 1, i32* %p_mul_stencil_update_1, i32* %p_mul_stencil_update_1)
  call void (...)* @_ssdm_op_SpecInterface(i32* %p_mul_stencil_update_1, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i32* %p_mul_stencil_update_1, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  %p_mul_stencil_stream_s = alloca i128, align 8
  %empty_23 = call i32 (...)* @_ssdm_op_SpecChannel([30 x i8]* @p_mul_stencil_stream_s, i32 1, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 1, i32 1, i128* %p_mul_stencil_stream_s, i128* %p_mul_stencil_stream_s)
  call void (...)* @_ssdm_op_SpecInterface(i128* %p_mul_stencil_stream_s, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i128* %p_mul_stencil_stream_s, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  %p_p2_mul1_stencil_str = alloca i32, align 4
  %empty_24 = call i32 (...)* @_ssdm_op_SpecChannel([34 x i8]* @p_p2_mul1_stencil_str, i32 1, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 1, i32 1, i32* %p_p2_mul1_stencil_str, i32* %p_p2_mul1_stencil_str)
  call void (...)* @_ssdm_op_SpecInterface(i32* %p_p2_mul1_stencil_str, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i32* %p_p2_mul1_stencil_str, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i32* %hw_input_V_value_V, i1* %hw_input_V_last_V, [6 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32* %hw_output_V_value_V, i1* %hw_output_V_last_V, [6 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str) nounwind
  call fastcc void @linebuffer.1(i32* %hw_input_V_value_V, i1* %hw_input_V_last_V, i288* %p_hw_input_stencil_st)
  call fastcc void @Loop_1_proc(i288* %p_hw_input_stencil_st, i32* %p_mul_stencil_update_1)
  call fastcc void @linebuffer.2(i32* %p_mul_stencil_update_1, i128* %p_mul_stencil_stream_s)
  call fastcc void @Loop_2_proc(i128* %p_mul_stencil_stream_s, i32* %p_p2_mul1_stencil_str)
  call fastcc void @Loop_3_proc(i32* %p_p2_mul1_stencil_str, i32* %hw_output_V_value_V, i1* %hw_output_V_last_V)
  ret void
}

define internal fastcc void @call_Loop_LB2D_shift.1(i64* %slice_stream_V_value_V, i128* %out_stream_V_value_V) {
newFuncRoot:
  %buffer_0_value_V = alloca i64
  call void (...)* @_ssdm_op_SpecMemCore(i64* %slice_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i128* %out_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i64* %slice_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i128* %out_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  br label %.preheader

.exitStub:                                        ; preds = %.preheader
  ret void

.preheader:                                       ; preds = %"linebuffer_1D<1918ul, 2ul, 1ul, 1ul, 1ul, 2ul, int>.exit", %newFuncRoot
  %n1 = phi i11 [ %n1_1, %"linebuffer_1D<1918ul, 2ul, 1ul, 1ul, 1ul, 2ul, int>.exit" ], [ 0, %newFuncRoot ]
  %tmp_s = icmp eq i11 %n1, -971
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 1077, i64 1077, i64 1077)
  %n1_1 = add i11 %n1, 1
  br i1 %tmp_s, label %.exitStub, label %1

"linebuffer_1D<1918ul, 2ul, 1ul, 1ul, 1ul, 2ul, int>.exit": ; preds = %0
  %empty_25 = call i32 (...)* @_ssdm_op_SpecRegionEnd([11 x i8]* @p_str25, i32 %tmp_6)
  br label %.preheader

; <label>:0                                       ; preds = %._crit_edge.i.i, %1
  %i_0_i_i = phi i11 [ 0, %1 ], [ %i, %._crit_edge.i.i ]
  %tmp_7 = icmp eq i11 %i_0_i_i, -130
  %empty_26 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 1918, i64 1918, i64 1918)
  %i = add i11 %i_0_i_i, 1
  br i1 %tmp_7, label %"linebuffer_1D<1918ul, 2ul, 1ul, 1ul, 1ul, 2ul, int>.exit", label %.critedge.i.i

; <label>:1                                       ; preds = %.preheader
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str25) nounwind
  %tmp_6 = call i32 (...)* @_ssdm_op_SpecRegionBegin([11 x i8]* @p_str25)
  br label %0

._crit_edge.i.i:                                  ; preds = %.preheader.i.i.preheader.0, %.critedge.i.i
  %empty_27 = call i32 (...)* @_ssdm_op_SpecRegionEnd([14 x i8]* @p_str26, i32 %tmp_8)
  store i64 %tmp_value_V_1, i64* %buffer_0_value_V
  br label %0

.critedge.i.i:                                    ; preds = %0
  call void (...)* @_ssdm_op_SpecLoopName([14 x i8]* @p_str26) nounwind
  %tmp_8 = call i32 (...)* @_ssdm_op_SpecRegionBegin([14 x i8]* @p_str26)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %tmp_value_V_1 = call i64 @_ssdm_op_Read.ap_fifo.volatile.i64P(i64* %slice_stream_V_value_V)
  %tmp_9 = icmp eq i11 %i_0_i_i, 0
  br i1 %tmp_9, label %._crit_edge.i.i, label %.preheader.i.i.preheader.0

.preheader.i.i.preheader.0:                       ; preds = %.critedge.i.i
  %buffer_0_value_V_lo = load i64* %buffer_0_value_V
  %tmp = trunc i64 %buffer_0_value_V_lo to i32
  %tmp_1 = trunc i64 %tmp_value_V_1 to i32
  %p_Result_37_1 = call i32 @_ssdm_op_PartSelect.i32.i64.i32.i32(i64 %buffer_0_value_V_lo, i32 32, i32 63)
  %p_Result_37_1_1 = call i32 @_ssdm_op_PartSelect.i32.i64.i32.i32(i64 %tmp_value_V_1, i32 32, i32 63)
  %tmp_value_V = call i128 @_ssdm_op_BitConcatenate.i128.i32.i32.i32.i32(i32 %p_Result_37_1_1, i32 %p_Result_37_1, i32 %tmp_1, i32 %tmp)
  call void @_ssdm_op_Write.ap_fifo.volatile.i128P(i128* %out_stream_V_value_V, i128 %tmp_value_V)
  br label %._crit_edge.i.i
}

define internal fastcc void @call_Loop_LB2D_shift(i96* %slice_stream_V_value_V, i288* %out_stream_V_value_V) {
newFuncRoot:
  %buffer_1_value_V = alloca i96
  %buffer_0_value_V = alloca i96
  call void (...)* @_ssdm_op_SpecMemCore(i96* %slice_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i288* %out_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i96* %slice_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i288* %out_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  br label %.preheader

.exitStub:                                        ; preds = %.preheader
  ret void

.preheader:                                       ; preds = %"linebuffer_1D<1920ul, 3ul, 1ul, 1ul, 1ul, 3ul, unsigned int>.exit", %newFuncRoot
  %n1 = phi i11 [ %n1_1, %"linebuffer_1D<1920ul, 3ul, 1ul, 1ul, 1ul, 3ul, unsigned int>.exit" ], [ 0, %newFuncRoot ]
  %tmp_s = icmp eq i11 %n1, -970
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 1078, i64 1078, i64 1078)
  %n1_1 = add i11 %n1, 1
  br i1 %tmp_s, label %.exitStub, label %1

"linebuffer_1D<1920ul, 3ul, 1ul, 1ul, 1ul, 3ul, unsigned int>.exit": ; preds = %0
  %empty_28 = call i32 (...)* @_ssdm_op_SpecRegionEnd([11 x i8]* @p_str25, i32 %tmp_5)
  br label %.preheader

; <label>:0                                       ; preds = %._crit_edge.i.i, %1
  %i_0_i_i = phi i11 [ 0, %1 ], [ %i, %._crit_edge.i.i ]
  %tmp_1 = icmp eq i11 %i_0_i_i, -128
  %empty_29 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 1920, i64 1920, i64 1920)
  %i = add i11 %i_0_i_i, 1
  br i1 %tmp_1, label %"linebuffer_1D<1920ul, 3ul, 1ul, 1ul, 1ul, 3ul, unsigned int>.exit", label %2

; <label>:1                                       ; preds = %.preheader
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str25) nounwind
  %tmp_5 = call i32 (...)* @_ssdm_op_SpecRegionBegin([11 x i8]* @p_str25)
  br label %0

._crit_edge.i.i:                                  ; preds = %2, %.preheader.i.i.preheader.0
  %buffer_1_value_V_lo = load i96* %buffer_1_value_V
  %empty_30 = call i32 (...)* @_ssdm_op_SpecRegionEnd([14 x i8]* @p_str26, i32 %tmp_7)
  store i96 %buffer_1_value_V_lo, i96* %buffer_0_value_V
  store i96 %tmp_value_V_2, i96* %buffer_1_value_V
  br label %0

; <label>:2                                       ; preds = %0
  call void (...)* @_ssdm_op_SpecLoopName([14 x i8]* @p_str26) nounwind
  %tmp_7 = call i32 (...)* @_ssdm_op_SpecRegionBegin([14 x i8]* @p_str26)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %tmp_value_V_2 = call i96 @_ssdm_op_Read.ap_fifo.volatile.i96P(i96* %slice_stream_V_value_V)
  %tmp = call i10 @_ssdm_op_PartSelect.i10.i11.i32.i32(i11 %i_0_i_i, i32 1, i32 10)
  %icmp = icmp eq i10 %tmp, 0
  br i1 %icmp, label %._crit_edge.i.i, label %.preheader.i.i.preheader.0

.preheader.i.i.preheader.0:                       ; preds = %2
  %buffer_1_value_V_lo_1 = load i96* %buffer_1_value_V
  %buffer_0_value_V_lo = load i96* %buffer_0_value_V
  %tmp_2 = trunc i96 %buffer_0_value_V_lo to i32
  %tmp_3 = trunc i96 %buffer_1_value_V_lo_1 to i32
  %tmp_4 = trunc i96 %tmp_value_V_2 to i32
  %p_Result_31_1 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %buffer_0_value_V_lo, i32 32, i32 63)
  %p_Result_31_1_1 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %buffer_1_value_V_lo_1, i32 32, i32 63)
  %p_Result_31_1_2 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %tmp_value_V_2, i32 32, i32 63)
  %p_Result_31_2 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %buffer_0_value_V_lo, i32 64, i32 95)
  %p_Result_31_2_1 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %buffer_1_value_V_lo_1, i32 64, i32 95)
  %p_Result_31_2_2 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %tmp_value_V_2, i32 64, i32 95)
  %tmp_value_V = call i288 @_ssdm_op_BitConcatenate.i288.i32.i32.i32.i32.i32.i32.i32.i32.i32(i32 %p_Result_31_2_2, i32 %p_Result_31_2_1, i32 %p_Result_31_2, i32 %p_Result_31_1_2, i32 %p_Result_31_1_1, i32 %p_Result_31_1, i32 %tmp_4, i32 %tmp_3, i32 %tmp_2)
  call void @_ssdm_op_Write.ap_fifo.volatile.i288P(i288* %out_stream_V_value_V, i288 %tmp_value_V)
  br label %._crit_edge.i.i
}

define internal fastcc void @call_Loop_LB2D_buf_p.1(i32* %in_stream_V_value_V, i64* %slice_stream_V_value_V) {
newFuncRoot:
  call void (...)* @_ssdm_op_SpecMemCore(i64* %slice_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i32* %in_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i64* %slice_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i32* %in_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  %buffer_0_value_V = alloca [1918 x i32], align 4
  br label %0

.preheader.exitStub:                              ; preds = %0
  ret void

; <label>:0                                       ; preds = %1, %newFuncRoot
  %row = phi i11 [ 0, %newFuncRoot ], [ %row_1, %1 ]
  %tmp = icmp eq i11 %row, -970
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 1078, i64 1078, i64 1078)
  %row_1 = add i11 %row, 1
  br i1 %tmp, label %.preheader.exitStub, label %3

; <label>:1                                       ; preds = %2
  %empty_31 = call i32 (...)* @_ssdm_op_SpecRegionEnd([9 x i8]* @p_str23, i32 %tmp_9)
  br label %0

; <label>:2                                       ; preds = %._crit_edge, %3
  %col = phi i11 [ 0, %3 ], [ %col_1, %._crit_edge ]
  %tmp_1 = icmp eq i11 %col, -130
  %col_1 = add i11 %col, 1
  br i1 %tmp_1, label %1, label %4

; <label>:3                                       ; preds = %0
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @p_str23) nounwind
  %tmp_9 = call i32 (...)* @_ssdm_op_SpecRegionBegin([9 x i8]* @p_str23)
  %tmp_s = icmp eq i11 %row, 0
  br label %2

._crit_edge:                                      ; preds = %.preheader57, %4
  %buffer_0_value_V_ad = getelementptr [1918 x i32]* %buffer_0_value_V, i64 0, i64 %col_cast
  store i32 %tmp_value_V_3, i32* %buffer_0_value_V_ad, align 4
  %empty_32 = call i32 (...)* @_ssdm_op_SpecRegionEnd([13 x i8]* @p_str24, i32 %tmp_2)
  br label %2

; <label>:4                                       ; preds = %2
  %col_cast = zext i11 %col to i64
  %empty_33 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 1918, i64 1918, i64 1918)
  %tmp_2 = call i32 (...)* @_ssdm_op_SpecRegionBegin([13 x i8]* @p_str24)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %tmp_value_V_3 = call i32 @_ssdm_op_Read.ap_fifo.volatile.i32P(i32* %in_stream_V_value_V)
  br i1 %tmp_s, label %._crit_edge, label %.preheader57

.preheader57:                                     ; preds = %4
  %buffer_0_value_V_ad_1 = getelementptr [1918 x i32]* %buffer_0_value_V, i64 0, i64 %col_cast
  %p_Val2_s = load i32* %buffer_0_value_V_ad_1, align 4
  %p_Result_s = call i64 @_ssdm_op_BitConcatenate.i64.i32.i32(i32 %tmp_value_V_3, i32 %p_Val2_s)
  call void @_ssdm_op_Write.ap_fifo.volatile.i64P(i64* %slice_stream_V_value_V, i64 %p_Result_s)
  br label %._crit_edge
}

define internal fastcc void @call_Loop_LB2D_buf_p(i32* %in_stream_V_value_V, i96* %slice_stream_V_value_V) {
newFuncRoot:
  call void (...)* @_ssdm_op_SpecMemCore(i96* %slice_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i32* %in_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i96* %slice_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i32* %in_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  %buffer_0_value_V = alloca [1920 x i32], align 4
  %buffer_1_value_V = alloca [1920 x i32], align 4
  br label %0

.preheader.exitStub:                              ; preds = %0
  ret void

; <label>:0                                       ; preds = %1, %newFuncRoot
  %write_idx_1 = phi i64 [ 0, %newFuncRoot ], [ %write_idx_1_2, %1 ]
  %row = phi i11 [ 0, %newFuncRoot ], [ %row_1, %1 ]
  %tmp = icmp eq i11 %row, -968
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 1080, i64 1080, i64 1080)
  %row_1 = add i11 %row, 1
  br i1 %tmp, label %.preheader.exitStub, label %3

; <label>:1                                       ; preds = %2
  %write_idx_1_2 = add i64 %write_idx_1_1, 1
  %empty_34 = call i32 (...)* @_ssdm_op_SpecRegionEnd([9 x i8]* @p_str23, i32 %tmp_4)
  br label %0

; <label>:2                                       ; preds = %._crit_edge31, %3
  %write_idx_1_1 = phi i64 [ %write_idx_1, %3 ], [ %p_write_idx_1_1, %._crit_edge31 ]
  %col = phi i11 [ 0, %3 ], [ %col_1, %._crit_edge31 ]
  %tmp_3 = icmp eq i11 %col, -128
  %col_1 = add i11 %col, 1
  br i1 %tmp_3, label %1, label %4

; <label>:3                                       ; preds = %0
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @p_str23) nounwind
  %tmp_4 = call i32 (...)* @_ssdm_op_SpecRegionBegin([9 x i8]* @p_str23)
  %tmp_5 = call i10 @_ssdm_op_PartSelect.i10.i11.i32.i32(i11 %row, i32 1, i32 10)
  %icmp = icmp eq i10 %tmp_5, 0
  br label %2

._crit_edge31:                                    ; preds = %branch5, %branch4
  %empty_35 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str36, i32 %tmp_6)
  br label %2

branch4:                                          ; preds = %._crit_edge
  store i32 %tmp_value_V_4, i32* %buffer_0_value_V_ad, align 4
  br label %._crit_edge31

._crit_edge:                                      ; preds = %4, %.preheader56.preheader.critedge.0_ifconv
  %buffer_0_value_V_ad = getelementptr [1920 x i32]* %buffer_0_value_V, i64 0, i64 %col_cast
  %buffer_1_value_V_ad = getelementptr [1920 x i32]* %buffer_1_value_V, i64 0, i64 %col_cast
  %tmp_9 = trunc i64 %p_write_idx_1_1 to i1
  br i1 %tmp_9, label %branch5, label %branch4

; <label>:4                                       ; preds = %2
  %col_cast = zext i11 %col to i64
  %empty_36 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 1920, i64 1920, i64 1920)
  %tmp_6 = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str36)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %tmp_7 = call i63 @_ssdm_op_PartSelect.i63.i64.i32.i32(i64 %write_idx_1_1, i32 1, i32 63)
  %icmp1 = icmp ne i63 %tmp_7, 0
  %write_idx_1_3 = add i64 %write_idx_1_1, -2
  %p_write_idx_1_1 = select i1 %icmp1, i64 %write_idx_1_3, i64 %write_idx_1_1
  %tmp_value_V_4 = call i32 @_ssdm_op_Read.ap_fifo.volatile.i32P(i32* %in_stream_V_value_V)
  br i1 %icmp, label %._crit_edge, label %.preheader56.preheader.critedge.0_ifconv

.preheader56.preheader.critedge.0_ifconv:         ; preds = %4
  %tmp_8 = trunc i64 %p_write_idx_1_1 to i1
  %buffer_0_value_V_ad_2 = getelementptr [1920 x i32]* %buffer_0_value_V, i64 0, i64 %col_cast
  %buffer_1_value_V_ad_1 = getelementptr [1920 x i32]* %buffer_1_value_V, i64 0, i64 %col_cast
  %buffer_1_value_V_lo = load i32* %buffer_1_value_V_ad_1, align 4
  %buffer_0_value_V_lo = load i32* %buffer_0_value_V_ad_2, align 4
  %p_Val2_14_0_phi = select i1 %tmp_8, i32 %buffer_1_value_V_lo, i32 %buffer_0_value_V_lo
  %p_Val2_14_1_phi = select i1 %tmp_8, i32 %buffer_0_value_V_lo, i32 %buffer_1_value_V_lo
  %p_Result_s = call i96 @_ssdm_op_BitConcatenate.i96.i32.i32.i32(i32 %tmp_value_V_4, i32 %p_Val2_14_1_phi, i32 %p_Val2_14_0_phi)
  call void @_ssdm_op_Write.ap_fifo.volatile.i96P(i96* %slice_stream_V_value_V, i96 %p_Result_s)
  br label %._crit_edge

branch5:                                          ; preds = %._crit_edge
  store i32 %tmp_value_V_4, i32* %buffer_1_value_V_ad, align 4
  br label %._crit_edge31
}

define internal fastcc void @call.1(i32* %in_stream_V_value_V, i128* %out_stream_V_value_V) {
codeRepl:
  call void (...)* @_ssdm_op_SpecInterface(i32* %in_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i128* %out_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecDataflowPipeline(i32 -1, [1 x i8]* @p_str) nounwind
  call void (...)* @_ssdm_op_SpecMemCore(i32* %in_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i128* %out_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  %slice_stream_V_value = alloca i64, align 8
  %empty = call i32 (...)* @_ssdm_op_SpecChannel([23 x i8]* @slice_stream_OC_V_OC, i32 1, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 1, i32 1, i64* %slice_stream_V_value, i64* %slice_stream_V_value)
  call void (...)* @_ssdm_op_SpecInterface(i64* %slice_stream_V_value, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i64* %slice_stream_V_value, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call fastcc void @call_Loop_LB2D_buf_p.1(i32* %in_stream_V_value_V, i64* %slice_stream_V_value)
  call fastcc void @call_Loop_LB2D_shift.1(i64* %slice_stream_V_value, i128* %out_stream_V_value_V)
  ret void
}

define internal fastcc void @call(i32* %in_stream_V_value_V, i288* %out_stream_V_value_V) {
codeRepl:
  call void (...)* @_ssdm_op_SpecInterface(i288* %out_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i32* %in_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecDataflowPipeline(i32 -1, [1 x i8]* @p_str) nounwind
  call void (...)* @_ssdm_op_SpecMemCore(i288* %out_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i32* %in_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  %slice_stream_V_value = alloca i96, align 8
  %empty = call i32 (...)* @_ssdm_op_SpecChannel([23 x i8]* @slice_stream_OC_V_OC, i32 1, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 1, i32 1, i96* %slice_stream_V_value, i96* %slice_stream_V_value)
  call void (...)* @_ssdm_op_SpecInterface(i96* %slice_stream_V_value, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i96* %slice_stream_V_value, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call fastcc void @call_Loop_LB2D_buf_p(i32* %in_stream_V_value_V, i96* %slice_stream_V_value)
  call fastcc void @call_Loop_LB2D_shift(i96* %slice_stream_V_value, i288* %out_stream_V_value_V)
  ret void
}

define weak void @_ssdm_op_Write.ap_fifo.volatile.i96P(i96*, i96) {
entry:
  %empty = call i96 @_autotb_FifoWrite_i96(i96* %0, i96 %1)
  ret void
}

define weak void @_ssdm_op_Write.ap_fifo.volatile.i64P(i64*, i64) {
entry:
  %empty = call i64 @_autotb_FifoWrite_i64(i64* %0, i64 %1)
  ret void
}

define weak void @_ssdm_op_Write.ap_fifo.volatile.i32P(i32*, i32) {
entry:
  %empty = call i32 @_autotb_FifoWrite_i32(i32* %0, i32 %1)
  ret void
}

define weak void @_ssdm_op_Write.ap_fifo.volatile.i288P(i288*, i288) {
entry:
  %empty = call i288 @_autotb_FifoWrite_i288(i288* %0, i288 %1)
  ret void
}

define weak void @_ssdm_op_Write.ap_fifo.volatile.i128P(i128*, i128) {
entry:
  %empty = call i128 @_autotb_FifoWrite_i128(i128* %0, i128 %1)
  ret void
}

define weak void @_ssdm_op_Write.ap_auto.volatile.i32P.i1P(i32*, i1*, i32, i1) {
entry:
  store i32 %2, i32* %0
  store i1 %3, i1* %1
  ret void
}

define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecRegionEnd(...) {
entry:
  ret i32 0
}

define weak i32 @_ssdm_op_SpecRegionBegin(...) {
entry:
  ret i32 0
}

define weak void @_ssdm_op_SpecPipeline(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecMemCore(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecLoopTripCount(...) {
entry:
  ret i32 0
}

define weak void @_ssdm_op_SpecLoopName(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecDataflowPipeline(...) nounwind {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecChannel(...) {
entry:
  ret i32 0
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

define weak i96 @_ssdm_op_Read.ap_fifo.volatile.i96P(i96*) {
entry:
  %empty = call i96 @_autotb_FifoRead_i96(i96* %0)
  ret i96 %empty
}

define weak i64 @_ssdm_op_Read.ap_fifo.volatile.i64P(i64*) {
entry:
  %empty = call i64 @_autotb_FifoRead_i64(i64* %0)
  ret i64 %empty
}

define weak i32 @_ssdm_op_Read.ap_fifo.volatile.i32P(i32*) {
entry:
  %empty = call i32 @_autotb_FifoRead_i32(i32* %0)
  ret i32 %empty
}

define weak i288 @_ssdm_op_Read.ap_fifo.volatile.i288P(i288*) {
entry:
  %empty = call i288 @_autotb_FifoRead_i288(i288* %0)
  ret i288 %empty
}

define weak i128 @_ssdm_op_Read.ap_fifo.volatile.i128P(i128*) {
entry:
  %empty = call i128 @_autotb_FifoRead_i128(i128* %0)
  ret i128 %empty
}

define weak { i32, i1 } @_ssdm_op_Read.ap_auto.volatile.i32P.i1P(i32*, i1*) {
entry:
  %empty = load i32* %0
  %empty_37 = load i1* %1
  %mrv_0 = insertvalue { i32, i1 } undef, i32 %empty, 0
  %mrv1 = insertvalue { i32, i1 } %mrv_0, i1 %empty_37, 1
  ret { i32, i1 } %mrv1
}

define weak i63 @_ssdm_op_PartSelect.i63.i64.i32.i32(i64, i32, i32) nounwind readnone {
entry:
  %empty = call i64 @llvm.part.select.i64(i64 %0, i32 %1, i32 %2)
  %empty_38 = trunc i64 %empty to i63
  ret i63 %empty_38
}

declare i52 @_ssdm_op_PartSelect.i52.i64.i32.i32(i64, i32, i32) nounwind readnone

define weak i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96, i32, i32) nounwind readnone {
entry:
  %empty = call i96 @llvm.part.select.i96(i96 %0, i32 %1, i32 %2)
  %empty_39 = trunc i96 %empty to i32
  ret i32 %empty_39
}

define weak i32 @_ssdm_op_PartSelect.i32.i64.i32.i32(i64, i32, i32) nounwind readnone {
entry:
  %empty = call i64 @llvm.part.select.i64(i64 %0, i32 %1, i32 %2)
  %empty_40 = trunc i64 %empty to i32
  ret i32 %empty_40
}

define weak i32 @_ssdm_op_PartSelect.i32.i288.i32.i32(i288, i32, i32) nounwind readnone {
entry:
  %empty = call i288 @llvm.part.select.i288(i288 %0, i32 %1, i32 %2)
  %empty_41 = trunc i288 %empty to i32
  ret i32 %empty_41
}

define weak i32 @_ssdm_op_PartSelect.i32.i137.i32.i32(i137, i32, i32) nounwind readnone {
entry:
  %empty = call i137 @llvm.part.select.i137(i137 %0, i32 %1, i32 %2)
  %empty_42 = trunc i137 %empty to i32
  ret i32 %empty_42
}

define weak i32 @_ssdm_op_PartSelect.i32.i128.i32.i32(i128, i32, i32) nounwind readnone {
entry:
  %empty = call i128 @llvm.part.select.i128(i128 %0, i32 %1, i32 %2)
  %empty_43 = trunc i128 %empty to i32
  ret i32 %empty_43
}

define weak i31 @_ssdm_op_PartSelect.i31.i288.i32.i32(i288, i32, i32) nounwind readnone {
entry:
  %empty = call i288 @llvm.part.select.i288(i288 %0, i32 %1, i32 %2)
  %empty_44 = trunc i288 %empty to i31
  ret i31 %empty_44
}

define weak i31 @_ssdm_op_PartSelect.i31.i137.i32.i32(i137, i32, i32) nounwind readnone {
entry:
  %empty = call i137 @llvm.part.select.i137(i137 %0, i32 %1, i32 %2)
  %empty_45 = trunc i137 %empty to i31
  ret i31 %empty_45
}

declare i30 @_ssdm_op_PartSelect.i30.i31.i32.i32(i31, i32, i32) nounwind readnone

define weak i30 @_ssdm_op_PartSelect.i30.i288.i32.i32(i288, i32, i32) nounwind readnone {
entry:
  %empty = call i288 @llvm.part.select.i288(i288 %0, i32 %1, i32 %2)
  %empty_46 = trunc i288 %empty to i30
  ret i30 %empty_46
}

define weak i11 @_ssdm_op_PartSelect.i11.i64.i32.i32(i64, i32, i32) nounwind readnone {
entry:
  %empty = call i64 @llvm.part.select.i64(i64 %0, i32 %1, i32 %2)
  %empty_47 = trunc i64 %empty to i11
  ret i11 %empty_47
}

define weak i10 @_ssdm_op_PartSelect.i10.i11.i32.i32(i11, i32, i32) nounwind readnone {
entry:
  %empty = call i11 @llvm.part.select.i11(i11 %0, i32 %1, i32 %2)
  %empty_48 = trunc i11 %empty to i10
  ret i10 %empty_48
}

declare i1 @_ssdm_op_PartSelect.i1.i64.i32.i32(i64, i32, i32) nounwind readnone

define weak i1 @_ssdm_op_BitSelect.i1.i64.i32(i64, i32) nounwind readnone {
entry:
  %empty = zext i32 %1 to i64
  %empty_49 = shl i64 1, %empty
  %empty_50 = and i64 %0, %empty_49
  %empty_51 = icmp ne i64 %empty_50, 0
  ret i1 %empty_51
}

define weak i1 @_ssdm_op_BitSelect.i1.i54.i32(i54, i32) nounwind readnone {
entry:
  %empty = zext i32 %1 to i54
  %empty_52 = shl i54 1, %empty
  %empty_53 = and i54 %0, %empty_52
  %empty_54 = icmp ne i54 %empty_53, 0
  ret i1 %empty_54
}

define weak i1 @_ssdm_op_BitSelect.i1.i12.i32(i12, i32) nounwind readnone {
entry:
  %empty = trunc i32 %1 to i12
  %empty_55 = shl i12 1, %empty
  %empty_56 = and i12 %0, %empty_55
  %empty_57 = icmp ne i12 %empty_56, 0
  ret i1 %empty_57
}

define weak i96 @_ssdm_op_BitConcatenate.i96.i32.i32.i32(i32, i32, i32) nounwind readnone {
entry:
  %empty = zext i32 %1 to i64
  %empty_58 = zext i32 %2 to i64
  %empty_59 = shl i64 %empty, 32
  %empty_60 = or i64 %empty_59, %empty_58
  %empty_61 = zext i32 %0 to i96
  %empty_62 = zext i64 %empty_60 to i96
  %empty_63 = shl i96 %empty_61, 64
  %empty_64 = or i96 %empty_63, %empty_62
  ret i96 %empty_64
}

define weak i64 @_ssdm_op_BitConcatenate.i64.i32.i32(i32, i32) nounwind readnone {
entry:
  %empty = zext i32 %0 to i64
  %empty_65 = zext i32 %1 to i64
  %empty_66 = shl i64 %empty, 32
  %empty_67 = or i64 %empty_66, %empty_65
  ret i64 %empty_67
}

define weak i54 @_ssdm_op_BitConcatenate.i54.i1.i52.i1(i1, i52, i1) nounwind readnone {
entry:
  %empty = zext i52 %1 to i53
  %empty_68 = zext i1 %2 to i53
  %empty_69 = shl i53 %empty, 1
  %empty_70 = or i53 %empty_69, %empty_68
  %empty_71 = zext i1 %0 to i54
  %empty_72 = zext i53 %empty_70 to i54
  %empty_73 = shl i54 %empty_71, 53
  %empty_74 = or i54 %empty_73, %empty_72
  ret i54 %empty_74
}

define weak i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31, i1) nounwind readnone {
entry:
  %empty = zext i31 %0 to i32
  %empty_75 = zext i1 %1 to i32
  %empty_76 = shl i32 %empty, 1
  %empty_77 = or i32 %empty_76, %empty_75
  ret i32 %empty_77
}

define weak i32 @_ssdm_op_BitConcatenate.i32.i30.i2(i30, i2) nounwind readnone {
entry:
  %empty = zext i30 %0 to i32
  %empty_78 = zext i2 %1 to i32
  %empty_79 = shl i32 %empty, 2
  %empty_80 = or i32 %empty_79, %empty_78
  ret i32 %empty_80
}

define weak i288 @_ssdm_op_BitConcatenate.i288.i32.i32.i32.i32.i32.i32.i32.i32.i32(i32, i32, i32, i32, i32, i32, i32, i32, i32) nounwind readnone {
entry:
  %empty = zext i32 %7 to i64
  %empty_81 = zext i32 %8 to i64
  %empty_82 = shl i64 %empty, 32
  %empty_83 = or i64 %empty_82, %empty_81
  %empty_84 = zext i32 %6 to i96
  %empty_85 = zext i64 %empty_83 to i96
  %empty_86 = shl i96 %empty_84, 64
  %empty_87 = or i96 %empty_86, %empty_85
  %empty_88 = zext i32 %5 to i128
  %empty_89 = zext i96 %empty_87 to i128
  %empty_90 = shl i128 %empty_88, 96
  %empty_91 = or i128 %empty_90, %empty_89
  %empty_92 = zext i32 %4 to i160
  %empty_93 = zext i128 %empty_91 to i160
  %empty_94 = shl i160 %empty_92, 128
  %empty_95 = or i160 %empty_94, %empty_93
  %empty_96 = zext i32 %3 to i192
  %empty_97 = zext i160 %empty_95 to i192
  %empty_98 = shl i192 %empty_96, 160
  %empty_99 = or i192 %empty_98, %empty_97
  %empty_100 = zext i32 %2 to i224
  %empty_101 = zext i192 %empty_99 to i224
  %empty_102 = shl i224 %empty_100, 192
  %empty_103 = or i224 %empty_102, %empty_101
  %empty_104 = zext i32 %1 to i256
  %empty_105 = zext i224 %empty_103 to i256
  %empty_106 = shl i256 %empty_104, 224
  %empty_107 = or i256 %empty_106, %empty_105
  %empty_108 = zext i32 %0 to i288
  %empty_109 = zext i256 %empty_107 to i288
  %empty_110 = shl i288 %empty_108, 256
  %empty_111 = or i288 %empty_110, %empty_109
  ret i288 %empty_111
}

define weak i128 @_ssdm_op_BitConcatenate.i128.i32.i32.i32.i32(i32, i32, i32, i32) nounwind readnone {
entry:
  %empty = zext i32 %2 to i64
  %empty_112 = zext i32 %3 to i64
  %empty_113 = shl i64 %empty, 32
  %empty_114 = or i64 %empty_113, %empty_112
  %empty_115 = zext i32 %1 to i96
  %empty_116 = zext i64 %empty_114 to i96
  %empty_117 = shl i96 %empty_115, 64
  %empty_118 = or i96 %empty_117, %empty_116
  %empty_119 = zext i32 %0 to i128
  %empty_120 = zext i96 %empty_118 to i128
  %empty_121 = shl i128 %empty_119, 96
  %empty_122 = or i128 %empty_121, %empty_120
  ret i128 %empty_122
}

declare void @_ssdm_SpecDependence(...) nounwind

declare i96 @_autotb_FifoWrite_i96(i96*, i96)

declare i64 @_autotb_FifoWrite_i64(i64*, i64)

declare i32 @_autotb_FifoWrite_i32(i32*, i32)

declare i288 @_autotb_FifoWrite_i288(i288*, i288)

declare i128 @_autotb_FifoWrite_i128(i128*, i128)

declare i96 @_autotb_FifoRead_i96(i96*)

declare i64 @_autotb_FifoRead_i64(i64*)

declare i32 @_autotb_FifoRead_i32(i32*)

declare i288 @_autotb_FifoRead_i288(i288*)

declare i128 @_autotb_FifoRead_i128(i128*)

declare void @_GLOBAL__I_a110() nounwind section ".text.startup"

declare void @_GLOBAL__I_a() nounwind section ".text.startup"

define internal fastcc void @Loop_3_proc(i32* %p_p2_mul1_stencil_stream_V_value_V, i32* %hw_output_V_value_V, i1* %hw_output_V_last_V) {
newFuncRoot:
  call void (...)* @_ssdm_op_SpecMemCore(i32* %p_p2_mul1_stencil_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i32* %p_p2_mul1_stencil_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  br label %.preheader

.exitStub:                                        ; preds = %.preheader
  ret void

.preheader37:                                     ; preds = %.preheader
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 2064609, i64 2064609, i64 2064609)
  %exitcond7 = icmp eq i11 %p_hw_output_x_scan_2, -131
  %p_hw_output_x_scan_s = select i1 %exitcond7, i11 0, i11 %p_hw_output_x_scan_2
  %p_hw_output_y_scan_2 = add i11 1, %p_hw_output_y_scan_1
  %tmp_7_mid1 = icmp eq i11 %p_hw_output_y_scan_2, -972
  %tmp_s = icmp eq i11 %p_hw_output_y_scan_1, -972
  %tmp_7_mid2 = select i1 %exitcond7, i1 %tmp_7_mid1, i1 %tmp_s
  %p_hw_output_y_scan_s = select i1 %exitcond7, i11 %p_hw_output_y_scan_2, i11 %p_hw_output_y_scan_1
  %tmp_3 = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str6)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %tmp_value_V_5 = call i32 @_ssdm_op_Read.ap_fifo.volatile.i32P(i32* %p_p2_mul1_stencil_stream_V_value_V)
  %p_417 = sitofp i32 %tmp_value_V_5 to float
  %p_418 = fpext float %p_417 to double
  %p_419 = fmul double %p_418, 1.250000e-01
  %p_Val2_s = bitcast double %p_419 to i64
  %loc_V = call i11 @_ssdm_op_PartSelect.i11.i64.i32.i32(i64 %p_Val2_s, i32 52, i32 62) nounwind
  %loc_V_1 = trunc i64 %p_Val2_s to i52
  %tmp_i_i = call i54 @_ssdm_op_BitConcatenate.i54.i1.i52.i1(i1 true, i52 %loc_V_1, i1 false)
  %tmp_i_cast_i = zext i54 %tmp_i_i to i137
  %tmp_i_i_cast_i = zext i11 %loc_V to i12
  %sh_assign = add i12 -1023, %tmp_i_i_cast_i
  %isNeg = call i1 @_ssdm_op_BitSelect.i1.i12.i32(i12 %sh_assign, i32 11)
  %tmp_1_i_i = sub i11 1023, %loc_V
  %tmp_1_i_cast_i = sext i11 %tmp_1_i_i to i12
  %sh_assign_1 = select i1 %isNeg, i12 %tmp_1_i_cast_i, i12 %sh_assign
  %sh_assign_1_i_cast_i = sext i12 %sh_assign_1 to i32
  %tmp_2_i_i = zext i32 %sh_assign_1_i_cast_i to i137
  %tmp_2_i_cast_i = zext i32 %sh_assign_1_i_cast_i to i54
  %tmp_3_i_i = lshr i54 %tmp_i_i, %tmp_2_i_cast_i
  %tmp_4_i_i = shl i137 %tmp_i_cast_i, %tmp_2_i_i
  %tmp = call i1 @_ssdm_op_BitSelect.i1.i54.i32(i54 %tmp_3_i_i, i32 53)
  %tmp_1 = zext i1 %tmp to i32
  %tmp_4 = call i32 @_ssdm_op_PartSelect.i32.i137.i32.i32(i137 %tmp_4_i_i, i32 53, i32 84)
  %p_Val2_4 = select i1 %isNeg, i32 %tmp_1, i32 %tmp_4
  %tmp_2 = icmp eq i11 %p_hw_output_x_scan_s, -132
  %tmp_last_V = and i1 %tmp_2, %tmp_7_mid2
  call void @_ssdm_op_Write.ap_auto.volatile.i32P.i1P(i32* %hw_output_V_value_V, i1* %hw_output_V_last_V, i32 %p_Val2_4, i1 %tmp_last_V)
  %empty_123 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str6, i32 %tmp_3)
  %p_hw_output_x_scan_1 = add i11 1, %p_hw_output_x_scan_s
  br label %.preheader

.preheader:                                       ; preds = %newFuncRoot, %.preheader37
  %indvar_flatten = phi i21 [ 0, %newFuncRoot ], [ %indvar_flatten_next, %.preheader37 ]
  %p_hw_output_y_scan_1 = phi i11 [ 0, %newFuncRoot ], [ %p_hw_output_y_scan_s, %.preheader37 ]
  %p_hw_output_x_scan_2 = phi i11 [ 0, %newFuncRoot ], [ %p_hw_output_x_scan_1, %.preheader37 ]
  %exitcond_flatten = icmp eq i21 %indvar_flatten, -32543
  %indvar_flatten_next = add i21 %indvar_flatten, 1
  br i1 %exitcond_flatten, label %.exitStub, label %.preheader37
}

define internal fastcc void @Loop_2_proc(i128* %p_mul_stencil_stream_V_value_V, i32* %p_p2_mul1_stencil_stream_V_value_V) {
newFuncRoot:
  call void (...)* @_ssdm_op_SpecMemCore(i32* %p_p2_mul1_stencil_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i128* %p_mul_stencil_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i32* %p_p2_mul1_stencil_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i128* %p_mul_stencil_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  br label %.preheader38

.preheader37.exitStub:                            ; preds = %.preheader38
  ret void

.preheader38.preheader:                           ; preds = %.preheader38
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 2064609, i64 2064609, i64 2064609)
  %tmp_1 = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str5)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %tmp_value_V = call i128 @_ssdm_op_Read.ap_fifo.volatile.i128P(i128* %p_mul_stencil_stream_V_value_V)
  %p_381 = trunc i128 %tmp_value_V to i32
  %p_382 = sitofp i32 %p_381 to float
  %p_383 = fpext float %p_382 to double
  %p_mul_stencil_value_0 = call i32 @_ssdm_op_PartSelect.i32.i128.i32.i32(i128 %tmp_value_V, i32 32, i32 63)
  %p_391 = sitofp i32 %p_mul_stencil_value_0 to float
  %p_392 = fpext float %p_391 to double
  %p_mul_stencil_value_0_1 = call i32 @_ssdm_op_PartSelect.i32.i128.i32.i32(i128 %tmp_value_V, i32 64, i32 95)
  %p_400 = sitofp i32 %p_mul_stencil_value_0_1 to float
  %p_401 = fpext float %p_400 to double
  %p_mul_stencil_value_0_2 = call i32 @_ssdm_op_PartSelect.i32.i128.i32.i32(i128 %tmp_value_V, i32 96, i32 127)
  %p_409 = sitofp i32 %p_mul_stencil_value_0_2 to float
  %p_410 = fpext float %p_409 to double
  %p_384 = fmul double %p_383, 6.250000e-02
  %p_Val2_5 = bitcast double %p_384 to i64
  %p_Result_s = call i1 @_ssdm_op_BitSelect.i1.i64.i32(i64 %p_Val2_5, i32 63)
  %loc_V = call i11 @_ssdm_op_PartSelect.i11.i64.i32.i32(i64 %p_Val2_5, i32 52, i32 62) nounwind
  %loc_V_2 = trunc i64 %p_Val2_5 to i52
  %tmp_i_i = call i54 @_ssdm_op_BitConcatenate.i54.i1.i52.i1(i1 true, i52 %loc_V_2, i1 false)
  %tmp_i_cast_i = zext i54 %tmp_i_i to i137
  %tmp_i_i_cast_i = zext i11 %loc_V to i12
  %sh_assign = add i12 -1023, %tmp_i_i_cast_i
  %isNeg = call i1 @_ssdm_op_BitSelect.i1.i12.i32(i12 %sh_assign, i32 11)
  %tmp_8_i_i = sub i11 1023, %loc_V
  %tmp_8_i_cast_i = sext i11 %tmp_8_i_i to i12
  %sh_assign_2 = select i1 %isNeg, i12 %tmp_8_i_cast_i, i12 %sh_assign
  %sh_assign_2_i_cast_i = sext i12 %sh_assign_2 to i32
  %tmp_9_i_i = zext i32 %sh_assign_2_i_cast_i to i137
  %tmp_9_i_cast_i = zext i32 %sh_assign_2_i_cast_i to i54
  %tmp_10_i_i = lshr i54 %tmp_i_i, %tmp_9_i_cast_i
  %tmp_11_i_i = shl i137 %tmp_i_cast_i, %tmp_9_i_i
  %tmp_17 = call i1 @_ssdm_op_BitSelect.i1.i54.i32(i54 %tmp_10_i_i, i32 53)
  %tmp_7 = zext i1 %tmp_17 to i31
  %tmp_8 = call i31 @_ssdm_op_PartSelect.i31.i137.i32.i32(i137 %tmp_11_i_i, i32 53, i32 83)
  %p_Val2_7 = select i1 %isNeg, i31 %tmp_7, i31 %tmp_8
  %tmp_13_i_i = zext i31 %p_Val2_7 to i32
  %tmp_16_i_i = sub nsw i32 0, %tmp_13_i_i
  %p_Val2_26 = select i1 %p_Result_s, i32 %tmp_16_i_i, i32 %tmp_13_i_i
  %p_393 = fmul double %p_392, 6.250000e-02
  %p_Val2_s = bitcast double %p_393 to i64
  %p_Result_4 = call i1 @_ssdm_op_BitSelect.i1.i64.i32(i64 %p_Val2_s, i32 63)
  %loc_V_3 = call i11 @_ssdm_op_PartSelect.i11.i64.i32.i32(i64 %p_Val2_s, i32 52, i32 62) nounwind
  %loc_V_4 = trunc i64 %p_Val2_s to i52
  %tmp_i_i7 = call i54 @_ssdm_op_BitConcatenate.i54.i1.i52.i1(i1 true, i52 %loc_V_4, i1 false)
  %tmp_i_cast_i8 = zext i54 %tmp_i_i7 to i137
  %tmp_i_i_cast_i9 = zext i11 %loc_V_3 to i12
  %sh_assign_3 = add i12 -1023, %tmp_i_i_cast_i9
  %isNeg_1 = call i1 @_ssdm_op_BitSelect.i1.i12.i32(i12 %sh_assign_3, i32 11)
  %tmp_8_i_i1 = sub i11 1023, %loc_V_3
  %tmp_8_i_cast_i1 = sext i11 %tmp_8_i_i1 to i12
  %sh_assign_4 = select i1 %isNeg_1, i12 %tmp_8_i_cast_i1, i12 %sh_assign_3
  %sh_assign_2_i_cast_i_1 = sext i12 %sh_assign_4 to i32
  %tmp_9_i_i1 = zext i32 %sh_assign_2_i_cast_i_1 to i137
  %tmp_9_i_cast_i1 = zext i32 %sh_assign_2_i_cast_i_1 to i54
  %tmp_10_i_i1 = lshr i54 %tmp_i_i7, %tmp_9_i_cast_i1
  %tmp_11_i_i1 = shl i137 %tmp_i_cast_i8, %tmp_9_i_i1
  %tmp_26 = call i1 @_ssdm_op_BitSelect.i1.i54.i32(i54 %tmp_10_i_i1, i32 53)
  %tmp_s = zext i1 %tmp_26 to i31
  %tmp_2 = call i31 @_ssdm_op_PartSelect.i31.i137.i32.i32(i137 %tmp_11_i_i1, i32 53, i32 83)
  %p_Val2_15 = select i1 %isNeg_1, i31 %tmp_s, i31 %tmp_2
  %tmp_27 = trunc i31 %p_Val2_15 to i30
  %tmp_16_i_i1 = sub i30 0, %tmp_27
  %tmp_28 = trunc i31 %p_Val2_15 to i30
  %tmp_3 = select i1 %p_Result_4, i30 %tmp_16_i_i1, i30 %tmp_28
  %p_396 = call i32 @_ssdm_op_BitConcatenate.i32.i30.i2(i30 %tmp_3, i2 0)
  %p_402 = fmul double %p_401, 6.250000e-02
  %p_Val2_17 = bitcast double %p_402 to i64
  %p_Result_5 = call i1 @_ssdm_op_BitSelect.i1.i64.i32(i64 %p_Val2_17, i32 63)
  %loc_V_5 = call i11 @_ssdm_op_PartSelect.i11.i64.i32.i32(i64 %p_Val2_17, i32 52, i32 62) nounwind
  %loc_V_6 = trunc i64 %p_Val2_17 to i52
  %tmp_i_i1 = call i54 @_ssdm_op_BitConcatenate.i54.i1.i52.i1(i1 true, i52 %loc_V_6, i1 false)
  %tmp_i_cast_i1 = zext i54 %tmp_i_i1 to i137
  %tmp_i_i_cast_i1 = zext i11 %loc_V_5 to i12
  %sh_assign_5 = add i12 -1023, %tmp_i_i_cast_i1
  %isNeg_2 = call i1 @_ssdm_op_BitSelect.i1.i12.i32(i12 %sh_assign_5, i32 11)
  %tmp_8_i_i2 = sub i11 1023, %loc_V_5
  %tmp_8_i_cast_i2 = sext i11 %tmp_8_i_i2 to i12
  %sh_assign_6 = select i1 %isNeg_2, i12 %tmp_8_i_cast_i2, i12 %sh_assign_5
  %sh_assign_2_i_cast_i_2 = sext i12 %sh_assign_6 to i32
  %tmp_9_i_i2 = zext i32 %sh_assign_2_i_cast_i_2 to i137
  %tmp_9_i_cast_i2 = zext i32 %sh_assign_2_i_cast_i_2 to i54
  %tmp_10_i_i2 = lshr i54 %tmp_i_i1, %tmp_9_i_cast_i2
  %tmp_11_i_i2 = shl i137 %tmp_i_cast_i1, %tmp_9_i_i2
  %tmp_32 = call i1 @_ssdm_op_BitSelect.i1.i54.i32(i54 %tmp_10_i_i2, i32 53)
  %tmp_4 = zext i1 %tmp_32 to i31
  %tmp_5 = call i31 @_ssdm_op_PartSelect.i31.i137.i32.i32(i137 %tmp_11_i_i2, i32 53, i32 83)
  %p_Val2_19 = select i1 %isNeg_2, i31 %tmp_4, i31 %tmp_5
  %tmp_16_i_i2 = sub i31 0, %p_Val2_19
  %tmp_6 = select i1 %p_Result_5, i31 %tmp_16_i_i2, i31 %p_Val2_19
  %p_405 = call i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31 %tmp_6, i1 false)
  %p_411 = fmul double %p_410, 6.250000e-02
  %p_Val2_21 = bitcast double %p_411 to i64
  %p_Result_6 = call i1 @_ssdm_op_BitSelect.i1.i64.i32(i64 %p_Val2_21, i32 63)
  %loc_V_7 = call i11 @_ssdm_op_PartSelect.i11.i64.i32.i32(i64 %p_Val2_21, i32 52, i32 62) nounwind
  %loc_V_8 = trunc i64 %p_Val2_21 to i52
  %tmp_i_i2 = call i54 @_ssdm_op_BitConcatenate.i54.i1.i52.i1(i1 true, i52 %loc_V_8, i1 false)
  %tmp_i_cast_i2 = zext i54 %tmp_i_i2 to i137
  %tmp_i_i_cast_i2 = zext i11 %loc_V_7 to i12
  %sh_assign_7 = add i12 -1023, %tmp_i_i_cast_i2
  %isNeg_3 = call i1 @_ssdm_op_BitSelect.i1.i12.i32(i12 %sh_assign_7, i32 11)
  %tmp_8_i_i3 = sub i11 1023, %loc_V_7
  %tmp_8_i_cast_i3 = sext i11 %tmp_8_i_i3 to i12
  %sh_assign_8 = select i1 %isNeg_3, i12 %tmp_8_i_cast_i3, i12 %sh_assign_7
  %sh_assign_2_i_cast_i_3 = sext i12 %sh_assign_8 to i32
  %tmp_9_i_i3 = zext i32 %sh_assign_2_i_cast_i_3 to i137
  %tmp_9_i_cast_i3 = zext i32 %sh_assign_2_i_cast_i_3 to i54
  %tmp_10_i_i3 = lshr i54 %tmp_i_i2, %tmp_9_i_cast_i3
  %tmp_11_i_i3 = shl i137 %tmp_i_cast_i2, %tmp_9_i_i3
  %tmp_36 = call i1 @_ssdm_op_BitSelect.i1.i54.i32(i54 %tmp_10_i_i3, i32 53)
  %tmp_9 = zext i1 %tmp_36 to i31
  %tmp_10 = call i31 @_ssdm_op_PartSelect.i31.i137.i32.i32(i137 %tmp_11_i_i3, i32 53, i32 83)
  %p_Val2_23 = select i1 %isNeg_3, i31 %tmp_9, i31 %tmp_10
  %tmp_13_i_i3 = zext i31 %p_Val2_23 to i32
  %tmp_16_i_i3 = sub nsw i32 0, %tmp_13_i_i3
  %p_Val2_27 = select i1 %p_Result_6, i32 %tmp_16_i_i3, i32 %tmp_13_i_i3
  %tmp = add i32 %p_396, %p_Val2_26
  %tmp5 = add i32 %p_405, %p_Val2_27
  %p_415 = add nsw i32 %tmp5, %tmp
  call void @_ssdm_op_Write.ap_fifo.volatile.i32P(i32* %p_p2_mul1_stencil_stream_V_value_V, i32 %p_415)
  %empty_124 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str5, i32 %tmp_1)
  br label %.preheader38

.preheader38:                                     ; preds = %newFuncRoot, %.preheader38.preheader
  %indvar_flatten = phi i21 [ 0, %newFuncRoot ], [ %indvar_flatten_next, %.preheader38.preheader ]
  %exitcond_flatten = icmp eq i21 %indvar_flatten, -32543
  %indvar_flatten_next = add i21 %indvar_flatten, 1
  br i1 %exitcond_flatten, label %.preheader37.exitStub, label %.preheader38.preheader
}

define internal fastcc void @Loop_1_proc(i288* %p_hw_input_stencil_stream_V_value_V, i32* %p_mul_stencil_update_stream_V_value_V) {
newFuncRoot:
  call void (...)* @_ssdm_op_SpecMemCore(i32* %p_mul_stencil_update_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i288* %p_hw_input_stencil_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i32* %p_mul_stencil_update_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i288* %p_hw_input_stencil_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  br label %.preheader39

.exitStub:                                        ; preds = %.preheader39
  ret void

.preheader39.preheader:                           ; preds = %.preheader39
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 2067604, i64 2067604, i64 2067604)
  %tmp = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str3)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %tmp_value_V = call i288 @_ssdm_op_Read.ap_fifo.volatile.i288P(i288* %p_hw_input_stencil_stream_V_value_V)
  %p_327 = trunc i288 %tmp_value_V to i32
  %p_339 = call i32 @_ssdm_op_PartSelect.i32.i288.i32.i32(i288 %tmp_value_V, i32 64, i32 95)
  %p_363 = call i32 @_ssdm_op_PartSelect.i32.i288.i32.i32(i288 %tmp_value_V, i32 192, i32 223)
  %p_375 = call i32 @_ssdm_op_PartSelect.i32.i288.i32.i32(i288 %tmp_value_V, i32 256, i32 287)
  %tmp_s = call i31 @_ssdm_op_PartSelect.i31.i288.i32.i32(i288 %tmp_value_V, i32 32, i32 62)
  %p_336 = call i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31 %tmp_s, i1 false)
  %tmp_11 = call i31 @_ssdm_op_PartSelect.i31.i288.i32.i32(i288 %tmp_value_V, i32 96, i32 126)
  %p_348 = call i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31 %tmp_11, i1 false)
  %tmp_12 = call i30 @_ssdm_op_PartSelect.i30.i288.i32.i32(i288 %tmp_value_V, i32 128, i32 157)
  %p_354 = call i32 @_ssdm_op_BitConcatenate.i32.i30.i2(i30 %tmp_12, i2 0)
  %tmp_13 = call i31 @_ssdm_op_PartSelect.i31.i288.i32.i32(i288 %tmp_value_V, i32 160, i32 190)
  %p_360 = call i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31 %tmp_13, i1 false)
  %tmp_14 = call i31 @_ssdm_op_PartSelect.i31.i288.i32.i32(i288 %tmp_value_V, i32 224, i32 254)
  %p_372 = call i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31 %tmp_14, i1 false)
  %tmp2 = add i32 %p_327, %p_336
  %tmp3 = add i32 %p_348, %p_339
  %tmp1 = add i32 %tmp2, %tmp3
  %tmp5 = add i32 %p_360, %p_354
  %tmp7 = add i32 %p_375, %p_372
  %tmp6 = add i32 %p_363, %tmp7
  %tmp4 = add i32 %tmp5, %tmp6
  %p_379 = add nsw i32 %tmp1, %tmp4
  call void @_ssdm_op_Write.ap_fifo.volatile.i32P(i32* %p_mul_stencil_update_stream_V_value_V, i32 %p_379)
  %empty_125 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str3, i32 %tmp)
  br label %.preheader39

.preheader39:                                     ; preds = %newFuncRoot, %.preheader39.preheader
  %indvar_flatten = phi i21 [ 0, %newFuncRoot ], [ %indvar_flatten_next, %.preheader39.preheader ]
  %exitcond_flatten = icmp eq i21 %indvar_flatten, -29548
  %indvar_flatten_next = add i21 %indvar_flatten, 1
  br i1 %exitcond_flatten, label %.exitStub, label %.preheader39.preheader
}

!opencl.kernels = !{!0, !7, !13, !13, !16, !16, !22, !16, !16, !25, !16, !16, !16, !16, !16, !16, !16, !16, !16, !27, !29, !35, !38, !38, !44, !47, !47, !16, !16, !29, !16, !48, !16, !29, !51, !51, !51, !16, !16, !16, !16, !16, !29, !16, !29, !35, !54, !54, !56, !56, !56, !16, !16, !16, !16, !16, !16, !16, !16, !16, !58, !58, !58, !58, !58, !61, !61, !63, !65, !67, !67, !16, !16, !16, !16, !68, !70, !70, !16, !72, !75, !77, !79, !80, !51, !27, !81, !81, !29, !35, !82, !82, !16, !16, !16, !16, !16, !16, !16, !16, !16, !84, !13, !13, !85, !29, !29, !16, !86, !29, !35, !88, !88, !90, !90, !90, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !16, !92, !95, !95, !95, !95, !95, !97, !97, !99, !101, !103, !103, !16, !16, !16, !16, !104, !106, !106, !16, !107, !109, !111, !113, !80, !27, !81, !81, !29, !35, !114, !114, !16, !16, !16, !16, !16, !16, !16, !16, !16, !116, !16, !16, !16, !16, !117, !120, !120, !120, !120, !123, !123, !123, !123, !125, !125, !125, !125, !120, !120, !120, !120, !123, !123, !123, !123, !125, !125, !125, !125, !127, !130, !16, !16, !16, !134, !137, !137, !16, !138, !138, !140, !16, !16, !16, !13, !13, !16, !16, !142, !145, !145, !16, !147, !149, !149, !16, !151, !151, !153, !151, !151, !153, !155, !137, !137, !158, !16, !16, !16, !161, !137, !137, !16, !16, !16, !163, !137, !137, !165, !16, !16, !16, !167, !167, !169, !169, !171, !16, !16, !153, !153, !16, !173, !175, !177, !177, !35, !35, !181, !181, !183, !185, !185, !16, !16, !16, !16, !186, !188, !188, !16, !16, !35, !189, !189, !191, !191, !193, !195, !195, !196, !198, !198, !196, !200, !200, !65, !67, !67, !16, !16, !68, !70, !70, !35, !35, !82, !82, !65, !68, !70, !70, !16, !35, !202, !202, !204, !205, !205, !207, !16, !173, !204, !209, !209, !211, !211, !16, !16, !16, !16, !16, !16, !16, !16, !127, !213, !16, !16, !16, !134, !215, !215, !217, !16, !13, !13, !16, !16, !219, !147, !221, !221, !16, !223, !223, !225, !223, !223, !225, !155, !227, !16, !16, !16, !229, !137, !137, !171, !16, !16, !225, !225, !198, !198, !196, !127, !231, !16, !16, !16, !134, !137, !137, !16, !233, !233, !235, !16, !13, !13, !16, !16, !237, !147, !239, !239, !16, !241, !241, !243, !241, !241, !243, !155, !245, !16, !16, !16, !247, !137, !137, !171, !16, !16, !243, !243, !198, !198, !196, !127, !249, !16, !16, !16, !134, !137, !137, !16, !251, !251, !253, !16, !13, !13, !16, !16, !255, !147, !257, !257, !16, !259, !259, !261, !259, !259, !261, !155, !263, !16, !16, !16, !265, !137, !137, !171, !16, !16, !261, !261, !198, !198, !196, !267, !269, !16, !271, !271, !273, !271, !271, !273, !275, !16, !16, !16, !277, !137, !137, !16, !279, !281, !283, !283, !171, !16, !16, !273, !273, !16, !173, !175, !285, !285, !35, !35, !287, !287, !289, !291, !291, !16, !16, !16, !16, !292, !294, !294, !16, !16, !35, !295, !295, !191, !191, !193, !195, !195, !297, !299, !299, !297, !301, !301, !80, !51, !51, !16, !16, !27, !81, !81, !35, !35, !38, !38, !80, !27, !81, !81, !35, !302, !302, !204, !304, !304, !306, !16, !47, !47, !16, !16, !16, !16, !267, !308, !310, !310, !312, !310, !310, !312, !314, !16, !16, !16, !316, !137, !137, !171, !16, !16, !312, !312, !299, !299, !297, !267, !318, !320, !320, !322, !320, !320, !322, !324, !16, !16, !16, !326, !137, !137, !171, !16, !16, !322, !322, !299, !299, !297, !267, !328, !330, !330, !332, !330, !330, !332, !334, !16, !16, !16, !336, !137, !137, !171, !16, !16, !332, !332, !299, !299, !297, !338, !340, !16, !342, !344, !345, !345, !347, !345, !345, !347, !349, !16, !16, !16, !351, !137, !137, !16, !353, !354, !356, !356, !171, !16, !16, !347, !347, !16, !173, !175, !358, !358, !35, !35, !360, !360, !362, !364, !364, !16, !16, !16, !365, !367, !367, !16, !35, !368, !368, !191, !191, !193, !195, !195, !370, !372, !372, !370, !374, !374, !375, !377, !377, !16, !16, !378, !380, !380, !35, !35, !381, !381, !375, !378, !380, !380, !16, !35, !383, !383, !204, !385, !385, !387, !16, !389, !389, !16, !16, !16, !16, !16, !338, !391, !393, !393, !395, !393, !393, !395, !397, !16, !16, !399, !137, !137, !171, !16, !16, !395, !395, !372, !372, !370, !338, !401, !403, !403, !405, !403, !403, !405, !407, !16, !16, !16, !409, !137, !137, !171, !16, !16, !405, !405, !372, !372, !370, !338, !411, !413, !413, !415, !413, !413, !415, !417, !16, !16, !16, !419, !137, !137, !171, !16, !16, !415, !415, !372, !372, !370, !127, !421, !16, !16, !16, !16, !423, !423, !425, !425, !427, !429, !429, !16, !173, !204, !431, !431, !13, !13, !16, !433, !147, !435, !435, !16, !151, !151, !153, !151, !151, !153, !155, !127, !437, !16, !16, !16, !16, !439, !439, !195, !195, !441, !443, !443, !16, !173, !204, !445, !445, !13, !13, !16, !447, !147, !449, !449, !16, !223, !223, !225, !16, !223, !223, !225, !155, !127, !451, !16, !16, !16, !16, !453, !453, !455, !455, !457, !459, !459, !16, !173, !204, !461, !461, !13, !13, !16, !463, !147, !465, !465, !16, !241, !241, !243, !16, !241, !241, !243, !155, !127, !467, !16, !16, !16, !16, !469, !469, !471, !471, !473, !475, !475, !16, !173, !204, !477, !477, !13, !13, !16, !479, !147, !481, !481, !16, !259, !259, !261, !16, !259, !259, !261, !155, !267, !483, !271, !271, !273, !271, !271, !273, !267, !485, !310, !310, !312, !310, !310, !312, !267, !487, !320, !320, !322, !320, !320, !322, !267, !489, !330, !330, !332, !330, !330, !332, !338, !491, !345, !345, !347, !345, !345, !347, !338, !493, !393, !393, !395, !393, !393, !395, !338, !495, !403, !403, !405, !403, !403, !405, !338, !497, !413, !413, !415, !413, !413, !415, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !499, !499, !499, !499, !499, !499, !499, !499, !499, !504, !504, !505, !16, !507, !16, !16, !16, !509, !509, !511, !511, !513, !16, !16, !16, !515, !16, !16, !16, !16, !517, !16, !191, !191, !193, !195, !195, !519, !504, !504, !505, !517, !191, !191, !193, !195, !195, !521, !504, !504, !505, !517, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !499, !499, !499, !499, !499, !499, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !499, !499, !499, !499, !499, !499, !499, !499, !499, !16, !499, !499, !499, !499, !499, !499, !523, !523, !523, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !523, !523, !523, !16, !523, !523, !523, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499, !16, !499, !499, !499}
!hls.encrypted.func = !{}
!llvm.map.gv = !{!527}

!0 = metadata !{null, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"hls::stream<AxiPackedStencil<uint32_t, 1, 1> > &", metadata !"hls::stream<AxiPackedStencil<uint32_t, 1, 1> > &"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_name", metadata !"hw_input", metadata !"hw_output"}
!6 = metadata !{metadata !"reqd_work_group_size", i32 1, i32 1, i32 1}
!7 = metadata !{null, metadata !8, metadata !9, metadata !10, metadata !11, metadata !12, metadata !6}
!8 = metadata !{metadata !"kernel_arg_addr_space", i32 0}
!9 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none"}
!10 = metadata !{metadata !"kernel_arg_type", metadata !"const struct AxiPackedStencil<uint, 1, 1, 1, 1> &"}
!11 = metadata !{metadata !"kernel_arg_type_qual", metadata !""}
!12 = metadata !{metadata !"kernel_arg_name", metadata !"din"}
!13 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !15, metadata !6}
!14 = metadata !{metadata !"kernel_arg_type", metadata !"int"}
!15 = metadata !{metadata !"kernel_arg_name", metadata !"val"}
!16 = metadata !{null, metadata !17, metadata !18, metadata !19, metadata !20, metadata !21, metadata !6}
!17 = metadata !{metadata !"kernel_arg_addr_space"}
!18 = metadata !{metadata !"kernel_arg_access_qual"}
!19 = metadata !{metadata !"kernel_arg_type"}
!20 = metadata !{metadata !"kernel_arg_type_qual"}
!21 = metadata !{metadata !"kernel_arg_name"}
!22 = metadata !{null, metadata !8, metadata !9, metadata !23, metadata !11, metadata !24, metadata !6}
!23 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<1> &"}
!24 = metadata !{metadata !"kernel_arg_name", metadata !"op2"}
!25 = metadata !{null, metadata !8, metadata !9, metadata !26, metadata !11, metadata !24, metadata !6}
!26 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<32> &"}
!27 = metadata !{null, metadata !8, metadata !9, metadata !28, metadata !11, metadata !15, metadata !6}
!28 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<32, false> &"}
!29 = metadata !{null, metadata !30, metadata !31, metadata !32, metadata !33, metadata !34, metadata !6}
!30 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0, i32 0, i32 0}
!31 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none", metadata !"none"}
!32 = metadata !{metadata !"kernel_arg_type", metadata !"size_t", metadata !"size_t", metadata !"size_t", metadata !"size_t"}
!33 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !"", metadata !""}
!34 = metadata !{metadata !"kernel_arg_name", metadata !"index_0", metadata !"index_1", metadata !"index_2", metadata !"index_3"}
!35 = metadata !{null, metadata !1, metadata !2, metadata !36, metadata !4, metadata !37, metadata !6}
!36 = metadata !{metadata !"kernel_arg_type", metadata !"int", metadata !"int"}
!37 = metadata !{metadata !"kernel_arg_name", metadata !"Hi", metadata !"Lo"}
!38 = metadata !{null, metadata !39, metadata !40, metadata !41, metadata !42, metadata !43, metadata !6}
!39 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 0, i32 0}
!40 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none"}
!41 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<32, false>*", metadata !"int", metadata !"int"}
!42 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !""}
!43 = metadata !{metadata !"kernel_arg_name", metadata !"bv", metadata !"h", metadata !"l"}
!44 = metadata !{null, metadata !8, metadata !9, metadata !45, metadata !11, metadata !46, metadata !6}
!45 = metadata !{metadata !"kernel_arg_type", metadata !"uint"}
!46 = metadata !{metadata !"kernel_arg_name", metadata !"in"}
!47 = metadata !{null, metadata !8, metadata !9, metadata !45, metadata !11, metadata !15, metadata !6}
!48 = metadata !{null, metadata !1, metadata !2, metadata !49, metadata !4, metadata !50, metadata !6}
!49 = metadata !{metadata !"kernel_arg_type", metadata !"ap_uint<32> &", metadata !"int &"}
!50 = metadata !{metadata !"kernel_arg_name", metadata !"in", metadata !"out"}
!51 = metadata !{null, metadata !8, metadata !9, metadata !52, metadata !11, metadata !53, metadata !6}
!52 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<32, false> &"}
!53 = metadata !{metadata !"kernel_arg_name", metadata !"ref"}
!54 = metadata !{null, metadata !39, metadata !40, metadata !55, metadata !42, metadata !43, metadata !6}
!55 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<128, false>*", metadata !"int", metadata !"int"}
!56 = metadata !{null, metadata !8, metadata !9, metadata !57, metadata !11, metadata !53, metadata !6}
!57 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<128, false> &"}
!58 = metadata !{null, metadata !1, metadata !2, metadata !59, metadata !4, metadata !60, metadata !6}
!59 = metadata !{metadata !"kernel_arg_type", metadata !"stream<PackedStencil<int, 1UL, 1UL, 1UL, 1UL> > &", metadata !"stream<PackedStencil<int, 2UL, 2UL, 1UL, 1UL> > &"}
!60 = metadata !{metadata !"kernel_arg_name", metadata !"in_stream", metadata !"out_stream"}
!61 = metadata !{null, metadata !1, metadata !2, metadata !62, metadata !4, metadata !60, metadata !6}
!62 = metadata !{metadata !"kernel_arg_type", metadata !"stream<PackedStencil<int, 1UL, 2UL, 1UL, 1UL> > &", metadata !"stream<PackedStencil<int, 2UL, 2UL, 1UL, 1UL> > &"}
!63 = metadata !{null, metadata !8, metadata !9, metadata !64, metadata !11, metadata !12, metadata !6}
!64 = metadata !{metadata !"kernel_arg_type", metadata !"const struct PackedStencil<int, 2, 2, 1, 1> &"}
!65 = metadata !{null, metadata !8, metadata !9, metadata !66, metadata !11, metadata !15, metadata !6}
!66 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<64, false> &"}
!67 = metadata !{null, metadata !8, metadata !9, metadata !66, metadata !11, metadata !53, metadata !6}
!68 = metadata !{null, metadata !8, metadata !9, metadata !69, metadata !11, metadata !15, metadata !6}
!69 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<64, false> &"}
!70 = metadata !{null, metadata !8, metadata !9, metadata !69, metadata !11, metadata !71, metadata !6}
!71 = metadata !{metadata !"kernel_arg_name", metadata !"op"}
!72 = metadata !{null, metadata !8, metadata !9, metadata !73, metadata !11, metadata !74, metadata !6}
!73 = metadata !{metadata !"kernel_arg_type", metadata !"const struct PackedStencil<int, 1, 2, 1, 1> &"}
!74 = metadata !{metadata !"kernel_arg_name", metadata !""}
!75 = metadata !{null, metadata !8, metadata !9, metadata !76, metadata !11, metadata !24, metadata !6}
!76 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<64> &"}
!77 = metadata !{null, metadata !8, metadata !9, metadata !78, metadata !11, metadata !74, metadata !6}
!78 = metadata !{metadata !"kernel_arg_type", metadata !"const struct PackedStencil<int, 1, 1, 1, 1> &"}
!79 = metadata !{null, metadata !8, metadata !9, metadata !73, metadata !11, metadata !12, metadata !6}
!80 = metadata !{null, metadata !8, metadata !9, metadata !52, metadata !11, metadata !15, metadata !6}
!81 = metadata !{null, metadata !8, metadata !9, metadata !28, metadata !11, metadata !71, metadata !6}
!82 = metadata !{null, metadata !39, metadata !40, metadata !83, metadata !42, metadata !43, metadata !6}
!83 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<64, false>*", metadata !"int", metadata !"int"}
!84 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !46, metadata !6}
!85 = metadata !{null, metadata !8, metadata !9, metadata !78, metadata !11, metadata !12, metadata !6}
!86 = metadata !{null, metadata !1, metadata !2, metadata !87, metadata !4, metadata !50, metadata !6}
!87 = metadata !{metadata !"kernel_arg_type", metadata !"ap_uint<32> &", metadata !"uint &"}
!88 = metadata !{null, metadata !39, metadata !40, metadata !89, metadata !42, metadata !43, metadata !6}
!89 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<288, false>*", metadata !"int", metadata !"int"}
!90 = metadata !{null, metadata !8, metadata !9, metadata !91, metadata !11, metadata !53, metadata !6}
!91 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<288, false> &"}
!92 = metadata !{null, metadata !1, metadata !2, metadata !93, metadata !4, metadata !94, metadata !6}
!93 = metadata !{metadata !"kernel_arg_type", metadata !"stream<AxiPackedStencil<uint, 1UL, 1UL, 1UL, 1UL> > &", metadata !"stream<PackedStencil<uint, 3UL, 3UL, 1UL, 1UL> > &"}
!94 = metadata !{metadata !"kernel_arg_name", metadata !"in_axi_stream", metadata !"out_stream"}
!95 = metadata !{null, metadata !1, metadata !2, metadata !96, metadata !4, metadata !60, metadata !6}
!96 = metadata !{metadata !"kernel_arg_type", metadata !"stream<PackedStencil<uint, 1UL, 1UL, 1UL, 1UL> > &", metadata !"stream<PackedStencil<uint, 3UL, 3UL, 1UL, 1UL> > &"}
!97 = metadata !{null, metadata !1, metadata !2, metadata !98, metadata !4, metadata !60, metadata !6}
!98 = metadata !{metadata !"kernel_arg_type", metadata !"stream<PackedStencil<uint, 1UL, 3UL, 1UL, 1UL> > &", metadata !"stream<PackedStencil<uint, 3UL, 3UL, 1UL, 1UL> > &"}
!99 = metadata !{null, metadata !8, metadata !9, metadata !100, metadata !11, metadata !12, metadata !6}
!100 = metadata !{metadata !"kernel_arg_type", metadata !"const struct PackedStencil<uint, 3, 3, 1, 1> &"}
!101 = metadata !{null, metadata !8, metadata !9, metadata !102, metadata !11, metadata !15, metadata !6}
!102 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<96, false> &"}
!103 = metadata !{null, metadata !8, metadata !9, metadata !102, metadata !11, metadata !53, metadata !6}
!104 = metadata !{null, metadata !8, metadata !9, metadata !105, metadata !11, metadata !15, metadata !6}
!105 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<96, false> &"}
!106 = metadata !{null, metadata !8, metadata !9, metadata !105, metadata !11, metadata !71, metadata !6}
!107 = metadata !{null, metadata !8, metadata !9, metadata !108, metadata !11, metadata !74, metadata !6}
!108 = metadata !{metadata !"kernel_arg_type", metadata !"const struct PackedStencil<uint, 1, 3, 1, 1> &"}
!109 = metadata !{null, metadata !8, metadata !9, metadata !110, metadata !11, metadata !24, metadata !6}
!110 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<96> &"}
!111 = metadata !{null, metadata !8, metadata !9, metadata !112, metadata !11, metadata !74, metadata !6}
!112 = metadata !{metadata !"kernel_arg_type", metadata !"const struct PackedStencil<uint, 1, 1, 1, 1> &"}
!113 = metadata !{null, metadata !8, metadata !9, metadata !108, metadata !11, metadata !12, metadata !6}
!114 = metadata !{null, metadata !39, metadata !40, metadata !115, metadata !42, metadata !43, metadata !6}
!115 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<96, false>*", metadata !"int", metadata !"int"}
!116 = metadata !{null, metadata !8, metadata !9, metadata !112, metadata !11, metadata !12, metadata !6}
!117 = metadata !{null, metadata !8, metadata !9, metadata !118, metadata !11, metadata !119, metadata !6}
!118 = metadata !{metadata !"kernel_arg_type", metadata !"uint32_t"}
!119 = metadata !{metadata !"kernel_arg_name", metadata !"bits"}
!120 = metadata !{null, metadata !8, metadata !9, metadata !121, metadata !11, metadata !122, metadata !6}
!121 = metadata !{metadata !"kernel_arg_type", metadata !"half"}
!122 = metadata !{metadata !"kernel_arg_name", metadata !"x"}
!123 = metadata !{null, metadata !8, metadata !9, metadata !124, metadata !11, metadata !122, metadata !6}
!124 = metadata !{metadata !"kernel_arg_type", metadata !"float"}
!125 = metadata !{null, metadata !8, metadata !9, metadata !126, metadata !11, metadata !122, metadata !6}
!126 = metadata !{metadata !"kernel_arg_type", metadata !"double"}
!127 = metadata !{null, metadata !1, metadata !2, metadata !128, metadata !4, metadata !129, metadata !6}
!128 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool"}
!129 = metadata !{metadata !"kernel_arg_name", metadata !"x", metadata !"detect_overflow"}
!130 = metadata !{null, metadata !131, metadata !40, metadata !132, metadata !42, metadata !133, metadata !6}
!131 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0, i32 0}
!132 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ulong>::is_signed, _Bool>::type"}
!133 = metadata !{metadata !"kernel_arg_name", metadata !"x", metadata !"detect_overflow", metadata !""}
!134 = metadata !{null, metadata !8, metadata !9, metadata !135, metadata !11, metadata !136, metadata !6}
!135 = metadata !{metadata !"kernel_arg_type", metadata !"_Bool"}
!136 = metadata !{metadata !"kernel_arg_name", metadata !"Cnative"}
!137 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !71, metadata !6}
!138 = metadata !{null, metadata !8, metadata !9, metadata !139, metadata !11, metadata !71, metadata !6}
!139 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<64, 64, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!140 = metadata !{null, metadata !8, metadata !9, metadata !141, metadata !11, metadata !71, metadata !6}
!141 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<64, 64, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!142 = metadata !{null, metadata !1, metadata !2, metadata !143, metadata !4, metadata !144, metadata !6}
!143 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 65, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!144 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"i_op"}
!145 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !146, metadata !6}
!146 = metadata !{metadata !"kernel_arg_name", metadata !"i_op"}
!147 = metadata !{null, metadata !8, metadata !9, metadata !148, metadata !11, metadata !24, metadata !6}
!148 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<32, 32, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!149 = metadata !{null, metadata !8, metadata !9, metadata !150, metadata !11, metadata !71, metadata !6}
!150 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 65, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!151 = metadata !{null, metadata !8, metadata !9, metadata !152, metadata !11, metadata !71, metadata !6}
!152 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<169, 116, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!153 = metadata !{null, metadata !8, metadata !9, metadata !154, metadata !11, metadata !71, metadata !6}
!154 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<169, 116, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!155 = metadata !{null, metadata !30, metadata !31, metadata !156, metadata !33, metadata !157, metadata !6}
!156 = metadata !{metadata !"kernel_arg_type", metadata !"_Bool", metadata !"_Bool", metadata !"_Bool", metadata !"_Bool"}
!157 = metadata !{metadata !"kernel_arg_name", metadata !"underflow", metadata !"overflow", metadata !"lD", metadata !"sign"}
!158 = metadata !{null, metadata !1, metadata !2, metadata !159, metadata !4, metadata !160, metadata !6}
!159 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<169, false> &", metadata !"int"}
!160 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"op2"}
!161 = metadata !{null, metadata !8, metadata !9, metadata !162, metadata !11, metadata !24, metadata !6}
!162 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<169, false> &"}
!163 = metadata !{null, metadata !1, metadata !2, metadata !164, metadata !4, metadata !144, metadata !6}
!164 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<11, false> &", metadata !"int"}
!165 = metadata !{null, metadata !1, metadata !2, metadata !166, metadata !4, metadata !160, metadata !6}
!166 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<11, false> &", metadata !"const ap_int_base<32, true> &"}
!167 = metadata !{null, metadata !8, metadata !9, metadata !168, metadata !11, metadata !71, metadata !6}
!168 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<32, true> &"}
!169 = metadata !{null, metadata !8, metadata !9, metadata !170, metadata !11, metadata !71, metadata !6}
!170 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<11, false> &"}
!171 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !172, metadata !6}
!172 = metadata !{metadata !"kernel_arg_name", metadata !"sh"}
!173 = metadata !{null, metadata !8, metadata !9, metadata !174, metadata !11, metadata !15, metadata !6}
!174 = metadata !{metadata !"kernel_arg_type", metadata !"ulong long"}
!175 = metadata !{null, metadata !8, metadata !9, metadata !45, metadata !11, metadata !176, metadata !6}
!176 = metadata !{metadata !"kernel_arg_name", metadata !"index"}
!177 = metadata !{null, metadata !178, metadata !2, metadata !179, metadata !4, metadata !180, metadata !6}
!178 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 0}
!179 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<53, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int"}
!180 = metadata !{metadata !"kernel_arg_name", metadata !"bv", metadata !"index"}
!181 = metadata !{null, metadata !39, metadata !40, metadata !182, metadata !42, metadata !43, metadata !6}
!182 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<52, false>*", metadata !"int", metadata !"int"}
!183 = metadata !{null, metadata !8, metadata !9, metadata !184, metadata !11, metadata !15, metadata !6}
!184 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<52, false> &"}
!185 = metadata !{null, metadata !8, metadata !9, metadata !184, metadata !11, metadata !53, metadata !6}
!186 = metadata !{null, metadata !8, metadata !9, metadata !187, metadata !11, metadata !15, metadata !6}
!187 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<52, false> &"}
!188 = metadata !{null, metadata !8, metadata !9, metadata !187, metadata !11, metadata !71, metadata !6}
!189 = metadata !{null, metadata !39, metadata !40, metadata !190, metadata !42, metadata !43, metadata !6}
!190 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<53, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int", metadata !"int"}
!191 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !192, metadata !6}
!192 = metadata !{metadata !"kernel_arg_name", metadata !"v"}
!193 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !194, metadata !6}
!194 = metadata !{metadata !"kernel_arg_name", metadata !"b"}
!195 = metadata !{null, metadata !8, metadata !9, metadata !148, metadata !11, metadata !71, metadata !6}
!196 = metadata !{null, metadata !8, metadata !9, metadata !197, metadata !11, metadata !71, metadata !6}
!197 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<53, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!198 = metadata !{null, metadata !8, metadata !9, metadata !199, metadata !11, metadata !71, metadata !6}
!199 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<53, 1, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!200 = metadata !{null, metadata !8, metadata !9, metadata !126, metadata !11, metadata !201, metadata !6}
!201 = metadata !{metadata !"kernel_arg_name", metadata !"f"}
!202 = metadata !{null, metadata !39, metadata !40, metadata !203, metadata !42, metadata !43, metadata !6}
!203 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<11, false>*", metadata !"int", metadata !"int"}
!204 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !176, metadata !6}
!205 = metadata !{null, metadata !178, metadata !2, metadata !206, metadata !4, metadata !180, metadata !6}
!206 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<64, false>*", metadata !"int"}
!207 = metadata !{null, metadata !8, metadata !9, metadata !208, metadata !11, metadata !15, metadata !6}
!208 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_bit_ref<64, false> &"}
!209 = metadata !{null, metadata !178, metadata !2, metadata !210, metadata !4, metadata !180, metadata !6}
!210 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<1, false>*", metadata !"int"}
!211 = metadata !{null, metadata !8, metadata !9, metadata !212, metadata !11, metadata !15, metadata !6}
!212 = metadata !{metadata !"kernel_arg_type", metadata !"ulong"}
!213 = metadata !{null, metadata !131, metadata !40, metadata !214, metadata !42, metadata !133, metadata !6}
!214 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uint>::is_signed, _Bool>::type"}
!215 = metadata !{null, metadata !8, metadata !9, metadata !216, metadata !11, metadata !71, metadata !6}
!216 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<32, 32, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!217 = metadata !{null, metadata !8, metadata !9, metadata !218, metadata !11, metadata !71, metadata !6}
!218 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<32, 32, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!219 = metadata !{null, metadata !1, metadata !2, metadata !220, metadata !4, metadata !144, metadata !6}
!220 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 33, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!221 = metadata !{null, metadata !8, metadata !9, metadata !222, metadata !11, metadata !71, metadata !6}
!222 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 33, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!223 = metadata !{null, metadata !8, metadata !9, metadata !224, metadata !11, metadata !71, metadata !6}
!224 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<137, 84, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!225 = metadata !{null, metadata !8, metadata !9, metadata !226, metadata !11, metadata !71, metadata !6}
!226 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<137, 84, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!227 = metadata !{null, metadata !1, metadata !2, metadata !228, metadata !4, metadata !160, metadata !6}
!228 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<137, false> &", metadata !"int"}
!229 = metadata !{null, metadata !8, metadata !9, metadata !230, metadata !11, metadata !24, metadata !6}
!230 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<137, false> &"}
!231 = metadata !{null, metadata !131, metadata !40, metadata !232, metadata !42, metadata !133, metadata !6}
!232 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ushort>::is_signed, _Bool>::type"}
!233 = metadata !{null, metadata !8, metadata !9, metadata !234, metadata !11, metadata !71, metadata !6}
!234 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<16, 16, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!235 = metadata !{null, metadata !8, metadata !9, metadata !236, metadata !11, metadata !71, metadata !6}
!236 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<16, 16, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!237 = metadata !{null, metadata !1, metadata !2, metadata !238, metadata !4, metadata !144, metadata !6}
!238 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 17, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!239 = metadata !{null, metadata !8, metadata !9, metadata !240, metadata !11, metadata !71, metadata !6}
!240 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 17, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!241 = metadata !{null, metadata !8, metadata !9, metadata !242, metadata !11, metadata !71, metadata !6}
!242 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<121, 68, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!243 = metadata !{null, metadata !8, metadata !9, metadata !244, metadata !11, metadata !71, metadata !6}
!244 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<121, 68, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!245 = metadata !{null, metadata !1, metadata !2, metadata !246, metadata !4, metadata !160, metadata !6}
!246 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<121, false> &", metadata !"int"}
!247 = metadata !{null, metadata !8, metadata !9, metadata !248, metadata !11, metadata !24, metadata !6}
!248 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<121, false> &"}
!249 = metadata !{null, metadata !131, metadata !40, metadata !250, metadata !42, metadata !133, metadata !6}
!250 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uchar>::is_signed, _Bool>::type"}
!251 = metadata !{null, metadata !8, metadata !9, metadata !252, metadata !11, metadata !71, metadata !6}
!252 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<8, 8, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!253 = metadata !{null, metadata !8, metadata !9, metadata !254, metadata !11, metadata !71, metadata !6}
!254 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<8, 8, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!255 = metadata !{null, metadata !1, metadata !2, metadata !256, metadata !4, metadata !144, metadata !6}
!256 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 9, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!257 = metadata !{null, metadata !8, metadata !9, metadata !258, metadata !11, metadata !71, metadata !6}
!258 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 9, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!259 = metadata !{null, metadata !8, metadata !9, metadata !260, metadata !11, metadata !71, metadata !6}
!260 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<113, 60, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!261 = metadata !{null, metadata !8, metadata !9, metadata !262, metadata !11, metadata !71, metadata !6}
!262 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<113, 60, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!263 = metadata !{null, metadata !1, metadata !2, metadata !264, metadata !4, metadata !160, metadata !6}
!264 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<113, false> &", metadata !"int"}
!265 = metadata !{null, metadata !8, metadata !9, metadata !266, metadata !11, metadata !24, metadata !6}
!266 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<113, false> &"}
!267 = metadata !{null, metadata !1, metadata !2, metadata !268, metadata !4, metadata !129, metadata !6}
!268 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool"}
!269 = metadata !{null, metadata !131, metadata !40, metadata !270, metadata !42, metadata !133, metadata !6}
!270 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ulong>::is_signed, _Bool>::type"}
!271 = metadata !{null, metadata !8, metadata !9, metadata !272, metadata !11, metadata !71, metadata !6}
!272 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<111, 87, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!273 = metadata !{null, metadata !8, metadata !9, metadata !274, metadata !11, metadata !71, metadata !6}
!274 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<111, 87, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!275 = metadata !{null, metadata !1, metadata !2, metadata !276, metadata !4, metadata !160, metadata !6}
!276 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<111, false> &", metadata !"int"}
!277 = metadata !{null, metadata !8, metadata !9, metadata !278, metadata !11, metadata !24, metadata !6}
!278 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<111, false> &"}
!279 = metadata !{null, metadata !1, metadata !2, metadata !280, metadata !4, metadata !144, metadata !6}
!280 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<8, false> &", metadata !"int"}
!281 = metadata !{null, metadata !1, metadata !2, metadata !282, metadata !4, metadata !160, metadata !6}
!282 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<8, false> &", metadata !"const ap_int_base<32, true> &"}
!283 = metadata !{null, metadata !8, metadata !9, metadata !284, metadata !11, metadata !71, metadata !6}
!284 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<8, false> &"}
!285 = metadata !{null, metadata !178, metadata !2, metadata !286, metadata !4, metadata !180, metadata !6}
!286 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<24, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int"}
!287 = metadata !{null, metadata !39, metadata !40, metadata !288, metadata !42, metadata !43, metadata !6}
!288 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<23, false>*", metadata !"int", metadata !"int"}
!289 = metadata !{null, metadata !8, metadata !9, metadata !290, metadata !11, metadata !15, metadata !6}
!290 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<23, false> &"}
!291 = metadata !{null, metadata !8, metadata !9, metadata !290, metadata !11, metadata !53, metadata !6}
!292 = metadata !{null, metadata !8, metadata !9, metadata !293, metadata !11, metadata !15, metadata !6}
!293 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<23, false> &"}
!294 = metadata !{null, metadata !8, metadata !9, metadata !293, metadata !11, metadata !71, metadata !6}
!295 = metadata !{null, metadata !39, metadata !40, metadata !296, metadata !42, metadata !43, metadata !6}
!296 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<24, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int", metadata !"int"}
!297 = metadata !{null, metadata !8, metadata !9, metadata !298, metadata !11, metadata !71, metadata !6}
!298 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<24, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!299 = metadata !{null, metadata !8, metadata !9, metadata !300, metadata !11, metadata !71, metadata !6}
!300 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<24, 1, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!301 = metadata !{null, metadata !8, metadata !9, metadata !124, metadata !11, metadata !201, metadata !6}
!302 = metadata !{null, metadata !39, metadata !40, metadata !303, metadata !42, metadata !43, metadata !6}
!303 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<8, false>*", metadata !"int", metadata !"int"}
!304 = metadata !{null, metadata !178, metadata !2, metadata !305, metadata !4, metadata !180, metadata !6}
!305 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<32, false>*", metadata !"int"}
!306 = metadata !{null, metadata !8, metadata !9, metadata !307, metadata !11, metadata !15, metadata !6}
!307 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_bit_ref<32, false> &"}
!308 = metadata !{null, metadata !131, metadata !40, metadata !309, metadata !42, metadata !133, metadata !6}
!309 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uint>::is_signed, _Bool>::type"}
!310 = metadata !{null, metadata !8, metadata !9, metadata !311, metadata !11, metadata !71, metadata !6}
!311 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<79, 55, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!312 = metadata !{null, metadata !8, metadata !9, metadata !313, metadata !11, metadata !71, metadata !6}
!313 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<79, 55, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!314 = metadata !{null, metadata !1, metadata !2, metadata !315, metadata !4, metadata !160, metadata !6}
!315 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<79, false> &", metadata !"int"}
!316 = metadata !{null, metadata !8, metadata !9, metadata !317, metadata !11, metadata !24, metadata !6}
!317 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<79, false> &"}
!318 = metadata !{null, metadata !131, metadata !40, metadata !319, metadata !42, metadata !133, metadata !6}
!319 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ushort>::is_signed, _Bool>::type"}
!320 = metadata !{null, metadata !8, metadata !9, metadata !321, metadata !11, metadata !71, metadata !6}
!321 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<63, 39, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!322 = metadata !{null, metadata !8, metadata !9, metadata !323, metadata !11, metadata !71, metadata !6}
!323 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<63, 39, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!324 = metadata !{null, metadata !1, metadata !2, metadata !325, metadata !4, metadata !160, metadata !6}
!325 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<63, false> &", metadata !"int"}
!326 = metadata !{null, metadata !8, metadata !9, metadata !327, metadata !11, metadata !24, metadata !6}
!327 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<63, false> &"}
!328 = metadata !{null, metadata !131, metadata !40, metadata !329, metadata !42, metadata !133, metadata !6}
!329 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uchar>::is_signed, _Bool>::type"}
!330 = metadata !{null, metadata !8, metadata !9, metadata !331, metadata !11, metadata !71, metadata !6}
!331 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<55, 31, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!332 = metadata !{null, metadata !8, metadata !9, metadata !333, metadata !11, metadata !71, metadata !6}
!333 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<55, 31, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!334 = metadata !{null, metadata !1, metadata !2, metadata !335, metadata !4, metadata !160, metadata !6}
!335 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<55, false> &", metadata !"int"}
!336 = metadata !{null, metadata !8, metadata !9, metadata !337, metadata !11, metadata !24, metadata !6}
!337 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<55, false> &"}
!338 = metadata !{null, metadata !1, metadata !2, metadata !339, metadata !4, metadata !129, metadata !6}
!339 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool"}
!340 = metadata !{null, metadata !131, metadata !40, metadata !341, metadata !42, metadata !133, metadata !6}
!341 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ulong>::is_signed, _Bool>::type"}
!342 = metadata !{null, metadata !1, metadata !2, metadata !343, metadata !4, metadata !160, metadata !6}
!343 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<5, false> &", metadata !"int"}
!344 = metadata !{null, metadata !8, metadata !9, metadata !168, metadata !11, metadata !24, metadata !6}
!345 = metadata !{null, metadata !8, metadata !9, metadata !346, metadata !11, metadata !71, metadata !6}
!346 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<85, 74, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!347 = metadata !{null, metadata !8, metadata !9, metadata !348, metadata !11, metadata !71, metadata !6}
!348 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<85, 74, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!349 = metadata !{null, metadata !1, metadata !2, metadata !350, metadata !4, metadata !160, metadata !6}
!350 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<85, false> &", metadata !"int"}
!351 = metadata !{null, metadata !8, metadata !9, metadata !352, metadata !11, metadata !24, metadata !6}
!352 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<85, false> &"}
!353 = metadata !{null, metadata !1, metadata !2, metadata !343, metadata !4, metadata !144, metadata !6}
!354 = metadata !{null, metadata !1, metadata !2, metadata !355, metadata !4, metadata !160, metadata !6}
!355 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<5, false> &", metadata !"const ap_int_base<32, true> &"}
!356 = metadata !{null, metadata !8, metadata !9, metadata !357, metadata !11, metadata !71, metadata !6}
!357 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<5, false> &"}
!358 = metadata !{null, metadata !178, metadata !2, metadata !359, metadata !4, metadata !180, metadata !6}
!359 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<11, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int"}
!360 = metadata !{null, metadata !39, metadata !40, metadata !361, metadata !42, metadata !43, metadata !6}
!361 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<10, false>*", metadata !"int", metadata !"int"}
!362 = metadata !{null, metadata !8, metadata !9, metadata !363, metadata !11, metadata !15, metadata !6}
!363 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<10, false> &"}
!364 = metadata !{null, metadata !8, metadata !9, metadata !363, metadata !11, metadata !53, metadata !6}
!365 = metadata !{null, metadata !8, metadata !9, metadata !366, metadata !11, metadata !15, metadata !6}
!366 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<10, false> &"}
!367 = metadata !{null, metadata !8, metadata !9, metadata !366, metadata !11, metadata !71, metadata !6}
!368 = metadata !{null, metadata !39, metadata !40, metadata !369, metadata !42, metadata !43, metadata !6}
!369 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<11, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int", metadata !"int"}
!370 = metadata !{null, metadata !8, metadata !9, metadata !371, metadata !11, metadata !71, metadata !6}
!371 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<11, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!372 = metadata !{null, metadata !8, metadata !9, metadata !373, metadata !11, metadata !71, metadata !6}
!373 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<11, 1, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!374 = metadata !{null, metadata !8, metadata !9, metadata !121, metadata !11, metadata !201, metadata !6}
!375 = metadata !{null, metadata !8, metadata !9, metadata !376, metadata !11, metadata !15, metadata !6}
!376 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<16, false> &"}
!377 = metadata !{null, metadata !8, metadata !9, metadata !376, metadata !11, metadata !53, metadata !6}
!378 = metadata !{null, metadata !8, metadata !9, metadata !379, metadata !11, metadata !15, metadata !6}
!379 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<16, false> &"}
!380 = metadata !{null, metadata !8, metadata !9, metadata !379, metadata !11, metadata !71, metadata !6}
!381 = metadata !{null, metadata !39, metadata !40, metadata !382, metadata !42, metadata !43, metadata !6}
!382 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<16, false>*", metadata !"int", metadata !"int"}
!383 = metadata !{null, metadata !39, metadata !40, metadata !384, metadata !42, metadata !43, metadata !6}
!384 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<5, false>*", metadata !"int", metadata !"int"}
!385 = metadata !{null, metadata !178, metadata !2, metadata !386, metadata !4, metadata !180, metadata !6}
!386 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<16, false>*", metadata !"int"}
!387 = metadata !{null, metadata !8, metadata !9, metadata !388, metadata !11, metadata !15, metadata !6}
!388 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_bit_ref<16, false> &"}
!389 = metadata !{null, metadata !8, metadata !9, metadata !390, metadata !11, metadata !15, metadata !6}
!390 = metadata !{metadata !"kernel_arg_type", metadata !"ushort"}
!391 = metadata !{null, metadata !131, metadata !40, metadata !392, metadata !42, metadata !133, metadata !6}
!392 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uint>::is_signed, _Bool>::type"}
!393 = metadata !{null, metadata !8, metadata !9, metadata !394, metadata !11, metadata !71, metadata !6}
!394 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<53, 42, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!395 = metadata !{null, metadata !8, metadata !9, metadata !396, metadata !11, metadata !71, metadata !6}
!396 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<53, 42, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!397 = metadata !{null, metadata !1, metadata !2, metadata !398, metadata !4, metadata !160, metadata !6}
!398 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<53, false> &", metadata !"int"}
!399 = metadata !{null, metadata !8, metadata !9, metadata !400, metadata !11, metadata !24, metadata !6}
!400 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<53, false> &"}
!401 = metadata !{null, metadata !131, metadata !40, metadata !402, metadata !42, metadata !133, metadata !6}
!402 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ushort>::is_signed, _Bool>::type"}
!403 = metadata !{null, metadata !8, metadata !9, metadata !404, metadata !11, metadata !71, metadata !6}
!404 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<37, 26, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!405 = metadata !{null, metadata !8, metadata !9, metadata !406, metadata !11, metadata !71, metadata !6}
!406 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<37, 26, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!407 = metadata !{null, metadata !1, metadata !2, metadata !408, metadata !4, metadata !160, metadata !6}
!408 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<37, false> &", metadata !"int"}
!409 = metadata !{null, metadata !8, metadata !9, metadata !410, metadata !11, metadata !24, metadata !6}
!410 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<37, false> &"}
!411 = metadata !{null, metadata !131, metadata !40, metadata !412, metadata !42, metadata !133, metadata !6}
!412 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uchar>::is_signed, _Bool>::type"}
!413 = metadata !{null, metadata !8, metadata !9, metadata !414, metadata !11, metadata !71, metadata !6}
!414 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<29, 18, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!415 = metadata !{null, metadata !8, metadata !9, metadata !416, metadata !11, metadata !71, metadata !6}
!416 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<29, 18, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!417 = metadata !{null, metadata !1, metadata !2, metadata !418, metadata !4, metadata !160, metadata !6}
!418 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<29, false> &", metadata !"int"}
!419 = metadata !{null, metadata !8, metadata !9, metadata !420, metadata !11, metadata !24, metadata !6}
!420 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<29, false> &"}
!421 = metadata !{null, metadata !131, metadata !40, metadata !422, metadata !42, metadata !133, metadata !6}
!422 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<long>::is_signed, _Bool>::type"}
!423 = metadata !{null, metadata !8, metadata !9, metadata !424, metadata !11, metadata !71, metadata !6}
!424 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<63, 63, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!425 = metadata !{null, metadata !8, metadata !9, metadata !426, metadata !11, metadata !71, metadata !6}
!426 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<64, 64, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!427 = metadata !{null, metadata !8, metadata !9, metadata !428, metadata !11, metadata !71, metadata !6}
!428 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed<64, 64, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!429 = metadata !{null, metadata !8, metadata !9, metadata !430, metadata !11, metadata !71, metadata !6}
!430 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<63, 63, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!431 = metadata !{null, metadata !178, metadata !2, metadata !432, metadata !4, metadata !180, metadata !6}
!432 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<64, true>*", metadata !"int"}
!433 = metadata !{null, metadata !1, metadata !2, metadata !434, metadata !4, metadata !144, metadata !6}
!434 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 64, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!435 = metadata !{null, metadata !8, metadata !9, metadata !436, metadata !11, metadata !71, metadata !6}
!436 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 64, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!437 = metadata !{null, metadata !131, metadata !40, metadata !438, metadata !42, metadata !133, metadata !6}
!438 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<int>::is_signed, _Bool>::type"}
!439 = metadata !{null, metadata !8, metadata !9, metadata !440, metadata !11, metadata !71, metadata !6}
!440 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<31, 31, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!441 = metadata !{null, metadata !8, metadata !9, metadata !442, metadata !11, metadata !71, metadata !6}
!442 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed<32, 32, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!443 = metadata !{null, metadata !8, metadata !9, metadata !444, metadata !11, metadata !71, metadata !6}
!444 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<31, 31, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!445 = metadata !{null, metadata !178, metadata !2, metadata !446, metadata !4, metadata !180, metadata !6}
!446 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<32, true>*", metadata !"int"}
!447 = metadata !{null, metadata !1, metadata !2, metadata !448, metadata !4, metadata !144, metadata !6}
!448 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 32, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!449 = metadata !{null, metadata !8, metadata !9, metadata !450, metadata !11, metadata !71, metadata !6}
!450 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 32, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!451 = metadata !{null, metadata !131, metadata !40, metadata !452, metadata !42, metadata !133, metadata !6}
!452 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<short>::is_signed, _Bool>::type"}
!453 = metadata !{null, metadata !8, metadata !9, metadata !454, metadata !11, metadata !71, metadata !6}
!454 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<15, 15, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!455 = metadata !{null, metadata !8, metadata !9, metadata !456, metadata !11, metadata !71, metadata !6}
!456 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<16, 16, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!457 = metadata !{null, metadata !8, metadata !9, metadata !458, metadata !11, metadata !71, metadata !6}
!458 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed<16, 16, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!459 = metadata !{null, metadata !8, metadata !9, metadata !460, metadata !11, metadata !71, metadata !6}
!460 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<15, 15, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!461 = metadata !{null, metadata !178, metadata !2, metadata !462, metadata !4, metadata !180, metadata !6}
!462 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<16, true>*", metadata !"int"}
!463 = metadata !{null, metadata !1, metadata !2, metadata !464, metadata !4, metadata !144, metadata !6}
!464 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 16, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!465 = metadata !{null, metadata !8, metadata !9, metadata !466, metadata !11, metadata !71, metadata !6}
!466 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 16, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!467 = metadata !{null, metadata !131, metadata !40, metadata !468, metadata !42, metadata !133, metadata !6}
!468 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<signed char>::is_signed, _Bool>::type"}
!469 = metadata !{null, metadata !8, metadata !9, metadata !470, metadata !11, metadata !71, metadata !6}
!470 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<7, 7, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!471 = metadata !{null, metadata !8, metadata !9, metadata !472, metadata !11, metadata !71, metadata !6}
!472 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<8, 8, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!473 = metadata !{null, metadata !8, metadata !9, metadata !474, metadata !11, metadata !71, metadata !6}
!474 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed<8, 8, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!475 = metadata !{null, metadata !8, metadata !9, metadata !476, metadata !11, metadata !71, metadata !6}
!476 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<7, 7, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!477 = metadata !{null, metadata !178, metadata !2, metadata !478, metadata !4, metadata !180, metadata !6}
!478 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<8, true>*", metadata !"int"}
!479 = metadata !{null, metadata !1, metadata !2, metadata !480, metadata !4, metadata !144, metadata !6}
!480 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 8, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!481 = metadata !{null, metadata !8, metadata !9, metadata !482, metadata !11, metadata !71, metadata !6}
!482 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 8, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!483 = metadata !{null, metadata !131, metadata !40, metadata !484, metadata !42, metadata !133, metadata !6}
!484 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<long>::is_signed, _Bool>::type"}
!485 = metadata !{null, metadata !131, metadata !40, metadata !486, metadata !42, metadata !133, metadata !6}
!486 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<int>::is_signed, _Bool>::type"}
!487 = metadata !{null, metadata !131, metadata !40, metadata !488, metadata !42, metadata !133, metadata !6}
!488 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<short>::is_signed, _Bool>::type"}
!489 = metadata !{null, metadata !131, metadata !40, metadata !490, metadata !42, metadata !133, metadata !6}
!490 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<signed char>::is_signed, _Bool>::type"}
!491 = metadata !{null, metadata !131, metadata !40, metadata !492, metadata !42, metadata !133, metadata !6}
!492 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<long>::is_signed, _Bool>::type"}
!493 = metadata !{null, metadata !131, metadata !40, metadata !494, metadata !42, metadata !133, metadata !6}
!494 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<int>::is_signed, _Bool>::type"}
!495 = metadata !{null, metadata !131, metadata !40, metadata !496, metadata !42, metadata !133, metadata !6}
!496 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<short>::is_signed, _Bool>::type"}
!497 = metadata !{null, metadata !131, metadata !40, metadata !498, metadata !42, metadata !133, metadata !6}
!498 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<signed char>::is_signed, _Bool>::type"}
!499 = metadata !{null, metadata !500, metadata !9, metadata !501, metadata !502, metadata !503, metadata !6}
!500 = metadata !{metadata !"kernel_arg_addr_space", i32 1}
!501 = metadata !{metadata !"kernel_arg_type", metadata !"char*"}
!502 = metadata !{metadata !"kernel_arg_type_qual", metadata !"const"}
!503 = metadata !{metadata !"kernel_arg_name", metadata !"str"}
!504 = metadata !{null, metadata !8, metadata !9, metadata !126, metadata !11, metadata !192, metadata !6}
!505 = metadata !{null, metadata !8, metadata !9, metadata !126, metadata !11, metadata !506, metadata !6}
!506 = metadata !{metadata !"kernel_arg_name", metadata !"d"}
!507 = metadata !{null, metadata !1, metadata !2, metadata !508, metadata !4, metadata !160, metadata !6}
!508 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<1, false> &", metadata !"const ap_int_base<54, true> &"}
!509 = metadata !{null, metadata !8, metadata !9, metadata !510, metadata !11, metadata !71, metadata !6}
!510 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<54, true> &"}
!511 = metadata !{null, metadata !8, metadata !9, metadata !512, metadata !11, metadata !71, metadata !6}
!512 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<1, false> &"}
!513 = metadata !{null, metadata !8, metadata !9, metadata !514, metadata !11, metadata !24, metadata !6}
!514 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<55, true> &"}
!515 = metadata !{null, metadata !8, metadata !9, metadata !516, metadata !11, metadata !24, metadata !6}
!516 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<33, true> &"}
!517 = metadata !{null, metadata !8, metadata !9, metadata !126, metadata !11, metadata !518, metadata !6}
!518 = metadata !{metadata !"kernel_arg_name", metadata !"pf"}
!519 = metadata !{null, metadata !8, metadata !9, metadata !520, metadata !11, metadata !71, metadata !6}
!520 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<25, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!521 = metadata !{null, metadata !8, metadata !9, metadata !522, metadata !11, metadata !71, metadata !6}
!522 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<7, 0, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!523 = metadata !{null, metadata !178, metadata !2, metadata !524, metadata !525, metadata !526, metadata !6}
!524 = metadata !{metadata !"kernel_arg_type", metadata !"char*", metadata !"signed char"}
!525 = metadata !{metadata !"kernel_arg_type_qual", metadata !"const", metadata !""}
!526 = metadata !{metadata !"kernel_arg_name", metadata !"str", metadata !"radix"}
!527 = metadata !{metadata !528, [2 x i32]* @llvm_global_ctors_0}
!528 = metadata !{metadata !529}
!529 = metadata !{i32 0, i32 31, metadata !530}
!530 = metadata !{metadata !531}
!531 = metadata !{metadata !"llvm.global_ctors.0", metadata !532, metadata !"", i32 0, i32 31}
!532 = metadata !{metadata !533}
!533 = metadata !{i32 0, i32 1, i32 1}
!534 = metadata !{metadata !535}
!535 = metadata !{i32 0, i32 31, metadata !536}
!536 = metadata !{metadata !537}
!537 = metadata !{metadata !"hw_input.V.value.V", metadata !538, metadata !"uint32", i32 0, i32 31}
!538 = metadata !{metadata !539}
!539 = metadata !{i32 0, i32 0, i32 1}
!540 = metadata !{metadata !541}
!541 = metadata !{i32 0, i32 0, metadata !542}
!542 = metadata !{metadata !543}
!543 = metadata !{metadata !"hw_input.V.last.V", metadata !538, metadata !"uint1", i32 0, i32 0}
!544 = metadata !{metadata !545}
!545 = metadata !{i32 0, i32 31, metadata !546}
!546 = metadata !{metadata !547}
!547 = metadata !{metadata !"hw_output.V.value.V", metadata !538, metadata !"uint32", i32 0, i32 31}
!548 = metadata !{metadata !549}
!549 = metadata !{i32 0, i32 0, metadata !550}
!550 = metadata !{metadata !551}
!551 = metadata !{metadata !"hw_output.V.last.V", metadata !538, metadata !"uint1", i32 0, i32 0}
