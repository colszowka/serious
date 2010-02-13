require 'helper'

#
# Tests for the Ruby Extensions
# 
class TestRubyExt < Test::Unit::TestCase
  # ========================================================================
  # Tests for formatted date 
  # ========================================================================
  context "With Serious.date_format set to '%Y-%m-%d'" do
    setup do
      @original_format = Serious.date_format
      Serious.set :date_format, "%Y-%m-%d"
    end
    
    should "return '2009-12-13' for Date.new(2009, 12, 13).formatted" do 
      assert_equal '2009-12-13', Date.new(2009, 12, 13).formatted
    end
    
    should "return '2010-01-09' for Date.new(2010, 1, 9).formatted" do 
      assert_equal '2010-01-09', Date.new(2010, 1, 9).formatted
    end
    
    teardown do
      Serious.set :date_format, @original_format
    end
  end
  
  context "With Serious.date_format set to '%a, %B %d, %Y'" do
    setup do
      @original_format = Serious.date_format
      Serious.set :date_format, "%a, %B %d, %Y"
    end
    
    should "return 'Sat, February 13 2010' for Date.new(2010, 2, 13).formatted" do 
      assert_equal 'Sat, February 13, 2010', Date.new(2010, 2, 13).formatted
    end
    
    teardown do
      Serious.set :date_format, @original_format
    end    
  end
  
  context 'With Serious.date_format set to "%B %o %Y"' do
    setup do
      @original_format = Serious.date_format
      Serious.set :date_format, "%B %o %Y"
    end
    
    should "return 'February 12th 2010' for Date.new(2010, 2, 12).formatted" do 
      assert_equal 'February 12th 2010', Date.new(2010, 2, 12).formatted
    end
    
    teardown do
      Serious.set :date_format, @original_format
    end
  end
  
  # ========================================================================
  # Tests for ordinal
  # ========================================================================
  
  should("return '1st' for 1.ordinal") { assert_equal '1st', 1.ordinal}
  should("return '2nd' for 2.ordinal") { assert_equal '2nd', 2.ordinal}
  should("return '3rd' for 3.ordinal") { assert_equal '3rd', 3.ordinal}
  should("return '4th' for 4.ordinal") { assert_equal '4th', 4.ordinal}
  should("return '31st' for 31.ordinal") { assert_equal '31st', 31.ordinal}
  
  # ========================================================================
  # Tests for slugize
  # ========================================================================
  should_slugize 'Foo Bar Baz', 'foo-bar-baz'
  should_slugize ' Foo Bar_Baz ', 'foo-bar-baz'
  should_slugize 'A Crazy Title with: Special Chars!', 'a-crazy-title-with-special-chars'
  should_slugize 'We have 0123 numbers in here', 'we-have-0123-numbers-in-here'
  should_slugize 'and we have !? more special char$', 'and-we-have-more-special-char'
  should_slugize 'should--squeeze$', 'should-squeeze'
  
end
