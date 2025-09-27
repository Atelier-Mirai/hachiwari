# frozen_string_literal: true

require "rubygems"

begin
  require_relative "hachiwari"
rescue LoadError
  warn "[hachiwari] Unable to load gem components for uninstall hook"
end

module Hachiwari
  module Hooks
    module_function

    # Rubygems のアンインストールフックへコールバックを登録する
    def register
      Gem.pre_uninstall(&method(:handle_pre_uninstall))
    end

    # 対象の gem をアンインストールする際に保存データを消去する
    def handle_pre_uninstall(uninstaller)
      return unless target_gem?(uninstaller)

      run_clear_command
    end

    # フック対象が `hachiwari` の gem かどうかを判定する
    def target_gem?(uninstaller)
      spec = uninstaller&.spec
      spec&.name == "hachiwari"
    end

    # CLI が利用可能なら `clear` を実行し、エラー時は警告を出す
    def run_clear_command
      unless defined?(Hachiwari::CLI)
        warn "[hachiwari] CLI is unavailable; skipping clear"
        return
      end

      Hachiwari::CLI.start(["clear"])
    rescue StandardError => e
      warn "[hachiwari] Failed to clear saved data during uninstall: #{e.message}"
    end
  end
end

Hachiwari::Hooks.register
