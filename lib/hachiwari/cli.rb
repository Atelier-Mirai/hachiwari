# require "hachiwari"
require "thor"
require 'yaml/store'

module Hachiwari
  class CLI < Thor

    Results   = Struct.new(:target, :wins, :losses)
    @@db      = YAML::Store.new("#{Dir.home}/.hachiwari")
    @@results = @@db.transaction { @@db[:results] } if @@db
    @@results ||= Results.new(0.8, 0, 0)
    class << self
      def save
        @@db.transaction { @@db[:results] = @@results }
      end
    end
    CLI.save

    desc "target {80}", "Set the win rate 80% you are aiming for."
    def target(win_rate = 80)
      @@results.target = win_rate.to_i / 100.0
      CLI.save
    end

    desc "status {wins} {losses}", "Displays winning percentage and number of wins to achieve the goal."
    def status(wins = @@results.wins, losses = @@results.losses)
      wins   = wins.to_i   if ARGV[1]
      losses = losses.to_i if ARGV[2]

      puts "#{wins} 勝 #{losses} 敗 勝率 #{winning_percentage(wins, losses)} % です"
      puts "あと #{reach_wins(wins, losses)} 勝で 勝率 #{(@@results.target*100).to_i} % です"

      @@results.wins   = wins
      @@results.losses = losses
      CLI.save
    end

    private

    def winning_percentage(wins, losses)
      (wins / (wins + losses).to_f * 100).round(4)
    end

    def reach_wins(wins, losses)
      target = @@results.target
      (target / (1 - target) * losses - wins).round(6).ceil
    end
  end
end


# Results = Struct.new(:target, :wins, :losses) do
#   def load
#     db = YAML::Store.new('./lib/results.yml')
#     results = if db
#                 db.transaction do
#                   db[:results]
#                 end
#               else
#                 Results.new(0.8, 7125, 1822)
#               end
#     results.wins   = ARGV[0].to_i if ARGV[0]
#     results.losses = ARGV[1].to_i if ARGV[1]
#     [:target, :wins, :losses].each do |key|
#       self[key] = results[key]
#     end
#   end
