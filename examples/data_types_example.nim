# Data Types Example
# Demonstrates PowerAssert with various Nim data types

import ../src/power_assert
import std/options

proc demonstrateNumericTypes() =
  echo "=== Numeric Types ==="
  
  let intVal = 42
  let floatVal = 3.14159
  let ratioVal = 22/7
  
  # Helper functions for numeric comparisons
  proc intEquals(a, b: int): bool = a == b
  proc floatGreater(a, b: float): bool = a > b
  proc floatsEqual(a, b: float): bool = a == b
  
  try:
    powerAssert(intEquals(intVal, 50))
  except PowerAssertDefect as e:
    echo "Integer assertion failure:"
    echo e.msg
  
  try:
    powerAssert(floatGreater(floatVal, 4.0))
  except PowerAssertDefect as e:
    echo "\nFloat assertion failure:"
    echo e.msg
  
  try:
    powerAssert(floatsEqual(ratioVal, floatVal))
  except PowerAssertDefect as e:
    echo "\nRatio comparison failure:"
    echo e.msg

proc demonstrateCollectionTypes() =
  echo "\n=== Collection Types ==="
  
  let sequence = @[1, 2, 3, 4, 5]
  let array = [10, 20, 30]
  let text = "Hello World"
  
  # Helper functions for collection operations
  proc seqLenEquals(s: seq[int], expected: int): bool = s.len == expected
  proc arrayElementEquals(arr: array[3, int], index: int, expected: int): bool = arr[index] == expected
  proc stringSliceEquals(s: string, start, stop: int, expected: string): bool = s[start..stop] == expected
  
  try:
    powerAssert(seqLenEquals(sequence, 3))
  except PowerAssertDefect as e:
    echo "Sequence length assertion failure:"
    echo e.msg
  
  try:
    powerAssert(arrayElementEquals(array, 1, 25))
  except PowerAssertDefect as e:
    echo "\nArray element assertion failure:"
    echo e.msg
  
  try:
    powerAssert(stringSliceEquals(text, 0, 4, "Hi"))
  except PowerAssertDefect as e:
    echo "\nString slice assertion failure:"
    echo e.msg

proc demonstrateBooleanLogic() =
  echo "\n=== Boolean Logic ==="
  
  let isActive = true
  let isComplete = false
  let count = 5
  
  # Helper functions for boolean logic
  proc boolAnd(a, b: bool): bool = a and b
  proc complexBoolLogic(active: bool, countVal: int): bool = 
    (not active) or (countVal < 3)
  
  try:
    powerAssert(boolAnd(isActive, isComplete))
  except PowerAssertDefect as e:
    echo "Boolean AND assertion failure:"
    echo e.msg
  
  try:
    powerAssert(complexBoolLogic(isActive, count))
  except PowerAssertDefect as e:
    echo "\nComplex boolean assertion failure:"
    echo e.msg

proc demonstrateOptionTypes() =
  echo "\n=== Option Types ==="
  
  let someValue = some(42)
  let noneValue: Option[int] = none(int)
  
  # Helper functions for option operations
  proc bothOptionsSome(a, b: Option[int]): bool = a.isSome and b.isSome
  proc optionValueEquals(opt: Option[int], expected: int): bool = 
    if opt.isSome: opt.get() == expected else: false
  
  try:
    powerAssert(bothOptionsSome(someValue, noneValue))
  except PowerAssertDefect as e:
    echo "Option assertion failure:"
    echo e.msg
  
  try:
    powerAssert(optionValueEquals(someValue, 50))
  except PowerAssertDefect as e:
    echo "\nOption value assertion failure:"
    echo e.msg

when isMainModule:
  echo "PowerAssert Data Types Examples"
  echo "=============================="
  
  demonstrateNumericTypes()
  demonstrateCollectionTypes()
  demonstrateBooleanLogic()
  demonstrateOptionTypes()
  
  echo "\nData types examples completed!"