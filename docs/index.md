# PowerAssert for Nim Documentation

## Overview

PowerAssert for Nim is a powerful assertion library that provides detailed and visual error messages to improve testing efficiency and debugging experience. It enhances standard `assert` and `check` macros with power-assert.js style visual output.

## Features

- **Power-assert.js Style Visual Output**: Multi-line visual trees showing expression breakdown
- **Automatic Value Extraction**: Extract values from expressions automatically using Nim's macro system
- **Enhanced Visual Display**: Aligned values under their corresponding expressions with vertical connectors
- **Color-Coded Output**: Color-coded elements for better readability
- **Type Information**: Each value includes detailed type information
- **Custom Type Support**: Comprehensive support for user-defined types
- **unittest Integration**: Seamless integration with Nim's standard unittest module
- **Side-Effect Safety**: Expressions are evaluated only once, even when they contain side effects
- **Test Statistics Tracking**: Built-in PASSED/FAILED/SKIPPED counters with summary reports
- **Multiple Output Formats**: PowerAssertJS, Compact, Detailed, Classic, and Custom formats
- **Custom Formatters**: Create your own output formatters for specialized needs

## Quick Start

### Installation

```bash
nimble install power_assert
```

### Basic Usage

```nim
import power_assert

let x = 5
let y = 7

powerAssert(x + y == 15)  # This will fail with detailed error message
```

Output with enhanced visual formatting:

```
PowerAssert: Assertion failed

x + y == 15
|||||    ||
|        |
12       15

[int] x + y
=> 12
[int] 15
=> 15
```

### Integration with unittest

```nim
import unittest
import power_assert

test "basic arithmetic":
  let a = 5
  let b = 7
  check(a + b == 12)    # Success
  check(a * b == 30)    # Failure with detailed visual output
```

## Documentation Index

### Getting Started
- [User Guide](user_guide.md) - Detailed usage instructions and feature explanations
- [API Reference](api_reference.md) - Complete technical documentation of all functions and types
- [Best Practices](best_practices.md) - Recommendations for effective use of PowerAssert
- [Examples](examples.md) - Various usage scenarios and code samples

### Configuration and Customization
- [Configuration Guide](configuration.md) - Color themes, output settings, and customization options
- [Test Statistics](test_statistics.md) - Track and report PASSED/FAILED/SKIPPED test counts
- [Custom Formatters](custom_formatters.md) - Create your own output formatters
- [Migration Guide](migration_guide.md) - How to migrate from standard assertions

### Troubleshooting and Support
- [Troubleshooting Guide](troubleshooting.md) - Common issues and their solutions
- [FAQ](faq.md) - Frequently asked questions and answers

### Development and Contributing
- [Implementation Details](implementation_details.md) - Library design and implementation details
- [Contributing Guidelines](contributing.md) - How to contribute to PowerAssert
- [TODO List](TODO.md) - Future development plans and improvement items

## Visual Output Examples

The enhanced visual output makes it immediately clear what went wrong:

### Simple Expression
```nim
let x = 10
let y = 5  
powerAssert(x * y == 60)
```

Output:
```
PowerAssert: Assertion failed

x * y == 60
|||||    ||
|        |
50       60

[int] x * y
=> 50
[int] 60
=> 60
```

### Complex Boolean Expression
```nim
let isActive = true
let score = 85
let threshold = 90
powerAssert(isActive and score > threshold)
```

Output:
```
PowerAssert: Assertion failed

isActive and score > threshold
||||||||||||||||||||||||||||||
|
false

[bool] isActive and score > threshold
=> false
```

## Contributing

We welcome contributions to PowerAssert for Nim! Bug reports, feature requests, and pull requests are all welcome on the GitHub repository. Please see the [Contributing Guidelines](contributing.md) for details.

## License

PowerAssert for Nim is released under the MIT License. See the LICENSE file for details.