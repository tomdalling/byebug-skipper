require_relative '../lib/byebug/skipper'

RSpec.describe Byebug::Skipper do
  subject { described_class }
  before { subject.skip_matchers = subject::DEFAULT_SKIP_MATCHERS }

  module BushKangaroo
    def self.===(path)
      path.match?(/_spec\.rb:\d+$/)
    end
  end

  it 'skips gem paths by default' do
    expect(subject.skip?('/Users/tom/.gem/ruby/2.7.3/gems/rspec-core-3.10.1/lib/rspec/core/example.rb'))
      .to be(true)
    expect(subject.skip?('/Users/tom/.gem/ruby/2.7.3/bundler/gems/rails-ce2d72a089f5/activesupport/lib/active_support.rb'))
      .to be(true)
  end

  it 'has a configurable list of matchers for skipping paths' do
    subject.skip_matchers = [
      /skipme/,
      BushKangaroo,
    ]

    expect(subject.skip?('/a/b/skipme/c/d.txt:123')).to be(true)
    expect(subject.skip?('blah/skippy_spec.rb:666')).to be(true)

    expect(subject.skip?('/Users/tom/.gem/ruby/2.7.3/gems/rspec-core-3.10.1/lib/rspec/core/example.rb'))
      .to be(false)
  end

  it 'adds extra commands to Byebug' do
    require 'byebug/core'

    expect(Byebug.commands).to include(
      Byebug::Skipper::UpsCommand,
      Byebug::Skipper::DownsCommand,
      Byebug::Skipper::FinishsCommand,
    )
  end
end
