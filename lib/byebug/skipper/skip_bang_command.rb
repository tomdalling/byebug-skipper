module Byebug::Skipper
  class SkipBangCommand < Byebug::SkipCommand
    def self.regexp
      /^ \s* skip! \s* $/x
    end

    def self.short_description
      "Same as `skip` but also comments out the line before the current one (where `byebug` or `binding.pry` usually is)"
    end

    def self.description
      short_description
    end

    def execute
      CommentLineAbove.(context.location)
      super
    end
  end
end
