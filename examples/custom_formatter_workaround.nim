## Custom Formatter Example with Workaround
## =========================================
##
## This example shows how to create custom formatters while avoiding
## the ambiguous operator issue when unittest is used.

import ../src/power_assert
import strutils

# Don't import tables directly if using with unittest
# Instead, use the types and iterators provided by power_assert

proc myFormatter(exprStr: string, capturedValues: CapturedValues): string =
  result = "=== Custom Format ===\n"
  result.add("Failed: " & exprStr & "\n")
  result.add("Values:\n")
  for key, value in capturedPairs(capturedValues):
    if key != exprStr:  # Skip the full expression
      result.add("  • " & key & " = " & value & "\n")

proc demonstrateCustomFormatter() =
  echo "Custom Formatter Demo"
  echo "=====================\n"
  
  # Set custom formatter
  setCustomRenderer(myFormatter)
  
  let a = 10
  let b = 20
  
  # This will use our custom formatter
  try:
    # Use explicit module qualification if needed
    powerAssert(a > b)
  except PowerAssertDefect as e:
    echo e.msg
  
  echo "\n---\n"
  
  # Reset to default
  clearCustomRenderer()
  
  try:
    powerAssert(a > b)
  except PowerAssertDefect as e:
    echo e.msg

when isMainModule:
  demonstrateCustomFormatter()
  
  echo "\n\nNOTE:"
  echo "====="
  echo "If you encounter ambiguous operator errors when using with unittest,"
  echo "avoid importing tables directly. Use the provided CapturedValues type"
  echo "and capturedPairs iterator instead."