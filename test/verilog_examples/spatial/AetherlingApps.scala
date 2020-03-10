package spatial.tests.feature.dense

// # C implementation
//#include<printf.h>
//
//int main(int argc, char** argv) {
//    int inputs[1000];
//    for (int i = 0; i < 1000; i++){
//        inputs[i] = i;
//    }
//    int downsample_result[200];
//    for (int i = 0; i < 200; i++){
//        downsample_result[i] = inputs[i*5];
//    }
//    int upsample_result[800];
//    for (int i = 0; i < 200; i++){
//        for (int j = 0; j < 4; j++){
//            upsample_result[i*4+j] = downsample_result[i];
//        }
//    }
//    for (int i = 0; i < 800; i++){
//        printf("output %d: %d\n", i, upsample_result[i]);
//    }
//    return 0;
//}

object Helper2 {
  def ifThenElse[T](c1: scala.Int, c2: scala.Int, v1: T, v2: T): T = {
    if (c1 == c2) v1 else v2
  }
}

import spatial.dsl._
import forge.tags._
import spatial.lang.AxiStream256Bus
//object Samplers {
//  // Dumb version that is just transliterated C, using 2 controllers, no parallelization
//  @virtualize
//  @api def TwoBoxes[T:Num](
//    in: FIFO[T],
//    out: FIFO[T],
//    downRate: scala.Int,
//    upRate: scala.Int,
//    tileSize: scala.Int,
//    numel: scala.Int
//  ): Unit = {
//    val down = FIFO[T](tileSize)
//    // Q2: Is it fair to deq {downRate} elements per cycle?
//    'DOWNSAMP.Foreach(numel by 1){ i =>
//      val data = in.deq()
//      if (i % downRate == 0) down.enq(data)
//    }
//    // Q3: Is it fair to enq a vector instead of using a nested cchain?
//    'UPSAMP.Foreach(numel/downRate by 1, upRate by 1){ (i,j) =>
//      val latch = Reg[T]
//      val data = if (j == 0) {val t = down.deq(); latch := t; t} else {latch.value}
//      out.enq(data)
//    }
//  }
//
//  // Smarter implementation using FIFOs, spamming logic, and a single controller with rate-matching
//  @virtualize
//  @api def OneBox[T:Num](
//    in: FIFO[T],
//    out: FIFO[T],
//    downRate: scala.Int,
//    upRate: scala.Int,
//    tileSize: scala.Int,
//    numel: scala.Int,
//    inPar: scala.Int
//  ): Unit = {
//    assert(upRate <= downRate, "OneBox needs to be rewritten to support upRate > downRate")
//    val minInView = scala.math.ceil(({inPar-downRate+1} max 1).toDouble / downRate.toDouble).toInt
//    val maxInView = scala.math.ceil(inPar.toDouble / downRate.toDouble).toInt
////    assert(inPar <= downRate, "OneBox needs to be rewritten to support multiple captures per vec during downsampling")
//    'SAMPLER.Foreach(numel by inPar){ i =>
//      val raw = in.deqVec(inPar)
//      val isEn = List.tabulate(inPar){n => if (((i + n) % downRate) == 0.to[I32]) 1.to[I4] else 0.to[I4]}
//      val inView = isEn.sumTree
//      List.tabulate(maxInView-minInView+1){kk =>
//        val k = kk + minInView - 1
//        if (inView == (k + 1).to[I4]) {
//          val seqData = List.tabulate(k + 1){m =>val takeMask: List[Bit] = List.tabulate(inPar){n => (isEn(n) == 1.to[I4]) && isEn.take(n).sumTree == m.to[I4]}
//            List.tabulate(upRate){p => oneHotMux(takeMask, List.tabulate(inPar){i => raw(i)})}
//          }.reduce{_++_}
//          out.enqVec(Vec.ZeroFirst(seqData:_*))
//        }
//      }
//    }
//  }
//}

