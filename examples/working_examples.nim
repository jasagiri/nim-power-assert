# Working PowerAssert Examples
# These examples demonstrate currently functional features

import ../src/power_assert

proc demonstrateWorkingFeatures() =
  echo "=== Currently Working PowerAssert Features ==="
  
  # ✅ Basic boolean assertions
  echo "\n1. Basic boolean assertions:"
  powerAssert(true)
  echo "✓ powerAssert(true) passed"
  
  powerAssert(not false)
  echo "✓ powerAssert(not false) passed"
  
  # ✅ Function call assertions
  echo "\n2. Function call assertions:"
  proc isEven(x: int): bool = (x mod 2) == 0
  proc isPositive(x: int): bool = x > 0
  
  let number = 4
  powerAssert(isEven(number))
  echo "✓ powerAssert(isEven(4)) passed"
  
  let value = 42
  powerAssert(isPositive(value))
  echo "✓ powerAssert(isPositive(42)) passed"
  
  # ✅ Custom messages
  echo "\n3. Custom messages:"
  powerAssert(true, "This assertion should pass with a custom message")
  echo "✓ Custom message assertion passed"
  
  let x = 10
  powerAssert(x > 0, "Value should be positive")
  echo "✓ Custom message with expression passed"

proc demonstrateFailureHandling() =
  echo "\n=== Failure Handling ==="
  
  # Demonstrate how failures are handled
  echo "Testing assertion failure with custom message:"
  try:
    powerAssert(false, "This assertion is designed to fail")
  except PowerAssertDefect as e:
    echo "✓ Failed assertion caught correctly:"
    echo "  Error: ", e.msg
  
  echo "\nTesting function call failure:"
  try:
    proc alwaysFalse(): bool = false
    powerAssert(alwaysFalse())
  except PowerAssertDefect as e:
    echo "✓ Function call failure caught correctly:"
    echo "  Error: ", e.msg

proc demonstrateUnittestIntegration() =
  echo "\n=== Unittest Integration ==="
  echo "PowerAssert integrates seamlessly with unittest framework."
  echo "See test_power_assert.nim for complete integration examples."
  
  # This would work in a unittest context:
  echo """
Example unittest integration:
  
  import unittest except check
  import power_assert
  
  suite "My Tests":
    test "Working assertion":
      powerAssert(true)
      powerAssert(isEven(4))
      powerAssert(value > 0, "Custom message")
"""

when isMainModule:
  echo "PowerAssert Working Examples"
  echo "==========================="
  echo "These examples demonstrate currently functional features."
  echo ""
  
  demonstrateWorkingFeatures()
  demonstrateFailureHandling()
  demonstrateUnittestIntegration()
  
  echo "\n🎉 All working examples completed successfully!"
  echo ""
  echo "Note: Extended operators (==, !=, <, >, etc.) are being enhanced."
  echo "See RESTORATION_SUMMARY.md for current status and roadmap."