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
        IO = ['I', In(ST_TSeq(1, 1, ST_SSeq(1, ST_Int(8, False))).magma_repr()),'O', Out(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(1, 1, ST_SSeq(1, ST_Int(8, False)))]
        st_out_t = ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False)))
        binary_op = False
        @classmethod
        def definition(cls):
            n4 = DefineUp_T(2, 0, ST_SSeq(1, ST_Int(8, False)), has_valid=True)()
            wire(cls.I, n4.I)
            wire(cls.valid_up, n4.valid_up)
            n7 = DefineMap_T(2, 0, DefineUp_S(2, ST_Int(8, False), has_valid=True))()
            wire(n4.O, n7.I)
            wire(n4.valid_down, n7.valid_up)
            wire(n7.O, cls.O)
            wire(n7.valid_down, cls.valid_down)
    return _Module_0

@cache_definition 
def Module_1() -> DefineCircuitKind:
    class _Module_1(Circuit):
        name = "top"
        IO = ['I', In(ST_TSeq(2, 14, ST_SSeq(1, ST_Int(8, False))).magma_repr()),'O', Out(ST_TSeq(16, 0, ST_SSeq(2, ST_Int(8, False))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(2, 14, ST_SSeq(1, ST_Int(8, False)))]
        st_out_t = ST_TSeq(16, 0, ST_SSeq(2, ST_Int(8, False)))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(2, 14, ST_SSeq(1, ST_Int(8, False))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n2 = DefineReshape_ST(ST_TSeq(2, 14, ST_SSeq(1, ST_Int(8, False))), ST_TSeq(2, 6, ST_TSeq(1, 1, ST_SSeq(1, ST_Int(8, False)))), has_valid=True)()
            wire(n1.O, n2.I)
            wire(n1.valid_down, n2.valid_up)
            n8 = DefineMap_T(2, 6, Module_0())()
            wire(n2.O, n8.I)
            wire(n2.valid_down, n8.valid_up)
            n9 = DefineReshape_ST(ST_TSeq(2, 6, ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False)))), ST_TSeq(4, 12, ST_SSeq(2, ST_Int(8, False))), has_valid=True)()
            wire(n8.O, n9.I)
            wire(n8.valid_down, n9.valid_up)
            n10 = DefineReshape_ST(ST_TSeq(4, 12, ST_SSeq(2, ST_Int(8, False))), ST_TSeq(1, 3, ST_TSeq(4, 0, ST_SSeq(2, ST_Int(8, False)))), has_valid=True)()
            wire(n9.O, n10.I)
            wire(n9.valid_down, n10.valid_up)
            n11 = DefineUp_T(4, 0, ST_TSeq(4, 0, ST_SSeq(2, ST_Int(8, False))), has_valid=True)()
            wire(n10.O, n11.I)
            wire(n10.valid_down, n11.valid_up)
            n12 = DefineReshape_ST(ST_TSeq(4, 0, ST_TSeq(4, 0, ST_SSeq(2, ST_Int(8, False)))), ST_TSeq(16, 0, ST_SSeq(2, ST_Int(8, False))), has_valid=True)()
            wire(n11.O, n12.I)
            wire(n11.valid_down, n12.valid_up)
            n13 = DefineFIFO(ST_TSeq(16, 0, ST_SSeq(2, ST_Int(8, False))), 1, has_valid=True)()
            wire(n12.O, n13.I)
            wire(n12.valid_down, n13.valid_up)
            n14 = DefineFIFO(ST_TSeq(16, 0, ST_SSeq(2, ST_Int(8, False))), 1, has_valid=True)()
            wire(n13.O, n14.I)
            wire(n13.valid_down, n14.valid_up)
            n15 = DefineFIFO(ST_TSeq(16, 0, ST_SSeq(2, ST_Int(8, False))), 1, has_valid=True)()
            wire(n14.O, n15.I)
            wire(n14.valid_down, n15.valid_up)
            wire(n15.O, cls.O)
            wire(n15.valid_down, cls.valid_down)
    return _Module_1

Main = Module_1

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/double_up/double_up_2 % 1thr.py")