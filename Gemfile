source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'graphql', '~> 1.11', '>= 1.11.1'
gem 'search_object_graphql', '~> 0.3.2'

# Use Puma as the app server
gem 'puma', '~> 3.7'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1', '>= 3.1.13'

# Authentication
gem 'devise', '~> 4.7', '>= 4.7.2'
gem 'devise-token_authenticatable', '~> 1.1'

# Authorization
gem 'cancancan', '~> 3.1'

gem 'rack-cors', '~> 1.1', '>= 1.1.1'
gem 'sprockets', '~> 4.0', '>= 4.0.2'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'graphiql-rails', '~> 1.7'
end

group :test do
  gem 'factory_bot_rails', '~> 6.0'
  gem 'rspec-rails', '~> 4.0', '>= 4.0.1'
  gem 'simplecov', '~> 0.18.5'
  gem 'shoulda-matchers', '~> 4.3'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
