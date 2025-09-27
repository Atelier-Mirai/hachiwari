# frozen_string_literal: true

require_relative "lib/hachiwari/version"

Gem::Specification.new do |spec|
  # Gem の基本的なメタ情報を定義
  spec.name          = "hachiwari"
  spec.version       = Hachiwari::VERSION
  spec.authors       = ["Atelier-Mirai"]
  spec.email         = ["contact@atelier-mirai.net"]

  spec.summary       = "Track progress toward your target win rate"
  spec.description   = "Enter your record and instantly see how many wins you need to reach 80% or a custom goal."
  spec.homepage      = "https://github.com/Atelier-Mirai/hachiwari"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Atelier-Mirai/hachiwari"
  spec.metadata["changelog_uri"] = "https://github.com/Atelier-Mirai/hachiwari/blob/master/CHANGELOG.md"

  # 配布対象ファイルを Git の管理対象から自動検出
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  # 実行可能ファイルの配置先と読み込み対象ディレクトリを指定
  spec.bindir = "bin"
  spec.executables = Dir.children("bin")
  spec.require_paths = %w[lib]

  # ランタイムで利用する依存関係を宣言
  spec.add_dependency "pstore"
  spec.add_dependency "thor"
end
