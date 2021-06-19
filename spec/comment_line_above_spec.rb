# frozen_string_literal: true

RSpec.describe Byebug::Skipper::CommentLineAbove do
  subject do
    described_class.(location)
    File.read(tempfile.path)
  end
  let(:location) { "#{tempfile.path}:#{line_number}" }
  let(:line_number) do
    file_contents.lines.index { _1.strip == 'stop_here' } + 1
  end
  let(:tempfile) { Tempfile.new }

  around do |example|
    tempfile.write(file_contents)
    tempfile.close
    example.()
  ensure
    tempfile.unlink
  end

  context 'with "byebug" on the previous line' do
    let(:file_contents) { <<~RUBY }
      def whatever
        byebug
        stop_here
      end
    RUBY

    it 'comments out the "byebug" line' do
      expect(subject).to eq(<<~RUBY)
        def whatever
          # byebug
          stop_here
        end
      RUBY
    end
  end

  context 'with empty lines and comments before the "byebug" line' do
    let(:file_contents) { <<~RUBY }
      def whatever
        byebug

        # some comment here

        stop_here
      end
    RUBY

    it 'comments out the "byebug" line' do
      expect(subject).to eq(<<~RUBY)
        def whatever
          # byebug

          # some comment here

          stop_here
        end
      RUBY
    end
  end
end
