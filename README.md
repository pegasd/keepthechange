# KeepTheChange

This gem provides an easy-to-use interface for parsing CHANGELOG files that strictly adhere to
[keep a changelog format](http://keepachangelog.com/).

The idea is loosely based on [vandamme](https://github.com/tech-angels/vandamme) gem, but is supposed to evolve
into something more strict (in terms of supported formats), but also more feature-rich.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'keepthechange', github: 'pegasd/keepthechange'
```

And then execute:

    $ bundle

## Usage

```ruby
changes_hash = KeepTheChange::Parser.new(changelog: File.read('CHANGELOG.md')).parse
```

This will produce a hash with versions as keys.

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also 
run `bin/simple_test` after putting a `CHANGELOG.md` into the repo directory for a basic parsing test.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in 
`version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push 
the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports, feature requests and pull requests are welcome at [KeepTheChange official repo](https://github.com/pegasd/keepthechange).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Keepthechange project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the 
[Code of Conduct](https://github.com/pegasd/keepthechange/blob/master/CODE_OF_CONDUCT.md).
