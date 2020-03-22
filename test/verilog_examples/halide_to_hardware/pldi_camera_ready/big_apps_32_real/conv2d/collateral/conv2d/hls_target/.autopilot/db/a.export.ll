; ModuleID = '/home/dhuff/Halide-HLS/apps/hls_examples/camera_ready_synthesis/app_files/big_apps_32_real/conv2d/conv2d/hls_target/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@slice_stream_OC_V_OC = internal unnamed_addr constant [23 x i8] c"slice_stream.V.value.V\00"
@llvm_global_ctors_1 = appending global [2 x void ()*] [void ()* @_GLOBAL__I_a, void ()* @_GLOBAL__I_a63]
@llvm_global_ctors_0 = appending global [2 x i32] [i32 65535, i32 65535]
@in_stream_OC_V_OC_va = internal unnamed_addr constant [20 x i8] c"in_stream.V.value.V\00"
@hls_target_str = internal unnamed_addr constant [11 x i8] c"hls_target\00"
@ap_fifo_str = internal unnamed_addr constant [8 x i8] c"ap_fifo\00"
@p_hw_input_stencil_st = internal unnamed_addr constant [35 x i8] c"_hw_input_stencil_stream.V.value.V\00"
@p_str3 = private unnamed_addr constant [12 x i8] c"hls_label_4\00", align 1
@p_str21 = private unnamed_addr constant [14 x i8] c"LB1D_shiftreg\00", align 1
@p_str20 = private unnamed_addr constant [11 x i8] c"LB2D_shift\00", align 1
@p_str2 = private unnamed_addr constant [9 x i8] c"FIFO_SRL\00", align 1
@p_str19 = private unnamed_addr constant [12 x i8] c"hls_label_6\00", align 1
@p_str18 = private unnamed_addr constant [9 x i8] c"LB2D_buf\00", align 1
@p_str17 = private unnamed_addr constant [11 x i8] c"LB_3D_pass\00", align 1
@p_str16 = private unnamed_addr constant [11 x i8] c"LB_4D_pass\00", align 1
@p_str15 = private unnamed_addr constant [12 x i8] c"hls_label_5\00", align 1
@p_str1 = private unnamed_addr constant [6 x i8] c"ap_hs\00", align 1
@p_str = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare i96 @llvm.part.select.i96(i96, i32, i32) nounwind readnone

declare i64 @llvm.part.select.i64(i64, i32, i32) nounwind readnone

declare i288 @llvm.part.select.i288(i288, i32, i32) nounwind readnone

declare i137 @llvm.part.select.i137(i137, i32, i32) nounwind readnone

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
  %tmp = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str15)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %empty_16 = call { i32, i1 } @_ssdm_op_Read.ap_auto.volatile.i32P.i1P(i32* %in_axi_stream_V_value_V, i1* %in_axi_stream_V_last_V)
  %tmp_value_V = extractvalue { i32, i1 } %empty_16, 0
  call void @_ssdm_op_Write.ap_fifo.volatile.i32P(i32* %in_stream_V_value_V, i32 %tmp_value_V)
  %empty_17 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str15, i32 %tmp)
  br label %.preheader.i

.preheader.i:                                     ; preds = %newFuncRoot, %.preheader4.i
  %indvar_flatten = phi i21 [ 0, %newFuncRoot ], [ %indvar_flatten_next, %.preheader4.i ]
  %exitcond_flatten = icmp eq i21 %indvar_flatten, -23552
  %indvar_flatten_next = add i21 %indvar_flatten, 1
  br i1 %exitcond_flatten, label %.critedge.exitStub, label %.preheader4.i
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
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str16) nounwind
  %tmp = call i32 (...)* @_ssdm_op_SpecRegionBegin([11 x i8]* @p_str16)
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str17) nounwind
  %empty = call i32 (...)* @_ssdm_op_SpecRegionEnd([11 x i8]* @p_str16, i32 %tmp)
  call fastcc void @call(i32* %in_stream_V_value_V, i288* %out_stream_V_value_V)
  ret void
}

define void @hls_target(i32* %hw_input_V_value_V, i1* %hw_input_V_last_V, i32* %hw_output_V_value_V, i1* %hw_output_V_last_V) {
codeRepl:
  call void (...)* @_ssdm_op_SpecDataflowPipeline(i32 -1, [1 x i8]* @p_str) nounwind
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %hw_input_V_value_V), !map !513
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %hw_input_V_last_V), !map !519
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %hw_output_V_value_V), !map !523
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %hw_output_V_last_V), !map !527
  call void (...)* @_ssdm_op_SpecTopModule([11 x i8]* @hls_target_str) nounwind
  %p_hw_input_stencil_st = alloca i288, align 8
  %empty = call i32 (...)* @_ssdm_op_SpecChannel([35 x i8]* @p_hw_input_stencil_st, i32 1, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 1, i32 1, i288* %p_hw_input_stencil_st, i288* %p_hw_input_stencil_st)
  call void (...)* @_ssdm_op_SpecInterface(i288* %p_hw_input_stencil_st, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecMemCore(i288* %p_hw_input_stencil_st, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i32* %hw_input_V_value_V, i1* %hw_input_V_last_V, [6 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32* %hw_output_V_value_V, i1* %hw_output_V_last_V, [6 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str) nounwind
  call fastcc void @linebuffer.1(i32* %hw_input_V_value_V, i1* %hw_input_V_last_V, i288* %p_hw_input_stencil_st)
  call fastcc void @Loop_1_proc(i288* %p_hw_input_stencil_st, i32* %hw_output_V_value_V, i1* %hw_output_V_last_V)
  ret void
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
  %tmp_5 = icmp eq i11 %n1, -970
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 1078, i64 1078, i64 1078)
  %n1_1 = add i11 %n1, 1
  br i1 %tmp_5, label %.exitStub, label %1

"linebuffer_1D<1920ul, 3ul, 1ul, 1ul, 1ul, 3ul, unsigned int>.exit": ; preds = %0
  %empty_18 = call i32 (...)* @_ssdm_op_SpecRegionEnd([11 x i8]* @p_str20, i32 %tmp_3)
  br label %.preheader

; <label>:0                                       ; preds = %._crit_edge.i.i, %1
  %i_0_i_i = phi i11 [ 0, %1 ], [ %i, %._crit_edge.i.i ]
  %tmp_7 = icmp eq i11 %i_0_i_i, -128
  %empty_19 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 1920, i64 1920, i64 1920)
  %i = add i11 %i_0_i_i, 1
  br i1 %tmp_7, label %"linebuffer_1D<1920ul, 3ul, 1ul, 1ul, 1ul, 3ul, unsigned int>.exit", label %2

; <label>:1                                       ; preds = %.preheader
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str20) nounwind
  %tmp_3 = call i32 (...)* @_ssdm_op_SpecRegionBegin([11 x i8]* @p_str20)
  br label %0

._crit_edge.i.i:                                  ; preds = %2, %.preheader.i.i.preheader.0
  %buffer_1_value_V_lo = load i96* %buffer_1_value_V
  %empty_20 = call i32 (...)* @_ssdm_op_SpecRegionEnd([14 x i8]* @p_str21, i32 %tmp_9)
  store i96 %buffer_1_value_V_lo, i96* %buffer_0_value_V
  store i96 %tmp_value_V_1, i96* %buffer_1_value_V
  br label %0

; <label>:2                                       ; preds = %0
  call void (...)* @_ssdm_op_SpecLoopName([14 x i8]* @p_str21) nounwind
  %tmp_9 = call i32 (...)* @_ssdm_op_SpecRegionBegin([14 x i8]* @p_str21)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %tmp_value_V_1 = call i96 @_ssdm_op_Read.ap_fifo.volatile.i96P(i96* %slice_stream_V_value_V)
  %tmp = call i10 @_ssdm_op_PartSelect.i10.i11.i32.i32(i11 %i_0_i_i, i32 1, i32 10)
  %icmp = icmp eq i10 %tmp, 0
  br i1 %icmp, label %._crit_edge.i.i, label %.preheader.i.i.preheader.0

.preheader.i.i.preheader.0:                       ; preds = %2
  %buffer_1_value_V_lo_1 = load i96* %buffer_1_value_V
  %buffer_0_value_V_lo = load i96* %buffer_0_value_V
  %tmp_1 = trunc i96 %buffer_0_value_V_lo to i32
  %tmp_2 = trunc i96 %buffer_1_value_V_lo_1 to i32
  %tmp_4 = trunc i96 %tmp_value_V_1 to i32
  %p_Result_20_1 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %buffer_0_value_V_lo, i32 32, i32 63)
  %p_Result_20_1_1 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %buffer_1_value_V_lo_1, i32 32, i32 63)
  %p_Result_20_1_2 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %tmp_value_V_1, i32 32, i32 63)
  %p_Result_20_2 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %buffer_0_value_V_lo, i32 64, i32 95)
  %p_Result_20_2_1 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %buffer_1_value_V_lo_1, i32 64, i32 95)
  %p_Result_20_2_2 = call i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96 %tmp_value_V_1, i32 64, i32 95)
  %tmp_value_V = call i288 @_ssdm_op_BitConcatenate.i288.i32.i32.i32.i32.i32.i32.i32.i32.i32(i32 %p_Result_20_2_2, i32 %p_Result_20_2_1, i32 %p_Result_20_2, i32 %p_Result_20_1_2, i32 %p_Result_20_1_1, i32 %p_Result_20_1, i32 %tmp_4, i32 %tmp_2, i32 %tmp_1)
  call void @_ssdm_op_Write.ap_fifo.volatile.i288P(i288* %out_stream_V_value_V, i288 %tmp_value_V)
  br label %._crit_edge.i.i
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
  %empty_21 = call i32 (...)* @_ssdm_op_SpecRegionEnd([9 x i8]* @p_str18, i32 %tmp_2)
  br label %0

