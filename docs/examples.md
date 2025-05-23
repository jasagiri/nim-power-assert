# PowerAssert for Nim: 使用例集

このドキュメントは PowerAssert の様々な使用例を提供し、実際のシナリオでどのように活用できるかを示します。

## 基本的な使用例

### 単純な比較

```nim
import power_assert

let x = 10
let y = 5

powerAssert(x > y)  # 成功
powerAssert(x < y)  # 失敗: 詳細なエラーメッセージが表示される
```

失敗時の出力:
```
PowerAssert: Assertion failed

x < y

^ 10 (int)
    ^ 5 (int)
      ^ false (bool)
```

### 算術演算

```nim
import power_assert

let a = 5
let b = 7

powerAssert(a + b == 12)  # 成功
powerAssert(a + b == 10)  # 失敗: 詳細なエラーメッセージが表示される
```

失敗時の出力:
```
PowerAssert: Assertion failed

a + b == 10

^ 5 (int)
    ^ 7 (int)
      ^ 12 (int)
         ^ 10 (int)
         ^ false (bool)

# Composite expressions:
a + b = 12 (int)
```

### 文字列操作

```nim
import power_assert

let greeting = "Hello"
let name = "World"

powerAssert(greeting & " " & name == "Hello World")  # 成功
powerAssert(greeting & name == "Hello World")  # 失敗
```

失敗時の出力:
```
PowerAssert: Assertion failed

greeting & name == "Hello World"

^ "Hello" (string)
            ^ "World" (string)
              ^ "HelloWorld" (string)
                 ^ "Hello World" (string)
                 ^ false (bool)

# Composite expressions:
greeting & name = "HelloWorld" (string)
```

## unittest との統合

```nim
import unittest except check
import power_assert

suite "Math operations":
  test "addition":
    let a = 5
    let b = 7
    check(a + b == 12)  # 成功
  
  test "subtraction":
    let x = 10
    let y = 3
    check(x - y == 5)  # 失敗: PowerAssertの詳細メッセージが表示される
```

## カスタム型との使用

```nim
import power_assert

type
  Person = object
    name: string
    age: int

proc `$`(p: Person): string =
  result = p.name & " (" & $p.age & ")"

proc `==`(a, b: Person): bool =
  a.name == b.name and a.age == b.age

let person1 = Person(name: "Alice", age: 30)
let person2 = Person(name: "Alice", age: 25)

powerAssert(person1 == person2)  # 失敗
```

失敗時の出力:
```
PowerAssert: Assertion failed

person1 == person2

^ Alice (30) (Person)
             ^ Alice (25) (Person)
                         ^ false (bool)
```

## コレクションとシーケンス

### 配列の使用

```nim
import power_assert

let numbers = [1, 2, 3, 4, 5]

powerAssert(numbers[2] == 3)  # 成功
powerAssert(numbers[2] == 4)  # 失敗
```

失敗時の出力:
```
PowerAssert: Assertion failed

numbers[2] == 4

^ [1, 2, 3, 4, 5] (array[5, int])
         ^ 3 (int)
            ^ 4 (int)
            ^ false (bool)

# Composite expressions:
numbers[2] = 3 (int)
```

### シーケンスの操作

```nim
import power_assert

let fruits = @["apple", "banana", "cherry"]

powerAssert(fruits.len == 3)  # 成功
powerAssert("orange" in fruits)  # 失敗
```

失敗時の出力:
```
PowerAssert: Assertion failed

"orange" in fruits

^ "orange" (string)
           ^ @["apple", "banana", "cherry"] (seq[string])
             ^ false (bool)
```

## 複雑な式の評価

```nim
import power_assert

proc square(x: int): int = x * x
proc isEven(x: int): bool = x mod 2 == 0

let a = 5
let b = 7

powerAssert(isEven(square(a) + b))  # 失敗
```

