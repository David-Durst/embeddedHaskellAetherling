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
        IO = ['I', In(ST_TSeq(2, 0, ST_SSeq(8, ST_Int(8, False))).magma_repr()),'O', Out(ST_TSeq(1, 1, ST_Int(8, False)).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(2, 0, ST_SSeq(8, ST_Int(8, False)))]
        st_out_t = ST_TSeq(1, 1, ST_Int(8, False))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(8, ST_Int(8, False))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n4 = DefineMap_T(2, 0, DefinePartition_S(2, 4, ST_Int(8, False), has_valid=True))()
            wire(n1.O, n4.I)
            wire(n1.valid_down, n4.valid_up)
            n5 = DefineDown_T(2, 0, 0, ST_SSeq(2, ST_SSeq(4, ST_Int(8, False))), has_valid=True)()
            wire(n4.O, n5.I)
            wire(n4.valid_down, n5.valid_up)
            n8 = DefineMap_T(1, 1, DefineDown_S(2, 0, ST_SSeq(4, ST_Int(8, False)), has_valid=True))()
            wire(n5.O, n8.I)
            wire(n5.valid_down, n8.valid_up)
            n9 = DefineReshape_ST(ST_TSeq(1, 1, ST_SSeq(1, ST_SSeq(4, ST_Int(8, False)))), ST_TSeq(1, 1, ST_SSeq(4, ST_Int(8, False))), has_valid=True)()
            wire(n8.O, n9.I)
            wire(n8.valid_down, n9.valid_up)
            n10 = DefineReshape_ST(ST_TSeq(1, 1, ST_SSeq(4, ST_Int(8, False))), ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))), has_valid=True)()
            wire(n9.O, n10.I)
            wire(n9.valid_down, n10.valid_up)
            n11 = DefineDown_T(2, 0, 0, ST_SSeq(2, ST_Int(8, False)), has_valid=True)()
            wire(n10.O, n11.I)
            wire(n10.valid_down, n11.valid_up)
            n14 = DefineMap_T(1, 1, DefineDown_S(2, 0, ST_Int(8, False), has_valid=True))()
            wire(n11.O, n14.I)
            wire(n11.valid_down, n14.valid_up)
            n15 = DefineReshape_ST(ST_TSeq(1, 1, ST_SSeq(1, ST_Int(8, False))), ST_TSeq(1, 1, ST_Int(8, False)), has_valid=True)()
            wire(n14.O, n15.I)
            wire(n14.valid_down, n15.valid_up)
            n16 = DefineFIFO(ST_TSeq(1, 1, ST_Int(8, False)), 1, has_valid=True)()
            wire(n15.O, n16.I)
            wire(n15.valid_down, n16.valid_up)
            n17 = DefineFIFO(ST_TSeq(1, 1, ST_Int(8, False)), 1, has_valid=True)()
            wire(n16.O, n17.I)
            wire(n16.valid_down, n17.valid_up)
            n18 = DefineFIFO(ST_TSeq(1, 1, ST_Int(8, False)), 1, has_valid=True)()
            wire(n17.O, n18.I)
            wire(n17.valid_down, n18.valid_up)
            wire(n18.O, cls.O)
            wire(n18.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/down_over_nested_to_down_over_flattened/down_over_nested_to_down_over_flattened_1 % 2thr.py")