import spatial.dsl._
//
//class DownUpSampleDRAM1 extends DownUpSampleDRAM(1,128)
//class DownUpSampleDRAM2 extends DownUpSampleDRAM(2,256)
//class DownUpSampleDRAM4 extends DownUpSampleDRAM(4,512)
//class DownUpSampleDRAM8 extends DownUpSampleDRAM(8,512)
//class DownUpSampleDRAM8OneBox extends DownUpSampleDRAM(8,512) {
//  override def backends = Seq(VCS, Zynq, ZCU)
//}
//class DownUpSampleDRAM8TwoBox extends DownUpSampleDRAM(8,512, true) {
//  override def backends = Seq(VCS, Zynq, ZCU)
//}
//class DownUpSampleDRAM16 extends DownUpSampleDRAM(16,512)
//class DownUpSampleDRAM32 extends DownUpSampleDRAM(32,512)
//
//// Test with data coming from DRAM
//@spatial abstract class DownUpSampleDRAM(inWidth: scala.Int, tileSize: scala.Int, useTwoBox: scala.Boolean = false) extends SpatialTest {
//  override def backends = DISABLED
//
//  def main(args: Array[String]): Unit = {
//    val numel = 200
//    val downRate = 5
//    val upRate = 4
//    val signalData = Array.tabulate[I8](numel){i => i.to[I8]}
//    val inDRAM = DRAM[I8](numel)
//    val outDRAM = DRAM[I8](numel/downRate*upRate)
//    setMem(inDRAM, signalData)
//
//    Accel {
//      val in = FIFO[I8](tileSize)
//      val out = FIFO[I8](tileSize)
//
//      // Q1: Is it fair to just drop {downRate-1} of every {downRate} elements upon loading?
//      Stream {
//        in load inDRAM(0 :: numel par inWidth)
//
//        if (useTwoBox) Samplers.TwoBoxes[I8](in, out, downRate, upRate, tileSize, numel)
//        else Samplers.OneBox[I8](in, out, downRate, upRate, tileSize, numel, inWidth)
//
//        // Q4: Is it fair to do the down and the up sampling in one loop?
//        Pipe {
//          outDRAM(0 :: numel / 5 * 4) store out
//        }
//      }
//    }
//
//    val gold = Array(List.tabulate(numel/downRate, upRate){(i,j) => signalData(i*downRate)}.flatten:_*)
//    val got = getMem(outDRAM)
//    printArray(gold, "Wanted:")
//    printArray(got, "Got:")
//    println(r"PASS: ${gold === got}")
//    assert(got === gold)
//  }
//}
//
//
//@spatial class DownUpSample1Test extends SpatialTest {
//  override def backends = DISABLED
//
//  def main(args: Array[String]): Unit = {
//    val numel = 200
//    val downRate = 5
//    val upRate = 4
//    val inStream = DRAM[I8](200)
//    val outStream = DRAM[I8](160)
//    Accel {
//      val in = FIFO[I8](200)
//      val out = FIFO[I8](160)
//
//      // Q1: Is it fair to just drop {downRate-1} of every {downRate} elements upon loading?
//      Stream {
//        in load inStream
//
//        Foreach(200 by 1) { i =>
//          // Collect input data
//          val dI: Vec[I8] = inStream.value().asVec[I8]
//
//          // Rip out desired sample and send out
//          val ctr = Reg[Int](0).conflictable
//          val latch = Reg[I8]
//          if (ctr.value == 0) {
//            latch := dI.apply(0)
//            ctr :+= 1
//          }
//          else if (ctr.value != (downRate - 2)) {
//            outStream.asInstanceOf[StreamOut[I8]] := latch.value
//            ctr :+= 1
//          }
//          else if (ctr.value != (downRate - 1)) {
//            ctr :+= 1
//          }
//          else ctr := 0
//        }
//        outStream store out
//      }
//    }
////    assert(args(0).to[Bit]) // dummy assert
//
//  }
//}


// Test with data coming from black box stream, using the Sampler
class DownUpSampleStream1 extends DownUpSampleStream(1,128)
class DownUpSampleStream5 extends DownUpSampleStream(5,256)
class DownUpSampleStream10 extends DownUpSampleStream(10,512)
class DownUpSampleStream15 extends DownUpSampleStream(15,512)
class DownUpSampleStream20 extends DownUpSampleStream(20,512)
class DownUpSampleStream25 extends DownUpSampleStream(25,512)
class DownUpSampleStream50 extends DownUpSampleStream(50,512)

@spatial abstract class DownUpSampleStream(inWidth: scala.Int, tileSize: scala.Int) extends SpatialTest {
  override def backends = DISABLED

