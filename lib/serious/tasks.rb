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
    puts ask('Title?')
  end
end
