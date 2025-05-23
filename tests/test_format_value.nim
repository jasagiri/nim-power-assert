import unittest except check
import ../src/power_assert
import std/strutils

suite "Format Value Tests":
  test "String formatting":
    check formatValue("hello") == "\"hello\""
    check formatValue("") == "\"\""
    check formatValue("special chars: \n\t\"") == "\"special chars: \n\t\"\""
  
  test "Char formatting":
    check formatValue('a') == "'a'"
    check formatValue('\n') == "'\n'"
    check formatValue('\'') == "'\''"
  
  test "Boolean formatting":
    check formatValue(true) == "true"
    check formatValue(false) == "false"
  
  test "Enum formatting":
    type
      Color = enum
        Red, Green, Blue
      Days = enum
        Mon = "Monday", Tue = "Tuesday", Wed = "Wednesday"
    
    check formatValue(Red) == "Red"
    check formatValue(Blue) == "Blue"
    check formatValue(Mon) == "Monday"
    check formatValue(Wed) == "Wednesday"
  
  test "Integer formatting":
    check formatValue(0) == "0"
    check formatValue(42) == "42"
    check formatValue(-100) == "-100"
    check formatValue(high(int)) == $high(int)
    
    # Different integer types
    check formatValue(42'i8) == "42"
    check formatValue(42'u8) == "42"
    check formatValue(1000'i16) == "1000"
    check formatValue(1000'u16) == "1000"
    check formatValue(1_000_000'i32) == "1000000"
    check formatValue(1_000_000'u32) == "1000000"
    check formatValue(1_000_000_000'i64) == "1000000000"
    check formatValue(1_000_000_000'u64) == "1000000000"
  
  test "Float formatting":
    check formatValue(0.0) == "0.0"
    check formatValue(3.14) == "3.14"
    check formatValue(-2.5) == "-2.5"
    check formatValue(1e10) == "1.0e+10"
    
    # Different float types
    check formatValue(3.14'f32) == "3.14"
    check formatValue(3.14'f64) == "3.14"
  
  test "Sequence formatting":
    check formatValue(@[1, 2, 3]) == "@[1, 2, 3]"
    check formatValue(@[1]) == "@[1]" # Can't use empty seq - need type information
    check formatValue(@["one", "two"]) == "@[\"one\", \"two\"]"
    let nestedSeq = @[@[1, 2], @[3, 4]]
    check formatValue(nestedSeq) == "@[@[1, 2], @[3, 4]]"
  
  test "Array formatting":
    check formatValue([1, 2, 3]) == "[1, 2, 3]"
    check formatValue(["one", "two"]) == "[\"one\", \"two\"]"
    
    # Multi-dimensional arrays
    check formatValue([[1, 2], [3, 4]]) == "[[1, 2], [3, 4]]"
    
    # Empty arrays
    var emptyArray: array[0, int]
    check formatValue(emptyArray) == "[]"
  
  test "Custom type with $ operator":
    type
      Point = object
        x, y: int
    
    proc `$`(p: Point): string =
      "(" & $p.x & ", " & $p.y & ")"
    
    let p = Point(x: 10, y: 20)
    check formatValue(p) == "(10, 20)"
  
  test "Tuple formatting":
    let t1 = (1, "test")
    check formatValue(t1) == "(1, test)"
    
    let t2 = (x: 10, y: 20)
    check formatValue(t2) == "(x: 10, y: 20)"
  
  test "Type without $ operator":
    type
      NoToString = object
        value: int
    
    let obj = NoToString(value: 42)
    check find(formatValue(obj), "NoToString") >= 0