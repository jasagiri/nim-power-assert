Feature: Enhanced Assertion Output
  As a Nim developer
  I want detailed and visual assertion failure messages
  So that I can quickly understand test failures without adding boilerplate

  Scenario: Basic equality assertion
    Given a simple equality assertion that will fail
    When the assertion is executed
    Then the output should display the expression
    And the output should display the actual values of variables
    And the output should display the result of subexpressions

  Scenario: Compound expression assertion
    Given a complex expression with multiple subexpressions
    When the assertion fails
    Then the output should display the value of each subexpression
    And the output should display the structure of the expression

  Scenario: Custom type assertion
    Given custom types with toString procedure defined
    When an assertion using these types fails
    Then the output should properly display values of custom types

  Scenario: Collection assertion
    Given an assertion involving sequences, arrays, and tables
    When the assertion fails
    Then the output should display the relevant elements
    And the output should clearly show expected versus actual values

  Scenario: Integration with unittest
    Given a test suite using the unittest module
    When power_assert is used within a test block
    Then it should integrate properly with unittest output
    And it should respect unittest configuration

  Scenario: Nested expressions
    Given an expression with nested function calls or operators
    When the assertion fails
    Then the output should display the evaluation hierarchy
    And intermediate results should be correctly displayed

  Scenario: User-defined messages
    Given an assertion with a custom message
    When the assertion fails
    Then the output should include the custom message
    And still display the detailed expression breakdown

  Scenario: Boolean expression handling
    Given a boolean expression with multiple conditions
    When the assertion fails
    Then the output should show which condition(s) failed
    And display the values that caused the failure

  Scenario: Different operator types
    Given expressions with different operators (arithmetic, comparison, logical)
    When assertions with these operators fail
    Then the output should correctly handle each operator type
    And display appropriate context for each operator

  Scenario: Edge cases
    Given assertions with edge cases (null values, empty collections, edge numbers)
    When these assertions fail
    Then the output should handle edge cases gracefully
    And provide useful diagnostics for debugging

  Scenario: Complex nested data structures
    Given complex data structures (nested objects, collections of objects)
    When assertions on these structures fail
    Then the output should present the relevant parts of the structures
    And make it clear where in the structure the mismatch occurred