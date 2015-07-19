Time.zone = "America/Phoenix"

require 'pp'

helpers do
    def display_date(date)
      if date.is_a?(Date)
        date.strftime("%e %B %Y")
      else
        date
      end
    end

    def display_age(birthday)
      pp birthday
      #bday = Date.parse(birthday)
      bday = birthday
      now = Date.today
      now.year - bday.year - (Date.new(now.year, bday.month, bday.day) > now ? 1 : 0)
    end

    def markdown_parser
      require 'redcarpet'
      @instance ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)
    end
end

activate :blog do |blog|
  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  blog.sources = "posts/:title"

  blog.permalink = "blog/{year}/{month}/{title}"
  blog.day_link = "blog/{year}/{month}/{day}.html"
  blog.month_link = "blog/{year}/{month}.html"
  blog.year_link = "blog/{year}.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 10
  blog.page_link = "page/{num}"

  blog.layout = "blog_post"
  
  blog.new_article_template = "article.tt"
end

page "/feed.xml",   layout: false
page "/index.html", layout: false

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

set :css_dir,      'assets/stylesheets'
set :js_dir,       'assets/javascripts'
set :images_dir,   'assets/images'
set :layouts_dir,  'layouts/'
set :partials_dir, 'layouts/'

# Enable cache buster
activate :asset_hash

set :layout, 'default'
#page "/blog/*", layout: 'post'

activate :syntax#, :line_numbers => true

# Use Kramdown for parsing Markdown. Midleman-Syntax includes support!
#set :markdown_engine, :kramdown
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true

# Build-specific configuration
configure :build do
  if ENV['TARGET'] # Building when we are deploying...
    activate :minify_css
    activate :minify_javascript
  end
end

case ENV['TARGET'].to_s.downcase
when 'delphox'
  activate :deploy do |deploy|
    deploy.method = :rsync
    deploy.host   = "delphox.evaryont.me"
    deploy.user   = 'colin'
    #deploy.port  = 22
    deploy.path   = "/home/colin/website"
    deploy.flags  = "-Cav --delete --delete-excluded"
    deploy.clean  = true
  end
when 'jupiter'
  activate :deploy do |deploy|
    deploy.method = :rsync
    deploy.host   = "jupiter.evaryont.me"
    deploy.user   = 'colin'
    #deploy.port  = 22
    deploy.path   = "/home/colin/website"
    deploy.flags  = "-Cav --delete --delete-excluded"
    deploy.clean  = true
  end
else
  activate :deploy do |deploy|
    deploy.method = :git
    deploy.remote = "origin"
    deploy.branch = "master"
  end
end
