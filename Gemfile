source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'devise'
# gem 'rails-i18n', '~> 5.0.0'
gem "simple_calendar", "~> 2.0"
gem 'jquery-rails'
# gem 'bootstrap', '~> 4.0.0.beta2.1'
gem 'bootstrap-sass', '~> 3.3.7'
gem "autoprefixer-rails"
gem "haml"
gem 'rails_bootstrap_navbar'
gem 'bootstrap_form'
gem "cocoon"
gem 'factory_bot_rails'
gem 'faker', "~> 1.9"
gem "font-awesome-rails"
gem "pundit"
gem 'kaminari'

group :development, :test do
  gem 'byebug'
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem "annotate", ">= 2.5.0"
  gem "awesome_print"
  gem "better_errors"
  gem "binding_of_caller"
  gem "guard", ">= 2.2.2", require: false
  gem "guard-livereload",  '~> 2.5.2', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem "overcommit", ">= 0.37.0", require: false
  gem "rack-livereload"
  gem "rubocop", ">= 0.53.0", require: false
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rails-controller-testing'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