  def main(args: Array[String]): Unit = {
    val numel = 200
    val downRate = 5
    val upRate = 4
    val inStream =
      if (inWidth == 1) StreamIn[I8](AxiStream256Bus(0,0))
      else if (inWidth == 5) StreamIn[I40](AxiStream256Bus(0,0))
      else if (inWidth == 10) StreamIn[I80](AxiStream256Bus(0,0))
      else if (inWidth == 15) StreamIn[I120](AxiStream256Bus(0,0))
      else if (inWidth == 20) StreamIn[I160](AxiStream256Bus(0,0))
      else if (inWidth == 25) StreamIn[I200](AxiStream256Bus(0,0))
      else StreamIn[I240](AxiStream256Bus(0,0))
    val outStream = StreamOut[I8](AxiStream256Bus(0,0))
    Accel {
      val in = FIFO[I8](tileSize)
      val out = FIFO[I8](tileSize)

      // Q1: Is it fair to just drop {downRate-1} of every {downRate} elements upon loading?
      Stream {
        val d: Vec[I8] =
          if (inWidth == 1) inStream.asInstanceOf[StreamIn[I8]].value().asVec[I8]
          else if (inWidth == 5) inStream.asInstanceOf[StreamIn[I40]].value().asVec[I8]
          else if (inWidth == 10) inStream.asInstanceOf[StreamIn[I80]].value().asVec[I8]
          else if (inWidth == 15) inStream.asInstanceOf[StreamIn[I120]].value().asVec[I8]
          else if (inWidth == 20) inStream.asInstanceOf[StreamIn[I160]].value().asVec[I8]
          else if (inWidth == 25) inStream.asInstanceOf[StreamIn[I200]].value().asVec[I8]
          else inStream.asInstanceOf[StreamIn[I240]].value().asVec[I8]
        in.enqVec(d)


//        Samplers.TwoBoxes[I8](in, out, downRate, upRate, tileSize, numel)
//        Samplers.OneBox[I8](in, out, downRate, upRate, tileSize, numel, inWidth)

        // Q4: Is it fair to do the down and the up sampling in one loop?
        outStream := out.deq()
      }
    }
//    assert(args(0).to[Bit]) // dummy assert

  }
}


class DownUpSampleBare1 extends DownUpSampleBare[_8,_8](1,128)
class DownUpSampleBare5 extends DownUpSampleBare[_40,_32](5,256)
class DownUpSampleBare10 extends DownUpSampleBare[_80,_64](10,512)
class DownUpSampleBare15 extends DownUpSampleBare[_120,_96](15,512)
class DownUpSampleBare20 extends DownUpSampleBare[_160,_128](20,512)
class DownUpSampleBare25 extends DownUpSampleBare[_200,_160](25,512)
//class DownUpSampleBare50 extends DownUpSampleBare[_400,_320](50,512)

// Bare minimum implementation, intended to have its verilog ripped out and fed into aether
@spatial abstract class DownUpSampleBare[B <: INT[_], C <: INT[_]](inWidth: scala.Int, tileSize: scala.Int)(implicit tev: FixPt[TRUE,B,_0], uev: FixPt[TRUE,C,_0]) extends SpatialTest {
  override def backends = DISABLED
  type TI = FixPt[TRUE,B,_0]
  type TO = FixPt[TRUE,C,_0]

  def main(args: Array[String]): Unit = {
    val numel = 200
    val downRate = 5
    val upRate = 4
    val inStream = StreamIn[TI](AxiStream256Bus(0,0))
    val outStream = StreamOut[TO](AxiStream256Bus(0,0))
    Accel {
      'SAMPLER_BOX.Pipe.II(1).Foreach(*) { _ =>
        // Collect input data
        val dI: Vec[I8] = inStream.value().asVec[I8]

        // Rip out desired sample and send out
        if (inWidth == 1) {
          val ctr = Reg[Int](0).conflictable
          val latch = Reg[I8]
          if (ctr.value == 0) {
            latch := dI.apply(0)
            ctr :+= 1
          }
          else if (ctr.value != (downRate-2)) {
            outStream.asInstanceOf[StreamOut[I8]] := latch.value
            ctr :+= 1
          }
          else if (ctr.value != (downRate-1)) {
            ctr :+= 1
          }
          else ctr := 0
        } else {
          val points: Seq[I8] = Seq.tabulate(inWidth / downRate) { i => dI.apply(i * downRate) }
          val expandedPoints: Seq[I8] = Seq.tabulate(inWidth / downRate) { i => Seq.tabulate(upRate) { _ => points(i) } }.flatten
          outStream := Vec.ZeroFirst(expandedPoints: _*).asPacked[TO]
        }
      }
    }
//    assert(args(0).to[Bit]) // dummy assert

  }
}