; <label>:2                                       ; preds = %._crit_edge33, %3
  %write_idx_1_1 = phi i64 [ %write_idx_1, %3 ], [ %p_write_idx_1_1, %._crit_edge33 ]
  %col = phi i11 [ 0, %3 ], [ %col_1, %._crit_edge33 ]
  %tmp_6 = icmp eq i11 %col, -128
  %col_1 = add i11 %col, 1
  br i1 %tmp_6, label %1, label %4

; <label>:3                                       ; preds = %0
  call void (...)* @_ssdm_op_SpecLoopName([9 x i8]* @p_str18) nounwind
  %tmp_2 = call i32 (...)* @_ssdm_op_SpecRegionBegin([9 x i8]* @p_str18)
  %tmp_5 = call i10 @_ssdm_op_PartSelect.i10.i11.i32.i32(i11 %row, i32 1, i32 10)
  %icmp = icmp eq i10 %tmp_5, 0
  br label %2

._crit_edge33:                                    ; preds = %branch5, %branch4
  %empty_22 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str19, i32 %tmp_4)
  br label %2

branch4:                                          ; preds = %._crit_edge
  store i32 %tmp_value_V_2, i32* %buffer_0_value_V_ad, align 4
  br label %._crit_edge33

._crit_edge:                                      ; preds = %4, %.preheader56.preheader.critedge.0
  %tmp_9 = trunc i64 %p_write_idx_1_1 to i1
  br i1 %tmp_9, label %branch5, label %branch4

; <label>:4                                       ; preds = %2
  %col_cast = zext i11 %col to i64
  %empty_23 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 1920, i64 1920, i64 1920)
  %tmp_4 = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str19)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %tmp_7 = call i63 @_ssdm_op_PartSelect.i63.i64.i32.i32(i64 %write_idx_1_1, i32 1, i32 63)
  %icmp1 = icmp ne i63 %tmp_7, 0
  %write_idx_1_3 = add i64 %write_idx_1_1, -2
  %p_write_idx_1_1 = select i1 %icmp1, i64 %write_idx_1_3, i64 %write_idx_1_1
  %tmp_value_V_2 = call i32 @_ssdm_op_Read.ap_fifo.volatile.i32P(i32* %in_stream_V_value_V)
  %buffer_0_value_V_ad = getelementptr [1920 x i32]* %buffer_0_value_V, i64 0, i64 %col_cast
  %buffer_0_value_V_lo = load i32* %buffer_0_value_V_ad, align 4
  %buffer_1_value_V_ad = getelementptr [1920 x i32]* %buffer_1_value_V, i64 0, i64 %col_cast
  %buffer_1_value_V_lo = load i32* %buffer_1_value_V_ad, align 4
  br i1 %icmp, label %._crit_edge, label %.preheader56.preheader.critedge.0

.preheader56.preheader.critedge.0:                ; preds = %4
  %tmp_8 = trunc i64 %p_write_idx_1_1 to i1
  %p_Val2_8_0_phi = select i1 %tmp_8, i32 %buffer_1_value_V_lo, i32 %buffer_0_value_V_lo
  %p_Val2_8_1_phi = select i1 %tmp_8, i32 %buffer_0_value_V_lo, i32 %buffer_1_value_V_lo
  %p_Result_s = call i96 @_ssdm_op_BitConcatenate.i96.i32.i32.i32(i32 %tmp_value_V_2, i32 %p_Val2_8_1_phi, i32 %p_Val2_8_0_phi)
  call void @_ssdm_op_Write.ap_fifo.volatile.i96P(i96* %slice_stream_V_value_V, i96 %p_Result_s)
  br label %._crit_edge

branch5:                                          ; preds = %._crit_edge
  store i32 %tmp_value_V_2, i32* %buffer_1_value_V_ad, align 4
  br label %._crit_edge33
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

define weak { i32, i1 } @_ssdm_op_Read.ap_auto.volatile.i32P.i1P(i32*, i1*) {
entry:
  %empty = load i32* %0
  %empty_24 = load i1* %1
  %mrv_0 = insertvalue { i32, i1 } undef, i32 %empty, 0
  %mrv1 = insertvalue { i32, i1 } %mrv_0, i1 %empty_24, 1
  ret { i32, i1 } %mrv1
}

define weak i63 @_ssdm_op_PartSelect.i63.i64.i32.i32(i64, i32, i32) nounwind readnone {
entry:
  %empty = call i64 @llvm.part.select.i64(i64 %0, i32 %1, i32 %2)
  %empty_25 = trunc i64 %empty to i63
  ret i63 %empty_25
}

declare i52 @_ssdm_op_PartSelect.i52.i64.i32.i32(i64, i32, i32) nounwind readnone

define weak i32 @_ssdm_op_PartSelect.i32.i96.i32.i32(i96, i32, i32) nounwind readnone {
entry:
  %empty = call i96 @llvm.part.select.i96(i96 %0, i32 %1, i32 %2)
  %empty_26 = trunc i96 %empty to i32
  ret i32 %empty_26
}

define weak i32 @_ssdm_op_PartSelect.i32.i288.i32.i32(i288, i32, i32) nounwind readnone {
entry:
  %empty = call i288 @llvm.part.select.i288(i288 %0, i32 %1, i32 %2)
  %empty_27 = trunc i288 %empty to i32
  ret i32 %empty_27
}

define weak i32 @_ssdm_op_PartSelect.i32.i137.i32.i32(i137, i32, i32) nounwind readnone {
entry:
  %empty = call i137 @llvm.part.select.i137(i137 %0, i32 %1, i32 %2)
  %empty_28 = trunc i137 %empty to i32
  ret i32 %empty_28
}

define weak i31 @_ssdm_op_PartSelect.i31.i288.i32.i32(i288, i32, i32) nounwind readnone {
entry:
  %empty = call i288 @llvm.part.select.i288(i288 %0, i32 %1, i32 %2)
  %empty_29 = trunc i288 %empty to i31
  ret i31 %empty_29
}

define weak i30 @_ssdm_op_PartSelect.i30.i288.i32.i32(i288, i32, i32) nounwind readnone {
entry:
  %empty = call i288 @llvm.part.select.i288(i288 %0, i32 %1, i32 %2)
  %empty_30 = trunc i288 %empty to i30
  ret i30 %empty_30
}

define weak i11 @_ssdm_op_PartSelect.i11.i64.i32.i32(i64, i32, i32) nounwind readnone {
entry:
  %empty = call i64 @llvm.part.select.i64(i64 %0, i32 %1, i32 %2)
  %empty_31 = trunc i64 %empty to i11
  ret i11 %empty_31
}

define weak i10 @_ssdm_op_PartSelect.i10.i11.i32.i32(i11, i32, i32) nounwind readnone {
entry:
  %empty = call i11 @llvm.part.select.i11(i11 %0, i32 %1, i32 %2)
  %empty_32 = trunc i11 %empty to i10
  ret i10 %empty_32
}

declare i1 @_ssdm_op_PartSelect.i1.i64.i32.i32(i64, i32, i32) nounwind readnone

define weak i1 @_ssdm_op_BitSelect.i1.i54.i32(i54, i32) nounwind readnone {
entry:
  %empty = zext i32 %1 to i54
  %empty_33 = shl i54 1, %empty
  %empty_34 = and i54 %0, %empty_33
  %empty_35 = icmp ne i54 %empty_34, 0
  ret i1 %empty_35
}

define weak i1 @_ssdm_op_BitSelect.i1.i12.i32(i12, i32) nounwind readnone {
entry:
  %empty = trunc i32 %1 to i12
  %empty_36 = shl i12 1, %empty
  %empty_37 = and i12 %0, %empty_36
  %empty_38 = icmp ne i12 %empty_37, 0
  ret i1 %empty_38
}

define weak i96 @_ssdm_op_BitConcatenate.i96.i32.i32.i32(i32, i32, i32) nounwind readnone {
entry:
  %empty = zext i32 %1 to i64
  %empty_39 = zext i32 %2 to i64
  %empty_40 = shl i64 %empty, 32
  %empty_41 = or i64 %empty_40, %empty_39
  %empty_42 = zext i32 %0 to i96
  %empty_43 = zext i64 %empty_41 to i96
  %empty_44 = shl i96 %empty_42, 64
  %empty_45 = or i96 %empty_44, %empty_43
  ret i96 %empty_45
}

define weak i54 @_ssdm_op_BitConcatenate.i54.i1.i52.i1(i1, i52, i1) nounwind readnone {
entry:
  %empty = zext i52 %1 to i53
  %empty_46 = zext i1 %2 to i53
  %empty_47 = shl i53 %empty, 1
  %empty_48 = or i53 %empty_47, %empty_46
  %empty_49 = zext i1 %0 to i54
  %empty_50 = zext i53 %empty_48 to i54
  %empty_51 = shl i54 %empty_49, 53
  %empty_52 = or i54 %empty_51, %empty_50
  ret i54 %empty_52
}

define weak i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31, i1) nounwind readnone {
entry:
  %empty = zext i31 %0 to i32
  %empty_53 = zext i1 %1 to i32
  %empty_54 = shl i32 %empty, 1
  %empty_55 = or i32 %empty_54, %empty_53
  ret i32 %empty_55
}

define weak i32 @_ssdm_op_BitConcatenate.i32.i30.i2(i30, i2) nounwind readnone {
entry:
  %empty = zext i30 %0 to i32
  %empty_56 = zext i2 %1 to i32
  %empty_57 = shl i32 %empty, 2
  %empty_58 = or i32 %empty_57, %empty_56
  ret i32 %empty_58
}

