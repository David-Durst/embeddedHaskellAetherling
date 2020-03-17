package spatial.tests.feature

import spatial.dsl._
import forge.tags._
import spatial.lang.AxiStream256Bus


// class AetherConv1_8_bulk extends AetherlingConv_bulk[_8,_8,_9]("conv", 1, 4, 4, 1)
// class AetherConv2_8_bulk extends AetherlingConv_bulk[_16,_8,_9]("conv", 2, 4, 4, 1)
// class AetherConv4_8_bulk extends AetherlingConv_bulk[_32,_8,_9]("conv", 4, 4, 4, 1)
// class AetherConv8_8_bulk extends AetherlingConv_bulk[_64,_8,_9]("conv", 8, 4, 4, 1)
class AetherConv1_32_bulk extends AetherlingConv_bulk[_32,_32,_25]("conv", 1, 1920, 1080)
class AetherConv2_32_bulk extends AetherlingConv_bulk[_64,_32,_25]("conv", 2, 1920, 1080)
class AetherConv4_32_bulk extends AetherlingConv_bulk[_128,_32,_25]("conv", 4, 1920, 1080)
class AetherConv8_32_bulk extends AetherlingConv_bulk[_256,_32,_25]("conv", 8, 1920, 1080)
// Bare minimum implementation, intended to have its verilog ripped out and fed into aether
@spatial abstract class AetherlingConv_bulk[B <: INT[_], X <: INT[_], Q <: INT[_]](alg: java.lang.String, inWidth: scala.Int, cols: scala.Int, rows: scala.Int, inp_scalar: scala.Int = 5)(implicit tev: FixPt[FALSE,B,_0], tev2: FixPt[FALSE,X,_0], tev3: FixPt[FALSE,Q,_7], tev4: FixPt[FALSE,X,_7]) extends SpatialTest {
  type TI = FixPt[FALSE,B,_0]
  type TE = FixPt[FALSE,X,_0]
  type FRAC = FixPt[FALSE,Q,_7]
  @streamstruct case class BBOX_IN(payload: TI)
  @streamstruct case class BBOX_OUT(payload: TI)

