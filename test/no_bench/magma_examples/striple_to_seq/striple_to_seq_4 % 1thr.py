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
        IO = ['I', In(ST_TSeq(4, 2, ST_SSeq(2, ST_SSeq(1, ST_Int(8, False)))).magma_repr()),'O', Out(ST_TSeq(4, 2, ST_SSeq(2, ST_SSeq(3, ST_Int(8, False)))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(4, 2, ST_SSeq(2, ST_SSeq(1, ST_Int(8, False))))]
        st_out_t = ST_TSeq(4, 2, ST_SSeq(2, ST_SSeq(3, ST_Int(8, False))))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(4, 2, ST_SSeq(2, ST_SSeq(1, ST_Int(8, False)))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n2 = DefineMap2_T(4, 2, DefineMap2_S(2, DefineMap2_S(1, DefineSSeqTupleCreator(ST_Int(8, False), has_valid=True),True),True))()
            wire(n1.O, n2.I0)
            wire(n1.O, n2.I1)
            wire(n1.valid_down & n1.valid_down, n2.valid_up)
            n12 = DefineMap2_T(4, 2, DefineMap2_S(2, DefineMap2_S(1, DefineSSeqTupleAppender(ST_Int(8, False), 2, has_valid=True),True),True))()
            wire(n2.O, n12.I0)
            wire(n1.O, n12.I1)
            wire(n2.valid_down & n1.valid_down, n12.valid_up)
            n28 = DefineMap_T(4, 2, DefineMap_S(2, DefineRemove_1_S(DefineSTupleToSSeq(ST_Int(8, False), 3, has_valid=True),True),True))()
            wire(n12.O, n28.I)
            wire(n12.valid_down, n28.valid_up)
            n29 = DefineFIFO(ST_TSeq(4, 2, ST_SSeq(2, ST_SSeq(3, ST_Int(8, False)))), 1, has_valid=True)()
            wire(n28.O, n29.I)
            wire(n28.valid_down, n29.valid_up)
            n30 = DefineFIFO(ST_TSeq(4, 2, ST_SSeq(2, ST_SSeq(3, ST_Int(8, False)))), 1, has_valid=True)()
            wire(n29.O, n30.I)
            wire(n29.valid_down, n30.valid_up)
            n31 = DefineFIFO(ST_TSeq(4, 2, ST_SSeq(2, ST_SSeq(3, ST_Int(8, False)))), 1, has_valid=True)()
            wire(n30.O, n31.I)
            wire(n30.valid_down, n31.valid_up)
            wire(n31.O, cls.O)
            wire(n31.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/striple_to_seq/striple_to_seq_4 % 1thr.py")