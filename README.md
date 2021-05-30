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
gem 'byebug-skipper', github: 'tomdalling/byebug-skipper'
```

And require it just after `byebug`.

```ruby
require 'byebug'
require 'byebug-skipper'
```

## Usage

This gem adds three new commands to Byebug: `ups`, `downs`, `steps`,
and `finishs`. These work exactly the same as the built in `up`,
`down`, `step` and `finish` commands, except they skip over frames of
garbage. Bon appétit.

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

