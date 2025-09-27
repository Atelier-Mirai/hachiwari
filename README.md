# 八割 Hachiwari

Hachiwari は、「目指す勝率 80%（＝八割）」という合言葉から生まれた勝率サポートツールです。
日々の対局成績を入力するだけで、目標勝率に届くまでにあと何勝必要なのかをすぐに教えてくれます。

For translations, see [README.en.md](README.en.md) / [README.es.md](README.es.md) / [README.fr.md](README.fr.md) / [README.de.md](README.de.md).

## インストール方法

以下のコマンドを実行して、インストールしてください。

```
% gem install hachiwari
```

## 使い方

## 目標勝率を達成するために必要な勝ち数・敗数を表示する (自動保存機能付)

```zsh
% hachiwari [status] [wins] [losses] [target] [language]
```

`status` は省略可能で、引数のみを渡しても同じ結果が得られます。
(``` s ``` コマンドは廃止予定です。利用すると警告が表示され、内部で `status` が実行されます。)

四つの引数、勝ち数、負け数、目標勝率、表示言語があります。すべての引数は省略可能です。

* 引数がないとき、既定値もしくは保存されたデータを元に、現在の対局成績を表示します。
  既定値は、勝ち数：０、負け数：０、勝率：八割、表示言語：日本語です。
  目標勝率を既に上回っている場合は、勝率が閾値を下回るまでに許容される敗北数も表示されます。
* 一つ目の引数として勝ち数が与えられると、それに基づく必要勝ち数を表示します。
  残りの引数は、既定値もしくは保存されたデータを用います。
* 負け数を与えたい場合・更新したい場合には、二番目の引数として、status コマンドを実行してください。
* 表示言語を変更したい場合には、四番目の引数として与えてください。既定値は日本語 `ja` です。英語への切り替えは `en`、スペイン語は `es`、フランス語は `fr`、ドイツ語は `de` を指定してください。
* 与えられた引数は、自動で保存される為、勝ち数のみが増えた場合、残りの引数の入力は不要です。

## Hachiwari のバージョンを表示する

```zsh
% hachiwari version
```

Hachiwari のバージョンを表示します。

## 保存済みの対局成績を削除する

```zsh
% hachiwari clear
```

保存されている `.hachiwari` ファイルを削除します。データが存在しない場合は警告のみが表示されます。

## コマンド一覧や詳細を表示する


```zsh
% hachiwari --help
% hachiwari status --help
```

`hachiwari --help` で利用可能なコマンドの一覧、あるいは特定コマンドの詳細ヘルプを表示します。

## 非推奨コマンドについて

以下のコマンド／エイリアスは非推奨です。実行すると警告が表示され、後方互換の動作にフォールバックします。

- `s`
  - `status` のエイリアスでしたが、非推奨です。
  - 実行すると警告を表示し、内部的に `status` を実行します（`hachiwari [status] ...` の利用を推奨）。
- `info` / `i`
  - 保存せずに試算のみを行うためのコマンドでしたが、非推奨です。
  - 実行すると警告を表示し、`status --trial` と同等の動作になります。
- `calculate`
  - オプション指定で計算のみを行うためのコマンドでしたが、非推奨です。
  - 実行すると警告を表示し、`status --trial` と同等の動作になります（`--target`/`--language` は引き続き利用可能）。


## 開発

リポジトリをクローンしたら、以下のコマンドで開発環境を整えてください。

```zsh
bundle install
bundle exec rake test
```

 - **依存関係のインストール**: `bundle install`
 - **テストの実行**: `bundle exec rake test`
 - **CLI の手動確認**: `bundle exec ruby -Ilib bin/hachiwari --help`

この gem をローカルにインストールするには、`bundle exec rake install` を実行します。

新しいバージョンをリリースする手順:

1. `lib/hachiwari/version.rb` の `VERSION` を更新する
2. 変更をコミットしてリモートへプッシュする
3. `bundle exec rake release` を実行する

`rake release` は、更新したバージョンで git タグを作成し、コミットとタグを push し、生成された `.gem` を [rubygems.org](https://rubygems.org) に公開します（RubyGems への公開には MFA 設定が必要です）。

## 貢献

 バグレポートやプルリクエストは、[GitHub](https://github.com/Atelier-Mirai/hachiwari)で受け付けています。

## ライセンス

このgemは、[MIT License](https://opensource.org/licenses/MIT)の条件でオープンソースとして提供されています。詳しくは [LICENSE](./LICENSE) を参照してください。
