task :default => [:start]

task :init do
  system "bundle install --path vendor/bundle --without production"
  system "sh util/setup.sh" 
  system "echo \"\" > db/database.db" 
end

task :start do
  system "bundle exec rackup -o 0.0.0.0 -p 8080"
end

