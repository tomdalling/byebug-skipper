require_relative '../skipper'
require 'pry-byebug'

module Byebug::Skipper::Pry
  COMMAND_NAMES = %w[ups downs steps finishs].freeze
  COMMANDS_THAT_CONTINUE = %w[steps finishs].freeze
end

# All the Pry command classes are implemented the same
Byebug::Skipper::Pry::COMMAND_NAMES.each do |command_name|
  command_class = Class.new(Pry::ClassCommand) do
    include ::PryByebug::Helpers::Navigation

    match command_name
    group "Byebug Skipper"
    description "Same as Byebug's `#{command_name.chomp('s')}` command but skips garbage frames (e.g. from gems)"

    def process
      PryByebug.check_file_context(target)
      # This comes from pry-byebug, and we need to monkey patch it (see below)
      # to get these custom command names to work properly.
      breakout_navigation(command_name)
    end
  end

  Byebug::Skipper::Pry.const_set("#{command_name.capitalize}Command", command_class)
  Pry::Commands.add_command(command_class)
end

# This is a monkey patch for Byebug::PryProcessor in order to add extra Byebug
# commands to Pry. This needs to be overriden because there is a hard-coded
# whitelist of `action` values inside, and I need to add custom actions.
module Byebug::Skipper::Pry::ProcessorHacks
  def perform(action, options = {})
    # If it's not one of our commands, short circuit and use the typical
    # behaviour.
    return super unless Byebug::Skipper::Pry::COMMAND_NAMES.include?(action.to_s)

    # Call the Byebug command objects directly. This seems kind of fragile to
    # me, but I don't see any better options.
    Byebug::Skipper.const_get("#{command_name.capitalize}Command")
      .new(self, command_name)
      .execute

    unless Byebug::Skipper::Pry::COMMANDS_THAT_CONTINUE.include?(command_name)
      # This shows the REPL again, preventing execution from continuing.
      resume_pry
    end
  end
end

Byebug::PryProcessor.prepend(Byebug::Skipper::Pry::ProcessorHacks)
