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
# - rsync everything to jupiter, the ssh server
# - Then convert the resume to PDF, now that updated assets are on the server
# - Then run rsync again so the PDF is uploaded
# - Push generated web pages to github
# - Push source repo to github
#
# Whew!
task :deploy => ["dirty_git", "build", "resume", "deploy:jupiter", "deploy:github", "deploy:git_push"]

namespace :deploy do
  def deploy(env)
    desc "Deploy the website to #{env}"
    task env => [:dirty_git] do
      cd @project_root
      puts "Deploying to #{env}"
      sh "TARGET=#{env} bundle exec middleman deploy"
      Rake::Task["deploy:#{env}"].reenable
    end
  end

  deploy :jupiter
  deploy :github

  task :git_push => [:dirty_git] do
    sh "git push"
  end
end

task :default do
  sh "bundle exec middleman server"
end

desc 'Convert my resume from HTML to PDF'
task :resume do
  Rake::Task["deploy:jupiter"].reenable
  Rake::Task["deploy:jupiter"].invoke
  Rake::Task["resume:build"].invoke
end

namespace :resume do
  task :build do
    require 'pdfkit'
    input_file = 'build/resume.html'
    output_file = 'build/resume.pdf'

    begin
      kit = PDFKit.new(File.new(input_file),
                       :margin_top => 10,
                       :margin_bottom => 0,
                       :margin_left => 0,
                       :margin_right => 0,
                       print_media_type: true,
                       enable_local_file_access: true,
                       images: true,
                       enable_javascript: true,
                       dpi: 96)
      file = kit.to_file(output_file)
    rescue Exception => e
      puts "Error in PDFKit: #{e.message}"
      raise
    end
  end
end
