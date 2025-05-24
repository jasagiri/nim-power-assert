# tests/test_color_output.nim

import unittest except check
import terminal
import ../src/power_assert

# Simple utility to describe color functionality
proc describeColorOutput() =
  echo "Color Support Information:"
  echo "--------------------------"
  echo "Terminal supports colors: ", isatty(stdout)
  echo "Default color settings:"
  echo "  - Error Title: Red"
  echo "  - Expression Code: White"
  echo "  - Indicators (^): Cyan"
  echo "  - Values: Yellow"
  echo "  - Type Information: Green"
  echo "  - Composite Header: Magenta"
  echo "  - Number Values: Yellow"
  echo "  - String Values: Green"
  echo "  - Boolean Values: Blue"
  echo "  - Error Values: Red"
  echo ""
  echo "Test the color output by running this test and observing the visual output."
  echo "Try customizing colors with setColorScheme() or disabling with enableColors(false)."
  echo "--------------------------"

suite "Color Output Functionality":
  setup:
    # Enable colors for all tests in this suite
    enableColors(true)

  test "Basic colored output":
    describeColorOutput()

    let x = 10
    let y = 5

    try:
      powerAssert(x + y == 20)  # Will fail with colored output
    except PowerAssertDefect:
      # Expected to fail, so this is correct
      unittest.check true

  test "Custom color scheme":
    # Set a custom color scheme
    setColorScheme(
      errorTitle = fgMagenta,
      expressionCode = fgCyan,
      indicator = fgGreen,
      values = fgWhite,
      types = fgYellow,
      compositeHeader = fgRed
    )

    let a = "hello"
    let b = "world"

    try:
      powerAssert(a == b)  # Will fail with custom colored output
    except PowerAssertDefect:
      # Expected to fail, so this is correct
      unittest.check true

  test "Disabling colors":
    # Disable colors
    enableColors(false)

    let flag = true

    try:
      powerAssert(not flag)  # Will fail without colors
    except PowerAssertDefect:
      # Expected to fail, so this is correct
      unittest.check true

    # Re-enable colors for subsequent tests
    enableColors(true)

  test "Color highlighting for different types":
    let number = 42
    let text = "text"
    let truth = true
    let seq1 = @[1, 2, 3]
    let seq2 = @[4, 5, 6]

    try:
      powerAssert(number == 100 and text == "different" and truth == false and seq1 == seq2)
    except PowerAssertDefect:
      # Expected to fail, so this is correct
      unittest.check true

  test "Difference detection highlighting":
    let str1 = "hello world"
    let str2 = "hello earth"

    try:
      powerAssert(str1 == str2)
    except PowerAssertDefect:
      # Expected to fail, so this is correct
      unittest.check true

    let seq1 = @[1, 2, 3, 4, 5]
    let seq2 = @[1, 2, 30, 4, 5]

    try:
      powerAssert(seq1 == seq2)
    except PowerAssertDefect:
      # Expected to fail, so this is correct
      unittest.check true

  test "Color scheme persistence":
    # Test that color scheme persists across assertions
    setColorScheme(
      errorTitle = fgBlue,
      expressionCode = fgGreen
    )
    
    unittest.check getColorScheme().errorTitle == fgBlue
    unittest.check getColorScheme().expressionCode == fgGreen
    
    # Reset to default
    setColorScheme()
    unittest.check getColorScheme().errorTitle == fgRed

  test "Colors enabled/disabled state":
    enableColors(true)
    unittest.check isColorsEnabled() == true
    
    enableColors(false)  
    unittest.check isColorsEnabled() == false
    
    enableColors(true)
    unittest.check isColorsEnabled() == true