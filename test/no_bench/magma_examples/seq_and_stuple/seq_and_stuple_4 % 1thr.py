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
            n5 = DefineAdd_1_S(DefineSSeqToSTuple(ST_Int(8, False), 4, has_valid=True),True)()
            wire(cls.I, n5.I)
            wire(cls.valid_up, n5.valid_up)
            n8 = DefineRemove_1_S(DefineSTupleToSSeq(ST_Int(8, False), 4, has_valid=True),True)()
            wire(n5.O, n8.I)
            wire(n5.valid_down, n8.valid_up)
            wire(n8.O, cls.O)
            wire(n8.valid_down, cls.valid_down)
    return _Module_0

@cache_definition 
def Module_1() -> DefineCircuitKind:
    class _Module_1(Circuit):
        name = "top"
        IO = ['I', In(ST_TSeq(4, 0, ST_SSeq(4, ST_Int(8, False))).magma_repr()),'O', Out(ST_TSeq(4, 0, ST_SSeq(4, ST_Int(8, False))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(4, 0, ST_SSeq(4, ST_Int(8, False)))]
        st_out_t = ST_TSeq(4, 0, ST_SSeq(4, ST_Int(8, False)))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(4, 0, ST_SSeq(4, ST_Int(8, False))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n9 = DefineMap_T(4, 0, Module_0())()
            wire(n1.O, n9.I)
            wire(n1.valid_down, n9.valid_up)
            n10 = DefineFIFO(ST_TSeq(4, 0, ST_SSeq(4, ST_Int(8, False))), 1, has_valid=True)()
            wire(n9.O, n10.I)
            wire(n9.valid_down, n10.valid_up)
            n11 = DefineFIFO(ST_TSeq(4, 0, ST_SSeq(4, ST_Int(8, False))), 1, has_valid=True)()
            wire(n10.O, n11.I)
            wire(n10.valid_down, n11.valid_up)
            n12 = DefineFIFO(ST_TSeq(4, 0, ST_SSeq(4, ST_Int(8, False))), 1, has_valid=True)()
            wire(n11.O, n12.I)
            wire(n11.valid_down, n12.valid_up)
            wire(n12.O, cls.O)
            wire(n12.valid_down, cls.valid_down)
    return _Module_1

Main = Module_1

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/seq_and_stuple/seq_and_stuple_4 % 1thr.py")