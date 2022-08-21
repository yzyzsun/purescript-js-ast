module Language.JS.AST where

import Prelude

import Data.Bifunctor (bimap)
import Data.Foldable (foldl)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))

-- |
-- Built-in unary operators
--
data UnaryOperator
  -- |
  -- Numeric negation
  --
  = Negate
  -- |
  -- Boolean negation
  --
  | Not
  -- |
  -- Bitwise negation
  --
  | BitwiseNot
  -- |
  -- Numeric unary \'plus\'
  --
  | Positive
  -- |
  -- Spread syntax
  --
  | Spread

instance showUnaryOperator :: Show UnaryOperator where
  show Negate = "Negate"
  show Not = "Not"
  show BitwiseNot = "BitwiseNot"
  show Positive = "Positive"
  show Spread = "Spread"

instance eqUnaryOperator :: Eq UnaryOperator where
  eq Negate Negate = true
  eq Not Not = true
  eq BitwiseNot BitwiseNot = true
  eq Positive Positive = true
  eq Spread Spread = true
  eq _ _ = false

-- |
-- Built-in binary operators
--
data BinaryOperator
  -- |
  -- Numeric addition
  --
  = Add
  -- |
  -- Numeric subtraction
  --
  | Subtract
  -- |
  -- Numeric multiplication
  --
  | Multiply
  -- |
  -- Numeric division
  --
  | Divide
  -- |
  -- Remainder
  --
  | Modulus
  -- |
  -- Generic equality test
  --
  | EqualTo
  -- |
  -- Generic inequality test
  --
  | NotEqualTo
  -- |
  -- Numeric less-than
  --
  | LessThan
  -- |
  -- Numeric less-than-or-equal
  --
  | LessThanOrEqualTo
  -- |
  -- Numeric greater-than
  --
  | GreaterThan
  -- |
  -- Numeric greater-than-or-equal
  --
  | GreaterThanOrEqualTo
  -- |
  -- Boolean and
  --
  | And
  -- |
  -- Boolean or
  --
  | Or
  -- |
  -- Bitwise and
  --
  | BitwiseAnd
  -- |
  -- Bitwise or
  --
  | BitwiseOr
  -- |
  -- Bitwise xor
  --
  | BitwiseXor
  -- |
  -- Bitwise left shift
  --
  | ShiftLeft
  -- |
  -- Bitwise right shift
  --
  | ShiftRight
  -- |
  -- Bitwise right shift with zero-fill
  --
  | ZeroFillShiftRight

instance showBinaryOperator :: Show BinaryOperator where
  show Add = "Add"
  show Subtract = "Subtract"
  show Multiply = "Multiply"
  show Divide = "Divide"
  show Modulus = "Modulus"
  show EqualTo = "EqualTo"
  show NotEqualTo = "NotEqualTo"
  show LessThan = "LessThan"
  show LessThanOrEqualTo = "LessThanOrEqualTo"
  show GreaterThan = "GreaterThan"
  show GreaterThanOrEqualTo = "GreaterThanOrEqualTo"
  show And = "And"
  show Or = "Or"
  show BitwiseAnd = "BitwiseAnd"
  show BitwiseOr = "BitwiseOr"
  show BitwiseXor = "BitwiseXor"
  show ShiftLeft = "ShiftLeft"
  show ShiftRight = "ShiftRight"
  show ZeroFillShiftRight = "ZeroFillShiftRight"

instance eqBinaryOperator :: Eq BinaryOperator where
  eq Add Add = true
  eq Subtract Subtract = true
  eq Multiply Multiply = true
  eq Divide Divide = true
  eq Modulus Modulus = true
  eq EqualTo EqualTo = true
  eq NotEqualTo NotEqualTo = true
  eq LessThan LessThan = true
  eq LessThanOrEqualTo LessThanOrEqualTo = true
  eq GreaterThan GreaterThan = true
  eq GreaterThanOrEqualTo GreaterThanOrEqualTo = true
  eq And And = true
  eq Or Or = true
  eq BitwiseAnd BitwiseAnd = true
  eq BitwiseOr BitwiseOr = true
  eq BitwiseXor BitwiseXor = true
  eq ShiftLeft ShiftLeft = true
  eq ShiftRight ShiftRight = true
  eq ZeroFillShiftRight ZeroFillShiftRight = true
  eq _ _ = false

