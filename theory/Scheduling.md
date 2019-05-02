# Scheduling
The goal of this document is:
1. Define scheduling
1. Define how scheduling occurs
1. Define the relationship between scheduling and the auto-scheduler
1. Enumerate the rewrite rules that each operator in the sequence language must
   support in order to enable scheduling
   
# Scheduling Definition
Scheduling is converting all the operators in a program from sequence language
to space-time IR.
Scheduling is performed to target a specific `input_throughput` and `output_throughput`
as defined in [the basic theory document's throughput section.](Basic.md#throughput).
The target is specified using a **throughput factor s**.
Scheduling with factor **s** means produce a pipeline with `input_throughput` and
`output_throughput` that are **s** times smaller than the fully parallel pipelines
`input_throughput` and `output_throughput`.


Scheduling is then performed by converting `Seq`s to `TSeq`s
and `SSeq`s. Different throughput schedules are expressed by different
computations of `TSeq`s and `SSeq`s. Scheduling a program P with a target
throughput t is done by:
1. Let t_full be the throughput by of P when fully parallelized
1. Let t = t_full / s
1. Each `Seq n` is converted to `TSeq` and `SSeq` by:
    1. s == 1 - make all nested Seqs into SSeqs
    1. s > 1, s < n of top Seq - split top nested Seq into TSeq (s) (SSeq (n /
      s) inner) and make all inner Seqs into SSeqs
    1. S > 1, s > n of top Seq - make top `Seq` into `TSeq n` inner, schedule the inner `Seq` with s'=(n / s)
