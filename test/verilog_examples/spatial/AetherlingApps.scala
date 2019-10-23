package spatial.tests.aetherling

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


import spatial.dsl._
import forge.tags._
import spatial.lang.AxiStream256Bus
object Samplers {
  // Dumb version that is just transliterated C, using 2 controllers, no parallelization
  @virtualize
  @api def TwoBoxes[T:Num](
    in: FIFO[T],
    out: FIFO[T],
    downRate: scala.Int,
    upRate: scala.Int,
    tileSize: scala.Int,
    numel: scala.Int
  ): Unit = {
    val down = FIFO[T](tileSize)
    // Q2: Is it fair to deq {downRate} elements per cycle?
    'DOWNSAMP.Foreach(numel by 1){ i =>
      val data = in.deq()
      if (i % downRate == 0) down.enq(data)
    }
    // Q3: Is it fair to enq a vector instead of using a nested cchain?
    'UPSAMP.Foreach(numel/downRate by 1, upRate by 1){ (i,j) =>
      val latch = Reg[T]
      val data = if (j == 0) {val t = down.deq(); latch := t; t} else {latch.value}
      out.enq(data)
    }
  }

  // Smarter implementation using FIFOs, spamming logic, and a single controller with rate-matching
  @virtualize
  @api def OneBox[T:Num](
    in: FIFO[T],
    out: FIFO[T],
    downRate: scala.Int,
    upRate: scala.Int,
    tileSize: scala.Int,
    numel: scala.Int,
    inPar: scala.Int
  ): Unit = {
    assert(upRate <= downRate, "OneBox needs to be rewritten to support upRate > downRate")
    val minInView = scala.math.ceil(({inPar-downRate+1} max 1).toDouble / downRate.toDouble).toInt
    val maxInView = scala.math.ceil(inPar.toDouble / downRate.toDouble).toInt
//    assert(inPar <= downRate, "OneBox needs to be rewritten to support multiple captures per vec during downsampling")
    'SAMPLER.Foreach(numel by inPar){ i =>
      val raw = in.deqVec(inPar)
      val isEn = List.tabulate(inPar){n => if (((i + n) % downRate) == 0.to[I32]) 1.to[I4] else 0.to[I4]}
      val inView = isEn.sumTree
      List.tabulate(maxInView-minInView+1){kk =>
        val k = kk + minInView - 1
        if (inView == (k + 1).to[I4]) {
          val seqData = List.tabulate(k + 1){m =>val takeMask: List[Bit] = List.tabulate(inPar){n => (isEn(n) == 1.to[I4]) && isEn.take(n).sumTree == m.to[I4]}
            List.tabulate(upRate){p => oneHotMux(takeMask, List.tabulate(inPar){i => raw(i)})}
          }.reduce{_++_}
          out.enqVec(Vec.ZeroFirst(seqData:_*))
        }
      }
    }
  }
}

import spatial.dsl._

// class DownUpSampleDRAM1 extends DownUpSampleDRAM(1,128)
// class DownUpSampleDRAM2 extends DownUpSampleDRAM(2,256)
// class DownUpSampleDRAM4 extends DownUpSampleDRAM(4,512)
// class DownUpSampleDRAM8 extends DownUpSampleDRAM(8,512)
// class DownUpSampleDRAM8OneBox extends DownUpSampleDRAM(8,512) {
//   override def backends = Seq(VCS, Zynq, ZCU)
// }
// class DownUpSampleDRAM8TwoBox extends DownUpSampleDRAM(8,512, true) {
//   override def backends = Seq(VCS, Zynq, ZCU)
// }
// class DownUpSampleDRAM16 extends DownUpSampleDRAM(16,512)
// class DownUpSampleDRAM32 extends DownUpSampleDRAM(32,512)

// // Test with data coming from DRAM
// @spatial abstract class DownUpSampleDRAM(inWidth: scala.Int, tileSize: scala.Int, useTwoBox: scala.Boolean = false) extends SpatialTest {
//   override def backends = DISABLED

//   def main(args: Array[String]): Unit = {
//     val numel = 200
//     val downRate = 5
//     val upRate = 4
//     val signalData = Array.tabulate[I8](numel){i => i.to[I8]}
//     val inDRAM = DRAM[I8](numel)
//     val outDRAM = DRAM[I8](numel/downRate*upRate)
//     setMem(inDRAM, signalData)

//     Accel {
//       val in = FIFO[I8](tileSize)
//       val out = FIFO[I8](tileSize)

//       // Q1: Is it fair to just drop {downRate-1} of every {downRate} elements upon loading?
//       Stream {
//         in load inDRAM(0 :: numel par inWidth)

