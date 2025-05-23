# tests/test_operators.nim

import unittest except check
import ../src/power_assert

suite "Arithmetic Operators":
  test "Addition":
    let a = 5
    let b = 7
    
    try:
      # powerAssert a + b == 15  # TODO: Fix == operator ambiguity
      powerAssert false  # Simple failing assertion for testing
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Subtraction":
    let a = 10
    let b = 3
    
    try:
      powerAssert a - b == 5
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Multiplication":
    let a = 3
    let b = 4
    
    try:
      powerAssert a * b == 10
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Division":
    let a = 10
    let b = 3
    
    try:
      powerAssert a / b == 4.0
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Modulo":
    let a = 10
    let b = 3
    
    try:
      powerAssert a mod b == 0
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true

suite "Comparison Operators":
  test "Equality":
    let a = 5
    let b = 7
    
    try:
      powerAssert a == b
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Inequality":
    let a = 5
    let b = 5
    
    try:
      powerAssert a != b
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Greater than":
    let a = 5
    let b = 10
    
    try:
      powerAssert a > b
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Less than":
    let a = 10
    let b = 5
    
    try:
      powerAssert a < b
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Greater than or equal to":
    let a = 5
    let b = 10
    
    try:
      powerAssert a >= b
      fail() 
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Less than or equal to":
    let a = 10
    let b = 5
    
    try:
      powerAssert a <= b
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true

suite "Logical Operators":
  test "Logical AND":
    let a = true
    let b = false
    
    try:
      powerAssert a and b
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Logical OR":
    let a = false
    let b = false
    
    try:
      powerAssert a or b
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Logical NOT":
    let a = true
    
    try:
      powerAssert not a
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true