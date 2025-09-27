# frozen_string_literal: true

require "yaml"

module Hachiwari
  # 自前の軽量ローカライゼーションローダー
  module Locales
    module_function

    # 指定ロケールの翻訳データを YAML から読み込みキャッシュする
    def load(locale)
      cache[locale.to_sym] ||= begin
        path = locale_path(locale)
        raise KeyError, "Unknown locale: #{locale}" unless path

        data = YAML.safe_load_file(path, aliases: true, symbolize_names: true)
        data.fetch(locale.to_sym)
      rescue Errno::ENOENT
        raise KeyError, "Missing locale file: #{locale}"
      end
    end

    # ネストしたキーを辿って翻訳文字列を取得する
    def t(locale, *keys)
      keys.reduce(load(locale)) do |current, key|
        current.fetch(key.to_sym)
      end
    end

    # 利用可能なロケール一覧を返す
    def available_locales
      locale_files.keys
    end

    # 翻訳データのキャッシュをクリアする
    def clear_cache
      cache.clear
    end

    # ロケールごとのキャッシュを初期化または返却する
    def cache
      @cache ||= {}
    end

    # ロケールシンボルからファイルパスを取得する
    def locale_path(locale)
      locale_files[locale.to_sym]
    end

    # ロケールファイルを走査し、シンボルとパスの対応表を構築する
    def locale_files
      @locale_files ||= Dir[File.expand_path("../../config/locales/*.yml",
                                             __dir__)].each_with_object({}) do |path, hash|
        name = File.basename(path, ".yml").to_sym
        hash[name] = path
      end
    end
  end
end
