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
  
  not_found do
    erb :"404"
  end
  
  helpers do
    def format(text)
      StupidFormatter.result(text)
    end
    
    # Helper for rendering partial _archives
    def render_archived(articles)
      render :erb, :'_archives', :locals => { :articles => articles }, :layout => false
    end
  end

  get '/' do
    @recent = Article.all(:limit => 3)
    @archived = Article.all(:limit => 10, :offset => 3)
    erb :index
  end
  
  # Specific article route
  get %r{^/(\d{4})/(\d{1,2})/(\d{1,2})/([^\\]+)} do
    halt 404 unless @article = Article.first(*params[:captures])
    erb :article
  end
  
  # Archives route
  get %r{^/(\d{4})[/]{0,1}(\d{0,2})[/]{0,1}(\d{0,2})[/]{0,1}$} do
    @selection = params[:captures].reject {|s| s.strip.length == 0 }.map {|n| n.length == 1 ? "%02d" % n : n}
    @articles = Article.find(*@selection)
    erb :archives
  end
  
  get "/archives" do
    @articles = Article.all
    erb :archives
  end
end

$:.unshift File.dirname(__FILE__)
require 'serious/article'
# Set up default stupid_formatter chain
StupidFormatter.chain = [StupidFormatter::Erb, StupidFormatter::RDiscount]
