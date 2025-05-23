## Unittest Integration with Statistics
## ====================================
##
## This example shows how to integrate PowerAssert's statistics
## tracking with Nim's unittest framework.

import unittest except check
import ../src/power_assert
import strutils

# Custom test template that uses powerAssertWithStats
template checkWithStats*(condition: untyped, msg = "") =
  ## Version of check that tracks statistics
  powerAssertWithStats(condition, msg)

suite "Math Operations":
  test "Basic arithmetic":
    checkWithStats(1 + 1 == 2)
    checkWithStats(5 - 3 == 2)
    checkWithStats(2 * 3 == 6)
    checkWithStats(10 div 2 == 5)
  
  test "Comparisons":
    checkWithStats(10 > 5)
    checkWithStats(5 < 10)
    checkWithStats(5 <= 5)
    checkWithStats(10 >= 10)
  
  test "Complex expressions":
    let x = 10
    let y = 20
    checkWithStats(x * 2 == y)
    checkWithStats((x + y) div 2 == 15)

suite "String Operations":
  test "String basics":
    checkWithStats("hello".len == 5)
    checkWithStats("Hello" != "hello")
    checkWithStats("abc" < "def")
  
  test "String concatenation":
    let first = "Hello"
    let second = "World"
    checkWithStats(first & " " & second == "Hello World")

suite "Conditional Tests":
  test "Feature tests":
    when defined(enableFeatureX):
      checkWithStats(true)  # Feature X test
    else:
      skipTest("Feature X not enabled")
    
    when defined(enableFeatureY):
      checkWithStats(true)  # Feature Y test
    else:
      skipTest("Feature Y not enabled")
  
  test "Platform tests":
    when defined(windows):
      skipTest("Not testing on Windows")
    elif defined(macosx):
      checkWithStats(true)  # macOS specific test
    else:
      checkWithStats(true)  # Other platforms

# Test with intentional failures
suite "Failure Examples":
  test "Arithmetic failures":
    try:
      checkWithStats(1 + 1 == 3, "This should fail")
    except PowerAssertDefect:
      echo "  (Expected failure caught)"
    
    try:
      checkWithStats(10 div 3 == 4)
    except PowerAssertDefect:
      echo "  (Expected failure caught)"
  
  test "String failures":
    try:
      checkWithStats("hello" == "Hello")
    except PowerAssertDefect:
      echo "  (Expected failure caught)"

# Custom suite that prints statistics after each suite
template suiteWithStats*(name: string, body: untyped) =
  suite name:
    setup:
      let statsBeforeSuite = getTestStats()
    
    teardown:
      let statsAfterSuite = getTestStats()
      let suitePassed = statsAfterSuite.passed - statsBeforeSuite.passed
      let suiteFailed = statsAfterSuite.failed - statsBeforeSuite.failed
      let suiteSkipped = statsAfterSuite.skipped - statsBeforeSuite.skipped
      echo "\n  Suite '" & name & "' Statistics:"
      echo "    Passed:  " & $suitePassed
      echo "    Failed:  " & $suiteFailed
      echo "    Skipped: " & $suiteSkipped
    
    body

# Example using the custom suite
suiteWithStats "Enhanced Test Suite":
  test "Test 1":
    checkWithStats(true)
  
  test "Test 2":
    try:
      checkWithStats(false)
    except PowerAssertDefect:
      discard
  
  test "Test 3":
    skipTest("Not implemented")

# Main test runner with final statistics
when isMainModule:
  echo "\nRunning PowerAssert with unittest integration..."
  echo "=" * 50
  
  # Reset statistics before running tests
  resetTestStats()
  
  # Run all test suites (this happens automatically)
  
  # After all tests, print the summary
  echo "\n" & "=" * 50
  echo "FINAL TEST STATISTICS"
  echo "=" * 50
  printTestSummary()
  echo "=" * 50
  
  # Additional statistics info
  let stats = getTestStats()
  if stats.total > 0:
    let passRate = (stats.passed.float / stats.total.float) * 100
    echo "\nPass Rate: " & formatFloat(passRate, precision = 1) & "%"
    
    if stats.skipped > 0:
      echo "Note: " & $stats.skipped & " test(s) were skipped"
  
  echo "\nTip: Use checkWithStats instead of check to track statistics"