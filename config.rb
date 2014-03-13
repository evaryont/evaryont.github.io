Time.zone = "America/Phoenix"

activate :blog do |blog|
  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  blog.sources = "posts/:title"

  blog.permalink = "{year}/{month}/{title}"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false
page "/index.html", layout: false

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

set :css_dir, 'assets/stylesheets'

set :js_dir, 'assets/javascripts'

set :images_dir, 'assets/images'

# Enable cache buster
activate :asset_hash

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
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
