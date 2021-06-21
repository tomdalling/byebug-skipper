require_relative '../skipper'
require 'pry-byebug'

module Byebug::Skipper::Pry
  COMMANDS = [
    {
      cmd: 'ups',
      const_name: 'Ups',
      continues?: false,
    },
    {
      cmd: 'downs',
      const_name: 'Downs',
      continues?: false,
    },
    {
      cmd: 'steps',
      const_name: 'Steps',
      continues?: true,
    },
    {
      cmd: 'finishs',
      const_name: 'Finishs',
      continues?: true,
    },
  ].freeze
end

# All the Pry command classes are implemented the same
Byebug::Skipper::Pry::COMMANDS.each do |command|
  byebug_command_class = Byebug::Skipper.const_get("#{command.fetch(:const_name)}Command")
  pry_command_class = Class.new(Pry::ClassCommand) do
    include ::PryByebug::Helpers::Navigation

    match command.fetch(:cmd)
    group "Byebug Skipper"
    description byebug_command_class.short_description

    def process
      PryByebug.check_file_context(target)
      # This comes from pry-byebug, and we need to monkey patch it (see below)
      # to get these custom command names to work properly.
      breakout_navigation(command_name)
    end
  end

  Byebug::Skipper::Pry.const_set("#{command.fetch(:const_name)}Command", pry_command_class)
  Pry::Commands.add_command(pry_command_class)
end

# This is a monkey patch for Byebug::PryProcessor in order to add extra Byebug
# commands to Pry. This needs to be overriden because there is a hard-coded
# whitelist of `action` values inside, and I need to add custom actions.
module Byebug::Skipper::Pry::ProcessorHacks
  def perform(action, options = {})
    # If it's not one of our commands, short circuit and use the typical
    # behaviour.
    command = Byebug::Skipper::Pry::COMMANDS.find { _1.fetch(:cmd) == action.to_s }
    return super unless command

    # Call the Byebug command objects directly. This seems kind of fragile to
    # me, but I don't see any better options.
    Byebug::Skipper.const_get("#{command.fetch(:const_name)}Command")
      .new(self, action.to_s)
      .execute

    # This shows the REPL again, preventing execution from continuing.
    resume_pry unless command.fetch(:continues?)
  end
end

Byebug::PryProcessor.prepend(Byebug::Skipper::Pry::ProcessorHacks)
