require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "serious"
    gem.summary = %Q{Serious is a simple, file-driven blog engine inspired by toto and driven by sinatra}
    gem.description = %Q{Serious is a simple, file-driven blog engine inspired by toto and driven by sinatra}
    gem.email = "christoph at olszowka dot de"
    gem.homepage = "http://github.com/colszowka/serious"
    gem.authors = ["Christoph Olszowka"]
    
    gem.bindir = 'bin'
    gem.executables = ['serious']
    gem.default_executable = 'serious'
    
    gem.add_dependency 'sinatra', ">= 0.9.4"
    gem.add_dependency 'stupid_formatter', '>= 0.2.0'
    gem.add_dependency 'builder', ">= 2.1.2"
    
    gem.add_development_dependency "shoulda", ">= 2.10.0"
    gem.add_development_dependency "hpricot", ">= 0.8.0"
    gem.add_development_dependency "rack-test", ">= 0.5.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "serious #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
