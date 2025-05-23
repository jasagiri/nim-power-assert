# tests/test_complex_expressions.nim

import unittest except check
import ../src/power_assert
import tables, sequtils, options, sets, strutils, algorithm

# Complex custom types for testing
type
  Address = object
    street: string
    city: string
    zipCode: string
    
  Person = object
    name: string
    age: int
    address: Address
    skills: seq[string]
    scores: Table[string, int]
    active: bool
    
  Team = object
    name: string
    members: seq[Person]
    founded: int
    tags: HashSet[string]
    statistics: Table[string, float]
    manager: Option[Person]

# String conversion procedures
proc `$`(a: Address): string =
  result = a.street & ", " & a.city & " " & a.zipCode

proc `$`(p: Person): string =
  result = p.name & " (" & $p.age & ")"

proc `$`(t: Team): string =
  result = t.name & " (" & $t.members.len & " members)"

# Test suite for complex expressions
suite "Complex Expression Handling":
  test "Deep nested expression with multiple operations":
    let a = 5
    let b = 10
    let c = 15
    let d = 20
    
    try:
      # Very complex expression with many operations
      powerAssert (a + b) * (c - d) / 2 + 100 == 0
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Large composite objects":
    # Create complex nested data structure
    let address1 = Address(street: "123 Main St", city: "Anytown", zipCode: "12345")
    let address2 = Address(street: "456 Elm St", city: "Othertown", zipCode: "67890")
    
    var person1 = Person(
      name: "Alice", 
      age: 30, 
      address: address1,
      skills: @["Programming", "Design", "Communication"],
      scores: {"Math": 95, "Science": 98, "History": 88}.toTable,
      active: true
    )
    
    var person2 = Person(
      name: "Bob", 
      age: 35, 
      address: address2,
      skills: @["Management", "Finance", "Leadership"],
      scores: {"Math": 85, "Science": 82, "History": 90}.toTable,
      active: true
    )
    
    let team1 = Team(
      name: "Alpha Team",
      members: @[person1, person2],
      founded: 2020,
      tags: ["innovative", "technical", "agile"].toHashSet,
      statistics: {"productivity": 0.85, "satisfaction": 0.92}.toTable,
      manager: some(person1)
    )
    
    let team2 = Team(
      name: "Alpha Team",  # Same name
      members: @[person1, person2],
      founded: 2021,       # Different founded year
      tags: ["innovative", "technical", "agile"].toHashSet,
      statistics: {"productivity": 0.85, "satisfaction": 0.92}.toTable,
      manager: some(person1)
    )
    
    try:
      # Complex equality check with deep nested structures
      powerAssert team1 == team2
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Complex expression with collection operations":
    let numbers = @[10, 20, 30, 40, 50]
    let strings = @["apple", "banana", "cherry", "date", "elderberry"]
    let mixed = @[10, 5, 30, 15, 40, 25]
    
    try:
      # Complex expression with multiple collection operations
      powerAssert numbers.mapIt(it * 2).filterIt(it > 50).len == 
              strings.filterIt(it.len > 5).mapIt(it.toUpperAscii).len
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
    try:
      # Complex sorting and filtering operations
      powerAssert mixed.sorted(Descending).filterIt(it mod 2 == 0)[1] == 20
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Expressions with table operations":
    var scores = {"Alice": 95, "Bob": 85, "Charlie": 90}.toTable
    var grades = {"Alice": "A", "Bob": "B", "Charlie": "A-"}.toTable
    
    try:
      # Complex table operations
      powerAssert scores.keys.toSeq.mapIt(scores[it] > 90).filterIt(it).len ==
                 grades.values.toSeq.filterIt(it == "A").len
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Expressions with custom type collections":
    let people = @[
      Person(name: "Alice", age: 30),
      Person(name: "Bob", age: 25),
      Person(name: "Charlie", age: 35),
      Person(name: "David", age: 40)
    ]
    
    try:
      # Complex operations on collection of custom objects
      powerAssert people.mapIt(it.age).filterIt(it > 30).len == 1
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Extremely large expression":
    let a = 5
    let b = 10
    let c = 15
    let d = 20
    let e = 25
    let f = 30
    
    try:
      # Extremely long expression
      powerAssert (a + b) * (c - d) / (e + f) * (a * b) + 
                (c * d) - (e / f) + 
                100 * (a + b + c + d + e + f) / (a * b * c) == 100
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
  test "Option type handling":
    let opt1 = some(42)
    let opt2 = some(43)
    let opt3 = none(int)
    
    try:
      # Option comparison with mapping
      powerAssert opt1.map(x => x * 2) == opt2
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
      
    try:
      # Option with flatMap
      powerAssert opt1.map(x => x - 42).get(0) == opt3.get(1)
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true