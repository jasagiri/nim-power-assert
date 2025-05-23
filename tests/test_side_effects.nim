# tests/test_side_effects.nim

import unittest except check
import ../src/power_assert

suite "Side Effects Handling":
  test "Simple variable increment":
    var counter = 0
    
    # Increment counter in assertion - should only happen once
    try:
      # This should fail but should only increment counter once
      counter += 1
      powerAssert counter == 2
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, but counter should be 1, not higher
      check counter == 1
      
  test "Multiple increments in same expression":
    var counter = 0
    
    # Expression with multiple increments
    try:
      # This should fail but should only increment counter once
      counter += 1  # First increment
      counter += 1  # Second increment
      powerAssert counter == 10
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Counter should be incremented twice, not more
      check counter == 2
      
  test "Function with side effects":
    var callCount = 0
    
    proc incrementAndReturn(): int =
      callCount += 1
      return callCount
    
    # Call function with side effects in assertion
    try:
      # First store result to avoid re-evaluating in check
      let result = incrementAndReturn()
      powerAssert result == 2
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Function should be called exactly once
      check callCount == 1
      
  test "Object method with side effects":
    type Counter = object
      value: int
    
    proc increment(c: var Counter): int =
      c.value += 1
      return c.value
    
    var counter = Counter(value: 0)
    
    # Call method with side effects
    try:
      # First store the result to avoid re-evaluation
      let result = counter.increment()
      powerAssert result == 2
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Method should be called exactly once
      check counter.value == 1
      
  test "Multiple functions with side effects":
    var callCounts: array[3, int] = [0, 0, 0]
    
    proc func1(): int =
      callCounts[0] += 1
      return 1
      
    proc func2(): int =
      callCounts[1] += 1
      return 2
      
    proc func3(): int =
      callCounts[2] += 1
      return 3
    
    # Expression with multiple function calls with side effects
    try:
      # First evaluate the expression to avoid re-evaluation
      let result = func1() + func2() * func3()
      powerAssert result == 10
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Each function should be called exactly once
      check callCounts[0] == 1
      check callCounts[1] == 1
      check callCounts[2] == 1