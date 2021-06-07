module Byebug::Skipper
  # this class is partially copy/pasted from Byebug::FinishsCommand
  class FinishsCommand < Byebug::Command
    include Byebug::Helpers::FrameHelper

    self.allow_in_post_mortem = false

    def self.regexp
      /^ \s* fin(?:ish)?s \s* $/x
    end

    def self.short_description
      "Same as `finish` but skips garbage frames, e.g. from gems"
    end

    def self.description
      <<~TXT
        finishs | fins

        #{short_description}
      TXT
    end

    def execute
      frame = context.frame

      loop do
        frame = Byebug::Frame.new(context, frame.pos + 1)
        next if frame.c_frame?
        break if out_of_bounds?(frame.pos)
        break if not Byebug::Skipper.skip?("#{frame.file}:#{frame.line}")
      end

      context.step_out(frame.pos, false)
      context.frame = 0
      processor.proceed!
    end
  end
end
