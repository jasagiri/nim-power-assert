# PowerAssert Examples

This directory contains comprehensive examples demonstrating all PowerAssert features including visual output formats, test statistics, custom formatters, and more. 

## Core Examples

### basic_example.nim
Basic usage of PowerAssert with simple assertions and error messages.

### enhanced_basic_example.nim
Enhanced version showing power-assert.js style visual output with pipe characters.

### format_demo.nim
Demonstrates all four built-in output formats:
- PowerAssertJS (default)
- Compact
- Detailed
- Classic

### statistics_demo.nim
Shows test statistics tracking with PASSED/FAILED/SKIPPED counts:
```bash
nim c -r statistics_demo.nim
```

### custom_formatter_simple.nim
Simple example of creating custom output formatters.

### custom_formatter_workaround.nim
Example with workarounds for avoiding operator ambiguity issues.

### unittest_integration_example.nim
Integration with Nim's standard unittest framework.

### unittest_integration_statistics.nim
Combining unittest with test statistics tracking.

## Additional Examples

### custom_types_example.nim
Demonstrates PowerAssert with custom types and objects.

### data_types_example.nim
Shows support for various data types including sequences, arrays, and tables.

### performance_comparison.nim
Compares performance between standard assert and PowerAssert.

### config_example.nim
Configuration options for colors and output settings.

### enhanced_demo.nim
Complex expressions with enhanced visual output.

### visual_comparison_example.nim
Side-by-side comparison of different output formats.

## Running Examples

### Run a specific example:
```bash
nim c -r examples/statistics_demo.nim
```

### Run all examples:
```bash
cd examples && ./run_all_examples.sh
```

## Key Features Demonstrated

### 1. Test Statistics
Track PASSED/FAILED/SKIPPED counts:
```nim
powerAssertWithStats(condition)  # Tracks result
printTestSummary()               # Shows summary
```

### 2. Output Formats
Switch between different visual styles:
```nim
setOutputFormat(PowerAssertJS)  # Default
setOutputFormat(Compact)        # One-line
setOutputFormat(Detailed)       # Structured
setOutputFormat(Classic)        # Traditional
```

### 3. Custom Formatters
Create your own output format:
```nim
proc myFormatter(expr: string, values: CapturedValues): string =
  # Custom formatting logic
  
setCustomRenderer(myFormatter)
```

### 4. unittest Integration
Works seamlessly with Nim's unittest:
```nim
import unittest except check
import power_assert

test "example":
  powerAssert(condition)
```

## Documentation

For detailed documentation, see:
- [Test Statistics Guide](../docs/test_statistics.md)
- [Custom Formatters Guide](../docs/custom_formatters.md)
- [API Reference](../docs/api_reference.md)
- [User Guide](../docs/user_guide.md)