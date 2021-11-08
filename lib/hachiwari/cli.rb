# require "hachiwari"
require "thor"

module Hachiwari
  class CLI < Thor
    desc "status {wins} {losses}", "Displays winning percentage and number of wins to achieve the goal."
    def status(wins, losses)
      wins   = wins.to_i
      losses = losses.to_i
      puts "現在の勝率は #{winning_percentage(wins, losses)} % です"
      puts "あと #{reach_wins(wins, losses)} 勝で 八割です"
    end

    private

    def winning_percentage(wins, losses)
      (wins / (wins + losses).to_f * 100).round(4)
    end

    def reach_wins(wins, losses)
      target = 0.8
      (target / (1 - target) * losses - wins).to_i
    end
  end
end
