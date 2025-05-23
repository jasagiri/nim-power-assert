# Basic PowerAssert Example
# This demonstrates the core functionality of power_assert

import ../src/power_assert

proc demonstrateBasicAssertions() =
  echo "=== Basic Assertions ==="
  
  # ✅ Simple boolean assertions that work
  powerAssert(true)
  echo "✓ powerAssert(true) passed"
  
  proc notFalse(): bool = not false
  powerAssert(notFalse())
  echo "✓ powerAssert(notFalse()) passed"
  
  # ✅ Function-based assertions that work
  proc isValid(x: int): bool = x > 0
  let x = 10
  powerAssert(isValid(x))
  echo "✓ powerAssert(isValid(10)) passed"
  
  # ✅ Assertion that will fail and show detailed output
  echo "\nDemonstrating failed assertion:"
  try:
    powerAssert(false)
  except PowerAssertDefect as e:
    echo "Failed assertion caught:"
    echo e.msg
  
  # ✅ Assertion with custom message
  echo "\nAssertion with custom message:"
  try:
    powerAssert(false, "This is a custom failure message")
  except PowerAssertDefect as e:
    echo "Failed assertion with custom message:"
    echo e.msg

proc demonstrateComplexExpressions() =
  echo "\n=== Function-based Complex Logic ==="
  
  # ✅ Use functions for complex logic (currently working)
  proc checkArrayLength(arr: seq[int], minLen: int): bool = 
    let arrLen = arr.len
    let isValid = arrLen - minLen
    return isValid >= 0
  
  proc checkFirstElement(arr: seq[int], expected: int): bool =
    if arr.len != 0: 
      let first = arr[0]
      return first == expected
    else: 
      return false
  
  let numbers = @[1, 2, 3, 4, 5]
  let threshold = 3
  
  # These work because they use function calls
  powerAssert(checkArrayLength(numbers, 3))
  echo "✓ Array length check passed"
  
  try:
    powerAssert(checkFirstElement(numbers, threshold))
  except PowerAssertDefect as e:
    echo "First element check failed (expected):"
    echo e.msg

proc demonstrateFutureFeatures() =
  echo "\n=== Future Features (Being Enhanced) ==="
  echo "These features are being enhanced and will work soon:"
  echo ""
  echo "  # powerAssert(x + y == 15)              # Arithmetic + comparison"
  echo "  # powerAssert(arr.len > 5)              # Property access + comparison" 
  echo "  # powerAssert(name == \"Alice\")          # String comparison"
  echo "  # powerAssert(a < b and c > d)          # Complex logical expressions"
  echo ""
  echo "See RESTORATION_SUMMARY.md for current progress and roadmap."

when isMainModule:
  echo "PowerAssert Basic Examples"
  echo "========================="
  echo "Demonstrating currently working features"
  echo ""
  
  demonstrateBasicAssertions()
  demonstrateComplexExpressions()
  demonstrateFutureFeatures()
  
  echo "\n🎉 Basic examples completed successfully!"
  echo ""
  echo "✅ All demonstrated features are working in production."
  echo "🔄 Extended operators are being enhanced using established patterns."