# Custom Formatters

PowerAssert allows you to create custom output formatters to display assertion failures in your preferred format.

## Basic Usage

```nim
import power_assert
import strutils

# Define a custom formatter
proc myFormatter(exprStr: string, capturedValues: CapturedValues): string =
  result = "=== Custom Format ===\n"
  result.add("Failed: " & exprStr & "\n")
  result.add("Values:\n")
  for key, value in capturedPairs(capturedValues):
    if key != exprStr:  # Skip the full expression
      result.add("  • " & key & " = " & value & "\n")

# Set the custom formatter
setCustomRenderer(myFormatter)

# Use powerAssert as normal
let x = 10
let y = 5
powerAssert(x == y)  # Will use your custom formatter

# Reset to default formatter
clearCustomRenderer()
```

## API Reference

### Types

- `CapturedValues`: Type alias for captured expression values
- `FormatRenderer`: Function type for custom formatters

### Functions

- `setCustomRenderer(renderer: FormatRenderer)`: Set a custom formatter
- `clearCustomRenderer()`: Reset to default PowerAssertJS formatter
- `capturedPairs(values: CapturedValues)`: Iterator for key-value pairs
- `detectExpressionPositions(exprStr: string, capturedValues: CapturedValues)`: Get expression positions
- `formatValue[T](val: T)`: Format a value for display

## Built-in Formats

PowerAssert includes several built-in formats that you can switch between:

```nim
# Set to a built-in format
setOutputFormat(OutputFormat.Compact)
setOutputFormat(OutputFormat.Detailed)
setOutputFormat(OutputFormat.Classic)
setOutputFormat(OutputFormat.PowerAssertJS)  # Default
```

## Advanced Example

```nim
proc visualFormatter(exprStr: string, capturedValues: CapturedValues): string =
  result = "╔═══ Assertion Failed ═══╗\n"
  result.add("║ " & exprStr & "\n")
  result.add("╠════════════════════════╣\n")
  
  # Get expression positions for visual indicators
  let positions = detectExpressionPositions(exprStr, capturedValues)
  
  # Create visual indicators
  var indicators = spaces(exprStr.len)
  for expr in positions:
    if expr.startPos >= 0:
      for i in expr.startPos .. min(expr.endPos, exprStr.len - 1):
        indicators[i] = '^'
  
  result.add("║ " & indicators & "\n")
  result.add("╠════════════════════════╣\n")
  
  # Show values
  for key, value in capturedPairs(capturedValues):
    if key != exprStr:
      result.add("║ " & key.alignLeft(15) & " = " & value & "\n")
  
  result.add("╚════════════════════════╝")

setCustomRenderer(visualFormatter)
```

## Important Notes

1. **Avoid importing tables directly**: If you're using PowerAssert with unittest, avoid importing the tables module directly as it may cause operator ambiguity issues. Use the provided `CapturedValues` type and `capturedPairs` iterator instead.

2. **Performance**: Custom formatters are called only when assertions fail, so they don't impact performance of successful assertions.

3. **Thread Safety**: Custom formatters should be thread-safe if you're using PowerAssert in multi-threaded code.

## Integration with Test Frameworks

When using with unittest or other test frameworks:

```nim
import unittest except check
import power_assert

# Your custom formatter here
proc testFormatter(exprStr: string, capturedValues: CapturedValues): string =
  # Custom format implementation
  discard

suite "My Tests":
  setup:
    setCustomRenderer(testFormatter)
  
  teardown:
    clearCustomRenderer()
  
  test "example":
    let a = 10
    let b = 20
    powerAssert(a > b)  # Uses custom formatter
```