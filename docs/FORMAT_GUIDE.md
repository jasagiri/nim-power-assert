# PowerAssert Output Format Guide

PowerAssert for Nim provides multiple output formats and test statistics functionality to suit different preferences and use cases.

## Output Formats

### 1. PowerAssertJS (Default)

Power-assert.js style visual output format with pipe characters and aligned values.

```nim
import power_assert

setOutputFormat(PowerAssertJS)  # Default, so setting is optional

let x = 10
let y = 5
proc isLess(a, b: int): bool = a < b
powerAssert(isLess(x, y))
```

**Output:**
```
PowerAssert: Assertion failed

isLess(x, y)
|      |  | 
          5 
       10   

isLess = <proc (a: int, b: int): bool{.noSideEffect, gcsafe.}>
```

**Features:**
- Pipe characters (|) show exact variable positions
- Values displayed directly under corresponding expressions
- Additional information shown below when needed
- Most intuitive and visual format

### 2. Compact Format

Single-line format with variable values in brackets.

```nim
setOutputFormat(Compact)
powerAssert(isLess(x, y))
```

**Output:**
```
PowerAssert: Assertion failed

assert(isLess(x, y)) failed [x=10, y=5, isLess=<proc>]
```

**Features:**
- Minimal screen space usage
- Quick scan of values
- Good for CI/CD logs
- Concise error reporting

### 3. Detailed Format

Structured format with clear sections and organized variable display.

```nim
setOutputFormat(Detailed)
powerAssert(isLess(x, y))
```

**Output:**
```
PowerAssert: Assertion failed

PowerAssert Failure Details:
══════════════════════════════════════════════════
Expression: isLess(x, y)
Variables:
  isLess               = <proc (a: int, b: int): bool>
  x                    = 10
  y                    = 5
══════════════════════════════════════════════════
```

**Features:**
- Clear visual separation
- Tabular variable display
- Professional appearance
- Easy to read in documentation

### 4. Classic Format

Traditional PowerAssert format with pointer visualization.

```nim
setOutputFormat(Classic)
powerAssert(isLess(x, y))
```

**Output:**
```
PowerAssert: Assertion failed

Expression: isLess(x, y)

Result: false

Subexpression values:
x => 10
y => 5
isLess => <proc>

isLess(x, y)
^      ^   ^
```

**Features:**
- Pointer characters (^) mark expression positions
- Traditional assertion library style
- Familiar to users of other assertion libraries
- Clear result indication

## Format Configuration API

### Setting Output Format

```nim
import power_assert

# Available formats
setOutputFormat(PowerAssertJS)  # Default
setOutputFormat(Compact)
setOutputFormat(Detailed) 
setOutputFormat(Classic)
```

### Getting Current Format

```nim
let currentFormat = getOutputFormat()
echo "Current format: ", currentFormat
```

### Dynamic Format Switching

```nim
# Switch formats during runtime
for format in [PowerAssertJS, Compact, Detailed, Classic]:
  setOutputFormat(format)
  echo "Format: ", format
  try:
    powerAssert(false, "Demo assertion")
  except PowerAssertDefect as e:
    echo e.msg
    echo "---"
```

## Test Statistics

### Basic Usage

```nim
import power_assert

# Reset counters
resetTestStats()

# Run tests with automatic tracking
powerAssertWithStats(condition1, "Test 1")
powerAssertWithStats(condition2, "Test 2")

# Skip tests when needed
skipTest("Feature not implemented yet")

# Show summary
printTestSummary()
```

**Output:**
```
Test Summary:
=============
PASSED:  2
FAILED:  1
SKIPPED: 1
TOTAL:   4

❌ 1 test(s) failed
```

### Manual Statistics Recording

```nim
# Manual control over statistics
try:
  powerAssert(someCondition)
  recordPassed()
except PowerAssertDefect:
  recordFailed()

# Record skipped tests
recordSkipped()

# Get current statistics
let stats = getTestStats()
echo "Passed: ", stats.passed
echo "Failed: ", stats.failed
echo "Skipped: ", stats.skipped
echo "Total: ", stats.total
```

### Statistics API

| Function | Description |
|----------|-------------|
| `powerAssertWithStats(condition, message)` | Assertion with automatic statistics |
| `recordPassed()` | Mark test as passed |
| `recordFailed()` | Mark test as failed |
| `recordSkipped()` | Mark test as skipped |
| `skipTest(reason)` | Skip test with reason |
| `getTestStats()` | Get current TestStats object |
| `resetTestStats()` | Reset all counters to zero |
| `printTestSummary()` | Display formatted summary |

## Advanced Usage

### Format Selection Based on Environment

```nim
import os, power_assert

# Use compact format in CI environments
if existsEnv("CI"):
  setOutputFormat(Compact)
else:
  setOutputFormat(PowerAssertJS)
```

### Custom Test Runners

```nim
proc runTestSuite() =
  resetTestStats()
  
  # Run your tests
  powerAssertWithStats(test1())
  powerAssertWithStats(test2())
  
  let stats = getTestStats()
  if stats.failed > 0:
    echo "Tests failed!"
    quit(1)
  else:
    echo "All tests passed!"
```

### Integration with unittest

```nim
import unittest except check
import power_assert

suite "My Test Suite":
  setup:
    resetTestStats()
    setOutputFormat(PowerAssertJS)
  
  test "Feature A":
    powerAssertWithStats(featureA_works())
  
  test "Feature B":
    powerAssertWithStats(featureB_works())
  
  teardown:
    printTestSummary()
```

## Best Practices

### Format Selection Guidelines

- **PowerAssertJS**: Best for development and debugging
- **Compact**: Good for CI/CD pipelines and logs
- **Detailed**: Excellent for documentation and reports
- **Classic**: Familiar for users of other assertion libraries

### Performance Considerations

- Format selection has minimal performance impact
- Statistics tracking adds negligible overhead
- Visual formatting only occurs on assertion failures

### Testing Strategy

- Use `powerAssertWithStats` for automatic tracking
- Call `printTestSummary()` at the end of test suites
- Reset statistics between test suites with `resetTestStats()`
- Use meaningful messages for better debugging

## Examples

See the [examples/](../examples/) directory for comprehensive usage examples:

- `format_demo.nim` - Demonstrates all output formats
- `enhanced_demo.nim` - Shows complex expression handling
- `basic_example.nim` - Simple getting started example

## Troubleshooting

### Common Issues

1. **Values not aligning properly**: Ensure terminal supports Unicode
2. **Statistics not tracking**: Use `powerAssertWithStats` instead of `powerAssert`
3. **Format not changing**: Verify `setOutputFormat()` is called before assertions

### Debug Mode

```nim
# Enable debug output to see format selection
when defined(debug):
  echo "Current format: ", getOutputFormat()
```