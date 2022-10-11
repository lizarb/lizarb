# frozen_string_literal: true

source "https://rubygems.org"

ruby File.read(".ruby-version").strip

group :default do
  gem "lizarb", "~> 1.0"
  # gem "lizarb", github: "rubyonrails-brasil/lizarb"
end

group :dev do
  # gems you only want to load if DevSystem is loaded
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
