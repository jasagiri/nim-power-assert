## Test Statistics Demo
## ====================
##
## A simple demonstration of PowerAssert's test statistics feature

import ../src/power_assert
import strutils

when isMainModule:
  echo "PowerAssert Test Statistics Demo"
  echo "================================\n"
  
  # Reset statistics at the start
  resetTestStats()
  
  # Test 1: Basic math (pass)
  echo "Test 1: Addition"
  powerAssertWithStats(2 + 2 == 4)
  echo "✓ Passed\n"
  
  # Test 2: Comparison (fail)
  echo "Test 2: Greater than check"
  try:
    powerAssertWithStats(5 > 10, "Five should be greater than ten")
  except PowerAssertDefect as e:
    echo e.msg
  echo ""
  
  # Test 3: Boolean (pass)
  echo "Test 3: Boolean logic"
  let isReady = true
  let isEnabled = true
  powerAssertWithStats(isReady and isEnabled)
  echo "✓ Passed\n"
  
  # Test 4: Skip a test
  echo "Test 4: Advanced feature"
  when defined(advancedMode):
    powerAssertWithStats(true)
  else:
    skipTest("Advanced mode not enabled")
  echo ""
  
  # Test 5: Another failure
  echo "Test 5: Equality check"
  let expected = 42
  let actual = 40
  try:
    powerAssertWithStats(actual == expected)
  except PowerAssertDefect as e:
    echo e.msg
  echo ""
  
  # Test 6: Pass with different format
  echo "Test 6: Using compact format"
  setOutputFormat(Compact)
  powerAssertWithStats(100 > 50)
  echo "✓ Passed (compact format)\n"
  
  # Reset to default format
  setOutputFormat(PowerAssertJS)
  
  # Print the test summary
  echo "=".repeat(60)
  printTestSummary()
  echo "=".repeat(60)
  
  # Show how to access statistics programmatically
  echo "\nAccessing statistics programmatically:"
  let stats = getTestStats()
  echo "• Total tests: ", stats.total
  echo "• Pass rate: ", 
    if stats.total > 0: 
      formatFloat(stats.passed.float / stats.total.float * 100, ffDecimal, 1) & "%"
    else: 
      "N/A"
  
  # Demonstrate manual recording
  echo "\n\nManual test recording:"
  echo "Recording 2 more passed tests..."
  recordPassed()
  recordPassed()
  
  echo "\nUpdated summary:"
  echo "-".repeat(40)
  printTestSummary()
  
  echo "\n\nKey Points:"
  echo "• Use powerAssertWithStats() to track test results"
  echo "• Call printTestSummary() to see PASSED/FAILED/SKIPPED counts"
  echo "• Use skipTest() to mark tests as skipped"
  echo "• Access stats with getTestStats() for custom reporting"