source 'https://rubygems.org'

# Specify your gem's dependencies in ruzo.gemspec
gemspec
gem 'hashery'
gem 'deep_merge'
gem 'facets'
gem 'yell'
gem 'attrio', path: '../attrio'
gem 'naught'
group :development do
  gem 'irbtools', require: false
  gem 'bond', require: false
  gem 'rb-inotify', require: false
  gem 'pry'
  gem 'nokogiri'
end

group :development, :test_dir do
  gem 'guard-rspec'
  gem 'fuubar'
  gem 'rspec', '~> 2.13.0'
  gem 'vcr', '~> 2.5.0'
end
