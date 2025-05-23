# PowerAssert Configuration

This document describes the configuration options available for customizing PowerAssert's behavior and appearance.

## Table of Contents

1. [Color Configuration](#color-configuration)
2. [Visual Output Settings](#visual-output-settings)
3. [Runtime Configuration](#runtime-configuration)
4. [Environment Variables](#environment-variables)
5. [Examples](#examples)

## Color Configuration

PowerAssert provides extensive color customization through the `ColorConfig` type.

### ColorConfig Type

```nim
type ColorConfig* = object
  enabled*: bool                    # Enable/disable colored output
  errorTitle*: ForegroundColor      # Color for error titles
  expressionCode*: ForegroundColor  # Color for expression code
  indicator*: ForegroundColor       # Color for visual indicators (|, ^)
  values*: ForegroundColor          # Default color for values
  types*: ForegroundColor           # Color for type information
  compositeHeader*: ForegroundColor # Color for section headers
  
  # Specific value type colors
  numberValues*: ForegroundColor    # Color for numeric values
  stringValues*: ForegroundColor    # Color for string values
  boolValues*: ForegroundColor      # Color for boolean values
  errorValues*: ForegroundColor     # Color for error values
```

### Default Color Scheme

The default color configuration is:

```nim
var colorConfig = ColorConfig(
  enabled: true,
  errorTitle: fgRed,
  expressionCode: fgWhite,
  indicator: fgCyan,
  values: fgYellow,
  types: fgGreen,
  compositeHeader: fgMagenta,
  numberValues: fgYellow,
  stringValues: fgGreen,
  boolValues: fgBlue,
  errorValues: fgRed
)
```

### Customizing Colors

You can modify the global color configuration:

```nim
import power_assert

# Customize individual colors
colorConfig.errorTitle = fgMagenta
colorConfig.expressionCode = fgCyan
colorConfig.indicator = fgYellow

# Or create a custom theme
proc setDarkTheme() =
  colorConfig.enabled = true
  colorConfig.errorTitle = fgRed
  colorConfig.expressionCode = fgWhite
  colorConfig.indicator = fgCyan
  colorConfig.values = fgYellow
  colorConfig.types = fgGreen
  colorConfig.numberValues = fgYellow
  colorConfig.stringValues = fgGreen
  colorConfig.boolValues = fgBlue

proc setLightTheme() =
  colorConfig.enabled = true
  colorConfig.errorTitle = fgRed
  colorConfig.expressionCode = fgBlack
  colorConfig.indicator = fgBlue
  colorConfig.values = fgMagenta
  colorConfig.types = fgGreen
  colorConfig.numberValues = fgMagenta
  colorConfig.stringValues = fgGreen
  colorConfig.boolValues = fgBlue

# Apply theme
setDarkTheme()
```

### Disabling Colors

To disable colored output entirely:

```nim
colorConfig.enabled = false
```

This is useful for:
- CI/CD environments that don't support colors
- Log files where colors would be distracting
- Terminal environments with limited color support

## Visual Output Settings

### Terminal Detection

PowerAssert automatically detects terminal capabilities and adjusts output accordingly:

```nim
# PowerAssert automatically detects if colors are supported
when defined(windows):
  # Windows-specific color handling
elif defined(posix):
  # Unix/Linux/macOS color handling
```

### Output Width

PowerAssert adapts to different terminal widths. The visual tree output automatically adjusts to prevent line wrapping in most cases.

### Unicode Support

PowerAssert uses ASCII characters by default for maximum compatibility, but you can enable Unicode characters for enhanced visual output:

```nim
# Note: This would require additional implementation
# Currently PowerAssert uses ASCII characters (| and ^) for maximum compatibility
```

## Runtime Configuration

### Conditional Compilation

PowerAssert behavior can be controlled at compile time:

```nim
# In debug builds, full PowerAssert functionality is enabled
when not defined(release) and not defined(danger):
  # Full visual output and analysis
  powerAssert(condition)
else:
  # Minimal overhead in release builds
  assert(condition)
```

### Custom Formatters

You can extend PowerAssert's formatting capabilities:

```nim
# Custom formatValue for your types
proc formatValue*[T: MyCustomType](val: T): string =
  # Custom formatting logic
  result = "MyType(" & $val.field1 & ", " & $val.field2 & ")"
```

## Environment Variables

PowerAssert respects several environment variables:

### POWER_ASSERT_COLORS

Control color output:

```bash
# Enable colors (default)
export POWER_ASSERT_COLORS=1

# Disable colors
export POWER_ASSERT_COLORS=0
```

### NO_COLOR

PowerAssert respects the `NO_COLOR` environment variable standard:

```bash
# Disable colors according to NO_COLOR standard
export NO_COLOR=1
```

### TERM

PowerAssert checks the `TERM` environment variable to determine color support:

```bash
# Terminals that typically support colors
TERM=xterm-256color
TERM=screen-256color

# Terminals that might not support colors
TERM=dumb
```

## Examples

### Complete Configuration Example

```nim
import power_assert

proc configureCustomPowerAssert() =
  # Enable colors
  colorConfig.enabled = true
  
  # Set custom colors for better visibility
  colorConfig.errorTitle = fgRed
  colorConfig.expressionCode = fgWhite
  colorConfig.indicator = fgCyan
  colorConfig.values = fgYellow
  colorConfig.types = fgGreen
  colorConfig.compositeHeader = fgMagenta
  
  # Customize value type colors
  colorConfig.numberValues = fgYellow
  colorConfig.stringValues = fgGreen
  colorConfig.boolValues = fgBlue
  colorConfig.errorValues = fgRed

# Apply configuration
configureCustomPowerAssert()

# Use PowerAssert with custom configuration
let x = 10
let y = 5
powerAssert(x * y == 60)
```

### Conditional Configuration Based on Environment

```nim
import power_assert, os

proc configureForEnvironment() =
  # Check if we're in a CI environment
  if existsEnv("CI") or existsEnv("GITHUB_ACTIONS"):
    colorConfig.enabled = false  # Disable colors in CI
  elif existsEnv("NO_COLOR"):
    colorConfig.enabled = false  # Respect NO_COLOR standard
  else:
    colorConfig.enabled = true   # Enable colors locally

configureForEnvironment()
```

### Theme Switching

```nim
import power_assert

type Theme = enum
  DarkTheme, LightTheme, MonochromeTheme

proc setTheme(theme: Theme) =
  case theme
  of DarkTheme:
    colorConfig.enabled = true
    colorConfig.errorTitle = fgRed
    colorConfig.expressionCode = fgWhite
    colorConfig.indicator = fgCyan
    colorConfig.values = fgYellow
    colorConfig.types = fgGreen
  
  of LightTheme:
    colorConfig.enabled = true
    colorConfig.errorTitle = fgRed
    colorConfig.expressionCode = fgBlack
    colorConfig.indicator = fgBlue
    colorConfig.values = fgMagenta
    colorConfig.types = fgGreen
  
  of MonochromeTheme:
    colorConfig.enabled = false

# Usage
setTheme(DarkTheme)
```

### Custom Type Formatting

```nim
import power_assert

type
  Point = object
    x, y: float
  
  Rectangle = object
    topLeft, bottomRight: Point

# Custom formatter for Point
proc `$`(p: Point): string =
  fmt"({p.x:.1f}, {p.y:.1f})"

# Custom formatter for Rectangle
proc `$`(r: Rectangle): string =
  fmt"Rect[{r.topLeft} to {r.bottomRight}]"

# Now PowerAssert will use these custom formatters
let rect = Rectangle(
  topLeft: Point(x: 0.0, y: 0.0),
  bottomRight: Point(x: 10.0, y: 5.0)
)

powerAssert(rect.topLeft.x == 0.0)
# Output will use the custom Point formatting
```

### Performance Configuration

```nim
import power_assert

# For performance-critical code, you might want to disable 
# PowerAssert in release builds
template performanceAssert(condition: untyped, message: string = "") =
  when defined(debug):
    powerAssert(condition, message)
  else:
    assert(condition, message)

# Usage
performanceAssert(expensiveCalculation() > threshold)
```

## Platform-Specific Configuration

### Windows

```nim
when defined(windows):
  # Windows-specific configuration
  proc enableWindowsColors() =
    # Enable ANSI color support on Windows 10+
    when defined(windows):
      import winlean
      # Code to enable ANSI colors on Windows console
```

### Unix/Linux/macOS

```nim
when defined(posix):
  # Unix-like systems typically have good color support
  colorConfig.enabled = true
```

## Best Practices

1. **Configure early**: Set up your color configuration before using PowerAssert
2. **Respect environment**: Check environment variables like `NO_COLOR`
3. **Test different terminals**: Ensure your configuration works across different terminals
4. **Use themes**: Create reusable theme configurations
5. **Document custom configurations**: Make it clear how to reproduce your configuration

This configuration system allows you to tailor PowerAssert's appearance and behavior to your specific needs and environment.