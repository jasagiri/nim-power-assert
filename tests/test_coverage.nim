import unittest except check, doAssert
import ../src/power_assert
import std/tables

# Test for expectError template
suite "Error Handling":
  test "expectError template - expected error":
    proc raiseValueError() =
      raise newException(ValueError, "Test error")
    expectError(ValueError):
      raiseValueError()
  
  test "expectError template - unexpected error type":
    proc raiseIOError() =
      raise newException(IOError, "Wrong error type")
    try:
      expectError(ValueError):
        raiseIOError()
      check false # Should not reach here
    except AssertionDefect:
      # This is expected
      check true
  
  test "expectError template - no error raised":
    proc noError() =
      discard "No error raised"
    try:
      expectError(ValueError):
        noError()
      check false # Should not reach here
    except AssertionDefect:
      # This is expected
      check true

# Test for formatValue function with various types
suite "Value Formatting":
  test "String formatting":
    check formatValue("test") == "\"test\""
  
  test "Char formatting":
    check formatValue('a') == "'a'"
  
  test "Boolean formatting":
    check formatValue(true) == "true"
    check formatValue(false) == "false"
  
  test "Enum formatting":
    type TestEnum = enum
      One, Two, Three
    check formatValue(One) == "One"
    check formatValue(Two) == "Two"
  
  test "Integer formatting":
    check formatValue(42) == "42"
    check formatValue(-10) == "-10"
  
  test "Float formatting":
    check formatValue(3.14) == "3.14"
    check formatValue(-0.5) == "-0.5"
  
  test "Sequence formatting":
    let seq1 = @[1, 2, 3]
    check formatValue(seq1) == "@[1, 2, 3]"
    
    let seq2 = @["a", "b", "c"]
    check formatValue(seq2) == "@[\"a\", \"b\", \"c\"]"
  
  test "Array formatting":
    let arr1 = [1, 2, 3]
    check formatValue(arr1) == "[1, 2, 3]"
    
    let arr2 = ["a", "b", "c"]
    check formatValue(arr2) == "[\"a\", \"b\", \"c\"]"
  
  test "Custom type with $ operator":
    type Person = object
      name: string
      age: int
    
    proc `$`(p: Person): string =
      result = p.name & " (" & $p.age & ")"
    
    let person = Person(name: "Alice", age: 30)
    check formatValue(person) == "Alice (30)"
  
  test "Type without $ operator":
    type 
      NoStringify = object
        x: int
    
    let obj = NoStringify(x: 42)
    check formatValue(obj).startsWith("<NoStringify>")

# Test for renderExpression function
suite "Expression Rendering":
  test "Simple expression rendering":
    let exprStr = "a + b == c"
    var values: seq[ExpressionInfo] = @[
      ExpressionInfo(code: "a", value: "5", typeName: "int", column: 0),
      ExpressionInfo(code: "b", value: "10", typeName: "int", column: 4),
      ExpressionInfo(code: "c", value: "15", typeName: "int", column: 9),
      ExpressionInfo(code: "a + b", value: "15", typeName: "int", column: 0)
    ]
    
    let rendered = renderExpression(exprStr, values)
    check rendered.contains("^ 5 (int)")
    check rendered.contains("^ 10 (int)")
    check rendered.contains("^ 15 (int)")
    check rendered.contains("a + b = 15 (int)")
  
  test "Expression with composite subexpressions":
    let exprStr = "(a + b) * c == d"
    var values: seq[ExpressionInfo] = @[
      ExpressionInfo(code: "a", value: "2", typeName: "int", column: 1),
      ExpressionInfo(code: "b", value: "3", typeName: "int", column: 5),
      ExpressionInfo(code: "c", value: "4", typeName: "int", column: 10),
      ExpressionInfo(code: "d", value: "20", typeName: "int", column: 15),
      ExpressionInfo(code: "a + b", value: "5", typeName: "int", column: 1),
      ExpressionInfo(code: "(a + b) * c", value: "20", typeName: "int", column: 0)
    ]
    
    let rendered = renderExpression(exprStr, values)
    check rendered.contains("^ 2 (int)")
    check rendered.contains("^ 3 (int)")
    check rendered.contains("^ 4 (int)")
    check rendered.contains("^ 20 (int)")
    check rendered.contains("a + b = 5 (int)")
    check rendered.contains("(a + b) * c = 20 (int)")
  
  test "Empty values list":
    let exprStr = "a + b == c"
    var values: seq[ExpressionInfo] = @[]
    
    let rendered = renderExpression(exprStr, values)
    check rendered == exprStr & "\n\n"

# Test for aliases and template overrides
suite "Alias Templates":
  test "assert template":
    let x = 10
    assert x == 10
    
    try:
      assert x == 20
      check false # Should not reach here
    except AssertionDefect:
      # This is expected
      check true
  
  test "doAssert template":
    let x = 10
    doAssert x == 10
    
    try:
      doAssert x == 20
      check false # Should not reach here
    except AssertionDefect:
      # This is expected
      check true
  
  test "powerCheck template":
    let x = 10
    powerCheck x == 10
    
    try:
      powerCheck x == 20
      check false # Should not reach here
    except AssertionDefect:
      # This is expected
      check true
  
# Test for the library's check override
suite "Unittest Integration":
  test "check template override":
    let x = 10
    check x == 10
    
    try:
      check x == 20
      check false # Should not reach here
    except AssertionDefect:
      # This is expected
      check true