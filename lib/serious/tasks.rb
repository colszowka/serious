# Swallow the actual run method from config.ru
def run(*args)
end

begin
  config = File.read('config.ru')
  eval config
rescue Errno::ENOENT => err
  puts "ERROR: Failed to load your config from config.ru!"
  exit 1
end

def ask(q)
  print "#{q} "
  STDIN.gets.strip.chomp
end

namespace :article do
  desc "Validates all articles, making sure they can be processed correctly"
  task :validate do
    Serious::Article.all.each do |article|
      unless article.valid?
        puts "", "Article #{File.basename(article.path)} is not valid!"
        puts "  Errors: #{article.errors.sort.join(", ")}"
      end
    end
    
    puts
    puts "Validated #{Serious::Article.all.length} article(s)!"
  end
  
  desc "Creates a new article"
  task :create do
    title = ask('Title?')
    if date = ask("Date (defaults to #{Date.today})? ") and date.length > 0
      begin
        article_date = Date.new(*date.split('-').map(&:to_i))
      rescue => err
        puts "Whoops, failed to process the date! The format must be #{Date.today}, you gave #{date}"
        raise err
        exit 1
      end
    else
      article_date = Date.today
    end
    
    filename = "#{article_date}-#{title.slugize}.txt"
    File.open(File.join(Serious.articles, filename), "w") do |article|
      article.puts "title: #{title}", ""
      article.puts "Summary here", "~", "Body here"
    end
    
    puts "Created article #{filename}!"
  end
end

desc "Runs a server hosting your site on localhost:3000 using rackup"
task :server do
  puts "Server launching on http://localhost:3000"
  system "rackup -p 3000 -o localhost"
  puts "Bye!"
end

task :default => :"article:create"