  def main(args: Array[String]): Unit = {
    val lb_rows = 4
    val normalize = 16
    val pad_size = 2
    val pad_value = 0

    val data = (0::rows, 0::cols){(i,j) => (i * rows + j + 1).to[TE]}.flatten
    val dram = DRAM[TE](rows * cols)
    val outdram = DRAM[TE](rows * cols)
    setMem(dram, data)

    val inStream = StreamIn[TI](AxiStream256Bus(0,0))
    val outStream = StreamOut[TI](AxiStream256Bus(0,0))
    def pad_aware_select(abs_i: Int, abs_j: Int, lb: SRAM2[TE]): TE = {
//        if (abs_i < 0 || abs_j < 0) pad_value.to[TE] else lb(abs_i % rows, abs_j)
      lb.__read(Seq(abs_i % lb_rows, abs_j), Set(!(abs_i < 0 || abs_j < 0)))
    }
    // Define bbox outside of Accel


    Accel {
      val outbuf = SRAM[TE](rows*cols)
      Stream {
        // Simulate instream
        val fifoinraw = FIFO[TE](lb_rows * cols)
        val fifoinpacked = FIFO[TI](lb_rows * cols)
        val fifooutraw = FIFO[TE](lb_rows * cols)
        Foreach(rows by 1, cols by inWidth){ (i,j) =>
          val els = List.tabulate(inWidth){k => ((inp_scalar * (1 + (i*cols + j + k))) % 256).to[TE]} 
          fifoinpacked.enq(Vec.ZeroFirst(els:_*).asPacked[TI])
        }

        // Simulate outstream

        /** DROP IN BBOX CODE */
          Pipe {
            val kernel = List(1.to[TE],2.to[TE],1.to[TE],2.to[TE],4.to[TE],2.to[TE],1.to[TE],2.to[TE],1.to[TE])
            val cstep = scala.math.min(cols, inWidth)
            val rstep = Helper2.ifThenElse[scala.Int](inWidth, 8, cols, 4, 2, 1)
            val fifooutpacked = FIFO[TI](inWidth*3)
            'SAMPLER_BOX.Pipe.II(1).Foreach(rows by rstep, cols by cstep) { (i, j) =>
              val in = inStream.value
              // Technically you need 3 + inWidth/cols number of rows or something like this
              val lb = SRAM[TE](lb_rows, cols).forcebank(N = Seq(lb_rows, Helper2.ifThenElse[scala.Int](cols, 4, 0, 0, cols, inWidth + 2)), B = Seq(1, 1), alpha = Seq(1, 1))
              val newdata = in.asVec[TE]
              List.tabulate(inWidth) { inst =>
                val inst_ofs_row = inst / cols
                val inst_ofs_col = inst % cols
                val wrRow = (i + inst_ofs_row) % lb_rows //oneHotMux(Seq.tabulate(lb_rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(lb_rows) { ii => (((ii % lb_rows) + lb_rows) % lb_rows).to[Int] })
                lb(wrRow, j + inst_ofs_col) = newdata(inst)
              }
              retimeGate()
              val rd_data = List.tabulate(rstep + 2, cstep + 2) { (ii, jj) =>
                val rdrow = i + rstep - 1 - ii
                val rdcol = j + cstep - 1 - jj
                pad_aware_select(rdrow, rdcol, lb)
              }
              val kernel_elems = List.tabulate(3, 3) { (ii, jj) => kernel(ii * 3 + jj).to[TE] }.flatten
              val newresults = List.tabulate(inWidth) { inst =>
                val inst_ofs_row = inst / cols
                val inst_ofs_col = inst % cols
                val data_elems = List.tabulate(3, 3) { (ii, jj) => rd_data(ii + inst_ofs_row)(jj + inst_ofs_col) }.flatten
                (data_elems.zip(kernel_elems).map { case (a, b) => a *! b }.reduceTree {
                  _ + _
                }.to[FRAC] * (1.0 / normalize).to[FRAC]).to[TE]
              }.reverse
              val result = retime(3, Vec.ZeroFirst(newresults: _*).asPacked[TI])
              outStream := result
              // fifooutpacked.enq(result)
            }
          }

        // /** USE BBOX */
        // val fifooutpacked = FIFO[TI](lb_rows * cols)
        // val res = aetherling_box(BBOX_IN(fifoinpacked.deqInterface()))
        // fifooutpacked.enq(res.payload)

        // Foreach(rows by 1, cols by inWidth){ (i,j) => 
        //   fifooutraw.enqVec(res.asVec[TE])
        // }

        // Foreach(rows * cols by 1 par inWidth){ i => 
        //   outbuf(i) = fifooutraw.deq()
        // }

      }
      outdram store outbuf
    }

    val got = getMem(outdram).reshape(rows,cols)
    printMatrix(got, "Got: ")
//    val gold = Array[TE](0, 0, 0, 0, 0, 1, 2, 3, 1, 4, 6, 7, 2, 7, 10, 11).reshape(rows,cols)
    // val gold = Array[TE](0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 7, 0, 0, 10, 11).reshape(rows,cols)
    // printMatrix(gold, "Gold: ")
    // println(r"PASS: ${List.tabulate(2,2){(i,j) => gold(i+2,j+2) === got(i+2,j+2)}.flatten.reduce{_&&_}}")

//    assert(args(0).to[Bit]) // dummy assert

  }
}

