module Test.Main where
import Data.Either (Either(..))
import Effect.Aff (Aff)
import Lambda (endpoint) as L
import Lambda.Body (class BodyDecode, jsonBody)
import Lambda.Types (DecodeError(..), Request, Response)
import Lambda.Types (Endpoint) as L
import Prelude (mempty, pure, ($), (+), (-))
import Simple.JSON (class ReadForeign, writeJSON)
import Web.Query (class QueryDecode)

calculate :: L.Endpoint
calculate = L.endpoint respond
  where
    respond :: Request -> Body -> Query -> Aff Response
    respond _ (Body {lhs, rhs}) {op} =
      let res = case op of
            Add -> lhs + rhs
            Sub -> lhs - rhs
      in pure $ { statusCode: 200, body: writeJSON res, headers: mempty }

newtype Body = Body { lhs :: Int, rhs :: Int }
derive newtype instance readForeignBody :: ReadForeign Body

instance bodyDecodeBody :: BodyDecode Body where
  decodeBody = jsonBody

type Query = { op :: Operation }

data Operation = Add | Sub

instance queryDecodeOperation :: QueryDecode Operation where
  decodeQueryParam ["add"] = Right Add
  decodeQueryParam ["sub"] = Right Sub
  decodeQueryParam _ = Left $ DecodeError "Invalid operation"
