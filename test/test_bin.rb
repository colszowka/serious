# encoding: utf-8
require 'helper'
require 'fileutils'

#
# Tests for the serious executable
# TODO: Tests for git repo creation
# 
class TestBin < Test::Unit::TestCase
  context "In tmp folder" do
    setup do
      @original_working_dir ||= Dir.getwd
      Dir.chdir(File.dirname(__FILE__))
      FileUtils.mkdir('tmp') if not File.exist?('tmp')
      Dir.chdir('tmp')
    end

    when_running_serious_with '' do
      should_print "Usage: serious DIRNAME"
      should_print "Only lowercase letters and dashes"
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
    
    when_running_serious_with 'foo', '--no-git' do
      should_have_dir 'foo/articles'
      should_have_dir 'foo/pages'
      should_have_file 'foo/Gemfile', 'gem "serious"'
      should_not_have_path 'foo/public'
      should_not_have_path 'foo/views'
      should_have_git_commit 'foo', 'Initial commit'
      
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
      
      when_running_serious_with 'foo', '--no-git', false do
        should_print 'foo exists'
      end
    end
    
    when_running_serious_with 'public-included', '--no-git --public' do
      should_have_dir 'public-included/articles'
      should_not_have_path 'public-included/views'
      should_have_file 'public-included/Gemfile'
      should_have_file 'public-included/config.ru' do |file|
        should_contain "Serious.set :public, File.join\(Dir.getwd, 'public'\)", file
        should_not_contain ":views", file
        should_not_contain ":root", file        
      end
      should_have_file "public-included/public/css/serious.css"
      should_have_file "public-included/public/css/application.css"
    end
    
    when_running_serious_with 'views-included', '--no-git --views' do
      should_have_dir 'views-included/articles'
      should_not_have_path 'views-included/public'
      should_have_file 'views-included/Gemfile'
      should_have_file 'views-included/config.ru' do |file|
        should_contain "Serious.set :views, File.join\(Dir.getwd, 'views'\)", file
        should_not_contain ":public", file
        should_not_contain ":root", file
      end
      should_have_file "views-included/views/layout.erb"
    end
    
    when_running_serious_with 'views-and-public', '--no-git --views --public' do
      should_have_dir 'views-and-public/articles'
      should_have_file 'views-and-public/Gemfile'
      should_have_file 'views-and-public/config.ru' do |file|
        should_contain "Serious.set :root, Dir.getwd", file
        should_not_contain ":public", file
        should_not_contain ":views", file
      end
      should_have_file "views-and-public/public/css/serious.css"
      should_have_file "views-and-public/public/css/application.css"
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
      FileUtils.rm_rf File.expand_path('../tmp', __FILE__)
    end
  end
  
end
