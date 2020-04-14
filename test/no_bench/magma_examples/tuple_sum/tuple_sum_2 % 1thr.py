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
        IO = ['I', In(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))).magma_repr()),'O', Out(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False)))]
        st_out_t = ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False)))
        binary_op = False
        @classmethod
        def definition(cls):
            n19 = DefineConst(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))), ((1,2,),(3,4,),), has_valid=True, delay=1)()
            wire(cls.valid_up, n19.valid_up)
            n2 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))), 1, has_valid=True)()
            wire(cls.I, n2.I)
            wire(cls.valid_up, n2.valid_up)
            n4 = DefineMap2_T(2, 0, DefineMap2_S(2, DefineAtomTupleCreator(ST_Int(8, False), ST_Int(8, False), has_valid=True),True))()
            wire(n19.O, n4.I0)
            wire(n2.O, n4.I1)
            wire(n19.valid_down & n2.valid_down, n4.valid_up)
            n15 = DefineMap_T(2, 0, DefineMap_S(2, DefineAdd_Atom(True),True))()
            wire(n4.O, n15.I)
            wire(n4.valid_down, n15.valid_up)
            n16 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))), 1, has_valid=True)()
            wire(n15.O, n16.I)
            wire(n15.valid_down, n16.valid_up)
            n17 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))), 1, has_valid=True)()
            wire(n16.O, n17.I)
            wire(n16.valid_down, n17.valid_up)
            n18 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))), 1, has_valid=True)()
            wire(n17.O, n18.I)
            wire(n17.valid_down, n18.valid_up)
            wire(n18.O, cls.O)
            wire(n18.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/tuple_sum/tuple_sum_2 % 1thr.py")