# PowerAssert for Nim ユーザーガイド

## 概要

PowerAssert for Nim は、Nim のテストをより効果的に行うためのアサーションライブラリです。標準の `assert` や `check` マクロを拡張し、アサーション失敗時に詳細で視覚的なエラーメッセージを提供します。これにより、テストのデバッグが容易になります。

## インストール

Nimble パッケージマネージャーを使用してインストールできます：

```bash
nimble install power_assert
```

または、プロジェクトの依存関係として `.nimble` ファイルに追加します：

```nim
requires "power_assert >= 0.1.0"
```

## 基本的な使用方法

### スタンドアロンでの使用

```nim
import power_assert

let x = 10
let y = 5

# 基本的なアサーション
powerAssert(x + y == 15)

# カスタムメッセージ付き
powerAssert(x > y, "x は y より大きくなければなりません")
```

### unittest モジュールとの統合

```nim
import unittest except check  # 標準の check を上書きするため except を使用
import power_assert

test "basic test":
  let x = 10
  let y = 5
  
  # PowerAssert の機能を使用した check
  check(x + y == 15)
```

## エラーメッセージの例

アサーションが失敗すると、PowerAssert は式の各部分を評価して視覚的に表示します。例えば：

```nim
let x = 5
let y = 7
powerAssert(x + y == 15)
```

このアサーションが失敗すると、以下のようなエラーメッセージが表示されます：

```
PowerAssert: Assertion failed

x + y == 15

^ 5 (int)
    ^ 7 (int)
      ^ 12 (int)
         ^ 15 (int)
         ^ false (bool)

# Composite expressions:
x + y = 12 (int)
```

このメッセージから、`x` の値が `5`、`y` の値が `7` であり、それらを足すと `12` になるため、`15` との等価チェックが `false` になっていることが一目でわかります。

## サポートされている機能

### 様々な型のサポート

PowerAssert は以下の型をサポートしています：

- 基本型 (int, float, string, bool, char)
- 列挙型 (enum)
- シーケンス (seq)
- 配列 (array)
- カスタム型 (toString / `$` 演算子をサポートするもの)

### 複合式のサポート

PowerAssert は複雑な式の評価もサポートしています：

```nim
let a = 5
let b = 7
let c = 9

powerAssert((a + b) * c == 108)
```

### 関数とメソッドの呼び出し

```nim
proc double(x: int): int = x * 2
proc isEven(x: int): bool = (x mod 2) == 0

let x = 5
let doubled = double(x)

powerAssert(isEven(doubled))
```

### コレクション操作

```nim
let numbers = @[1, 2, 3, 4, 5]

powerAssert(numbers.len == 5)
powerAssert(numbers[2] == 3)
powerAssert(3 in numbers)
```

## エラー処理のテスト

PowerAssert には、期待されるエラーをテストするための `expectError` テンプレートも含まれています：

```nim
# エラーを発生させるコードが ZeroDivisionDefect を起こすことを検証
expectError(ZeroDivisionDefect):
  let x = 1 div 0
```

## カスタム型の使用

カスタム型を PowerAssert で使用するには、その型に対する `$` 演算子を定義するか、`toString` メソッドを実装します：

```nim
type
  Person = object
    name: string
    age: int

# この文字列変換プロシージャは PowerAssert マクロによって
# エラーメッセージ表示時に暗黙的に使用されます
proc `$`(p: Person): string =
  result = p.name & " (" & $p.age & ")"

let person1 = Person(name: "Alice", age: 30)
let person2 = Person(name: "Bob", age: 25)

powerAssert(person1 == person2)  # 詳細なエラーメッセージが表示されます
```

## ベストプラクティス

1. **明確な表現を使用する**: PowerAssert は式の評価を視覚化しますが、複雑すぎる式は読みにくくなることがあります。

2. **カスタム型には `$` 演算子を実装する**: より読みやすいエラーメッセージのために、カスタム型に文字列変換機能を追加してください。

3. **unittest との統合時は `except check` を使用する**: PowerAssert の `check` を使用するには、標準の `check` を除外する必要があります。

4. **メッセージを追加する**: 複雑なアサーションには説明的なメッセージを追加すると、意図が明確になります。

## トラブルシューティング

### 複雑な式が正しく表示されない

非常に複雑な式や特定のマクロを含む式では、PowerAssert が正確に評価できないことがあります。そのような場合は、式をより小さな部分に分割してみてください。

### カスタム型の値が `<CustomType>` として表示される

カスタム型の値が型名だけで表示される場合は、その型に `$` 演算子が実装されていないか、コンパイル時に到達できない可能性があります。型に適切な文字列変換機能を追加してください。

### マクロ展開エラー

PowerAssert はマクロを使用しているため、一部の複雑なコードではコンパイル時エラーが発生することがあります。そのような場合は、より単純な式を使用するか、標準の `assert` にフォールバックしてください。

## さらなる情報

より詳細な情報やコード例については、以下のリソースを参照してください：

- [GitHub リポジトリ](https://github.com/username/power_assert_nim)
- [API ドキュメント](https://username.github.io/power_assert_nim/docs/api.html)
- [内部実装の詳細](/docs/implementation_details.md)