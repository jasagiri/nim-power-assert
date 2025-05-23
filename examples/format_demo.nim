import ../src/power_assert
import strutils

# フォーマットと統計のデモ
proc demonstrateFormats() =
  echo "PowerAssert Format Demonstration"
  echo "================================"
  
  let x = 10
  let y = 5
  let name = "Alice"
  let expected = "Bob"
  
  # Helper function for testing
  proc stringEquals(a, b: string): bool = a == b
  proc intGreater(a, b: int): bool = a > b
  
  echo "\n1. PowerAssert.js Style (Default):"
  echo "-----------------------------------"
  setOutputFormat(PowerAssertJS)
  try:
    powerAssert(stringEquals(name, expected))
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "\n2. Compact Format:"
  echo "------------------"
  setOutputFormat(Compact)
  try:
    powerAssert(intGreater(y, x))
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "\n3. Detailed Format:"
  echo "-------------------"
  setOutputFormat(Detailed)
  try:
    powerAssert(stringEquals(name, expected))
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "\n4. Classic Format:"
  echo "------------------"
  setOutputFormat(Classic)
  try:
    powerAssert(intGreater(y, x))
  except PowerAssertDefect as e:
    echo e.msg

proc demonstrateStats() =
  echo "\n\nTest Statistics Demonstration"
  echo "============================="
  
  # Reset stats
  resetTestStats()
  
  # Helper functions
  proc isPositive(x: int): bool = x > 0
  proc isEven(x: int): bool = (x mod 2) == 0
  proc stringEquals(s1, s2: string): bool = s1 == s2
  
  echo "\nRunning tests with statistics tracking..."
  
  # Test 1: Should pass
  try:
    powerAssertWithStats(isPositive(10), "Test if 10 is positive")
    echo "✓ Test 1 passed"
  except PowerAssertDefect:
    echo "✗ Test 1 failed"
  
  # Test 2: Should pass
  try:
    powerAssertWithStats(isEven(4), "Test if 4 is even")
    echo "✓ Test 2 passed"
  except PowerAssertDefect:
    echo "✗ Test 2 failed"
  
  # Test 3: Should fail
  try:
    powerAssertWithStats(isEven(5), "Test if 5 is even")
    echo "✓ Test 3 passed"
  except PowerAssertDefect:
    echo "✗ Test 3 failed (expected)"
  
  # Test 4: Should pass
  try:
    powerAssertWithStats(stringEquals("Hello", "Hello"), "Test if strings are equal")
    echo "✓ Test 4 passed"
  except PowerAssertDefect:
    echo "✗ Test 4 failed"
  
  # Test 5: Skip test
  skipTest("This test is not yet implemented")
  
  # Test 6: Should fail
  try:
    powerAssertWithStats(isPositive(-5), "Test if -5 is positive")
    echo "✓ Test 6 passed"
  except PowerAssertDefect:
    echo "✗ Test 6 failed (expected)"
  
  # Show test summary
  printTestSummary()

proc demonstrateAdvancedUsage() =
  echo "\n\nAdvanced Usage Examples"
  echo "======================="
  
  # Reset to PowerAssert.js format
  setOutputFormat(PowerAssertJS)
  resetTestStats()
  
  # Complex expression examples
  proc complexCheck(a, b, c: int): bool =
    let sum = a + b
    let product = b * c
    return sum > product
  
  proc arrayValidation(arr: seq[int], minLen: int, maxVal: int): bool =
    if arr.len < minLen: return false
    for item in arr:
      if item > maxVal: return false
    return true
  
  echo "\nTesting complex expressions:"
  
  try:
    powerAssertWithStats(complexCheck(3, 4, 2))
    echo "✓ Complex check passed"
  except PowerAssertDefect as e:
    echo "✗ Complex check failed:"
    echo e.msg
  
  let numbers = @[1, 5, 3, 8, 2]
  try:
    powerAssertWithStats(arrayValidation(numbers, 3, 6))
    echo "✓ Array validation passed"
  except PowerAssertDefect as e:
    echo "✗ Array validation failed:"
    echo e.msg
  
  printTestSummary()

when isMainModule:
  demonstrateFormats()
  demonstrateStats()
  demonstrateAdvancedUsage()
  
  echo "\n" & "=".repeat(50)
  echo "Format Options Available:"
  echo "========================="
  echo "• PowerAssertJS - power-assert.js style visualization"
  echo "• Compact      - Single line with variable values"
  echo "• Detailed     - Structured format with clear sections"
  echo "• Classic      - Traditional PowerAssert format"
  echo ""
  echo "Statistics Features:"
  echo "==================="
  echo "• powerAssertWithStats() - Assertion with auto statistics"
  echo "• skipTest() - Mark tests as skipped"
  echo "• printTestSummary() - Show PASSED/FAILED/SKIPPED counts"
  echo "• resetTestStats() - Reset counters"