// class AetherB2B1_8_bulk extends AetherlingB2B_bulk[_8,_8,_9]("b2b", 1, 4, 4, 1)
// class AetherB2B2_8_bulk extends AetherlingB2B_bulk[_16,_8,_9]("b2b", 2, 4, 4, 1)
// class AetherB2B4_8_bulk extends AetherlingB2B_bulk[_32,_8,_9]("b2b", 4, 4, 4, 1)
// class AetherB2B8_8_bulk extends AetherlingB2B_bulk[_64,_8,_9]("b2b", 8, 4, 4, 1)
class AetherB2B1_32_bulk extends AetherlingB2B_bulk[_32,_32,_25]("b2b", 1, 1920, 1080,1)
class AetherB2B2_32_bulk extends AetherlingB2B_bulk[_64,_32,_25]("b2b", 2, 1920, 1080,1)
class AetherB2B4_32_bulk extends AetherlingB2B_bulk[_128,_32,_25]("b2b", 4, 1920, 1080,1)
class AetherB2B8_32_bulk extends AetherlingB2B_bulk[_256,_32,_25]("b2b", 8, 1920, 1080,1)

@spatial abstract class AetherlingB2B_bulk[B <: INT[_], X <: INT[_], Q <: INT[_]](alg: java.lang.String, inWidth: scala.Int, cols: scala.Int, rows: scala.Int, inp_scalar: scala.Int = 5)(implicit tev: FixPt[FALSE,B,_0], tev2: FixPt[FALSE,X,_0], tev3: FixPt[FALSE,Q,_7], tev4: FixPt[FALSE,X,_7]) extends SpatialTest {
  type TI = FixPt[FALSE,B,_0]
  type TE = FixPt[FALSE,X,_0]
  type FRAC = FixPt[FALSE,Q,_7]
  @streamstruct case class BBOX_IN(payload: TI)
  @streamstruct case class BBOX_OUT(payload: TI)

