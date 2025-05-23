# Custom Types Example
# Demonstrates PowerAssert with user-defined types

import ../src/power_assert
import std/strformat

# Define custom types
type
  Person = object
    name: string
    age: int
    email: string

  Point = object
    x, y: float

  Status = enum
    Active, Inactive, Pending

  Product = object
    id: int
    name: string
    price: float
    status: Status

# Implement string representation for custom types
proc `$`(p: Person): string =
  fmt"Person(name: {p.name}, age: {p.age}, email: {p.email})"

proc `$`(pt: Point): string =
  fmt"Point(x: {pt.x}, y: {pt.y})"

proc `$`(prod: Product): string =
  fmt"Product(id: {prod.id}, name: {prod.name}, price: {prod.price}, status: {prod.status})"

# Define equality operators for custom types
proc `==`(a, b: Person): bool =
  a.name == b.name and a.age == b.age and a.email == b.email

proc `==`(a, b: Point): bool =
  a.x == b.x and a.y == b.y

proc `==`(a, b: Product): bool =
  a.id == b.id and a.name == b.name and a.price == b.price and a.status == b.status

proc demonstratePersonType() =
  echo "=== Person Type ==="
  
  let alice = Person(name: "Alice", age: 30, email: "alice@example.com")
  let bob = Person(name: "Bob", age: 25, email: "bob@example.com")
  let aliceCopy = Person(name: "Alice", age: 30, email: "alice@example.com")
  
  # Helper functions for comparisons
  proc personsEqual(a, b: Person): bool = (a == b)
  proc personAgeGreater(a, b: Person): bool = a.age > b.age
  proc personNameEquals(p: Person, name: string): bool = p.name == name
  proc complexPersonCheck(a, b: Person, name: string): bool = 
    personAgeGreater(a, b) and personNameEquals(a, name)
  
  # This should pass
  powerAssert(personsEqual(alice, aliceCopy))
  echo "✓ alice == aliceCopy passed"
  
  # This should fail
  try:
    powerAssert(personsEqual(alice, bob))
  except PowerAssertDefect as e:
    echo "\nPerson comparison failure:"
    echo e.msg
  
  # Test with complex expression
  try:
    powerAssert(complexPersonCheck(alice, bob, "Bob"))
  except PowerAssertDefect as e:
    echo "\nComplex Person expression failure:"
    echo e.msg

proc demonstratePointType() =
  echo "\n=== Point Type ==="
  
  let origin = Point(x: 0.0, y: 0.0)
  let point1 = Point(x: 3.0, y: 4.0)
  let point2 = Point(x: 1.0, y: 1.0)
  
  # Helper functions for point operations
  proc pointDistanceSquaredEquals(p: Point, expected: float): bool =
    let distSq = p.x * p.x + p.y * p.y
    return distSq == expected
  
  proc pointsEqual(a, b: Point): bool = (a == b)
  
  # Calculate distance (should fail)
  try:
    powerAssert(pointDistanceSquaredEquals(point1, 20.0))
  except PowerAssertDefect as e:
    echo "Point distance calculation failure:"
    echo e.msg
  
  # Point comparison
  try:
    powerAssert(pointsEqual(origin, point2))
  except PowerAssertDefect as e:
    echo "\nPoint comparison failure:"
    echo e.msg

proc demonstrateProductType() =
  echo "\n=== Product Type ==="
  
  let laptop = Product(id: 1, name: "Laptop", price: 999.99, status: Active)
  let phone = Product(id: 2, name: "Phone", price: 599.99, status: Pending)
  
  # Helper functions for product comparisons
  proc productPriceLess(a, b: Product): bool = a.price < b.price
  proc productStatusAndPrice(p: Product, status: Status, minPrice: float): bool =
    (p.status == status) and (p.price > minPrice)
  
  # Price comparison
  try:
    powerAssert(productPriceLess(laptop, phone))
  except PowerAssertDefect as e:
    echo "Product price comparison failure:"
    echo e.msg
  
  # Status and price combined
  try:
    powerAssert(productStatusAndPrice(laptop, Inactive, 1000.0))
  except PowerAssertDefect as e:
    echo "\nProduct status and price failure:"
    echo e.msg

proc demonstrateComplexNesting() =
  echo "\n=== Complex Nested Types ==="
  
  let team = @[
    Person(name: "Alice", age: 30, email: "alice@example.com"),
    Person(name: "Bob", age: 25, email: "bob@example.com"),
    Person(name: "Charlie", age: 35, email: "charlie@example.com")
  ]
  
  # Helper function for complex team validation
  proc validateTeam(team: seq[Person], expectedLen: int, expectedName: string): bool =
    if team.len != expectedLen: return false
    if team.len < 3: return false
    if team[0].age <= team[1].age: return false
    if team[2].name != expectedName: return false
    return true
  
  # Complex nested assertion
  try:
    powerAssert(validateTeam(team, 5, "David"))
  except PowerAssertDefect as e:
    echo "Complex nested assertion failure:"
    echo e.msg

when isMainModule:
  echo "PowerAssert Custom Types Examples"
  echo "================================"
  
  demonstratePersonType()
  demonstratePointType()
  demonstrateProductType()
  demonstrateComplexNesting()
  
  echo "\nCustom types examples completed!"