失敗時の出力:
```
PowerAssert: Assertion failed

isEven(square(a) + b)

      ^ 5 (int)
                ^ 7 (int)
                  ^ 32 (int)
       ^ 25 (int)
                 ^ false (bool)

# Composite expressions:
square(a) = 25 (int)
square(a) + b = 32 (int)
isEven(square(a) + b) = false (bool)
```

## エラー処理のテスト

```nim
import power_assert

proc divideNumbers(a, b: int): int =
  if b == 0:
    raise newException(DivByZeroDefect, "Division by zero")
  return a div b

# 正常なケース
let result = divideNumbers(10, 2)
powerAssert(result == 5)  # 成功

# エラーケースのテスト
expectError(DivByZeroDefect):
  discard divideNumbers(10, 0)  # 成功: 期待通りの例外が発生

# 誤った例外タイプの指定
expectError(ValueError):
  discard divideNumbers(10, 0)  # 失敗: 別の例外が発生
```

## 複数の検証

```nim
import power_assert

proc validatePerson(name: string, age: int): bool =
  powerAssert(name.len > 0, "名前は空であってはなりません")
  powerAssert(age >= 0, "年齢は負であってはなりません")
  powerAssert(age < 150, "年齢は現実的でなければなりません")
  return true

discard validatePerson("Alice", 30)  # 成功
discard validatePerson("", 30)  # 失敗: 名前の検証で失敗
discard validatePerson("Bob", -5)  # 失敗: 年齢の検証で失敗
```

## プロシージャの戻り値の検証

```nim
import power_assert

proc getUserAge(name: string): int =
  case name
  of "Alice": return 30
  of "Bob": return 25
  else: return 0

let age = getUserAge("Alice")
powerAssert(age == 30)  # 成功

let unknownAge = getUserAge("Charlie")
powerAssert(unknownAge > 0)  # 失敗
```

失敗時の出力:
```
PowerAssert: Assertion failed

unknownAge > 0

^ 0 (int)
           ^ 0 (int)
           ^ false (bool)
```

## 論理演算子

```nim
import power_assert

let a = true
let b = false
let c = true

powerAssert(a and b)  # 失敗
powerAssert(a or b)   # 成功
powerAssert(a and c)  # 成功
powerAssert(not b)    # 成功
```

失敗時の出力:
```
PowerAssert: Assertion failed

a and b

^ true (bool)
      ^ false (bool)
        ^ false (bool)
```

## カスタムメッセージの追加

```nim
import power_assert

let score = 65
powerAssert(score >= 70, "スコアは合格点（70点）以上である必要があります")  # 失敗
```

失敗時の出力:
```
PowerAssert: Assertion failed

score >= 70

^ 65 (int)
        ^ 70 (int)
        ^ false (bool)

Message: スコアは合格点（70点）以上である必要があります
```

## 副作用の安全な処理

PowerAssert は式の副作用を安全に処理します。式は一度だけ評価されるため、副作用を持つ操作も安全に使用できます。

### インクリメント操作

```nim
import power_assert

var counter = 0
powerAssert((counter += 1) == 2)  # 失敗するが、counter は1回だけインクリメントされる
echo "Counter value: ", counter  # "Counter value: 1" と表示される
```

失敗時の出力:
```
PowerAssert: Assertion failed

(counter += 1) == 2

^ 1 (int)
              ^ 2 (int)
              ^ false (bool)
```

### 副作用を持つ関数

```nim
import power_assert

var callCount = 0

proc functionWithSideEffect(): int =
  callCount += 1
  return callCount

powerAssert(functionWithSideEffect() == 2)  # 失敗するが、関数は1回だけ呼ばれる
echo "Call count: ", callCount  # "Call count: 1" と表示される
```

失敗時の出力:
```
PowerAssert: Assertion failed

functionWithSideEffect() == 2

^ 1 (int)
                         ^ 2 (int)
                         ^ false (bool)
```

## テーブル型の比較

```nim
import power_assert
import tables

let t1 = {"a": 1, "b": 2, "c": 3}.toTable
let t2 = {"a": 1, "b": 2, "c": 4}.toTable

powerAssert(t1 == t2)  # 失敗
```