//         if (useTwoBox) Samplers.TwoBoxes[I8](in, out, downRate, upRate, tileSize, numel)
//         else Samplers.OneBox[I8](in, out, downRate, upRate, tileSize, numel, inWidth)

//         // Q4: Is it fair to do the down and the up sampling in one loop?
//         Pipe {
//           outDRAM(0 :: numel / 5 * 4) store out
//         }
//       }
//     }

//     val gold = Array(List.tabulate(numel/downRate, upRate){(i,j) => signalData(i*downRate)}.flatten:_*)
//     val got = getMem(outDRAM)
//     printArray(gold, "Wanted:")
//     printArray(got, "Got:")
//     println(r"PASS: ${gold === got}")
//     assert(got === gold)
//   }
// }


// // Test with data coming from black box stream, using the Sampler
// class DownUpSampleStream1 extends DownUpSampleStream(1,128)
// class DownUpSampleStream5 extends DownUpSampleStream(5,256)
// class DownUpSampleStream10 extends DownUpSampleStream(10,512)
// class DownUpSampleStream15 extends DownUpSampleStream(15,512)
// class DownUpSampleStream20 extends DownUpSampleStream(20,512)
// class DownUpSampleStream25 extends DownUpSampleStream(25,512)
// class DownUpSampleStream50 extends DownUpSampleStream(50,512)

// @spatial abstract class DownUpSampleStream(inWidth: scala.Int, tileSize: scala.Int) extends SpatialTest {
//   override def backends = DISABLED

//   def main(args: Array[String]): Unit = {
//     val numel = 200
//     val downRate = 5
//     val upRate = 4
//     val inStream =
//       if (inWidth == 1) StreamIn[I8](AxiStream256Bus)
//       else if (inWidth == 5) StreamIn[I40](AxiStream256Bus)
//       else if (inWidth == 10) StreamIn[I80](AxiStream256Bus)
//       else if (inWidth == 15) StreamIn[I120](AxiStream256Bus)
//       else if (inWidth == 20) StreamIn[I160](AxiStream256Bus)
//       else if (inWidth == 25) StreamIn[I200](AxiStream256Bus)
//       else StreamIn[I240](AxiStream256Bus)
//     val outStream = StreamOut[I8](AxiStream256Bus)
//     Accel {
//       val in = FIFO[I8](tileSize)
//       val out = FIFO[I8](tileSize)

//       // Q1: Is it fair to just drop {downRate-1} of every {downRate} elements upon loading?
//       Stream {
//         val d: Vec[I8] =
//           if (inWidth == 1) inStream.asInstanceOf[StreamIn[I8]].value().asVec[I8]
//           else if (inWidth == 5) inStream.asInstanceOf[StreamIn[I40]].value().asVec[I8]
//           else if (inWidth == 10) inStream.asInstanceOf[StreamIn[I80]].value().asVec[I8]
//           else if (inWidth == 15) inStream.asInstanceOf[StreamIn[I120]].value().asVec[I8]
//           else if (inWidth == 20) inStream.asInstanceOf[StreamIn[I160]].value().asVec[I8]
//           else if (inWidth == 25) inStream.asInstanceOf[StreamIn[I200]].value().asVec[I8]
//           else inStream.asInstanceOf[StreamIn[I240]].value().asVec[I8]
//         in.enqVec(d)


// //        Samplers.TwoBoxes[I8](in, out, downRate, upRate, tileSize, numel)
//         Samplers.OneBox[I8](in, out, downRate, upRate, tileSize, numel, inWidth)

//         // Q4: Is it fair to do the down and the up sampling in one loop?
//         outStream := out.deq()
//       }
//     }
// //    assert(args(0).to[Bit]) // dummy assert

//   }
// }


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
    val inStream = StreamIn[TI](AxiStream256Bus)
    val outStream = StreamOut[TO](AxiStream256Bus)
    Accel {
      'SAMPLER_BOX.Pipe.II(1).Foreach(*) { _ =>
        // Collect input data
        val dI: Vec[I8] = inStream.value().asVec[I8]

        // Rip out desired sample and send out
        if (inWidth == 1) {
          val ctr = Reg[Int](0)
          val latch = Reg[I8]
          ctr :+= 1
          if (ctr.value % downRate == 0) {
            latch := dI.apply(0)
          }
          if (ctr.value % downRate != 4) {
            outStream.asInstanceOf[StreamOut[I8]] := latch.value
          }
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
    val inStream = StreamIn[TI](AxiStream256Bus)

    val outStream = StreamOut[TI](AxiStream256Bus)

    Accel {
      'SAMPLER_BOX.Pipe.II(1).Foreach(*) { _ =>
        outStream := inStream.value().asVec[I8].map(_ + 5.to[I8]).asPacked[TI]
      }
    }
//    assert(args(0).to[Bit]) // dummy assert

  }
}



