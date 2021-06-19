# frozen_string_literal: true

module Byebug::Skipper
  module CommentLineAbove
    extend self

    def call(location)
      path, _, line_no = location.rpartition(':')
      lines = File.readlines(path)

      idx = Integer(line_no) - 2
      while ignore_line?(lines[idx])
        idx -= 1
        return if idx < 0 # tried to go above the first line of the file, so abort
      end

      lines[idx] = comment_out(lines.fetch(idx))
      File.write(path, lines.join)
    end

    private

      def comment_out(line)
        line.sub(/\A\s*/, '\0# ')
      end

      def ignore_line?(line)
        line.strip.empty? || line.strip.start_with?('#')
      end
  end
end
