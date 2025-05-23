# tests/test_nested_expressions.nim

import unittest except check
import ../src/power_assert
import options, tables, sequtils, strutils

suite "Deeply Nested Expressions":
  test "Basic nested expressions":
    let a = 5
    let b = 10
    let c = 15
    
    try:
      # Deeply nested expression with parentheses
      powerAssert (((a + b) * c) - ((a * b) + c)) == 100
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Nested function calls":
    proc f1(x: int): int = x * 2
    proc f2(x: int): int = x + 10
    proc f3(x: int): int = x - 5
    
    try:
      # Nested function calls
      powerAssert f1(f2(f3(10))) == 40
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Nested collection operations":
    let numbers = @[@[1, 2, 3], @[4, 5, 6], @[7, 8, 9]]
    
    try:
      # Nested collection indexing with operations
      powerAssert numbers[1][2] + numbers[0][1] == 10
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Nested options with flatMap":
    let optA = some(5)
    let optB = some(10)
    
    try:
      # Nested option mapping
      powerAssert optA.map(proc(a: int): Option[int] = optB.map(proc(b: int): int = a + b)).flatten().get() == 20
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Nested table operations":
    var nestedTable = {
      "level1": {"a": 1, "b": 2}.toTable,
      "level2": {"c": 3, "d": 4}.toTable
    }.toTable
    
    try:
      # Nested table access
      powerAssert nestedTable["level1"]["a"] + nestedTable["level2"]["d"] == 10
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Nested object field access":
    type
      Inner = object
        x: int
        y: int
      Middle = object
        name: string
        inner: Inner
      Outer = object
        id: int
        middle: Middle
    
    let obj = Outer(
      id: 1,
      middle: Middle(
        name: "test",
        inner: Inner(
          x: 10,
          y: 20
        )
      )
    )
    
    try:
      # Deeply nested field access
      powerAssert obj.middle.inner.x + obj.middle.inner.y == 50
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Nested expressions with different types":
    let a = 5
    let s = "test"
    let f = 2.5
    
    try:
      # Nested expressions with type conversions
      powerAssert (a.float * f).int.toHex(5).len == s.len + 2
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Nested iterator expressions":
    let matrix = @[@[1, 2, 3], @[4, 5, 6], @[7, 8, 9]]
    
    try:
      # Nested sequences with complex mapping
      powerAssert matrix.mapIt(it.filterIt(it mod 2 == 0).mapIt(it * 2)).mapIt(it.len) == @[1, 1, 1]
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Conditional nested expressions":
    let a = 10
    let b = 5
    
    try:
      # Nested expressions with conditionals
      powerAssert (if a > b: a + b else: a - b) * 2 == 10
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Extremely deep nesting":
    let x = 2
    
    try:
      # Extremely deep nesting
      powerAssert (((((((x + 1) * 2) - 1) / 1) + 2) * 3) - 4) == 20
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true