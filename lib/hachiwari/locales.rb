# frozen_string_literal: true

require "yaml"

module Hachiwari
  # 自前の軽量ローカライゼーションローダー
  module Locales
    module_function

    def load(locale)
      cache[locale.to_sym] ||= begin
        path = locale_path(locale)
        raise KeyError, "Unknown locale: #{locale}" unless path

        data = YAML.safe_load(File.read(path), aliases: true, symbolize_names: true)
        data.fetch(locale.to_sym)
      rescue Errno::ENOENT
        raise KeyError, "Missing locale file: #{locale}"
      end
    end

    def t(locale, *keys)
      keys.reduce(load(locale)) do |current, key|
        current.fetch(key.to_sym)
      end
    end

    def available_locales
      locale_files.keys
    end

    def clear_cache
      cache.clear
    end

    def cache
      @cache ||= {}
    end

    def locale_path(locale)
      locale_files[locale.to_sym]
    end

    def locale_files
      @locale_files ||= Dir[File.expand_path("../../config/locales/*.yml", __dir__)].each_with_object({}) do |path, hash|
        name = File.basename(path, ".yml").to_sym
        hash[name] = path
      end
    end
  end
end
