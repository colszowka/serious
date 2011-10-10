# encoding: utf-8
require 'helper'

class TestArticle < Test::Unit::TestCase
  # ========================================================================
  # Tests for all articles and limited all articles finder
  # ========================================================================
  context "Serious::Article.all" do
    setup do
      @articles = Serious::Article.all
    end

    should("return 5 articles") { assert_equal 5, @articles.length }
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
    
    should "have 2009-10-06 as the first article's date" do
      assert_equal Date.new(2009, 10, 6), @articles.first.date
    end
    
    should "have 2009-04-01 as the last article's date" do
      assert_equal Date.new(2009, 4, 1), @articles.last.date
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
    
    should "return 'http://example.com/2010/01/15/foo-bar' as full_url" do
      assert_equal 'http://example.com/2010/01/15/foo-bar', @article.full_url
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
  # Tests for finders
  # ========================================================================
  context "When calling find with (2009, 12, 24, 'merry-christmas'), the returned articles" do
    setup do
      @articles = Serious::Article.find(2009, 12, 24, 'merry-christmas')
    end
    
    should("have a length of 1") { assert_equal 1, @articles.length}
    
    context "the found article" do
      setup { @article = @articles.first }
      
      should "be valid" do
        assert @article.valid?
      end
      
      should "have date 2009-12-24" do
        assert_equal Date.new(2009, 12, 24), @article.date
      end

      should "have permalink 'merry-christmas'" do
        assert_equal 'merry-christmas', @article.permalink
      end
      
      should "be the same as when calling Serious::Article.first(2009, 12, 24, 'merry-christmas')" do
        assert_equal @article, Serious::Article.first(2009, 12, 24, 'merry-christmas')
      end
    end
  end
  
  should "find article for date '2009, 12, 24' with Serious::Article.first('merry-christmas')" do
    assert_equal Date.new(2009, 12, 24), Serious::Article.first('merry-christmas').date
  end
  
  should "find article for date '2009, 12, 24' with Serious::Article.first(12, 24)" do
    assert_equal Date.new(2009, 12, 24), Serious::Article.first(12, 24).date
  end
  
  should "find article for date '2009, 12, 24' with Serious::Article.first('12', '24')" do
    assert_equal Date.new(2009, 12, 24), Serious::Article.first('12', '24').date
  end
  
  should "find article for date '2000, 1, 1' with Serious::Article.first(2000, 1, 1)" do
    assert_equal Date.new(2000, 1, 1), Serious::Article.first(2000, 1, 1).date
  end
  
  should "find article for date '2000, 1, 1' with Serious::Article.first('2000', '1', '1')" do
    assert_equal Date.new(2000, 1, 1), Serious::Article.first('2000', '1', '1').date
  end
  
  should "find article for date '2000, 1, 1' with Serious::Article.first('2000', '01', '01')" do
    assert_equal Date.new(2000, 1, 1), Serious::Article.first('2000', '01', '01').date
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
      @article = Serious::Article.first('merry-christmas')
    end
    
    should "not have instance variable @yaml set" do
      assert_nil @article.instance_variable_get(:@yaml)
    end
    
    should "not have instance variable @content set" do
      assert_nil @article.instance_variable_get(:@content)
    end
    
    should "have 'Christoph Olszowka' as author" do
      assert_equal 'Christoph Olszowka', @article.author
    end
    
    context "after getting the article's title" do
      setup { @title = @article.title }
      
      should "have returned 'Merry Christmas! ☃'" do
        assert_equal 'Merry Christmas! ☃', @title
      end
      
      should "have initialized the @yaml instance variable to a hash" do
        assert @article.instance_variable_get(:@yaml).kind_of?(Hash)
      end
      
      should "have initialized the @content instance variable to a string" do
        assert @article.instance_variable_get(:@content).kind_of?(String)
      end
      
      should "have summary set to 'Merry christmas, dear reader! ☃'" do
        assert_equal 'Merry christmas, dear reader! ☃', @article.summary
      end
      
      should 'have body set to "Merry christmas, dear reader! ☃\n\nThis ain\'t rails, yet it has ☃!"' do
        assert_equal "Merry christmas, dear reader! ☃\n\nThis ain't rails, yet it has ☃!", @article.body
      end
    end
  end
  
  context "The article 'foo-bar'" do
    setup do
      @article = Serious::Article.first('foo-bar')
    end
    
    should "be valid" do
      assert @article.valid?
    end
    should("have title 'Foo Bar'") { assert_equal 'Foo Bar', @article.title }
    should('have summary "Baz!"')  { assert_equal "Baz!\n", @article.summary }
    should('have body "Baz!"')     { assert_equal "Baz!\n", @article.body }
    should("have 'TheDeadSerious' as author") { assert_equal 'TheDeadSerious', @article.author }
    should('have summary equal to body') { assert_equal @article.summary, @article.body}
  end
  
  context "The article 'custom-summary-delimiter'" do
    setup do
      @article = Serious::Article.first('custom-summary-delimiter')
    end
    
    should "be valid" do
      assert @article.valid?
    end
    
    should 'have summary "Can we support a custom summary delimiter?"' do
      assert_equal "Can we support a custom summary delimiter?", @article.summary
    end
    
    should 'have body "Looks like we can! Nicely done."' do
      assert_equal "Can we support a custom summary delimiter?\n\nLooks like we can! Nicely done.", @article.body
    end
  end
  
  # ========================================================================
  # Tests for validation
  # ========================================================================
  context "An article with invalid ERb content" do
    setup do 
      @article = Serious::Article.new('2009-12-12-foo-bar.txt')
      @article.instance_variable_set :@yaml, {"title" => "Foo Bar"}
      @article.instance_variable_set :@content, "Some stupid text with <% invalid %>"
    end
    
    should("not be valid") { assert !@article.valid? }
    context "after validating" do
      setup { @article.valid? }
      
      should "include 'Failed to format body' in errors" do 
        assert @article.errors.include?('Failed to format body'), @article.errors.inspect
      end
      
      should "include 'Failed to format summary' in errors" do 
        assert @article.errors.include?('Failed to format summary'), @article.errors.inspect
      end
    end
  end
  
  context "An article with missing title and author" do
    setup do 
      @article = Serious::Article.new('2009-12-12-foo-bar.txt')
      @article.instance_variable_set :@yaml, {"title" => nil, "author" => nil}
      @article.instance_variable_set :@content, "Some stupid text"
    end
    
    should("not be valid") { assert !@article.valid? }
    context "after validating" do
      setup { @article.valid? }
      
      should "include 'No title given' in errors" do 
        assert @article.errors.include?('No title given'), @article.errors.inspect
      end
      
      should "not include 'No author given' in errors" do 
        assert !@article.errors.include?('No author given'), @article.errors.inspect
      end
      
      context "after setting @author to '' and revalidating" do
        setup do
          @article.instance_variable_set :@author, ''
          @article.valid?
        end
        
        should "include 'No title given' in errors" do 
          assert @article.errors.include?('No title given'), @article.errors.inspect
        end
        
        should "include 'No author given' in errors" do 
          assert @article.errors.include?('No author given'), @article.errors.inspect
        end
      end
    end
  end
  
  context "An article with invalid Filename" do
    should "raise Serious::Article::InvalidFilename exception on load" do 
      assert_raise Serious::Article::InvalidFilename do
        @article = Serious::Article.new('2009-12_12-foo-bar.txt')
      end
    end
  end
end
