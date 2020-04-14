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
        IO = ['I', In(ST_TSeq(2, 6, ST_TSeq(2, 0, ST_Int(8, True))).magma_repr()),'O', Out(ST_TSeq(4, 12, ST_Int(8, True)).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(2, 6, ST_TSeq(2, 0, ST_Int(8, True)))]
        st_out_t = ST_TSeq(4, 12, ST_Int(8, True))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(2, 6, ST_TSeq(2, 0, ST_Int(8, True))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n6 = DefineMap_T(2, 6, DefineMap_T(2, 0, DefineAbs_Atom(True)))()
            wire(n1.O, n6.I)
            wire(n1.valid_down, n6.valid_up)
            n7 = DefineReshape_ST(ST_TSeq(2, 6, ST_TSeq(2, 0, ST_Int(8, True))), ST_TSeq(4, 12, ST_Int(8, True)), has_valid=True)()
            wire(n6.O, n7.I)
            wire(n6.valid_down, n7.valid_up)
            n10 = DefineMap_T(4, 12, DefineAbs_Atom(True))()
            wire(n7.O, n10.I)
            wire(n7.valid_down, n10.valid_up)
            n11 = DefineFIFO(ST_TSeq(4, 12, ST_Int(8, True)), 1, has_valid=True)()
            wire(n10.O, n11.I)
            wire(n10.valid_down, n11.valid_up)
            n12 = DefineFIFO(ST_TSeq(4, 12, ST_Int(8, True)), 1, has_valid=True)()
            wire(n11.O, n12.I)
            wire(n11.valid_down, n12.valid_up)
            n13 = DefineFIFO(ST_TSeq(4, 12, ST_Int(8, True)), 1, has_valid=True)()
            wire(n12.O, n13.I)
            wire(n12.valid_down, n13.valid_up)
            wire(n13.O, cls.O)
            wire(n13.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/map_to_unpartition/map_to_unpartition_1 % 4thr.py")