失敗時の出力:
```
PowerAssert: Assertion failed

t1 == t2

^ {a: 1, b: 2, c: 3} (Table[system.string, system.int])
      ^ {a: 1, b: 2, c: 4} (Table[system.string, system.int])
        ^ false (bool)
```

## オプション型の使用

```nim
import power_assert
import options

let opt1 = some(42)
let opt2 = none(int)

powerAssert(opt1.isSome)  # 成功
powerAssert(opt2.isSome)  # 失敗
powerAssert(opt1.get == 100)  # 失敗
```

失敗時の出力:
```
PowerAssert: Assertion failed

opt2.isSome

^ None[int] (Option[system.int])
         ^ false (bool)
```

## 入れ子になった複雑な式

```nim
import power_assert
import sequtils
import options

type
  OptionalValue = Option[int]

proc square(x: int): int = x * x

proc processValue(opt: OptionalValue): int =
  if opt.isSome:
    return square(opt.get)
  else:
    return 0

let values = @[some(3), some(4), none(int)]
let results = values.map(processValue)

powerAssert(results.max == 25)  # 失敗
```

失敗時の出力:
```
PowerAssert: Assertion failed

results.max == 25

^ @[9, 16, 0] (seq[int])
          ^ 16 (int)
             ^ 25 (int)
             ^ false (bool)

# Composite expressions:
results.max = 16 (int)
```

## 複合データ構造

```nim
import power_assert

type
  Address = object
    street: string
    city: string
    zipCode: string

  Customer = object
    name: string
    age: int
    address: Address

proc `$`(a: Address): string =
  result = a.street & ", " & a.city & " " & a.zipCode

proc `$`(c: Customer): string =
  result = c.name & " (" & $c.age & ") - " & $c.address

let customer1 = Customer(
  name: "John Doe",
  age: 35,
  address: Address(
    street: "123 Main St",
    city: "Anytown",
    zipCode: "12345"
  )
)

let customer2 = Customer(
  name: "John Doe",
  age: 35,
  address: Address(
    street: "456 Oak Ave",
    city: "Anytown",
    zipCode: "12345"
  )
)

powerAssert(customer1 == customer2)  # 失敗（住所が異なる）
```

## マップとフィルタ操作

```nim
import power_assert
import sequtils
import sugar

let numbers = @[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# マップ操作で各要素を2倍にする
let doubled = numbers.map(x => x * 2)

# フィルタ操作で偶数のみを選択
let evens = numbers.filter(x => x mod 2 == 0)

powerAssert(doubled.sum == 120)  # 失敗: 実際の合計は110
powerAssert(evens.len == 6)      # 失敗: 実際の長さは5
```

失敗時の出力:
```
PowerAssert: Assertion failed

doubled.sum == 120

^ @[2, 4, 6, 8, 10, 12, 14, 16, 18, 20] (seq[int])
           ^ 110 (int)
              ^ 120 (int)
              ^ false (bool)

# Composite expressions:
doubled.sum = 110 (int)
```

## 高階関数

```nim
import power_assert

proc applyTwice(f: proc(x: int): int, value: int): int =
  f(f(value))

proc increment(x: int): int = x + 1
proc double(x: int): int = x * 2

let result1 = applyTwice(increment, 5)  # 5 + 1 + 1 = 7
let result2 = applyTwice(double, 3)     # 3 * 2 * 2 = 12

powerAssert(result1 == 8)  # 失敗
powerAssert(result2 == 12) # 成功
```

## カラー出力のカスタマイズ

```nim
import power_assert
import terminal

# カラー出力のカスタマイズ
setColorScheme(
  errorTitle: fgRed,
  varName: fgCyan, 
  varValue: fgGreen,
  varType: fgYellow,
  pointer: fgMagenta,
  operator: fgBlue
)

let x = 10
let y = 20

powerAssert(x > y)  # カラー付きのエラーメッセージが表示される
```

## 実行時条件を使用した検証

