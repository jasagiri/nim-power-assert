# Visual Comparison Example
# Shows the improved power-assert.js-like visual output

import ../src/power_assert

proc demonstrateEnhancedVisuals() =
  echo "=== Enhanced Visual Output Demo ==="
  echo "This shows the power-assert.js-like visual formatting"
  echo ""
  
  # Helper functions for visual demonstrations
  proc arithmeticEquals(a, b, c: int): bool = (a + b) == c
  proc arrayProductEquals(arr: seq[int], idx1, idx2: int, target: int): bool = 
    (arr[idx1] * arr[idx2]) == target
  proc stringConcatEquals(s1, s2, s3, expected: string): bool = 
    (s1 & s2 & s3) == expected
  proc complexBoolCheck(active: bool, score, threshold: int): bool =
    active and (score > threshold) and (score < 100)
  
  # Simple arithmetic comparison
  let x = 10
  let y = 20
  let z = 5
  
  echo "1. Simple arithmetic expression:"
  try:
    powerAssert(arithmeticEquals(x, z, y))
  except PowerAssertDefect as e:
    echo e.msg
  
  # Array/sequence operations
  let numbers = @[1, 2, 3, 4, 5]
  let target = 10
  
  echo "2. Array operations:"
  try:
    powerAssert(arrayProductEquals(numbers, 2, 3, target))
  except PowerAssertDefect as e:
    echo e.msg
  
  # String operations
  let name = "Alice"
  let greeting = "Hello"
  let expected = "Hello Bob"
  
  echo "3. String concatenation:"
  try:
    powerAssert(stringConcatEquals(greeting, " ", name, expected))
  except PowerAssertDefect as e:
    echo e.msg
  
  # Complex boolean logic
  let isActive = true
  let score = 85
  let threshold = 90
  
  echo "4. Complex boolean expression:"
  try:
    powerAssert(complexBoolCheck(isActive, score, threshold))
  except PowerAssertDefect as e:
    echo e.msg

when isMainModule:
  echo "PowerAssert Enhanced Visual Output"
  echo "================================="
  echo ""
  echo "This example demonstrates the improved visual formatting"
  echo "that makes it easier to understand assertion failures."
  echo ""
  
  demonstrateEnhancedVisuals()
  
  echo ""
  echo "Key improvements:"
  echo "- Visual tree structure showing expression breakdown"
  echo "- Aligned values under their corresponding expressions"
  echo "- Color-coded output for better readability"
  echo "- Type information for each value"
  echo "- Clear separation between visual and detailed sections"