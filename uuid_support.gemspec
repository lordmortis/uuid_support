# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "uuid_support/version"

Gem::Specification.new do |s|
  s.name        = "uuid_support"
  s.version     = UuidSupport::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brendan Ragan"]
  s.email       = ["lordmortis@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/uuid_support"
  s.summary     = %q{Implements proper UUID support for ActiveRecord/Rails 3}
  s.description = %q{Implements a "uuid" and "uuid_pkey" type for ActiveRecord/Rails 3}

  s.rubyforge_project = "uuid_support"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

	s.add_dependency("uuidtools", '>= 2.1.1')
end
