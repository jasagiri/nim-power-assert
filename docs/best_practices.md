# PowerAssert Best Practices

This guide provides best practices and recommendations for using PowerAssert effectively in your Nim projects.

## Table of Contents

1. [General Guidelines](#general-guidelines)
2. [Writing Effective Assertions](#writing-effective-assertions)
3. [Custom Types](#custom-types)
4. [Performance Considerations](#performance-considerations)
5. [Integration with Testing Frameworks](#integration-with-testing-frameworks)
6. [Using the Hint System](#using-the-hint-system)
7. [Debugging Tips](#debugging-tips)
8. [Common Pitfalls](#common-pitfalls)

## General Guidelines

### Use Descriptive Variable Names

Good variable names make PowerAssert's output more readable:

```nim
# Good - clear variable names
let expectedCount = 10
let actualCount = users.len
powerAssert(actualCount == expectedCount)
```

```nim
# Avoid - cryptic variable names
let x = 10
let y = users.len
powerAssert(y == x)
```

### Keep Expressions Reasonably Complex

PowerAssert shines with moderately complex expressions. For very simple checks, standard assertions may suffice:

```nim
# Good - complex enough to benefit from visual output
powerAssert(user.isActive and user.score > threshold and user.permissions.canEdit)

# Overkill for simple checks
powerAssert(x == 5)  # Standard assert might be sufficient
```

### Use Custom Messages for Business Logic

Add custom messages to explain the business context:

```nim
powerAssert(
  account.balance >= withdrawalAmount,
  "Insufficient funds for withdrawal"
)

powerAssert(
  user.age >= 18,
  "User must be at least 18 years old"
)
```

## Writing Effective Assertions

### Structure Expressions for Clarity

Organize complex expressions to make the visual output clearer:

```nim
# Good - logical grouping
let isValidUser = user.isActive and user.isVerified
let hasPermission = user.role == Admin or user.permissions.canEdit
powerAssert(isValidUser and hasPermission)

# Less clear - everything in one expression
powerAssert(user.isActive and user.isVerified and (user.role == Admin or user.permissions.canEdit))
```

### Use Meaningful Intermediate Variables

Break down complex calculations into steps:

```nim
# Good - shows intermediate calculations
let totalPrice = basePrice + tax
let discountedPrice = totalPrice * (1.0 - discountRate)
powerAssert(discountedPrice <= budget)

# Less informative
powerAssert((basePrice + tax) * (1.0 - discountRate) <= budget)
```

### Leverage PowerAssert for Data Structure Validation

PowerAssert excels at showing the contents of data structures:

```nim
# Array/sequence validation
let numbers = @[1, 2, 3, 4, 5]
powerAssert(numbers[2] == 3 and numbers.len == 5)

# Object validation
powerAssert(response.status == 200 and response.data.len > 0)
```

## Custom Types

### Always Implement the `$` Operator

Implement meaningful string representations for your custom types:

```nim
type
  User = object
    id: int
    name: string
    email: string
    isActive: bool

proc `$`(user: User): string =
  fmt"User(id: {user.id}, name: {user.name}, active: {user.isActive})"

# Now PowerAssert can display user objects meaningfully
let user1 = User(id: 1, name: "Alice", email: "alice@example.com", isActive: true)
let user2 = User(id: 2, name: "Bob", email: "bob@example.com", isActive: false)
powerAssert(user1.isActive == user2.isActive)
```

### Implement Comparison Operators

Define equality and comparison operators for meaningful assertions:

```nim
proc `==`(a, b: User): bool =
  a.id == b.id and a.name == b.name and a.email == b.email

proc `<`(a, b: User): bool =
  a.id < b.id

# Now you can use PowerAssert with user comparisons
powerAssert(user1 == user2)
powerAssert(user1 < user2)
```

### Keep String Representations Concise

Avoid overly verbose `$` implementations:

```nim
# Good - concise but informative
proc `$`(user: User): string =
  fmt"{user.name} (ID: {user.id})"

# Too verbose for assertion output
proc `$`(user: User): string =
  fmt"User Details - ID: {user.id}, Full Name: {user.name}, Email Address: {user.email}, Account Status: {if user.isActive: \"Active\" else: \"Inactive\"}"
```

## Performance Considerations

### Be Aware of Side Effects

PowerAssert evaluates expressions only once, but be mindful of expensive operations:

```nim
# Good - cache expensive operations
let expensiveResult = performComplexCalculation()
powerAssert(expensiveResult > threshold)

# Less efficient - calculated every time during development
powerAssert(performComplexCalculation() > threshold)
```

### Use PowerAssert in Debug Builds

PowerAssert's enhanced features are most active in debug builds. In release builds, consider the performance impact:

```nim
# PowerAssert automatically provides minimal overhead in release builds
when not defined(release):
  powerAssert(complexCondition)
else:
  assert(complexCondition)  # Fallback for release builds
```

## Integration with Testing Frameworks

### Use with unittest Module

PowerAssert integrates seamlessly with Nim's unittest:

```nim
import unittest
import power_assert

suite "User Management":
  test "user creation":
    let user = createUser("Alice", "alice@example.com")
    check(user.name == "Alice")
    check(user.email == "alice@example.com")
    check(user.isActive == true)
  
  test "user validation":
    let user = User(name: "", email: "invalid-email", isActive: false)
    check(validateUser(user) == false)
```

### Organize Tests Logically

Group related assertions in meaningful test cases:

```nim
suite "E-commerce Cart":
  setup:
    let cart = newCart()
    let product1 = Product(id: 1, price: 10.0)
    let product2 = Product(id: 2, price: 20.0)
  
  test "adding products":
    cart.add(product1)
    check(cart.items.len == 1)
    check(cart.total == 10.0)
    
    cart.add(product2)
    check(cart.items.len == 2)
    check(cart.total == 30.0)
  
  test "removing products":
    cart.add(product1)
    cart.add(product2)
    cart.remove(product1.id)
    check(cart.items.len == 1)
    check(cart.total == 20.0)
```

## Using the Hint System

PowerAssert's intelligent hint system provides Rust-like helpful suggestions to fix assertion failures quickly.

### Understanding Hint Types

The hint system provides four types of guidance:

1. **Type Mismatch Hints**: Help with type conversion issues
2. **Common Mistake Hints**: Catch frequent programming errors
3. **Suggestion Hints**: Provide specific improvement recommendations
4. **Note Hints**: Explain why operations failed

### Leveraging Type Mismatch Hints

When comparing different types, PowerAssert suggests appropriate conversions:

```nim
let userAge = 25
let minimumAge = 18.0  # Float instead of int

# Instead of getting a generic type error, you get:
powerAssert(userAge >= minimumAge)
```

PowerAssert will suggest:
```
Help:
  type mismatch: Comparing int with float
    → Consider converting one type: float(userAge) or int(minimumAge)
```

### String Comparison Intelligence

PowerAssert analyzes string comparison failures and provides specific guidance:

```nim
# Case sensitivity issues
let username = "Alice"
let expectedUser = "alice"
powerAssert(username == expectedUser)
```

Output:
```
Help:
  suggestion: Strings differ only in case
    → Use .toLowerAscii() or .toUpperAscii() for case-insensitive comparison
```

```nim
# Whitespace issues
let input = "Hello World "  # Trailing space
let expected = "Hello World"
powerAssert(input == expected)
```

Output:
```
Help:
  suggestion: String lengths differ: 12 vs 11
    → Check for extra whitespace, different line endings, or missing characters
```

### Boolean Logic Guidance

When complex boolean expressions fail, PowerAssert explains why:

```nim
let user = User(isActive: false, hasPermission: true, age: 25)
powerAssert(user.isActive and user.hasPermission and user.age > 18)
```

Output:
```
Help:
  note: Boolean AND operation failed
    → All conditions in 'and' expression must be true. Check each condition separately.
```

### Collection State Insights

PowerAssert detects empty collections and suggests solutions:

```nim
let items: seq[string] = @[]
let expectedCount = 3
powerAssert(items.len == expectedCount)
```

Output:
```
Help:
  note: Collection is empty
    → Verify that elements were added to the collection before testing
```

### Writing Hint-Friendly Code

To get the most from the hint system:

#### Use Clear Variable Names
```nim
# Good - hints will reference meaningful names
let actualUserCount = users.len
let expectedUserCount = 5
powerAssert(actualUserCount == expectedUserCount)

# Less helpful - hints reference cryptic names
let x = users.len
let y = 5
powerAssert(x == y)
```

#### Structure Complex Conditions
```nim
# Good - allows targeted hints for each part
let isValidUser = user.isActive and user.isVerified
let hasAccess = user.role == Admin or user.hasPermission
powerAssert(isValidUser and hasAccess)

# Less clear - generic hints for the whole expression
powerAssert(user.isActive and user.isVerified and (user.role == Admin or user.hasPermission))
```

#### Separate Concerns
```nim
# Good - specific hints for each check
powerAssert(response.status == 200, "API call should succeed")
powerAssert(response.data.len > 0, "Response should contain data")
powerAssert(response.data[0].id == expectedId, "First item should match")

# Less helpful - combined assertion with generic hints
powerAssert(response.status == 200 and response.data.len > 0 and response.data[0].id == expectedId)
```

### Acting on Hints

When you see hints, take action:

1. **Type Mismatch**: Apply the suggested conversion
2. **String Issues**: Use the recommended string methods
3. **Boolean Logic**: Check each condition individually
4. **Collections**: Verify your data setup logic
5. **Common Mistakes**: Review your operators and syntax

### Custom Hint Integration

While PowerAssert provides built-in hints, you can enhance them with custom messages:

```nim
powerAssert(
  account.balance >= withdrawalAmount,
  "Insufficient funds - consider account limits and pending transactions"
)
```

This combines PowerAssert's automatic analysis with your domain-specific context.

## Debugging Tips

### Use Visual Output to Understand Failures

When a test fails, study the visual output to understand the problem:

```
PowerAssert: Assertion failed

cart.items.len == expectedCount and cart.total == expectedTotal
|||||||||||||||    |||||||||||||     |||||||||||    |||||||||||||
3                  2                 45.0           50.0

[int] cart.items.len
=> 3
[int] expectedCount
=> 2
[float] cart.total
=> 45.0
[float] expectedTotal
=> 50.0
```

This immediately shows that both the count and total are wrong.

### Add Context with Custom Messages

Provide context for complex business rules:

```nim
powerAssert(
  order.status == Completed and payment.status == Confirmed,
  "Order can only be shipped when both order and payment are confirmed"
)
```

### Use require for Preconditions

Use `require` to validate preconditions:

```nim
proc processOrder(order: Order): Result[ProcessedOrder, string] =
  require(order.items.len > 0, "Order must have at least one item")
  require(order.customer.isActive, "Customer must be active")
  
  # Process the order...
```

## Common Pitfalls

### Avoid Side Effects in Assertions

Don't put side effects in assertion expressions:

```nim
# Bad - modifies state during assertion
var counter = 0
powerAssert(counter.inc() == 1)  # Don't do this

# Good - separate side effects from assertions
var counter = 0
counter.inc()
powerAssert(counter == 1)
```

### Don't Rely on Expression Evaluation Order

While PowerAssert is side-effect safe, don't rely on specific evaluation orders:

```nim
# Bad - assumes specific evaluation order
var x = 0
powerAssert(x.inc() == 1 and x == 1)

# Good - make expectations explicit
var x = 0
x.inc()
powerAssert(x == 1)
```

### Avoid Overly Complex Single Assertions

Break down very complex assertions:

```nim
# Too complex - hard to understand failures
powerAssert(
  user.profile.settings.notifications.email.enabled and
  user.profile.settings.notifications.sms.enabled and
  user.profile.settings.privacy.publicProfile and
  user.subscription.tier == Premium and
  user.subscription.isActive and
  user.billing.hasValidPaymentMethod
)

# Better - break into logical groups
let notificationsEnabled = user.profile.settings.notifications.email.enabled and
                           user.profile.settings.notifications.sms.enabled
let profilePublic = user.profile.settings.privacy.publicProfile
let subscriptionValid = user.subscription.tier == Premium and user.subscription.isActive
let billingValid = user.billing.hasValidPaymentMethod

powerAssert(notificationsEnabled, "User notifications must be enabled")
powerAssert(profilePublic, "User profile must be public")
powerAssert(subscriptionValid, "User must have active premium subscription")
powerAssert(billingValid, "User must have valid payment method")
```

### Handle Optional/Nullable Types Carefully

Be explicit about handling optional values:

```nim
# Good - explicit handling
let userOpt = findUser(userId)
powerAssert(userOpt.isSome, "User should exist")
let user = userOpt.get()
powerAssert(user.isActive, "User should be active")

# Risky - could fail unexpectedly
powerAssert(findUser(userId).get().isActive)
```

## Summary

PowerAssert is most effective when used with:
- Clear, descriptive variable names
- Well-structured expressions
- Custom types with good string representations
- Meaningful custom messages
- Proper separation of side effects from assertions

By following these best practices, you'll get the most benefit from PowerAssert's enhanced debugging capabilities and create more maintainable tests.