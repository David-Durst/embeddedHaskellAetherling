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
        IO = ['I', In(ST_SSeq(8, ST_Int(16, False)).magma_repr()),'O', Out(ST_SSeq(1, ST_Int(16, False)).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_SSeq(8, ST_Int(16, False))]
        st_out_t = ST_SSeq(1, ST_Int(16, False))
        binary_op = False
        @classmethod
        def definition(cls):
            n19 = DefineConst(ST_SSeq(8, ST_Int(16, False)), ((1,2,3,4,2,1,2,3,),), has_valid=True, delay=1)()
            wire(cls.valid_up, n19.valid_up)
            n5 = DefineMap2_S(8, DefineAtomTupleCreator(ST_Int(16, False), ST_Int(16, False), has_valid=True),True)()
            wire(n19.O, n5.I0)
            wire(cls.I, n5.I1)
            wire(n19.valid_down & cls.valid_up, n5.valid_up)
            n11 = DefineMap_S(8, DefineMul_Atom(True),True)()
            wire(n5.O, n11.I)
            wire(n5.valid_down, n11.valid_up)
            n14 = DefineReduce_S(8, DefineAdd_Atom(False), has_valid=True)()
            wire(n11.O, n14.I)
            wire(n11.valid_down, n14.valid_up)
            wire(n14.O, cls.O)
            wire(n14.valid_down, cls.valid_down)
    return _Module_0

@cache_definition 
def Module_1() -> DefineCircuitKind:
    class _Module_1(Circuit):
        name = "top"
        IO = ['I', In(ST_TSeq(2, 0, ST_SSeq(8, ST_Int(16, False))).magma_repr()),'O', Out(ST_TSeq(2, 0, ST_SSeq(1, ST_Int(16, False))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(2, 0, ST_SSeq(8, ST_Int(16, False)))]
        st_out_t = ST_TSeq(2, 0, ST_SSeq(1, ST_Int(16, False)))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(8, ST_Int(16, False))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n15 = DefineMap_T(2, 0, Module_0())()
            wire(n1.O, n15.I)
            wire(n1.valid_down, n15.valid_up)
            n16 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(1, ST_Int(16, False))), 1, has_valid=True)()
            wire(n15.O, n16.I)
            wire(n15.valid_down, n16.valid_up)
            n17 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(1, ST_Int(16, False))), 1, has_valid=True)()
            wire(n16.O, n17.I)
            wire(n16.valid_down, n17.valid_up)
            n18 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(1, ST_Int(16, False))), 1, has_valid=True)()
            wire(n17.O, n18.I)
            wire(n17.valid_down, n18.valid_up)
            wire(n18.O, cls.O)
            wire(n18.valid_down, cls.valid_down)
    return _Module_1

Main = Module_1

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/tuple_reduce/tuple_reduce_1 % 1thr.py")