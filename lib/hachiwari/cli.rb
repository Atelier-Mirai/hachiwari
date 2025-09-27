# frozen_string_literal: true

require "thor"
require_relative "status_runner"
require_relative "storage"
require_relative "locales"

module Hachiwari
  class CLI < Thor
    HIDDEN_GENERAL_HELP_COMMANDS = %w[info i calculate s].freeze
    DEFAULT_THOR_LOCALE = :ja

    class << self
      # CLI 起動時に旧フォーマットの保存データをマイグレートし、ヘルプやバージョン表示を先に処理する
      def start(given_args = ARGV, config = {}, &)
        migrate_legacy_store

        args = Array(given_args).dup
        return display_help(nil) if args.empty?
        return if handle_direct_option?(args)

        args = ["status", *args] if default_to_status?(args)
        super(args, config, &)
      end

      # ヘルプ用の文字列をユーザー設定ロケール優先で取得する
      def thor_string(command, key)
        fetch_locale_value(help_language, command, key) || fetch_locale_value(DEFAULT_THOR_LOCALE, command, key) || ""
      end

      # ヘルプ詳細文をロケール順に取得して配列化する
      def thor_details(command)
        value = fetch_locale_value(help_language, command, :details)
        value = fetch_locale_value(DEFAULT_THOR_LOCALE, command, :details) if value.nil?
        array_wrap(value)
      end

      # 長文説明をメイン文と詳細の組み合わせで構築する
      def thor_long_description(command)
        build_long_description(thor_string(command, :long), thor_details(command))
      end

      # デフォルトロケールから短い説明を取得する
      def default_thor_string(command, key)
        fetch_locale_value(DEFAULT_THOR_LOCALE, command, key) || ""
      end

      # デフォルトロケールの詳細情報を配列で取得する
      def default_thor_details(command)
        array_wrap(fetch_locale_value(DEFAULT_THOR_LOCALE, command, :details))
      end

      # デフォルトロケールで長文説明を生成する
      def default_thor_long_description(command)
        build_long_description(default_thor_string(command, :long), default_thor_details(command))
      end

      private

      # 引数に含まれるバージョン/ヘルプ系の即時オプションを処理する
      def handle_direct_option?(args)
        case args.first
        when "--version", "-v"
          puts Hachiwari::VERSION
          return true
        when "--help", "-h", "help"
          display_help(args[1])
          return true
        end

        help_index = args.index("--help") || args.index("-h")
        return false unless help_index

        display_help(extract_command_for_help(args, help_index))
        true
      end

      # 旧ストレージ形式が存在する場合にマイグレーションを実行する
      def migrate_legacy_store
        Storage.new.send(:migrate_legacy_if_needed)
      rescue StandardError
        # 続行
      end

      # ヘルプ引数の位置からコマンド名候補を取得する
      def extract_command_for_help(args, help_index)
        before = help_index.positive? ? args[help_index - 1] : nil
        after = args[help_index + 1]
        [before, after].compact.find { |candidate| candidate && !candidate.start_with?("-") }
      end

      # 指定されたコマンドのヘルプを出力する
      def display_help(command)
        command = command&.to_s&.strip
        command = nil if command.nil? || command.empty?
        command ? print_command_help(command) : print_general_help
      end

      # 全体ヘルプの各コマンド情報を出力する
      def print_general_help
        data = help_content
        puts data[:general_intro]
        data[:commands].each do |name, info|
          next if HIDDEN_GENERAL_HELP_COMMANDS.include?(name.to_s)

          puts "  #{info[:usage]}"
          puts "    #{info[:description]}"
          Array(info[:details]).each { |detail| puts "    #{detail}" }
        end
        Array(data[:general_footer]).each { |line| puts line }
      end

      # 個別コマンドの詳細ヘルプを出力する
      def print_command_help(command)
        data = help_content
        info = data[:commands][command.to_sym] || data[:commands][command.to_s]

        unless info
          puts format(data[:unknown_command], command: command)
          puts
          print_general_help
          return
        end

        puts format(data[:command_heading], usage: info[:usage])
        puts format(data[:description_heading], description: info[:description])
        Array(info[:details]).each { |detail| puts "  #{detail}" }
      end

      # ロケールごとのヘルプデータを取得する
      def help_content
        Hachiwari::Locales.t(help_language, :help)
      rescue KeyError
        Hachiwari::Locales.t(:ja, :help)
      end

      # 保存ロケールが利用可能か確認し、ヘルプ用ロケールを返す
      def help_language
        locale = Storage.new.load.language
        available = Hachiwari::Locales.available_locales
        available.include?(locale) ? locale : :ja
      rescue StandardError
        :ja
      end

      # 指定コマンドが登録済みか判定し、未登録なら status へフォールバックする
      def default_to_status?(args)
        return false if args.empty?

        first = args.first
        return true if first.start_with?("-")

        !all_commands.key?(first)
      end

      # ロケール付きの Thor 文言を取得する
      def fetch_locale_value(locale, command, key)
        Hachiwari::Locales.t(locale, :thor, command, key)
      rescue KeyError
        nil
      end

      # メイン文と詳細配列から長文を組み立てる
      def build_long_description(primary, extra_lines)
        lines = []
        lines << primary if primary && !primary.empty?
        lines.concat(array_wrap(extra_lines))
        lines.compact.join("\n")
      end

      # 値を配列にラップして扱いやすくする
      def array_wrap(value)
        case value
        when nil
          []
        when Array
          value
        else
          [value]
        end
      end
    end

    attr_reader :runner, :storage

    # コマンド実行時に利用するストレージとランナーを初期化する
    def initialize(*args, **kwargs)
      super
      @storage = Storage.new
      @runner = StatusRunner.new(storage: storage)
    end

    option :trial, type: :boolean, aliases: "-t", desc: CLI.default_thor_string(:status, :option_trial)
    desc "status [wins] [losses] [target] [language]", CLI.default_thor_long_description(:status)

    # 勝敗・目標勝率・言語を受け取り、状態を保存しながら結果を表示
    def status(*args)
      run_status_with_trial_flag(trial: options[:trial], **parse_status_arguments(args))
    end

    option :trial, type: :boolean, aliases: "-t", desc: CLI.default_thor_string(:info, :option_trial)
    desc "info [wins] [losses] [target] [language]", CLI.default_thor_long_description(:info)
    # 状態を保存せず試算だけ行うコマンド
    def info(*args)
      warn_deprecation("info", locale_key: :trial)
      run_status_with_trial_flag(trial: true, **parse_status_arguments(args))
    end

    desc "i   [wins] [losses] [target] [language]", CLI.default_thor_long_description(:alias_i)
    # `info` と同等の動作を行う短縮エイリアス
    def i(*args)
      warn_deprecation("i", locale_key: :alias)
      run_status_with_trial_flag(trial: true, **parse_status_arguments(args))
    end

    desc "version", CLI.default_thor_string(:version, :short)
    # CLI のバージョン情報を表示する
    def version
      puts Hachiwari::VERSION
    end

    desc "clear", CLI.default_thor_string(:clear, :short)
    # 保存済みの状態データを削除する
    def clear
      if storage.clear
        say("Saved status data has been cleared.", :green)
      else
        say("No saved status data found.", :yellow)
      end
    end

    desc "calculate [wins] [losses]", CLI.default_thor_long_description(:calculate)
    option :target, type: :numeric, desc: CLI.default_thor_string(:calculate, :option_target)
    option :language, type: :string, desc: CLI.default_thor_string(:calculate, :option_language)
    # `status`/`info` とは別に、オプション経由でパラメータを受け取って計算のみ行う
    def calculate(wins, losses)
      warn_deprecation("calculate")
      run_status_with_trial_flag(
        trial: true,
        wins: wins, losses: losses, target: options[:target], language: options[:language]
      )
    end

    private

    # トライアル指定の有無に応じて保存フラグを切り替える
    def run_status_with_trial_flag(trial:, **params)
      run_status(save: !trial, **params)
    end

    # 位置引数から勝敗・目標・言語を取り出して整形する
    def parse_status_arguments(args)
      %i[wins losses target language].zip(args).to_h
    end

    # 非推奨コマンド利用時の警告をユーザーへ通知する
    def warn_deprecation(command, message = nil, locale_key: :trial)
      message ||= localized_deprecation(locale_key)
      say("`hachiwari #{command}`: #{message}", :yellow)
    end

    # 保存された言語設定で非推奨メッセージを取得する
    def localized_deprecation(key)
      locale = storage.load.language
      available = Hachiwari::Locales.available_locales
      locale = :ja unless available.include?(locale)
      Hachiwari::Locales.t(locale, :deprecations, key)
    rescue StandardError
      Hachiwari::Locales.t(:ja, :deprecations, key)
    end

    # `StatusRunner` へ依頼し、不要な nil を除いて保存フラグ付きで実行
    def run_status(save:, **params)
      runner.call(params.compact, save: save)
    end
  end
end
