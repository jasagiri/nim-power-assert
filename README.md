# PowerAssert for Nim

A powerful assertion library for Nim that provides **power-assert.js style visual output** with enhanced error messages to improve testing efficiency and debugging experience.

![Build Status: Passing](https://img.shields.io/badge/build-passing-brightgreen)
![Tests: All Passing](https://img.shields.io/badge/tests-all%20passing-brightgreen)
![Nim: 2.2.4+](https://img.shields.io/badge/nim-2.2.4%2B-yellow)
![License: MIT](https://img.shields.io/badge/license-MIT-blue)

## 🚀 Status: Production Ready

PowerAssert for Nim is **fully implemented and production-ready** with all requested features:

- ✅ **power-assert.js style output** - Visual pipe character display with values under expressions
- ✅ **Multiple output formats** - PowerAssertJS, Compact, Detailed, and Classic templates  
- ✅ **Test statistics tracking** - PASSED/FAILED/SKIPPED counts with summary reports
- ✅ **Template-based formatting** - Independent from core logic, easily configurable
- ✅ **Full backward compatibility** - All existing tests pass

## Features

### 🎯 Core Functionality
- **Visual Expression Trees**: power-assert.js style output with pipe characters and aligned values
- **Multiple Output Formats**: 4 different display styles to suit your preferences
- **Test Statistics**: Built-in tracking of test results with summary reports
- **Automatic Value Extraction**: Uses Nim's macro system for detailed expression analysis
- **unittest Integration**: Seamless drop-in replacement for standard `check` templates
- **Side-Effect Safety**: Expressions evaluated exactly once to prevent unintended side effects
- **Type Safety**: Full compile-time type checking and comprehensive type support

### 📊 Output Formats

#### 1. PowerAssertJS (Default) - power-assert.js Style
```nim
isLess(x, y)
|      |  | 
          5 
       10   

isLess = <proc (a: int, b: int): bool>
```

#### 2. Compact Format
```nim
assert(isLess(x, y)) failed [x=10, y=5, isLess=<proc>]
```

#### 3. Detailed Format
```nim
PowerAssert Failure Details:
══════════════════════════════════════════════════
Expression: isLess(x, y)
Variables:
  isLess               = <proc (a: int, b: int): bool>
  x                    = 10
  y                    = 5
══════════════════════════════════════════════════
```

#### 4. Classic Format
```nim
Expression: isLess(x, y)

Result: false

Subexpression values:
x => 10
y => 5
isLess => <proc>

isLess(x, y)
^      ^   ^
```

## Quick Start

### Installation

```bash
nimble install power_assert
```

### Basic Usage

```nim
import power_assert

# Simple assertions with automatic visual output
let x = 10
let y = 5

proc isLess(a, b: int): bool = a < b

# This will show the detailed visual output when it fails
powerAssert(isLess(x, y))
```

### With Test Statistics

```nim
import power_assert

# Reset counters
resetTestStats()

# Run tests with automatic statistics tracking
powerAssertWithStats(someCondition, "Test description")
powerAssertWithStats(anotherCondition)

# Skip tests when needed
skipTest("This feature is not yet implemented")

# Show final summary
printTestSummary()
# Output:
# Test Summary:
# =============
# PASSED:  3
# FAILED:  1
# SKIPPED: 1
# TOTAL:   5
```

### Format Configuration

```nim
import power_assert

# Switch between different output formats
setOutputFormat(PowerAssertJS)  # Default - power-assert.js style
setOutputFormat(Compact)        # Single line format
setOutputFormat(Detailed)       # Structured detailed format
setOutputFormat(Classic)        # Traditional format with pointers

# Check current format
let currentFormat = getOutputFormat()
```

### unittest Integration

```nim
import unittest except check
import power_assert

suite "My Test Suite":
  test "Basic functionality":
    let value = 42
    powerAssert(value > 0, "Value must be positive")
    
  test "With statistics":
    powerAssertWithStats(someComplexCondition())
```

## API Reference

### Core Functions
- `powerAssert(condition, message = "")` - Main assertion with visual output
- `powerAssertWithStats(condition, message = "")` - Assertion with automatic statistics tracking

### Format Control
- `setOutputFormat(format: OutputFormat)` - Set the output format
- `getOutputFormat(): OutputFormat` - Get current output format

### Statistics Management
- `recordPassed()`, `recordFailed()`, `recordSkipped()` - Manual statistics recording
- `getTestStats(): TestStats` - Get current statistics
- `resetTestStats()` - Reset all counters
- `printTestSummary()` - Display formatted summary
- `skipTest(reason: string)` - Mark test as skipped

### Template Aliases
- `assert(condition, message = "")` - Alias for powerAssert
- `doAssert(condition, message = "")` - Alias for powerAssert
- `check(condition, message = "")` - unittest compatibility
- `require(condition, message = "")` - Precondition checking

## Examples

See the [examples/](examples/) directory for comprehensive usage examples:

- `examples/format_demo.nim` - Demonstrates all output formats
- `examples/enhanced_demo.nim` - Shows complex expression handling
- `examples/basic_example.nim` - Simple getting started example

## Documentation

- [FORMAT_GUIDE.md](docs/FORMAT_GUIDE.md) - Detailed guide to output formats
- [API Reference](docs/api_reference.md) - Complete API documentation
- [Usage Guide](docs/usage_guide.md) - Comprehensive usage examples
- [Best Practices](docs/best_practices.md) - Recommended usage patterns

## Implementation

PowerAssert for Nim uses Nim's powerful macro system to:

1. **Analyze Expression Structure**: Traverse the AST of condition expressions
2. **Instrument Expressions**: Evaluate exactly once and capture intermediate values
3. **Generate Visual Output**: Create power-assert.js style visual displays
4. **Format Results**: Apply selected template formatting
5. **Track Statistics**: Optionally record test results for summary reporting

The implementation is designed to be:
- **Zero-overhead when passing**: No performance impact for successful assertions
- **Template-based**: Formatting is completely separate from core logic
- **Extensible**: Easy to add new output formats
- **Safe**: No side effects from expression evaluation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass: `nimble test`
6. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by [power-assert.js](https://github.com/power-assert-js/power-assert) for JavaScript
- Built with Nim's powerful macro system
- Thanks to the Nim community for feedback and suggestions