  def main(args: Array[String]): Unit = {
    val lb_rows = 4
    val normalize = 16
    val pad_size = 2
    val pad_value = 0

    val data = (0::rows, 0::cols){(i,j) => (i * rows + j + 1).to[TE]}.flatten
    val dram = DRAM[TE](rows * cols)
    val outdram = DRAM[TE](rows * cols)
    setMem(dram, data)

    val inStream = StreamIn[TI](AxiStream256Bus(0,0))
    val outStream = StreamOut[TI](AxiStream256Bus(0,0))
    def pad_aware_select(abs_i: Int, abs_j: Int, lb: SRAM2[TE]): TE = {
//        if (abs_i < 0 || abs_j < 0) pad_value.to[TE] else lb(abs_i % rows, abs_j)
      lb.__read(Seq(abs_i % lb_rows, abs_j), Set(!(abs_i < 0 || abs_j < 0)))
    }
    // Define bbox outside of Accel



    Accel {
      val outbuf = SRAM[TE](rows*cols)
      Stream {
        // Simulate instream
        val fifoinraw = FIFO[TE](lb_rows * cols)
        val fifoinpacked = FIFO[TI](lb_rows * cols)
        val fifooutraw = FIFO[TE](lb_rows * cols)
        Foreach(rows by 1, cols by inWidth){ (i,j) =>
          val els = List.tabulate(inWidth){k => ((inp_scalar * (1 + (i*cols + j + k))) % 256).to[TE]} 
          fifoinpacked.enq(Vec.ZeroFirst(els:_*).asPacked[TI])
        }

        // Simulate outstream

        /** DROP IN BBOX CODE */
          Pipe {
            val cstep = scala.math.min(cols, inWidth)
            val rstep = Helper2.ifThenElse[scala.Int](inWidth, 8, cols, 4, 2, 1)
            val fifooutpacked = FIFO[TI](inWidth*3)
            val kernel1 = List(1.to[TE],2.to[TE],1.to[TE],2.to[TE],4.to[TE],2.to[TE],1.to[TE],2.to[TE],1.to[TE])
            val kernel2 = List(1.to[TE],2.to[TE],4.to[TE],1.to[TE])
            val normalize2 = 8
            'SAMPLER_BOX.Pipe.II(1).Foreach(rows by rstep, cols by cstep) { (i, j) =>
            val in = inStream.value
            val lb = SRAM[TE](lb_rows, cols).forcebank(N = Seq(lb_rows, Helper2.ifThenElse[scala.Int](cols, 4, 0, 0, cols, inWidth + 2)), B = Seq(1, 1), alpha = Seq(1, 1))
            val lb2 = SRAM[TE](lb_rows, cols).forcebank(N = Seq(lb_rows, Helper2.ifThenElse[scala.Int](cols, 4, 0, 0, cols, inWidth + 2)), B = Seq(1, 1), alpha = Seq(1, 1))
            val newdata = in.asVec[TE]
            List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val wrRow = (i + inst_ofs_row) % lb_rows //oneHotMux(Seq.tabulate(lb_rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(lb_rows) { ii => (((ii % lb_rows) + lb_rows) % lb_rows).to[Int] })
              lb(wrRow, j + inst_ofs_col) = newdata(inst)
            }
            retimeGate()
            val conv1_in = List.tabulate(rstep + 2, cstep + 2) { (ii, jj) =>
              val rdrow = i + rstep - 1 - ii
              val rdcol = j + cstep - 1 - jj
              pad_aware_select(rdrow, rdcol, lb)
            }
            val kernel1_elems = List.tabulate(3, 3) { (ii, jj) => kernel1(ii * 3 + jj).to[TE] }.flatten
            val conv1_out = List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val data_elems = List.tabulate(3, 3) { (ii, jj) => conv1_in(ii + inst_ofs_row)(jj + inst_ofs_col) }.flatten
              (data_elems.zip(kernel1_elems).map { case (a, b) => a *! b }.reduceTree {
                _ + _
              }.to[FRAC] * (1.0 / normalize).to[FRAC]).to[TE]
            }.reverse
            retimeGate()
            List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val wrRow = (i + inst_ofs_row) % lb_rows //oneHotMux(Seq.tabulate(lb_rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(lb_rows) { ii => (((ii % lb_rows) + lb_rows) % lb_rows).to[Int] })
              lb2(wrRow, j + inst_ofs_col) = conv1_out(inst)
            }
            retimeGate()
            val conv2_in = List.tabulate(rstep + 1, cstep + 1) { (ii, jj) =>
              val rdrow = i + rstep - 1 - ii
              val rdcol = j + cstep - 1 - jj
              pad_aware_select(rdrow, rdcol, lb2)
            }
            val kernel2_elems = List.tabulate(2, 2) { (ii, jj) => kernel2(ii * 2 + jj).to[TE] }.flatten
            val b2bresults = List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val data_elems = List.tabulate(2, 2) { (ii, jj) => conv2_in(ii + inst_ofs_row)(jj + inst_ofs_col) }.flatten
              (data_elems.zip(kernel2_elems).map { case (a, b) => a *! b }.reduceTree {
                _ + _
              }.to[FRAC] * (1.0 / normalize2).to[FRAC]).to[TE]
            }.reverse
            val result = retime(3, Vec.ZeroFirst(b2bresults: _*).asPacked[TI])
            outStream := result
            // fifooutpacked.enq(result)
          }
        }

        // /** USE BBOX */
        // val fifooutpacked = FIFO[TI](lb_rows * cols)
        // val res = aetherling_box(BBOX_IN(fifoinpacked.deqInterface()))
        // fifooutpacked.enq(res.payload)

        // Foreach(rows by 1, cols by inWidth){ (i,j) => 
        //   fifooutraw.enqVec(res.asVec[TE])
        // }

        // Foreach(rows * cols by 1 par inWidth){ i => 
        //   outbuf(i) = fifooutraw.deq()
        // }

      }
      outdram store outbuf
    }

    val got = getMem(outdram).reshape(rows,cols)
    printMatrix(got, "Got: ")
