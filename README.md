# KeepTheChange

[![Build Status](https://travis-ci.org/pegasd/keepthechange.svg?branch=master)](https://travis-ci.org/pegasd/keepthechange)
[![Coverage Status](https://coveralls.io/repos/github/pegasd/keepthechange/badge.svg)](https://coveralls.io/github/pegasd/keepthechange)

This gem provides an easy-to-use interface for parsing CHANGELOG files that strictly adhere to
[keep a changelog format](http://keepachangelog.com/).

The idea is loosely based on [vandamme](https://github.com/tech-angels/vandamme) gem, but is supposed to evolve
into something more strict (in terms of supported formats), but also more feature-rich.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'keepthechange', '~> 0.1'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install keepthechange
```

## Usage

### Parsed Changes Hash

```ruby
parser = KeepTheChange::Parser.new(changelog: File.read('CHANGELOG.md'))
changes_hash = parser.parse
```

This will produce a hash where keys are version numbers (e.g. `0.1.0`, `1.0.3`) and values are hashes themselves.
Those will have headers as keys (e.g. `Added`, `Fixed`) and changesets as corresponding values.

### Combine Multiple Changesets

If you only provide one argument to `combine_changes()`, the resulting output will contain changes since that
version.

```ruby
File.write('SINCE_0.1.7.md', parser.combine_changes('0.1.7'))
```

> `0.1.7` itself won't be included in the resulting file.

Specify both the lower and upper bound (again - lower bound is exclusive) to produce output with changes between the versions.

```ruby
File.write('0.1.7-1.0.3.md', parser.combine_changes('0.1.7', '1.0.3'))
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also 
run `bin/simple_test` after putting a `TEST_CHANGELOG.md` into the repo directory for a basic parsing test.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports, feature requests and pull requests are welcome at [KeepTheChange official repo](https://github.com/pegasd/keepthechange).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Keepthechange project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the 
[Code of Conduct](https://github.com/pegasd/keepthechange/blob/master/CODE_OF_CONDUCT.md).
