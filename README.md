# purescript-lambda-api
Purescript library for AWS Lambda API Gateway integrations

# example endpoint
Taken from `test/Main.purs`
```purescript
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
```
