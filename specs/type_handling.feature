Feature: Type Handling in Power Assertions
  As a Nim developer
  I want power assertions to handle different types correctly
  So that I can use assertions with any type without special handling

  Scenario: Primitive type handling
    Given assertions using primitive types (int, float, string, char, bool)
    When these assertions fail
    Then the output should correctly display the primitive type values
    And show appropriate type information for each value

  Scenario: User-defined object types
    Given an object type with multiple fields
    When assertions comparing objects fail
    Then the output should show the field values that differ
    And display the objects in a readable format

  Scenario: Sequence and array comparison
    Given sequences and arrays of different types
    When assertions comparing these collections fail
    Then the output should show elements that differ
    And indicate the indices where mismatches occur

  Scenario: Table and map comparisons
    Given tables or maps with various key-value pairs
    When assertions comparing tables fail
    Then the output should identify which keys have different values
    And show both the expected and actual values for those keys

  Scenario: Option type handling
    Given option types (some and none values)
    When assertions with option types fail
    Then the output should clearly indicate if a value is present or not
    And display the contained value when present

  Scenario: Custom generic types
    Given generic types instantiated with different type parameters
    When assertions with generic types fail
    Then the output should correctly display the type information
    And show the generic parameter types in the output

  Scenario: Reference and pointer type handling
    Given reference and pointer types pointing to values
    When assertions comparing references or pointers fail
    Then the output should show the dereferenced values
    And indicate that they are references/pointers

  Scenario: Tuple comparison
    Given tuples with mixed types
    When assertions comparing tuples fail
    Then the output should show which tuple elements differ
    And display both expected and actual values for each position

  Scenario: Enum type handling
    Given enum types with multiple possible values
    When assertions comparing enum values fail
    Then the output should display the enum value names
    And not just show the underlying numeric values

  Scenario: Procedure type handling
    Given procedure types or closures
    When assertions involving procedure equality fail
    Then the output should provide meaningful information about the procedures
    And not just show memory addresses