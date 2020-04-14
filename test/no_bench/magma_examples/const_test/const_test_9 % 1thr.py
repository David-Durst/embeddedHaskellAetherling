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
        IO = ['O', Out(ST_SSeq(9, ST_Int(8, False)).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_out_t = ST_SSeq(9, ST_Int(8, False))
        binary_op = False
        @classmethod
        def definition(cls):
            n4 = DefineConst(ST_SSeq(9, ST_Int(8, False)), ((0,1,2,3,4,5,6,7,8,),), has_valid=True, delay=1)()
            wire(cls.valid_up, n4.valid_up)
            n2 = DefineFIFO(ST_SSeq(9, ST_Int(8, False)), 1, has_valid=True)()
            wire(n4.O, n2.I)
            wire(n4.valid_down, n2.valid_up)
            n3 = DefineFIFO(ST_SSeq(9, ST_Int(8, False)), 1, has_valid=True)()
            wire(n2.O, n3.I)
            wire(n2.valid_down, n3.valid_up)
            wire(n3.O, cls.O)
            wire(n3.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/const_test/const_test_9 % 1thr.py")