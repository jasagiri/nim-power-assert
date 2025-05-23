# Example usage of power_assert_nim

import ../src/power_assert

# Basic assertion examples
proc basicExample() =
  echo "Running basic assertion examples..."
  
  let a = 10
  let b = 20
  
  # This will pass
  powerAssert(a + b == 30)
  echo "a + b == 30 passed as expected"
  
  # This would fail with detailed error message
  try:
    powerAssert(a > b, "a should be greater than b")
    echo "This shouldn't be reached"
  except PowerAssertDefect as e:
    echo "Caught expected assertion failure:"
    echo e.msg
    
  echo "Basic examples completed"

# Custom type example
type
  Person = object
    name: string
    age: int

proc `$`(p: Person): string =
  p.name & " (age: " & $p.age & ")"

proc customTypeExample() =
  echo "\nRunning custom type examples..."
  
  let alice = Person(name: "Alice", age: 30)
  let bob = Person(name: "Bob", age: 25)
  
  # Custom comparison operator for Person
  proc `==`(a, b: Person): bool = a.name == b.name and a.age == b.age
  
  # This will fail with detailed output showing the Person objects
  try:
    powerAssert(alice == bob)
  except PowerAssertDefect as e:
    echo "Caught expected assertion failure with custom types:"
    echo e.msg
    
  echo "Custom type examples completed"

# Integration with unittest
proc unittestIntegrationExample() =
  echo "\nUnittest integration would be shown in the test files"
  echo "See tests/test_power_assert.nim for examples"

when isMainModule:
  echo "PowerAssert for Nim - Examples"
  echo "============================"
  
  basicExample()
  customTypeExample()
  unittestIntegrationExample()
  
  echo "\nAll examples completed"