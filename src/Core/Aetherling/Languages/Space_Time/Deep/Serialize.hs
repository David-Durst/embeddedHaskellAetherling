module Aetherling.Languages.Space_Time.Deep.Serialize where
import Aetherling.Languages.Space_Time.Deep.Types
import Proto.Spacetime as PS
import Proto.Spacetime_Fields as PS
import Data.ProtoLens.Message
import Data.ProtoLens.Encoding
import Data.ProtoLens (defMessage)
import Lens.Family2 ((&), (.~), (^.))
import Data.ByteString


save_type :: FilePath -> AST_Type -> IO ()
save_type file_path t = do
  let serialized_type = save_type' t
  let byte_str_type = encodeMessage serialized_type
  Data.ByteString.writeFile file_path byte_str_type
  

save_type' :: AST_Type -> PS.TypeSerialized
save_type' (UnitT) =
  defMessage & PS.v .~ PS.Unit
save_type' (BitT) =
  defMessage & PS.v .~ PS.Bit
save_type' (IntT) =
  defMessage & PS.v .~ PS.Int
save_type' (ATupleT left right) =
  defMessage & PS.v .~ PS.ATuple
  & PS.children .~ [left_serialized, right_serialized]
  where
    left_serialized = save_type' left
    right_serialized = save_type' right
save_type' (STupleT n elem_t) =
  defMessage & PS.v .~ PS.STuple
  & PS.n .~ (fromIntegral n)
  & PS.children .~ [elem_t_serialized]
  where
    elem_t_serialized = save_type' elem_t
save_type' (SSeqT n elem_t) =
  defMessage & PS.v .~ PS.SSeq
  & PS.n .~ (fromIntegral n)
  & PS.children .~ [elem_t_serialized]
  where
    elem_t_serialized = save_type' elem_t
save_type' (TSeqT n i elem_t) =
  defMessage & PS.v .~ PS.TSeq
  & PS.n .~ (fromIntegral n)
  & PS.i .~ (fromIntegral i)
  & PS.children .~ [elem_t_serialized]
  where
    elem_t_serialized = save_type' elem_t

load_type :: FilePath -> IO AST_Type
load_type file_path = do
  byte_str_type <- Data.ByteString.readFile file_path
  let serialized_type = decodeMessageOrDie byte_str_type
  return $ load_type' serialized_type
  

load_type' :: PS.TypeSerialized -> AST_Type
load_type' serialized_type = do
  let type_version = serialized_type ^. PS.v
  case type_version of
    PS.Unit -> UnitT
    PS.Bit -> BitT
    PS.Int -> IntT
    PS.ATuple -> do
      let elem_t_xs = serialized_type ^. PS.children
      if Prelude.length elem_t_xs == 2
        then ATupleT (load_type' $ elem_t_xs !! 0) (load_type' $ elem_t_xs !! 1)
        else error "deserializing failed as ATuple didn't have 2 elem_T"
    PS.STuple -> do
      let n = fromIntegral $ serialized_type ^. PS.n
      let elem_t_xs = serialized_type ^. PS.children
      if Prelude.length elem_t_xs == 1
        then STupleT n (load_type' $ elem_t_xs !! 0)
        else error "deserializing failed as STuple didn't have 1 elem_T"
    PS.SSeq -> do
      let n = fromIntegral $ serialized_type ^. PS.n
      let elem_t_xs = serialized_type ^. PS.children
      if Prelude.length elem_t_xs == 1
        then SSeqT n (load_type' $ elem_t_xs !! 0)
        else error "deserializing failed as SSeq didn't have 1 elem_T"
    PS.TSeq -> do
      let n = fromIntegral $ serialized_type ^. PS.n
      let i = fromIntegral $ serialized_type ^. PS.i
      let elem_t_xs = serialized_type ^. PS.children
      if Prelude.length elem_t_xs == 1
        then TSeqT n i (load_type' $ elem_t_xs !! 0)
        else error "deserializing failed as TSeq didn't have 1 elem_T"
    _ -> error "failed match in deserializing"
