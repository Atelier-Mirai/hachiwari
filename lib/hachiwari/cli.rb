# frozen_string_literal: true

require "thor"
require_relative "status_runner"

module Hachiwari
  # Thor を利用したコマンドラインインターフェイスのエントリポイント
  class CLI < Thor
    # `thor` の初期化時にステータス処理担当のランナーを準備
    def initialize(*args, **kwargs)
      super
      @runner = StatusRunner.new
    end

    desc "status [wins] [losses] [target] [language]", <<~DESC.strip
      Displays winning percentage and number of wins to achieve the goal. (with save status)
    DESC
    # 勝敗・目標勝率・言語を受け取り、状態を保存しながら結果を表示
    def status(*args)
      wins, losses, target, language = args
      run_status(save: true, wins: wins, losses: losses, target: target, language: language)
    end

    desc "s   [wins] [losses] [target] [language]", "Another name for the status command."
    def s(...)
      status(...)
    end

    desc "info [wins] [losses] [target] [language]", <<~DESC.strip
      Displays winning percentage and number of wins to achieve the goal. (Information only)
    DESC
    # 状態を保存せず試算だけ行うコマンド
    def info(*args)
      wins, losses, target, language = args
      run_status(save: false, wins: wins, losses: losses, target: target, language: language)
    end

    desc "i   [wins] [losses] [target] [language]", "Another name for the info command."
    def i(...)
      info(...)
    end

    desc "version", "Displays the version number."
    def version
      puts Hachiwari::VERSION
    end

    desc "calculate [wins] [losses]", "Prints the winning percentage without reading or writing state."
    option :target, type: :numeric, desc: "Target percentage"
    option :language, type: :string, desc: "Display language (ja or en)"
    # `status`/`info` とは別に、オプション経由でパラメータを受け取って計算のみ行う
    def calculate(wins, losses)
      runner.call(
        {
          wins: wins,
          losses: losses,
          target: options[:target],
          language: options[:language]
        }.compact,
        save: false
      )
    end

    private

    attr_reader :runner

    # `StatusRunner` へ依頼し、不要な nil を除いて保存フラグ付きで実行
    def run_status(save:, **params)
      runner.call(params.compact, save: save)
    end
  end
end
