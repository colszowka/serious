require 'helper'

class TestSerious < Test::Unit::TestCase

  # ===================================================================
  # Tests for the main page
  # ===================================================================
  context "GET /" do
    setup { get '/' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    
    should_contain_text "Serious Test Blog", "#header h1 a"
    
    should_contain_elements 3, "ul#articles li"
    should_contain_text "Merry Christmas!", "ul#articles li:first"
    should_contain_text "Merry christmas, dear reader!", "ul#articles li:first"
    should_contain_text "December 24th 2009", "ul#articles li:first .date"
    
    should_not_contain_text "Lorem ipsum dolor...", "ul#articles li:first"
    
    should_contain_text "Ruby is the shit!", "ul#articles"
    should_contain_text "Some kind of introduction and summary", "ul#articles li"
    should_not_contain_text "The number is 4", "ul#articles li"
    
    should_contain_text "Foo Bar", "ul#articles"
    should_contain_text "Serious Test Blog", "head title"
    
    should_contain_elements 1, "ul.archives li"
    should_contain_text "Disco 2000", "ul.archives li:first"
  end
  
  # ===================================================================
  # Tests for the Archives
  # ===================================================================
  context "GET /2009" do
    setup { get '/2009' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    should_contain_text "Archives for 2009", "#container h2:first"
    should_contain_elements 3, "ul.archives li"
    should_contain_text "Merry Christmas!", "ul.archives li:first"
    should_contain_text "Ruby is the shit!", "ul.archives"
    should_contain_text "Foo Bar", "ul.archives"
  end
  
  context "GET /2009/12" do
    setup { get '/2009/12' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    should_contain_text "Archives for 2009-12", "#container h2:first"
    should_contain_text 'December 24th 2009', "ul.archives li"
    should_contain_elements 2, "ul.archives li"
    should_contain_text "Merry Christmas!", "ul.archives li:first"
    should_contain_text "Ruby is the shit!", "ul.archives"
  end  
  
  context "GET /2009/12/11" do
    setup { get '/2009/12/11' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    should_contain_text "Archives for 2009-12-11", "#container h2:first"
    should_contain_elements 1, "ul.archives li"
    should_contain_text "Ruby is the shit!", "ul.archives li:first"
  end  
  
  context "GET /2000/" do
    setup { get '/2000' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    should_contain_text "Archives for 2000", "#container h2:first"
    should_contain_elements 1, "ul.archives li"
    should_contain_text "Disco 2000", "ul.archives li:first"
  end  
  
  context "GET /2005/" do
    setup { get '/2005' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    should_contain_text "Archives for 2005", "#container h2:first"
    should_contain_elements 0, "ul.archives li"
  end  
  
  context "GET /2000/1" do
    setup { get '/2000/1' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    should_contain_text "Archives for 2000-01", "#container h2:first"
    should_contain_elements 1, "ul.archives li"
    should_contain_text "Disco 2000", "ul.archives li:first"
  end
  
  context "GET /2000/1/01" do
    setup { get '/2000/1/01' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    should_contain_text "Archives for 2000-01-01", "#container h2:first"
    should_contain_elements 1, "ul.archives li"
    should_contain_text "Disco 2000", "ul.archives li:first"
  end
  
  context "GET /archives" do
    setup { get '/archives' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    should_contain_text "Archives", "#container h2:first"
    should_contain_elements 4, "ul.archives li"
    should_contain_text "Merry Christmas!", "ul.archives li:first"
    should_contain_text "Ruby is the shit!", "ul.archives"
    should_contain_text "Foo Bar", "ul.archives"
    should_contain_text "Disco 2000", "ul.archives li:last"
  end
  
  # ===================================================================
  # Tests for the article view
  # ===================================================================
  
  context "GET /2009/12/24/merry-christmas" do
    setup { get '/2009/12/24/merry-christmas' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    should_contain_text "Merry Christmas!", "#container h2:first"
    should_contain_text "Merry Christmas! - Serious Test Blog", "head title"
    should_contain_text "Merry christmas, dear reader!", ".article .body"
    should_contain_text "Lorem ipsum dolor...", ".article .body"
  end
  
  context "GET /2009/12/11/ruby-is-the-shit" do
    setup { get '/2009/12/11/ruby-is-the-shit' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    should_contain_text "Ruby is the shit!", "#container h2:first"
    should_contain_text "Some kind of introduction and summary", ".article .body"
    # Erb should evaluate properly
    should_contain_text "The number is 4", ".article .body"
  end
  
  context "GET /2000/1/1/disco-2000" do
    setup { get '/2000/1/1/disco-2000' }
    
    should_respond_with 200
    should_set_cache_control_to 300
    should_contain_text "Disco 2000", "#container h2:first"
    should_contain_text "Well we were born within one hour of each other.", ".article .body"
    # Markdown should evaluate properly
    should_contain_text "by Pulp", ".article .body h3:first"
  end
  
  context "GET /2009/1/1/disco-2000" do
    setup { get '/2009/1/1/disco-2000' }
    
    should_respond_with 404
    should_set_cache_control_to 300
    should_contain_text "The requested page could not be found!", "#container h2:first"
    should_not_contain_text "Well we were born within one hour of each other.", ".article .body"
  end
  
  # ===================================================================
  # Tests for the public folder
  # ===================================================================
  context "GET /css/serious.css" do
    setup { get '/css/serious.css' }
    should_respond_with 200
  end
  
  context "GET /foobar.baz" do
    setup { get '/foobar.baz' }
    should_respond_with 404
  end
  
  # ===================================================================
  # Tests for the atom feed
  # ===================================================================
  context "GET /atom.xml" do
    setup { get '/atom.xml' }
    should_respond_with 200
    should_set_cache_control_to 300
    
    should_contain_text "Merry Christmas!", "feed entry:first title"
    should_contain_text "Christoph Olszowka", "feed entry:first author name:first"
  end
end
