byebug-skipper
==============

![Logo](https://raw.githubusercontent.com/tomdalling/byebug-skipper/main/skipper.png)

Are you tired of going...

```
up
up
up
up
```

... and...

```
down
down
down
down
```

... in Byebug, through dozens of frames of crap you don't care about,
just to see your own code? Then this is the gem for you.

## Installation

At the gem to your `Gemfile`.

```ruby
gem 'byebug-skipper'
```

And require it just after `byebug` (or `pry-byebug`).

```ruby
require 'byebug'
require 'byebug-skipper'
```

## Usage

This gem adds a few new commands to Byebug: `ups`, `downs`, `steps`,
and `finishs`. These work exactly the same as the built in `up`,
`down`, `step` and `finish` commands, except they skip over frames of
garbage. Bon appétit.

It also adds a `skip!` command, which works like Byebug's `skip`
except it also comments out the line above the current line, which is
usually where you put `byebug` or `binding.pry`, so that next time you
run your code it won't stop there again. Radical!

## Pry Support

This gem will also add it's commands (except `skip!`) to Pry if the
`pry-byebug` gem is loaded. Either require 'byebug-skipper'
afterwards:

```ruby
require 'pry-byebug'
require 'byebug-skipper'
```

Or directly require the special Pry entry point:

```ruby
require 'byebug-skipper/pry'
```

The `skip!` command is not available because it doesn't seem to work,
I don't know why, and also `pry-byebug` does not provide a `skip`
command.

## Configuration

By default, the commands in this gem will skip frames that come from
gems and Ruby built-ins. It does this by looking at the file paths to
see if they contain something that looks like `/ruby/2.7.3/gems/`.

If that's not good enough for you, you can configure your own
matchers. If any of these match the file location, the frame will be
skipped.

```ruby
Byebug::Skipper.skip_matchers = [
  %r{app/controllers/application_controller.rb},
  /_spec\.rb/,
  /stuff/,
]
```

The elements of this array must implement the `#===` method (e.g.
regular expressions implement this), and will be provided a string
containing the absolute path and line number of the frame, like
`/path/to/whatever.rb:55`.

## Contributing

Open a pull request.

