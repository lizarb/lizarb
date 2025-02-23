# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in lizarb.gemspec
gemspec name: "lizarb"

gem "zeitwerk", "~> 2.6"

group :systems do
  # gem "echo_system", "~> 1.0"
end

group :dev do
  # gems used by DevSystem

  # Command gems
  gem "pry", ">= 0.14.2"

  # Shell gems
  gem "diff-lcs", ">= 1.5.1"
  gem "tty-prompt", ">= 0.23.1"
  gem "htmlbeautifier", "~> 1.4"
  gem "commonmarker", "~> 0.23"
  gem "haml", "~> 6.1"
  gem "sassc", "~> 2.4"
  gem "coffee-script", "~> 2.4"
end

group :happy do
  # gems used by HappySystem
end

group :net do
  # gems used by NetSystem

  # client gems
  gem "nori", "~> 2.6"
  gem "rexml", "~> 3.2"

  # database gems
  gem "redis", "~> 5.0"
  gem "mongo", "~> 2.19"
  gem "sqlite3", "~> 1.5"
  gem "mysql2", "~> 0.5"
  gem "pg", "~> 1.5"
end

group :web do
  # gems used by WebSystem
  gem "rack", "~> 3.0"
  gem "agoo", "~> 2.15"
  gem "falcon", "~> 0.47"
  gem "iodine", "~> 0.7"
  gem "puma", "~> 6.4"
  # gem "thin", "~> 1.6" is not compatible with Rack 3
end

group :desk do
  # gems used by DeskSystem
  gem "glimmer-dsl-libui", "~> 0.11"
end
