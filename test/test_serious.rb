require 'helper'

class TestSerious < Test::Unit::TestCase
  def test_my_default
    get '/'
    assert_match /ul id="articles"/, last_response.body
  end
end
