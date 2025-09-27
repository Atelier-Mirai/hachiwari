# frozen_string_literal: true

require "test_helper"

# `Hachiwari::CLI` の振る舞いを確認するためのテストクラス
class HachiwariTest < Minitest::Test
  # 計算ロジックと結果データの初期化
  def setup
    @calculator = Hachiwari::StatusCalculator.new
    @base_results = Hachiwari::Results.new(79, 20, 80, :ja)
  end

  # バージョン番号が定義されていることを確認
  def test_that_it_has_a_version_number
    refute_nil ::Hachiwari::VERSION
  end

  # ひとまず雛形として true を返す簡易テスト
  def test_it_does_something_useful
    assert true
  end

  # 勝率計算の結果が期待通りであることを確認
  def test_winning_percentage
    results = Hachiwari::Results.new(40, 10, 80, :ja)
    assert_in_delta 80.0000, @calculator.winning_percentage(results), 0.0001

    results = Hachiwari::Results.new(7162, 1823, 80, :ja)
    assert_in_delta 79.7106, @calculator.winning_percentage(results), 0.0001

    results = Hachiwari::Results.new(79, 20, 80, :ja)
    assert_in_delta 79.7980, @calculator.winning_percentage(results), 0.0001

    results = Hachiwari::Results.new(80, 21, 80, :ja)
    assert_in_delta 79.2079, @calculator.winning_percentage(results), 0.0001
  end

  # 目標勝率を達成するために必要な勝ち数を検証
  def test_required_wins
    assert_equal 1, @calculator.required_wins(@base_results)

    results = Hachiwari::Results.new(7162, 1823, 80, :ja)
    assert_equal 130, @calculator.required_wins(results)

    results = Hachiwari::Results.new(80, 21, 80, :ja)
    assert_equal 4, @calculator.required_wins(results)

    results = Hachiwari::Results.new(25, 0, 80, :ja)
    assert_equal 0, @calculator.required_wins(results)
    assert_equal 7, @calculator.losses_until_below_target(results)
  end

  # save: true の場合にストレージへ保存されることを確認
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

  # save: false の場合にストレージが変更されないことを確認
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

  # CLI から clear を呼び出すと保存ファイルが削除されることを検証
  def test_cli_clear_removes_saved_data
    path = ENV.fetch("HACHIWARI_STORE_PATH")
    storage = Hachiwari::Storage.new(path)
    storage.save(Hachiwari::Results.new(5, 3, 80, :ja))
    assert File.exist?(path), "Expected store file to exist before clearing"

    capture_io { Hachiwari::CLI.start(["clear"]) }

    refute File.exist?(path), "Expected store file to be removed by clear command"
  end

  # アンインストールフックが呼ばれると自動的に保存ファイルが削除されることを検証
  def test_post_uninstall_hook_clears_storage
    path = ENV.fetch("HACHIWARI_STORE_PATH")
    storage = Hachiwari::Storage.new(path)
    storage.save(Hachiwari::Results.new(12, 8, 80, :ja))
    assert File.exist?(path), "Expected store file to exist before uninstall hook"

    require_relative "../lib/rubygems_plugin"
    fake_spec = Gem::Specification.new { |s| s.name = "hachiwari" }
    fake_uninstaller = Struct.new(:spec).new(fake_spec)

    capture_io { Hachiwari::Hooks.handle_pre_uninstall(fake_uninstaller) }

    refute File.exist?(path), "Expected store file to be removed by uninstall hook"
  end

  # CLI の `--version` オプションがバージョン番号を出力することを確認
  def test_cli_version_flag_displays_version
    out, err = capture_io { Hachiwari::CLI.start(["--version"]) }

    assert_equal "#{Hachiwari::VERSION}\n", out
    assert_empty err
  end

  # CLI の `--help` が全体のヘルプを表示し、非推奨コマンドを含まないことを確認
  def test_cli_help_flag_displays_general_help
    storage = Hachiwari::Storage.new(ENV.fetch("HACHIWARI_STORE_PATH"))
    storage.clear

    out, err = capture_io { Hachiwari::CLI.start(["--help"]) }

    assert_includes out, "利用可能なコマンド"
    assert_includes out, "hachiwari [status]"
    refute_includes out, "hachiwari info"
    refute_includes out, "hachiwari calculate"
    assert_empty err
  end

  # サブコマンド指定で詳細ヘルプが表示されることを確認
  def test_cli_command_help_flag_displays_command_specific_help
    storage = Hachiwari::Storage.new(ENV.fetch("HACHIWARI_STORE_PATH"))
    storage.clear

    out, err = capture_io { Hachiwari::CLI.start(["status", "--help"]) }

    assert_includes out, "コマンド: hachiwari [status]"
    assert_empty err
  end

  # ヘルプ出力が保存済みの言語設定に従うことを確認
  def test_cli_help_respects_language_setting
    storage = Hachiwari::Storage.new(ENV.fetch("HACHIWARI_STORE_PATH"))
    storage.save(Hachiwari::Results.new(0, 0, 80, :en))

    out, err = capture_io { Hachiwari::CLI.start(["--help"]) }

    assert_includes out, "Available commands"
    assert_includes out, "hachiwari [status]"
    refute_includes out, "hachiwari info"
    assert_empty err
  ensure
    storage.clear
  end

  # `status --trial` で保存データが更新されないことを検証
  def test_status_trial_option_does_not_persist
    storage = Hachiwari::Storage.new(ENV.fetch("HACHIWARI_STORE_PATH"))
    storage.clear
    storage.save(Hachiwari::Results.new(3, 2, 80, :ja))

    out, err = capture_io { Hachiwari::CLI.start(["status", "10", "5", "--trial"]) }

    persisted = storage.load
    assert_equal 3, persisted.wins
    assert_equal 2, persisted.losses
    assert_includes out, "勝率"
    assert_empty err
  ensure
    storage.clear
  end

  # 非推奨の `info` コマンドが警告を表示し、試算モードで動作することを確認
  def test_info_command_warns_and_behaves_like_trial
    storage = Hachiwari::Storage.new(ENV.fetch("HACHIWARI_STORE_PATH"))
    storage.clear
    storage.save(Hachiwari::Results.new(4, 6, 75, :ja))

    out, err = capture_io { Hachiwari::CLI.start(%w[info 10 5]) }

    assert_includes out, "status --trial"
    persisted = storage.load
    assert_equal 4, persisted.wins
    assert_equal 6, persisted.losses
    assert_empty err
  ensure
    storage.clear
  end

  # 非推奨の `calculate` コマンドが警告を表示し、試算モードで動作することを確認
  def test_calculate_command_warns_and_behaves_like_trial
    storage = Hachiwari::Storage.new(ENV.fetch("HACHIWARI_STORE_PATH"))
    storage.clear
    storage.save(Hachiwari::Results.new(8, 2, 70, :ja))

    out, err = capture_io { Hachiwari::CLI.start(["calculate", "12", "3", "--target=90", "--language=en"]) }

    assert_includes out, "status --trial"
    persisted = storage.load
    assert_equal 8, persisted.wins
    assert_equal 2, persisted.losses
    assert_empty err
  ensure
    storage.clear
  end

  # コマンド省略時に `status` へフォールバックすることを確認
  def test_cli_defaults_to_status_when_command_omitted
    storage = Hachiwari::Storage.new(ENV.fetch("HACHIWARI_STORE_PATH"))
    storage.clear

    capture_io { Hachiwari::CLI.start(%w[10 2 85 en]) }

    persisted = storage.load
    assert_equal 10, persisted.wins
    assert_equal 2, persisted.losses
    assert_equal 85, persisted.target
    assert_equal :en, persisted.language
  ensure
    storage.clear
  end

  # オプションのみ指定した場合に `status --trial` が実行されることを確認
  def test_cli_defaults_to_status_trial_when_only_option_provided
    storage = Hachiwari::Storage.new(ENV.fetch("HACHIWARI_STORE_PATH"))
    storage.clear
    storage.save(Hachiwari::Results.new(1, 1, 80, :ja))

    out, err = capture_io { Hachiwari::CLI.start(["--trial", "12"]) }

    persisted = storage.load
    assert_equal 1, persisted.wins
    assert_equal 1, persisted.losses
    assert_includes out, "勝率"
    assert_empty err
  ensure
    storage.clear
  end

  # レガシー形式の保存データがマイグレーションされることを確認
  def test_cli_handles_legacy_cli_results_entries
    path = ENV.fetch("HACHIWARI_STORE_PATH")
    storage = Hachiwari::Storage.new(path)
    FileUtils.rm_f(path)
    legacy_yaml = <<~YAML
      ---
      :results: !ruby/struct:Hachiwari::CLI::Results
        :wins: 7
        :losses: 3
        :target: 90
        :language: :en
    YAML
    File.write(path, legacy_yaml)

    out, err = capture_io { Hachiwari::CLI.start(["--trial"]) }

    assert_match(/勝率|winning percentage/i, out)
    persisted = storage.load
    assert_equal 7, persisted.wins
    assert_equal 3, persisted.losses
    assert_equal 90, persisted.target
    assert_equal :en, persisted.language
    assert_empty err
  ensure
    FileUtils.rm_f(path)
  end

  # 目標勝率を既に達成している場合に、勝率を下回るまでの敗数を案内することを確認
  def test_cli_reports_losses_needed_when_above_target
    storage = Hachiwari::Storage.new(ENV.fetch("HACHIWARI_STORE_PATH"))
    storage.clear
    storage.save(Hachiwari::Results.new(25, 0, 80, :ja))

    out, err = capture_io { Hachiwari::CLI.start(["--trial"]) }

    assert_includes out, "敗すると 勝率 80 % を下回ります"
    assert_empty err
  ensure
    storage.clear
  end
end
