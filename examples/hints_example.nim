# Hints Example
# Demonstrates PowerAssert's Rust-like helpful error messages with fix suggestions

import ../src/power_assert
import std/[strutils, strformat]

proc demonstrateTypeMismatchHints() =
  echo "=== Type Mismatch Hints ==="
  
  # Different numeric types (converted for comparison)
  let intValue = 42
  let floatValue = 42.5
  
  echo "1. Comparing converted int with float:"
  try:
    powerAssert(float(intValue) == floatValue)
  except PowerAssertDefect as e:
    echo e.msg
  
  # String number parsing issue
  let stringNumber = "42a"  # Invalid format
  
  echo "2. String parsing issue:"
  try:
    let parsed = parseInt(stringNumber)
    powerAssert(parsed == 42)
  except ValueError:
    echo "ValueError: String cannot be parsed as integer"
    echo "hint: Check the string format - it may contain non-numeric characters"
  except PowerAssertDefect as e:
    echo e.msg

proc demonstrateCommonMistakeHints() =
  echo "=== Common Mistake Hints ==="
  
  # This would show assignment vs comparison hint if it were valid syntax
  echo "Note: Assignment vs comparison detection would show in more complex cases"

proc demonstrateBooleanLogicHints() =
  echo "=== Boolean Logic Hints ==="
  
  let isActive = false
  let hasPermission = false
  let score = 75
  let threshold = 80
  
  echo "1. Boolean AND failure:"
  try:
    powerAssert(isActive and hasPermission)
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "2. Boolean OR failure:"
  try:
    powerAssert(isActive or (score > threshold))
  except PowerAssertDefect as e:
    echo e.msg

proc demonstrateStringComparisonHints() =
  echo "=== String Comparison Hints ==="
  
  let actual = "Hello World"
  let expected = "hello world"
  
  echo "1. Case difference hint:"
  try:
    powerAssert(actual == expected)
  except PowerAssertDefect as e:
    echo e.msg
  
  let withSpaces = "Hello World "
  let withoutSpaces = "Hello World"
  
  echo "2. Length difference hint:"
  try:
    powerAssert(withSpaces == withoutSpaces)
  except PowerAssertDefect as e:
    echo e.msg

proc demonstrateCollectionHints() =
  echo "=== Collection Hints ==="
  
  let emptyArray: seq[int] = @[]
  let expectedLength = 3
  
  echo "1. Empty collection hint:"
  try:
    powerAssert(emptyArray.len == expectedLength)
  except PowerAssertDefect as e:
    echo e.msg

proc demonstrateNilValueHints() =
  echo "=== Nil Value Hints ==="
  
  var nullableString: string
  let expectedValue = "test"
  
  echo "1. Nil/uninitialized value hint:"
  try:
    powerAssert(nullableString == expectedValue)
  except PowerAssertDefect as e:
    echo e.msg

proc demonstrateComplexHints() =
  echo "=== Complex Expression Hints ==="
  
  type User = object
    name: string
    age: int
    isActive: bool
  
  proc `$`(u: User): string =
    fmt"User(name: {u.name}, age: {u.age}, active: {u.isActive})"
  
  let user = User(name: "Alice", age: 25, isActive: false)
  let requiredAge = 18
  let adminRequired = true
  
  echo "1. Complex business logic with hints:"
  try:
    powerAssert(user.isActive and user.age >= requiredAge and adminRequired)
  except PowerAssertDefect as e:
    echo e.msg

when isMainModule:
  echo "PowerAssert Helpful Hints Examples"
  echo "================================="
  echo "Demonstrating Rust-like error messages with fix suggestions"
  echo ""
  
  demonstrateTypeMismatchHints()
  demonstrateCommonMistakeHints()  
  demonstrateBooleanLogicHints()
  demonstrateStringComparisonHints()
  demonstrateCollectionHints()
  demonstrateNilValueHints()
  demonstrateComplexHints()
  
  echo ""
  echo "Key features of the hint system:"
  echo "- Type mismatch detection and conversion suggestions"
  echo "- Common mistake identification (like = vs ==)"
  echo "- Boolean logic guidance"
  echo "- String comparison analysis"
  echo "- Collection state insights"
  echo "- Nil/null value detection"
  echo "- Context-aware suggestions"