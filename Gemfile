# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in lizarb.gemspec
gemspec

group :dev do
  # gems you only want to load if DevSystem is loaded

  # Generator gems
  gem "htmlbeautifier", "~> 1.4"
  
  # Terminal gems
  gem "pry", "~> 0.14.1"
end

group :happy do
  # gems you only want to load if HappySystem is loaded
end

group :net do
  # gems you only want to load if NetSystem is loaded
  gem "redis", "~> 5.0"
  gem "sqlite3", "~> 1.5"
end

group :web do
  # gems you only want to load if WebSystem is loaded
  gem "rack", "~> 3.0"
  gem "rackup", "~> 0.2.2"
  gem "puma", "~> 5.6"
end
