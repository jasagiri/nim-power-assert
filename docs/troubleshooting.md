# PowerAssert Troubleshooting Guide

This guide helps you diagnose and resolve common issues when using PowerAssert for Nim.

## Table of Contents

1. [Installation Issues](#installation-issues)
2. [Compilation Problems](#compilation-problems)
3. [Visual Output Issues](#visual-output-issues)
4. [Integration Problems](#integration-problems)
5. [Performance Issues](#performance-issues)
6. [Hint System Issues](#hint-system-issues)
7. [Common Errors](#common-errors)
8. [Getting Help](#getting-help)

## Installation Issues

### Package Not Found

**Problem**: `nimble install power_assert` fails with package not found.

**Solutions**:
1. Update nimble package list:
   ```bash
   nimble refresh
   nimble install power_assert
   ```

2. Install from source:
   ```bash
   git clone https://github.com/your-repo/power_assert_nim.git
   cd power_assert_nim
   nimble install
   ```

3. Check Nim version compatibility:
   ```bash
   nim --version  # Should be 1.6.0 or higher
   ```

### Dependency Conflicts

**Problem**: PowerAssert conflicts with other packages.

**Solution**: Check your project's nimble file for conflicting dependencies:
```nim
# In your .nimble file
requires "nim >= 1.6.0"
requires "power_assert >= 1.0.0"
```

## Compilation Problems

### Macro Expansion Errors

**Problem**: Errors during macro expansion phase.

```
Error: cannot evaluate at compile time
```

**Solution**: Ensure you're not using runtime-only operations in compile-time contexts:

```nim
# Bad - runtime operation in compile-time context
powerAssert(readFile("test.txt").len > 0)

# Good - separate compile-time and runtime
let content = readFile("test.txt")
powerAssert(content.len > 0)
```

### Template/Macro Conflicts

**Problem**: PowerAssert conflicts with other macros or templates.

**Solution**: Use explicit module qualification:
```nim
import unittest
import power_assert

# Explicit qualification when there are conflicts
power_assert.check(condition)
unittest.check(condition)
```

### Type Inference Issues

**Problem**: Nim cannot infer types in complex expressions.

**Solution**: Add explicit type annotations:
```nim
# Add type hints when needed
let result: bool = complexFunction()
powerAssert(result == true)
```

## Visual Output Issues

### Colors Not Displaying

**Problem**: Output appears without colors in terminal.

**Diagnosis**:
```nim
import power_assert
echo "Color support: ", colorConfig.enabled
```

**Solutions**:

1. **Force enable colors**:
   ```nim
   colorConfig.enabled = true
   ```

2. **Check terminal support**:
   ```bash
   echo $TERM  # Should be something like xterm-256color
   ```

3. **Set environment variables**:
   ```bash
   export TERM=xterm-256color
   export COLORTERM=truecolor
   ```

4. **Windows users**:
   ```bash
   # Enable ANSI colors on Windows 10+
   reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1
   ```

### Garbled Output

**Problem**: Visual output appears garbled or misaligned.

**Causes**:
- Terminal doesn't support Unicode
- Wrong terminal encoding
- Terminal width issues

**Solutions**:

1. **Check terminal encoding**:
   ```bash
   echo $LANG  # Should include UTF-8
   export LANG=en_US.UTF-8
   ```

2. **Test with simple expressions first**:
   ```nim
   let x = 5
   powerAssert(x == 10)  # Test with simple case
   ```

3. **Disable colors temporarily**:
   ```nim
   colorConfig.enabled = false
   ```

### Missing Visual Elements

**Problem**: Visual tree structure doesn't display properly.

**Solution**: Ensure you're using debug builds:
```bash
nim c -d:debug your_file.nim  # Debug build
# vs
nim c -d:release your_file.nim  # Release build (minimal output)
```

## Integration Problems

### unittest Module Conflicts

**Problem**: PowerAssert conflicts with standard unittest.

**Solution**: Import order matters:
```nim
# Correct order
import unittest
import power_assert  # This should override unittest's check

test "my test":
  check(condition)  # Will use PowerAssert
```

### Custom Test Frameworks

**Problem**: PowerAssert doesn't work with custom testing frameworks.

**Solution**: Use PowerAssert directly:
```nim
proc myCustomTest(name: string, testProc: proc()) =
  try:
    testProc()
    echo "✓ ", name
  except PowerAssertDefect as e:
    echo "✗ ", name
    echo e.msg

myCustomTest "arithmetic":
  powerAssert(2 + 2 == 4)
```

## Performance Issues

### Slow Compilation

**Problem**: Compilation is slow with PowerAssert.

**Causes**:
- Complex macro expansions
- Large expressions being analyzed

**Solutions**:

1. **Use conditional compilation**:
   ```nim
   when defined(debug):
     powerAssert(complexExpression)
   else:
     assert(complexExpression)
   ```

2. **Simplify expressions**:
   ```nim
   # Instead of one complex assertion
   powerAssert(a.b.c.d == x.y.z and p.q.r > threshold)
   
   # Break it down
   let leftSide = a.b.c.d
   let rightSide = x.y.z
   let conditionA = leftSide == rightSide
   let conditionB = p.q.r > threshold
   powerAssert(conditionA and conditionB)
   ```

### Runtime Performance

**Problem**: Tests run slower with PowerAssert.

**Solution**: PowerAssert is designed to be efficient, but for performance-critical code:

```nim
template fastAssert(condition: untyped) =
  when defined(debug):
    powerAssert(condition)
  else:
    assert(condition)

# Use fastAssert in performance-critical sections
fastAssert(criticalCondition)
```

## Hint System Issues

### Hints Not Appearing

**Problem**: PowerAssert doesn't show helpful hints in error messages.

**Causes**:
- Running in release mode
- Hints disabled globally
- Expression too simple for hints

**Solutions**:

1. **Ensure debug mode**:
   ```bash
   nim c -d:debug your_file.nim  # Hints work best in debug mode
   ```

2. **Check hint system is working**:
   ```nim
   import power_assert
   
   # This should show a hint about string case differences
   let a = "Hello"
   let b = "hello"
   powerAssert(a == b)
   ```

3. **Verify expression complexity**:
   ```nim
   # Too simple - may not generate hints
   powerAssert(x == 5)
   
   # Better - more likely to generate helpful hints
   let actual = processData(input)
   let expected = getExpectedResult()
   powerAssert(actual == expected)
   ```

### Irrelevant or Confusing Hints

**Problem**: Hints don't seem applicable to the actual problem.

**Solutions**:

1. **Use descriptive variable names**:
   ```nim
   # Vague - hints reference unclear variables
   let x = getValue()
   let y = getOther()
   powerAssert(x == y)
   
   # Clear - hints reference meaningful variables
   let actualBalance = account.getBalance()
   let expectedBalance = calculateExpectedBalance()
   powerAssert(actualBalance == expectedBalance)
   ```

2. **Break down complex expressions**:
   ```nim
   # Complex - may generate generic hints
   powerAssert(users.filter(u => u.isActive).map(u => u.id).contains(targetId))
   
   # Clearer - specific hints for each step
   let activeUsers = users.filter(u => u.isActive)
   let userIds = activeUsers.map(u => u.id)
   powerAssert(userIds.contains(targetId))
   ```

### Missing Type Information in Hints

**Problem**: Hints don't show detailed type information.

**Solution**: Ensure custom types implement proper string representation:

```nim
type User = object
  name: string
  age: int

# Without this, hints will be less helpful
proc `$`(user: User): string =
  fmt"User(name: {user.name}, age: {user.age})"

# Now hints can reference meaningful type information
let user1 = User(name: "Alice", age: 30)
let user2 = User(name: "Bob", age: 25)
powerAssert(user1 == user2)  # Hints will show User details
```

### Hint Overload

**Problem**: Too many hints make output cluttered.

**Solutions**:

1. **Use more specific assertions**:
   ```nim
   # Too broad - generates many hints
   powerAssert(validateAll(data))
   
   # Specific - targeted hints
   powerAssert(data.isValid, "Data validation failed")
   powerAssert(data.hasRequiredFields, "Missing required fields")
   powerAssert(data.meetsConstraints, "Data constraint violation")
   ```

2. **Separate complex conditions**:
   ```nim
   # Complex - multiple hints
   powerAssert(user.isActive and user.hasPermission and user.age >= 18)
   
   # Separated - focused hints
   powerAssert(user.isActive, "User must be active")
   powerAssert(user.hasPermission, "User needs permission")
   powerAssert(user.age >= 18, "User must be adult")
   ```

### Customizing Hint Behavior

Currently, hints are automatically generated based on expression analysis. Future versions may include:

```nim
# Hypothetical future API
powerAssert(condition, hints = false)  # Disable hints for this assertion
powerAssert(condition, customHint = "Check the user manual for details")
```

### Understanding Hint Categories

**Type Mismatch Hints**: Look for suggestions about type conversions
```
Help:
  type mismatch: Comparing int with float
    → Consider converting one type: float(intValue) or int(floatValue)
```

**String Comparison Hints**: Focus on case, length, and content differences
```
Help:
  suggestion: Strings differ only in case
    → Use .toLowerAscii() or .toUpperAscii() for case-insensitive comparison
```

**Boolean Logic Hints**: Understand why logical operations failed
```
Help:
  note: Boolean AND operation failed
    → All conditions in 'and' expression must be true. Check each condition separately.
```

**Collection Hints**: Get insights about data structure states
```
Help:
  note: Collection is empty
    → Verify that elements were added to the collection before testing
```

## Common Errors

### "undeclared identifier: 'powerAssert'"

**Problem**: PowerAssert not imported correctly.

**Solution**:
```nim
import power_assert  # Make sure this line is present
```

### "ambiguous call"

**Problem**: Multiple modules provide the same symbol.

**Solution**: Use explicit module qualification:
```nim
import unittest
import power_assert

# Be explicit about which check to use
power_assert.check(condition)
```

### "type mismatch"

**Problem**: Expression types don't match expected types.

**Example Error**:
```
type mismatch: got <string> but expected <int>
```

**Solution**: Check your expression types:
```nim
let stringValue = "42"
let intValue = 42

# Wrong - comparing different types
# powerAssert(stringValue == intValue)

# Correct - convert types appropriately
powerAssert(parseInt(stringValue) == intValue)
```

### "cannot evaluate at compile time"

**Problem**: Using runtime operations in compile-time contexts.

**Solution**: Separate compile-time and runtime operations:
```nim
# Wrong - file I/O at compile time
# powerAssert(staticRead("file.txt").len > 0)

# Correct - runtime evaluation
let content = readFile("file.txt")
powerAssert(content.len > 0)
```

## Custom Type Issues

### "no `$` operator available"

**Problem**: Custom type doesn't have string representation.

**Solution**: Implement the `$` operator:
```nim
type MyType = object
  field1: int
  field2: string

proc `$`(obj: MyType): string =
  fmt"MyType(field1: {obj.field1}, field2: {obj.field2})"

let obj = MyType(field1: 42, field2: "hello")
powerAssert(obj.field1 == 42)  # Now works
```

### Custom Comparison Issues

**Problem**: Custom types can't be compared.

**Solution**: Implement comparison operators:
```nim
proc `==`(a, b: MyType): bool =
  a.field1 == b.field1 and a.field2 == b.field2

proc `<`(a, b: MyType): bool =
  a.field1 < b.field1
```

## Debug Techniques

### Enable Verbose Output

```nim
# Add debug information
when defined(debug):
  echo "PowerAssert version: 1.0.0"
  echo "Color support: ", colorConfig.enabled
  echo "Terminal: ", getEnv("TERM")
```

### Test with Simple Cases

When troubleshooting, start with simple assertions:

```nim
# Test basic functionality first
let x = 5
powerAssert(x == 5)  # Should work

# Then move to more complex cases
let arr = @[1, 2, 3]
powerAssert(arr.len == 3)
```

### Check Generated Code

Use `dumpTree` to see what PowerAssert generates:

```nim
import macros

macro debugPowerAssert(condition: untyped): untyped =
  echo condition.treeRepr
  result = quote do:
    powerAssert(`condition`)

# Use debugPowerAssert to see macro expansion
debugPowerAssert(x == y)
```

## Environment-Specific Issues

### Windows Issues

1. **ANSI color support**: Ensure Windows 10+ with ANSI support enabled
2. **Path issues**: Use forward slashes or `os.PathSeparator`
3. **Console encoding**: Set console to UTF-8

### macOS Issues

1. **Terminal app**: Use Terminal.app or iTerm2 for best support
2. **Homebrew Nim**: If using Homebrew, ensure latest version

### Linux Issues

1. **Terminal emulator**: Most modern terminals work well
2. **SSH sessions**: Colors might be disabled over SSH
3. **Docker containers**: May need explicit color enabling

## Getting Help

### Before Asking for Help

1. **Check the version**:
   ```bash
   nim --version
   nimble list | grep power_assert
   ```

2. **Create a minimal reproduction**:
   ```nim
   import power_assert
   
   let x = 5
   powerAssert(x == 10)  # Minimal failing case
   ```

3. **Include environment information**:
   - Operating system
   - Terminal/IDE used
   - Nim version
   - PowerAssert version

### Where to Get Help

1. **GitHub Issues**: Report bugs and feature requests
2. **Nim Forum**: Ask questions about usage
3. **Discord/IRC**: Real-time help from the community

### Bug Report Template

```markdown
## Bug Description
Brief description of the issue

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What you expected to happen

## Actual Behavior
What actually happened

## Environment
- OS: [e.g., Windows 10, macOS 12, Ubuntu 20.04]
- Terminal: [e.g., Windows Terminal, iTerm2, GNOME Terminal]
- Nim version: [output of `nim --version`]
- PowerAssert version: [output of `nimble list | grep power_assert`]

## Minimal Code Example
```nim
import power_assert
# Your minimal failing code here
```
```

Following this troubleshooting guide should help you resolve most common issues with PowerAssert. If you encounter problems not covered here, please consider contributing to this guide by submitting your solution.