-- |
-- Data type for simplified Javascript expressions
--
data JS
  = JSNullLiteral
  -- |
  -- A numeric literal
  --
  | JSNumericLiteral Number
  -- |
  -- A string literal
  --
  | JSStringLiteral String
  -- |
  -- A template literal
  | JSTemplateLiteral String
  -- |
  -- A boolean literal
  --
  | JSBooleanLiteral Boolean
  -- |
  -- A unary operator application
  --
  | JSUnary UnaryOperator JS
  -- |
  -- A binary operator application
  --
  | JSBinary BinaryOperator JS JS
  -- |
  -- An array literal
  --
  | JSArrayLiteral (Array JS)
  -- |
  -- An array indexer expression
  --
  | JSIndexer JS JS
  -- |
  -- An object literal
  --
  | JSObjectLiteral (Array (Tuple JS JS))
  -- |
  -- An object property accessor expression
  --
  | JSAccessor String JS
  -- |
  -- A function introduction (optional name, arguments, body)
  --
  | JSFunction (Maybe String) (Array String) JS
  -- |
  -- Function application
  --
  | JSApp JS (Array JS)
  -- |
  -- Variable
  --
  | JSVar String
  -- |
  -- Conditional expression
  --
  | JSConditional JS JS JS
  -- |
  -- A block of expressions in braces
  --
  | JSBlock (Array JS)
  -- |
  -- A variable introduction and optional initialization
  --
  | JSVariableIntroduction String (Maybe JS)
  -- |
  -- A variable assignment
  --
  | JSAssignment JS JS
  -- |
  -- While loop
  --
  | JSWhile JS JS
  -- |
  -- For loop
  --
  | JSFor String JS JS JS
  -- |
  -- ForIn loop
  --
  | JSForIn String JS JS
  -- |
  -- If-then-else statement
  --
  | JSIfElse JS JS (Maybe JS)
  -- |
  -- Return statement
  --
  | JSReturn JS
  -- |
  -- Throw statement
  --
  | JSThrow JS
  -- |
  -- Type-Of operator
  --
  | JSTypeOf JS
  -- |
  -- Labelled statement
  --
  | JSLabel String JS
  -- |
  -- Break statement
  --
  | JSBreak String
  -- |
  -- Continue statement
  --
  | JSContinue String

instance showJS :: Show JS where
  show (JSNullLiteral) = "JSNullLiteral"
  show (JSNumericLiteral n) = "JSNumericLiteral (" <> show n <> ")"
  show (JSStringLiteral s) = "JSStringLiteral (" <> show s <> ")"
  show (JSTemplateLiteral s) = "JSTemplateLiteral (" <> show s <> ")"
  show (JSBooleanLiteral b) = "JSBooleanLiteral (" <> show b <> ")"
  show (JSUnary op js) = "JSUnary (" <> show op <> ") (" <> show js <> ")"
  show (JSBinary op js1 js2) = "JSBinary (" <> show op <> ") (" <> show js1 <> ") (" <> show js2 <> ")"
  show (JSArrayLiteral js) = "JSArrayLiteral (" <> show js <> ")"
  show (JSIndexer js1 js2) = "JSIndexer (" <> show js1 <> ") (" <> show js2 <> ")"
  show (JSObjectLiteral ps) = "JSObjectLiteral (" <> show ps <> ")"
  show (JSAccessor prop js) = "JSAccessor (" <> show prop <> ") (" <> show js <> ")"
  show (JSFunction nm args js) = "JSFunction (" <> show nm <> ") (" <> show args <> ") (" <> show js <> ")"
  show (JSApp js args) = "JSApp (" <> show js <> ") (" <> show args <> ")"
  show (JSVar nm) = "JSVar (" <> show nm <> ")"
  show (JSConditional js1 js2 js3) = "JSConditional (" <> show js1 <> ") (" <> show js2 <> ") (" <> show js3 <> ")"
  show (JSBlock js) = "JSBlock (" <> show js <> ")"
  show (JSVariableIntroduction nm js) = "JSVariableIntroduction (" <> show nm <> ") (" <> show js <> ")"
  show (JSAssignment js1 js2) = "JSAssignment (" <> show js1 <> ") (" <> show js2 <> ")"
  show (JSWhile js1 js2) = "JSWhile (" <> show js1 <> ") (" <> show js2 <> ")"
  show (JSFor nm js1 js2 js3) = "JSFor (" <> show nm <> ") (" <> show js1 <> ") (" <> show js2 <> ") (" <> show js3 <> ")"
  show (JSForIn nm js1 js2) = "JSForIn String (" <> show nm <> ") (" <> show js1 <> ") (" <> show js2 <> ")"
  show (JSIfElse js1 js2 js3) = "JSIfElse (" <> show js1 <> ") (" <> show js2 <> ") (" <> show js3 <> ")"
  show (JSReturn js) = "JSReturn (" <> show js <> ")"
  show (JSThrow js) = "JSThrow (" <> show js <> ")"
  show (JSTypeOf js) = "JSTypeOf (" <> show js <> ")"
  show (JSLabel lbl js) = "JSLabel (" <> show lbl <> ") (" <> show js <> ")"
  show (JSBreak lbl) = "JSBreak (" <> show lbl <> ")"
  show (JSContinue lbl) = "JSContinue (" <> show lbl <> ")"

