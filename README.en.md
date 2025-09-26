# Hachiwari

Hachiwari is derived from the word "80%". It is a Ruby gem that shows you the number of wins you need to achieve your target win rate (the default target is 80%).

For the Japanese documentation, refer to [README.md](README.md).

## Installation

Install it yourself as:

```
% gem install hachiwari
```

## Usage

### Display the number of wins needed to achieve the target win rate (with automatic saving)

```
% hachiwari status [wins] [losses] [target] [language]
```

- The `s` command can also be used as an alias for `status`.
- There are four arguments: number of wins, number of losses, target win rate, and display language. All arguments are optional.
- When no arguments are provided, the current match record is displayed based on default values or previously saved data. Defaults are wins: 0, losses: 0, win rate: 80%, language: Japanese (`ja`).
- If the number of wins is provided as the first argument, the required number of additional wins based on it will be displayed. The remaining arguments fall back to defaults or saved values.
- The provided number of wins is automatically saved to `~/.hachiwari`.
- To update the number of losses, supply it as the second argument.
- To change the target win rate, provide it as the third argument (e.g., `90` for a 90% target).
- To change the display language, use the fourth argument. Specify `en` for English; the default is Japanese `ja`.

### Display the number of wins needed to achieve the target win rate (information only)

Usage is the same as the `status / s` command, but this command does not save the provided arguments. It is handy when you only want to simulate different scenarios.

```
% hachiwari info [wins] [losses] [target] [language]
```

### Display the version of Hachiwari

```
% hachiwari version
```

Displays the currently installed version of Hachiwari.

## Development

After checking out the repository, run `bin/setup` to install dependencies. Then run `rake test` to execute the test suite. You can also run `bin/console` for an interactive prompt that lets you experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Atelier-Mirai/hachiwari. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Atelier-Mirai/hachiwari/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Hachiwari project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [code of conduct](https://github.com/Atelier-Mirai/hachiwari/blob/master/CODE_OF_CONDUCT.md).
