source 'https://rubygems.org'

# Specify your gem's dependencies in ruzo.gemspec
gemspec

gem 'facets'

group :development do
  gem 'irbtools', require: false
  gem 'bond', require: false
  gem 'rb-inotify', require: false
  gem 'pry'
  gem 'nokogiri'
end

group :development, :test do
  gem 'guard-rspec'
  gem 'fuubar'
  gem 'rspec', '~> 2.13.0'
  gem 'vcr', '~> 2.4.0'
end
