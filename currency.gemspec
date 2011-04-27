require 'rubygems'
SPEC = Gem::Specification.new do |s|
  s.name = "mumboe-currency"
  s.version = "0.6"
  s.date = "2011-04-26"
  s.author = "John Liu & Eric Stewart"
  s.email = "johnl@mumboe.com"
  s.homepage = "http://rubyforge.org/projects/currency/"
  s.platform = Gem::Platform::RUBY
  s.summary = "Fixed unwanted side-effects by avoiding shared factory and floating point rounding errors"
  s.files = Dir.glob("{bin,examples,lib,test}/**/*")
  s.require_path = "lib"
  s.executables = [ "currency_historical_rate_load" ]
  s.test_file = "test/test_base.rb"
  s.has_rdoc = false
end