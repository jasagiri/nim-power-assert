import unittest except check
import ../src/power_assert
import std/tables
import std/strutils
import terminal

# Test for power assert with various scenarios
suite "PowerAssert Coverage":
  test "Basic assertions":
    let x = 10
    powerAssert x == 10
    
    try:
      powerAssert x == 20
      fail()
    except PowerAssertDefect:
      # This is expected
      check true

  test "Complex expressions":
    let a = 5
    let b = 10
    powerAssert a + b == 15
    powerAssert a * 2 == 10
    powerAssert b / 2 == 5.0

  test "String operations":
    let s = "hello"
    powerAssert s.len == 5
    powerAssert s & " world" == "hello world"

  test "Boolean operations":
    let x = true
    let y = false
    powerAssert x or y
    powerAssert not y
    powerAssert x and not y

  test "Collections":
    let seq1 = @[1, 2, 3]
    powerAssert seq1.len == 3
    powerAssert seq1[0] == 1
    powerAssert 2 in seq1

    var table1 = initTable[string, int]()
    table1["one"] = 1
    powerAssert "one" in table1
    powerAssert table1["one"] == 1

  test "Custom messages":
    let x = 42
    try:
      powerAssert(x == 0, "x should be zero")
      fail()
    except PowerAssertDefect as e:
      let msg = e.msg
      check "x should be zero" in msg

  test "Type comparisons":
    type Color = enum
      Red, Green, Blue
    
    let c = Red
    powerAssert c == Red
    powerAssert c != Blue

  test "Floating point comparisons":
    let f1 = 3.14
    let f2 = 3.14
    powerAssert f1 == f2
    
    let f3 = 3.14159
    powerAssert f3 > f1

  test "Nil and none values":
    var p: ref int = nil
    powerAssert p.isNil
    
    var s: string
    powerAssert s == ""

  test "Nested structures":
    type
      Point = object
        x, y: int
      Rectangle = object
        topLeft: Point
        bottomRight: Point
    
    let rect = Rectangle(
      topLeft: Point(x: 0, y: 0),
      bottomRight: Point(x: 10, y: 10)
    )
    
    powerAssert rect.topLeft.x == 0
    powerAssert rect.bottomRight.y == 10

# Test for unittest integration
suite "Unittest Integration Coverage":
  test "check template override":
    let x = 10
    check x == 10
    
    try:
      check x == 20
      fail()
    except PowerAssertDefect:
      # This is expected
      check true

  test "Multiple checks in one test":
    let a = 1
    let b = 2
    let c = 3
    
    check a < b
    check b < c
    check a + b == c

# Test statistics functionality
suite "Statistics Coverage":
  test "powerAssertWithStats":
    resetTestStats()
    
    powerAssertWithStats(1 + 1 == 2)
    powerAssertWithStats(2 * 2 == 4)
    
    try:
      powerAssertWithStats(3 + 3 == 7)
    except PowerAssertDefect:
      discard
    
    let stats = getTestStats()
    check stats.passed == 2
    check stats.failed == 1
    check stats.total == 3

  test "skipTest functionality":
    resetTestStats()
    
    powerAssertWithStats(true)
    skipTest("This test is intentionally skipped")
    
    let stats = getTestStats()
    check stats.passed == 1
    check stats.skipped == 1
    check stats.total == 2

# Test output format functionality
suite "Output Format Coverage":
  test "PowerAssertJS format":
    setOutputFormat(PowerAssertJS)
    check getOutputFormat() == PowerAssertJS
    
    try:
      let x = 10
      let y = 20
      powerAssert x > y
    except PowerAssertDefect as e:
      # Should contain pipe character
      check "|" in e.msg

  test "Compact format":
    setOutputFormat(Compact)
    check getOutputFormat() == Compact
    
    try:
      let x = 10
      powerAssert x == 20
    except PowerAssertDefect as e:
      # Should contain equals sign for variable values
      check "=" in e.msg

  test "Detailed format":
    setOutputFormat(Detailed)
    check getOutputFormat() == Detailed
    
    try:
      let x = 10
      powerAssert x == 20
    except PowerAssertDefect as e:
      # Should contain Expression section
      check "Expression:" in e.msg

  test "Classic format":
    setOutputFormat(Classic)
    check getOutputFormat() == Classic
    
    try:
      let x = 10
      powerAssert x == 20
    except PowerAssertDefect as e:
      # Should contain caret
      check "^" in e.msg

# Test color functionality
suite "Color Functionality Coverage":
  test "Enable/disable colors":
    enableColors(true)
    check isColorsEnabled() == true
    
    enableColors(false)
    check isColorsEnabled() == false

  test "Color scheme":
    setColorScheme(
      errorTitle = fgRed,
      expressionCode = fgWhite,
      indicator = fgCyan,
      values = fgYellow,
      types = fgGreen,
      compositeHeader = fgMagenta
    )
    
    let scheme = getColorScheme()
    check scheme.errorTitle == fgRed
    check scheme.values == fgYellow