//    val gold = Array[TE](0, 0, 0, 0, 0, 1, 2, 3, 1, 4, 6, 7, 2, 7, 10, 11).reshape(rows,cols)
    // val gold = Array[TE](0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 7, 0, 0, 10, 11).reshape(rows,cols)
    // printMatrix(gold, "Gold: ")
    // println(r"PASS: ${List.tabulate(2,2){(i,j) => gold(i+2,j+2) === got(i+2,j+2)}.flatten.reduce{_&&_}}")

//    assert(args(0).to[Bit]) // dummy assert

  }
}


// class AetherSharpen1_8_bulk extends AetherlingSharpen_bulk[_8,_8,_9]("sharpen", 1, 4, 4)
// class AetherSharpen2_8_bulk extends AetherlingSharpen_bulk[_16,_8,_9]("sharpen", 2, 4, 4)
// class AetherSharpen4_8_bulk extends AetherlingSharpen_bulk[_32,_8,_9]("sharpen", 4, 4, 4)
// class AetherSharpen8_8_bulk extends AetherlingSharpen_bulk[_64,_8,_9]("sharpen", 8, 4, 4)
class AetherSharpen1_32_bulk extends AetherlingSharpen_bulk[_32,_32,_25]("sharpen", 1, 1920, 1080)
class AetherSharpen2_32_bulk extends AetherlingSharpen_bulk[_64,_32,_25]("sharpen", 2, 1920, 1080)
class AetherSharpen4_32_bulk extends AetherlingSharpen_bulk[_128,_32,_25]("sharpen", 4, 1920, 1080)
class AetherSharpen8_32_bulk extends AetherlingSharpen_bulk[_256,_32,_25]("sharpen", 8, 1920, 1080)

