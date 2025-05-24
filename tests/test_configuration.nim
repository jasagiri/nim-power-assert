import unittest except check
import ../src/power_assert
import std/strutils

suite "Configuration Tests":
  setup:
    setOutputFormat(PowerAssertJS)
    resetTestStats()
  
  test "Output format configuration":
    unittest.check getOutputFormat() == PowerAssertJS
    
    setOutputFormat(Compact)
    unittest.check getOutputFormat() == Compact
    
    setOutputFormat(Detailed)
    unittest.check getOutputFormat() == Detailed
    
    setOutputFormat(Classic)
    unittest.check getOutputFormat() == Classic
    
    setOutputFormat(PowerAssertJS)
    unittest.check getOutputFormat() == PowerAssertJS
  
  test "Configuration persists across assertions":
    setOutputFormat(Compact)
    
    let x = 5
    powerAssert(x == 5)
    
    unittest.check getOutputFormat() == Compact
    
    powerAssert(x > 0)
    
    unittest.check getOutputFormat() == Compact
  
  test "Output format affects assertion output":
    let x = 10
    let y = 20
    
    setOutputFormat(PowerAssertJS)
    try:
      powerAssert(x > y)
    except PowerAssertDefect as e:
      unittest.check "|" in e.msg
    
    setOutputFormat(Compact)
    try:
      powerAssert(x > y)
    except PowerAssertDefect as e:
      unittest.check "|" notin e.msg
      unittest.check "x=10" in e.msg
      unittest.check "y=20" in e.msg
    
    setOutputFormat(Detailed)
    try:
      powerAssert(x > y)
    except PowerAssertDefect as e:
      unittest.check "Expression:" in e.msg
      unittest.check "Result:" in e.msg
      unittest.check "Values:" in e.msg
    
    setOutputFormat(Classic)
    try:
      powerAssert(x > y)
    except PowerAssertDefect as e:
      unittest.check "^" in e.msg
  
  test "Default configuration values":
    setOutputFormat(PowerAssertJS)
    resetTestStats()
    
    unittest.check getOutputFormat() == PowerAssertJS
    
    let stats = getTestStats()
    unittest.check stats.passed == 0
    unittest.check stats.failed == 0
    unittest.check stats.skipped == 0
  
  test "Configuration independence":
    setOutputFormat(Detailed)
    powerAssertWithStats(true)
    
    setOutputFormat(Compact)
    try:
      powerAssertWithStats(false)
    except PowerAssertDefect:
      discard
    
    let stats = getTestStats()
    unittest.check stats.passed == 1
    unittest.check stats.failed == 1
    
    unittest.check getOutputFormat() == Compact
  
  test "Format names as strings":
    setOutputFormat(PowerAssertJS)
    unittest.check $getOutputFormat() == "PowerAssertJS"
    
    setOutputFormat(Compact)
    unittest.check $getOutputFormat() == "Compact"
    
    setOutputFormat(Detailed)
    unittest.check $getOutputFormat() == "Detailed"
    
    setOutputFormat(Classic)
    unittest.check $getOutputFormat() == "Classic"
  
  test "Format switching during test execution":
    var hasUniqueOutputs = true
    var outputs: seq[string] = @[]
    
    for format in [PowerAssertJS, Compact, Detailed, Classic]:
      setOutputFormat(format)
      try:
        let a = 1
        let b = 2
        powerAssert(a > b)
      except PowerAssertDefect as e:
        outputs.add(e.msg)
    
    # 各フォーマットが異なる出力を生成することを確認
    unittest.check outputs.len == 4
    for i in 0..<outputs.len:
      for j in (i+1)..<outputs.len:
        if outputs[i] == outputs[j]:
          hasUniqueOutputs = false
    unittest.check hasUniqueOutputs
    
    # PowerAssertJS には | が含まれる
    unittest.check "|" in outputs[0]
    # Compact には = が含まれる
    unittest.check "a=1" in outputs[1]
    # Detailed には Expression: が含まれる
    unittest.check "Expression:" in outputs[2]
    # Classic には ^ が含まれる
    unittest.check "^" in outputs[3]