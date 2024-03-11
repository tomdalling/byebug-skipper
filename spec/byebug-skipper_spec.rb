# frozen_string_literal: true

RSpec.describe Byebug::Skipper do
  subject { described_class }

  around do |example|
    old_matchers = subject.skip_matchers
    example.call
  ensure
    subject.skip_matchers = old_matchers
  end

  it 'skips gem paths by default' do
    expect(subject.skip?('/Users/tom/.gem/ruby/2.7.3/gems/rspec-core-3.10.1/lib/rspec/core/example.rb'))
      .to be(true)
    expect(subject.skip?('/Users/tom/.gem/ruby/2.7.3/bundler/gems/rails-ce2d72a089f5/activesupport/lib/active_support.rb'))
      .to be(true)
    expect(subject.skip?('/Users/blakeastley/.rvm/gems/ruby-2.7.3/gems/active_interaction-4.0.1/lib/active_interaction/concerns/runnable.rb'))
      .to be(true)
    expect(subject.skip?('/Users/hoylemd/.rbenv/versions/2.7.7/lib/ruby/gems/2.7.0/gems/activesupport-6.1.7.3/lib/active_support/json/decoding.rb:23'))
      .to be(true)
  end

  it 'skips Ruby built-in paths by default' do
    expect(subject.skip?('/Users/tom/.rubies/ruby-2.7.3/lib/ruby/2.7.0/delegate.rb:79'))
      .to be(true)
  end

  it 'does not skip other paths' do
    expect(subject.skip?('/path/to/my/ruby/code.rb')).to be(false)
    expect(subject.skip?('/path/to/my/ruby-2.7.3/code.rb')).to be(false)
  end

  it 'has a configurable list of matchers for skipping paths' do
    subject.skip_matchers = [
      /excluded/,
      ->(path) { path.match?(/_spec\.rb:\d+$/) },
    ]

    expect(subject.skip?('/a/b/excluded/c/d.txt:123')).to be(true)
    expect(subject.skip?('blah/skippy_spec.rb:666')).to be(true)
  end

  it 'repaces the defaults when setting custom matchers' do
    subject.skip_matchers = []
    expect(subject.skip?('/Users/tom/.gem/ruby/2.7.3/gems/rspec-core-3.10.1/lib/rspec/core/example.rb'))
      .to be(false)
  end

  it 'adds extra commands to Byebug' do
    require 'byebug/core'

    expect(Byebug.commands).to include(
      Byebug::Skipper::UpsCommand,
      Byebug::Skipper::DownsCommand,
      Byebug::Skipper::FinishsCommand,
      Byebug::Skipper::StepsCommand,
      Byebug::Skipper::SkipBangCommand,
    )
  end

  it 'adds extra commands to Pry' do
    require 'pry'

    expect(Pry.commands.keys).not_to include(
      'ups',
      'downs',
      'steps',
      'finishs',
    )

    require 'byebug/skipper/pry'

    expect(Pry.commands.keys).to include(
      'ups',
      'downs',
      'steps',
      'finishs',
    )
  end
end