@spatial abstract class AetherlingSharpen_bulk[B <: INT[_], X <: INT[_], Q <: INT[_]](alg: java.lang.String, inWidth: scala.Int, cols: scala.Int, rows: scala.Int, inp_scalar: scala.Int = 5)(implicit tev: FixPt[FALSE,B,_0], tev2: FixPt[FALSE,X,_0], tev3: FixPt[FALSE,Q,_7], tev4: FixPt[FALSE,X,_7]) extends SpatialTest {
  type TI = FixPt[FALSE,B,_0]
  type TE = FixPt[FALSE,X,_0]
  type FRAC = FixPt[FALSE,Q,_7]
  @streamstruct case class BBOX_IN(payload: TI)
  @streamstruct case class BBOX_OUT(payload: TI)
  def main(args: Array[String]): Unit = {
    val lb_rows = 4
    val normalize = 16
    val pad_size = 2
    val pad_value = 0

    val data = (0::rows, 0::cols){(i,j) => (i * rows + j + 1).to[TE]}.flatten
    val dram = DRAM[TE](rows * cols)
    val outdram = DRAM[TE](rows * cols)
    setMem(dram, data)

    val inStream = StreamIn[TI](AxiStream256Bus(0,0))
    val outStream = StreamOut[TI](AxiStream256Bus(0,0))
    def pad_aware_select(abs_i: Int, abs_j: Int, lb: SRAM2[TE]): TE = {
//        if (abs_i < 0 || abs_j < 0) pad_value.to[TE] else lb(abs_i % rows, abs_j)
      lb.__read(Seq(abs_i % lb_rows, abs_j), Set(!(abs_i < 0 || abs_j < 0)))
    }
    // Define bbox outside of Accel



    Accel {
      val outbuf = SRAM[TE](rows*cols)
      Stream {
        // Simulate instream
        val fifoinraw = FIFO[TE](lb_rows * cols)
        val fifoinpacked = FIFO[TI](lb_rows * cols)
        val fifooutraw = FIFO[TE](lb_rows * cols)
        Foreach(rows by 1, cols by inWidth){ (i,j) =>
          val els = List.tabulate(inWidth){k => ((inp_scalar * (1 + (i*cols + j + k))) % 256).to[TE]} 
          fifoinpacked.enq(Vec.ZeroFirst(els:_*).asPacked[TI])
        }

        // Simulate outstream

        /** DROP IN BBOX CODE */
          Pipe {
            val kernel = List(1.to[TE],2.to[TE],1.to[TE],2.to[TE],4.to[TE],2.to[TE],1.to[TE],2.to[TE],1.to[TE])
            val cstep = scala.math.min(cols, inWidth)
            val rstep = Helper2.ifThenElse[scala.Int](inWidth, 8, cols, 4, 2, 1)
            val fifooutpacked = FIFO[TI](inWidth*3)        
            'SAMPLER_BOX.Pipe.II(1).Foreach(rows by rstep, cols by cstep) { (i, j) =>
            val in = inStream.value
            val lb = SRAM[TE](lb_rows, cols).forcebank(N = Seq(lb_rows, Helper2.ifThenElse[scala.Int](cols, 4, 0, 0, cols, inWidth + 2)), B = Seq(1, 1), alpha = Seq(1, 1))
            val newdata = in.asVec[TE]
            List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val wrRow = (i + inst_ofs_row) % lb_rows //oneHotMux(Seq.tabulate(lb_rows) { ii => ii.to[Int] === (i + inst_ofs_row) }, Seq.tabulate(lb_rows) { ii => (((ii % lb_rows) + lb_rows) % lb_rows).to[Int] })
              lb(wrRow, j + inst_ofs_col) = newdata(inst)
            }
            retimeGate()
            val rd_data = List.tabulate(rstep + 2, cstep + 2) { (ii, jj) =>
              val rdrow = i + rstep - 1 - ii
              val rdcol = j + cstep - 1 - jj
              pad_aware_select(rdrow, rdcol, lb)
            }
            val kernel_elems = List.tabulate(3, 3) { (ii, jj) => kernel(ii * 3 + jj).to[TE] }.flatten
            val newresults = List.tabulate(inWidth) { inst =>
              val inst_ofs_row = inst / cols
              val inst_ofs_col = inst % cols
              val data_elems = List.tabulate(3, 3) { (ii, jj) => rd_data(ii + inst_ofs_row)(jj + inst_ofs_col) }.flatten
              val b = (data_elems.zip(kernel_elems).map { case (a, b) => a *! b }.reduceTree {
                _ + _
              }.to[FRAC] * (1.0 / normalize).to[FRAC]).to[TE]
              val a = rd_data(inst_ofs_row)(inst_ofs_col)
              val h = mux((a - b) > 15.to[TE] || (b - a) > 15.to[TE], a - b, 0.to[TE])
              a + (h.to[FRAC] * (1.0 / 4).to[FRAC]).to[TE]
            }.reverse
            val result = retime(3, Vec.ZeroFirst(newresults: _*).asPacked[TI])
            outStream := result
            // fifooutpacked.enq(result)
          }
        }

        // /** USE BBOX */
        // val fifooutpacked = FIFO[TI](lb_rows * cols)
        // val res = aetherling_box(BBOX_IN(fifoinpacked.deqInterface()))
        // fifooutpacked.enq(res.payload)

        // Foreach(rows by 1, cols by inWidth){ (i,j) => 
        //   fifooutraw.enqVec(res.payload.asVec[TE])
        // }

        // Foreach(rows * cols by 1 par inWidth){ i => 
        //   outbuf(i) = fifooutraw.deq()
        // }

      }
      outdram store outbuf
    }

    val got = getMem(outdram).reshape(rows,cols)
    printMatrix(got, "Got: ")
//    val gold = Array[TE](0, 0, 0, 0, 0, 1, 2, 3, 1, 4, 6, 7, 2, 7, 10, 11).reshape(rows,cols)
    // val gold = Array[TE](0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 7, 0, 0, 10, 11).reshape(rows,cols)
    // printMatrix(gold, "Gold: ")
    // println(r"PASS: ${List.tabulate(2,2){(i,j) => gold(i+2,j+2) === got(i+2,j+2)}.flatten.reduce{_&&_}}")

//    assert(args(0).to[Bit]) // dummy assert

  }
}