define weak i288 @_ssdm_op_BitConcatenate.i288.i32.i32.i32.i32.i32.i32.i32.i32.i32(i32, i32, i32, i32, i32, i32, i32, i32, i32) nounwind readnone {
entry:
  %empty = zext i32 %7 to i64
  %empty_59 = zext i32 %8 to i64
  %empty_60 = shl i64 %empty, 32
  %empty_61 = or i64 %empty_60, %empty_59
  %empty_62 = zext i32 %6 to i96
  %empty_63 = zext i64 %empty_61 to i96
  %empty_64 = shl i96 %empty_62, 64
  %empty_65 = or i96 %empty_64, %empty_63
  %empty_66 = zext i32 %5 to i128
  %empty_67 = zext i96 %empty_65 to i128
  %empty_68 = shl i128 %empty_66, 96
  %empty_69 = or i128 %empty_68, %empty_67
  %empty_70 = zext i32 %4 to i160
  %empty_71 = zext i128 %empty_69 to i160
  %empty_72 = shl i160 %empty_70, 128
  %empty_73 = or i160 %empty_72, %empty_71
  %empty_74 = zext i32 %3 to i192
  %empty_75 = zext i160 %empty_73 to i192
  %empty_76 = shl i192 %empty_74, 160
  %empty_77 = or i192 %empty_76, %empty_75
  %empty_78 = zext i32 %2 to i224
  %empty_79 = zext i192 %empty_77 to i224
  %empty_80 = shl i224 %empty_78, 192
  %empty_81 = or i224 %empty_80, %empty_79
  %empty_82 = zext i32 %1 to i256
  %empty_83 = zext i224 %empty_81 to i256
  %empty_84 = shl i256 %empty_82, 224
  %empty_85 = or i256 %empty_84, %empty_83
  %empty_86 = zext i32 %0 to i288
  %empty_87 = zext i256 %empty_85 to i288
  %empty_88 = shl i288 %empty_86, 256
  %empty_89 = or i288 %empty_88, %empty_87
  ret i288 %empty_89
}

declare void @_ssdm_SpecDependence(...) nounwind

declare i96 @_autotb_FifoWrite_i96(i96*, i96)

declare i32 @_autotb_FifoWrite_i32(i32*, i32)

declare i288 @_autotb_FifoWrite_i288(i288*, i288)

declare i96 @_autotb_FifoRead_i96(i96*)

declare i32 @_autotb_FifoRead_i32(i32*)

declare i288 @_autotb_FifoRead_i288(i288*)

declare void @_GLOBAL__I_a63() nounwind section ".text.startup"

declare void @_GLOBAL__I_a() nounwind section ".text.startup"

define internal fastcc void @Loop_1_proc(i288* %p_hw_input_stencil_stream_V_value_V, i32* %hw_output_V_value_V, i1* %hw_output_V_last_V) {
newFuncRoot:
  call void (...)* @_ssdm_op_SpecMemCore(i288* %p_hw_input_stencil_stream_V_value_V, [1 x i8]* @p_str, [9 x i8]* @p_str2, [1 x i8]* @p_str, i32 -1, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str)
  call void (...)* @_ssdm_op_SpecInterface(i288* %p_hw_input_stencil_stream_V_value_V, [8 x i8]* @ap_fifo_str, i32 0, i32 0, [1 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str, [1 x i8]* @p_str, [1 x i8]* @p_str, i32 2, i32 2, i32 16, i32 16, [1 x i8]* @p_str, [1 x i8]* @p_str)
  br label %.preheader

.exitStub:                                        ; preds = %.preheader
  ret void

.preheader.preheader:                             ; preds = %.preheader
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 2067604, i64 2067604, i64 2067604)
  %exitcond = icmp eq i11 %p_hw_output_x_scan_2, -130
  %p_hw_output_x_scan_s = select i1 %exitcond, i11 0, i11 %p_hw_output_x_scan_2
  %p_hw_output_y_scan_2 = add i11 1, %p_hw_output_y_scan_1
  %tmp_mid1 = icmp eq i11 %p_hw_output_y_scan_2, -971
  %tmp8 = icmp eq i11 %p_hw_output_y_scan_1, -971
  %tmp_mid2 = select i1 %exitcond, i1 %tmp_mid1, i1 %tmp8
  %p_hw_output_y_scan_s = select i1 %exitcond, i11 %p_hw_output_y_scan_2, i11 %p_hw_output_y_scan_1
  %tmp_1 = call i32 (...)* @_ssdm_op_SpecRegionBegin([12 x i8]* @p_str3)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str) nounwind
  %tmp_value_V = call i288 @_ssdm_op_Read.ap_fifo.volatile.i288P(i288* %p_hw_input_stencil_stream_V_value_V)
  %p_345 = trunc i288 %tmp_value_V to i32
  %p_357 = call i32 @_ssdm_op_PartSelect.i32.i288.i32.i32(i288 %tmp_value_V, i32 64, i32 95)
  %p_381 = call i32 @_ssdm_op_PartSelect.i32.i288.i32.i32(i288 %tmp_value_V, i32 192, i32 223)
  %p_393 = call i32 @_ssdm_op_PartSelect.i32.i288.i32.i32(i288 %tmp_value_V, i32 256, i32 287)
  %tmp_2 = call i31 @_ssdm_op_PartSelect.i31.i288.i32.i32(i288 %tmp_value_V, i32 32, i32 62)
  %p_353 = call i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31 %tmp_2, i1 false)
  %tmp_3 = call i31 @_ssdm_op_PartSelect.i31.i288.i32.i32(i288 %tmp_value_V, i32 96, i32 126)
  %p_365 = call i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31 %tmp_3, i1 false)
  %tmp_4 = call i30 @_ssdm_op_PartSelect.i30.i288.i32.i32(i288 %tmp_value_V, i32 128, i32 157)
  %p_371 = call i32 @_ssdm_op_BitConcatenate.i32.i30.i2(i30 %tmp_4, i2 0)
  %tmp_5 = call i31 @_ssdm_op_PartSelect.i31.i288.i32.i32(i288 %tmp_value_V, i32 160, i32 190)
  %p_377 = call i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31 %tmp_5, i1 false)
  %tmp_6 = call i31 @_ssdm_op_PartSelect.i31.i288.i32.i32(i288 %tmp_value_V, i32 224, i32 254)
  %p_389 = call i32 @_ssdm_op_BitConcatenate.i32.i31.i1(i31 %tmp_6, i1 false)
  %tmp2 = add i32 %p_345, %p_353
  %tmp3 = add i32 %p_365, %p_357
  %tmp1 = add i32 %tmp2, %tmp3
  %tmp5 = add i32 %p_377, %p_371
  %tmp7 = add i32 %p_393, %p_389
  %tmp6 = add i32 %p_381, %tmp7
  %tmp4 = add i32 %tmp5, %tmp6
  %p_397 = add nsw i32 %tmp1, %tmp4
  %p_399 = sitofp i32 %p_397 to float
  %p_400 = fpext float %p_399 to double
  %p_401 = fmul double %p_400, 6.250000e-02
  %p_Val2_s = bitcast double %p_401 to i64
  %loc_V = call i11 @_ssdm_op_PartSelect.i11.i64.i32.i32(i64 %p_Val2_s, i32 52, i32 62) nounwind
  %loc_V_1 = trunc i64 %p_Val2_s to i52
  %tmp_i_i = call i54 @_ssdm_op_BitConcatenate.i54.i1.i52.i1(i1 true, i52 %loc_V_1, i1 false)
  %tmp_i_cast_i = zext i54 %tmp_i_i to i137
  %tmp_i_i_cast_i = zext i11 %loc_V to i12
  %sh_assign = add i12 -1023, %tmp_i_i_cast_i
  %isNeg = call i1 @_ssdm_op_BitSelect.i1.i12.i32(i12 %sh_assign, i32 11)
  %tmp_9_i_i = sub i11 1023, %loc_V
  %tmp_9_i_cast_i = sext i11 %tmp_9_i_i to i12
  %sh_assign_1 = select i1 %isNeg, i12 %tmp_9_i_cast_i, i12 %sh_assign
  %sh_assign_1_i_cast_i = sext i12 %sh_assign_1 to i32
  %tmp_1_i_i = zext i32 %sh_assign_1_i_cast_i to i137
  %tmp_1_i_cast_i = zext i32 %sh_assign_1_i_cast_i to i54
  %tmp_2_i_i = lshr i54 %tmp_i_i, %tmp_1_i_cast_i
  %tmp_3_i_i = shl i137 %tmp_i_cast_i, %tmp_1_i_i
  %tmp = call i1 @_ssdm_op_BitSelect.i1.i54.i32(i54 %tmp_2_i_i, i32 53)
  %tmp_8 = zext i1 %tmp to i32
  %tmp_9 = call i32 @_ssdm_op_PartSelect.i32.i137.i32.i32(i137 %tmp_3_i_i, i32 53, i32 84)
  %p_Val2_4 = select i1 %isNeg, i32 %tmp_8, i32 %tmp_9
  %tmp_s = icmp eq i11 %p_hw_output_x_scan_s, -131
  %tmp_last_V = and i1 %tmp_s, %tmp_mid2
  call void @_ssdm_op_Write.ap_auto.volatile.i32P.i1P(i32* %hw_output_V_value_V, i1* %hw_output_V_last_V, i32 %p_Val2_4, i1 %tmp_last_V)
  %empty_90 = call i32 (...)* @_ssdm_op_SpecRegionEnd([12 x i8]* @p_str3, i32 %tmp_1)
  %p_hw_output_x_scan_1 = add i11 1, %p_hw_output_x_scan_s
  br label %.preheader

