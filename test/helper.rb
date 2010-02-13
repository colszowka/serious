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
  Serious.set :title, "Serious Test Blog"
  Serious.set :articles, File.join(File.dirname(__FILE__), 'articles')
  Serious.set :pages, File.join(File.dirname(__FILE__), 'pages')
  Serious.set :author, "TheDeadSerious"
  Serious.set :url, 'http://example.com'
  StupidFormatter.chain = [StupidFormatter::Erb, StupidFormatter::RDiscount]

  def app
    Serious
  end
  
  def self.should_contain_elements(count, selector)
    should "contain #{count} elements in '#{selector}'" do
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
  
  def self.should_contain_attribute(attribute, text, selector)
    should "contain '#{text}' in '#{selector}' #{attribute}" do
      doc = Hpricot.parse(last_response.body)
      assert_equal text, (doc/selector).first[attribute]
    end
  end
  
  def self.should_set_cache_control_to(seconds)
    should "set Cache-Control header with timeout of #{seconds} seconds" do
      assert_equal "public, max-age=#{Serious.cache_timeout}", last_response.headers['Cache-Control']
    end
  end
  
  def self.should_slugize(input, expectation)
    should "return '#{expectation}' for '#{input}'.slugize" do
      assert_equal expectation, input.slugize
    end
  end
  
  def self.should_have_file(name, content=nil)
    should "have file #{name}" do
      assert File.exist?(name), "#{name} does not exist"
    end
    
    if content and not block_given?
      should "have content in file #{name} match /#{content}/" do
        assert_match /#{content}/, File.read(name)
      end
    end
    
    yield(File.read(name)) if block_given? and File.exist?(name)
  end
  
  def self.should_have_dir(name)
    should "have directory #{name}" do
      assert File.directory?(name), "#{name} is not a directory"
    end
  end
  
  def self.should_not_have_path(name)
    should "not have directory #{name}" do
      assert !File.exist?(name), "#{name} exists!"
    end
  end
  
  def self.should_contain(expect, item)
    should "contain #{expect}" do
      assert_match /#{expect}/, item
    end
  end
  
  def self.should_not_contain(expect, item)
    should "not contain #{expect}" do
      assert_no_match /#{expect}/, item
    end
  end
  
  def self.when_running_serious_with(site_name, arguments="", cache=true)
    context "when running serious #{site_name} #{arguments}" do
      setup { assert @output = serious(site_name, arguments, cache) }
    end
  end
  
  def self.should_print(expect)
    should("print #{expect}") do
      assert_match /#{expect}/, @output
    end
  end
end
