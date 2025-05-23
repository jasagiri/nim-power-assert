# Test Statistics

PowerAssert provides comprehensive test statistics tracking to help you monitor the health of your test suite with PASSED/FAILED/SKIPPED counts.

## Quick Start

```nim
import power_assert

# Use powerAssertWithStats instead of powerAssert
powerAssertWithStats(1 + 1 == 2)  # Tracks as PASSED

try:
  powerAssertWithStats(1 > 2)      # Tracks as FAILED
except PowerAssertDefect:
  discard

skipTest("Not implemented")        # Tracks as SKIPPED

# Display the summary
printTestSummary()
```

Output:
```
Test Summary:
=============
PASSED:  1
FAILED:  1
SKIPPED: 1
TOTAL:   3

❌ 1 test(s) failed
```

## API Reference

### Statistics Tracking

- `powerAssertWithStats(condition, message = "")`: Like `powerAssert` but tracks statistics
- `skipTest(reason = "")`: Mark a test as skipped with optional reason
- `resetTestStats()`: Clear all statistics counters
- `printTestSummary()`: Display formatted statistics summary
- `getTestStats()`: Get current statistics as a `TestStats` object

### Manual Recording

- `recordPassed()`: Manually record a passed test
- `recordFailed()`: Manually record a failed test
- `recordSkipped()`: Manually record a skipped test

### Types

```nim
type TestStats = object
  passed: int
  failed: int
  skipped: int
  total: int
```

## Integration with unittest

```nim
import unittest except check
import power_assert

# Create a custom check template
template checkWithStats*(condition: untyped, msg = "") =
  powerAssertWithStats(condition, msg)

suite "My Tests":
  test "example":
    checkWithStats(1 + 1 == 2)
    checkWithStats(2 * 2 == 4)

# After tests run
printTestSummary()
```

## Advanced Usage

### Per-Suite Statistics

```nim
suite "Test Suite":
  setup:
    let statsBefore = getTestStats()
  
  teardown:
    let statsAfter = getTestStats()
    echo "Suite passed: ", statsAfter.passed - statsBefore.passed
    echo "Suite failed: ", statsAfter.failed - statsBefore.failed
  
  test "example":
    powerAssertWithStats(true)
```

### Conditional Tests

```nim
when defined(slowTests):
  powerAssertWithStats(complexOperation() == expected)
else:
  skipTest("Slow tests disabled")

when defined(windows):
  skipTest("Not supported on Windows")
else:
  powerAssertWithStats(unixSpecificTest())
```

### Custom Formats with Statistics

```nim
# Statistics work with all output formats
setOutputFormat(Compact)
powerAssertWithStats(1 == 2)  # Still tracked

setOutputFormat(Detailed)
powerAssertWithStats(true)     # Still tracked
```

## Best Practices

1. **Reset at Start**: Call `resetTestStats()` at the beginning of your test run
2. **Consistent Usage**: Use either `powerAssert` or `powerAssertWithStats` consistently
3. **Handle Failures**: Wrap failing assertions in try-except blocks
4. **Document Skips**: Always provide a reason when using `skipTest()`
5. **Check Return Codes**: Use statistics to determine test suite success

## Example: Complete Test Runner

```nim
import power_assert
import os

proc runTests(): int =
  resetTestStats()
  
  # Run your tests here
  powerAssertWithStats(1 + 1 == 2)
  
  try:
    powerAssertWithStats(false, "This should fail")
  except PowerAssertDefect:
    discard
  
  skipTest("Feature not implemented")
  
  # Print summary
  printTestSummary()
  
  # Return exit code based on failures
  let stats = getTestStats()
  return if stats.failed > 0: 1 else: 0

when isMainModule:
  quit(runTests())
```

## Output Examples

### All Tests Pass
```
Test Summary:
=============
PASSED:  10
FAILED:  0
SKIPPED: 2
TOTAL:   12

✅ All tests passed!
```

### Some Tests Fail
```
Test Summary:
=============
PASSED:  8
FAILED:  2
SKIPPED: 2
TOTAL:   12

❌ 2 test(s) failed
```

### No Tests Run
```
Test Summary:
=============
PASSED:  0
FAILED:  0
SKIPPED: 0
TOTAL:   0

ℹ️  No tests were run
```

## Tips

- Statistics are global and accumulate across all tests
- Use `getTestStats()` to implement custom reporting
- Combine with CI/CD systems by checking the failed count
- Statistics persist across multiple test files in the same process