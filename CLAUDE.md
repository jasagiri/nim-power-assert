# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PowerAssert for Nim is a powerful assertion library that provides **power-assert.js style visual output** with enhanced error messages to improve testing efficiency. The library is **fully implemented and production-ready** with all requested features completed.

Key features:
- **power-assert.js style output** - Visual pipe character display with values under expressions
- **Multiple output formats** - PowerAssertJS, Compact, Detailed, and Classic templates
- **Test statistics tracking** - PASSED/FAILED/SKIPPED counts with summary reports  
- **Template-based formatting** - Independent from core logic, easily configurable
- **Full backward compatibility** - All existing tests pass
- **unittest Integration** - Seamless integration with the standard unittest module

## Build and Test Commands

### Installation

```bash
nimble install
```

### Running Tests

To run all tests:
```bash
nimble test
```

To run specific tests:
```bash
cd tests && nim c -r test_power_assert.nim
cd tests && nim c -r test_operators.nim
cd tests && nim c -r test_custom_types.nim
```

### Testing Format Output

To verify the output formats are working correctly:
```bash
nim c -r examples/format_demo.nim
nim c -r examples/enhanced_demo.nim
```

### Development Testing

When testing during development:
```bash
# Quick compilation check
nim check src/power_assert.nim

# Run specific examples
nim c -r examples/basic_example.nim
```

## Code Architecture

The project has a clean modular structure:

1. **Main Implementation** - `src/power_assert.nim`: Contains the core functionality using Nim's macro system with four distinct output formats:
   - PowerAssertJS (default): power-assert.js style with pipe visualization
   - Compact: Single-line format with variable values
   - Detailed: Structured format with clear sections  
   - Classic: Traditional format with pointer visualization

2. **Enhanced Output** - `src/power_assert_enhanced_output.nim`: Additional formatting utilities

3. **Test Suite**: Comprehensive testing covering all functionality:
   - `tests/test_power_assert.nim`: Core functionality tests
   - `tests/test_operators.nim`: Operator handling tests
   - `tests/test_custom_types.nim`: Custom type support tests
   - Multiple additional test files for edge cases and features

4. **Examples**: Working examples demonstrating all features:
   - `examples/format_demo.nim`: Demonstrates all output formats and statistics
   - `examples/enhanced_demo.nim`: Shows complex expression handling
   - `examples/basic_example.nim`: Simple getting started example

## Implementation Details

The library works by using Nim's macro system to:
1. **Analyze expressions** and extract their values
2. **Generate visual output** using the selected template format
3. **Track test statistics** with optional PASSED/FAILED/SKIPPED counting
4. **Provide power-assert.js style output** with pipe characters and aligned values

Key components:
- `powerAssert` macro: Main implementation that instruments expressions
- `renderPowerAssertJS` proc: Generates power-assert.js style visual output
- `formatValue` proc: Handles formatting of different data types
- Statistics API: `powerAssertWithStats`, `printTestSummary`, etc.
- Format selection: `setOutputFormat`, `getOutputFormat`

The code includes handlers for various types including primitives, sequences, arrays, and custom objects.

## Current Status

### ✅ Fully Implemented Features
- **power-assert.js style output** with pipe characters and proper value alignment
- **Four output formats** (PowerAssertJS, Compact, Detailed, Classic)
- **Test statistics tracking** with PASSED/FAILED/SKIPPED counts
- **Template-based formatting** system independent of core logic
- **Complete API** for format control and statistics management
- **Full backward compatibility** with all existing tests passing

### 🏆 Key Achievements
- Power-assert.js style visual output successfully restored and enhanced
- Template system allows format changes without affecting core functionality
- Test statistics provide comprehensive test result tracking
- All user requirements have been fully implemented

## Development Practices

When making changes:
1. Ensure all tests pass after modifications: `nimble test`
2. Test output formats work correctly: `nim c -r examples/format_demo.nim`
3. Add tests for new features
4. Maintain backward compatibility
5. Follow existing code style and patterns
6. Update documentation as needed

The library is fully functional and ready for production use with comprehensive testing coverage and complete feature implementation.

## Examples of Current Functionality

### Power-assert.js Style Output
```
isLess(x, y)
|      |  | 
          5 
       10   

isLess = <proc (a: int, b: int): bool>
```

### Test Statistics
```
Test Summary:
=============
PASSED:  3
FAILED:  2
SKIPPED: 1
TOTAL:   6

❌ 2 test(s) failed
```

All requested features are working perfectly and the library is production-ready.