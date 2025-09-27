# Release Notes — `hachiwari` 1.0.0 (2025-09-27)

## Highlights
- `hachiwari clear` コマンドで保存済みの対局成績を手軽に削除できます。
- `status --trial` によって保存を伴わない試算が簡単に行えます。`info` / `i` / `calculate` / `s` は非推奨となり、内部で `status` 系へ統一されました。
- ローカライズ可能なヘルプを導入し、日本語・英語に加えてスペイン語・フランス語・ドイツ語へ自動切り替えできます。

## Added
- `hachiwari clear` コマンドを追加して保存済みデータの削除を自動化。
- `hachiwari status --trial` オプションで、保存せずに勝率計算を実行。
- コマンド名を省略した場合でも `status` を自動起動。
- 目標勝率を下回るまでの許容敗北数を提示し、現在の余裕度を可視化。
- `config/locales/*.yml` を参照してヘルプ文言をローカライズし、`ja` / `en` / `es` / `fr` / `de` をサポート。

## Changed
- 対応 Ruby を `>= 3.3.0` へ更新し、最新環境での安定動作を保証。
- `bundle update` により開発用依存関係を刷新。
- CLI を `StatusRunner` / `StatusCalculator` / `StatusPresenter` / `Storage` の各コンポーネントへ分離し責務を整理。
- 実行ファイルを `bin/` 配下へ集約し、不要スクリプト (`bin/setup`, `bin/console`) を削除。
- `info` / `i` / `calculate` / `s` コマンドを非推奨化し、利用時に警告を表示して `status` 系処理へ誘導。

## Fixed
- アンインストールフックを追加し、gem 削除時に保存ファイルを自動クリア。

## Documentation
- `README.md`（日本語）を更新し、`README.en.md`（英語版）を追加。
- `LICENSE` に日本語訳を補足。
- `test/hachiwari_test.rb` にコメントと追加テストを導入し、挙動と境界ケースを文書化。
- `lib/` 配下の主要クラスへ説明コメントを拡充し、アーキテクチャを明文化。

## Upgrade Notes
- Ruby 3.3 以降が必須です。環境の Ruby を更新してからアップグレードしてください。
- 非推奨コマンド (`info`, `i`, `calculate`, `s`) は今後削除予定です。`status` / `status --trial` への移行を推奨します。
- ヘルプ文言は `config/locales/` 配下の YAML を編集することでカスタマイズ可能です。

## Test Summary
- `bundle exec rake`（テストスイートと RuboCop を実行）
