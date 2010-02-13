require 'helper'

class TestPage < Test::Unit::TestCase
  # ========================================================================
  # Tests for all pages
  # ========================================================================
  context "Serious::Page.all" do
    setup do
      @pages = Serious::Page.all
    end
    
    should("return 2 pages") { assert_equal 2, @pages.length }
    should "have only instances of Serious::Page in the collection" do
      assert @pages.all? {|a| a.instance_of?(Serious::Page) }
    end
    
    should "return an existing path for all pages" do
      assert @pages.all? {|p| File.exist? p.path }
    end
    
    should "not have instance variable @yaml set on any page" do
      @pages.each do |page|
        assert_nil page.instance_variable_get(:@yaml)
      end
    end
    
    should "not have instance variable @content set on any page" do
      @pages.each do |page|
        assert_nil page.instance_variable_get(:@content)
      end
    end
  end
  
  # ========================================================================
  # Tests for initializer and extracting permalink from path
  # ========================================================================
  context "Serious::Page.new('foo-bar.txt')" do
    setup do
      @page = Serious::Page.new('foo-bar.txt')
    end
    
    should "return permalink 'foo-bar'" do
      assert_equal 'foo-bar', @page.permalink
    end
    
    should "return '/pages/foo-bar' as url" do
      assert_equal '/pages/foo-bar', @page.url
    end
    
    should "return 'http://example.com/pages/foo-bar' as full_url" do
      assert_equal 'http://example.com/pages/foo-bar', @page.full_url
    end
  end
  
  # ========================================================================
  # Tests for dynamic loading and processing of title, summary and body
  # ========================================================================
  context "The page 'about'" do
    setup do
      @page = Serious::Page.find('about')
    end
    
    context "after getting the page's title" do
      setup { @title = @page.title }
      
      should "have returned 'About me'" do
        assert_equal 'About me', @title
      end
      
      should "have initialized the @yaml instance variable to a hash" do
        assert @page.instance_variable_get(:@yaml).kind_of?(Hash)
      end
      
      should "have initialized the @content instance variable to a string" do
        assert @page.instance_variable_get(:@content).kind_of?(String)
      end
      
      should "have summary set to 'Some text about me'" do
        assert_equal 'Some text about me', @page.summary
      end
      
      should 'have formatted body set to "<p>Some text about me</p>\n\n<p>And some more content with erb</p>\n"' do
        assert_equal "<p>Some text about me</p>\n\n<p>And some more content with erb</p>\n", @page.body.formatted
      end
    end
  end
  
  context "The page 'foo-bar'" do
    setup do
      @page = Serious::Page.find('foo-bar')
    end
    
    should "be valid" do
      assert @page.valid?
    end
    should("have title 'Foo Bar'") { assert_equal 'Foo Bar', @page.title }
    should('have summary "Baz!"')  { assert_equal "Baz!", @page.summary }
    should('have body "Baz!"')     { assert_equal "Baz!", @page.body }
    should('have summary equal to body') { assert_equal @page.summary, @page.body}
  end
end
