# Simple Working PowerAssert Example
# This demonstrates ONLY the features that are confirmed to work

import ../src/power_assert

proc demonstrateWorkingFeatures() =
  echo "=== PowerAssert Working Features ==="
  
  # ✅ Simple boolean assertions (confirmed working)
  echo "\n1. Basic boolean assertions:"
  powerAssert(true)
  echo "✓ powerAssert(true) passed"
  
  # ✅ Function call assertions (confirmed working)
  echo "\n2. Function call assertions:"
  proc isEven(x: int): bool = (x mod 2) == 0
  proc isPositive(x: int): bool = x > 0
  proc alwaysTrue(): bool = true
  
  let number = 4
  powerAssert(isEven(number))
  echo "✓ powerAssert(isEven(4)) passed"
  
  powerAssert(alwaysTrue())
  echo "✓ powerAssert(alwaysTrue()) passed"
  
  # ✅ Custom messages (confirmed working)
  echo "\n3. Custom messages:"
  powerAssert(true, "This assertion should pass with a custom message")
  echo "✓ Custom message assertion passed"
  
  let x = 10
  powerAssert(isPositive(x), "Value should be positive")
  echo "✓ Function call with custom message passed"

proc demonstrateFailureHandling() =
  echo "\n=== Failure Handling ==="
  
  # Demonstrate how failures are handled
  echo "Testing assertion failure:"
  try:
    powerAssert(false)
  except PowerAssertDefect as e:
    echo "✓ Failed assertion caught correctly"
    echo "  Error message: ", e.msg
  
  echo "\nTesting failure with custom message:"
  try:
    powerAssert(false, "This assertion is designed to fail")
  except PowerAssertDefect as e:
    echo "✓ Failed assertion with custom message caught correctly"
    echo "  Error message: ", e.msg
  
  echo "\nTesting function call failure:"
  try:
    proc alwaysFalse(): bool = false
    powerAssert(alwaysFalse())
  except PowerAssertDefect as e:
    echo "✓ Function call failure caught correctly"
    echo "  Error message: ", e.msg

when isMainModule:
  echo "PowerAssert Simple Working Example"
  echo "=================================="
  echo "Demonstrating confirmed working features only"
  echo ""
  
  demonstrateWorkingFeatures()
  demonstrateFailureHandling()
  
  echo "\n🎉 All demonstrations completed successfully!"
  echo ""
  echo "✅ Features demonstrated:"
  echo "  - Basic boolean assertions"
  echo "  - Function call assertions"  
  echo "  - Custom error messages"
  echo "  - Proper failure handling"
  echo ""
  echo "🔄 Extended operators (==, !=, <, >, and, or, not) are being enhanced."
  echo "   See test_power_assert.nim for complete integration examples."