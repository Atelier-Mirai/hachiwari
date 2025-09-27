# frozen_string_literal: true

# `lib/` 配下のファイルをテストから参照できるようにロードパスへ追加
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "fileutils"

# テスト実行時はユーザー環境のデータを汚さないよう、ストアファイルを一時ディレクトリへ切り替え
test_store_path = File.expand_path("../tmp/test-hachiwari.yml", __dir__)
ENV["HACHIWARI_STORE_PATH"] = test_store_path
FileUtils.mkdir_p(File.dirname(test_store_path))
FileUtils.rm_f(test_store_path)

require "hachiwari"

# Minitest を読み込み、レポーターを利用してテスト結果を整形表示
require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new(color: true)
