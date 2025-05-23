Feature: Error Handling in Power Assertions
  As a Nim developer
  I want power assertions to handle errors properly
  So that I can test error conditions effectively

  Scenario: Exception expectation
    Given code that will raise an exception
    When using expectError to expect specific exceptions
    Then it should pass when the expected exception is raised
    And it should fail when a different exception is raised
    And it should fail when no exception is raised

  Scenario: Error message verification
    Given code that raises an exception with a specific message
    When verifying the exception message content
    Then it should pass when the message matches expectations
    And it should fail when the message differs from expectations

  Scenario: Multiple possible exceptions
    Given code that might raise different exceptions
    When using expectError with alternative exception types
    Then it should pass if any of the specified exceptions are raised
    And it should fail if none of the specified exceptions are raised

  Scenario: Error in subexpressions
    Given a complex expression where a subexpression raises an error
    When the assertion is executed
    Then the output should identify which subexpression raised the error
    And show the error message for debugging

  Scenario: Deferred exceptions
    Given code that generates deferred exceptions
    When assertions are made after potential exception points
    Then the output should properly handle these exceptions
    And indicate where they were actually raised

  Scenario: Error stack traces
    Given code that generates deep error stack traces
    When using power_assert in this context
    Then stack traces should be presented in a readable format
    And include relevant source code locations

  Scenario: Custom error types
    Given custom error types derived from Exception
    When expecting these custom errors in tests
    Then power_assert should properly recognize and handle these types
    And display relevant custom error properties

  Scenario: Error in collection operations
    Given operations on collections that might raise errors (e.g., index out of bounds)
    When assertions involving these operations fail
    Then the output should clearly indicate the operation that failed
    And provide context about why it failed

  Scenario: System error handling
    Given operations that might result in system errors (file i/o, etc.)
    When these operations are used in power assertions
    Then system error information should be properly captured and displayed
    And contain useful diagnostic information