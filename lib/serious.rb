require 'rubygems'
gem 'sinatra', '~> 0.9.4'
require 'sinatra'
require 'stupid_formatter'

class Serious < Sinatra::Application
  class << self
    # Get the current root directory. Defaults to current working directory.
    def root(*args)
      @root ||= Dir.getwd
    end
    # Update the root directory to given path. set_paths will be invoked after updating the 
    # root path to reflect the changes.
    def root=(root)
      @root = root
      set_paths
      @root
    end
    
    # Updates views and public paths as subdirectories of root
    def set_paths
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
    erb :article
  end
end
