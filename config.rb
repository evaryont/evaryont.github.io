require 'pp'
require 'digest/sha1'
require 'geo_pattern'


$color_palette = [ "#00c853", "#00e676", "#1b5e20", "#2e7d32", "#33691e",
                   "#388e3c", "#43a047", "#4caf50", "#558b2f", "#64dd17",
                   "#66bb6a", "#689f38", "#69f0ae", "#76ff03", "#7cb342",
                   "#81c784", "#8bc34a", "#9ccc65", "#a5d6a7", "#aed581",
                   "#b2ff59", "#b9f6ca", "#c5e1a5", "#c8e6c9", "#dcedc8"] 

# add lib/ to the load path
File.join(File.expand_path(File.dirname(__FILE__)), 'lib').tap do |pwd|
  $LOAD_PATH.unshift(pwd) unless $LOAD_PATH.include?(pwd)
end

# Dumb hacks are dumb. Since the blog posts don't include '.html.' in the file
# name (nor do I want them to), Middleman defaults to showing them as plain
# text. Instead, send all pseudo-extensionless files as HTML. This might break
# something down the line.
::Rack::Mime::MIME_TYPES[''] = 'text/html'

helpers do
    def display_date(date)
      if date.is_a?(Time)
        date.strftime('%B %Y')
      else
        raise ArgumentError, "Unsupported date object '#{date}' to format. Make sure it's a Time."
      end
    end

    def markdown_parser
      require 'redcarpet'
      @instance ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)
    end

    def date_parse(raw_date_string)
      # We assume that every date is of the form "year-month" or the magic word
      # "Present", and that's it.
      raw_date_string.strip!
      if raw_date_string.downcase == 'present'
        now = Time.now
        return Time.utc(now.year, now.month)
      end
      raise ArgumentError, "Unsupported date format '#{raw_date_string}'. Make sure it's YYYY-MM or 'Present' only" unless raw_date_string =~ /\d{4}-\d{1,2}/
      year, month = raw_date_string.split('-').map(&:to_i)
      return Time.utc(year, month)
    end

    def display_start_date(start_date)
      unless start_date
        raise ArgumentError, "Nope! Need a beginning of time, not '#{start_date}'."
      end

      parsed_datetime = date_parse(start_date)
      "<abbr class='dtstart' title='%s'>%s</abbr>" % [date_title(parsed_datetime), display_date(parsed_datetime)]
    end
    def display_end_date(end_date)
      unless !!end_date
        # if there wasn't an end date set in the source data, assume that means
        # it lasts until the present moment
        end_date = 'Present'
      end

      parsed_datetime = date_parse(end_date)
      if end_date.downcase == 'present'
        show_date = 'Present'
      else
        show_date = display_date(parsed_datetime)
      end
      "- <abbr class='dtend' title='%s'>%s</abbr>" % [date_title(parsed_datetime), show_date]
    end

    def date_title(date)
      if date.is_a?(Time)
        date.strftime('%Y-%m')
      else
        raise ArgumentError, "WTF? Unsupported time object '#{date}' to format for datetime title. Make sure it's a Time."
      end
    end

    def geopattern(path)
      base_color_i = Random.new(Digest::SHA1.hexdigest(path).to_i(16)).rand($color_palette.length+1)

      GeoPattern.generate(path, color: $color_palette[base_color_i]).to_data_uri
    end
end

activate :blog do |blog|
  blog.sources = 'posts/{title}'
  blog.permalink = 'blog/{year}/{month}/{title}.html'
  blog.taglink = 'tags/{tag}/index.html'

  # Enable pagination
  blog.paginate = false

  blog.layout = 'blog_post'
  blog.tag_template = 'tag.html'
  blog.calendar_template = 'calendar.html'
  blog.new_article_template = 'article.tt'

  # Don't generate any date-specific pages, just the blog post pages.
  blog.calendar_template = false
  blog.year_template = false
  blog.month_template = false
  blog.day_template = false
end

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

set :css_dir,      'assets/stylesheets'
set :js_dir,       'assets/javascripts'
set :images_dir,   'assets/images'

# Enable cache buster
activate :asset_hash

set :layout, 'default'
page "/blog/*", layout: 'post'
page "/resume.html", :layout => false

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
