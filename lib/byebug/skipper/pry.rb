require_relative '../skipper'
require 'pry-byebug'

module Byebug::Skipper::Pry
  # All the Pry command classes are implemented the same
  %w[ups downs steps finishs].each do |command_name|
    command_class = Class.new(Pry::ClassCommand) do
      include ::PryByebug::Helpers::Navigation

      match command_name
      group "Byebug Skipper"
      description "Same as Byebug's `#{command_name.chomp('s')}` command but skips garbage frames (e.g. from gems)"

      def process
        PryByebug.check_file_context(target)
        breakout_navigation command_name
      end
    end

    const_set "#{command_name.capitalize}Command", command_class
    ::Pry::Commands.add_command(command_class)
  end
end


# Time 2 get nasty
module Byebug::Skipper::PryProcessorHacks
  # this needs to be overriden because there is a hard-coded whitelist of
  # `action` values inside, and I need to add custom actions.
  def perform(action, options = {})
    return if action.nil?
    send("perform_#{action}", options)
  end

  # delegate the implementations straight to the byebug command objects
  {
    'ups' => true,
    'downs' => true,
    'steps' => false,
    'finishs' => false,
  }.each do |command_name, should_resume|
    define_method("perform_#{command_name}") do |_options|
      Byebug::Skipper.const_get("#{command_name.capitalize}Command")
        .new(self, command_name)
        .execute

      resume_pry if should_resume
    end
  end
end

Byebug::PryProcessor.prepend(Byebug::Skipper::PryProcessorHacks)
