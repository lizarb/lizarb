class DevSystem::GemfileGenerator < DevSystem::SimpleGenerator

  # liza g gemfile

  def call_default
    @gemspec_name = get_gemspec_name

    fname = command.given_args[1] || "Gemfile"

    create_file fname, :gemfile, :rb
  end

  def get_gemspec_name
    # ls = Dir["*.gemspec"]
    # ls.first.split(".").first if ls.any?
    false
  end

end

__END__

# view gemfile.rb.erb

# frozen_string_literal: true

source "https://rubygems.org"
<% if @gemspec_name -%>

# Specify your gem's dependencies in <%= @gemspec_name %>.gemspec
# gemspec path: "../path/to/<%= @gemspec_name %>"
gemspec :<%= @gemspec_name %>
<% end -%>

group :default do
  gem "lizarb", "~> <%= Lizarb::VERSION %>"
  # gem "lizarb", github: "lizarb/lizarb"
  # gem "lizarb", path: "../lizarb"
end

group :dev do
  # gems you only want to load if DevSystem is loaded

  # Shell
  # gem "htmlbeautifier", "~> 1.4"
  # gem "commonmarker", "~> 0.23.9"
  # gem "haml", "~> 6.1"
  # gem "sassc", "~> 2.4"
  # gem "coffee-script", "~> 2.4"
end
