import unittest except check
import ../src/power_assert
import std/strutils

suite "Output Format Tests":
  setup:
    resetTestStats()
  
  test "PowerAssertJS format (default)":
    setOutputFormat(PowerAssertJS)
    unittest.check getOutputFormat() == PowerAssertJS
    
    # PowerAssertJS format should show pipe characters and values
    try:
      let x = 10
      let y = 5
      powerAssert(x > y + 10)
    except PowerAssertDefect as e:
      let msg = e.msg
      unittest.check "x > y + 10" in msg
      unittest.check "|" in msg
      unittest.check "10" in msg
      unittest.check "5" in msg
  
  test "Compact format":
    setOutputFormat(Compact)
    unittest.check getOutputFormat() == Compact
    
    try:
      let x = 10
      let y = 5
      powerAssert(x > y + 10)
    except PowerAssertDefect as e:
      let msg = e.msg
      unittest.check "x > y + 10" in msg
      unittest.check "x=10" in msg
      unittest.check "y=5" in msg
      unittest.check "y + 10=15" in msg
      unittest.check "|" notin msg
  
  test "Detailed format":
    setOutputFormat(Detailed)
    unittest.check getOutputFormat() == Detailed
    
    try:
      let x = 10
      let y = 5
      powerAssert(x > y + 10)
    except PowerAssertDefect as e:
      let msg = e.msg
      unittest.check "Expression: x > y + 10" in msg
      unittest.check "Values:" in msg
      unittest.check "x" in msg and "= 10" in msg
      unittest.check "y" in msg and "= 5" in msg
      unittest.check "y + 10" in msg and "= 15" in msg
  
  test "Classic format":
    setOutputFormat(Classic)
    unittest.check getOutputFormat() == Classic
    
    try:
      let x = 10
      let y = 5
      powerAssert(x > y + 10)
    except PowerAssertDefect as e:
      let msg = e.msg
      unittest.check "x > y + 10" in msg
      unittest.check "^" in msg
      unittest.check "x => 10" in msg
      unittest.check "y => 5" in msg
      unittest.check "y + 10 => 15" in msg
  
  test "Format switching at runtime":
    setOutputFormat(PowerAssertJS)
    unittest.check getOutputFormat() == PowerAssertJS
    
    setOutputFormat(Compact)
    unittest.check getOutputFormat() == Compact
    
    setOutputFormat(Detailed)
    unittest.check getOutputFormat() == Detailed
    
    setOutputFormat(Classic)
    unittest.check getOutputFormat() == Classic
  
  test "PowerAssertJS with complex expressions":
    setOutputFormat(PowerAssertJS)
    
    try:
      let a = 5
      let b = 10
      let c = 15
      powerAssert((a + b) * 2 == c + 20)
    except PowerAssertDefect as e:
      let msg = e.msg
      unittest.check "(a + b) * 2 == c + 20" in msg
      unittest.check "|" in msg
  
  test "PowerAssertJS with nested function calls":
    setOutputFormat(PowerAssertJS)
    
    proc double(x: int): int = x * 2
    proc addNumbers(x, y: int): int = x + y
    
    try:
      let x = 5
      powerAssert(double(x) == addNumbers(x, 10))
    except PowerAssertDefect as e:
      let msg = e.msg
      unittest.check "double(x) == addNumbers(x, 10)" in msg
      unittest.check "|" in msg
  
  test "Compact format with custom message":
    setOutputFormat(Compact)
    
    try:
      let x = 10
      let y = 20
      powerAssert(x > y, "x should be greater than y")
    except PowerAssertDefect as e:
      let msg = e.msg
      unittest.check "x should be greater than y" in msg
      unittest.check "x > y" in msg
      unittest.check "x=10" in msg
      unittest.check "y=20" in msg
  
  test "Detailed format with sequences":
    setOutputFormat(Detailed)
    
    try:
      let arr1 = @[1, 2, 3]
      let arr2 = @[1, 2, 4]
      powerAssert(arr1 == arr2)
    except PowerAssertDefect as e:
      let msg = e.msg
      unittest.check "Expression: arr1 == arr2" in msg
      unittest.check "Values:" in msg
      unittest.check "arr1" in msg
      unittest.check "@[1, 2, 3]" in msg
      unittest.check "arr2" in msg
      unittest.check "@[1, 2, 4]" in msg
  
  test "Classic format with logical operators":
    setOutputFormat(Classic)
    
    try:
      let a = true
      let b = false
      let c = true
      powerAssert(a and b or not c)
    except PowerAssertDefect as e:
      let msg = e.msg
      unittest.check "a and b or not c" in msg
      unittest.check "^" in msg
      unittest.check "a => true" in msg
      unittest.check "b => false" in msg
      unittest.check "c => true" in msg
  
  test "All formats produce output for same expression":
    let formats = [PowerAssertJS, Compact, Detailed, Classic]
    
    for format in formats:
      setOutputFormat(format)
      try:
        let x = 42
        powerAssert(x == 100)
      except PowerAssertDefect as e:
        unittest.check e.msg.len > 0
        unittest.check "42" in e.msg
        unittest.check "100" in e.msg