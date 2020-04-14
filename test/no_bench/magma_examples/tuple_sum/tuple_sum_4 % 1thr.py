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
        IO = ['I', In(ST_SSeq(4, ST_Int(8, False)).magma_repr()),'O', Out(ST_SSeq(4, ST_Int(8, False)).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_SSeq(4, ST_Int(8, False))]
        st_out_t = ST_SSeq(4, ST_Int(8, False))
        binary_op = False
        @classmethod
        def definition(cls):
            n14 = DefineConst(ST_SSeq(4, ST_Int(8, False)), ((1,2,3,4,),), has_valid=True, delay=1)()
            wire(cls.valid_up, n14.valid_up)
            n2 = DefineFIFO(ST_SSeq(4, ST_Int(8, False)), 1, has_valid=True)()
            wire(cls.I, n2.I)
            wire(cls.valid_up, n2.valid_up)
            n4 = DefineMap2_S(4, DefineAtomTupleCreator(ST_Int(8, False), ST_Int(8, False), has_valid=True),True)()
            wire(n14.O, n4.I0)
            wire(n2.O, n4.I1)
            wire(n14.valid_down & n2.valid_down, n4.valid_up)
            n10 = DefineMap_S(4, DefineAdd_Atom(True),True)()
            wire(n4.O, n10.I)
            wire(n4.valid_down, n10.valid_up)
            n11 = DefineFIFO(ST_SSeq(4, ST_Int(8, False)), 1, has_valid=True)()
            wire(n10.O, n11.I)
            wire(n10.valid_down, n11.valid_up)
            n12 = DefineFIFO(ST_SSeq(4, ST_Int(8, False)), 1, has_valid=True)()
            wire(n11.O, n12.I)
            wire(n11.valid_down, n12.valid_up)
            n13 = DefineFIFO(ST_SSeq(4, ST_Int(8, False)), 1, has_valid=True)()
            wire(n12.O, n13.I)
            wire(n12.valid_down, n13.valid_up)
            wire(n13.O, cls.O)
            wire(n13.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/tuple_sum/tuple_sum_4 % 1thr.py")