class AetherMap1 extends AetherMap[_8](1,128)
class AetherMap2 extends AetherMap[_16](2,256)
class AetherMap4 extends AetherMap[_32](4,512)
class AetherMap8 extends AetherMap[_64](8,512)

// Bare minimum implementation, intended to have its verilog ripped out and fed into aether
@spatial abstract class AetherMap[B <: INT[_]](inWidth: scala.Int, tileSize: scala.Int)(implicit tev: FixPt[TRUE,B,_0]) extends SpatialTest {
  override def backends = DISABLED
  type TI = FixPt[TRUE,B,_0]

  def main(args: Array[String]): Unit = {
    val numel = 200
    val inStream = StreamIn[TI](AxiStream256Bus(0,0))

    val outStream = StreamOut[TI](AxiStream256Bus(0,0))

    Accel {
      'SAMPLER_BOX.Pipe.II(1).Foreach(*) { _ =>
        outStream := retime(3, inStream.value().asVec[I8].map(_ + 5.to[I8]).asPacked[TI])
      }
    }
//    assert(args(0).to[Bit]) // dummy assert

  }
}



class AetherConv1 extends Aetherling[_8]("conv", 1)
class AetherConv2 extends Aetherling[_16]("conv", 2)
class AetherConv4 extends Aetherling[_32]("conv", 4)
class AetherConv8 extends Aetherling[_64]("conv", 8)
class AetherConv16 extends Aetherling[_128]("conv", 16)
class AetherConv32 extends Aetherling[_256]("conv", 32)

class AetherB2B1 extends Aetherling[_8]("b2b", 1)
class AetherB2B2 extends Aetherling[_16]("b2b", 2)
class AetherB2B4 extends Aetherling[_32]("b2b", 4)
class AetherB2B8 extends Aetherling[_64]("b2b", 8)

class AetherSharpen1 extends Aetherling[_8]("sharpen", 1)
class AetherSharpen2 extends Aetherling[_16]("sharpen", 2)
class AetherSharpen4 extends Aetherling[_32]("sharpen", 4)
class AetherSharpen8 extends Aetherling[_64]("sharpen", 8)

// Bare minimum implementation, intended to have its verilog ripped out and fed into aether
@spatial abstract class Aetherling[B <: INT[_]](alg: java.lang.String, inWidth: scala.Int)(implicit tev: FixPt[FALSE,B,_0]) extends SpatialTest {
  override def backends = DISABLED
  type TI = FixPt[FALSE,B,_0]
  @streamstruct case class BBOX_IN(payload: TI)
  @streamstruct case class BBOX_OUT(payload: TI)