instance eqJS :: Eq JS where
  eq JSNullLiteral JSNullLiteral = true
  eq (JSNumericLiteral n1) (JSNumericLiteral n2) = n1 == n2
  eq (JSStringLiteral s1) (JSStringLiteral s2) = s1 == s2
  eq (JSTemplateLiteral s1) (JSTemplateLiteral s2) = s1 == s2
  eq (JSBooleanLiteral b1) (JSBooleanLiteral b2) = b1 == b2
  eq (JSUnary op1 js1) (JSUnary op2 js2) = op1 == op2 && js1 == js2
  eq (JSBinary op1 js11 js21) (JSBinary op2 js12 js22) = op1 == op2 && js11 == js12 && js21 == js22
  eq (JSArrayLiteral js1) (JSArrayLiteral js2) = js1 == js2
  eq (JSIndexer js11 js21) (JSIndexer js12 js22) = js11 == js12 && js21 == js22
  eq (JSObjectLiteral ps1) (JSObjectLiteral ps2) = ps1 == ps2
  eq (JSAccessor prop1 js1) (JSAccessor prop2 js2) = prop1 == prop2 && js1 == js2
  eq (JSFunction nm1 args1 js1) (JSFunction nm2 args2 js2) = nm1 == nm2 && args1 == args2 && js1 == js2
  eq (JSApp js1 args1) (JSApp js2 args2) = js1 == js2 && args1 == args2
  eq (JSVar nm1) (JSVar nm2) = nm1 == nm2
  eq (JSConditional js11 js21 js31) (JSConditional js12 js22 js32) = js11 == js12 && js21 == js22 && js31 == js32
  eq (JSBlock js1) (JSBlock js2) = js1 == js2
  eq (JSVariableIntroduction nm1 js1) (JSVariableIntroduction nm2 js2) = nm1 == nm2 && js1 == js2
  eq (JSAssignment js11 js21) (JSAssignment js12 js22) = js11 == js12 && js21 == js22
  eq (JSWhile js11 js21) (JSWhile js12 js22) = js11 == js12 && js21 == js22
  eq (JSFor nm1 js11 js21 js31) (JSFor nm2 js12 js22 js32) = nm1 == nm2 && js11 == js12 && js21 == js22 && js31 == js32
  eq (JSForIn nm1 js11 js21) (JSForIn nm2 js12 js22) = nm1 == nm2 && js11 == js12 && js21 == js22
  eq (JSIfElse js11 js21 js31) (JSIfElse js12 js22 js32) = js11 == js12 && js21 == js22 && js31 == js32
  eq (JSReturn js1) (JSReturn js2) = js1 == js2
  eq (JSThrow js1) (JSThrow js2) = js1 == js2
  eq (JSTypeOf js1) (JSTypeOf js2) = js1 == js2
  eq (JSLabel lbl1 js1) (JSLabel lbl2 js2) = lbl1 == lbl2 && js1 == js2
  eq (JSBreak lbl1) (JSBreak lbl2) = lbl1 == lbl2
  eq (JSContinue lbl1) (JSContinue lbl2) = lbl1 == lbl2
  eq _ _ = false

--
-- Traversals
--

everywhereOnJS :: (JS -> JS) -> JS -> JS
everywhereOnJS f = go
  where
  go :: JS -> JS
  go (JSUnary op j) = f (JSUnary op (go j))
  go (JSBinary op j1 j2) = f (JSBinary op (go j1) (go j2))
  go (JSArrayLiteral js) = f (JSArrayLiteral (map go js))
  go (JSIndexer j1 j2) = f (JSIndexer (go j1) (go j2))
  go (JSObjectLiteral js) = f (JSObjectLiteral (map (bimap go go) js))
  go (JSAccessor prop j) = f (JSAccessor prop (go j))
  go (JSFunction name args j) = f (JSFunction name args (go j))
  go (JSApp j js) = f (JSApp (go j) (map go js))
  go (JSConditional j1 j2 j3) = f (JSConditional (go j1) (go j2) (go j3))
  go (JSBlock js) = f (JSBlock (map go js))
  go (JSVariableIntroduction name j) = f (JSVariableIntroduction name ((<$>) go j))
  go (JSAssignment j1 j2) = f (JSAssignment (go j1) (go j2))
  go (JSWhile j1 j2) = f (JSWhile (go j1) (go j2))
  go (JSFor name j1 j2 j3) = f (JSFor name (go j1) (go j2) (go j3))
  go (JSForIn name j1 j2) = f (JSForIn name (go j1) (go j2))
  go (JSIfElse j1 j2 j3) = f (JSIfElse (go j1) (go j2) ((<$>) go j3))
  go (JSReturn js) = f (JSReturn (go js))
  go (JSThrow js) = f (JSThrow (go js))
  go (JSTypeOf js) = f (JSTypeOf (go js))
  go (JSLabel name js) = f (JSLabel name (go js))
  go other = f other

