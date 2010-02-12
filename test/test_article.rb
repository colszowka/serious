require 'helper'

class TestArticle < Test::Unit::TestCase
  # ========================================================================
  # Tests for all articles and limited all articles finder
  # ========================================================================
  context "Serious::Article.all" do
    setup do
      @articles = Serious::Article.all
    end
    
    should("return 4 articles") { assert_equal 4, @articles.length }
    should "have only instances of Serious::Article in the collection" do
      assert @articles.all? {|a| a.instance_of?(Serious::Article) }
    end
    
    should "return an existing path for all articles" do
      assert @articles.all? {|a| File.exist? a.path }
    end
    
    should "have 2009-12-24 as the first article's date" do
      assert_equal Date.new(2009, 12, 24), @articles.first.date
    end
    
    should "have 2000-01-01 as the last article's date" do
      assert_equal Date.new(2000, 1, 1), @articles.last.date
    end
    
    should "not have instance variable @yaml set on any article" do
      @articles.each do |article|
        assert_nil article.instance_variable_get(:@yaml)
      end
    end
    
    should "not have instance variable @content set on any article" do
      @articles.each do |article|
        assert_nil article.instance_variable_get(:@content)
      end
    end
  end
  
  context "Serious::Article.all(:limit => 2)" do
    setup do
      @articles = Serious::Article.all(:limit => 2)
    end
    
    should("return 2 articles") { assert_equal 2, @articles.length }
    
    should "have 2009-12-24 as the first article's date" do
      assert_equal Date.new(2009, 12, 24), @articles.first.date
    end
    
    should "have 2009-12-11 as the last article's date" do
      assert_equal Date.new(2009, 12, 11), @articles.last.date
    end
  end
  
  context "Serious::Article.all(:limit => 2, :offset => 2)" do
    setup do
      @articles = Serious::Article.all(:limit => 2, :offset => 2)
    end
    
    should("return 2 articles") { assert_equal 2, @articles.length }
    
    should "have 2009-04-01 as the first article's date" do
      assert_equal Date.new(2009, 4, 1), @articles.first.date
    end
    
    should "have 2000-01-01 as the last article's date" do
      assert_equal Date.new(2000, 1, 1), @articles.last.date
    end
  end
  
  context "Serious::Article.all(:limit => 50, :offset => 5)" do
    should "return an empty array" do
      assert_equal [], Serious::Article.all(:limit => 50, :offset => 5)
    end
  end
  
  # ========================================================================
  # Tests for initializer and extracting date and permalink from path
  # ========================================================================
  context "Serious::Article.new('2010-01-15-foo-bar.txt')" do
    setup do
      @article = Serious::Article.new('2010-01-15-foo-bar.txt')
    end
    
    should "return Date 2010-01-15" do
      assert_equal Date.new(2010, 1, 15), @article.date
    end
    
    should "return permalink 'foo-bar'" do
      assert_equal 'foo-bar', @article.permalink
    end
    
    should "return '/2010/01/15/foo-bar' as url" do
      assert_equal '/2010/01/15/foo-bar', @article.url
    end
  end
  
  # Making sure one-digit month and day work as well
  context "Serious::Article.new('2010-1-1-foo-bar.txt')" do
    setup do
      @article = Serious::Article.new('2010-1-1-foo-bar.txt')
    end
    
    should "return Date 2010-01-01" do
      assert_equal Date.new(2010, 1, 1), @article.date
    end
    
    should "return permalink 'foo-bar'" do
      assert_equal 'foo-bar', @article.permalink
    end
    
    should "return '/2010/01/01/foo-bar' as url" do
      assert_equal '/2010/01/01/foo-bar', @article.url
    end
  end
  
  context "Serious::Article.new('2010-02-16-some-text-for-permalink.txt')" do
    setup do
      @article = Serious::Article.new('2010-02-16-some-text-for-permalink.txt')
    end
    
    should "return Date 2010-02-16" do
      assert_equal Date.new(2010, 2, 16), @article.date
    end
    
    should "return permalink 'some-text-for-permalink'" do
      assert_equal 'some-text-for-permalink', @article.permalink
    end
    
    should "return '/2010/02/16/some-text-for-permalink' as url" do
      assert_equal '/2010/02/16/some-text-for-permalink', @article.url
    end
  end
  
  # ========================================================================
  # Tests for finder
  # ========================================================================
  context "When calling find with (2009, 12, 24, 'merry-christmas'), the returned article" do
    setup do
      @article = Serious::Article.find(2009, 12, 24, 'merry-christmas')
    end
    
    should "have date 2009-12-24" do
      assert_equal Date.new(2009, 12, 24), @article.date
    end
    
    should "have permalink 'merry-christmas'" do
      assert_equal 'merry-christmas', @article.permalink
    end
  end
  
  should "find article for date '2009, 12, 24' with Serious::Article.find('merry-christmas')" do
    assert_equal Date.new(2009, 12, 24), Serious::Article.find('merry-christmas').date
  end
  
  should "find article for date '2009, 12, 24' with Serious::Article.find(12, 24)" do
    assert_equal Date.new(2009, 12, 24), Serious::Article.find(12, 24).date
  end
  
  context "Serious::Article.find(2009, 12)" do
    setup do
      @articles = Serious::Article.find(2009, 12) 
    end
    
    should("have found 2 articles") { assert_equal 2, @articles.length }
    should "return article with permalink 'merry-christmas' first" do
      assert_equal 'merry-christmas', @articles.first.permalink
    end
    should "return article with permalink 'ruby-is-the-shit' last" do
      assert_equal 'ruby-is-the-shit', @articles.last.permalink
    end
  end
  
  # ========================================================================
  # Tests for dynamic loading and processing of title, summary and body
  # ========================================================================
  context "The article 'merry-christmas'" do
    setup do
      @article = Serious::Article.find('merry-christmas')
    end
    
    should "not have instance variable @yaml set" do
      assert_nil @article.instance_variable_get(:@yaml)
    end
    
    should "not have instance variable @content set" do
      assert_nil @article.instance_variable_get(:@content)
    end
    
    context "after getting the article's title" do
      setup { @title = @article.title }
      
      should "have returned 'Merry Christmas!'" do
        assert_equal 'Merry Christmas!', @title
      end
      
      should "have initialized the @yaml instance variable to a hash" do
        assert @article.instance_variable_get(:@yaml).kind_of?(Hash)
      end
      
      should "have initialized the @content instance variable to a string" do
        assert @article.instance_variable_get(:@content).kind_of?(String)
      end
      
      should "have summary set to 'Merry christmas, dear reader!'" do
        assert_equal 'Merry christmas, dear reader!', @article.summary
      end
      
      should 'have body set to "Merry christmas, dear reader!\n\nLorem ipsum dolor..."' do
        assert_equal "Merry christmas, dear reader!\n\nLorem ipsum dolor...", @article.body
      end
    end
  end
  
  context "The article 'foo-bar'" do
    setup do
      @article = Serious::Article.find('foo-bar')
    end
    
    should("have title 'Foo Bar'") { assert_equal 'Foo Bar', @article.title }
    should('have summary "Baz!"')  { assert_equal "Baz!\n", @article.summary }
    should('have body "Baz!"')     { assert_equal "Baz!\n", @article.body }
    should('have summary equal to body') { assert_equal @article.summary, @article.body}
  end
  
end
