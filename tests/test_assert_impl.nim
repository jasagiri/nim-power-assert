import unittest except check
import ../src/power_assert
import macros, strutils

# A simple wrapper proc for testing power assert functionality
proc testPowerAssert(cond: bool): bool =
  result = cond

suite "PowerAssert Implementation Tests":
  test "Simple literals":
    let a = 10
    check testPowerAssert(a == 10)
    
    var exceptionRaised = false
    try:
      powerAssert(a == 20)
      check false # Should not reach here
    except AssertionDefect as e:
      exceptionRaised = true
      # Verify the error message contains the expected values
      check find(e.msg, "10") >= 0
      check find(e.msg, "20") >= 0
    check exceptionRaised
  
  test "Binary operations":
    let x = 5
    let y = 10
    check testPowerAssert(x + y == 15)
    
    var exceptionRaised = false
    try:
      powerAssert(x * y == 40)
      check false # Should not reach here
    except AssertionDefect as e:
      exceptionRaised = true
      # Verify the error message contains the expected values
      check find(e.msg, "5") >= 0
      check find(e.msg, "10") >= 0
      check find(e.msg, "40") >= 0
    check exceptionRaised
  
  test "Complex expressions":
    let a = 2
    let b = 3
    let c = 4
    check testPowerAssert((a + b) * c == 20)
    
    var exceptionRaised = false
    try:
      powerAssert((a * b) + c == 10)
      check false # Should not reach here
    except AssertionDefect as e:
      exceptionRaised = true
      # Verify the error message contains the expected values
      check find(e.msg, "2") >= 0
      check find(e.msg, "3") >= 0
      check find(e.msg, "4") >= 0
      check find(e.msg, "10") >= 0
    check exceptionRaised
  
  test "Function calls":
    proc square(x: int): int = x * x
    let num = 4
    check testPowerAssert(square(num) == 16)
    
    var exceptionRaised = false
    try:
      powerAssert(square(num + 1) == 30)
      check false # Should not reach here
    except AssertionDefect as e:
      exceptionRaised = true
      # Verify the error message contains the expected values
      check find(e.msg, "4") >= 0 # might contain num
      check find(e.msg, "30") >= 0 # expected value
    check exceptionRaised
  
  test "Indexing operations":
    let arr = [10, 20, 30, 40, 50]
    let idx = 2
    check testPowerAssert(arr[idx] == 30)
    
    var exceptionRaised = false
    try:
      powerAssert(arr[idx + 1] == 30)
      check false # Should not reach here
    except AssertionDefect as e:
      exceptionRaised = true
      # Verify the error message contains the expected values
      check find(e.msg, "2") >= 0 # might contain idx
      check find(e.msg, "30") >= 0 # expected value
    check exceptionRaised