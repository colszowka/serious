require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'rack/test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'serious'

class Test::Unit::TestCase
  include Rack::Test::Methods
  Serious.root = File.dirname(__FILE__)

  def app
    Serious
  end
end
