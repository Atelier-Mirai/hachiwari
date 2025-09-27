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

    def register
      Gem.pre_uninstall(&method(:handle_pre_uninstall))
    end

    def handle_pre_uninstall(uninstaller)
      return unless target_gem?(uninstaller)
      run_clear_command
    end

    def target_gem?(uninstaller)
      spec = uninstaller&.spec
      spec&.name == "hachiwari"
    end

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