everywhereOnJSTopDown :: (JS -> JS) -> JS -> JS
everywhereOnJSTopDown f = go <<< f
  where
  go :: JS -> JS
  go (JSUnary op j) = JSUnary op (go (f j))
  go (JSBinary op j1 j2) = JSBinary op (go (f j1)) (go (f j2))
  go (JSArrayLiteral js) = JSArrayLiteral (map (go <<< f) js)
  go (JSIndexer j1 j2) = JSIndexer (go (f j1)) (go (f j2))
  go (JSObjectLiteral js) = JSObjectLiteral (map (bimap (go <<< f) (go <<< f)) js)
  go (JSAccessor prop j) = JSAccessor prop (go (f j))
  go (JSFunction name args j) = JSFunction name args (go (f j))
  go (JSApp j js) = JSApp (go (f j)) (map (go <<< f) js)
  go (JSConditional j1 j2 j3) = JSConditional (go (f j1)) (go (f j2)) (go (f j3))
  go (JSBlock js) = JSBlock (map (go <<< f) js)
  go (JSVariableIntroduction name j) = JSVariableIntroduction name ((go <<< f) <$> j)
  go (JSAssignment j1 j2) = JSAssignment (go (f j1)) (go (f j2))
  go (JSWhile j1 j2) = JSWhile (go (f j1)) (go (f j2))
  go (JSFor name j1 j2 j3) = JSFor name (go (f j1)) (go (f j2)) (go (f j3))
  go (JSForIn name j1 j2) = JSForIn name (go (f j1)) (go (f j2))
  go (JSIfElse j1 j2 j3) = JSIfElse (go (f j1)) (go (f j2)) ((go <<< f) <$> j3)
  go (JSReturn j) = JSReturn (go (f j))
  go (JSThrow j) = JSThrow (go (f j))
  go (JSTypeOf j) = JSTypeOf (go (f j))
  go (JSLabel name j) = JSLabel name (go (f j))
  go other = f other

everythingOnJS :: forall r. Monoid r ⇒ (JS -> r) -> JS -> r
everythingOnJS f = go
  where
  go j@(JSUnary _ j1) = f j <> go j1
  go j@(JSBinary _ j1 j2) = f j <> go j1 <> go j2
  go j@(JSArrayLiteral js) = foldl (<>) (f j) (map go js)
  go j@(JSIndexer j1 j2) = f j <> go j1 <> go j2
  go j@(JSObjectLiteral js) = foldl (<>) (f j) (map (\(Tuple j1 j2) -> go j1 <> go j2) js)
  go j@(JSAccessor _ j1) = f j <> go j1
  go j@(JSFunction _ _ j1) = f j <> go j1
  go j@(JSApp j1 js) = foldl (<>) (f j <> go j1) (map go js)
  go j@(JSConditional j1 j2 j3) = f j <> go j1 <> go j2 <> go j3
  go j@(JSBlock js) = foldl (<>) (f j) (map go js)
  go j@(JSVariableIntroduction _ (Just j1)) = f j <> go j1
  go j@(JSAssignment j1 j2) = f j <> go j1 <> go j2
  go j@(JSWhile j1 j2) = f j <> go j1 <> go j2
  go j@(JSFor _ j1 j2 j3) = f j <> go j1 <> go j2 <> go j3
  go j@(JSForIn _ j1 j2) = f j <> go j1 <> go j2
  go j@(JSIfElse j1 j2 Nothing) = f j <> go j1 <> go j2
  go j@(JSIfElse j1 j2 (Just j3)) = f j <> go j1 <> go j2 <> go j3
  go j@(JSReturn j1) = f j <> go j1
  go j@(JSThrow j1) = f j <> go j1
  go j@(JSTypeOf j1) = f j <> go j1
  go j@(JSLabel _ j1) = f j <> go j1
  go other = f other
