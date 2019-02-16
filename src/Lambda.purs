module Lambda where
import Prelude

import Data.Either (either)
import Data.Newtype (unwrap)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Exception (throw)
import Effect.Uncurried (runEffectFn1)
import Lambda.Body (class BodyDecode, decodeBody)
import Web.Query (class QueryDecodeFields, QueryParams(..), decodeQueryR)
import Lambda.Types (Endpoint, Request, Response, Handler)
import Prim.RowList (class RowToList)

foreign import lambdify :: Handler -> Endpoint

endpoint' :: (Request -> Aff Response) -> Endpoint
endpoint' fn = lambdify handler
  where
    task req cb = fn req >>= liftEffect <<< runEffectFn1 cb
    handler req cb = launchAff_ $ task req cb

endpoint
  :: ∀ body params paramsFields
   . RowToList params paramsFields
  => BodyDecode body
  => QueryDecodeFields paramsFields () params
  => (Request -> body -> {| params } -> Aff Response)
  -> Endpoint
endpoint fn = endpoint' \req -> do
  { body, params } <- liftEffect $ either (throw <<< unwrap) pure $ input req
  fn req body params
  where
    input req = do
      body <- decodeBody req.body
      params <- decodeQueryR $ QueryParams req.multiValueQueryStringParameters
      pure $ { body, params }