```nim
import power_assert

proc validateUserInput(input: string): bool =
  # 基本的な検証
  powerAssert(input.len > 0, "入力は空であってはなりません")
  
  # 実行時条件に基づく高度な検証
  if input.len > 10:
    powerAssert(input.contains('@'), "長い入力はメールアドレスである必要があります")
  else:
    powerAssert(input.all(char -> char.isAlphaNumeric), "短い入力は英数字のみである必要があります")
  
  return true

discard validateUserInput("user123")      # 成功: 短い英数字入力
discard validateUserInput("user@example.com")  # 成功: 長いメールアドレス
discard validateUserInput("user 123")     # 失敗: 短い入力にスペースが含まれている
discard validateUserInput("longusername") # 失敗: 長い入力にメールアドレス形式がない
```

## 再帰データ構造

```nim
import power_assert

type
  TreeNode = ref object
    value: int
    left: TreeNode
    right: TreeNode

proc `$`(node: TreeNode): string =
  if node == nil:
    return "nil"
  return "Node(" & $node.value & 
    ", left: " & $node.left & 
    ", right: " & $node.right & ")"

proc createNode(value: int): TreeNode =
  result = TreeNode(value: value)

proc addLeft(node: TreeNode, value: int): TreeNode =
  node.left = createNode(value)
  return node.left

proc addRight(node: TreeNode, value: int): TreeNode =
  node.right = createNode(value)
  return node.right

# ツリーの構築
let root = createNode(10)
let leftChild = root.addLeft(5)
let rightChild = root.addRight(15)
let leftGrandchild = leftChild.addLeft(3)

# 検証
powerAssert(root.left.value == 5)  # 成功
powerAssert(root.right.value == 20)  # 失敗
```

## 非同期操作のテスト

```nim
import power_assert
import asyncdispatch

proc asyncTask(): Future[int] {.async.} =
  await sleepAsync(100)
  return 42

proc testAsyncOperation() {.async.} =
  let result = await asyncTask()
  
  # 非同期結果の検証
  powerAssert(result == 42)  # 成功
  powerAssert(result == 50)  # 失敗

# 非同期テストの実行
waitFor testAsyncOperation()
```

## 実践的なシナリオ: ユーザー入力の検証

```nim
import power_assert
import strutils

type
  User = object
    username: string
    email: string
    password: string

proc validateUsername(username: string): bool =
  powerAssert(username.len >= 3, "ユーザー名は3文字以上である必要があります")
  powerAssert(username.len <= 20, "ユーザー名は20文字以下である必要があります")
  powerAssert(username.all(char -> char.isAlphaNumeric or char == '_'),
    "ユーザー名は英数字とアンダースコアのみ使用できます")
  return true

proc validateEmail(email: string): bool =
  powerAssert(email.contains('@'), "メールアドレスには @ が含まれている必要があります")
  powerAssert(email.contains('.'), "メールアドレスにはドメインの区切りが必要です")
  return true

proc validatePassword(password: string): bool =
  powerAssert(password.len >= 8, "パスワードは8文字以上である必要があります")
  powerAssert(password.any(char -> char.isUpperAscii), 
    "パスワードには少なくとも1つの大文字が必要です")
  powerAssert(password.any(char -> char.isLowerAscii), 
    "パスワードには少なくとも1つの小文字が必要です")
  powerAssert(password.any(char -> char.isDigit), 
    "パスワードには少なくとも1つの数字が必要です")
  return true

proc registerUser(username, email, password: string): User =
  discard validateUsername(username)
  discard validateEmail(email)
  discard validatePassword(password)
  
  return User(
    username: username,
    email: email,
    password: password
  )

# 正常なケース
let validUser = registerUser(
  "john_doe", 
  "john@example.com", 
  "Password123"
)

# 不正なケース
try:
  let invalidUser = registerUser(
    "j", 
    "invalid-email", 
    "weakpwd"
  )
except:
  echo "ユーザー登録に失敗しました"
```

これらの例は PowerAssert の様々な機能と使用方法を示しています。プロジェクトの特性に応じて、これらの例を拡張または調整することができます。