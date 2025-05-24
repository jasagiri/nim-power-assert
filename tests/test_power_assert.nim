# tests/test_power_assert.nim

import unittest except check
import ../src/power_assert

suite "PowerAssert Basic Functionality":
  test "Basic equality assertion":
    let a = 10
    let b = 5
    
    powerAssert a + b == 15
    powerAssert a - b == 5
    powerAssert a * 2 == 20
    powerAssert b != 0
    
  test "Comparison operators":
    let x = 5
    let y = 10
    
    powerAssert x < y
    powerAssert y > x
    powerAssert x <= 5
    powerAssert y >= 10
      
  test "Logical expressions":
    let flag1 = true
    let flag2 = false
    
    powerAssert flag1 or flag2
    powerAssert flag1 and not flag2
    powerAssert not (flag1 and flag2)
    powerAssert flag1 xor flag2
      
  test "Custom messages":
    let val = 42
    
    powerAssert val > 0, "Value must be positive"
    powerAssert val != 0, "Value must not be zero"
    powerAssert val == 42, "Value should be 42"

suite "Complex Expressions":
  test "Nested expressions":
    let a = 5
    let b = 7
    let c = 9
    
    powerAssert (a + b) * c == 108
    powerAssert a * (b + c) == 80
    powerAssert (a + b) * (c - 1) == 96
      
  test "Function calls":
    proc double(x: int): int = x * 2
    proc isEven(x: int): bool = (x mod 2) == 0
    
    let x = 5
    
    powerAssert double(x) == 10
    powerAssert isEven(double(x))
    powerAssert not isEven(x)
    
  test "String manipulation":
    let greeting = "Hello"
    let name = "World"
    
    powerAssert greeting & " " & name == "Hello World"
    powerAssert greeting.len == 5
    powerAssert name[0] == 'W'
    
  test "Collection operations":
    let numbers = @[1, 2, 3, 4, 5]
    
    powerAssert numbers.len == 5
    powerAssert numbers[2] == 3
    powerAssert 3 in numbers
    powerAssert 6 notin numbers