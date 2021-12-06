# 八割 Hachiwari

Hachiwari は、八割に由来します。
ご自身の目指す勝率（＝既定値八割）を達成するために必要な勝ち数を表示する gem です。

Hachiwari is derived from the word "80%".
It is a gem that shows you the number of wins you need to achieve your target win rate (i.e. the default of 80%).

## インストール方法 Installation

以下のコマンドを実行して、インストールしてください。
Install it yourself as:

```
% gem install hachiwari
```

## 使い方 Usage

## 目標勝率を達成するために必要な勝ち数を表示する

``` zsh
% hachiwari status [wins] [losses] [target] [language]
```

(``` status ``` コマンドの別名として、 ``` s ``` コマンドを用いることが出来ます。)

四つの引数、勝ち数、負け数、目標勝率、表示言語があります。すべての引数は省略可能です。

* 引数がないとき、既定値もしくは保存されたデータを元に、現在の対局成績を表示します。
  既定値は、勝ち数：０、負け数：０、勝率：八割、表示言語：日本語です。
* 一つ目の引数として勝ち数が与えられると、それに基づく必要勝ち数を表示します。
  残りの引数は、既定値もしくは保存されたデータを用います。
  与えられた勝ち数のデータは、ホームディレクトリの直下のファイル「.hachiwari」に自動的に保存・更新されます。
* 負け数を与えたい場合・更新したい場合には、二番目の引数として、status コマンドを実行してください。
* 目標勝率を変更したい場合には、三番目の引数として下さい。九割の勝率を目指す場合には、90 と指定します。
* 表示言語を変更したい場合には、四番目の引数として与えてください。既定値は日本語 ja です。英語に変更したい場合には、en を指定してください。

## Hachiwari のバージョンを表示する

``` zsh
% hachiwari version
```

Hachiwari のバージョンを表示します。

## Display the number of wins needed to achieve the target win rate.

``` zsh
% hachiwari status [wins] [losses] [target] [language]
```

(The ``` s ``` command can also be used as an alias for ``` status ```).

There are four arguments: number of wins, number of losses, target win percentage, and display language. All arguments are optional.

* If there is no argument, the current game results are displayed based on default values or saved data.
  The default values are: wins: 0, losses: 0, win percentage: 80%, display language: Japanese.
* If the number of wins is given as the first argument, the required number of wins based on it will be displayed.
  The rest of the arguments are default values or saved data.
  The data of the number of wins given will be automatically saved and updated in the file ".hachiwari" directly under the home directory.
* If you want to give/update the number of losses, please execute the status command as the second argument.
* If you want to change the target winning percentage, make it the third argument. If you want to aim for a 90% win rate, specify 90.
* If you want to change the display language, give it as the fourth argument. The default language is Japanese ``` ja ```. If you want to change it to English, specify ``` en ```.

## Display the version of Hachiwari

``` zsh
% hachiwari version
```

Displays the version of Hachiwari.

## 開発 Development

repo をチェックアウトしたら、`bin/setup`を実行して、依存関係をインストールします。その後、`rake test` を実行してテストを実行します。また、`bin/console`を実行すると、インタラクティブなプロンプトが表示され、実験を行うことができます。

このgemをローカルマシンにインストールするには、`bundle exec rake install`を実行します。新しいバージョンをリリースするには、`version.rb` のバージョン番号を更新してから、`bundle exec rake release` を実行すると、そのバージョンの git タグが作成され、git commits と作成されたタグがプッシュされ、`.gem` ファイルが [rubygems.org](https://rubygems.org) にプッシュされます。

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## 貢献 Contributing

バグレポートやプルリクエストは、GitHub（https://github.com/Atelier-Mirai/hachiwari）で受け付けています。このプロジェクトは、共同作業のための安全で歓迎される空間であることを意図しており、貢献者は[行動規範](https://github.com/Atelier-Mirai/hachiwari/blob/master/CODE_OF_CONDUCT.md)を遵守することが期待されています。

Bug reports and pull requests are welcome on GitHub at https://github.com/Atelier-Mirai/hachiwari. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Atelier-Mirai/hachiwari/blob/master/CODE_OF_CONDUCT.md).

## ライセンス License

このgemは、[MIT License](https://opensource.org/licenses/MIT)の条件でオープンソースとして提供されています。

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 行動規範 Code of Conduct

Hachiwariプロジェクトのコードベース、イシュートラッカー、チャットルーム、メーリングリストで交流するすべての人は、[行動規範](https://github.com/Atelier-Mirai/hachiwari/blob/master/CODE_OF_CONDUCT.md)に従うことが求められます。

Everyone interacting in the Hachiwari project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hachiwari/blob/master/CODE_OF_CONDUCT.md).
