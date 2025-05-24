import unittest except check
import ../src/power_assert
import std/strutils

template captureOutput(body: untyped): string =
  # Simple capture approach - just execute the body and return empty string
  # In real usage, the output would go to stdout normally
  body
  ""

suite "Unittest Integration":
  setup:
    setOutputFormat(PowerAssertJS)
    resetTestStats()
  
  test "PowerAssert works alongside unittest":
    let x = 10
    let y = 20
    
    powerAssert x < y
    unittest.check x < y
    
    powerAssert x == 10
    unittest.check x == 10
  
  test "PowerAssert with unittest expect":
    let a = 5
    let b = 10
    
    expect PowerAssertDefect:
      powerAssert a > b
  
  test "Mixed assertions in same test":
    let values = @[1, 2, 3, 4, 5]
    
    powerAssert values.len == 5
    unittest.check values[0] == 1
    
    powerAssert 3 in values
    unittest.check values[4] == 5
    
    powerAssert values[2] == 3
  
  test "PowerAssert with unittest setup/teardown":
    var testValue = 0
    
    proc setup() =
      testValue = 42
    
    proc teardown() =
      testValue = 0
    
    setup()
    powerAssert testValue == 42
    unittest.check testValue == 42
    teardown()
    powerAssert testValue == 0
  
  test "Exception handling compatibility":
    proc riskyOperation(): int =
      raise newException(ValueError, "Test error")
    
    expect ValueError:
      let result = riskyOperation()
      powerAssert result > 0
  
  test "PowerAssert with unittest's require":
    let critical = true
    
    powerAssert critical
    unittest.require critical
    
    powerAssert true
  
  test "Statistics integration with unittest":
    powerAssertWithStats(1 == 1)
    unittest.check 1 == 1
    
    try:
      powerAssertWithStats(2 < 1)
    except PowerAssertDefect:
      discard
    
    let stats = getTestStats()
    unittest.check stats.passed == 1
    unittest.check stats.failed == 1
    unittest.check stats.skipped == 0
  
  test "Output format compatibility":
    setOutputFormat(Compact)
    let output1 = captureOutput:
      powerAssert 5 > 3
    unittest.check "5 > 3" in output1
    
    setOutputFormat(PowerAssertJS)
    let output2 = captureOutput:
      powerAssert 5 > 3
    unittest.check "|" in output2
  
  test "Custom messages work with both":
    let value = 100
    
    powerAssert value > 50, "Value should be greater than 50"
    unittest.check value > 50
    
    powerAssert value == 100, "Value should be exactly 100"
    unittest.check value == 100
  
  test "Complex expressions in both systems":
    let arr1 = @[1, 2, 3]
    let arr2 = @[1, 2, 3]
    
    powerAssert arr1 == arr2
    unittest.check arr1 == arr2
    
    powerAssert arr1.len == arr2.len
    unittest.check arr1.len == arr2.len
  
  test "Backward compatibility":
    let oldStyleTest = proc() =
      let x = 42
      powerAssert x == 42
      powerAssert x > 0
      powerAssert x < 100
    
    oldStyleTest()
    unittest.check true
  
  test "PowerAssert failure output":
    # PowerAssertの詳細な出力をテスト
    try:
      let a = 10
      let b = 20
      powerAssert a > b
      fail()  # Should not reach here
    except PowerAssertDefect as e:
      # 出力に失敗した式が含まれていることを確認
      unittest.check "a > b" in e.msg
      unittest.check "10" in e.msg
      unittest.check "20" in e.msg