require_relative 'lib/byebug/skipper/version'

Gem::Specification.new do |s|
  s.name = 'byebug-skipper'
  s.version = Byebug::Skipper::VERSION
  s.licenses = ['MIT']
  s.authors = ['Tom Dalling']
  s.email = ['tom', '@', 'tomdalling', '.', 'com'].join
  s.homepage = 'https://github.com/tomdalling/byebug-skipper'
  s.summary = 'Additional commands for Byebug that skip over garbage frames'
  s.description = s.summary
  s.files = Dir.glob('lib/**/*.rb')

  s.add_dependency 'byebug'
  s.add_development_dependency 'rspec'
end
