# tests/test_custom_types.nim

import unittest except check
import ../src/power_assert

type
  Person = object
    name: string
    age: int

# This string conversion procedure is used implicitly by the powerAssert macro
# when displaying values in error messages
proc `$`(p: Person): string {.used.} =
  result = p.name & " (" & $p.age & ")"

suite "Custom Types":
  test "Object equality":
    let person1 = Person(name: "Alice", age: 30)
    let person2 = Person(name: "Bob", age: 25)
    
    try:
      powerAssert person1 == person2
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Custom operators":
    proc `>`(a, b: Person): bool = a.age > b.age
    
    let person1 = Person(name: "Alice", age: 30)
    let person2 = Person(name: "Bob", age: 35)
    
    try:
      powerAssert person1 > person2
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true

  test "Nested objects":
    type
      Department = object
        name: string
        head: Person
    
    let dept1 = Department(
      name: "Engineering",
      head: Person(name: "Alice", age: 30)
    )
    
    let dept2 = Department(
      name: "Engineering",
      head: Person(name: "Bob", age: 35)
    )
    
    try:
      powerAssert dept1 == dept2
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Sequences of custom types":
    let people = @[
      Person(name: "Alice", age: 30),
      Person(name: "Bob", age: 25),
      Person(name: "Charlie", age: 35)
    ]
    
    # Test length
    powerAssert people.len == 3
    
    # Test finding an element
    let target = Person(name: "Alice", age: 30)
    try:
      powerAssert target != people[0]
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Custom type with field access":
    let person = Person(name: "Alice", age: 30)
    
    # Test field access
    powerAssert person.name == "Alice"
    powerAssert person.age == 30
    
    # Test field manipulation
    var mutablePerson = person
    mutablePerson.age += 1
    powerAssert mutablePerson.age == 31