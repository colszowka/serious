xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title Serious.title
  xml.id Serious.url
  xml.updated @articles.first.date.to_s unless @articles.empty?
  xml.author { xml.name Serious.author }

  @articles.each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => article.full_url
      xml.id article.full_url
      xml.published article.date.to_s
      xml.updated article.date.to_s
      xml.author { xml.name article.author }
      xml.summary article.summary.formatted, "type" => "html"
      xml.content article.body.formatted, "type" => "html"
      unless article.tags.empty?
        article.tags.each do |tag|
          xml.category "term" => tag
        end
      end
    end
  end
end