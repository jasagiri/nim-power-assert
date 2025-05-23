# Enhanced Basic PowerAssert Example
# This demonstrates extended functionality using working patterns

import ../src/power_assert

proc demonstrateBasicAssertions() =
  echo "=== Basic Assertions ==="
  
  # ✅ Simple boolean assertions that work
  powerAssert(true)
  echo "✓ powerAssert(true) passed"
  
  # ✅ Function-based logic that works
  proc isValid(x: int): bool = x > 0
  proc isEven(x: int): bool = (x mod 2) == 0
  proc isInRange(x, min, max: int): bool = x >= min and x <= max
  
  let x = 10
  powerAssert(isValid(x))
  echo "✓ powerAssert(isValid(10)) passed"
  
  powerAssert(isEven(4))
  echo "✓ powerAssert(isEven(4)) passed"
  
  powerAssert(isInRange(5, 1, 10))
  echo "✓ powerAssert(isInRange(5, 1, 10)) passed"

proc demonstrateCustomMessages() =
  echo "\n=== Custom Messages ==="
  
  # ✅ Custom messages work perfectly
  powerAssert(true, "Basic assertion with message")
  echo "✓ Custom message assertion passed"
  
  proc alwaysTrue(): bool = true
  powerAssert(alwaysTrue(), "Function call with custom message")
  echo "✓ Function call with message passed"

proc demonstrateErrorHandling() =
  echo "\n=== Error Handling ==="
  
  # ✅ Proper error handling
  echo "Testing intentional failure..."
  try:
    powerAssert(false, "This should fail gracefully")
  except PowerAssertDefect as e:
    echo "✓ Error handled correctly: ", e.msg
  
  echo "Testing function failure..."
  try:
    proc alwaysFalse(): bool = false
    powerAssert(alwaysFalse(), "Function that returns false")
  except PowerAssertDefect as e:
    echo "✓ Function error handled correctly: ", e.msg

proc demonstrateAdvancedPatterns() =
  echo "\n=== Advanced Patterns ==="
  
  # ✅ Complex logic encapsulated in functions
  proc validateArray(arr: seq[int]): bool =
    # Check array has elements and first element is positive
    if arr.len == 0: return false
    if arr[0] <= 0: return false
    return true
  
  proc validateString(s: string): bool =
    # Check string is not empty and starts with capital
    if s.len == 0: return false
    let firstChar = s[0]
    return firstChar >= 'A' and firstChar <= 'Z'
  
  let numbers = @[1, 2, 3, 4, 5]
  let name = "Alice"
  
  powerAssert(validateArray(numbers))
  echo "✓ Array validation passed"
  
  powerAssert(validateString(name))
  echo "✓ String validation passed"

proc demonstrateMultipleAssertions() =
  echo "\n=== Multiple Assertions ==="
  
  # ✅ Multiple assertions in sequence
  proc isPositive(x: int): bool = x > 0
  proc isNonEmpty(s: string): bool = s.len > 0
  proc hasIntElements(arr: seq[int]): bool = arr.len > 0
  
  powerAssert(isPositive(42))
  powerAssert(isNonEmpty("Hello"))
  let testArray = @[1, 2, 3]
  powerAssert(hasIntElements(testArray))
  
  echo "✓ All multiple assertions passed"

when isMainModule:
  echo "Enhanced PowerAssert Basic Examples"
  echo "=================================="
  echo "Demonstrating extended functionality using working patterns"
  echo ""
  
  demonstrateBasicAssertions()
  demonstrateCustomMessages()
  demonstrateErrorHandling()
  demonstrateAdvancedPatterns()
  demonstrateMultipleAssertions()
  
  echo "\n🎉 All enhanced examples completed successfully!"
  echo ""
  echo "✅ Features demonstrated:"
  echo "  - Basic boolean assertions"
  echo "  - Function-based complex logic"
  echo "  - Custom error messages"
  echo "  - Proper error handling"
  echo "  - Advanced validation patterns"
  echo "  - Multiple sequential assertions"
  echo ""
  echo "🚀 PowerAssert is production-ready for these use cases!"