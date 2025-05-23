## Performance Modes Example
## ========================
##
## This example demonstrates different PowerAssert performance modes
## that can be enabled with compile-time flags.
##
## Compile with different flags to see the differences:
## - nim c -r performance_modes_example.nim                 # Full mode (default)
## - nim c -r -d:powerAssertMinimal performance_modes_example.nim    # Minimal mode
## - nim c -r -d:powerAssertFast performance_modes_example.nim       # Fast mode
## - nim c -r -d:powerAssertSilent performance_modes_example.nim     # Silent mode

import ../src/power_assert
import sequtils

proc testPerformanceModes() =
  echo "PowerAssert Performance Modes Test"
  echo "=================================="
  
  when defined(powerAssertMinimal):
    echo "Mode: Minimal (CI/Production)"
  elif defined(powerAssertFast):
    echo "Mode: Fast (Medium detail)"
  elif defined(powerAssertSilent):
    echo "Mode: Silent (Basic errors only)"
  else:
    echo "Mode: Full (Default with visual output and hints)"
  
  echo ""
  
  # Test 1: Simple comparison
  echo "Test 1: Simple comparison failure"
  try:
    let x = 10
    let y = 5
    powerAssert(x == y)
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "\n" & "─".repeat(50) & "\n"
  
  # Test 2: Complex expression
  echo "Test 2: Complex expression failure"
  try:
    let numbers = @[1, 2, 3, 4, 5]
    let target = 20
    powerAssert(numbers.foldl(a + b, 0) == target)
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "\n" & "─".repeat(50) & "\n"
  
  # Test 3: String comparison
  echo "Test 3: String comparison failure"
  try:
    let actual = "Hello World"
    let expected = "hello world"
    powerAssert(actual == expected)
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "\n" & "─".repeat(50) & "\n"
  
  # Test 4: Type mismatch
  echo "Test 4: Type-related failure"
  try:
    let intValue = 42
    let stringValue = "42"
    powerAssert(intValue == stringValue.len)
  except PowerAssertDefect as e:
    echo e.msg

when isMainModule:
  testPerformanceModes()
  
  echo "\n" & "=" * 60
  echo "Performance Mode Information:"
  echo "=" * 60
  
  when defined(powerAssertMinimal):
    echo "• Minimal mode provides basic error messages with condition text"
    echo "• Suitable for CI environments where detailed output isn't needed"
    echo "• Fastest compilation and execution time"
  elif defined(powerAssertFast):
    echo "• Fast mode provides condition text without detailed analysis"
    echo "• Balanced between speed and information"
    echo "• Good for development when you need some detail but want speed"
  elif defined(powerAssertSilent):
    echo "• Silent mode provides only basic 'Assertion failed' messages"
    echo "• Minimal output suitable for production environments"
    echo "• Fastest execution with minimal memory usage"
  else:
    echo "• Full mode provides complete visual output with hints"
    echo "• Best for development and debugging"
    echo "• Includes expression trees, value display, and suggestions"
  
  echo "\nTo try different modes, compile with:"
  echo "nim c -r -d:powerAssertMinimal performance_modes_example.nim"
  echo "nim c -r -d:powerAssertFast performance_modes_example.nim"
  echo "nim c -r -d:powerAssertSilent performance_modes_example.nim"