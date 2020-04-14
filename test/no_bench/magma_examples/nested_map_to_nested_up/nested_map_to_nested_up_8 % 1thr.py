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
        IO = ['I', In(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(1, ST_Int(8, True)))).magma_repr()),'O', Out(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, True)))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(1, ST_Int(8, True))))]
        st_out_t = ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, True))))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(1, ST_Int(8, True)))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n8 = DefineMap_T(2, 0, DefineMap_S(2, DefineMap_S(1, DefineAbs_Atom(True),True),True))()
            wire(n1.O, n8.I)
            wire(n1.valid_down, n8.valid_up)
            n13 = DefineMap_T(2, 0, DefineMap_S(2, DefineUp_S(4, ST_Int(8, True), has_valid=True),True))()
            wire(n8.O, n13.I)
            wire(n8.valid_down, n13.valid_up)
            n14 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, True)))), 1, has_valid=True)()
            wire(n13.O, n14.I)
            wire(n13.valid_down, n14.valid_up)
            n15 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, True)))), 1, has_valid=True)()
            wire(n14.O, n15.I)
            wire(n14.valid_down, n15.valid_up)
            n16 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, True)))), 1, has_valid=True)()
            wire(n15.O, n16.I)
            wire(n15.valid_down, n16.valid_up)
            wire(n16.O, cls.O)
            wire(n16.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/nested_map_to_nested_up/nested_map_to_nested_up_8 % 1thr.py")