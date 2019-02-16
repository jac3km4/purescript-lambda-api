module Lambda.Types
  ( Endpoint
  , Handler
  , Callback
  , Response
  , Request
  , NoBody(..)
  , NoQuery
  , module Web.Query
  ) where
import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Foreign.Object (Object)
import Prelude (Unit)
import Web.Query (DecodeError(..), QueryParam)

foreign import data Endpoint :: Type

type Handler = Request -> Callback -> Effect Unit

type Callback = EffectFn1 Response Unit

type Response =
  { statusCode :: Int
  , headers :: Object String
  , body :: String
  }

type Request =
  { multiValueQueryStringParameters :: Object QueryParam
  , headers :: Object String
  , pathParameters :: Object String
  , body :: Nullable String
  }

newtype NoBody = NoBody {}

type NoQuery = {}
