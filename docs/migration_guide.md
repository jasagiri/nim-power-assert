# 標準アサーションから PowerAssert への移行ガイド

このガイドでは、Nim の標準アサーション（`assert`、`doAssert`、`check`）から PowerAssert ライブラリへの移行方法について説明します。

## 概要

PowerAssert は Nim の標準アサーションを強化し、テスト失敗時により詳細な情報を提供します。標準アサーションと互換性があるため、移行は簡単です。

## 移行の利点

1. **詳細なエラーメッセージ**: アサーション失敗時に式の各部分の値が表示されます
2. **視覚的な出力**: 式の構造と各部分の評価結果が視覚的に表示されます
3. **テスト効率の向上**: 失敗原因の特定が容易になります
4. **互換性**: 既存のコードと互換性があり、最小限の変更で移行できます

## 基本的な移行手順

### 1. ライブラリのインストール

```bash
nimble install power_assert
```

### 2. モジュールのインポート

```nim
import power_assert
```

これだけで、標準の `assert` と `doAssert` は自動的に PowerAssert の機能に置き換えられます。

### 3. unittest モジュールとの統合

標準の unittest モジュールと統合する場合：

```nim
import unittest except check  # 標準の check を除外
import power_assert
```

これにより、`check` マクロが PowerAssert の強化された機能に置き換えられます。

## 移行例

### 標準アサーションの例

```nim
# 移行前
import unittest

test "simple test":
  let x = 5
  let y = 7
  assert x + y == 15  # 失敗時の情報が限られる
  check x < y         # 失敗時の情報が限られる
```

### PowerAssert への移行

```nim
# 移行後
import unittest except check
import power_assert

test "simple test":
  let x = 5
  let y = 7
  assert x + y == 15  # 詳細なエラーメッセージを表示
  check x < y         # 詳細なエラーメッセージを表示
```

## 既存コードへの段階的な移行

大規模なプロジェクトでは、一度にすべてのコードを移行するのではなく、段階的に移行することをお勧めします。

### 部分的な移行（ファイルごと）

特定のテストファイルだけを移行する場合：

```nim
# このファイルだけ PowerAssert を使用
import unittest except check
import power_assert

# テストコード...
```

### 混在させる（明示的なAPIの使用）

標準アサーションと PowerAssert を混在させる場合：

```nim
import unittest  # 標準の unittest をそのまま使用

# PowerAssert を明示的に使用
import power_assert

test "mixed assertions":
  let x = 5
  let y = 7
  
  # 標準のアサーション
  assert(x > 0)
  check(y > 0)
  
  # PowerAssert の明示的な使用
  powerAssert(x + y == 15)
  powerCheck(x < y)
```

## 注意事項

### パフォーマンスへの影響

PowerAssert はエラーメッセージ生成のために、標準アサーションよりも多少のオーバーヘッドがあります。しかし、以下の点に注意してください：

1. このオーバーヘッドはアサーションが失敗した場合にのみ重要になります
2. テスト環境では、詳細な情報の価値がオーバーヘッドを上回ることが多い
3. パフォーマンスクリティカルなコードでは、リリースビルドでアサーションを無効にするのが一般的です

### マクロの制限

PowerAssert はマクロを使用しているため、一部の非常に複雑な式では正確に解析できない場合があります。そのような場合は、式をより小さな部分に分割することを検討してください。

```nim
# 複雑すぎる式（解析が難しい場合がある）
powerAssert(complexFunction(a + b) * (c - d) / e.someProperty == expectedValue)

# より扱いやすい形に分割
let intermediate = complexFunction(a + b) * (c - d) / e.someProperty
powerAssert(intermediate == expectedValue)
```

## コンパイルフラグ

PowerAssert は標準の Nim アサーション制御フラグと互換性があります：

- `-d:release`: すべてのアサーションを無効にします（パフォーマンス向上のため）
- `-d:danger`: より厳しい最適化でアサーションを無効にします

## よくある質問

### Q: PowerAssert を使うとコンパイル時間が長くなりますか？

A: マクロ処理のため若干の増加はありますが、通常は無視できるレベルです。大量のアサーションを含む非常に大きなプロジェクトでのみ顕著になる可能性があります。

### Q: リリースビルドでも詳細なエラーメッセージを保持できますか？

A: はい、カスタムコンパイルフラグを定義することで可能です：

```nim
when not defined(noAssertions) and not defined(release) and not defined(danger):
  # PowerAssert の実装
else:
  # 簡略化された実装
```

### Q: カスタムテストフレームワークと併用できますか？

A: はい、PowerAssert の基本機能はどのようなテストフレームワークからでも使用できます。ただし、特定のフレームワーク向けの統合コードが必要な場合があります。