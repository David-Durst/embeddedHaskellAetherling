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
        IO = ['I', In(ST_TSeq(4, 0, ST_Int(8, True)).magma_repr()),'O', Out(ST_TSeq(4, 0, ST_Int(8, True)).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(4, 0, ST_Int(8, True))]
        st_out_t = ST_TSeq(4, 0, ST_Int(8, True))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(4, 0, ST_Int(8, True)), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n4 = DefineMap_T(4, 0, DefineAbs_Atom(True))()
            wire(n1.O, n4.I)
            wire(n1.valid_down, n4.valid_up)
            n5 = DefineFIFO(ST_TSeq(4, 0, ST_Int(8, True)), 1, has_valid=True)()
            wire(n4.O, n5.I)
            wire(n4.valid_down, n5.valid_up)
            n6 = DefineFIFO(ST_TSeq(4, 0, ST_Int(8, True)), 1, has_valid=True)()
            wire(n5.O, n6.I)
            wire(n5.valid_down, n6.valid_up)
            n7 = DefineFIFO(ST_TSeq(4, 0, ST_Int(8, True)), 1, has_valid=True)()
            wire(n6.O, n7.I)
            wire(n6.valid_down, n7.valid_up)
            wire(n7.O, cls.O)
            wire(n7.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/single_map_underutil/single_map_underutil_1 % 1thr.py")