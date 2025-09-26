# frozen_string_literal: true

# gem 利用者が `require "hachiwari"` した際に読み込まれるエントリポイント

require_relative "hachiwari/version"
require_relative "hachiwari/results"
require_relative "hachiwari/status_calculator"
require_relative "hachiwari/status_presenter"
require_relative "hachiwari/status_runner"
require_relative "hachiwari/cli"

module Hachiwari
  # gem 全体で共通的に利用できる基底エラークラス
  class Error < StandardError; end
end
