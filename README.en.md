# Hachiwari

Hachiwari originates from the phrase "80 percent" (hachiwari). It is a Ruby gem that tells you how many additional wins you need to hit your target win rate (80 percent by default).

For other languages, see [README.md](README.md) (Japanese) / [README.es.md](README.es.md) (Spanish) / [README.fr.md](README.fr.md) (French) / [README.de.md](README.de.md) (German).

## Installation

Install it with:

```
% gem install hachiwari
```

## Usage

### Display the number of wins required to reach the target win rate (with automatic saving)

```
% hachiwari [status] [wins] [losses] [target] [language]
```

- You can omit `status` and pass only the arguments.
- The legacy alias `s` is deprecated; it prints a warning and internally invokes `status`.
- There are four arguments: number of wins, number of losses, target win rate, and display language. All of them are optional.
- With no arguments, the current record is shown based on defaults or previously saved data. Defaults are wins: 0, losses: 0, target: 80 percent, language: Japanese (`ja`).
- If you pass wins as the first argument, Hachiwari tells you how many more wins are required from that value. Remaining arguments fall back to defaults or saved data.
- The number of wins you provide is automatically saved to `~/.hachiwari`.
- To update losses, pass them as the second argument.
- To change the target win rate, use the third argument (for example, `90` for 90 percent).
- To change the language, use the fourth argument. Supported values are `ja` (Japanese, default), `en` (English), `es` (Spanish), `fr` (French), and `de` (German).

To preview the result without saving it, append the `--trial` (or `-t`) option:

```
% hachiwari [status] --trial [wins] [losses] [target] [language]
```

Arguments behave exactly as in the regular `status` command, but no state is persisted. The legacy `info`, `i`, and `calculate` commands are deprecated; they print a warning and behave like `status --trial`.

### Display the version of Hachiwari

```
% hachiwari version
```

Shows the installed version of Hachiwari.

### Delete saved match data

```
% hachiwari clear
```

Removes the stored `.hachiwari` file. If no data exists, a warning is shown instead.

### Show command lists or detailed help

```
% hachiwari --help
% hachiwari status --help
```

`hachiwari --help` prints available commands, and `hachiwari <command> --help` prints detailed help for each command.

### Deprecated commands

The following commands/aliases are deprecated. When executed, they print a warning and fall back to compatible behavior:

- **s**: Former alias of `status`. A warning is printed and `status` runs.
- **info / i**: Formerly provided trial output without saving. They now warn and behave like `status --trial`.
- **calculate**: Former option-driven calculator command. It now warns and behaves like `status --trial` (the `--target` / `--language` options remain available).

## Development

Clone the repository and set up the development environment with:

```
bundle install
bundle exec rake test
```

- **Install dependencies**: `bundle install`
- **Run tests**: `bundle exec rake test`
- **Check the CLI manually**: `bundle exec ruby -Ilib bin/hachiwari --help`

To install the gem locally, run `bundle exec rake install`.

### Releasing a new version

1. Update `VERSION` in `lib/hachiwari/version.rb`.
2. Commit and push your changes.
3. Run `bundle exec rake release`.

The release task creates a git tag, pushes commits and the tag, and publishes the gem to [rubygems.org](https://rubygems.org) (you need MFA enabled on RubyGems).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/Atelier-Mirai/hachiwari).

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT). See [LICENSE](./LICENSE) for details.
