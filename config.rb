Time.zone = "America/Phoenix"

activate :blog do |blog|
  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  blog.sources = "posts/:title"

  blog.permalink = "blog/{year}/{month}/{title}"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 12
  blog.page_link = "page/{num}"

  blog.layout = "default"
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
else
  activate :deploy do |deploy|
    deploy.method = :git
    deploy.remote = "origin"
    deploy.branch = "master"
  end
end
