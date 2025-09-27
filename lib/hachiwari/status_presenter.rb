# frozen_string_literal: true

module Hachiwari
  # 計算済みの値をユーザー向けメッセージに整形して出力する責務を担う
  class StatusPresenter
    # 言語に応じたテンプレートへ値を埋め込み標準出力へ表示
    def render(results, data)
      template = status_template(results.language)
      puts format(template[:summary], **data)

      if data[:needed].positive?
        puts format(template[:needed], **data)
      elsif data[:losses_to_fall].positive?
        puts format(template[:cushion], **data)
      end
    end

    private

    def status_template(locale)
      Hachiwari::Locales.t(locale, :status)
    rescue KeyError
      Hachiwari::Locales.t(:ja, :status)
    end
  end
end
