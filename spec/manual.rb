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
byebug
pp MuhCode

# Test #2
# -------
# Use `steps`. You should land in `MuhCode`, bypassing PP.
pp MuhCode
puts "Go to Test #5 with `continue`"



file_before = File.read(__FILE__)
10.times do
  byebug # `skip!` currently doesn't work with Pry. `skip` is not available either.

# Test #5
# -------
# Use `skip!` to end testing (will print out success/failure)
end
if File.readlines(__FILE__).fetch(__LINE__ - 7).start_with?(/\s*# (byebug|binding\.pry)/)
  File.write(__FILE__, file_before) # undo the commenting
  puts "Done. (Test #5 was successful)"
else
  puts "Test failure: `skip!` command did not comment out the line!"
end
