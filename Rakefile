# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

# `bundle exec rake test` でテストスイートを走らせるタスクを定義
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

require "rubocop/rake_task"

# `bundle exec rake rubocop` で静的解析を実行できるようにする
RuboCop::RakeTask.new

# デフォルトタスクでテストと RuboCop をまとめて実行
task default: %i[test rubocop]
