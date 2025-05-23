# PowerAssert 内部実装の詳細

このドキュメントは、PowerAssert for Nim ライブラリの内部実装について詳細に解説します。

## 概要

PowerAssert ライブラリは、Nim のマクロシステムを利用して、テスト中の assertion の失敗時に詳細な情報を提供します。標準の `assert` や `check` よりも豊富な情報を表示することで、テストのデバッグを容易にします。

## 主要なコンポーネント

### 1. データ構造

```nim
type
  PowerAssertDefect* = object of AssertionDefect

  ExpressionInfo* = object
    ## Expression evaluation information
    code*: string    # 式のコード表現
    value*: string   # 評価された値の文字列表現
    typeName*: string # 値の型名
    column*: int     # 式の列位置（視覚表示に使用）
```

- `PowerAssertDefect`: 標準の `AssertionDefect` を拡張した例外型
- `ExpressionInfo`: 式の評価情報を保持する構造体

### 2. 値のフォーマット機能

`formatValue` プロシージャは、様々な型の値を読みやすい文字列に変換します:

```nim
proc formatValue*[T](val: T): string
```

このプロシージャは以下の型に対応しています:
- 文字列 (`string`)
- 文字 (`char`)
- ブール値 (`bool`)
- 列挙型 (`enum`)
- 整数 (`SomeInteger`)
- 浮動小数点数 (`SomeFloat`)
- シーケンス (`seq`)
- 配列 (`array`)
- `$` 演算子をサポートする任意の型
- その他の型（型名のみ表示）

### 3. 式の視覚化

`renderExpression` プロシージャは、式とその評価結果を視覚的に表示します:

```nim
proc renderExpression*(exprStr: string, values: seq[ExpressionInfo]): string
```

このプロシージャは:
1. 列ごとに評価情報をグループ化
2. 順番に表示
3. 複合式の情報を追加表示

### 4. マクロの実装

#### powerAssertImpl マクロ（内部実装）

```nim
macro powerAssertImpl*(condition: untyped): untyped
```

このマクロは:
1. 条件式の AST（抽象構文木）を分析
2. 式の各部分とその評価値を抽出
3. 失敗時に詳細なエラーメッセージを生成するコードを生成

AST 分析プロセス:
```nim
proc processNode(node: NimNode) =
  if node.kind in {nnkIdent, nnkIntLit, nnkFloatLit, nnkStrLit, 
                   nnkCharLit, nnkNilLit} or 
     (node.kind == nnkSym and node.symKind in {nskConst, nskVar, nskLet, nskParam}):
    # リーフノード（リテラルまたは識別子）の処理
    let code = node.repr
    let column = 0  # 簡略化された列処理
    infos.add((code, column))
    values.add(node)
  else:
    # 複合ノードを再帰的に処理
    for i in 0 ..< node.len:
      processNode(node[i])
```

#### powerAssert マクロ（メインインターフェース）

```nim
macro powerAssert*(condition: untyped, message: string = ""): untyped
```

このマクロは:
1. 条件を評価
2. 失敗した場合は詳細なエラーメッセージを生成
3. オプションのカスタムメッセージをサポート

### 5. 互換性のあるテンプレート

標準ライブラリとの互換性のために以下のテンプレートが提供されています:

```nim
template assert*(cond: untyped, msg: string = "") {.dirty.}
template doAssert*(cond: untyped, msg: string = "") {.dirty.}
template powerCheck*(condition: untyped, message: string = "") {.dirty.}
template require*(condition: untyped, message: string = "") {.dirty.}
template check*(condition: untyped): untyped
```

また、期待されるエラーをテストするためのユーティリティも含まれています:

```nim
template expectError*(errorType: typedesc, code: untyped)
```

## 動作フロー

1. ユーザーが `powerAssert(x + y == 15)` のような assertion を記述
2. コンパイル時に、マクロがこの式を分析し、各部分の値を取得するためのコードを生成
3. 実行時に:
   - 条件が `true` なら何も起きない
   - 条件が `false` なら:
     1. 式の各部分の値を収集
     2. 視覚的な表示を生成
     3. `PowerAssertDefect` 例外を発生させる

## エラーメッセージの例

assertion `x + y == 15` が失敗した場合（x=5, y=7）:

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

## 拡張と制限

### 対応している機能:
- 基本型（整数、浮動小数点数、文字列など）
- コレクション型（シーケンス、配列）
- カスタム型（`$` 演算子を実装している場合）
- 複合式と演算子
- 関数呼び出し

### 制限:
- 複雑な式の列位置計算は簡略化されている
- マクロの性質上、一部の複雑な式は正確に解析できない場合がある

## 単体テストでの使用

PowerAssert は標準の unittest モジュールと統合して使用できます:

```nim
import unittest except check
import power_assert

test "powerful assertions":
  let x = 10
  let y = 5
  check(x + y == 15)  # PowerAssert 機能を使用
```

このように、PowerAssert for Nim は強力なマクロ機能を活用して、テストをより効果的に行うためのツールを提供しています。