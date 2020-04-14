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
        IO = ['I', In(ST_SSeq(4, ST_Int(8, True)).magma_repr()),'O', Out(ST_SSeq(4, ST_Int(8, True)).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_SSeq(4, ST_Int(8, True))]
        st_out_t = ST_SSeq(4, ST_Int(8, True))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_SSeq(4, ST_Int(8, True)), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n4 = DefineMap_S(4, DefineAbs_Atom(True),True)()
            wire(n1.O, n4.I)
            wire(n1.valid_down, n4.valid_up)
            n5 = DefineFIFO(ST_SSeq(4, ST_Int(8, True)), 1, has_valid=True)()
            wire(n1.O, n5.I)
            wire(n1.valid_down, n5.valid_up)
            n6 = DefineMap2_S(4, DefineAtomTupleCreator(ST_Int(8, True), ST_Int(8, True), has_valid=True),True)()
            wire(n4.O, n6.I0)
            wire(n5.O, n6.I1)
            wire(n4.valid_down & n5.valid_down, n6.valid_up)
            n12 = DefineMap_S(4, DefineAdd_Atom(True),True)()
            wire(n6.O, n12.I)
            wire(n6.valid_down, n12.valid_up)
            n13 = DefineFIFO(ST_SSeq(4, ST_Int(8, True)), 1, has_valid=True)()
            wire(n12.O, n13.I)
            wire(n12.valid_down, n13.valid_up)
            n14 = DefineFIFO(ST_SSeq(4, ST_Int(8, True)), 1, has_valid=True)()
            wire(n13.O, n14.I)
            wire(n13.valid_down, n14.valid_up)
            n15 = DefineFIFO(ST_SSeq(4, ST_Int(8, True)), 1, has_valid=True)()
            wire(n14.O, n15.I)
            wire(n14.valid_down, n15.valid_up)
            wire(n15.O, cls.O)
            wire(n15.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/diamond_map/diamond_map_4 % 1thr.py")