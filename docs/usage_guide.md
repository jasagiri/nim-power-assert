# PowerAssert 使用ガイド

このガイドでは、PowerAssert for Nimの効果的な使用方法を説明します。初心者向けの基本的な使用法から、高度なシナリオまでをカバーします。

## 目次

1. [基本的な使用方法](#基本的な使用方法)
2. [テストにPowerAssertを統合する](#テストにpowerassertを統合する)
3. [異なるデータ型でのPowerAssertの使用](#異なるデータ型でのpowerassertの使用)
4. [カスタム型での使用](#カスタム型での使用)
5. [エラー処理とPowerAssert](#エラー処理とpowerassert)
6. [高度な使用例](#高度な使用例)
7. [よくある問題と解決策](#よくある問題と解決策)

## 基本的な使用方法

### PowerAssertのインポート

```nim
import power_assert
```

必要に応じて、標準の `unittest` モジュールを使用する場合は、チェック関数の競合を避けるためにインポート文を以下のように修正します：

```nim
import unittest except check
import power_assert
```

### 単純なアサーション

PowerAssertの基本的な使用方法は次のとおりです：

```nim
let a = 5
let b = 10

# 等価性の検証
powerAssert(a + a == b)  # 成功

# 不等式の検証
powerAssert(a < b)      # 成功
powerAssert(a > b)      # 失敗、詳細な出力が表示される
```

失敗した場合、次のような詳細な出力が得られます：

```
PowerAssert: Assertion failed

a > b

^ ^
5 10
(int) (int)

a > b
^^^^^
false
(bool)
```

### カスタムエラーメッセージの追加

条件に加えて、カスタムメッセージを提供することができます：

```nim
let userName = "alice"
powerAssert(userName.len > 5, "ユーザー名は5文字よりも長い必要があります")
```

失敗すると、カスタムメッセージが出力に含まれます：

```
PowerAssert: Assertion failed

userName.len > 5

^^^^^^^^^^ ^
alice      5
(string)   (int)

userName.len > 5
^^^^^^^^^^^^^^
false
(bool)

Message: ユーザー名は5文字よりも長い必要があります
```

## テストにPowerAssertを統合する

### unittestモジュールとの統合

PowerAssertは、Nimの標準unittestモジュールとシームレスに統合できます：

```nim
import unittest except check
import power_assert

suite "ユーザー認証":
  test "パスワードの妥当性検証":
    let password = "short"
    let minLength = 8
    
    check(password.len >= minLength)  # PowerAssertの詳細出力で失敗
```

### テスト前提条件の指定

テストで前提条件を明確にする場合は、`require`テンプレートを使用します：

```nim
test "ユーザープロファイルの更新":
  let user = User(id: 1, name: "Alice")
  require(user.id > 0, "有効なユーザーIDが必要です")
  
  # 前提条件が満たされたら、実際のテストロジックを実行
  user.name = "Alicia"
  check(user.name == "Alicia")
```

## 異なるデータ型でのPowerAssertの使用

PowerAssertは、さまざまなNimのデータ型をサポートしています：

### プリミティブ型

```nim
# 数値型
let intValue = 42
let floatValue = 3.14
powerAssert(intValue.float == floatValue * 10 + 10.6)

# 文字列
let greeting = "Hello"
let name = "World"
powerAssert(greeting & " " & name == "Hello World")

# ブール値
let flag1 = true
let flag2 = false
powerAssert(flag1 or flag2)  # 成功
powerAssert(flag1 and flag2)  # 失敗
```

### コレクション型

```nim
# 配列
let arr = [1, 2, 3, 4, 5]
powerAssert(arr[2] == 3)
powerAssert(arr.len == 5)

# シーケンス
let seq1 = @[1, 2, 3, 4, 5]
powerAssert(seq1[0] == 1)
powerAssert(seq1.contains(3))

# テーブル
import tables
let scores = {"Alice": 95, "Bob": 80, "Charlie": 85}.toTable
powerAssert(scores["Alice"] > 90)
powerAssert("Dave" in scores)  # 失敗
```

## カスタム型での使用

PowerAssertは、カスタム型のサポートも簡単です。`$`演算子を実装することで、詳細なエラーメッセージで適切に表示されます：

```nim
type
  Person = object
    name: string
    age: int

# 文字列変換演算子を実装
proc `$`(p: Person): string =
  return p.name & " (age: " & $p.age & ")"

# カスタム比較演算子も実装できる
proc `==`(a, b: Person): bool =
  return a.name == b.name and a.age == b.age

# 使用例
let person1 = Person(name: "Alice", age: 30)
let person2 = Person(name: "Bob", age: 25)

powerAssert(person1 == person2)  # 失敗し、詳細なエラーメッセージを表示
```

エラーメッセージ：

```
PowerAssert: Assertion failed

person1 == person2

^^^^^^^ ^^ ^^^^^^^
Alice   == Bob
(age: 30)  (age: 25)
(Person)   (Person)

person1 == person2
^^^^^^^^^^^^^^^
false
(bool)
```

## エラー処理とPowerAssert

特定の例外が発生することを期待してコードをテストする場合は、`expectError`テンプレートを使用します：

```nim
test "無効な入力の処理":
  # パースエラーを期待する
  expectError(ValueError):
    discard parseInt("not a number")
  
  # 存在しないキーのアクセスでKeyErrorを期待
  let table = {"a": 1, "b": 2}.toTable
  expectError(KeyError):
    discard table["c"]
```

異なる例外が発生した場合や例外が発生しなかった場合、テストは失敗し、詳細なエラーメッセージが表示されます。

## 高度な使用例

### 複雑な式の評価

PowerAssertは複雑な式も適切に処理し、各部分の評価結果を表示します：

```nim
proc calculate(x, y: int): int =
  return x * y + 5

let a = 3
let b = 4
let expectedResult = 20

powerAssert(calculate(a, b) + a == expectedResult)
```

失敗した場合、次のような詳細な出力が得られます：

```
PowerAssert: Assertion failed

calculate(a, b) + a == expectedResult

^^^^^^^^^^^^^ ^ ^ ^^ ^^^^^^^^^^^^^^^
17          + 3 == 20
(int)         (int)  (int)

calculate(a, b) + a == expectedResult
^^^^^^^^^^^^^^^^^^^^
false
(bool)

# Composite expressions:
calculate(a, b) = 17 (int)
calculate(a, b) + a = 20 (int)
```

### 関数呼び出しを含む式

```nim
proc isEven(x: int): bool = x mod 2 == 0
proc double(x: int): int = x * 2

let num = 5

powerAssert(isEven(double(num)))
```

### コレクション操作

```nim
let numbers = @[1, 2, 3, 4, 5]
let sum = numbers.foldl(a + b, 0)
let product = numbers.foldl(a * b, 1)

powerAssert(sum == 15)
powerAssert(product == 120)
powerAssert(numbers.filter(proc (x: int): bool = x mod 2 == 0).len == 3)  # 偶数の数が予想と異なる場合に失敗
```

## よくある問題と解決策

### 問題: マクロ展開の問題

**問題**: `Error: cannot evaluate at compile time`というエラーが表示される。

**解決策**: マクロが実行時の値を必要とするコードを評価しようとしている可能性があります。式を簡略化するか、実行時評価を行うコード部分を分離してください。

```nim
# 問題のあるコード
powerAssert(complexRuntimeFunction() > 0)

# 解決策
let result = complexRuntimeFunction()
powerAssert(result > 0)
```

### 問題: カスタム型の表示が適切でない

**問題**: カスタム型のオブジェクトが「<CustomType>」のように表示される。

**解決策**: 適切な`$`演算子を実装してください：

```nim
type MyType = object
  value: int

# この実装がないと、型名のみが表示される
proc `$`(t: MyType): string =
  return "MyType(value: " & $t.value & ")"
```

### 問題: 循環参照を含む複雑なデータ構造

**問題**: 循環参照を含むデータ構造の表示中にスタックオーバーフローが発生する。

**解決策**: 循環参照を処理できる`$`演算子の実装を提供するか、表示用の簡略化された表現を使用してください：

```nim
type
  Node = ref object
    value: int
    next: Node

proc toSafeString(n: Node, depth: int = 0): string =
  if n == nil:
    return "nil"
  if depth > 3:  # 深さ制限
    return "..."
  
  result = "Node(value: " & $n.value
  if n.next != nil:
    result &= ", next: " & toSafeString(n.next, depth + 1)
  result &= ")"

proc `$`(n: Node): string =
  return toSafeString(n)
```

### 問題: 非同期コード内でのアサーション

**問題**: 非同期コード内でのアサーションが機能しない。

**解決策**: 現時点では、結果が利用可能になった後に明示的にアサーションを実行してください：

```nim
import asyncdispatch

proc asyncOperation(): Future[int] {.async.} =
  return 42

proc testAsync() {.async.} =
  let result = await asyncOperation()
  # 非同期操作の結果が得られた後にアサーションを実行
  powerAssert(result == 42)

waitFor testAsync()
```