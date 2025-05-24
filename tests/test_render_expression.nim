import unittest except check
import ../src/power_assert
import std/strutils

suite "Expression Rendering Tests":
  test "PowerAssert generates readable output":
    try:
      let a = 5
      let b = 10
      powerAssert(a == b)
    except PowerAssertDefect as e:
      unittest.check "a == b" in e.msg
      unittest.check "5" in e.msg
      unittest.check "10" in e.msg
  
  test "Complex expression output":
    try:
      let x = 2
      let y = 3
      let z = 4
      powerAssert((x + y) * z == 25)
    except PowerAssertDefect as e:
      unittest.check "(x + y) * z == 25" in e.msg
      unittest.check "2" in e.msg
      unittest.check "3" in e.msg
      unittest.check "4" in e.msg
  
  test "Nested function call output":
    proc double(n: int): int = n * 2
    proc addNumbers(a, b: int): int = a + b
    
    try:
      let val = 5
      powerAssert(double(val) == addNumbers(val, 20))
    except PowerAssertDefect as e:
      unittest.check "double(val) == addNumbers(val, 20)" in e.msg
      unittest.check "5" in e.msg
      unittest.check "10" in e.msg
      unittest.check "25" in e.msg
  
  test "Array access expression output":
    try:
      let arr = [10, 20, 30]
      let idx = 1
      powerAssert(arr[idx] == 30)
    except PowerAssertDefect as e:
      unittest.check "arr[idx] == 30" in e.msg
      unittest.check "20" in e.msg
      unittest.check "30" in e.msg
  
  test "String comparison output":
    try:
      let name = "Alice"
      let expected = "Bob"
      powerAssert(name == expected)
    except PowerAssertDefect as e:
      unittest.check "name == expected" in e.msg
      unittest.check "Alice" in e.msg
      unittest.check "Bob" in e.msg
  
  test "Boolean expression output":
    try:
      let flag1 = true
      let flag2 = false
      powerAssert(flag1 and flag2)
    except PowerAssertDefect as e:
      unittest.check "flag1 and flag2" in e.msg
      unittest.check "true" in e.msg
      unittest.check "false" in e.msg
  
  test "Output format consistency":
    # Test that different output formats work
    setOutputFormat(PowerAssertJS)
    try:
      let a = 1
      let b = 2
      powerAssert(a > b)
    except PowerAssertDefect as e:
      unittest.check "|" in e.msg  # PowerAssertJS style
    
    setOutputFormat(Compact)
    try:
      let a = 1
      let b = 2
      powerAssert(a > b)
    except PowerAssertDefect as e:
      unittest.check "a=1" in e.msg  # Compact style
    
    setOutputFormat(PowerAssertJS)  # Reset to default