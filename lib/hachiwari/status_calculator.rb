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

    # 目標勝率を満たすまでに必要な追加勝利数を算出
    # 既に目標を上回っている、もしくは目標が無効な場合は 0 を返す
    def required_wins(results)
      target = results.target.to_i
      return 0 if target <= 0

      wins = results.wins.to_i
      losses = results.losses.to_i
      total = wins + losses

      return 0 if total.positive? && wins * 100 >= target * total

      denominator = 100 - target
      return 0 if denominator <= 0

      numerator = (target * total) - (wins * 100)
      return 0 if numerator <= 0

      (numerator + denominator - 1) / denominator
    end

    # 勝率が目標を上回っている場合に、目標を下回るまでに許容される敗北数を算出
    # それ以外の状況では 0 を返す
    def losses_until_below_target(results)
      target = results.target.to_i
      return 0 if target <= 0

      wins = results.wins.to_i
      losses = results.losses.to_i
      total = wins + losses
      return 0 if total.zero?

      numerator = (wins * 100) - (target * total)
      return 0 if numerator < 0

      return 0 if numerator.zero? && target >= 100 && losses.positive?

      return 1 if numerator.zero? && target >= 100

      (numerator / target) + 1
    end

    # 総対局数（勝ち数 + 負け数）を返却
    def total_games(results)
      results.wins + results.losses
    end
  end
end
