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
            n7 = DefineMap_T(4, 0, DefineAbs_Atom(True))()
            wire(n4.O, n7.I)
            wire(n4.valid_down, n7.valid_up)
            n8 = DefineFIFO(ST_TSeq(4, 0, ST_Int(8, True)), 1, has_valid=True)()
            wire(n7.O, n8.I)
            wire(n7.valid_down, n8.valid_up)
            n9 = DefineFIFO(ST_TSeq(4, 0, ST_Int(8, True)), 1, has_valid=True)()
            wire(n8.O, n9.I)
            wire(n8.valid_down, n9.valid_up)
            n10 = DefineFIFO(ST_TSeq(4, 0, ST_Int(8, True)), 1, has_valid=True)()
            wire(n9.O, n10.I)
            wire(n9.valid_down, n10.valid_up)
            wire(n10.O, cls.O)
            wire(n10.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/two_maps/two_maps_1 % 1thr.py")