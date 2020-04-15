import fault
import aetherling.helpers.fault_helpers as fault_helpers
from aetherling.space_time import *
from aetherling.space_time.reshape_st import DefineReshape_ST
import magma as m
import json


@cache_definition 
def Module_0() -> DefineCircuitKind:
    class _Module_0(Circuit):
        name = "top"
        IO = ['I', In(ST_TSeq(8, 16, ST_SSeq(1, ST_Int(8, False))).magma_repr()),'O', Out(ST_TSeq(8, 16, ST_SSeq(3, ST_Int(8, False))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(8, 16, ST_SSeq(1, ST_Int(8, False)))]
        st_out_t = ST_TSeq(8, 16, ST_SSeq(3, ST_Int(8, False)))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(8, 16, ST_SSeq(1, ST_Int(8, False))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n2 = DefineMap2_T(8, 16, DefineMap2_S(1, DefineSSeqTupleCreator(ST_Int(8, False), has_valid=True),True))()
            wire(n1.O, n2.I0)
            wire(n1.O, n2.I1)
            wire(n1.valid_down & n1.valid_down, n2.valid_up)
            n9 = DefineMap2_T(8, 16, DefineMap2_S(1, DefineSSeqTupleAppender(ST_Int(8, False), 2, has_valid=True),True))()
            wire(n2.O, n9.I0)
            wire(n1.O, n9.I1)
            wire(n2.valid_down & n1.valid_down, n9.valid_up)
            n20 = DefineMap_T(8, 16, DefineRemove_1_S(DefineSTupleToSSeq(ST_Int(8, False), 3, has_valid=True),True))()
            wire(n9.O, n20.I)
            wire(n9.valid_down, n20.valid_up)
            n21 = DefineFIFO(ST_TSeq(8, 16, ST_SSeq(3, ST_Int(8, False))), 1, has_valid=True)()
            wire(n20.O, n21.I)
            wire(n20.valid_down, n21.valid_up)
            n22 = DefineFIFO(ST_TSeq(8, 16, ST_SSeq(3, ST_Int(8, False))), 1, has_valid=True)()
            wire(n21.O, n22.I)
            wire(n21.valid_down, n22.valid_up)
            n23 = DefineFIFO(ST_TSeq(8, 16, ST_SSeq(3, ST_Int(8, False))), 1, has_valid=True)()
            wire(n22.O, n23.I)
            wire(n22.valid_down, n23.valid_up)
            wire(n23.O, cls.O)
            wire(n23.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/striple_to_seq/striple_to_seq_1 % 1thr.py")