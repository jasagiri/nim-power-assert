# Unittest Integration Example
# Shows how to use PowerAssert with Nim's unittest module

import unittest
import ../src/power_assert
import std/[strformat, strutils, sequtils]

# Test basic integration
suite "PowerAssert with unittest":
  
  test "basic arithmetic assertions":
    let x = 10
    let y = 5
    
    # These should pass - using power_assert.check
    power_assert.check(x > y)
    power_assert.check(x + y == 15)
    power_assert.check(x * y == 50)
    
    echo "✓ Basic arithmetic tests passed"
  
  test "string operations":
    let greeting = "Hello"
    let name = "World"
    let combined = greeting & " " & name
    
    power_assert.check(combined == "Hello World")
    power_assert.check(greeting.len == 5)
    power_assert.check(combined.contains(name))
    
    echo "✓ String operation tests passed"
  
  test "collection operations":
    let numbers = @[1, 2, 3, 4, 5]
    let doubled = numbers.map(proc(x: int): int = x * 2)
    
    power_assert.check(numbers.len == 5)
    power_assert.check(doubled[0] == 2)
    power_assert.check(doubled[4] == 10)
    
    echo "✓ Collection operation tests passed"

# Test with custom types
type
  Rectangle = object
    width, height: float

proc `$`(r: Rectangle): string =
  fmt"Rectangle(w: {r.width}, h: {r.height})"

proc area(r: Rectangle): float =
  r.width * r.height

proc `==`(a, b: Rectangle): bool =
  a.width == b.width and a.height == b.height

suite "PowerAssert with custom types":
  
  test "rectangle operations":
    let rect1 = Rectangle(width: 5.0, height: 3.0)
    let rect2 = Rectangle(width: 4.0, height: 4.0)
    
    power_assert.check(rect1.area == 15.0)
    power_assert.check(rect2.area == 16.0)
    power_assert.check(rect1.area < rect2.area)
    
    echo "✓ Rectangle tests passed"

# Demonstrate failure cases (commented out to avoid test failures)
when false:
  suite "PowerAssert failure demonstrations":
    
    test "intentional failures":
      let x = 10
      let y = 5
      
      # These would fail with detailed error messages
      power_assert.check(x < y)  # Shows: 10 < 5 is false
      power_assert.check(x * y == 60)  # Shows: 10 * 5 == 60 is false (50 != 60)

when isMainModule:
  echo "Running PowerAssert unittest integration examples..."
  echo "Note: To see failure examples, set 'when false:' to 'when true:' above"