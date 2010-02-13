class Serious::Page < Serious::Article
  class << self
    #
    # Returns all pages
    #
    def all
      @all ||= page_paths.map { |path| new(path) }
    end
    
    def find(permalink)
      all.find_all {|page| page.permalink == permalink }.first
    end
    
    private
    
      # Returns all page files in pages path
      def page_paths
        @pages_paths ||= Dir[File.join(Serious.pages, '*')].sort
      end
  end
  
  def url
    "/pages/#{permalink}"
  end
  
  private
  
    # Will extract the permalink from the filename.
    def extract_date_and_permalink!
      @permalink = File.basename(path).split('.')[0...-1].join("")
    end
end
