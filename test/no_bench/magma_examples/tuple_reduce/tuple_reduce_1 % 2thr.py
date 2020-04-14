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
        IO = ['I', In(ST_TSeq(2, 0, ST_SSeq(4, ST_Int(16, False))).magma_repr()),'O', Out(ST_TSeq(1, 1, ST_Int(16, False)).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(2, 0, ST_SSeq(4, ST_Int(16, False)))]
        st_out_t = ST_TSeq(1, 1, ST_Int(16, False))
        binary_op = False
        @classmethod
        def definition(cls):
            n30 = DefineConst(ST_TSeq(2, 0, ST_SSeq(4, ST_Int(16, False))), ((1,2,3,4,),(2,1,2,3,),), has_valid=True, delay=1)()
            wire(cls.valid_up, n30.valid_up)
            n5 = DefineMap2_T(2, 0, DefineMap2_S(4, DefineAtomTupleCreator(ST_Int(16, False), ST_Int(16, False), has_valid=True),True))()
            wire(n30.O, n5.I0)
            wire(cls.I, n5.I1)
            wire(n30.valid_down & cls.valid_up, n5.valid_up)
            n16 = DefineMap_T(2, 0, DefineMap_S(4, DefineMul_Atom(True),True))()
            wire(n5.O, n16.I)
            wire(n5.valid_down, n16.valid_up)
            n21 = DefineMap_T(2, 0, DefineReduce_S(4, DefineAdd_Atom(False), has_valid=True))()
            wire(n16.O, n21.I)
            wire(n16.valid_down, n21.valid_up)
            n24 = DefineReduce_T(2, 0, DefineMap_S(1, DefineAdd_Atom(False),False))()
            wire(n21.O, n24.I)
            wire(n21.valid_down, n24.valid_up)
            n25 = DefineReshape_ST(ST_TSeq(1, 1, ST_SSeq(1, ST_Int(16, False))), ST_TSeq(1, 1, ST_Int(16, False)), has_valid=True)()
            wire(n24.O, n25.I)
            wire(n24.valid_down, n25.valid_up)
            wire(n25.O, cls.O)
            wire(n25.valid_down, cls.valid_down)
    return _Module_0

@cache_definition 
def Module_1() -> DefineCircuitKind:
    class _Module_1(Circuit):
        name = "top"
        IO = ['I', In(ST_TSeq(2, 0, ST_TSeq(2, 0, ST_SSeq(4, ST_Int(16, False)))).magma_repr()),'O', Out(ST_TSeq(2, 0, ST_TSeq(1, 1, ST_Int(16, False))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(2, 0, ST_TSeq(2, 0, ST_SSeq(4, ST_Int(16, False))))]
        st_out_t = ST_TSeq(2, 0, ST_TSeq(1, 1, ST_Int(16, False)))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(2, 0, ST_TSeq(2, 0, ST_SSeq(4, ST_Int(16, False)))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n26 = DefineMap_T(2, 0, Module_0())()
            wire(n1.O, n26.I)
            wire(n1.valid_down, n26.valid_up)
            n27 = DefineFIFO(ST_TSeq(2, 0, ST_TSeq(1, 1, ST_Int(16, False))), 1, has_valid=True)()
            wire(n26.O, n27.I)
            wire(n26.valid_down, n27.valid_up)
            n28 = DefineFIFO(ST_TSeq(2, 0, ST_TSeq(1, 1, ST_Int(16, False))), 1, has_valid=True)()
            wire(n27.O, n28.I)
            wire(n27.valid_down, n28.valid_up)
            n29 = DefineFIFO(ST_TSeq(2, 0, ST_TSeq(1, 1, ST_Int(16, False))), 1, has_valid=True)()
            wire(n28.O, n29.I)
            wire(n28.valid_down, n29.valid_up)
            wire(n29.O, cls.O)
            wire(n29.valid_down, cls.valid_down)
    return _Module_1

Main = Module_1

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/tuple_reduce/tuple_reduce_1 % 2thr.py")