.preheader:                                       ; preds = %newFuncRoot, %.preheader.preheader
  %indvar_flatten = phi i21 [ 0, %newFuncRoot ], [ %indvar_flatten_next, %.preheader.preheader ]
  %p_hw_output_y_scan_1 = phi i11 [ 0, %newFuncRoot ], [ %p_hw_output_y_scan_s, %.preheader.preheader ]
  %p_hw_output_x_scan_2 = phi i11 [ 0, %newFuncRoot ], [ %p_hw_output_x_scan_1, %.preheader.preheader ]
  %exitcond_flatten = icmp eq i21 %indvar_flatten, -29548
  %indvar_flatten_next = add i21 %indvar_flatten, 1
  br i1 %exitcond_flatten, label %.exitStub, label %.preheader.preheader
}

!opencl.kernels = !{!0, !7, !13, !13, !16, !16, !22, !16, !16, !25, !16, !16, !16, !16, !16, !16, !16, !16, !16, !27, !29, !35, !38, !38, !44, !47, !47, !16, !16, !29, !29, !16, !48, !16, !29, !35, !51, !51, !53, !53, !53, !16, !16, !16, !16, !16, !16, !16, !16, !16, !56, !59, !59, !59, !59, !59, !62, !62, !64, !66, !68, !68, !16, !16, !16, !16, !69, !71, !71, !16, !73, !76, !78, !80, !81, !83, !83, !16, !16, !27, !84, !84, !29, !35, !85, !85, !16, !16, !16, !16, !16, !16, !16, !16, !16, !87, !16, !16, !16, !16, !88, !91, !91, !91, !91, !94, !94, !94, !94, !96, !96, !96, !96, !91, !91, !91, !91, !94, !94, !94, !94, !96, !96, !96, !96, !98, !101, !16, !16, !16, !105, !108, !108, !16, !109, !109, !111, !16, !16, !16, !13, !13, !16, !16, !113, !116, !116, !16, !118, !120, !120, !16, !122, !122, !124, !122, !122, !124, !126, !108, !108, !129, !16, !16, !16, !132, !108, !108, !16, !16, !16, !134, !108, !108, !136, !16, !16, !16, !138, !138, !140, !140, !142, !16, !16, !124, !124, !16, !144, !146, !148, !148, !35, !35, !152, !152, !154, !156, !156, !16, !16, !16, !16, !157, !159, !159, !16, !16, !35, !160, !160, !162, !162, !164, !166, !166, !167, !169, !169, !167, !171, !171, !173, !175, !175, !16, !16, !176, !178, !178, !35, !35, !179, !179, !173, !176, !178, !178, !16, !35, !181, !181, !183, !184, !184, !186, !16, !144, !183, !188, !188, !190, !190, !16, !16, !16, !16, !16, !16, !16, !16, !98, !192, !16, !16, !16, !105, !194, !194, !196, !16, !13, !13, !16, !16, !198, !118, !200, !200, !16, !202, !202, !204, !202, !202, !204, !126, !206, !16, !16, !16, !208, !108, !108, !142, !16, !16, !204, !204, !169, !169, !167, !98, !210, !16, !16, !16, !105, !108, !108, !16, !212, !212, !214, !16, !13, !13, !16, !16, !216, !118, !218, !218, !16, !220, !220, !222, !220, !220, !222, !126, !224, !16, !16, !16, !226, !108, !108, !142, !16, !16, !222, !222, !169, !169, !167, !98, !228, !16, !16, !16, !105, !108, !108, !16, !230, !230, !232, !16, !13, !13, !16, !16, !234, !118, !236, !236, !16, !238, !238, !240, !238, !238, !240, !126, !242, !16, !16, !16, !244, !108, !108, !142, !16, !16, !240, !240, !169, !169, !167, !246, !248, !16, !250, !250, !252, !250, !250, !252, !254, !16, !16, !16, !256, !108, !108, !16, !258, !260, !262, !262, !142, !16, !16, !252, !252, !16, !144, !146, !264, !264, !35, !35, !266, !266, !268, !270, !270, !16, !16, !16, !16, !271, !273, !273, !16, !16, !35, !274, !274, !162, !162, !164, !166, !166, !276, !278, !278, !276, !280, !280, !81, !83, !83, !16, !16, !27, !84, !84, !35, !35, !38, !38, !81, !27, !84, !84, !35, !281, !281, !183, !283, !283, !285, !16, !47, !47, !16, !16, !16, !16, !246, !287, !289, !289, !291, !289, !289, !291, !293, !16, !16, !16, !295, !108, !108, !142, !16, !16, !291, !291, !278, !278, !276, !246, !297, !299, !299, !301, !299, !299, !301, !303, !16, !16, !16, !305, !108, !108, !142, !16, !16, !301, !301, !278, !278, !276, !246, !307, !309, !309, !311, !309, !309, !311, !313, !16, !16, !16, !315, !108, !108, !142, !16, !16, !311, !311, !278, !278, !276, !317, !319, !16, !321, !323, !324, !324, !326, !324, !324, !326, !328, !16, !16, !16, !330, !108, !108, !16, !332, !333, !335, !335, !142, !16, !16, !326, !326, !16, !144, !146, !337, !337, !35, !35, !339, !339, !341, !343, !343, !16, !16, !16, !344, !346, !346, !16, !35, !347, !347, !162, !162, !164, !166, !166, !349, !351, !351, !349, !353, !353, !354, !356, !356, !16, !16, !357, !359, !359, !35, !35, !360, !360, !354, !357, !359, !359, !16, !35, !362, !362, !183, !364, !364, !366, !16, !368, !368, !16, !16, !16, !16, !16, !317, !370, !372, !372, !374, !372, !372, !374, !376, !16, !16, !378, !108, !108, !142, !16, !16, !374, !374, !351, !351, !349, !317, !380, !382, !382, !384, !382, !382, !384, !386, !16, !16, !16, !388, !108, !108, !142, !16, !16, !384, !384, !351, !351, !349, !317, !390, !392, !392, !394, !392, !392, !394, !396, !16, !16, !16, !398, !108, !108, !142, !16, !16, !394, !394, !351, !351, !349, !98, !400, !16, !16, !16, !16, !402, !402, !404, !404, !406, !408, !408, !16, !144, !183, !410, !410, !13, !13, !16, !412, !118, !414, !414, !16, !122, !122, !124, !122, !122, !124, !126, !98, !416, !16, !16, !16, !16, !418, !418, !166, !166, !420, !422, !422, !16, !144, !183, !424, !424, !13, !13, !16, !426, !118, !428, !428, !16, !202, !202, !204, !16, !202, !202, !204, !126, !98, !430, !16, !16, !16, !16, !432, !432, !434, !434, !436, !438, !438, !16, !144, !183, !440, !440, !13, !13, !16, !442, !118, !444, !444, !16, !220, !220, !222, !16, !220, !220, !222, !126, !98, !446, !16, !16, !16, !16, !448, !448, !450, !450, !452, !454, !454, !16, !144, !183, !456, !456, !13, !13, !16, !458, !118, !460, !460, !16, !238, !238, !240, !16, !238, !238, !240, !126, !246, !462, !250, !250, !252, !250, !250, !252, !246, !464, !289, !289, !291, !289, !289, !291, !246, !466, !299, !299, !301, !299, !299, !301, !246, !468, !309, !309, !311, !309, !309, !311, !317, !470, !324, !324, !326, !324, !324, !326, !317, !472, !372, !372, !374, !372, !372, !374, !317, !474, !382, !382, !384, !382, !382, !384, !317, !476, !392, !392, !394, !392, !392, !394, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !478, !478, !478, !478, !478, !478, !478, !478, !478, !483, !483, !484, !16, !486, !16, !16, !16, !488, !488, !490, !490, !492, !16, !16, !16, !494, !16, !16, !16, !16, !496, !16, !162, !162, !164, !166, !166, !498, !483, !483, !484, !496, !162, !162, !164, !166, !166, !500, !483, !483, !484, !496, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !478, !478, !478, !478, !478, !478, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !478, !478, !478, !478, !478, !478, !478, !478, !478, !16, !478, !478, !478, !478, !478, !478, !502, !502, !502, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !502, !502, !502, !16, !502, !502, !502, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478, !16, !478, !478, !478}
!hls.encrypted.func = !{}
!llvm.map.gv = !{!506}

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
!49 = metadata !{metadata !"kernel_arg_type", metadata !"ap_uint<32> &", metadata !"uint &"}
!50 = metadata !{metadata !"kernel_arg_name", metadata !"in", metadata !"out"}
!51 = metadata !{null, metadata !39, metadata !40, metadata !52, metadata !42, metadata !43, metadata !6}
!52 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<288, false>*", metadata !"int", metadata !"int"}
!53 = metadata !{null, metadata !8, metadata !9, metadata !54, metadata !11, metadata !55, metadata !6}
!54 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<288, false> &"}
!55 = metadata !{metadata !"kernel_arg_name", metadata !"ref"}
!56 = metadata !{null, metadata !1, metadata !2, metadata !57, metadata !4, metadata !58, metadata !6}
!57 = metadata !{metadata !"kernel_arg_type", metadata !"stream<AxiPackedStencil<uint, 1UL, 1UL, 1UL, 1UL> > &", metadata !"stream<PackedStencil<uint, 3UL, 3UL, 1UL, 1UL> > &"}
!58 = metadata !{metadata !"kernel_arg_name", metadata !"in_axi_stream", metadata !"out_stream"}
!59 = metadata !{null, metadata !1, metadata !2, metadata !60, metadata !4, metadata !61, metadata !6}
!60 = metadata !{metadata !"kernel_arg_type", metadata !"stream<PackedStencil<uint, 1UL, 1UL, 1UL, 1UL> > &", metadata !"stream<PackedStencil<uint, 3UL, 3UL, 1UL, 1UL> > &"}
!61 = metadata !{metadata !"kernel_arg_name", metadata !"in_stream", metadata !"out_stream"}
!62 = metadata !{null, metadata !1, metadata !2, metadata !63, metadata !4, metadata !61, metadata !6}
!63 = metadata !{metadata !"kernel_arg_type", metadata !"stream<PackedStencil<uint, 1UL, 3UL, 1UL, 1UL> > &", metadata !"stream<PackedStencil<uint, 3UL, 3UL, 1UL, 1UL> > &"}
!64 = metadata !{null, metadata !8, metadata !9, metadata !65, metadata !11, metadata !12, metadata !6}
!65 = metadata !{metadata !"kernel_arg_type", metadata !"const struct PackedStencil<uint, 3, 3, 1, 1> &"}
!66 = metadata !{null, metadata !8, metadata !9, metadata !67, metadata !11, metadata !15, metadata !6}
!67 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<96, false> &"}
!68 = metadata !{null, metadata !8, metadata !9, metadata !67, metadata !11, metadata !55, metadata !6}
!69 = metadata !{null, metadata !8, metadata !9, metadata !70, metadata !11, metadata !15, metadata !6}
!70 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<96, false> &"}
!71 = metadata !{null, metadata !8, metadata !9, metadata !70, metadata !11, metadata !72, metadata !6}
!72 = metadata !{metadata !"kernel_arg_name", metadata !"op"}
!73 = metadata !{null, metadata !8, metadata !9, metadata !74, metadata !11, metadata !75, metadata !6}
!74 = metadata !{metadata !"kernel_arg_type", metadata !"const struct PackedStencil<uint, 1, 3, 1, 1> &"}
!75 = metadata !{metadata !"kernel_arg_name", metadata !""}
!76 = metadata !{null, metadata !8, metadata !9, metadata !77, metadata !11, metadata !24, metadata !6}
!77 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<96> &"}
!78 = metadata !{null, metadata !8, metadata !9, metadata !79, metadata !11, metadata !75, metadata !6}
!79 = metadata !{metadata !"kernel_arg_type", metadata !"const struct PackedStencil<uint, 1, 1, 1, 1> &"}
!80 = metadata !{null, metadata !8, metadata !9, metadata !74, metadata !11, metadata !12, metadata !6}
!81 = metadata !{null, metadata !8, metadata !9, metadata !82, metadata !11, metadata !15, metadata !6}
!82 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<32, false> &"}
!83 = metadata !{null, metadata !8, metadata !9, metadata !82, metadata !11, metadata !55, metadata !6}
!84 = metadata !{null, metadata !8, metadata !9, metadata !28, metadata !11, metadata !72, metadata !6}
!85 = metadata !{null, metadata !39, metadata !40, metadata !86, metadata !42, metadata !43, metadata !6}
!86 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<96, false>*", metadata !"int", metadata !"int"}
!87 = metadata !{null, metadata !8, metadata !9, metadata !79, metadata !11, metadata !12, metadata !6}
!88 = metadata !{null, metadata !8, metadata !9, metadata !89, metadata !11, metadata !90, metadata !6}
!89 = metadata !{metadata !"kernel_arg_type", metadata !"uint32_t"}
!90 = metadata !{metadata !"kernel_arg_name", metadata !"bits"}
!91 = metadata !{null, metadata !8, metadata !9, metadata !92, metadata !11, metadata !93, metadata !6}
!92 = metadata !{metadata !"kernel_arg_type", metadata !"half"}
!93 = metadata !{metadata !"kernel_arg_name", metadata !"x"}
!94 = metadata !{null, metadata !8, metadata !9, metadata !95, metadata !11, metadata !93, metadata !6}
!95 = metadata !{metadata !"kernel_arg_type", metadata !"float"}
!96 = metadata !{null, metadata !8, metadata !9, metadata !97, metadata !11, metadata !93, metadata !6}
!97 = metadata !{metadata !"kernel_arg_type", metadata !"double"}
!98 = metadata !{null, metadata !1, metadata !2, metadata !99, metadata !4, metadata !100, metadata !6}
!99 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool"}
!100 = metadata !{metadata !"kernel_arg_name", metadata !"x", metadata !"detect_overflow"}
!101 = metadata !{null, metadata !102, metadata !40, metadata !103, metadata !42, metadata !104, metadata !6}
!102 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0, i32 0}
!103 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ulong>::is_signed, _Bool>::type"}
!104 = metadata !{metadata !"kernel_arg_name", metadata !"x", metadata !"detect_overflow", metadata !""}
!105 = metadata !{null, metadata !8, metadata !9, metadata !106, metadata !11, metadata !107, metadata !6}
!106 = metadata !{metadata !"kernel_arg_type", metadata !"_Bool"}
!107 = metadata !{metadata !"kernel_arg_name", metadata !"Cnative"}
!108 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !72, metadata !6}
!109 = metadata !{null, metadata !8, metadata !9, metadata !110, metadata !11, metadata !72, metadata !6}
!110 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<64, 64, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!111 = metadata !{null, metadata !8, metadata !9, metadata !112, metadata !11, metadata !72, metadata !6}
!112 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<64, 64, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!113 = metadata !{null, metadata !1, metadata !2, metadata !114, metadata !4, metadata !115, metadata !6}
!114 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 65, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!115 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"i_op"}
!116 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !117, metadata !6}
!117 = metadata !{metadata !"kernel_arg_name", metadata !"i_op"}
!118 = metadata !{null, metadata !8, metadata !9, metadata !119, metadata !11, metadata !24, metadata !6}
!119 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<32, 32, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!120 = metadata !{null, metadata !8, metadata !9, metadata !121, metadata !11, metadata !72, metadata !6}
!121 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 65, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!122 = metadata !{null, metadata !8, metadata !9, metadata !123, metadata !11, metadata !72, metadata !6}
!123 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<169, 116, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!124 = metadata !{null, metadata !8, metadata !9, metadata !125, metadata !11, metadata !72, metadata !6}
!125 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<169, 116, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!126 = metadata !{null, metadata !30, metadata !31, metadata !127, metadata !33, metadata !128, metadata !6}
!127 = metadata !{metadata !"kernel_arg_type", metadata !"_Bool", metadata !"_Bool", metadata !"_Bool", metadata !"_Bool"}
!128 = metadata !{metadata !"kernel_arg_name", metadata !"underflow", metadata !"overflow", metadata !"lD", metadata !"sign"}
!129 = metadata !{null, metadata !1, metadata !2, metadata !130, metadata !4, metadata !131, metadata !6}
!130 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<169, false> &", metadata !"int"}
!131 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"op2"}
!132 = metadata !{null, metadata !8, metadata !9, metadata !133, metadata !11, metadata !24, metadata !6}
!133 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<169, false> &"}
!134 = metadata !{null, metadata !1, metadata !2, metadata !135, metadata !4, metadata !115, metadata !6}
!135 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<11, false> &", metadata !"int"}
!136 = metadata !{null, metadata !1, metadata !2, metadata !137, metadata !4, metadata !131, metadata !6}
!137 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<11, false> &", metadata !"const ap_int_base<32, true> &"}
!138 = metadata !{null, metadata !8, metadata !9, metadata !139, metadata !11, metadata !72, metadata !6}
!139 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<32, true> &"}
!140 = metadata !{null, metadata !8, metadata !9, metadata !141, metadata !11, metadata !72, metadata !6}
!141 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<11, false> &"}
!142 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !143, metadata !6}
!143 = metadata !{metadata !"kernel_arg_name", metadata !"sh"}
!144 = metadata !{null, metadata !8, metadata !9, metadata !145, metadata !11, metadata !15, metadata !6}
!145 = metadata !{metadata !"kernel_arg_type", metadata !"ulong long"}
!146 = metadata !{null, metadata !8, metadata !9, metadata !45, metadata !11, metadata !147, metadata !6}
!147 = metadata !{metadata !"kernel_arg_name", metadata !"index"}
!148 = metadata !{null, metadata !149, metadata !2, metadata !150, metadata !4, metadata !151, metadata !6}
!149 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 0}
!150 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<53, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int"}
!151 = metadata !{metadata !"kernel_arg_name", metadata !"bv", metadata !"index"}
!152 = metadata !{null, metadata !39, metadata !40, metadata !153, metadata !42, metadata !43, metadata !6}
!153 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<52, false>*", metadata !"int", metadata !"int"}
!154 = metadata !{null, metadata !8, metadata !9, metadata !155, metadata !11, metadata !15, metadata !6}
!155 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<52, false> &"}
!156 = metadata !{null, metadata !8, metadata !9, metadata !155, metadata !11, metadata !55, metadata !6}
!157 = metadata !{null, metadata !8, metadata !9, metadata !158, metadata !11, metadata !15, metadata !6}
!158 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<52, false> &"}
!159 = metadata !{null, metadata !8, metadata !9, metadata !158, metadata !11, metadata !72, metadata !6}
!160 = metadata !{null, metadata !39, metadata !40, metadata !161, metadata !42, metadata !43, metadata !6}
!161 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<53, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int", metadata !"int"}
!162 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !163, metadata !6}
!163 = metadata !{metadata !"kernel_arg_name", metadata !"v"}
!164 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !165, metadata !6}
!165 = metadata !{metadata !"kernel_arg_name", metadata !"b"}
!166 = metadata !{null, metadata !8, metadata !9, metadata !119, metadata !11, metadata !72, metadata !6}
!167 = metadata !{null, metadata !8, metadata !9, metadata !168, metadata !11, metadata !72, metadata !6}
!168 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<53, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!169 = metadata !{null, metadata !8, metadata !9, metadata !170, metadata !11, metadata !72, metadata !6}
!170 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<53, 1, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!171 = metadata !{null, metadata !8, metadata !9, metadata !97, metadata !11, metadata !172, metadata !6}
!172 = metadata !{metadata !"kernel_arg_name", metadata !"f"}
!173 = metadata !{null, metadata !8, metadata !9, metadata !174, metadata !11, metadata !15, metadata !6}
!174 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<64, false> &"}
!175 = metadata !{null, metadata !8, metadata !9, metadata !174, metadata !11, metadata !55, metadata !6}
!176 = metadata !{null, metadata !8, metadata !9, metadata !177, metadata !11, metadata !15, metadata !6}
!177 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<64, false> &"}
!178 = metadata !{null, metadata !8, metadata !9, metadata !177, metadata !11, metadata !72, metadata !6}
!179 = metadata !{null, metadata !39, metadata !40, metadata !180, metadata !42, metadata !43, metadata !6}
!180 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<64, false>*", metadata !"int", metadata !"int"}
!181 = metadata !{null, metadata !39, metadata !40, metadata !182, metadata !42, metadata !43, metadata !6}
!182 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<11, false>*", metadata !"int", metadata !"int"}
!183 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !147, metadata !6}
!184 = metadata !{null, metadata !149, metadata !2, metadata !185, metadata !4, metadata !151, metadata !6}
!185 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<64, false>*", metadata !"int"}
!186 = metadata !{null, metadata !8, metadata !9, metadata !187, metadata !11, metadata !15, metadata !6}
!187 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_bit_ref<64, false> &"}
!188 = metadata !{null, metadata !149, metadata !2, metadata !189, metadata !4, metadata !151, metadata !6}
!189 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<1, false>*", metadata !"int"}
!190 = metadata !{null, metadata !8, metadata !9, metadata !191, metadata !11, metadata !15, metadata !6}
!191 = metadata !{metadata !"kernel_arg_type", metadata !"ulong"}
!192 = metadata !{null, metadata !102, metadata !40, metadata !193, metadata !42, metadata !104, metadata !6}
!193 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uint>::is_signed, _Bool>::type"}
!194 = metadata !{null, metadata !8, metadata !9, metadata !195, metadata !11, metadata !72, metadata !6}
!195 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<32, 32, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!196 = metadata !{null, metadata !8, metadata !9, metadata !197, metadata !11, metadata !72, metadata !6}
!197 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<32, 32, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!198 = metadata !{null, metadata !1, metadata !2, metadata !199, metadata !4, metadata !115, metadata !6}
!199 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 33, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!200 = metadata !{null, metadata !8, metadata !9, metadata !201, metadata !11, metadata !72, metadata !6}
!201 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 33, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!202 = metadata !{null, metadata !8, metadata !9, metadata !203, metadata !11, metadata !72, metadata !6}
!203 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<137, 84, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!204 = metadata !{null, metadata !8, metadata !9, metadata !205, metadata !11, metadata !72, metadata !6}
!205 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<137, 84, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!206 = metadata !{null, metadata !1, metadata !2, metadata !207, metadata !4, metadata !131, metadata !6}
!207 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<137, false> &", metadata !"int"}
!208 = metadata !{null, metadata !8, metadata !9, metadata !209, metadata !11, metadata !24, metadata !6}
!209 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<137, false> &"}
!210 = metadata !{null, metadata !102, metadata !40, metadata !211, metadata !42, metadata !104, metadata !6}
!211 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ushort>::is_signed, _Bool>::type"}
!212 = metadata !{null, metadata !8, metadata !9, metadata !213, metadata !11, metadata !72, metadata !6}
!213 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<16, 16, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!214 = metadata !{null, metadata !8, metadata !9, metadata !215, metadata !11, metadata !72, metadata !6}
!215 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<16, 16, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!216 = metadata !{null, metadata !1, metadata !2, metadata !217, metadata !4, metadata !115, metadata !6}
!217 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 17, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!218 = metadata !{null, metadata !8, metadata !9, metadata !219, metadata !11, metadata !72, metadata !6}
!219 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 17, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!220 = metadata !{null, metadata !8, metadata !9, metadata !221, metadata !11, metadata !72, metadata !6}
!221 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<121, 68, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!222 = metadata !{null, metadata !8, metadata !9, metadata !223, metadata !11, metadata !72, metadata !6}
!223 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<121, 68, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!224 = metadata !{null, metadata !1, metadata !2, metadata !225, metadata !4, metadata !131, metadata !6}
!225 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<121, false> &", metadata !"int"}
!226 = metadata !{null, metadata !8, metadata !9, metadata !227, metadata !11, metadata !24, metadata !6}
!227 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<121, false> &"}
!228 = metadata !{null, metadata !102, metadata !40, metadata !229, metadata !42, metadata !104, metadata !6}
!229 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uchar>::is_signed, _Bool>::type"}
!230 = metadata !{null, metadata !8, metadata !9, metadata !231, metadata !11, metadata !72, metadata !6}
!231 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<8, 8, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!232 = metadata !{null, metadata !8, metadata !9, metadata !233, metadata !11, metadata !72, metadata !6}
!233 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<8, 8, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!234 = metadata !{null, metadata !1, metadata !2, metadata !235, metadata !4, metadata !115, metadata !6}
!235 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 9, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!236 = metadata !{null, metadata !8, metadata !9, metadata !237, metadata !11, metadata !72, metadata !6}
!237 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 9, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!238 = metadata !{null, metadata !8, metadata !9, metadata !239, metadata !11, metadata !72, metadata !6}
!239 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<113, 60, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!240 = metadata !{null, metadata !8, metadata !9, metadata !241, metadata !11, metadata !72, metadata !6}
!241 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<113, 60, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!242 = metadata !{null, metadata !1, metadata !2, metadata !243, metadata !4, metadata !131, metadata !6}
!243 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<113, false> &", metadata !"int"}
!244 = metadata !{null, metadata !8, metadata !9, metadata !245, metadata !11, metadata !24, metadata !6}
!245 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<113, false> &"}
!246 = metadata !{null, metadata !1, metadata !2, metadata !247, metadata !4, metadata !100, metadata !6}
!247 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool"}
!248 = metadata !{null, metadata !102, metadata !40, metadata !249, metadata !42, metadata !104, metadata !6}
!249 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ulong>::is_signed, _Bool>::type"}
!250 = metadata !{null, metadata !8, metadata !9, metadata !251, metadata !11, metadata !72, metadata !6}
!251 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<111, 87, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!252 = metadata !{null, metadata !8, metadata !9, metadata !253, metadata !11, metadata !72, metadata !6}
!253 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<111, 87, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!254 = metadata !{null, metadata !1, metadata !2, metadata !255, metadata !4, metadata !131, metadata !6}
!255 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<111, false> &", metadata !"int"}
!256 = metadata !{null, metadata !8, metadata !9, metadata !257, metadata !11, metadata !24, metadata !6}
!257 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<111, false> &"}
!258 = metadata !{null, metadata !1, metadata !2, metadata !259, metadata !4, metadata !115, metadata !6}
!259 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<8, false> &", metadata !"int"}
!260 = metadata !{null, metadata !1, metadata !2, metadata !261, metadata !4, metadata !131, metadata !6}
!261 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<8, false> &", metadata !"const ap_int_base<32, true> &"}
!262 = metadata !{null, metadata !8, metadata !9, metadata !263, metadata !11, metadata !72, metadata !6}
!263 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<8, false> &"}
!264 = metadata !{null, metadata !149, metadata !2, metadata !265, metadata !4, metadata !151, metadata !6}
!265 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<24, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int"}
!266 = metadata !{null, metadata !39, metadata !40, metadata !267, metadata !42, metadata !43, metadata !6}
!267 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<23, false>*", metadata !"int", metadata !"int"}
!268 = metadata !{null, metadata !8, metadata !9, metadata !269, metadata !11, metadata !15, metadata !6}
!269 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<23, false> &"}
!270 = metadata !{null, metadata !8, metadata !9, metadata !269, metadata !11, metadata !55, metadata !6}
!271 = metadata !{null, metadata !8, metadata !9, metadata !272, metadata !11, metadata !15, metadata !6}
!272 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<23, false> &"}
!273 = metadata !{null, metadata !8, metadata !9, metadata !272, metadata !11, metadata !72, metadata !6}
!274 = metadata !{null, metadata !39, metadata !40, metadata !275, metadata !42, metadata !43, metadata !6}
!275 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<24, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int", metadata !"int"}
!276 = metadata !{null, metadata !8, metadata !9, metadata !277, metadata !11, metadata !72, metadata !6}
!277 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<24, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!278 = metadata !{null, metadata !8, metadata !9, metadata !279, metadata !11, metadata !72, metadata !6}
!279 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<24, 1, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!280 = metadata !{null, metadata !8, metadata !9, metadata !95, metadata !11, metadata !172, metadata !6}
!281 = metadata !{null, metadata !39, metadata !40, metadata !282, metadata !42, metadata !43, metadata !6}
!282 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<8, false>*", metadata !"int", metadata !"int"}
!283 = metadata !{null, metadata !149, metadata !2, metadata !284, metadata !4, metadata !151, metadata !6}
!284 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<32, false>*", metadata !"int"}
!285 = metadata !{null, metadata !8, metadata !9, metadata !286, metadata !11, metadata !15, metadata !6}
!286 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_bit_ref<32, false> &"}
!287 = metadata !{null, metadata !102, metadata !40, metadata !288, metadata !42, metadata !104, metadata !6}
!288 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uint>::is_signed, _Bool>::type"}
!289 = metadata !{null, metadata !8, metadata !9, metadata !290, metadata !11, metadata !72, metadata !6}
!290 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<79, 55, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!291 = metadata !{null, metadata !8, metadata !9, metadata !292, metadata !11, metadata !72, metadata !6}
!292 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<79, 55, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!293 = metadata !{null, metadata !1, metadata !2, metadata !294, metadata !4, metadata !131, metadata !6}
!294 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<79, false> &", metadata !"int"}
!295 = metadata !{null, metadata !8, metadata !9, metadata !296, metadata !11, metadata !24, metadata !6}
!296 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<79, false> &"}
!297 = metadata !{null, metadata !102, metadata !40, metadata !298, metadata !42, metadata !104, metadata !6}
!298 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ushort>::is_signed, _Bool>::type"}
!299 = metadata !{null, metadata !8, metadata !9, metadata !300, metadata !11, metadata !72, metadata !6}
!300 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<63, 39, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!301 = metadata !{null, metadata !8, metadata !9, metadata !302, metadata !11, metadata !72, metadata !6}
!302 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<63, 39, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!303 = metadata !{null, metadata !1, metadata !2, metadata !304, metadata !4, metadata !131, metadata !6}
!304 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<63, false> &", metadata !"int"}
!305 = metadata !{null, metadata !8, metadata !9, metadata !306, metadata !11, metadata !24, metadata !6}
!306 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<63, false> &"}
!307 = metadata !{null, metadata !102, metadata !40, metadata !308, metadata !42, metadata !104, metadata !6}
!308 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uchar>::is_signed, _Bool>::type"}
!309 = metadata !{null, metadata !8, metadata !9, metadata !310, metadata !11, metadata !72, metadata !6}
!310 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<55, 31, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!311 = metadata !{null, metadata !8, metadata !9, metadata !312, metadata !11, metadata !72, metadata !6}
!312 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<55, 31, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!313 = metadata !{null, metadata !1, metadata !2, metadata !314, metadata !4, metadata !131, metadata !6}
!314 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<55, false> &", metadata !"int"}
!315 = metadata !{null, metadata !8, metadata !9, metadata !316, metadata !11, metadata !24, metadata !6}
!316 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<55, false> &"}
!317 = metadata !{null, metadata !1, metadata !2, metadata !318, metadata !4, metadata !100, metadata !6}
!318 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool"}
!319 = metadata !{null, metadata !102, metadata !40, metadata !320, metadata !42, metadata !104, metadata !6}
!320 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ulong>::is_signed, _Bool>::type"}
!321 = metadata !{null, metadata !1, metadata !2, metadata !322, metadata !4, metadata !131, metadata !6}
!322 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<5, false> &", metadata !"int"}
!323 = metadata !{null, metadata !8, metadata !9, metadata !139, metadata !11, metadata !24, metadata !6}
!324 = metadata !{null, metadata !8, metadata !9, metadata !325, metadata !11, metadata !72, metadata !6}
!325 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<85, 74, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!326 = metadata !{null, metadata !8, metadata !9, metadata !327, metadata !11, metadata !72, metadata !6}
!327 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<85, 74, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!328 = metadata !{null, metadata !1, metadata !2, metadata !329, metadata !4, metadata !131, metadata !6}
!329 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<85, false> &", metadata !"int"}
!330 = metadata !{null, metadata !8, metadata !9, metadata !331, metadata !11, metadata !24, metadata !6}
!331 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<85, false> &"}
!332 = metadata !{null, metadata !1, metadata !2, metadata !322, metadata !4, metadata !115, metadata !6}
!333 = metadata !{null, metadata !1, metadata !2, metadata !334, metadata !4, metadata !131, metadata !6}
!334 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<5, false> &", metadata !"const ap_int_base<32, true> &"}
!335 = metadata !{null, metadata !8, metadata !9, metadata !336, metadata !11, metadata !72, metadata !6}
!336 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<5, false> &"}
!337 = metadata !{null, metadata !149, metadata !2, metadata !338, metadata !4, metadata !151, metadata !6}
!338 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<11, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int"}
!339 = metadata !{null, metadata !39, metadata !40, metadata !340, metadata !42, metadata !43, metadata !6}
!340 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<10, false>*", metadata !"int", metadata !"int"}
!341 = metadata !{null, metadata !8, metadata !9, metadata !342, metadata !11, metadata !15, metadata !6}
!342 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<10, false> &"}
!343 = metadata !{null, metadata !8, metadata !9, metadata !342, metadata !11, metadata !55, metadata !6}
!344 = metadata !{null, metadata !8, metadata !9, metadata !345, metadata !11, metadata !15, metadata !6}
!345 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<10, false> &"}
!346 = metadata !{null, metadata !8, metadata !9, metadata !345, metadata !11, metadata !72, metadata !6}
!347 = metadata !{null, metadata !39, metadata !40, metadata !348, metadata !42, metadata !43, metadata !6}
!348 = metadata !{metadata !"kernel_arg_type", metadata !"ap_fixed_base<11, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0>*", metadata !"int", metadata !"int"}
!349 = metadata !{null, metadata !8, metadata !9, metadata !350, metadata !11, metadata !72, metadata !6}
!350 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<11, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!351 = metadata !{null, metadata !8, metadata !9, metadata !352, metadata !11, metadata !72, metadata !6}
!352 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<11, 1, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!353 = metadata !{null, metadata !8, metadata !9, metadata !92, metadata !11, metadata !172, metadata !6}
!354 = metadata !{null, metadata !8, metadata !9, metadata !355, metadata !11, metadata !15, metadata !6}
!355 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_range_ref<16, false> &"}
!356 = metadata !{null, metadata !8, metadata !9, metadata !355, metadata !11, metadata !55, metadata !6}
!357 = metadata !{null, metadata !8, metadata !9, metadata !358, metadata !11, metadata !15, metadata !6}
!358 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<16, false> &"}
!359 = metadata !{null, metadata !8, metadata !9, metadata !358, metadata !11, metadata !72, metadata !6}
!360 = metadata !{null, metadata !39, metadata !40, metadata !361, metadata !42, metadata !43, metadata !6}
!361 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<16, false>*", metadata !"int", metadata !"int"}
!362 = metadata !{null, metadata !39, metadata !40, metadata !363, metadata !42, metadata !43, metadata !6}
!363 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<5, false>*", metadata !"int", metadata !"int"}
!364 = metadata !{null, metadata !149, metadata !2, metadata !365, metadata !4, metadata !151, metadata !6}
!365 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<16, false>*", metadata !"int"}
!366 = metadata !{null, metadata !8, metadata !9, metadata !367, metadata !11, metadata !15, metadata !6}
!367 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_bit_ref<16, false> &"}
!368 = metadata !{null, metadata !8, metadata !9, metadata !369, metadata !11, metadata !15, metadata !6}
!369 = metadata !{metadata !"kernel_arg_type", metadata !"ushort"}
!370 = metadata !{null, metadata !102, metadata !40, metadata !371, metadata !42, metadata !104, metadata !6}
!371 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uint>::is_signed, _Bool>::type"}
!372 = metadata !{null, metadata !8, metadata !9, metadata !373, metadata !11, metadata !72, metadata !6}
!373 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<53, 42, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!374 = metadata !{null, metadata !8, metadata !9, metadata !375, metadata !11, metadata !72, metadata !6}
!375 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<53, 42, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!376 = metadata !{null, metadata !1, metadata !2, metadata !377, metadata !4, metadata !131, metadata !6}
!377 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<53, false> &", metadata !"int"}
!378 = metadata !{null, metadata !8, metadata !9, metadata !379, metadata !11, metadata !24, metadata !6}
!379 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<53, false> &"}
!380 = metadata !{null, metadata !102, metadata !40, metadata !381, metadata !42, metadata !104, metadata !6}
!381 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<ushort>::is_signed, _Bool>::type"}
!382 = metadata !{null, metadata !8, metadata !9, metadata !383, metadata !11, metadata !72, metadata !6}
!383 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<37, 26, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!384 = metadata !{null, metadata !8, metadata !9, metadata !385, metadata !11, metadata !72, metadata !6}
!385 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<37, 26, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!386 = metadata !{null, metadata !1, metadata !2, metadata !387, metadata !4, metadata !131, metadata !6}
!387 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<37, false> &", metadata !"int"}
!388 = metadata !{null, metadata !8, metadata !9, metadata !389, metadata !11, metadata !24, metadata !6}
!389 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<37, false> &"}
!390 = metadata !{null, metadata !102, metadata !40, metadata !391, metadata !42, metadata !104, metadata !6}
!391 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<!std::numeric_limits<uchar>::is_signed, _Bool>::type"}
!392 = metadata !{null, metadata !8, metadata !9, metadata !393, metadata !11, metadata !72, metadata !6}
!393 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<29, 18, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!394 = metadata !{null, metadata !8, metadata !9, metadata !395, metadata !11, metadata !72, metadata !6}
!395 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<29, 18, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!396 = metadata !{null, metadata !1, metadata !2, metadata !397, metadata !4, metadata !131, metadata !6}
!397 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<29, false> &", metadata !"int"}
!398 = metadata !{null, metadata !8, metadata !9, metadata !399, metadata !11, metadata !24, metadata !6}
!399 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<29, false> &"}
!400 = metadata !{null, metadata !102, metadata !40, metadata !401, metadata !42, metadata !104, metadata !6}
!401 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<long>::is_signed, _Bool>::type"}
!402 = metadata !{null, metadata !8, metadata !9, metadata !403, metadata !11, metadata !72, metadata !6}
!403 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<63, 63, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!404 = metadata !{null, metadata !8, metadata !9, metadata !405, metadata !11, metadata !72, metadata !6}
!405 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<64, 64, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!406 = metadata !{null, metadata !8, metadata !9, metadata !407, metadata !11, metadata !72, metadata !6}
!407 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed<64, 64, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!408 = metadata !{null, metadata !8, metadata !9, metadata !409, metadata !11, metadata !72, metadata !6}
!409 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<63, 63, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!410 = metadata !{null, metadata !149, metadata !2, metadata !411, metadata !4, metadata !151, metadata !6}
!411 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<64, true>*", metadata !"int"}
!412 = metadata !{null, metadata !1, metadata !2, metadata !413, metadata !4, metadata !115, metadata !6}
!413 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 64, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!414 = metadata !{null, metadata !8, metadata !9, metadata !415, metadata !11, metadata !72, metadata !6}
!415 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 64, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!416 = metadata !{null, metadata !102, metadata !40, metadata !417, metadata !42, metadata !104, metadata !6}
!417 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<int>::is_signed, _Bool>::type"}
!418 = metadata !{null, metadata !8, metadata !9, metadata !419, metadata !11, metadata !72, metadata !6}
!419 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<31, 31, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!420 = metadata !{null, metadata !8, metadata !9, metadata !421, metadata !11, metadata !72, metadata !6}
!421 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed<32, 32, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!422 = metadata !{null, metadata !8, metadata !9, metadata !423, metadata !11, metadata !72, metadata !6}
!423 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<31, 31, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!424 = metadata !{null, metadata !149, metadata !2, metadata !425, metadata !4, metadata !151, metadata !6}
!425 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<32, true>*", metadata !"int"}
!426 = metadata !{null, metadata !1, metadata !2, metadata !427, metadata !4, metadata !115, metadata !6}
!427 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 32, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!428 = metadata !{null, metadata !8, metadata !9, metadata !429, metadata !11, metadata !72, metadata !6}
!429 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 32, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!430 = metadata !{null, metadata !102, metadata !40, metadata !431, metadata !42, metadata !104, metadata !6}
!431 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<short>::is_signed, _Bool>::type"}
!432 = metadata !{null, metadata !8, metadata !9, metadata !433, metadata !11, metadata !72, metadata !6}
!433 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<15, 15, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!434 = metadata !{null, metadata !8, metadata !9, metadata !435, metadata !11, metadata !72, metadata !6}
!435 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<16, 16, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!436 = metadata !{null, metadata !8, metadata !9, metadata !437, metadata !11, metadata !72, metadata !6}
!437 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed<16, 16, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!438 = metadata !{null, metadata !8, metadata !9, metadata !439, metadata !11, metadata !72, metadata !6}
!439 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<15, 15, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!440 = metadata !{null, metadata !149, metadata !2, metadata !441, metadata !4, metadata !151, metadata !6}
!441 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<16, true>*", metadata !"int"}
!442 = metadata !{null, metadata !1, metadata !2, metadata !443, metadata !4, metadata !115, metadata !6}
!443 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 16, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!444 = metadata !{null, metadata !8, metadata !9, metadata !445, metadata !11, metadata !72, metadata !6}
!445 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 16, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!446 = metadata !{null, metadata !102, metadata !40, metadata !447, metadata !42, metadata !104, metadata !6}
!447 = metadata !{metadata !"kernel_arg_type", metadata !"double", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<signed char>::is_signed, _Bool>::type"}
!448 = metadata !{null, metadata !8, metadata !9, metadata !449, metadata !11, metadata !72, metadata !6}
!449 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<7, 7, false, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!450 = metadata !{null, metadata !8, metadata !9, metadata !451, metadata !11, metadata !72, metadata !6}
!451 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<8, 8, true, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!452 = metadata !{null, metadata !8, metadata !9, metadata !453, metadata !11, metadata !72, metadata !6}
!453 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed<8, 8, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!454 = metadata !{null, metadata !8, metadata !9, metadata !455, metadata !11, metadata !72, metadata !6}
!455 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_ufixed<7, 7, (enum ap_q_mode)6, (enum ap_o_mode)3, 0> &"}
!456 = metadata !{null, metadata !149, metadata !2, metadata !457, metadata !4, metadata !151, metadata !6}
!457 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<8, true>*", metadata !"int"}
!458 = metadata !{null, metadata !1, metadata !2, metadata !459, metadata !4, metadata !115, metadata !6}
!459 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 8, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &", metadata !"int"}
!460 = metadata !{null, metadata !8, metadata !9, metadata !461, metadata !11, metadata !72, metadata !6}
!461 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<1, 8, false, (enum ap_q_mode)5, (enum ap_o_mode)0, 0> &"}
!462 = metadata !{null, metadata !102, metadata !40, metadata !463, metadata !42, metadata !104, metadata !6}
!463 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<long>::is_signed, _Bool>::type"}
!464 = metadata !{null, metadata !102, metadata !40, metadata !465, metadata !42, metadata !104, metadata !6}
!465 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<int>::is_signed, _Bool>::type"}
!466 = metadata !{null, metadata !102, metadata !40, metadata !467, metadata !42, metadata !104, metadata !6}
!467 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<short>::is_signed, _Bool>::type"}
!468 = metadata !{null, metadata !102, metadata !40, metadata !469, metadata !42, metadata !104, metadata !6}
!469 = metadata !{metadata !"kernel_arg_type", metadata !"float", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<signed char>::is_signed, _Bool>::type"}
!470 = metadata !{null, metadata !102, metadata !40, metadata !471, metadata !42, metadata !104, metadata !6}
!471 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<long>::is_signed, _Bool>::type"}
!472 = metadata !{null, metadata !102, metadata !40, metadata !473, metadata !42, metadata !104, metadata !6}
!473 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<int>::is_signed, _Bool>::type"}
!474 = metadata !{null, metadata !102, metadata !40, metadata !475, metadata !42, metadata !104, metadata !6}
!475 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<short>::is_signed, _Bool>::type"}
!476 = metadata !{null, metadata !102, metadata !40, metadata !477, metadata !42, metadata !104, metadata !6}
!477 = metadata !{metadata !"kernel_arg_type", metadata !"half", metadata !"_Bool", metadata !"typename enable_if<std::numeric_limits<signed char>::is_signed, _Bool>::type"}
!478 = metadata !{null, metadata !479, metadata !9, metadata !480, metadata !481, metadata !482, metadata !6}
!479 = metadata !{metadata !"kernel_arg_addr_space", i32 1}
!480 = metadata !{metadata !"kernel_arg_type", metadata !"char*"}
!481 = metadata !{metadata !"kernel_arg_type_qual", metadata !"const"}
!482 = metadata !{metadata !"kernel_arg_name", metadata !"str"}
!483 = metadata !{null, metadata !8, metadata !9, metadata !97, metadata !11, metadata !163, metadata !6}
!484 = metadata !{null, metadata !8, metadata !9, metadata !97, metadata !11, metadata !485, metadata !6}
!485 = metadata !{metadata !"kernel_arg_name", metadata !"d"}
!486 = metadata !{null, metadata !1, metadata !2, metadata !487, metadata !4, metadata !131, metadata !6}
!487 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<1, false> &", metadata !"const ap_int_base<54, true> &"}
!488 = metadata !{null, metadata !8, metadata !9, metadata !489, metadata !11, metadata !72, metadata !6}
!489 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<54, true> &"}
!490 = metadata !{null, metadata !8, metadata !9, metadata !491, metadata !11, metadata !72, metadata !6}
!491 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<1, false> &"}
!492 = metadata !{null, metadata !8, metadata !9, metadata !493, metadata !11, metadata !24, metadata !6}
!493 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<55, true> &"}
!494 = metadata !{null, metadata !8, metadata !9, metadata !495, metadata !11, metadata !24, metadata !6}
!495 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<33, true> &"}
!496 = metadata !{null, metadata !8, metadata !9, metadata !97, metadata !11, metadata !497, metadata !6}
!497 = metadata !{metadata !"kernel_arg_name", metadata !"pf"}
!498 = metadata !{null, metadata !8, metadata !9, metadata !499, metadata !11, metadata !72, metadata !6}
!499 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<25, 1, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!500 = metadata !{null, metadata !8, metadata !9, metadata !501, metadata !11, metadata !72, metadata !6}
!501 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_fixed_base<7, 0, false, (enum ap_q_mode)5, (enum ap_o_mode)3, 0> &"}
!502 = metadata !{null, metadata !149, metadata !2, metadata !503, metadata !504, metadata !505, metadata !6}
!503 = metadata !{metadata !"kernel_arg_type", metadata !"char*", metadata !"signed char"}
!504 = metadata !{metadata !"kernel_arg_type_qual", metadata !"const", metadata !""}
!505 = metadata !{metadata !"kernel_arg_name", metadata !"str", metadata !"radix"}
!506 = metadata !{metadata !507, [2 x i32]* @llvm_global_ctors_0}
!507 = metadata !{metadata !508}
!508 = metadata !{i32 0, i32 31, metadata !509}
!509 = metadata !{metadata !510}
!510 = metadata !{metadata !"llvm.global_ctors.0", metadata !511, metadata !"", i32 0, i32 31}
!511 = metadata !{metadata !512}
!512 = metadata !{i32 0, i32 1, i32 1}
!513 = metadata !{metadata !514}
!514 = metadata !{i32 0, i32 31, metadata !515}
!515 = metadata !{metadata !516}
!516 = metadata !{metadata !"hw_input.V.value.V", metadata !517, metadata !"uint32", i32 0, i32 31}
!517 = metadata !{metadata !518}
!518 = metadata !{i32 0, i32 0, i32 1}
!519 = metadata !{metadata !520}
!520 = metadata !{i32 0, i32 0, metadata !521}
!521 = metadata !{metadata !522}
!522 = metadata !{metadata !"hw_input.V.last.V", metadata !517, metadata !"uint1", i32 0, i32 0}
!523 = metadata !{metadata !524}
!524 = metadata !{i32 0, i32 31, metadata !525}
!525 = metadata !{metadata !526}
!526 = metadata !{metadata !"hw_output.V.value.V", metadata !517, metadata !"uint32", i32 0, i32 31}
!527 = metadata !{metadata !528}
!528 = metadata !{i32 0, i32 0, metadata !529}
!529 = metadata !{metadata !530}
!530 = metadata !{metadata !"hw_output.V.last.V", metadata !517, metadata !"uint1", i32 0, i32 0}
