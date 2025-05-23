## Configuration Example
## ===================
##
## This example demonstrates how to configure the PowerAssert hint system
## to customize its behavior and appearance.

import std/[strutils, terminal]
import ../src/power_assert

# Example 1: Basic configuration
proc basicConfigExample() =
  echo "=== Basic Configuration Example ==="
  
  # Enable/disable hints globally
  disableHints()
  
  let x = 5
  let y = 10
  
  echo "With hints disabled:"
  try:
    powerAssert(x + y == 20)
  except PowerAssertDefect as e:
    echo e.msg
  
  # Re-enable hints
  enableHints()
  
  echo "\nWith hints enabled:"
  try:
    powerAssert(x + y == 20)
  except PowerAssertDefect as e:
    echo e.msg

# Example 2: Limiting the number of hints
proc limitHintsExample() =
  echo "\n=== Limiting Hints Example ==="
  
  # Set maximum number of hints to 1
  setMaxHints(1)
  
  let text = "hello"
  let number = 42
  
  echo "With max hints set to 1:"
  try:
    powerAssert(text.len == number)  # This would normally generate multiple hints
  except PowerAssertDefect as e:
    echo e.msg
  
  # Reset to default
  setMaxHints(3)

# Example 3: Configuring hint types
proc hintTypesExample() =
  echo "\n=== Hint Types Configuration Example ==="
  
  # Show only suggestions, disable other hint types
  configureHintTypes(
    showTypeHints = false,
    showCommonMistakes = false, 
    showSuggestions = true,
    showNotes = false
  )
  
  let a = 10
  let b = "20"
  
  echo "With only suggestions enabled:"
  try:
    powerAssert(a == parseInt(b))
  except PowerAssertDefect as e:
    echo e.msg
  
  # Reset to show all hint types
  configureHintTypes()

# Example 4: Custom color configuration
proc customColorsExample() =
  echo "\n=== Custom Colors Example ==="
  
  # Create custom hint colors
  var customConfig = hintConfig
  customConfig.colors.typeMismatch = fgMagenta
  customConfig.colors.suggestion = fgBlue
  customConfig.colors.hintPrefix = fgGreen
  
  setHintConfig(customConfig)
  
  let value1 = 42
  let value2 = "42"
  
  echo "With custom colors:"
  try:
    powerAssert(value1 == parseInt(value2))
  except PowerAssertDefect as e:
    echo e.msg

# Example 5: Creating a minimal configuration
proc minimalConfigExample() =
  echo "\n=== Minimal Configuration Example ==="
  
  # Create a minimal hint configuration
  var minimalConfig = HintConfig(
    enabled: true,
    maxHints: 1,
    showTypeHints: true,
    showCommonMistakes: false,
    showSuggestions: false,
    showNotes: false,
    colors: HintColorConfig(
      typeMismatch: fgRed,
      commonMistake: fgYellow,
      suggestion: fgGreen,
      note: fgCyan,
      hintPrefix: fgMagenta
    )
  )
  
  setHintConfig(minimalConfig)
  
  let list1 = @[1, 2, 3]
  let list2 = @[1, 2, 4]
  
  echo "With minimal configuration (only type hints, max 1):"
  try:
    powerAssert(list1 == list2)
  except PowerAssertDefect as e:
    echo e.msg

# Example 6: Completely disable hints for production
proc productionConfigExample() =
  echo "\n=== Production Configuration Example ==="
  
  # Configuration suitable for production: hints disabled
  var productionConfig = HintConfig(
    enabled: false,
    maxHints: 0,
    showTypeHints: false,
    showCommonMistakes: false,
    showSuggestions: false,
    showNotes: false,
    colors: HintColorConfig()  # Colors don't matter when disabled
  )
  
  setHintConfig(productionConfig)
  
  let expected = 100
  let actual = 99
  
  echo "With production configuration (no hints):"
  try:
    powerAssert(actual == expected)
  except PowerAssertDefect as e:
    echo e.msg
  
  # Note: You would typically set this once at the start of your program
  # rather than changing it dynamically like in this example

when isMainModule:
  basicConfigExample()
  limitHintsExample()
  hintTypesExample()
  customColorsExample()
  minimalConfigExample()
  productionConfigExample()
  
  echo "\n=== Configuration Tips ==="
  echo "• Use disableHints() for production builds"
  echo "• Use setMaxHints(1) to reduce verbosity"
  echo "• Use configureHintTypes() to show only relevant hints"
  echo "• Configure colors once at program startup"
  echo "• Consider environment variables for configuration"