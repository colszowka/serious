require 'helper'

class TestSerious < Test::Unit::TestCase

  context "GET /" do
    setup { get '/' }
    
    should_contain_elements 3, "ul#articles li"
    should_contain_text "Merry Christmas!", "ul#articles li:first"
    should_contain_text "Ruby is the shit!", "ul#articles"
    should_contain_text "Foo Bar", "ul#articles"
    
    should_contain_elements 1, "ul#archives li"
    should_contain_text "Disco 2000", "ul#archives li:first"
  end
  
  context "GET /2009" do
    setup { get '/2009' }
    
    should_contain_text "Archives for 2009", "#container h2:first"
    should_contain_elements 3, "ul#archives li"
    should_contain_text "Merry Christmas!", "ul#archives li:first"
    should_contain_text "Ruby is the shit!", "ul#archives"
    should_contain_text "Foo Bar", "ul#archives"
  end
  
  context "GET /2009/12" do
    setup { get '/2009/12' }
    
    should_contain_text "Archives for 2009-12", "#container h2:first"
    should_contain_elements 2, "ul#archives li"
    should_contain_text "Merry Christmas!", "ul#archives li:first"
    should_contain_text "Ruby is the shit!", "ul#archives"
  end  
  
  context "GET /2009/12/11" do
    setup { get '/2009/12/11' }
    
    should_contain_text "Archives for 2009-12-11", "#container h2:first"
    should_contain_elements 1, "ul#archives li"
    should_contain_text "Ruby is the shit!", "ul#archives li:first"
  end  
  
end
