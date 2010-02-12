require 'rubygems'
gem 'sinatra', '~> 0.9.4'
require 'sinatra/base'
require 'stupid_formatter'
require 'yaml'

class Serious < Sinatra::Base
  
  set :articles, Proc.new { File.join(root, 'articles') }
  
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
    
    def render_article(article, summary_only=false)
      render :erb, :'_article', :locals => { :article => article, :summary_only => summary_only }, :layout => !summary_only
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
    render_article @article
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
Serious.set :root, Dir.getwd
