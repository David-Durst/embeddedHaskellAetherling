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
        IO = ['I', In(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, True))).magma_repr()),'O', Out(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, True))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, True)))]
        st_out_t = ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, True)))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, True))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n6 = DefineMap_T(2, 0, DefineMap_S(2, DefineAbs_Atom(True),True))()
            wire(n1.O, n6.I)
            wire(n1.valid_down, n6.valid_up)
            n7 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, True))), 1, has_valid=True)()
            wire(n1.O, n7.I)
            wire(n1.valid_down, n7.valid_up)
            n8 = DefineMap2_T(2, 0, DefineMap2_S(2, DefineAtomTupleCreator(ST_Int(8, True), ST_Int(8, True), has_valid=True),True))()
            wire(n6.O, n8.I0)
            wire(n7.O, n8.I1)
            wire(n6.valid_down & n7.valid_down, n8.valid_up)
            n19 = DefineMap_T(2, 0, DefineMap_S(2, DefineAdd_Atom(True),True))()
            wire(n8.O, n19.I)
            wire(n8.valid_down, n19.valid_up)
            n20 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, True))), 1, has_valid=True)()
            wire(n19.O, n20.I)
            wire(n19.valid_down, n20.valid_up)
            n21 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, True))), 1, has_valid=True)()
            wire(n20.O, n21.I)
            wire(n20.valid_down, n21.valid_up)
            n22 = DefineFIFO(ST_TSeq(2, 0, ST_SSeq(2, ST_Int(8, True))), 1, has_valid=True)()
            wire(n21.O, n22.I)
            wire(n21.valid_down, n22.valid_up)
            wire(n22.O, cls.O)
            wire(n22.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/diamond_map/diamond_map_2 % 1thr.py")