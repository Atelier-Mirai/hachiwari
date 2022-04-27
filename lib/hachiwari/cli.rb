# require "hachiwari"
require "thor"
require 'yaml/store'

module Hachiwari
  class CLI < Thor

    Results   = Struct.new(:wins, :losses, :target, :language)
    @@db      = YAML::Store.new("#{Dir.home}/.hachiwari")
    @@results = @@db.transaction { @@db[:results] } if @@db
    @@results ||= Results.new(0, 0, 80, :ja)

    class << self
      def save
        @@db.transaction { @@db[:results] = @@results }
      end
    end
    CLI.save

    desc "status [wins] [losses] [target] [language]", "Displays winning percentage and number of wins to achieve the goal. (with save status)"
    def status(wins = @@results.wins, losses = @@results.losses, target = @@results.target, language = @@results.language, save = true)
      wins     = wins.to_i       if ARGV[1]
      losses   = losses.to_i     if ARGV[2]
      target   = target.to_i     if ARGV[3]
      language = language.to_sym if ARGV[4]

      if save
        @@results.wins     = wins
        @@results.losses   = losses
        @@results.target   = target
        @@results.language = language
        CLI.save
      end

      case language
      when :ja
        puts "#{wins+losses} 戦 #{wins} 勝 #{losses} 敗 勝率 #{winning_percentage(wins, losses)} % です"
        puts "あと #{reach_wins(wins, losses)} 勝で 勝率 #{(@@results.target).to_i} % です"
      when :en
        puts "#{wins+losses} games #{wins} wins #{losses} losses a winning percentage of #{winning_percentage(wins, losses)} %."
        puts "You need #{reach_wins(wins, losses)} more wins to reach #{(@@results.target).to_i} %"
      end
    end

    desc "s   [wins] [losses] [target] [language]", "Another name for the status command."
    def s(wins = @@results.wins, losses = @@results.losses, target = @@results.target, language = @@results.language)
      status(wins, losses, target, language)
    end

    desc "info [wins] [losses] [target] [language]", "Displays winning percentage and number of wins to achieve the goal. (Information only)"
    def info(wins = @@results.wins, losses = @@results.losses, target = @@results.target, language = @@results.language)
      status(wins, losses, target, language, false)
    end

    desc "i   [wins] [losses] [target] [language]", "Another name for the info command."
    def i(wins = @@results.wins, losses = @@results.losses, target = @@results.target, language = @@results.language)
      status(wins, losses, target, language, false)
    end

    desc "version", "Displays the version number."
    def version
      puts Hachiwari::VERSION
    end

    private

    def winning_percentage(wins, losses)
      (wins / (wins + losses).to_f * 100).round(4)
    end

    def reach_wins(wins, losses)
      target = @@results.target / 100.0
      (target / (1 - target) * losses - wins).round(6).ceil
    end
  end
end
