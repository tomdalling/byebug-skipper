module Byebug::Skipper
  # this class is partially copy/pasted from Byebug::DownCommand
  class DownsCommand < Byebug::Command
    include Byebug::Helpers::FrameHelper

    self.allow_in_post_mortem = true

    def self.regexp
      /^ \s* downs \s* $/x
    end

    def self.short_description
      "Same as `down` but skips garbage frames, e.g. from gems"
    end

    def self.description
      short_description
    end

    def execute
      loop do
        break if out_of_bounds?(context.frame.pos - 1)
        jump_frames(-1)
        break if not Byebug::Skipper.skip?(context.location)
      end

      Byebug::ListCommand.new(processor).execute if Byebug::Setting[:autolist]
    end
  end
end
