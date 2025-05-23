import unittest except check
import ../src/power_assert
import std/strutils

suite "Error Handling Tests":
  test "Test exception raising - correct error":
    var exceptionRaised = false
    
    try:
      # This is expected to fail
      var x = 10
      var y = 0
      powerAssert(x div y > 0, "Division by zero should fail")
      check(false) # This should not be reached
    except DivByZeroDefect:
      exceptionRaised = true
    
    check(exceptionRaised)
  
  test "Test exception handling - incorrect error type":
    var correctExceptionRaised = false
    
    try:
      # Try to access an out-of-bounds index
      var arr = [1, 2, 3]
      powerAssert(arr[10] == 0, "This should raise an IndexDefect")
      check(false) # This should not be reached
    except IndexDefect:
      correctExceptionRaised = true
    except CatchableError:
      check(false) # Wrong exception type
    
    check(correctExceptionRaised)
  
  test "PowerAssertDefect should contain error details":
    var errorContainsDetails = false
    
    try:
      # This should fail with a detailed message
      let a = 10
      let b = 20
      powerAssert(a == b, "Values should be equal")
      check(false) # This should not be reached
    except PowerAssertDefect as e:
      # Check that the message contains key details
      let msg = e.msg
      errorContainsDetails = find(msg, "PowerAssert") >= 0 and 
                           find(msg, "10") >= 0 and 
                           find(msg, "20") >= 0 and
                           find(msg, "Values should be equal") >= 0
    
    check(errorContainsDetails)
  
  test "Template aliases should work the same way":
    var failures = 0
    
    # Test assert template using fully qualified name
    try:
      power_assert.assert(1 == 2)
      check(false) # This should not be reached
    except AssertionDefect:
      failures += 1
    
    # Test doAssert template
    try:
      power_assert.doAssert(1 == 2)
      check(false) # This should not be reached 
    except AssertionDefect:
      failures += 1
    
    # Test require template
    try:
      power_assert.require(1 == 2)
      check(false) # This should not be reached
    except AssertionDefect:
      failures += 1
    
    # Test powerCheck template
    try:
      power_assert.powerCheck(1 == 2)
      check(false) # This should not be reached
    except AssertionDefect:
      failures += 1
    
    # All 4 templates should have failed
    check(failures == 4)