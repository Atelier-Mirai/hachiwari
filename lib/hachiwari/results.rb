# frozen_string_literal: true

module Hachiwari
  # 勝敗や目標勝率、表示言語など CLI の状態を保持するデータオブジェクト
  Results = Struct.new(:wins, :losses, :target, :language) do
    # YAML への保存や表示時に利用しやすい Hash へ変換
    def to_h
      { wins: wins, losses: losses, target: target, language: language }
    end
  end
end
