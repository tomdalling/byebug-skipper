# Run this manual test with `bundle exec ruby spec/manual.rb` and follow the
# instructions in the comments.
#
# Replace "binding.pry" with "byebug" to test byebug standalone.
#

require 'pp'
require_relative '../lib/byebug/skipper/pry'

module MuhCode
  def self.pretty_print(pp)
    # Test #3: Use `ups` then `downs`. It should take you back to Test #2 and
    # back here again, bypassing PP.
    #
    # Test #4: Use `finishs`. It should take you back to Test #2 bypassing PP.
    pp.text('.-+* MuhCode *+-.')
  end
end


# Test #1
# -------
# Use `step` then `finish`. You should step into the Ruby standard library for
# PP
binding.pry
pp MuhCode

# Test #2
# -------
# Use `steps`. You should land in `MuhCode`, bypassing PP.
pp MuhCode
puts "Done."
