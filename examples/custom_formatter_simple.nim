## Simple Custom Formatter Example
## ================================
##
## This example demonstrates how to create custom formatters
## without needing to import tables module directly.

import ../src/power_assert
import strutils

# Create custom formatters using the iterator API
proc mySimpleFormatter(exprStr: string, capturedValues: CapturedValues): string =
  result = "Custom Format:\n"
  result.add("Expression: " & exprStr & "\n")
  # Use the power_assert module's helper iterator
  for key, value in capturedPairs(capturedValues):
    result.add("  " & key & " => " & value & "\n")

proc testCustomFormatters() =
  echo "Testing Custom Formatters (Simple)"
  echo "==================================\n"
  
  let x = 10
  let y = 5
  
  # Test custom formatter
  echo "Custom Formatter:"
  setCustomRenderer(mySimpleFormatter)
  try:
    powerAssert(x == y)
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "\n" & "─".repeat(50) & "\n"
  
  # Back to default
  echo "Default PowerAssertJS Format:"
  clearCustomRenderer()
  try:
    powerAssert(x < y)
  except PowerAssertDefect as e:
    echo e.msg

when isMainModule:
  testCustomFormatters()