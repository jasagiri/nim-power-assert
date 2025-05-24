import unittest
import strutils
import strformat
import tables
import options

when defined(nimHasUsed):
  {.used.}

import power_assert

# Helpers for step definitions
type
  TestContext = object
    output: string
    primitives: PrimitiveTypes
    objects: ObjectComparison
    sequences: SequenceComparison
    tables: TableComparison
    options: OptionTypes
    genericTypes: GenericTypeTest
    references: ReferenceTypes
    tuples: TupleTypes
    enums: EnumTypes
    
  PrimitiveTypes = object
    intValue: int
    floatValue: float
    stringValue: string
    charValue: char
    boolValue: bool
    
  TestObject = object
    name: string
    value: int
    active: bool
    
  ObjectComparison = object
    obj1, obj2: TestObject
    
  SequenceComparison = object
    seq1, seq2: seq[int]
    arr1, arr2: array[5, string]
    
  TableComparison = object
    table1, table2: Table[string, int]
    
  OptionTypes = object
    someValue: Option[int]
    noneValue: Option[int]
    
  GenericBox[T] = object
    value: T
    
  GenericTypeTest = object
    intBox: GenericBox[int]
    stringBox: GenericBox[string]
    
  ReferenceTypes = object
    ref1, ref2: ref int
    
  TupleTypes = object
    tuple1, tuple2: (int, string, bool)
    
  TestEnum = enum
    ValueOne, ValueTwo, ValueThree
    
  EnumTypes = object
    enum1, enum2: TestEnum

proc `$`(obj: TestObject): string =
  fmt"{obj.name} (value: {obj.value}, active: {obj.active})"

proc `$`[T](box: GenericBox[T]): string =
  fmt"Box({box.value})"

# Global context for sharing data between steps
var ctx = TestContext()

# Step definitions for "Primitive type handling"
proc givenAssertionsUsingPrimitiveTypes*() =
  ctx.primitives = PrimitiveTypes(
    intValue: 42,
    floatValue: 3.14,
    stringValue: "test",
    charValue: 'x',
    boolValue: true
  )

proc whenTheseAssertionsFail*() =
  try:
    # For int comparison
    let output = capture(stderr, powerAssert(ctx.primitives.intValue == 100))
    ctx.output = output
  except AssertionDefect:
    # In a real implementation, we'd capture the output
    discard

proc thenTheOutputShouldCorrectlyDisplayThePrimitiveTypeValues*() =
  check ctx.output.contains("42") # intValue
  # Similarly for other primitive types

proc andShowAppropriateTypeInformationForEachValue*() =
  check ctx.output.contains("(int)")
  # Similarly for other type information

# Step definitions for "User-defined object types"
proc givenAnObjectTypeWithMultipleFields*() =
  ctx.objects = ObjectComparison(
    obj1: TestObject(name: "Object A", value: 42, active: true),
    obj2: TestObject(name: "Object A", value: 99, active: true)
  )

proc whenAssertionsComparingObjectsFail*() =
  try:
    let output = capture(stderr, powerAssert(ctx.objects.obj1 == ctx.objects.obj2))
    ctx.output = output
  except AssertionDefect:
    discard

proc thenTheOutputShouldShowTheFieldValuesThatDiffer*() =
  check ctx.output.contains("42") # obj1.value
  check ctx.output.contains("99") # obj2.value

proc andDisplayTheObjectsInAReadableFormat*() =
  check ctx.output.contains("Object A (value: 42, active: true)")
  check ctx.output.contains("Object A (value: 99, active: true)")

# Step definitions for "Sequence and array comparison"
proc givenSequencesAndArraysOfDifferentTypes*() =
  ctx.sequences = SequenceComparison(
    seq1: @[1, 2, 3, 4, 5],
    seq2: @[1, 2, 3, 5, 5],
    arr1: ["a", "b", "c", "d", "e"],
    arr2: ["a", "b", "x", "d", "e"]
  )

proc whenAssertionsComparingTheseCollectionsFail*() =
  try:
    let output = capture(stderr, powerAssert(ctx.sequences.seq1 == ctx.sequences.seq2))
    ctx.output = output
  except AssertionDefect:
    discard

proc thenTheOutputShouldShowElementsThatDiffer*() =
  check ctx.output.contains("4") # seq1[3]
  check ctx.output.contains("5") # seq2[3]

proc andIndicateTheIndicesWhereMismatchesOccur*() =
  check ctx.output.contains("[3]") # index of mismatch

# Other step definitions would follow a similar pattern

# Step definitions for "Table and map comparisons"
proc givenTablesOrMapsWithVariousKeyValuePairs*() =
  ctx.tables = TableComparison(
    table1: {"one": 1, "two": 2, "three": 3}.toTable,
    table2: {"one": 1, "two": 22, "three": 3}.toTable
  )

proc whenAssertionsComparingTablesFail*() =
  try:
    let output = capture(stderr, powerAssert(ctx.tables.table1 == ctx.tables.table2))
    ctx.output = output
  except AssertionDefect:
    discard

proc thenTheOutputShouldIdentifyWhichKeysHaveDifferentValues*() =
  check ctx.output.contains("two") # The key with different values

proc andShowBothTheExpectedAndActualValuesForThoseKeys*() =
  check ctx.output.contains("2") # table1["two"]
  check ctx.output.contains("22") # table2["two"]

# Step definitions for "Option type handling"
proc givenOptionTypesSomeAndNoneValues*() =
  ctx.options = OptionTypes(
    someValue: some(42),
    noneValue: none(int)
  )

proc whenAssertionsWithOptionTypesFail*() =
  try:
    let output = capture(stderr, powerAssert(ctx.options.someValue == none(int)))
    ctx.output = output
  except AssertionDefect:
    discard

proc thenTheOutputShouldClearlyIndicateIfAValueIsPresentOrNot*() =
  check ctx.output.contains("some") # indicates presence
  check ctx.output.contains("none") # indicates absence

proc andDisplayTheContainedValueWhenPresent*() =
  check ctx.output.contains("42") # The contained value

# Note: This is a demonstration implementation
# In a real BDD test framework, these would be registered automatically
# and matched with the feature file descriptions.