import unittest except check
import ../src/power_assert
import macros, strutils

# A simple wrapper proc for testing power assert functionality
proc testPowerAssert(cond: bool): bool =
  result = cond

suite "PowerAssert Implementation Tests":
  test "Simple literals":
    let a = 10
    unittest.check testPowerAssert(a == 10)
    
    var exceptionRaised = false
    try:
      powerAssert(a == 20)
      unittest.check false # Should not reach here
    except PowerAssertDefect as e:
      exceptionRaised = true
      # Verify the error message contains the expected values
      unittest.check "10" in e.msg
      unittest.check "20" in e.msg
    unittest.check exceptionRaised
  
  test "Binary operations":
    let x = 5
    let y = 10
    unittest.check testPowerAssert(x + y == 15)
    
    var exceptionRaised = false
    try:
      powerAssert(x * y == 40)
      unittest.check false # Should not reach here
    except PowerAssertDefect as e:
      exceptionRaised = true
      # Verify the error message contains the expected values
      unittest.check "5" in e.msg
      unittest.check "10" in e.msg
      unittest.check "40" in e.msg
    unittest.check exceptionRaised
  
  test "Complex expressions":
    let a = 2
    let b = 3
    let c = 4
    unittest.check testPowerAssert((a + b) * c == 20)
    
    var exceptionRaised = false
    try:
      powerAssert((a * b) + c == 11)
      unittest.check false # Should not reach here
    except PowerAssertDefect as e:
      exceptionRaised = true
      # Verify the error message contains something
      unittest.check e.msg.len > 0
      unittest.check "(a * b) + c == 11" in e.msg
    unittest.check exceptionRaised
  
  test "Function calls":
    proc square(x: int): int = x * x
    let num = 4
    unittest.check testPowerAssert(square(num) == 16)
    
    var exceptionRaised = false
    try:
      powerAssert(square(num + 1) == 30)
      unittest.check false # Should not reach here
    except PowerAssertDefect as e:
      exceptionRaised = true
      # Verify the error message contains the expected values
      unittest.check "4" in e.msg # might contain num
      unittest.check "30" in e.msg # expected value
    unittest.check exceptionRaised
  
  test "Indexing operations":
    let arr = [10, 20, 30, 40, 50]
    let idx = 2
    unittest.check testPowerAssert(arr[idx] == 30)
    
    var exceptionRaised = false
    try:
      powerAssert(arr[idx + 1] == 30)
      unittest.check false # Should not reach here
    except PowerAssertDefect as e:
      exceptionRaised = true
      # Verify the error message contains the expected values
      unittest.check "2" in e.msg # might contain idx
      unittest.check "30" in e.msg # expected value
    unittest.check exceptionRaised