module Test.Language.JS.AST.Pretty where

import Prelude

import Data.String (joinWith)
import Language.JS.AST (JS(..), ObjectProperty(..))
import Language.JS.Pretty (print1)
import Test.Unit (TestSuite, test)
import Test.Unit (suite) as Test
import Test.Unit.Assert (equal)

suite ∷ TestSuite
suite = Test.suite "Language.JS.AST.Pretty" $ do
  let
    obj = JSObjectLiteral
      [ LiteralName "string" (JSStringLiteral "value")
      , LiteralName "my-number" (JSNumericLiteral 8.0)
      , ComputedName (JSVar "variable") (JSBooleanLiteral true)
      , Getter "zero" [JSReturn (JSNumericLiteral 0.0)]
      , Setter "noop" "_" []
      ]
    s = joinWith "\n"
      [ "{"
      , "    string: \"value\","
      , "    \"my-number\": 8.0,"
      , "    [variable]: true,"
      , "    get zero() {"
      , "        return 0.0;"
      , "    },"
      , "    set noop(_) {"
      , ""
      , "    }"
      , "}"
      ]
  test "plain" do
    equal s (print1 obj)
