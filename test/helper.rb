require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rack/test'
require 'hpricot'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'serious'

class Test::Unit::TestCase
  include Rack::Test::Methods
  Serious.root = File.dirname(__FILE__)
  StupidFormatter.chain = [StupidFormatter::Erb, StupidFormatter::RDiscount]

  def app
    Serious
  end
  
  def self.should_contain_elements(count, selector)
    should "contan #{count} elements in '#{selector}'" do
      doc = Hpricot.parse(last_response.body)
      assert_equal count, (doc/selector).size
    end
  end
  
  def self.should_respond_with(status)
    should "respond with #{status}" do
      assert_equal status, last_response.status
    end
  end
  
  def self.should_contain_text(text, selector)
    should "contain '#{text}' in '#{selector}'" do
      doc = Hpricot.parse(last_response.body)
      assert_match /#{text}/, (doc/selector).inner_html
    end
  end
  
  def self.should_not_contain_text(text, selector)
    should "not contain '#{text}' in '#{selector}'" do
      doc = Hpricot.parse(last_response.body)
      assert_no_match /#{text}/, (doc/selector).inner_html
    end
  end
end
