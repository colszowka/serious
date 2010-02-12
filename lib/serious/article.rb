#
# Backend for file-system based articles
#
class Serious::Article
  class << self
    #
    # Returns all articles. Can be drilled down by (optional) :limit and :offset options
    #
    def all(options={})
      options = {:limit => 10000, :offset => 0}.merge(options)
      (article_paths[options[:offset]...options[:limit]+options[:offset]] || []).map {|article_path| new(article_path) }
    end
    
    #
    # Retrieves the article(s) for the given arguments. The arguments must be part of the filename.
    # You can give any combination, but the arguments must appear in the same order as given in the
    # arguments, so find(2009, 11) works for all articles in november 2009, 
    # find('foo-bar') works for all articles with permalink 'foo-bar', but find(2009, 'foo-bar')
    # will not return anything.
    #
    def find(*args)
      articles = article_paths.select {|path| File.basename(path) =~ /#{args.join('-')}/i }.map {|path| new(path) }
      articles.length == 1 ? articles.first : articles
    end
    
    private
    
      # Returns all article files in articles path
      def article_paths
        @article_paths ||= Dir[File.join(Serious.articles, '*')].sort.reverse
      end
  end
  
  attr_reader :path, :date, :permalink
  
  def initialize(path)
    @path = path
    extract_date_and_permalink!
    # TODO: Add some nice error handling!
  end
  
  # Lazy-loading title accessor
  def title
    @title ||= yaml["title"]
  end
  
  # Cached lazy-loading of summary
  def summary
    return @summary if @summary
    @summary ||= content.split("~", 2).first.chomp
  end
  
  # Cached lazy-loading of body
  def body
    return @body if @body
    @body ||= content.split("~", 2).join("").chomp
  end
  
  # Compiles the url for this article
  def url
    "/#{date.year}/#{"%02d" % date.month}/#{"%02d" % date.day}/#{permalink}"
  end
  
  private
  
    # Will extract the date and permalink from the filename.
    def extract_date_and_permalink!
      match = File.basename(path).match(/(\d{4})-(\d{1,2})-(\d{1,2})-([^\.]+)/)
      @date = Date.new(match[1].to_i, match[2].to_i, match[3].to_i)
      @permalink = match[4]
    end
    
    #
    # Will read the actual article file and store the yaml front processed in @yaml,
    # the content in @content
    #
    def load!
      return [@yaml, @content] if @yaml and @content
      yaml, @content = File.read(path).split(/\n\n/, 2)
      @yaml = YAML.load(yaml)
    end
    
    # Cached lazy-loading yaml config
    def yaml
      return @yaml if @yaml
      load!
      @yaml 
    end
    
    # Cached lazy-loading content
    def content
      return @content if @content
      load!
      @content
    end
end
