# PowerAssert for Nim コントリビュータガイドライン

PowerAssert for Nim プロジェクトへの貢献に興味をお持ちいただき、ありがとうございます。このドキュメントでは、プロジェクトに貢献するための方法と、守るべきガイドラインを説明します。

## 行動規範

このプロジェクトに参加するすべての貢献者は、オープンで友好的な環境を維持するために、以下の行動規範を守ることが期待されます：

- 他の貢献者に対して敬意を持ち、協力的に接すること
- 建設的な批評を受け入れ、提供すること
- プロジェクトの目標と方向性を尊重すること
- 技術的な議論に焦点を当て、個人的な批判を避けること
- 多様性を尊重し、包括的な言語を使用すること

## はじめ方

### 開発環境のセットアップ

1. リポジトリをフォークし、ローカルにクローンします：
   ```bash
   git clone https://github.com/yourusername/power_assert_nim.git
   cd power_assert_nim
   ```

2. 依存関係をインストールします：
   ```bash
   nimble install
   ```

3. テストを実行して、すべてが正常に動作することを確認します：
   ```bash
   nimble test
   ```

### ブランチ戦略

- `main` ブランチは常に安定した最新リリースを反映しています
- 開発は `develop` ブランチまたは機能固有のブランチで行われます
- 新機能やバグ修正のための作業は、`feature/your-feature-name` または `fix/issue-number` のような命名規則のブランチで行ってください

## 貢献の種類

### バグ報告

バグを報告する場合は、GitHub の Issue トラッカーを使用し、以下の情報を含めてください：

1. バグの簡潔な説明
2. 再現手順（可能であればコード例を含む）
3. 期待される動作と実際の動作
4. Nim と PowerAssert のバージョン情報
5. その他の関連情報（OS、コンパイラフラグなど）

### 機能リクエスト

新機能を提案する場合は、GitHub の Issue トラッカーを使用し、以下の情報を含めてください：

1. 提案する機能の明確な説明
2. なぜその機能が有用か、またはどのような問題を解決するかの説明
3. 可能であれば、実装の提案やコード例

### コード貢献

コードの変更を提案する場合は、以下の手順に従ってください：

1. 最新の `develop` ブランチから新しいブランチを作成します
2. 変更を実装し、コミットします
3. すべてのテストが通過することを確認します
4. プルリクエストを作成します

## コーディング規約

### 一般的なガイドライン

- Nim 標準のスタイルガイドに従ってください
- スペースのインデントを使用し、インデントは 2 スペースとします
- 行の長さは 80 文字以内に収めるよう努めてください
- 関数、型、変数には明確で説明的な名前を使用してください
- コードには適切なコメントを追加してください

### ドキュメント

- 新しい機能や重要な変更にはドキュメントを追加してください
- 公開 API には NimDoc 形式のドキュメントコメントを追加してください
- 複雑なロジックや非自明なコードにはインラインコメントを追加してください

### テスト

- すべての新機能とバグ修正にはテストを追加してください
- テストは `tests` ディレクトリに配置し、適切なカテゴリに整理してください
- テストは明確で理解しやすく、期待される動作を示すものであるべきです
- テストは自動化され、再現可能であるべきです

## プルリクエスト（PR）プロセス

1. **PR の作成**：変更が完了したら、`develop` ブランチに対してプルリクエストを作成します
2. **PR の説明**：以下を含む明確な説明を提供してください：
   - 変更の概要
   - 解決する問題や追加する機能
   - テスト方法
   - 関連する Issue（ある場合）
3. **レビュー**：PR はプロジェクトのメンテナによってレビューされます
4. **変更の要求**：レビュー中に変更や改善が要求される場合があります
5. **マージ**：承認されたらメンテナによってマージされます

## リリースプロセス

PowerAssert for Nim は以下のリリースプロセスに従います：

1. 開発は `develop` ブランチで行われます
2. 機能が安定し、すべてのテストが通過したら、リリース候補が作成されます
3. リリース候補の安定性が確認されたら、`main` ブランチにマージされます
4. タグ付けされて新しいバージョンがリリースされます

リリースは [セマンティックバージョニング](https://semver.org/) に従います：
- **パッチバージョン**（0.0.X）：後方互換性のあるバグ修正
- **マイナーバージョン**（0.X.0）：後方互換性のある機能追加
- **メジャーバージョン**（X.0.0）：後方互換性を破る変更

## コミュニケーション

プロジェクトに関する質問や議論は、以下のチャネルで行うことができます：

- GitHub Issues：バグ報告、機能リクエスト、具体的な問題
- Pull Requests：コードレビューと具体的な変更に関する議論
- GitHub Discussions：一般的な質問や議論

## ドキュメント貢献

コード以外にも、ドキュメントの改善は非常に価値のある貢献です：

- ユーザーガイドの拡充
- チュートリアルやサンプルの追加
- API ドキュメントの改善
- よくある質問（FAQ）の追加

## 貢献の認識

すべての貢献者は CONTRIBUTORS.md ファイルに記載され、その貢献が認識されます。また、重要な貢献をした方は AUTHORS ファイルに追加されることがあります。

## パフォーマンス考慮事項

PowerAssert for Nim はパフォーマンスに敏感なライブラリです。変更を提案する際は、以下の点を考慮してください：

- コンパイル時間への影響
- 実行時のオーバーヘッド
- メモリ使用量
- リリースビルドでの最適化

## テクニカルデザイン

新機能や大きな変更を提案する場合は、実装前にテクニカルデザインドキュメントを作成することをお勧めします。これには以下を含めるべきです：

1. 提案する変更の概要
2. 設計上の決定と根拠
3. 影響を受ける既存のコード
4. 実装計画
5. テスト戦略

## ヘルプとサポート

貢献に関して質問や支援が必要な場合は、躊躇せずに以下の方法で連絡してください：

- GitHub Issues で質問する
- プロジェクトのメンテナに直接連絡する
- コミュニティの議論に参加する

## 最後に

PowerAssert for Nim への貢献を検討していただき、ありがとうございます。皆様の貢献によって、このプロジェクトはより良くなります。質問や提案がある場合は、お気軽にお問い合わせください。