  def main(args: Array[String]): Unit = {
    val rows = 1080
    val lb_rows = 4
    val cols = 1920
    val normalize = 16
    val pad_size = 2
    val pad_value = 0

    val data = (0::rows, 0::cols){(i,j) => (i * rows + j + 1).to[U8]}.flatten
    val dram = DRAM[U8](rows * cols)
    val outdram = DRAM[U8](rows * cols)
    setMem(dram, data)

    val inStream = StreamIn[TI](AxiStream256Bus(0,0))
    val outStream = StreamOut[TI](AxiStream256Bus(0,0))
    def pad_aware_select(abs_i: Int, abs_j: Int, lb: SRAM2[U8]): U8 = {
//        if (abs_i < 0 || abs_j < 0) pad_value.to[U8] else lb(abs_i % rows, abs_j)
      lb.__read(Seq(abs_i % lb_rows, abs_j), Set(!(abs_i < 0 || abs_j < 0)))
    }
    // Define bbox outside of Accel
      val aetherling_box = alg match {
        case "conv" => 
          Blackbox.SpatialController[BBOX_IN, BBOX_OUT] { in: BBOX_IN =>
            val kernel = List(1.to[U8],2.to[U8],1.to[U8],2.to[U8],4.to[U8],2.to[U8],1.to[U8],2.to[U8],1.to[U8])
            val cstep = scala.math.min(cols, inWidth)
            val rstep = 1 //Helper2.ifThenElse[scala.Int](inWidth, 8, 2, 1)
            val fifooutpacked = FIFO[TI](inWidth*3)
            'SAMPLER_BOX.Pipe.II(1).Foreach(rows by rstep, cols by cstep) { (i, j) =>
              // Technically you need 3 + inWidth/cols number of rows or something like this
              val lb = SRAM[U8](lb_rows, cols).forcebank(N = Seq(lb_rows, /*cols*/ inWidth + 2), B = Seq(1, 1), alpha = Seq(1, 1))
              val newdata = in.payload.asVec[U8]
              List.tabulate(inWidth) { inst =>
                val inst_ofs_row = inst / cols
                val inst_ofs_col = inst % cols
                val wrRow = oneHotMux(Seq.tabulate(lb_rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(lb_rows) { ii => (((ii % lb_rows) + lb_rows) % lb_rows).to[Int] })
                lb(wrRow, j + inst_ofs_col) = newdata(inst)
              }
              retimeGate()
              val rd_data = List.tabulate(rstep + 2, cstep + 2) { (ii, jj) =>
                val rdrow = i + rstep - 1 - ii
                val rdcol = j + cstep - 1 - jj
                pad_aware_select(rdrow, rdcol, lb)
              }
              val kernel_elems = List.tabulate(3, 3) { (ii, jj) => kernel(ii * 3 + jj).to[U8] }.flatten
              val newresults = List.tabulate(inWidth) { inst =>
                val inst_ofs_row = inst / cols
                val inst_ofs_col = inst % cols
                //          val wrRow = wrRows(inst)
                //          val wrRowM1 = oneHotMux(Seq.tabulate(rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(rows) { ii => ((((ii - 1) % rows) + rows) % rows).to[Int] })
                //          val wrRowM2 = oneHotMux(Seq.tabulate(rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(rows) { ii => ((((ii - 2) % rows) + rows) % rows).to[Int] })
                val data_elems = List.tabulate(3, 3) { (ii, jj) => rd_data(ii + inst_ofs_row)(jj + inst_ofs_col) }.flatten
                data_elems.zip(kernel_elems).map { case (a, b) => a * b }.reduceTree {
                  _ + _
                } / normalize
              }.reverse
              val result = retime(3, Vec.ZeroFirst(newresults: _*).asPacked[TI])
              // outStream := result
              fifooutpacked.enq(result)
            }

          BBOX_OUT(fifooutpacked.deqInterface())
        }
      case "b2b" => 
          Blackbox.SpatialController[BBOX_IN, BBOX_OUT] { in: BBOX_IN =>
            val cstep = scala.math.min(cols, inWidth)
            val rstep = 1 //Helper2.ifThenElse[scala.Int](inWidth, 8, 2, 1)
            val fifooutpacked = FIFO[TI](inWidth*3)
            val kernel1 = List(1.to[U8],2.to[U8],1.to[U8],2.to[U8],4.to[U8],2.to[U8],1.to[U8],2.to[U8],1.to[U8])
            val kernel2 = List(1.to[U8],2.to[U8],2.to[U8],1.to[U8])
            val normalize2 = 6
            'SAMPLER_BOX.Pipe.II(1).Foreach(rows by rstep, cols by cstep) { (i, j) =>
            val lb = SRAM[U8](lb_rows, cols).forcebank(N = Seq(lb_rows, /*cols*/ inWidth + 2), B = Seq(1, 1), alpha = Seq(1, 1))
            val lb2 = SRAM[U8](lb_rows, cols).forcebank(N = Seq(lb_rows, /*cols*/ inWidth + 2), B = Seq(1, 1), alpha = Seq(1, 1))
            val newdata = in.payload.asVec[U8]
            List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val wrRow = oneHotMux(Seq.tabulate(rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(rows) { ii => (((ii % rows) + rows) % rows).to[Int] })
              lb(wrRow, j + inst_ofs_col) = newdata(inst)
            }
            retimeGate()
            val conv1_in = List.tabulate(rstep + 2, cstep + 2) { (ii, jj) =>
              val rdrow = i + rstep - 1 - ii
              val rdcol = j + cstep - 1 - jj
              pad_aware_select(rdrow, rdcol, lb)
            }
            val kernel1_elems = List.tabulate(3, 3) { (ii, jj) => kernel1(ii * 3 + jj).to[U8] }.flatten
            val conv1_out = List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val data_elems = List.tabulate(3, 3) { (ii, jj) => conv1_in(ii + inst_ofs_row)(jj + inst_ofs_col) }.flatten
              data_elems.zip(kernel1_elems).map { case (a, b) => a * b }.reduceTree {
                _ + _
              } / normalize
            }.reverse
            retimeGate()
            List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val wrRow = oneHotMux(Seq.tabulate(rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(rows) { ii => (((ii % rows) + rows) % rows).to[Int] })
              lb2(wrRow, j + inst_ofs_col) = conv1_out(inst)
            }
            retimeGate()
            val conv2_in = List.tabulate(rstep + 1, cstep + 1) { (ii, jj) =>
              val rdrow = i + rstep - 1 - ii
              val rdcol = j + cstep - 1 - jj
              pad_aware_select(rdrow, rdcol, lb2)
            }
            val kernel2_elems = List.tabulate(2, 2) { (ii, jj) => kernel2(ii * 2 + jj).to[U8] }.flatten
            val b2bresults = List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val data_elems = List.tabulate(2, 2) { (ii, jj) => conv2_in(ii + inst_ofs_row)(jj + inst_ofs_col) }.flatten
              data_elems.zip(kernel2_elems).map { case (a, b) => a * b }.reduceTree {
                _ + _
              } / normalize2
            }.reverse
            val result = retime(3, Vec.ZeroFirst(b2bresults: _*).asPacked[TI])
            // outStream := result
            fifooutpacked.enq(result)
          }
          BBOX_OUT(fifooutpacked.deqInterface())
        }
      case "sharpen" => 
          Blackbox.SpatialController[BBOX_IN, BBOX_OUT] { in: BBOX_IN =>
            val kernel = List(1.to[U8],2.to[U8],1.to[U8],2.to[U8],4.to[U8],2.to[U8],1.to[U8],2.to[U8],1.to[U8])
            val cstep = scala.math.min(cols, inWidth)
            val rstep = 1 //Helper2.ifThenElse[scala.Int](inWidth, 8, 2, 1)
            val fifooutpacked = FIFO[TI](inWidth*3)        
            'SAMPLER_BOX.Pipe.II(1).Foreach(rows by rstep, cols by cstep) { (i, j) =>
            val lb = SRAM[U8](lb_rows, cols).forcebank(N = Seq(lb_rows, /*cols*/ inWidth + 2), B = Seq(1, 1), alpha = Seq(1, 1))
            val newdata = in.payload.asVec[U8]
            List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val wrRow = oneHotMux(Seq.tabulate(rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(rows) { ii => (((ii % rows) + rows) % rows).to[Int] })
              lb(wrRow, j + inst_ofs_col) = newdata(inst)
            }
            retimeGate()
            val rd_data = List.tabulate(rstep + 2, cstep + 2) { (ii, jj) =>
              val rdrow = i + rstep - 1 - ii
              val rdcol = j + cstep - 1 - jj
              pad_aware_select(rdrow, rdcol, lb)
            }
            val kernel_elems = List.tabulate(3, 3) { (ii, jj) => kernel(ii * 3 + jj).to[U8] }.flatten
            val newresults = List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val data_elems = List.tabulate(3, 3) { (ii, jj) => rd_data(ii + inst_ofs_row)(jj + inst_ofs_col) }.flatten
              val blur_pt = data_elems.zip(kernel_elems).map { case (a, b) => a * b }.reduceTree {
                _ + _
              } / normalize
              val in_pt = rd_data(inst_ofs_row)(inst_ofs_col)
              val h = mux(abs(in_pt - blur_pt) > 15.to[U8], in_pt - blur_pt, 0.to[U8])
              if (blur_pt == 0) blur_pt else in_pt + (h / 5)
            }.reverse
            val result = retime(3, Vec.ZeroFirst(newresults: _*).asPacked[TI])
            // outStream := result
            fifooutpacked.enq(result)
          }
          BBOX_OUT(fifooutpacked.deqInterface())
        }
    }



    Accel {
      val outbuf = SRAM[U8](rows*cols)
      Stream {
        // Simulate instream
        val fifoinraw = FIFO[U8](lb_rows * cols)
        val fifoinpacked = FIFO[TI](lb_rows * cols)
        val fifooutraw = FIFO[U8](lb_rows * cols)
        Foreach(rows by 1, cols by inWidth){ (i,j) =>
          val els = List.tabulate(inWidth){k => ((5 * (1 + (i*cols + j + k))) % 256).to[U8]} 
          fifoinpacked.enq(Vec.ZeroFirst(els:_*).asPacked[TI])
        }

        // Simulate outstream

        /** DROP IN BBOX CODE */
          // Pipe {
          //   val in = inStream.value
          //   val kernel = List(1.to[U8],2.to[U8],1.to[U8],2.to[U8],4.to[U8],2.to[U8],1.to[U8],2.to[U8],1.to[U8])
          //   val cstep = scala.math.min(cols, inWidth)
          //   val rstep = 1 //Helper2.ifThenElse[scala.Int](inWidth, 8, 2, 1)
          //   val fifooutpacked = FIFO[TI](inWidth*3)
          //   'SAMPLER_BOX.Pipe.II(1).Foreach(rows by rstep, cols by cstep) { (i, j) =>
          //     // Technically you need 3 + inWidth/cols number of rows or something like this
          //     val lb = SRAM[U8](lb_rows, cols).forcebank(N = Seq(lb_rows, /*cols*/ inWidth + 2), B = Seq(1, 1), alpha = Seq(1, 1))
          //     val newdata = in.asVec[U8]
          //     List.tabulate(inWidth) { inst =>
          //       val inst_ofs_row = inst / cols
          //       val inst_ofs_col = inst % cols
          //       val wrRow = oneHotMux(Seq.tabulate(lb_rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(lb_rows) { ii => (((ii % lb_rows) + lb_rows) % lb_rows).to[Int] })
          //       lb(wrRow, j + inst_ofs_col) = newdata(inst)
          //     }
          //     retimeGate()
          //     val rd_data = List.tabulate(rstep + 2, cstep + 2) { (ii, jj) =>
          //       val rdrow = i + rstep - 1 - ii
          //       val rdcol = j + cstep - 1 - jj
          //       pad_aware_select(rdrow, rdcol, lb)
          //     }
          //     val kernel_elems = List.tabulate(3, 3) { (ii, jj) => kernel(ii * 3 + jj).to[U8] }.flatten
          //     val newresults = List.tabulate(inWidth) { inst =>
          //       val inst_ofs_row = inst / cols
          //       val inst_ofs_col = inst % cols
          //       //          val wrRow = wrRows(inst)
          //       //          val wrRowM1 = oneHotMux(Seq.tabulate(rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(rows) { ii => ((((ii - 1) % rows) + rows) % rows).to[Int] })
          //       //          val wrRowM2 = oneHotMux(Seq.tabulate(rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(rows) { ii => ((((ii - 2) % rows) + rows) % rows).to[Int] })
          //       val data_elems = List.tabulate(3, 3) { (ii, jj) => rd_data(ii + inst_ofs_row)(jj + inst_ofs_col) }.flatten
          //       data_elems.zip(kernel_elems).map { case (a, b) => a * b }.reduceTree {
          //         _ + _
          //       } / normalize
          //     }.reverse
          //     val result = retime(3, Vec.ZeroFirst(newresults: _*).asPacked[TI])
          //     outStream := result
          //     // fifooutpacked.enq(result)
          //   }
          // }

        // /** USE BBOX */
        // val fifooutpacked = FIFO[TI](lb_rows * cols)
        // val res = aetherling_box(BBOX_IN(fifoinpacked.deqInterface()))
        // fifooutpacked.enq(res.payload)

        // Foreach(rows by 1, cols by inWidth){ (i,j) => 
        //   fifooutraw.enqVec(res.payload.asVec[U8])
        // }

        // Foreach(rows * cols by 1 par inWidth){ i => 
        //   outbuf(i) = fifooutraw.deq()
        // }

      }
      outdram store outbuf
    }

    val got = getMem(outdram).reshape(rows,cols)
    printMatrix(got, "Got: ")
//    val gold = Array[U8](0, 0, 0, 0, 0, 1, 2, 3, 1, 4, 6, 7, 2, 7, 10, 11).reshape(rows,cols)
    // val gold = Array[U8](0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 7, 0, 0, 10, 11).reshape(rows,cols)
    // printMatrix(gold, "Gold: ")
    // println(r"PASS: ${List.tabulate(2,2){(i,j) => gold(i+2,j+2) === got(i+2,j+2)}.flatten.reduce{_&&_}}")

//    assert(args(0).to[Bit]) // dummy assert

  }
}
