# PowerAssert API Reference

This document provides detailed documentation for all APIs provided by PowerAssert for Nim.

## Table of Contents

1. [Public API](#public-api)
   - [powerAssert](#powerassert)
   - [assert](#assert)
   - [doAssert](#doassert)
   - [check](#check)
   - [require](#require)
   - [expectError](#expecterror)
   - [formatValue](#formatvalue)

2. [Test Statistics API](#test-statistics-api)
   - [TestStats](#teststats)
   - [powerAssertWithStats](#powerassertwithstats)
   - [skipTest](#skiptest)
   - [resetTestStats](#resetteststats)
   - [printTestSummary](#printtestsummary)
   - [getTestStats](#getteststats)
   - [recordPassed](#recordpassed)
   - [recordFailed](#recordfailed)
   - [recordSkipped](#recordskipped)

3. [Output Formats API](#output-formats-api)
   - [OutputFormat](#outputformat)
   - [setOutputFormat](#setoutputformat)
   - [getOutputFormat](#getoutputformat)

4. [Custom Formatters API](#custom-formatters-api)
   - [CapturedValues](#capturedvalues)
   - [FormatRenderer](#formatrenderer)
   - [setCustomRenderer](#setcustomrenderer)
   - [clearCustomRenderer](#clearcustomrenderer)
   - [capturedPairs](#capturedpairs)
   - [detectExpressionPositions](#detectexpressionpositions)

5. [Configuration](#configuration)
   - [ColorConfig](#colorconfig)
   - [setColorConfig](#setcolorconfig)

6. [Hint System](#hint-system)
   - [HintType](#hinttype)
   - [AssertionHint](#assertionhint)
   - [generateHints](#generatehints)
   - [formatHints](#formathints)

7. [Internal API](#internal-api)
   - [renderExpression](#renderexpression)
   - [ExpressionInfo](#expressioninfo)
   - [PowerAssertDefect](#powerassertdefect)

8. [Examples](#examples)

## Public API

### powerAssert

```nim
macro powerAssert*(condition: untyped, message: string = ""): untyped
```

Evaluates the given condition and displays detailed error messages with power-assert.js style visual output if the condition is `false`.

**Parameters**:
- `condition`: The condition expression to evaluate
- `message`: (Optional) Additional message to display on failure

**Returns**:
- Nothing if condition is `true`, raises `PowerAssertDefect` if `false`

**Example**:

```nim
let x = 5
let y = 10
powerAssert(x * 2 == y)  # Success

let a = 10
let b = 5
powerAssert(a < b, "a must be less than b")  # Failure with detailed visual output
```

**Visual Output**:
```
PowerAssert: Assertion failed

a < b
|   |
|   |
10  5

[int] a
=> 10
[int] b
=> 5

Message: a must be less than b
```

### assert

```nim
template assert*(cond: untyped, msg: string = "") {.dirty.}
```

Alias for `powerAssert`. Used to replace the standard library `assert` with enhanced functionality.

**Parameters**:
- `cond`: The condition expression to evaluate
- `msg`: (Optional) Additional message to display on failure

**Example**:

```nim
let value = 42
assert(value > 0)  # Uses PowerAssert functionality
```

### doAssert

```nim
template doAssert*(cond: untyped, msg: string = "") {.dirty.}
```

Alias for `powerAssert`. Used to replace the standard library `doAssert` with enhanced functionality.

**Parameters**:
- `cond`: The condition expression to evaluate
- `msg`: (Optional) Additional message to display on failure

**Example**:

```nim
let value = 42
doAssert(value > 0)  # Uses PowerAssert functionality
```

### check

```nim
template check*(condition: untyped): untyped
```

Overrides the unittest module's `check` template to provide PowerAssert's detailed error messages.

**Parameters**:
- `condition`: The condition expression to evaluate

**Example**:

```nim
import unittest
import power_assert

test "Value validation":
  let value = 42
  check(value == 42)  # Uses PowerAssert's detailed output
```

**Visual Output**:
```
PowerAssert: Assertion failed

value == 42
|||||    ||
|        |
35       42

[int] value
=> 35
[int] 42
=> 42
```

### require

```nim
template require*(condition: untyped, message: string = "") {.dirty.}
```

Alias for `powerAssert` used to express preconditions. Semantically clearer and provides detailed error messages when preconditions are not met.

**Parameters**:
- `condition`: The condition expression to evaluate
- `message`: (Optional) Additional message to display on failure

**Example**:

```nim
proc calculateSquareRoot(value: float): float =
  require(value >= 0, "Value must be non-negative")
  return sqrt(value)
```

### expectError

```nim
template expectError*(errorType: typedesc, code: untyped)
```

Expects the specified code block to throw a specific type of exception. Test fails if no exception is thrown or if a different type of exception is thrown.

**Parameters**:
- `errorType`: The expected exception type
- `code`: The code block to execute

**Example**:

```nim
expectError(ValueError):
  discard parseInt("not_a_number")
```

### formatValue

```nim
proc formatValue*[T](val: T): string
```

Converts a value of any type to a human-readable string format. Used internally by PowerAssert to display values in error messages, but can be used directly.

**Parameters**:
- `val`: The value to format (any type)

**Returns**:
- String representation of the value

**Example**:

```nim
let arr = @[1, 2, 3]
echo formatValue(arr)  # Output: "@[1, 2, 3]"

type Person = object
  name: string
  age: int

proc `$`(p: Person): string = p.name & " (" & $p.age & ")"

let person = Person(name: "Alice", age: 30)
echo formatValue(person)  # Output: "Alice (30)"
```

## Test Statistics API

PowerAssert provides comprehensive test statistics tracking functionality to monitor test execution results.

### TestStats

```nim
type TestStats* = object
  passed*: int
  failed*: int
  skipped*: int
```

Object that holds test execution statistics.

**Fields**:
- `passed`: Number of tests that passed
- `failed`: Number of tests that failed
- `skipped`: Number of tests that were skipped

### powerAssertWithStats

```nim
macro powerAssertWithStats*(condition: untyped, message: string = ""): untyped
```

Enhanced version of `powerAssert` that automatically tracks test statistics.

**Parameters**:
- `condition`: The condition expression to evaluate
- `message`: (Optional) Additional message to display on failure

**Returns**:
- Nothing if condition is `true`, raises `PowerAssertDefect` if `false`

**Example**:

```nim
powerAssertWithStats(x > 0)  # Automatically updates test statistics
powerAssertWithStats(y == 10, "Value should be 10")
```

### skipTest

```nim
template skipTest*(reason: string = "")
```

Marks a test as skipped and increments the skipped test counter.

**Parameters**:
- `reason`: (Optional) Reason for skipping the test

**Example**:

```nim
if not supportsFeatureX():
  skipTest("Feature X not supported on this platform")
```

### resetTestStats

```nim
proc resetTestStats*()
```

Resets all test statistics counters to zero.

**Example**:

```nim
resetTestStats()  # Start fresh test statistics
```

### printTestSummary

```nim
proc printTestSummary*()
```

Prints a formatted summary of test execution results.

**Output Format**:
```
Test Summary:
=============
PASSED:  15
FAILED:  2
SKIPPED: 1
TOTAL:   18

❌ 2 test(s) failed
```

**Example**:

```nim
# After running tests
printTestSummary()
```

### getTestStats

```nim
proc getTestStats*(): TestStats
```

Returns the current test statistics.

**Returns**:
- `TestStats` object with current counts

**Example**:

```nim
let stats = getTestStats()
echo "Passed: ", stats.passed
echo "Failed: ", stats.failed
```

### recordPassed

```nim
proc recordPassed*()
```

Manually increments the passed test counter.

**Example**:

```nim
# Custom test logic
if customTestPassed():
  recordPassed()
```

### recordFailed

```nim
proc recordFailed*()
```

Manually increments the failed test counter.

**Example**:

```nim
# Custom test logic
if not customTestPassed():
  recordFailed()
```

### recordSkipped

```nim
proc recordSkipped*()
```

Manually increments the skipped test counter.

**Example**:

```nim
# Custom skip logic
if shouldSkipTest():
  recordSkipped()
```

## Output Formats API

PowerAssert supports multiple output formats for assertion failure messages.

### OutputFormat

```nim
type OutputFormat* = enum
  ofPowerAssertJS = "PowerAssertJS"     # power-assert.js style with pipes
  ofCompact = "Compact"                  # Single-line format
  ofDetailed = "Detailed"                # Structured format with sections
  ofClassic = "Classic"                  # Traditional format with pointer
```

Enumeration of available output formats.

**Format Examples**:

**PowerAssertJS** (default):
```
isLess(x, y)
|      |  | 
|      |  5 
|      10   
false       

isLess = <proc (a: int, b: int): bool>
```

**Compact**:
```
Assertion failed: isLess(x, y) | x=10, y=5, isLess(x, y)=false
```

**Detailed**:
```
Assertion failed
Expression: isLess(x, y)
Variables:
  x = 10
  y = 5
  isLess(x, y) = false
```

**Classic**:
```
Assertion failed: isLess(x, y)
                  ^
At column 0: isLess(x, y) = false
```

### setOutputFormat

```nim
proc setOutputFormat*(format: OutputFormat)
```

Sets the global output format for all PowerAssert assertions.

**Parameters**:
- `format`: The desired output format

**Example**:

```nim
import power_assert

# Change to compact format
setOutputFormat(ofCompact)

# All subsequent assertions will use compact format
powerAssert(x > 0)

# Change to detailed format
setOutputFormat(ofDetailed)
```

### getOutputFormat

```nim
proc getOutputFormat*(): OutputFormat
```

Returns the currently active output format.

**Returns**:
- The current `OutputFormat`

**Example**:

```nim
let currentFormat = getOutputFormat()
echo "Current format: ", currentFormat
```

## Custom Formatters API

PowerAssert allows you to create custom output formatters for assertion failures.

### CapturedValues

```nim
type CapturedValues* = Table[string, tuple[value: string, typeName: string]]
```

Table type that stores captured expression values and their type information.

**Structure**:
- Key: Expression code as string
- Value: Tuple containing the value string and type name

### FormatRenderer

```nim
type FormatRenderer* = proc(
  exprStr: string,
  values: seq[ExpressionInfo],
  capturedValues: CapturedValues,
  message: string
): string {.closure.}
```

Function type for custom format renderers.

**Parameters**:
- `exprStr`: The original expression string
- `values`: Sequence of expression information
- `capturedValues`: Table of captured values
- `message`: Optional assertion message

**Returns**:
- Formatted string for display

### setCustomRenderer

```nim
proc setCustomRenderer*(renderer: FormatRenderer)
```

Sets a custom renderer function for formatting assertion output.

**Parameters**:
- `renderer`: Custom renderer function

**Example**:

```nim
proc myCustomRenderer(exprStr: string, values: seq[ExpressionInfo], 
                      capturedValues: CapturedValues, message: string): string =
  result = "=== Custom Assertion Failed ===\n"
  result &= "Expression: " & exprStr & "\n"
  for key, (value, typeName) in capturedValues:
    result &= "  " & key & " (" & typeName & ") = " & value & "\n"
  if message.len > 0:
    result &= "Message: " & message & "\n"

setCustomRenderer(myCustomRenderer)
```

### clearCustomRenderer

```nim
proc clearCustomRenderer*()
```

Removes the custom renderer and reverts to the default format.

**Example**:

```nim
# Use custom renderer
setCustomRenderer(myRenderer)

# Later, revert to default
clearCustomRenderer()
```

### capturedPairs

```nim
iterator capturedPairs*(captured: CapturedValues): tuple[code: string, value: string, typeName: string]
```

Iterator for traversing captured values in a convenient way.

**Yields**:
- Tuples containing code, value, and type name

**Example**:

```nim
for code, value, typeName in capturedPairs(capturedValues):
  echo code, " (", typeName, ") = ", value
```

### detectExpressionPositions

```nim
proc detectExpressionPositions*(exprStr: string, values: seq[ExpressionInfo]): seq[tuple[start, finish: int]]
```

Detects the positions of expressions within the expression string.

**Parameters**:
- `exprStr`: The original expression string
- `values`: Sequence of expression information

**Returns**:
- Sequence of tuples containing start and end positions

**Example**:

```nim
let positions = detectExpressionPositions("a + b == c", values)
for (start, finish) in positions:
  echo "Expression from ", start, " to ", finish
```

### Custom Formatter Example

Here's a complete example of creating and using a custom formatter:

```nim
import power_assert
import tables

# Define a JSON-like formatter
proc jsonFormatter(exprStr: string, values: seq[ExpressionInfo], 
                   capturedValues: CapturedValues, message: string): string =
  result = "{\n"
  result &= "  \"assertion\": \"failed\",\n"
  result &= "  \"expression\": \"" & exprStr & "\",\n"
  result &= "  \"values\": {\n"
  
  var first = true
  for code, value, typeName in capturedPairs(capturedValues):
    if not first:
      result &= ",\n"
    result &= "    \"" & code & "\": {\"value\": \"" & value & 
              "\", \"type\": \"" & typeName & "\"}"
    first = false
  
  result &= "\n  }"
  if message.len > 0:
    result &= ",\n  \"message\": \"" & message & "\""
  result &= "\n}"

# Use the custom formatter
setCustomRenderer(jsonFormatter)

let x = 10
let y = 5
powerAssert(x < y, "x should be less than y")

# Output:
# {
#   "assertion": "failed",
#   "expression": "x < y",
#   "values": {
#     "x": {"value": "10", "type": "int"},
#     "y": {"value": "5", "type": "int"}
#   },
#   "message": "x should be less than y"
# }
```

## Configuration

### ColorConfig

```nim
type ColorConfig* = object
  enabled*: bool
  errorTitle*: ForegroundColor
  expressionCode*: ForegroundColor
  indicator*: ForegroundColor
  values*: ForegroundColor
  types*: ForegroundColor
  compositeHeader*: ForegroundColor
  numberValues*: ForegroundColor
  stringValues*: ForegroundColor
  boolValues*: ForegroundColor
  errorValues*: ForegroundColor
```

Configuration object for customizing the visual output colors.

### Color Customization

The default color configuration can be modified to customize the visual output:

```nim
import power_assert

# Customize colors
colorConfig.enabled = true
colorConfig.errorTitle = fgRed
colorConfig.expressionCode = fgWhite
colorConfig.indicator = fgCyan
colorConfig.values = fgYellow
colorConfig.types = fgGreen
```

## Hint System

PowerAssert includes an intelligent hint system that provides Rust-like helpful suggestions for fixing assertion failures.

### HintType

```nim
type HintType* = enum
  TypeMismatchHint,
  CommonMistakeHint,
  SuggestionHint,
  NoteHint
```

Enumeration of different types of hints that can be provided:

- **TypeMismatchHint**: Suggests type conversions when comparing different types
- **CommonMistakeHint**: Detects common programming mistakes (like `=` vs `==`)
- **SuggestionHint**: Provides specific suggestions for improvement
- **NoteHint**: Offers explanatory notes about why something failed

### AssertionHint

```nim
type AssertionHint* = object
  hintType*: HintType
  message*: string
  suggestion*: string
```

Structure that holds information about a helpful hint:

**Fields**:
- `hintType`: The type of hint being provided
- `message`: Description of the issue detected
- `suggestion`: Specific recommendation for fixing the problem

### generateHints

```nim
proc generateHints*(exprStr: string, values: seq[ExpressionInfo]): seq[AssertionHint]
```

Analyzes assertion failures and generates context-aware hints.

**Parameters**:
- `exprStr`: The original expression string
- `values`: Information about evaluated sub-expressions

**Returns**:
- Sequence of hints with suggestions for fixing the assertion

**Hint Detection Patterns**:

1. **Type Mismatches**: Different numeric types, string vs number comparisons
2. **Boolean Logic**: Failed `and`/`or` operations with explanations
3. **String Comparisons**: Case differences, length mismatches, whitespace issues
4. **Collections**: Empty arrays/sequences detection
5. **Common Mistakes**: Assignment vs comparison operators

**Example**:
```nim
let hints = generateHints("x == y", @[
  ExpressionInfo(code: "x", value: "42", typeName: "int", column: 0),
  ExpressionInfo(code: "y", value: "42.0", typeName: "float", column: 5)
])
# Returns hints about type mismatch between int and float
```

### formatHints

```nim
proc formatHints*(hints: seq[AssertionHint]): string
```

Formats hints for display with color coding and proper structure.

**Parameters**:
- `hints`: Sequence of hints to format

**Returns**:
- Formatted string ready for display

**Output Format**:
```
Help:
  type mismatch: Comparing int with float
    → Consider converting one type: float(x) or int(y)
  suggestion: String lengths differ: 10 vs 12
    → Check for extra whitespace, different line endings, or missing characters
```

**Example Usage**:
```nim
let hints = generateHints(exprStr, values)
let formattedOutput = formatHints(hints)
echo formattedOutput
```

### Hint Examples

#### Type Mismatch Detection

```nim
let intVal = 42
let floatVal = 42.5
powerAssert(float(intVal) == floatVal)
```

Output:
```
PowerAssert: Assertion failed

float(intVal) == floatVal
|||||||||||||||    ||||||||
|                  |
42.0               42.5

[float] float(intVal)
=> 42.0
[float64] floatVal
=> 42.5

Help:
  type mismatch: Comparing float with float64
    → Consider converting one type: float64(float(intVal)) or float(floatVal)
```

#### String Comparison Analysis

```nim
let actual = "Hello World"
let expected = "hello world"
powerAssert(actual == expected)
```

Output:
```
Help:
  suggestion: Strings differ only in case
    → Use .toLowerAscii() or .toUpperAscii() for case-insensitive comparison
```

#### Boolean Logic Guidance

```nim
let condition1 = false
let condition2 = true
powerAssert(condition1 and condition2)
```

Output:
```
Help:
  note: Boolean AND operation failed
    → All conditions in 'and' expression must be true. Check each condition separately.
```

## Internal API

### renderExpression

```nim
proc renderExpression*(exprStr: string, values: seq[ExpressionInfo]): string
```

Generates detailed visual output from an expression string and list of value information.

**Parameters**:
- `exprStr`: String representation of the expression
- `values`: Value information for each part of the expression

**Returns**:
- Formatted expression display with power-assert.js style visual tree

**Example**:

```nim
let values = @[
  ExpressionInfo(code: "a", value: "5", typeName: "int", column: 0),
  ExpressionInfo(code: "b", value: "10", typeName: "int", column: 4),
  ExpressionInfo(code: "a + b", value: "15", typeName: "int", column: 0)
]
let output = renderExpression("a + b == 15", values)
echo output
```

### ExpressionInfo

```nim
type ExpressionInfo* = object
  code*: string        # Original code of the expression part
  value*: string       # String representation of the evaluated value
  typeName*: string    # Type name of the value
  column*: int         # Column position in the original expression
```

Structure that holds information about expression parts and their evaluation results.

### PowerAssertDefect

```nim
type PowerAssertDefect* = object of AssertionDefect
```

Exception type thrown by PowerAssert. Inherits from standard AssertionDefect for compatibility with existing test frameworks.

## Examples

### Basic Usage

```nim
import power_assert

# Simple assertion
let x = 10
let y = 5
powerAssert(x + y == 15)  # Success

# Failing assertion with visual output
powerAssert(x * y == 60)  # Shows detailed breakdown
```

### With Custom Types

```nim
import power_assert

type Person = object
  name: string
  age: int

proc `$`(p: Person): string =
  p.name & " (age: " & $p.age & ")"

proc `==`(a, b: Person): bool =
  a.name == b.name and a.age == b.age

let alice = Person(name: "Alice", age: 30)
let bob = Person(name: "Bob", age: 25)

powerAssert(alice == bob)  # Shows custom type visualization
```

### Integration with unittest

```nim
import unittest
import power_assert

suite "My Tests":
  test "arithmetic operations":
    let a = 5
    let b = 10
    check(a * 2 == b)  # Uses PowerAssert automatically
    
  test "string operations":
    let greeting = "Hello"
    let name = "World"
    check(greeting & " " & name == "Hello World")
```

### Complex Expressions

```nim
import power_assert

let numbers = @[1, 2, 3, 4, 5]
let threshold = 3
let condition = true

# Complex boolean expression
powerAssert(numbers.len > 3 and numbers[0] == 1 and condition)

# Array operations
powerAssert(numbers[2] * numbers[3] == 12)
```

This API provides comprehensive assertion capabilities with enhanced visual feedback, making it easier to understand and debug test failures.

## 目次

1. [パブリックAPI](#パブリックapi)
   - [powerAssert](#powerassert)
   - [assert](#assert)
   - [doAssert](#doassert)
   - [powerCheck](#powercheck)
   - [require](#require)
   - [expectError](#expecterror)
   - [check](#check)
   - [formatValue](#formatvalue)

2. [内部API](#内部api)
   - [powerAssertImpl](#powerassertimpl)
   - [renderExpression](#renderexpression)
   - [ExpressionInfo](#expressioninfo)
   - [PowerAssertDefect](#powerassertdefect)

## パブリックAPI

### powerAssert

```nim
macro powerAssert*(condition: untyped, message: string = ""): untyped
```

指定された条件を評価し、条件が`false`の場合に詳細なエラーメッセージを表示して例外を発生させます。

**パラメータ**:
- `condition`: 評価する条件式
- `message`: （オプション）失敗時に表示する追加メッセージ

**戻り値**:
- なし（条件が`true`の場合）または例外（条件が`false`の場合）

**例**:

```nim
let x = 5
let y = 10
powerAssert(x * 2 == y)  # 成功

let a = 10
let b = 5
powerAssert(a < b, "aはbより小さくなければなりません")  # 失敗して詳細なエラーメッセージを表示
```

### assert

```nim
template assert*(cond: untyped, msg: string = "") {.dirty.}
```

`powerAssert`のエイリアス。標準ライブラリの`assert`を置き換えるために使用します。

**パラメータ**:
- `cond`: 評価する条件式
- `msg`: （オプション）失敗時に表示する追加メッセージ

**例**:

```nim
let value = 42
assert(value > 0)  # PowerAssertの機能を使用
```

### doAssert

```nim
template doAssert*(cond: untyped, msg: string = "") {.dirty.}
```

`powerAssert`のエイリアス。標準ライブラリの`doAssert`を置き換えるために使用します。

**パラメータ**:
- `cond`: 評価する条件式
- `msg`: （オプション）失敗時に表示する追加メッセージ

**例**:

```nim
let value = 42
doAssert(value > 0)  # PowerAssertの機能を使用
```

### powerCheck

```nim
template powerCheck*(condition: untyped, message: string = "") {.dirty.}
```

`powerAssert`のエイリアス。`check`と同様の機能を提供します。

**パラメータ**:
- `condition`: 評価する条件式
- `message`: （オプション）失敗時に表示する追加メッセージ

**例**:

```nim
let value = 42
powerCheck(value > 0)  # PowerAssertの機能を使用
```

### require

```nim
template require*(condition: untyped, message: string = "") {.dirty.}
```

前提条件を表現するための`powerAssert`のエイリアス。セマンティックにわかりやすく、前提条件が満たされない場合に詳細なエラーメッセージを提供します。

**パラメータ**:
- `condition`: 評価する条件式
- `message`: （オプション）失敗時に表示する追加メッセージ

**例**:

```nim
proc calculateSquareRoot(value: float): float =
  require(value >= 0, "値は0以上である必要があります")
  return sqrt(value)
```

### expectError

```nim
template expectError*(errorType: typedesc, code: untyped)
```

指定されたコードブロックが特定の型の例外をスローすることを期待します。例外がスローされない場合、または異なる型の例外がスローされた場合、テストは失敗します。

**パラメータ**:
- `errorType`: 期待される例外の型
- `code`: 実行されるコードブロック

**例**:

```nim
expectError(ValueError):
  discard parseInt("not_a_number")
```

### check

```nim
template check*(condition: untyped): untyped
```

unittest モジュールの`check`テンプレートを上書きして、PowerAssertの詳細なエラーメッセージを提供します。

**パラメータ**:
- `condition`: 評価する条件式

**例**:

```nim
import unittest
import power_assert

test "値の検証":
  let value = 42
  check(value == 42)  # PowerAssertの詳細出力を使用
```

### formatValue

```nim
proc formatValue*[T](val: T): string
```

任意の型の値を人間が読みやすい文字列形式に変換します。PowerAssertのエラーメッセージ内で値を表示するために内部的に使用されますが、直接使用することもできます。

**パラメータ**:
- `val`: フォーマットする値（任意の型）

**戻り値**:
- 値の文字列表現

**例**:

```nim
let arr = @[1, 2, 3]
echo formatValue(arr)  # 出力: "@[1, 2, 3]"

let person = Person(name: "Alice", age: 30)
echo formatValue(person)  # 出力: "Alice (30)" ($演算子の実装に依存)
```

## 内部API

### powerAssertImpl

```nim
macro powerAssertImpl*(condition: untyped): untyped
```

PowerAssertの内部実装マクロです。条件式のAST解析を実行し、式の各部分の値を抽出するためのコードを生成します。

**パラメータ**:
- `condition`: 評価する条件式

**戻り値**:
- 変換された式のAST

**注意**: これは内部使用を意図したAPIであり、直接使用することは推奨されません。

### renderExpression

```nim
proc renderExpression*(exprStr: string, values: seq[ExpressionInfo]): string
```

式の文字列表現と値情報のリストから、詳細な可視化された出力を生成します。

**パラメータ**:
- `exprStr`: 式の文字列表現
- `values`: 式の各部分の値情報

**戻り値**:
- フォーマットされた式の表示

**例**:

```nim
let values = @[
  ExpressionInfo(code: "a", value: "5", typeName: "int", column: 0),
  ExpressionInfo(code: "b", value: "10", typeName: "int", column: 4),
  ExpressionInfo(code: "a + b", value: "15", typeName: "int", column: 0)
]
let output = renderExpression("a + b == 15", values)
echo output
```

### ExpressionInfo

```nim
type ExpressionInfo* = object
  code*: string        # 式の部分の元のコード
  value*: string       # 評価された値の文字列表現
  typeName*: string    # 値の型名
  column*: int         # 元の式内の列位置
```

式の部分とその評価結果に関する情報を保持する構造体です。

### PowerAssertDefect

```nim
type PowerAssertDefect* = object of AssertionDefect
```

PowerAssertによってスローされる例外型です。標準のAssertionDefectを継承しています。