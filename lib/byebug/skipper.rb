module Byebug::Skipper
  extend self

  DEFAULT_SKIP_MATCHERS = [
    %r{/ruby/[^/]+(/bundler)?/gems/}, # gems installed globally or via Bundler
    %r{/ruby-[^/]+/lib/ruby/[^/]+/}, # Ruby built-in files
  ].freeze

  def skip_matchers
    @skip_matchers ||= DEFAULT_SKIP_MATCHERS
  end

  def skip_matchers=(matchers)
    @skip_matchers = matchers
  end

  def skip?(location)
    skip_matchers.any? { |sm| sm === location }
  end
end

require 'delegate'
require 'byebug'
require 'byebug/command'
require 'byebug/helpers/frame'
require_relative 'skipper/ups_command'
require_relative 'skipper/downs_command'
require_relative 'skipper/finishs_command'
require_relative 'skipper/steps_command'

# Command classes need to be in the Byebug module or else they don't get picked
# up. Cool, bruh.
[
  Byebug::Skipper::UpsCommand,
  Byebug::Skipper::DownsCommand,
  Byebug::Skipper::FinishsCommand,
  Byebug::Skipper::StepsCommand,
].each do |command_class|
  Byebug.const_set(
    command_class.name.split('::').last,
    command_class,
  )
end

require_relative 'skipper/pry' if defined?(PryByebug)

