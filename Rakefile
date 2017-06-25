require 'bundler/setup'

require "middleman-core/load_paths"
Middleman.setup_load_paths

@project_root = File.expand_path('..', __FILE__)

desc "Create a new blog post"
# Sorta black magic for this task. But makes it easy to write an article title!
# Just do 'rake article any stuff after' and it'll create an article entitled
# "any stuff after", no complaints from rake!
task :article do
  # Pop 'article'
  ARGV.shift

  # For each word in ARGV after 'article', we need to create a temporary task
  ARGV.each do |arg|
    task arg.to_sym do
      # Recreating a task that already exists (say 'article') means that the new
      # one will execute before the old one, so we just use 'next' to return
      # early from the block
      next
    end
  end

  # Now, fill in ARGV so Thor (which Middleman uses) can do it's job
  title_string = ARGV.join(' ')
  if title_string =~ /^[:space:]*$/
    puts "ERROR: You need to pass a title!"
    puts "Usage: rake article TITLE"
    next
  end
  ARGV.clear
  ARGV << "article"
  ARGV << title_string

  # And run Thor
  Middleman::Cli::Base.start

  # Then find the latest post, by looking for a file with the latest creation
  # time.
  latest_post = Dir['source/posts/*'].map{|f| [f, File.stat(f)] }.sort_by{|s| s[1].ctime}.last[0]

  # then open that file in $EDITOR
  system("#{ENV['EDITOR']} #{latest_post}")

  system("git add #{latest_post}")
  system("git commit -m 'New Post: #{title_string}'")
end

task :dirty_git do
  # Throw an error if we don't have a clean git checkout
  fail "Directory not clean" unless (`git diff --shortstat 2> /dev/null`.split('\n')[-1].nil?)
end

desc "Build the middleman site"
task :build do
  cd File.expand_path('..', __FILE__)
  sh "bundle exec middleman build --clean --verbose"
end

desc "Run the middleman preview server"
task :server do
  cd File.expand_path('..', __FILE__)
  sh "bundle exec middleman server"
end

desc "Build and upload my website to everywhere"
# So the order here is important:
# - Ensure the repository is clean & ready
# - Build the full website
# - rsync everything to my webserver
# - Then convert the resume to PDF, now that updated assets are on the server
# - Then run rsync again so the PDF is uploaded
# - Push generated web pages to github
# - Push source repo to github
#
# Whew!
task :deploy => ["dirty_git", "build", "resume", "deploy:rsync", "deploy:git_push"]

namespace :deploy do
  task :git_push => [:dirty_git] do
    sh "git push"
  end

  task :rsync do
    sh "rsync -avz --exclude='.git/' --delete --delete-excluded build/ colin@evaryont.me:/var/www/evaryont.me"
  end
end

task :default do
  sh "bundle exec middleman server"
end

desc 'Convert my resume from HTML to PDF'
task :resume do
    require 'webrick'
    require 'wkhtmltopdf-heroku'
    
    @port_num = rand(8000..9000)
    ws = Thread.new do
      WEBrick::HTTPServer.new(:Port => @port_num, :DocumentRoot => Dir.pwd + '/build').start
    end

    `#{WKHTMLTOPDF_PATH} --margin-top 8 --margin-left 2 --margin-right 2 --margin-bottom 2 --print-media-type --header-font-name 'opensans' --header-font-size 6 --header-left "Colin Shea's Resume" --header-right "Page [page] of [toPage]" 'http://localhost:#{@port_num}/resume.html' #{Dir.pwd}/build/resume.pdf`
    ws.exit
end
