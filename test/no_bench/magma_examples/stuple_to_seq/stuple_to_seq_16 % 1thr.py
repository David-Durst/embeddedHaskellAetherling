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
        IO = ['I', In(ST_SSeq(4, ST_SSeq(1, ST_SSeq_Tuple(4, ST_Int(8, False)))).magma_repr()),'O', Out(ST_SSeq(4, ST_SSeq(4, ST_Int(8, False))).magma_repr())] + ClockInterface(has_ce=False,has_reset=False) + valid_ports
        st_in_t = [ST_SSeq(4, ST_SSeq(1, ST_SSeq_Tuple(4, ST_Int(8, False))))]
        st_out_t = ST_SSeq(4, ST_SSeq(4, ST_Int(8, False)))
        binary_op = False
        @classmethod
        def definition(cls):
            n1 = DefineFIFO(ST_SSeq(4, ST_SSeq(1, ST_SSeq_Tuple(4, ST_Int(8, False)))), 1, has_valid=True)()
            wire(cls.I, n1.I)
            wire(cls.valid_up, n1.valid_up)
            n6 = DefineMap_S(4, DefineRemove_1_S(DefineSTupleToSSeq(ST_Int(8, False), 4, has_valid=True),True),True)()
            wire(n1.O, n6.I)
            wire(n1.valid_down, n6.valid_up)
            n7 = DefineFIFO(ST_SSeq(4, ST_SSeq(4, ST_Int(8, False))), 1, has_valid=True)()
            wire(n6.O, n7.I)
            wire(n6.valid_down, n7.valid_up)
            n8 = DefineFIFO(ST_SSeq(4, ST_SSeq(4, ST_Int(8, False))), 1, has_valid=True)()
            wire(n7.O, n8.I)
            wire(n7.valid_down, n8.valid_up)
            n9 = DefineFIFO(ST_SSeq(4, ST_SSeq(4, ST_Int(8, False))), 1, has_valid=True)()
            wire(n8.O, n9.I)
            wire(n8.valid_down, n9.valid_up)
            wire(n9.O, cls.O)
            wire(n9.valid_down, cls.valid_down)
    return _Module_0

Main = Module_0

fault_helpers.compile(Main(), "v./home/durst/dev/embeddedHaskellAetherling//test/no_bench/magma_examples/stuple_to_seq/stuple_to_seq_16 % 1thr.py")