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

desc "Foo"
task :foo do
  puts Serious.articles
end
