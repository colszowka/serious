require 'helper'
require 'fileutils'

#
# Tests for the serious executable
# 
class TestBin < Test::Unit::TestCase
  context "In tmp" do
    setup do
      @original_working_dir ||= Dir.getwd
      Dir.chdir(File.dirname(__FILE__))
      FileUtils.mkdir('tmp') if not File.exist?('tmp')
      Dir.chdir('tmp')
    end
    
    when_running_serious_with '' do
      should_print "Usage: serious DIRNAME"
      should_print "Note: Only lowercase letters and dashes ('-') are allowed for DIRNAME"
    end
    
    when_running_serious_with '-foo-' do
      should_print "Only lowercase-letters and '-' allowed in dirname!"
      should_not_have_path '-foo-'
    end
    
    when_running_serious_with 'foo-123' do
      should_print "Only lowercase-letters and '-' allowed in dirname!"
    end
    
    when_running_serious_with 'foo-ABC' do
      should_print "Only lowercase-letters and '-' allowed in dirname!"
    end
    
    when_running_serious_with 'foo_bar' do
      should_print "Only lowercase-letters and '-' allowed in dirname!"
    end
    
    when_running_serious_with 'foo' do
      should_have_dir 'foo/articles'
      should_have_dir 'foo/pages'
      should_have_dir 'foo/.git'
      should_have_file 'foo/.gems', 'serious --version'
      should_not_have_path 'foo/public'
      should_not_have_path 'foo/views'
      
      should "match git log with 'Initial commit'" do
        Dir.chdir('foo')
        assert_match /Initial commit/, `git log`
        Dir.chdir('..')
      end
      
      should_have_file 'foo/pages/about.txt' do |file| 
        should_contain "title: About", file
        should_contain "Something about you", file
      end
      
      should_have_file 'foo/config.ru' do |file| 
        should_contain "require 'serious'", file
        should_contain "Serious.set :title, 'foo'", file
        should_contain "Serious.set :author, 'Your Name here'", file
        should_contain "Serious.set :url, 'http://foo.heroku.com'", file
        should_contain "run Serious", file
      end
      
      should_have_file 'foo/Rakefile' do |file|
        should_contain "require 'serious'", file
        should_contain "require 'serious/tasks'", file
      end
      
      when_running_serious_with 'foo', '', false do
        should("respond with 'foo exists!'") { assert_match /foo exists\!/, @output }
      end
    end
    
    when_running_serious_with 'public-included', '--public' do
      should_have_dir 'public-included/articles'
      should_not_have_path 'public-included/views'
      should_have_file 'public-included/.gems'
      should_have_file 'public-included/config.ru' do |file|
        should_contain "Serious.set :public, File.join(Dir.getwd, 'public')"
        should_not_contain ":views"
        should_not_contain ":root"        
      end
      should_have_file "public-included/public/css/serious.css"
    end
    
    when_running_serious_with 'views-included', '--views' do
      should_have_dir 'views-included/articles'
      should_not_have_path 'views-included/public'
      should_have_file 'views-included/.gems'
      should_have_file 'views-included/config.ru' do |file|
        should_contain "Serious.set :views, File.join(Dir.getwd, 'views')"
        should_not_contain ":public"
        should_not_contain ":root"        
      end
      should_have_file "views-included/views/layout.erb"
    end
    
    when_running_serious_with 'views-and-public', '--views --public' do
      should_have_dir 'views-and-public/articles'
      should_have_file 'views-and-public/.gems'
      should_have_file 'views-and-public/config.ru' do |file|
        should_contain "Serious.set :root, Dir.getwd"
        should_not_contain ":public"
        should_not_contain ":views"        
      end
      should_have_file "views-and-public/public/css/serious.css"
      should_have_file "views-and-public/views/layout.erb"
    end
    
    when_running_serious_with 'no-git', '--no-git' do
      should_not_have_path 'no-git/.git'
    end
    
    teardown do
      Dir.chdir(@original_working_dir)
    end
  end
  
  # Run this only once...
  context "zzz" do
    should "remove tmp at the end" do
      FileUtils.rm_rf File.expand_path(File.join(File.dirname(__FILE__), 'tmp'))
    end
  end
  
  def serious(site_name="", arguments="", cache=true)
    if cache
      @cache ||= {}
      return @cache[site_name] if @cache[site_name]
    end
    
    executable = File.expand_path(File.join(File.dirname(__FILE__), '..', '../../bin/serious'))
    output = `#{executable} #{site_name} #{arguments}`
    @cache[site_name] = output if cache
    output
  end
  
end
