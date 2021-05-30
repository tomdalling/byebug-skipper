module Byebug::Skipper
  # this class is partially copy/pasted from Byebug::StepsCommand
  class StepsCommand < Byebug::Command
    def self.regexp
      /^ \s* s(?:tep)?s \s* $/x
    end

    def self.short_description
      "Same as `step` but skips garbage frames, e.g. from gems"
    end

    def self.description
      short_description
    end

    def execute
      HackyProcessor.hack_into(context)
    end

    class HackyProcessor < SimpleDelegator
      def self.hack_into(context)
        hack = new(context.send(:processor))
        context.instance_variable_set(:@processor, hack)
        hack.skip_this_frame!
      end

      def unhack!
        context.instance_variable_set(:@processor, __getobj__)
      end

      def skip_this_frame!
        context.step_into(1, context.frame.pos)
        proceed!
      end

      def at_line
        if Byebug::Skipper.skip?(context.location)
          skip_this_frame!
        else
          super
          unhack!
        end
      end
    end
  end
end
