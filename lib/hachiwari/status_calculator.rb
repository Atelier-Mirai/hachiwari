# frozen_string_literal: true

module Hachiwari
  # 勝率や必要勝数などの数値計算を担当するユーティリティ
  class StatusCalculator
    # 勝率（%）を小数第4位まで算出
    def winning_percentage(results)
      games = total_games(results)
      return 0.0 if games.zero?

      (results.wins / games.to_f * 100).round(4)
    end

    # 目標勝率を達成するために必要な勝ち数を算出
    def required_wins(results)
      target_ratio = results.target / 100.0
      needed_wins = (target_ratio / (1 - target_ratio) * results.losses) - results.wins
      needed_wins.round(6).ceil
    end

    # 総対局数（勝ち数 + 負け数）を返却
    def total_games(results)
      results.wins + results.losses
    end
  end
end
