import fault
import aetherling.helpers.fault_helpers as fault_helpers
from aetherling.space_time import *
from aetherling.space_time.reshape_st import DefineReshape_ST
import magma as m
import json


@cache_definition 
def Module_0() -> DefineCircuitKind:
    class _Module_0(Circuit):
        name = "Module_0"
        IO = ['I', In(ST_SSeq(4, ST_Int(8, False)).magma_repr()),'O', Out(ST_SSeq(4, ST_Int(8, False)).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_SSeq(4, ST_Int(8, False))]
        st_out_t = ST_SSeq(4, ST_Int(8, False))
        binary_op = False
        @classmethod
        def definition(cls):
            n6 = DefineAdd_1_S(DefineSSeqToSTuple(ST_Int(8, False), 4, has_valid=True),True)()
            wire(cls.I, n6.I)
            wire(cls.valid_up, n6.valid_up)
            n9 = DefineRemove_1_S(DefineSTupleToSSeq(ST_Int(8, False), 4, has_valid=True),True)()
            wire(n6.O, n9.I)
            wire(n6.valid_down, n9.valid_up)
            wire(n9.O, cls.O)
            wire(n9.valid_down, cls.valid_down)
    return _Module_0

@cache_definition 
def Module_1() -> DefineCircuitKind:
    class _Module_1(Circuit):
        name = "top"
        IO = ['I', In(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, False)))).magma_repr()),'O', Out(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, False)))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, False))))]
        st_out_t = ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, False))))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, False)))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n11 = DefineMap_T(2, 0, DefineMap_S(2, Module_0(),True))()
            wire(n1.O, n11.I)
            wire(n1.valid_down, n11.valid_up)
            n12 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, False)))), 1, has_valid=True)()
            wire(n11.O, n12.I)
            wire(n11.valid_down, n12.valid_up)
            n13 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, False)))), 1, has_valid=True)()
            wire(n12.O, n13.I)
            wire(n12.valid_down, n13.valid_up)
            n14 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, False)))), 1, has_valid=True)()
            wire(n13.O, n14.I)
            wire(n13.valid_down, n14.valid_up)
            wire(n14.O, cls.O)
            wire(n14.valid_down, cls.valid_down)
    return _Module_1

Main = Module_1

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/seq_and_stuple/seq_and_stuple_8 % 1thr.py")