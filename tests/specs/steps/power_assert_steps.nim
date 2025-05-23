import unittest
import strutils
import strformat
import tables

when defined(nimHasUsed):
  {.used.}

import power_assert

# Helpers for step definitions
type
  TestContext = object
    expressionResult: bool
    output: string
    value1, value2: int
    complexValue: seq[int]
    customObj: CustomObject
    collections: Collections
    boolExpr: bool
    errorRaised: bool
    expectedErrorType: string
    actualErrorType: string
    customMsg: string
    
  CustomObject = object
    name: string
    value: int
    
  Collections = object
    sequence: seq[int]
    array: array[5, string]
    table: Table[string, int]

proc `$`(obj: CustomObject): string =
  fmt"{obj.name} ({obj.value})"

# Global context for sharing data between steps
var ctx = TestContext()

# Step definitions for "Basic equality assertion"
proc givenASimpleEqualityAssertionThatWillFail*() =
  ctx.value1 = 5
  ctx.value2 = 10
  # We'll use these values in a failing assertion

proc whenTheAssertionIsExecuted*() =
  try:
    # Capture the output by redirecting stderr
    let output = capture(stderr, powerAssert(ctx.value1 == ctx.value2))
    ctx.output = output
    ctx.expressionResult = false
  except AssertionDefect:
    ctx.expressionResult = false
    # In a real implementation, we'd capture the output

proc thenTheOutputShouldDisplayTheExpression*() =
  check ctx.output.contains("ctx.value1 == ctx.value2")

proc andTheOutputShouldDisplayTheActualValuesOfVariables*() =
  check ctx.output.contains("5") # value1
  check ctx.output.contains("10") # value2

proc andTheOutputShouldDisplayTheResultOfSubexpressions*() =
  check ctx.output.contains("false") # overall expression result

# Step definitions for "Compound expression assertion"
proc givenAComplexExpressionWithMultipleSubexpressions*() =
  ctx.complexValue = @[1, 2, 3, 4, 5]
  # We'll use this in a complex expression

proc whenTheAssertionFails*() =
  try:
    # Example: ctx.complexValue.len > 10 and ctx.complexValue[0] == 0
    let output = capture(stderr, powerAssert(ctx.complexValue.len > 10 and ctx.complexValue[0] == 0))
    ctx.output = output
    ctx.expressionResult = false
  except AssertionDefect:
    ctx.expressionResult = false
    # Capture output

proc thenTheOutputShouldDisplayTheValueOfEachSubexpression*() =
  check ctx.output.contains("5") # complexValue.len
  check ctx.output.contains("1") # complexValue[0]

proc andTheOutputShouldDisplayTheStructureOfTheExpression*() =
  check ctx.output.contains("and")
  check ctx.output.contains(">")
  check ctx.output.contains("==")

# Step definitions for "Custom type assertion"
proc givenCustomTypesWithToStringProcedureDefined*() =
  ctx.customObj = CustomObject(name: "TestObject", value: 42)

proc whenAnAssertionUsingTheseTypesFails*() =
  try:
    let otherObj = CustomObject(name: "TestObject", value: 99)
    let output = capture(stderr, powerAssert(ctx.customObj == otherObj))
    ctx.output = output
    ctx.expressionResult = false
  except AssertionDefect:
    ctx.expressionResult = false
    # Capture output

proc thenTheOutputShouldProperlyDisplayValuesOfCustomTypes*() =
  check ctx.output.contains("TestObject (42)")
  check ctx.output.contains("TestObject (99)")

# Step definitions for "Collection assertion"
proc givenAnAssertionInvolvingSequencesArraysAndTables*() =
  ctx.collections = Collections(
    sequence: @[1, 2, 3, 4, 5],
    array: ["a", "b", "c", "d", "e"],
    table: {"one": 1, "two": 2, "three": 3}.toTable
  )

# Other steps would be defined similarly for all scenarios in the feature files

# Step definitions for "Boolean expression handling"
proc givenABooleanExpressionWithMultipleConditions*() =
  ctx.value1 = 5
  ctx.value2 = 10
  # We'll use these in a boolean expression

proc thenTheOutputShouldShowWhichConditionsFailed*() =
  check ctx.output.contains("false") # The failed condition result

proc andDisplayTheValuesThatCausedTheFailure*() =
  check ctx.output.contains("5") # value1
  check ctx.output.contains("10") # value2

# Step definitions for "User-defined messages"
proc givenAnAssertionWithACustomMessage*() =
  ctx.customMsg = "Values must be equal"
  ctx.value1 = 5
  ctx.value2 = 10

proc thenTheOutputShouldIncludeTheCustomMessage*() =
  check ctx.output.contains(ctx.customMsg)

proc andStillDisplayTheDetailedExpressionBreakdown*() =
  check ctx.output.contains("ctx.value1 == ctx.value2")
  check ctx.output.contains("5") # value1
  check ctx.output.contains("10") # value2

# Error handling step definitions
proc givenCodeThatWillRaiseAnException*() =
  # Setup code that will raise an exception
  discard

proc whenUsingExpectErrorToExpectSpecificExceptions*() =
  ctx.expectedErrorType = "ValueError"
  try:
    expectError(ValueError):
      discard parseInt("not a number")
    ctx.errorRaised = true
    ctx.actualErrorType = "ValueError"
  except:
    ctx.errorRaised = false
    ctx.actualErrorType = "NoError"

proc thenItShouldPassWhenTheExpectedExceptionIsRaised*() =
  check ctx.errorRaised
  check ctx.expectedErrorType == ctx.actualErrorType

# Note: This is a demonstration implementation
# In a real BDD test framework, these would be registered automatically
# and matched with the feature file descriptions.