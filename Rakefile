require 'bundler/setup'
require 'middleman-gh-pages'

require "middleman-core/load_paths"
Middleman.setup_load_paths

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
end
