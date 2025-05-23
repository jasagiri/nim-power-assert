import std/unittest except check, require
import ../src/power_assert

suite "Basic PowerAssert Tests":
  test "Successful assertions":
    let a = 5
    let b = 10
    
    # Simple successful assertion
    powerAssert(a * 2 == b)
    
    # Using powerAssert directly
    powerAssert(a + 5 == b)
    
  test "Require template":
    # Testing the require template
    let value = 10
    require(value > 0)
    powerAssert(value * 2 == 20)
    
  test "Assertion with custom messages":
    let x = 42
    powerAssert(x > 0, "Value must be positive")
    powerAssert(x < 100, "Value must be less than 100")
    
  test "Multiple assertions in sequence":
    let numbers = @[1, 2, 3, 4, 5]
    
    powerAssert(numbers.len == 5)
    powerAssert(numbers[0] == 1)
    powerAssert(numbers[^1] == 5)
    
  test "Different types in assertions":
    let intVal = 10
    let floatVal = 10.0
    let boolVal = true
    let strVal = "hello"
    
    powerAssert(intVal == 10)
    powerAssert(floatVal == 10.0)
    powerAssert(boolVal == true)
    powerAssert(strVal == "hello")
    
  test "Assertions with type conversions":
    let intVal = 10
    let floatVal = 10.0
    
    powerAssert(intVal.float == floatVal)
    powerAssert(floatVal.int == intVal)
    
  test "Assertions with complex expressions":
    proc square(x: int): int = x * x
    proc isOdd(x: int): bool = x mod 2 == 1
    
    let x = 5
    
    powerAssert(square(x) == 25)
    powerAssert(isOdd(x))
    powerAssert(isOdd(square(x) + 2))
    
suite "Failed Assertions":
  test "Failing assertion with display":
    try:
      let x = 5
      let y = 10
      powerAssert(x + x == y + 1)
      check false # Should not reach here
    except AssertionDefect:
      # This is expected
      check true
      
  test "Multiple operations in failing assertion":
    try:
      let a = 2
      let b = 3
      let c = 4
      powerAssert((a + b) * c == 21)
      check false # Should not reach here
    except AssertionDefect:
      # This is expected
      check true
      
  test "Function calls in failing assertion":
    try:
      proc double(x: int): int = x * 2
      let x = 5
      powerAssert(double(x) == 11)
      check false # Should not reach here
    except AssertionDefect:
      # This is expected
      check true