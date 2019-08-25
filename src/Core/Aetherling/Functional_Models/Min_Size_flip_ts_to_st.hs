-- | A functional model of the Flip_ts_to_st operator.
-- This computes the amount of storage and the delay clock cycles
-- necessary to implement the operator
-- It shows that the model is extremely inefficient to implement.
-- For example, A TSeq 2 0 (SSeq 3) like [[1,2,3], [4,5,6]]
-- requires 3 integer sized registers and a delay of 1 clock.
-- The [1,2,3] appear on clk 0 and [4,5,6] appear on clk 1.
-- The output is [[1,2],[3,4],[5,6]].
-- Naively, 1,3, and 5 would be emitted on clk 0. But
-- 5 only is inputted on clk 1. To preserve causality,
-- the first output is delayed by 1.
-- That means that [1,2,3] must be stored for a clock.
-- Then, when 1, 3, and 5 are emitted, 2 is kept for the next
-- clock and 4 and 6 are stored.
-- Then, on clock 2, 2,4,6 are emitted.
-- This is more problematic for larger values as
--
-- λ: ts_to_st_max_buffer_size 120 1000
--delay119
--storage119000
--0
--λ: ts_to_st_max_buffer_size 1000 120
--delay991
--storage118920
--0
--
-- This shows that the flip ends up storing almost the entire input
module Aetherling.Functional_Models.Min_Size_flip_ts_to_st where
import Data.List.Split
import Debug.Trace

data Input_Element_And_Clock = E_And_C { elem :: Int, clk :: Int} deriving (Show, Eq)
data IO_Clk = IO_Clk {i_clk :: Int, o_clk :: Int} deriving (Show, Eq)

-- | given an outer TSeq len and an inner SSeq len
-- generate a the sequence where each element is combined
-- with it's arrival clock
generate_ts :: Int -> Int -> [[Input_Element_And_Clock]]
generate_ts t_len s_len =
  [[E_And_C (s_len*o + i) o | i <- [0.. (s_len - 1)]] |o <- [0..(t_len - 1)]]

-- | reorder a TSeq no io (SSeq ni) to SSeq ni (TSeq no io)
-- while preserving the order of elements
flip_ts_to_st t_len ts = chunksOf t_len $ concat ts

-- | given an SSeq ni (TSeq no io) to output where each element is tupled
-- with when it was inputted, emit a flat list of the input and out times of each
-- element in the SSeq ni (TSeq no io)
-- Note that this may lead to elements that are emitted before they're accepted
get_input_and_output_clks_for_st st = do
  let st_with_output_clk = fmap (zip [0..]) st
  concat $ fmap (\tseq -> fmap (\(out_clk, elem) -> IO_Clk (clk elem) out_clk) tseq) st_with_output_clk

-- | given a list elements where each element has it's input and output clocks
-- return the minimum delay necessary to ensure each element is emitted after it arrives
get_delay_to_preserve_causality io_clk_list =
  maximum $ fmap (\(IO_Clk i_clk o_clk) -> i_clk - o_clk) io_clk_list

-- | Given an element's input and outupt clks and a clock, determine if that element
-- must be stored during the clock tick leading into that clock cycle
store_element_during_clk io_clk clk = (clk > i_clk io_clk) && (clk <= o_clk io_clk)

-- | given a clock and list of the input and output clocks for an element,
-- determine the number of elements that must be buffered each clock
num_elem_on_clk io_clk_list clk = length $
  filter (\elem_io_clk -> store_element_during_clk elem_io_clk clk) io_clk_list

update_io_clk_for_delay io_clk delay = IO_Clk (i_clk io_clk) (o_clk io_clk + delay)
{-
get_offset_ts ts_tracker emitted_clock = IO_Clk (clk ts_tracker) emitted_clock 


get_input_and_output_clks_for_ts ts = do
  let t_with_clk = zip [0..] ts
  fmap (\(clk, xs) -> fmap (\elem -> get_offset_ts elem clk) xs) t_with_clk
 -} 
ts_to_st_max_buffer_size t_len s_len = do
  let ts = generate_ts t_len s_len
  let st = flip_ts_to_st t_len ts
  let io_clk_list = get_input_and_output_clks_for_st st
  let delay = get_delay_to_preserve_causality io_clk_list
  let io_clks_with_delay_list = fmap (\io_clk -> update_io_clk_for_delay io_clk delay) io_clk_list
  let storage_per_clk = fmap (\clk -> num_elem_on_clk io_clks_with_delay_list clk) [0..delay+t_len-1]
  --trace ("io_per_element" ++ (show $ io_clk_list)) $
  --  trace ("storage_per_clk" ++ (show $ storage_per_clk))
  trace ("delay" ++ show delay) $
    trace ("storage" ++ (show $ maximum storage_per_clk)) $ 0
    
