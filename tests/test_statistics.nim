import unittest except check
import ../src/power_assert
import std/strutils

suite "Test Statistics":
  setup:
    resetTestStats()
  
  test "Basic statistics tracking":
    powerAssertWithStats(2 + 2 == 4)
    
    try:
      powerAssertWithStats(3 + 3 == 7)
    except PowerAssertDefect:
      discard
    
    skipTest("Test skipped for demo")
    
    let stats = getTestStats()
    unittest.check stats.passed == 1
    unittest.check stats.failed == 1
    unittest.check stats.skipped == 1
  
  test "Reset statistics":
    powerAssertWithStats(true)
    
    try:
      powerAssertWithStats(false)
    except PowerAssertDefect:
      discard
    
    let stats1 = getTestStats()
    unittest.check stats1.passed == 1
    unittest.check stats1.failed == 1
    unittest.check stats1.skipped == 0
    
    resetTestStats()
    
    let stats2 = getTestStats()
    unittest.check stats2.passed == 0
    unittest.check stats2.failed == 0
    unittest.check stats2.skipped == 0
  
  test "Multiple passed tests":
    for i in 1..5:
      powerAssertWithStats(i > 0)
    
    let stats = getTestStats()
    unittest.check stats.passed == 5
    unittest.check stats.failed == 0
    unittest.check stats.skipped == 0
  
  test "Multiple failed tests":
    for i in 1..3:
      try:
        powerAssertWithStats(i < 0)
      except PowerAssertDefect:
        discard
    
    let stats = getTestStats()
    unittest.check stats.passed == 0
    unittest.check stats.failed == 3
    unittest.check stats.skipped == 0
  
  test "Mixed test results":
    powerAssertWithStats(1 == 1)
    
    try:
      powerAssertWithStats(2 == 3)
    except PowerAssertDefect:
      discard
    
    powerAssertWithStats(true)
    
    try:
      powerAssertWithStats(false)
    except PowerAssertDefect:
      discard
    
    skipTest("Skip 1")
    skipTest("Skip 2")
    
    let stats = getTestStats()
    unittest.check stats.passed == 2
    unittest.check stats.failed == 2
    unittest.check stats.skipped == 2
  
  test "Test summary output verification":
    resetTestStats()
    powerAssertWithStats(true)
    
    try:
      powerAssertWithStats(false)
    except PowerAssertDefect:
      discard
    
    skipTest("Skipped test")
    
    # Use printTestSummary and verify it runs without error
    printTestSummary()
    
    let stats = getTestStats()
    unittest.check stats.passed == 1
    unittest.check stats.failed == 1
    unittest.check stats.skipped == 1
    unittest.check stats.total == 3
  
  test "Test summary with all passed":
    resetTestStats()
    for i in 1..5:
      powerAssertWithStats(true)
    
    printTestSummary()
    
    let stats = getTestStats()
    unittest.check stats.passed == 5
    unittest.check stats.failed == 0
    unittest.check stats.skipped == 0
    unittest.check stats.total == 5
  
  test "Test summary with no tests":
    resetTestStats()
    
    printTestSummary()
    
    let stats = getTestStats()
    unittest.check stats.passed == 0
    unittest.check stats.failed == 0
    unittest.check stats.skipped == 0
    unittest.check stats.total == 0
  
  test "Statistics with actual assertions":
    resetTestStats()
    
    let x = 10
    let y = 20
    
    powerAssertWithStats(x < y)
    
    try:
      powerAssertWithStats(x > y)
    except PowerAssertDefect:
      discard
    
    try:
      powerAssertWithStats(x == y)
    except PowerAssertDefect:
      discard
    
    let stats = getTestStats()
    unittest.check stats.passed == 1
    unittest.check stats.failed == 2
    unittest.check stats.skipped == 0
  
  test "Statistics persist across multiple calls":
    resetTestStats()
    
    powerAssertWithStats(true)
    let stats1 = getTestStats()
    unittest.check stats1.passed == 1
    
    try:
      powerAssertWithStats(false)
    except PowerAssertDefect:
      discard
    
    let stats2 = getTestStats()
    unittest.check stats2.passed == 1
    unittest.check stats2.failed == 1
    
    skipTest("Skip test")
    let stats3 = getTestStats()
    unittest.check stats3.passed == 1
    unittest.check stats3.failed == 1
    unittest.check stats3.skipped == 1
  
  test "Test summary with many failures":
    resetTestStats()
    
    for i in 1..10:
      if i mod 3 == 0:
        powerAssertWithStats(true)
      else:
        try:
          powerAssertWithStats(false)
        except PowerAssertDefect:
          discard
    
    printTestSummary()
    
    let stats = getTestStats()
    unittest.check stats.passed == 3
    unittest.check stats.failed == 7
    unittest.check stats.total == 10