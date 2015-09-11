xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  #<generator uri="https://middlemanapp.com/" version="{{ jekyll.version }}">Jekyll</generator>

  xml.title data.site.title
  xml.subtitle data.site.subtitle
  xml.id URI.join(data.site.url, blog.options.prefix.to_s)
  xml.logo data.site.avatar

  xml.link "href" => URI.join(data.site.url, blog.options.prefix.to_s), "type" => "text/html"
  xml.link "href" => URI.join(data.site.url, current_page.path), "rel" => "self", "type" => "application/atom+xml"

  xml.updated(blog.articles.first.date.to_time.iso8601) unless blog.articles.empty?

  xml.author do
    xml.name data.site.author
    xml.email data.site.email
    xml.uri data.site.url
  end

  blog.articles[0..10].each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => URI.join(data.site.url, article.url)
      xml.id URI.join(data.site.url, article.url)
      xml.published article.date.to_time.iso8601
      xml.updated File.mtime(article.source_file).iso8601
      if article.metadata[:page]['author']
        xml.author do
          xml.name article.metadata[:page]['author']
        end
      end
      article.tags.each do |tag|
        xml.category tag
      end
      xml.content article.body, "type" => "html"
    end
  end
end
