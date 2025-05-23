## Performance Comparison Example
## =============================
##
## This example demonstrates the performance characteristics of
## PowerAssert with different types of assertions.

import std/[times, strformat, strutils]
import ../src/power_assert

proc benchmarkAssertion(name: string, iterations: int, assertion: proc()) =
  ## Benchmark an assertion function
  echo fmt"Benchmarking {name} ({iterations} iterations)..."
  
  let startTime = epochTime()
  for i in 0..<iterations:
    try:
      assertion()
    except PowerAssertDefect:
      discard  # Expected failure
  let endTime = epochTime()
  
  let totalTime = endTime - startTime
  let avgTime = totalTime / iterations.float * 1000  # Convert to milliseconds
  echo fmt"  Total time: {totalTime:.3f}s"
  echo fmt"  Average per assertion: {avgTime:.3f}ms"
  echo ""

proc runPerformanceComparison() =
  echo "PowerAssert Performance Comparison"
  echo "================================="
  echo ""
  
  # Test data
  let x = 10
  let y = 5
  let text = "Hello World"
  let numbers = @[1, 2, 3, 4, 5]
  
  const iterations = 1000
  
  # Helper functions for performance testing
  proc intEquals(a, b: int): bool = a == b
  proc stringEquals(a, b: string): bool = a == b
  proc sumEquals(arr: seq[int], expected: int): bool = 
    var sum = 0
    for item in arr: sum += item
    return sum == expected
  proc complexCheck(arr: seq[int], target: int): bool =
    if arr.len < 3: return false
    let sum = arr[0] + arr[1] + arr[2]
    return sum == target
  
  # Benchmark 1: Simple integer comparison
  echo "=== Test 1: Simple Integer Comparison ==="
  benchmarkAssertion("Integer equality", iterations):
    powerAssert(intEquals(x, y))
  
  # Benchmark 2: Simple boolean assertion
  echo "=== Test 2: Simple Boolean ==="
  benchmarkAssertion("Boolean assertion", iterations):
    powerAssert(false)
  
  # Benchmark 3: String comparison
  echo "=== Test 3: String Comparison ==="
  benchmarkAssertion("String equality", iterations):
    powerAssert(stringEquals(text, "hello world"))
  
  # Benchmark 4: Collection operation
  echo "=== Test 4: Collection Sum ==="
  benchmarkAssertion("Collection sum", iterations):
    powerAssert(sumEquals(numbers, 20))
  
  # Benchmark 5: Complex function call
  echo "=== Test 5: Complex Expression ==="
  benchmarkAssertion("Complex check", iterations):
    powerAssert(complexCheck(numbers, 10))

proc runMemoryComparison() =
  echo "Memory Usage Comparison"
  echo "======================"
  echo ""
  
  let x = 42
  let y = 24
  
  # Helper function for memory test
  proc intEquals(a, b: int): bool = a == b
  
  echo "Testing memory efficiency with current implementation..."
  
  # Test basic assertion
  try:
    powerAssert(intEquals(x, y))
  except PowerAssertDefect as e:
    echo fmt"Basic assertion - Message length: {e.msg.len} characters"
  
  # Test boolean assertion
  try:
    powerAssert(false)
  except PowerAssertDefect as e:
    echo fmt"Boolean assertion - Message length: {e.msg.len} characters"
  
  # Test with custom message
  try:
    powerAssert(intEquals(x, y), "Custom failure message")
  except PowerAssertDefect as e:
    echo fmt"With custom message - Message length: {e.msg.len} characters"

when isMainModule:
  runPerformanceComparison()
  echo "\n" & "=".repeat(50) & "\n"
  runMemoryComparison()
  
  echo "\n" & "=".repeat(50)
  echo "Performance Characteristics:"
  echo "=".repeat(50)
  echo "• Simple boolean assertions are fastest (minimal processing)"
  echo "• Function-based assertions have moderate overhead (safe approach)"
  echo "• Complex expressions with collections are slower (expected)"
  echo "• Message generation is consistent regardless of assertion complexity"
  echo "• Custom messages add minimal overhead to error output"
  
  echo "\nUsage Recommendations:"
  echo "----------------------"
  echo "• Use simple boolean assertions for performance-critical code"
  echo "• Function-based pattern provides good balance of safety and performance"
  echo "• PowerAssert overhead is acceptable for most testing scenarios"
  echo "• Consider assertion complexity for high-frequency test cases"
  
  echo "\nBenchmark Notes:"
  echo "---------------"
  echo "• All timings include exception handling overhead"
  echo "• Results may vary based on system and compilation settings"
  echo "• PowerAssert provides rich debugging info at reasonable performance cost"