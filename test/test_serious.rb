require 'helper'

class TestSerious < Test::Unit::TestCase
  def test_my_default
    get '/'
    assert_match /ul id="articles"/, last_response.body
  end
  
  context "GET /" do
    setup { get '/' }
    
    should_contain_elements 3, "ul#articles li"
    should_contain_text "Merry Christmas!", "ul#articles li:first"
    should_contain_text "Ruby is the shit!", "ul#articles"
    should_contain_text "Foo Bar", "ul#articles"
    
    should_contain_elements 1, "ul#archives li"
    should_contain_text "Disco 2000", "ul#archives li:first"
  end
end
