# frozen_string_literal: true

require "yaml/store"
require "fileutils"
require_relative "results"

module Hachiwari
  # `YAML::Store` を使った永続化層。勝率データの読み書きを担う
  class Storage
    DEFAULT_PATH = ENV.fetch("HACHIWARI_STORE_PATH", File.join(Dir.home, ".hachiwari"))
    PERMITTED_SYMBOLS = %i[wins losses target language results ja en].freeze

    # パスを差し替え可能にしてテストしやすくする
    def initialize(path = DEFAULT_PATH)
      @path = path
    end

    # 保存された結果を `Results` に変換して返却
    def load
      migrate_legacy_if_needed
      data = load_raw
      data ||= load_legacy
      coerce(data)
    end

    # 与えられた結果を YAML に書き出す
    def save(results)
      migrate_legacy_if_needed
      store.transaction { store[:results] = results.to_h }
    end

    # 保存済みデータを削除
    def clear
      existed = File.exist?(path)
      FileUtils.rm_f(path)
      @store = nil
      existed
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

    def load_legacy
      return unless File.exist?(path)

      content = File.read(path)
      sanitized = sanitize_legacy_yaml(content)

      data = Psych.safe_load(
        sanitized,
        permitted_classes: [Hachiwari::Results, Symbol],
        permitted_symbols: PERMITTED_SYMBOLS,
        aliases: true,
        symbolize_names: true
      )
      extract_results_data(data)
    rescue Psych::Exception, Errno::ENOENT
      nil
    end

    # `safe_load` で得た構造から結果部分を抽出
    def extract_results_data(data)
      return unless data

      object = data[:results] || data["results"] || data
      case object
      when Hash, Hachiwari::Results
        object
      else
        legacy_struct_to_hash(object)
      end
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
    def legacy_struct_to_hash(object)
      return object.to_h if object.respond_to?(:to_h)

      if object.respond_to?(:members) && object.respond_to?(:[]) # Struct 互換
        object.members.each_with_object({}) do |member, hash|
          hash[member.to_sym] = object[member]
        end
      else
        nil
      end
    end

    def normalize_results_hash(data)
      case data
      when Hachiwari::Results
        data.to_h
      when Hash
        data.transform_keys { |key| key.to_sym rescue key }
      else
        legacy_struct_to_hash(data) || {}
      end
    end

    def sanitize_legacy_yaml(content)
      return content unless content

      patterns = [
        %r{!ruby/struct:Hachiwari::CLI::Results},
        %r{!ruby/object:Hachiwari::CLI::Results},
        %r{!ruby/struct:Hachiwari::Results},
        %r{!ruby/object:Hachiwari::Results}
      ]

      patterns.reduce(content) { |text, pattern| text.gsub(pattern, "") }
    end

    def migrate_legacy_if_needed
      return unless File.exist?(path)

      content = File.read(path)
      return unless legacy_yaml?(content)

      sanitized = sanitize_legacy_yaml(content)
      data = Psych.safe_load(
        sanitized,
        permitted_classes: [Hachiwari::Results, Symbol],
        permitted_symbols: PERMITTED_SYMBOLS,
        aliases: true,
        symbolize_names: true
      )

      results_hash = extract_results_data(data)
      return unless results_hash && !results_hash.empty?

      normalized = normalize_results_hash(results_hash)
      FileUtils.rm_f(path)
      yaml_store = YAML::Store.new(path)
      yaml_store.transaction { yaml_store[:results] = normalized }
      @store = nil
    rescue Psych::Exception
      # 破損データは削除してデフォルトに戻す
      clear
    end

    def legacy_yaml?(content)
      return false unless content

      content.include?("Hachiwari::CLI::Results") || content.include?("Hachiwari::Results")
    end

    def default_results
      Hachiwari::Results.new(0, 0, 80, :ja)
    end
  end
end
