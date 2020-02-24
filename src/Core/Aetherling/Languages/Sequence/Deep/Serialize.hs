module Aetherling.Languages.Sequence.Deep.Serialize where
import Aetherling.Languages.Sequence.Deep.Types
import Aetherling.Interpretations.Backend_Execute.Value_To_String
import Proto.Sequence as PS
import Proto.Sequence_Fields as PS
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
save_type' (SeqT n elem_t) =
  defMessage & PS.v .~ PS.Seq
  & PS.n .~ (fromIntegral n)
  & PS.children .~ [elem_t_serialized]
  where
    elem_t_serialized = save_type' elem_t
save_type' _ = error "not supported type to save"

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
    PS.Seq -> do
      let n = fromIntegral $ serialized_type ^. PS.n
      let elem_t_xs = serialized_type ^. PS.children
      if Prelude.length elem_t_xs == 1
        then SeqT n (load_type' $ elem_t_xs !! 0)
        else error "deserializing failed as Seq didn't have 1 elem_T"
    _ -> error "failed match in deserializing"


save_value :: Convertible_To_Atom_Strings a => FilePath -> a -> IO ()
save_value file_path vals = do
  let serialized_vals = convert_to_haskell_proto vals
  let byte_str_vals = encodeMessage serialized_vals
  Data.ByteString.writeFile file_path byte_str_vals

load_value :: FilePath -> IO ValueSerialized
load_value file_path = do
  byte_str_vals <- Data.ByteString.readFile file_path
  return $ decodeMessageOrDie byte_str_vals
