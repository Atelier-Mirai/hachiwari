# frozen_string_literal: true

require "yaml/store"
require_relative "results"

module Hachiwari
  # `YAML::Store` を使った永続化層。勝率データの読み書きを担う
  class Storage
    DEFAULT_PATH = ENV.fetch("HACHIWARI_STORE_PATH", File.join(Dir.home, ".hachiwari"))

    # パスを差し替え可能にしてテストしやすくする
    def initialize(path = DEFAULT_PATH)
      @path = path
    end

    # 保存された結果を `Results` に変換して返却
    def load
      coerce(load_raw)
    end

    # 与えられた結果を YAML に書き出す
    def save(results)
      store.transaction { store[:results] = results.to_h }
    end

    private

    attr_reader :path

    # 遅延初期化した `YAML::Store` を返す
    def store
      @store ||= YAML::Store.new(path)
    end

    # Store から Hash を読み込む。安全な読み込みに失敗した場合はレガシーデータを試みる
    def load_raw
      store.transaction(true) { store[:results] }
    rescue Psych::DisallowedClass
      load_legacy
    rescue Psych::Exception
      nil
    end

    # 古い YAML 形式から安全にデータを復元
    def load_legacy
      return unless File.exist?(path)

      data = Psych.safe_load(
        File.read(path),
        permitted_classes: [Hachiwari::Results],
        permitted_symbols: %i[wins losses target language results],
        aliases: true
      )
      extract_results_data(data)
    rescue Psych::Exception, Errno::ENOENT
      nil
    end

    # `safe_load` で得た構造から結果部分を抽出
    def extract_results_data(data)
      return unless data

      data[:results] || data["results"] || data
    end

    # 各種形式を `Results` に変換
    def coerce(data)
      case data
      when Hachiwari::Results
        data
      when Hash
        hash_to_results(data)
      else
        default_results
      end
    end

    # Hash を想定した構造へ落とし込む
    def hash_to_results(data)
      Hachiwari::Results.new(
        integer_value(data, :wins, 0),
        integer_value(data, :losses, 0),
        integer_value(data, :target, 80),
        symbol_value(data, :language, :ja)
      )
    end

    # 数値項目を安全に取得
    def integer_value(data, key, fallback)
      value = data[key] || data[key.to_s]
      value ? value.to_i : fallback
    end

    # 言語項目をシンボルとして取得
    def symbol_value(data, key, fallback)
      value = data[key] || data[key.to_s]
      value ? value.to_sym : fallback
    end

    # デフォルト値を表す結果
    def default_results
      Hachiwari::Results.new(0, 0, 80, :ja)
    end
  end
end
