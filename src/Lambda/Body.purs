module Lambda.Body where
import Data.Bifunctor (lmap)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe)
import Lambda.Types (DecodeError(..), NoBody(..))
import Prelude (show, ($), (<<<))
import Simple.JSON (class ReadForeign, readJSON)

class BodyDecode a where
  decodeBody :: Nullable String -> Either DecodeError a

instance decodeNoBody :: BodyDecode NoBody where
  decodeBody _ = Right $ NoBody {}

jsonBody :: ∀ a. ReadForeign a => Nullable String -> Either DecodeError a
jsonBody body =
  case toMaybe body of
    Just value -> lmap (DecodeError <<< show) $ readJSON value
    Nothing -> Left $ DecodeError "Body is null"
