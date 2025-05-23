## Test Statistics Example
## =======================
##
## This example demonstrates how to use PowerAssert's test statistics
## tracking feature to get detailed test results with PASSED/FAILED/SKIPPED counts.

import ../src/power_assert
import strutils

proc runMathTests() =
  echo "Math Tests"
  echo "=========="
  
  # Test 1: Basic arithmetic
  echo "Test 1.1: Addition"
  powerAssertWithStats(2 + 2 == 4)
  echo "✓ Passed"
  
  echo "\nTest 1.2: Multiplication"
  powerAssertWithStats(3 * 4 == 12)
  echo "✓ Passed"
  
  echo "\nTest 1.3: Division (will fail)"
  try:
    powerAssertWithStats(10 div 3 == 4, "Integer division should round down")
  except PowerAssertDefect as e:
    echo e.msg

proc runStringTests() =
  echo "\n\nString Tests"
  echo "============"
  
  let hello = "Hello"
  let world = "World"
  
  echo "Test 2.1: String concatenation"
  powerAssertWithStats(hello & " " & world == "Hello World")
  echo "✓ Passed"
  
  echo "\nTest 2.2: String length (will fail)"
  try:
    powerAssertWithStats(hello.len == 6)
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "\nTest 2.3: String comparison"
  powerAssertWithStats(hello < world)  # "H" < "W"
  echo "✓ Passed"

proc runConditionalTests() =
  echo "\n\nConditional Tests"
  echo "================="
  
  echo "Test 3.1: Complex boolean"
  let x = 10
  let y = 20
  let z = 30
  powerAssertWithStats((x < y) and (y < z))
  echo "✓ Passed"
  
  echo "\nTest 3.2: Feature flag test (skipped)"
  when defined(experimentalFeature):
    powerAssertWithStats(true)  # Would run if feature is enabled
  else:
    skipTest("Experimental feature not enabled")
  
  echo "\nTest 3.3: Platform-specific test"
  when defined(windows):
    skipTest("Windows-specific test skipped on this platform")
  elif defined(linux):
    skipTest("Linux-specific test skipped on this platform")
  else:
    # Run on other platforms
    powerAssertWithStats(true)
    echo "✓ Passed (platform: other)"

proc demonstrateFormats() =
  echo "\n\nDifferent Output Formats"
  echo "========================"
  
  let a = 42
  let b = 100
  
  echo "\nTest 4.1: PowerAssertJS format (default)"
  try:
    powerAssertWithStats(a > b)
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "\nTest 4.2: Compact format"
  setOutputFormat(Compact)
  try:
    powerAssertWithStats(a == b)
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "\nTest 4.3: Detailed format"
  setOutputFormat(Detailed)
  try:
    powerAssertWithStats(a + 58 == b - 1)
  except PowerAssertDefect as e:
    echo e.msg
  
  # Reset to default
  setOutputFormat(PowerAssertJS)

proc demonstrateDirectAPI() =
  echo "\n\nDirect Statistics API"
  echo "===================="
  
  # Save current stats
  let beforeStats = getTestStats()
  echo "Stats before manual operations:"
  echo "  Total: ", beforeStats.total
  
  # Manually record some results
  echo "\nManually recording: 3 passed, 1 failed, 2 skipped"
  for i in 1..3:
    recordPassed()
  recordFailed()
  for i in 1..2:
    recordSkipped()
  
  let afterStats = getTestStats()
  echo "\nStats after manual operations:"
  echo "  Total: ", afterStats.total
  echo "  Difference: ", afterStats.total - beforeStats.total

when isMainModule:
  echo "PowerAssert Test Statistics Example"
  echo "===================================\n"
  
  # Reset statistics at the start
  resetTestStats()
  
  # Run different test suites
  runMathTests()
  runStringTests()
  runConditionalTests()
  demonstrateFormats()
  
  # Show final summary
  echo "\n" & "═".repeat(60)
  echo "FINAL TEST SUMMARY"
  echo "═".repeat(60)
  printTestSummary()
  echo "═".repeat(60)
  
  # Demonstrate direct API
  demonstrateDirectAPI()
  
  # Show updated summary
  echo "\n" & "═".repeat(60)
  echo "UPDATED SUMMARY (including manual records)"
  echo "═".repeat(60)
  printTestSummary()
  echo "═".repeat(60)
  
  # Show usage tips
  echo "\nUsage Tips:"
  echo "==========="
  echo "• Use `powerAssertWithStats` instead of `powerAssert` to track statistics"
  echo "• Call `resetTestStats()` to clear all counters"
  echo "• Call `printTestSummary()` to display the summary"
  echo "• Use `getTestStats()` to access statistics programmatically"
  echo "• Use `skipTest(reason)` to mark tests as skipped"
  echo "• Statistics are global and accumulate across all tests"