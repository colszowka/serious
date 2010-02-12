require 'rubygems'
gem 'sinatra', '~> 0.9.4'
require 'sinatra/base'
require 'stupid_formatter'
require 'yaml'

class Serious < Sinatra::Base
  class << self
    # Get the current root directory. Defaults to current working directory.
    def root(*args)
      @root ||= Dir.getwd
    end
    # Update the root directory to given path. set_paths will be invoked after updating the 
    # root path to reflect the changes.
    def root=(root)
      @root = root
      update_paths
      @root
    end
    
    # Updates views and public paths as subdirectories of root
    def update_paths
      set :views, File.join(root, 'views')
      set :public, File.join(root, 'public')
      set :articles, File.join(root, 'articles')
    end
  end
  
  helpers do
    def format(text)
      StupidFormatter.result(text)
    end
  end

  get '/' do
    @articles = Article.all
    erb :index
  end
end

$:.unshift File.dirname(__FILE__)
require 'serious/article'
