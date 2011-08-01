# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "serious/version"

Gem::Specification.new do |s|
  s.name        = "serious"
  s.version     = SERIOUS_VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Christoph Olszowka"]
  s.email       = ["christoph at olszowka de"]
  s.homepage    = "https://github.com/colszowka/serious"
  s.summary     = %Q{Serious is a simple, file-driven blog engine inspired by toto and driven by sinatra with an emphasis on easy setup}
  s.description = %Q{Serious is a simple, file-driven blog engine inspired by toto and driven by sinatra with an emphasis on easy setup}

  s.rubyforge_project = "serious"
  
  s.bindir = 'bin'
  s.executables = ['serious']
  
  s.add_dependency 'sinatra', ">= 1.0.0"
  s.add_dependency 'stupid_formatter', '>= 0.2.0'
  s.add_dependency 'builder', ">= 2.1.2"
  
  s.add_development_dependency "shoulda", "2.10.3"
  s.add_development_dependency "hpricot", ">= 0.8.0"
  s.add_development_dependency "rack-test", ">= 0.5.0"
  s.add_development_dependency "rake", ">= 0.8.7"
  s.add_development_dependency "rdoc"
  s.add_development_dependency 'simplecov'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
