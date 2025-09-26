# frozen_string_literal: true

module Hachiwari
  # 計算済みの値をユーザー向けメッセージに整形して出力する責務を担う
  class StatusPresenter
    STATUS_LINES = {
      ja: [
        "%<total>d 戦 %<wins>d 勝 %<losses>d 敗 勝率 %<percentage>.4f %% です",
        "あと %<needed>d 勝で 勝率 %<target>d %% です"
      ],
      en: [
        "%<total>d games %<wins>d wins %<losses>d losses a winning percentage of %<percentage>.4f %%.",
        "You need %<needed>d more wins to reach %<target>d %%"
      ]
    }.freeze

    # 言語に応じたテンプレートへ値を埋め込み標準出力へ表示
    def render(results, data)
      template = STATUS_LINES.fetch(results.language, STATUS_LINES[:ja])
      template.each { |line| puts format(line, **data) }
    end
  end
end
