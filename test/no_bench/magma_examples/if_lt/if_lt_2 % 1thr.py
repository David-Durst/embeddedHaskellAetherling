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
        IO = ['I', In(ST_Int(8, False).magma_repr()),'O', Out(ST_Int(8, False).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_Int(8, False)]
        st_out_t = ST_Int(8, False)
        binary_op = False
        @classmethod
        def definition(cls):
            n19 = DefineConst(ST_Int(8, False), (1,), has_valid=True, delay=1)()
            wire(cls.valid_up, n19.valid_up)
            n6 = DefineAtomTupleCreator(ST_Int(8, False), ST_Int(8, False), has_valid=True)()
            wire(cls.I, n6.I0)
            wire(n19.O, n6.I1)
            wire(cls.valid_up & n19.valid_down, n6.valid_up)
            n7 = DefineLt_Atom(True)()
            wire(n6.O, n7.I)
            wire(n6.valid_down, n7.valid_up)
            n8 = DefineConst(ST_Int(8, False), (3,), has_valid=True, delay=0)()
            wire(cls.valid_up, n8.valid_up)
            n9 = DefineConst(ST_Int(8, False), (2,), has_valid=True, delay=0)()
            wire(cls.valid_up, n9.valid_up)
            n10 = DefineAtomTupleCreator(ST_Int(8, False), ST_Int(8, False), has_valid=True)()
            wire(n8.O, n10.I0)
            wire(n9.O, n10.I1)
            wire(n8.valid_down & n9.valid_down, n10.valid_up)
            n11 = DefineFIFO(ST_Atom_Tuple(ST_Int(8, False), ST_Int(8, False)), 1, has_valid=True)()
            wire(n10.O, n11.I)
            wire(n10.valid_down, n11.valid_up)
            n12 = DefineAtomTupleCreator(ST_Bit(), ST_Atom_Tuple(ST_Int(8, False), ST_Int(8, False)), has_valid=True)()
            wire(n7.O, n12.I0)
            wire(n11.O, n12.I1)
            wire(n7.valid_down & n11.valid_down, n12.valid_up)
            n13 = DefineIf_Atom(ST_Int(8, False), True)()
            wire(n12.O, n13.I)
            wire(n12.valid_down, n13.valid_up)
            wire(n13.O, cls.O)
            wire(n13.valid_down, cls.valid_down)
    return _Module_0

@cache_definition 
def Module_1() -> DefineCircuitKind:
    class _Module_1(Circuit):
        name = "top"
        IO = ['I', In(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))).magma_repr()),'O', Out(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False)))]
        st_out_t = ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False)))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, False))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n15 = DefineMap_T(2, 0, DefineMap_S(2, Module_0(),True))()
            wire(n1.O, n15.I)
            wire(n1.valid_down, n15.valid_up)
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
    return _Module_1

Main = Module_1

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/if_lt/if_lt_2 % 1thr.py")