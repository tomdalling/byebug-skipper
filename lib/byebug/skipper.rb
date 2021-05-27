
module Byebug::Skipper
  extend self

  DEFAULT_SKIP_MATCHERS = [
    %r{/ruby/[^/]+(/bundler)?/gems/}, # gems installed globally or via Bundler
  ].freeze

  def skip_matchers
    @skip_matchers || DEFAULT_SKIP_MATCHERS
  end

  def skip_matchers=(matchers)
    @skip_matchers = matchers
  end

  def skip?(location)
    skip_matchers.any? { |sm| sm === location }
  end
end

require 'byebug'
require 'byebug/command'
require 'byebug/helpers/frame'
require_relative 'skipper/ups_command'
require_relative 'skipper/downs_command'
require_relative 'skipper/finishs_command'

module Byebug
  # These classes need to be in the Byebug module or else they don't get picked
  # up. Cool, bruh.
  UpsCommand = Byebug::Skipper::UpsCommand
  DownsCommand = Byebug::Skipper::DownsCommand
  FinishsCommand = Byebug::Skipper::FinishsCommand
end
