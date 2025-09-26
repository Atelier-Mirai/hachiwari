# frozen_string_literal: true

require_relative "results"
require_relative "status_calculator"
require_relative "status_presenter"
require_relative "storage"

# 状態の読み書き・計算・表示を束ねる調停役
module Hachiwari
  class StatusRunner
    # 依存するコンポーネントを DI で受け取り、テストしやすくする
    def initialize(storage: Storage.new, calculator: StatusCalculator.new, presenter: StatusPresenter.new)
      @storage = storage
      @calculator = calculator
      @presenter = presenter
    end

    # 引数から `Results` を生成し、保存フラグに応じて永続化と表示を行う
    def call(input, save:)
      data = normalize_input(input)
      base = storage.load
      results = merge_results(base, data)
      storage.save(results) if save
      presenter.render(results, formatted_data(results))
      results
    end

    private

    attr_reader :storage, :calculator, :presenter

    # 受け取った Hash のキーをシンボル化して扱いやすくする
    def normalize_input(input)
      input.transform_keys { |key| key.to_sym rescue key } # rubocop:disable Style/RescueModifier
    end

    # 既存結果と入力値をマージして新しい `Results` を生成
    def merge_results(base, input)
      Results.new(
        resolve_integer(input[:wins], base.wins),
        resolve_integer(input[:losses], base.losses),
        resolve_integer(input[:target], base.target),
        resolve_language(input[:language], base.language)
      )
    end

    # 数値系入力の正規化（空入力は既存値を維持）
    def resolve_integer(value, fallback)
      return fallback if value.nil?

      string = value.to_s.strip
      return fallback if string.empty?

      string.to_i
    end

    # 言語指定の正規化（空入力は既存値を維持）
    def resolve_language(value, fallback)
      return fallback if value.nil?

      string = value.to_s.strip
      return fallback if string.empty?

      string.to_sym
    end

    # 表示用の Hash を生成し、プレゼンターへ渡す
    def formatted_data(results)
      {
        total: calculator.total_games(results),
        wins: results.wins,
        losses: results.losses,
        percentage: calculator.winning_percentage(results),
        needed: calculator.required_wins(results),
        target: results.target.to_i
      }
    end
  end
end
