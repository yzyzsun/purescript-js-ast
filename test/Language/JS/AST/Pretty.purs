module Test.Language.JS.AST.Pretty where

import Prelude

import Data.String (joinWith)
import Data.Tuple (Tuple(..))
import Language.JS.AST (JS(..))
import Language.JS.Pretty (print1)
import Test.Unit (TestSuite, test)
import Test.Unit (suite) as Test
import Test.Unit.Assert (equal)

suite ∷ TestSuite
suite = Test.suite "Language.JS.AST.Pretty" $ do
  let
    obj = JSObjectLiteral
      [ Tuple (JSStringLiteral "string") (JSStringLiteral "value")
      , Tuple (JSStringLiteral "my-number") (JSNumericLiteral 8.0)
      , Tuple (JSVar "variable") (JSBooleanLiteral true)
      ]
    s = joinWith "\n"
      [ "{"
      , "    string: \"value\","
      , "    \"my-number\": 8.0,"
      , "    [variable]: true"
      , "}"
      ]
  test "plain" do
    equal s (print1 obj)
