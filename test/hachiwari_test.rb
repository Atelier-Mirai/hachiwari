# frozen_string_literal: true

require "test_helper"

# `Hachiwari::CLI` の振る舞いを確認するためのテストクラス
class HachiwariTest < Minitest::Test
  def setup
    # 計算ロジックと結果データの初期化
    @calculator = Hachiwari::StatusCalculator.new
    @base_results = Hachiwari::Results.new(79, 20, 80, :ja)
  end

  def test_that_it_has_a_version_number
    # バージョン番号が定義されていることを確認
    refute_nil ::Hachiwari::VERSION
  end

  def test_it_does_something_useful
    # ひとまず雛形として true を返す簡易テスト
    assert true
  end

  def test_winning_percentage
    # 勝率計算の結果が期待通りであることを確認
    results = Hachiwari::Results.new(40, 10, 80, :ja)
    assert_in_delta 80.0000, @calculator.winning_percentage(results), 0.0001

    results = Hachiwari::Results.new(7162, 1823, 80, :ja)
    assert_in_delta 79.7106, @calculator.winning_percentage(results), 0.0001
  end

  def test_required_wins
    # 目標勝率を達成するために必要な勝ち数を検証
    assert_equal 1, @calculator.required_wins(@base_results)

    results = Hachiwari::Results.new(7162, 1823, 80, :ja)
    assert_equal 130, @calculator.required_wins(results)
  end

  def test_status_runner_updates_storage_when_save_true
    temp_store = File.expand_path("../tmp/runner-store.yml", __dir__)
    storage = Hachiwari::Storage.new(temp_store)
    runner = Hachiwari::StatusRunner.new(storage: storage)

    results = runner.call({ wins: 10, losses: 5 }, save: true)

    assert_equal 10, results.wins
    assert_equal 5, results.losses
    assert_equal 80, storage.load.target
  ensure
    FileUtils.rm_f(temp_store)
  end

  def test_status_runner_does_not_persist_when_save_false
    temp_store = File.expand_path("../tmp/runner-store.yml", __dir__)
    storage = Hachiwari::Storage.new(temp_store)
    runner = Hachiwari::StatusRunner.new(storage: storage)

    runner.call({ wins: 25 }, save: false)

    persisted = storage.load
    assert_equal 0, persisted.wins
    assert_equal 0, persisted.losses
  ensure
    FileUtils.rm_f(temp_store)
  end
end
