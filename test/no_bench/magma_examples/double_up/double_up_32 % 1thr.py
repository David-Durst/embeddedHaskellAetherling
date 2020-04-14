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
        IO = ['I', In(ST_SSeq(2, ST_Int(8, False)).magma_repr()),'O', Out(ST_SSeq(32, ST_Int(8, False)).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_SSeq(2, ST_Int(8, False))]
        st_out_t = ST_SSeq(32, ST_Int(8, False))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_SSeq(2, ST_Int(8, False)), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n2 = DefinePartition_S(2, 1, ST_Int(8, False), has_valid=True)()
            wire(n1.O, n2.I)
            wire(n1.valid_down, n2.valid_up)
            n5 = DefineMap_S(2, DefineUp_S(4, ST_Int(8, False), has_valid=True),True)()
            wire(n2.O, n5.I)
            wire(n2.valid_down, n5.valid_up)
            n6 = DefineUnpartition_S(2, 4, ST_Int(8, False), has_valid=True)()
            wire(n5.O, n6.I)
            wire(n5.valid_down, n6.valid_up)
            n7 = DefinePartition_S(1, 8, ST_Int(8, False), has_valid=True)()
            wire(n6.O, n7.I)
            wire(n6.valid_down, n7.valid_up)
            n8 = DefineUp_S(4, ST_SSeq(8, ST_Int(8, False)), has_valid=True)()
            wire(n7.O, n8.I)
            wire(n7.valid_down, n8.valid_up)
            n9 = DefineUnpartition_S(4, 8, ST_Int(8, False), has_valid=True)()
            wire(n8.O, n9.I)
            wire(n8.valid_down, n9.valid_up)
            n10 = DefineFIFO(ST_SSeq(32, ST_Int(8, False)), 1, has_valid=True)()
            wire(n9.O, n10.I)
            wire(n9.valid_down, n10.valid_up)
            n11 = DefineFIFO(ST_SSeq(32, ST_Int(8, False)), 1, has_valid=True)()
            wire(n10.O, n11.I)
            wire(n10.valid_down, n11.valid_up)
            n12 = DefineFIFO(ST_SSeq(32, ST_Int(8, False)), 1, has_valid=True)()
            wire(n11.O, n12.I)
            wire(n11.valid_down, n12.valid_up)
            wire(n12.O, cls.O)
            wire(n12.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/double_up/double_up_32 % 1thr.py")