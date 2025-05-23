# tests/test_enhanced_types.nim

import unittest except check
import tables
import options
import ../src/power_assert

suite "Enhanced Type Support":
  test "Tuple type support":
    # Simple tuple
    let simpleT = (10, "hello")
    powerAssert simpleT == (10, "hello")  # should pass
    
    # Try a failing assertion
    try:
      powerAssert simpleT == (10, "world")
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
    
    # Named tuple
    let namedT = (name: "Alice", age: 30)
    powerAssert namedT.name == "Alice"
    powerAssert namedT.age == 30
    
    # Nested tuple
    let nestedT = (point: (x: 5, y: 10), label: "Point")
    
    try:
      powerAssert nestedT.point.x == 10
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
  
  test "Table type support":
    # Simple Table
    var t = initTable[string, int]()
    t["one"] = 1
    t["two"] = 2
    t["three"] = 3
    
    powerAssert t["one"] == 1
    
    try:
      powerAssert t["two"] == 3
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
    
    # Table operations
    powerAssert t.len == 3
    powerAssert t.hasKey("one")
    
    # Table with tuple values
    var tComplex = initTable[string, (int, string)]()
    tComplex["first"] = (1, "one")
    tComplex["second"] = (2, "two")
    
    try:
      powerAssert tComplex["first"] == (2, "one")
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
  
  test "Option type support":
    # Some option
    let someValue = some(42)
    powerAssert someValue.isSome
    powerAssert someValue.get == 42
    
    # None option
    let noValue = none(int)
    powerAssert noValue.isNone
    
    # Option operations
    try:
      powerAssert someValue.get == 100
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
    
    # Option with complex type
    let complexOpt = some((name: "Alice", age: 30))
    
    try:
      powerAssert complexOpt.get.age == 25
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true

  test "Mixed type assertions":
    # Table with option values
    var tOpt = initTable[string, Option[int]]()
    tOpt["valid"] = some(42)
    tOpt["invalid"] = none(int)
    
    powerAssert tOpt["valid"].isSome
    powerAssert tOpt["invalid"].isNone
    
    # Option with tuple
    let optTuple = some((x: 10, y: 20))
    
    try:
      powerAssert optTuple.get == (x: 10, y: 10)
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true
    
    # Table with sequences
    var tSeq = initTable[string, seq[int]]()
    tSeq["even"] = @[2, 4, 6, 8]
    tSeq["odd"] = @[1, 3, 5, 7]
    
    powerAssert tSeq["even"][0] == 2
    
    try:
      powerAssert tSeq["odd"][0] == 2
      fail()
      echo "Assertion should have failed"
    except AssertionDefect:
      # Expected to fail, so this is correct
      check true