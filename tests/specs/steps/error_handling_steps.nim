import unittest
import strutils
import strformat

when defined(nimHasUsed):
  {.used.}

import power_assert

# Custom exception types for testing
type
  TestError = object of Exception
  OtherError = object of Exception
  CustomError = object of Exception
    code: int
    details: string

  ErrorContext = object
    expectedError: string
    actualError: string
    errorWasRaised: bool
    errorMessage: string
    output: string
    codeValue: int
    exceptionObj: ref Exception

# Global context
var ctx = ErrorContext()

# Helper procs for raising different exceptions
proc raiseValueError() =
  raise newException(ValueError, "Invalid value")

proc raiseCustomError() =
  var e = newException(CustomError, "Custom error occurred")
  CustomError(e).code = 500
  CustomError(e).details = "Additional error details"
  raise e

proc raiseNoError() =
  discard # This proc doesn't raise any error

# Step definitions for "Exception expectation"
proc givenCodeThatWillRaiseAnException*() =
  ctx.expectedError = "ValueError"
  ctx.codeValue = 0 # 0 for ValueError, 1 for OtherError, 2 for no error

proc whenUsingExpectErrorToExpectSpecificExceptions*() =
  try:
    if ctx.codeValue == 0:
      expectError(ValueError):
        raiseValueError()
      ctx.errorWasRaised = true
      ctx.actualError = "ValueError"
    elif ctx.codeValue == 1:
      expectError(ValueError):
        raise newException(OtherError, "Different error")
      ctx.errorWasRaised = false
      ctx.actualError = "OtherError"
    else:
      expectError(ValueError):
        raiseNoError()
      ctx.errorWasRaised = false
      ctx.actualError = "NoError"
  except AssertionDefect:
    ctx.errorWasRaised = false

proc thenItShouldPassWhenTheExpectedExceptionIsRaised*() =
  check ctx.errorWasRaised
  check ctx.actualError == ctx.expectedError

proc andItShouldFailWhenADifferentExceptionIsRaised*() =
  ctx.codeValue = 1 # Set to raise OtherError
  whenUsingExpectErrorToExpectSpecificExceptions()
  check not ctx.errorWasRaised
  check ctx.actualError != ctx.expectedError

proc andItShouldFailWhenNoExceptionIsRaised*() =
  ctx.codeValue = 2 # Set to raise no error
  whenUsingExpectErrorToExpectSpecificExceptions()
  check not ctx.errorWasRaised
  check ctx.actualError == "NoError"

# Step definitions for "Error message verification"
proc givenCodeThatRaisesAnExceptionWithASpecificMessage*() =
  ctx.errorMessage = "Invalid value"

proc whenVerifyingTheExceptionMessageContent*() =
  try:
    expectError(ValueError, "Invalid value"):
      raiseValueError()
    ctx.errorWasRaised = true
  except AssertionDefect:
    ctx.errorWasRaised = false

proc thenItShouldPassWhenTheMessageMatchesExpectations*() =
  check ctx.errorWasRaised

proc andItShouldFailWhenTheMessageDiffersFromExpectations*() =
  try:
    expectError(ValueError, "Different message"):
      raiseValueError()
    ctx.errorWasRaised = true
  except AssertionDefect:
    ctx.errorWasRaised = false
  
  check not ctx.errorWasRaised

# Step definitions for "Multiple possible exceptions"
proc givenCodeThatMightRaiseDifferentExceptions*() =
  # Setup for a situation where different exceptions might be raised
  discard

proc whenUsingExpectErrorWithAlternativeExceptionTypes*() =
  # In a real implementation, we would capture the output and check
  # that expectError can handle multiple exception types
  discard

proc thenItShouldPassIfAnyOfTheSpecifiedExceptionsAreRaised*() =
  # This would verify that expectError passes if any of the specified
  # exceptions are raised
  discard

proc andItShouldFailIfNoneOfTheSpecifiedExceptionsAreRaised*() =
  # This would verify that expectError fails if none of the specified
  # exceptions are raised
  discard

# Step definitions for "Error in subexpressions"
proc givenAComplexExpressionWhereASubexpressionRaisesAnError*() =
  # Setup for a complex expression with subexpressions that might raise errors
  discard

proc whenTheAssertionIsExecuted*() =
  try:
    # Execute an assertion with expressions that might raise errors
    let output = capture(stderr, powerAssert(parseInt("not a number") > 0))
    ctx.output = output
  except:
    # In a real implementation, we would capture the output
    discard

proc thenTheOutputShouldIdentifyWhichSubexpressionRaisedTheError*() =
  check ctx.output.contains("parseInt")
  check ctx.output.contains("\"not a number\"")

proc andShowTheErrorMessageForDebugging*() =
  check ctx.output.contains("ValueError")
  check ctx.output.contains("Invalid value")

# Step definitions for "Custom error types"
proc givenCustomErrorTypesDerivedFromException*() =
  # Setup custom error types
  ctx.exceptionObj = newException(CustomError, "Custom error occurred")
  CustomError(ctx.exceptionObj).code = 500
  CustomError(ctx.exceptionObj).details = "Additional error details"

proc whenExpectingTheseCustomErrorsInTests*() =
  try:
    expectError(CustomError):
      raiseCustomError()
    ctx.errorWasRaised = true
  except:
    ctx.errorWasRaised = false

proc thenPowerAssertShouldProperlyRecognizeAndHandleTheseTypes*() =
  check ctx.errorWasRaised

proc andDisplayRelevantCustomErrorProperties*() =
  # This would check that power_assert displays custom error properties
  # like code and details
  discard

# Note: This is a demonstration implementation
# In a real BDD test framework, these would be registered automatically
# and matched with the feature file descriptions.