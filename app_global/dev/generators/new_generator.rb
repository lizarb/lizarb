class NewGenerator < Liza::Generator

  def self.call args
    log :higher, "Called #{self}.#{__method__} with args #{args}"
    new.call args
  end

  def call args
    # setup

    name = args.shift || "app_1"

    from = "#{Lizarb::APP_DIR}/app_new"
    to = name

    return log "Directory #{to.light_green} already exists." if Dir.exist? to

    log "Liza Application initializing at `#{to}`"

    # init

    DirShell.create to

    # app
    
    FileUtils.cp_r "app_new", "#{to}/app", verbose: true
    FileUtils.cp_r "app_new.rb", "#{to}/app.rb", verbose: true

    # extra

    puts

    FileShell.gitkeep "#{to}/lib"
    FileShell.gitkeep "#{to}/tmp"

    TextShell.write "#{to}/.gitignore", render("hidden.gitignore")
    TextShell.write "#{to}/Gemfile", render("Gemfile.rb")
    TextShell.write "#{to}/Procfile", render("Procfile.yml")

    FileUtils.cp_r "#{Lizarb::APP_DIR}/.ruby-version", "#{to}/.ruby-version", verbose: true
    FileUtils.cp_r "#{Lizarb::APP_DIR}/README.md", "#{to}/README.md", verbose: true
    FileUtils.cp_r "#{Lizarb::APP_DIR}/app.env", "#{to}/app.env", verbose: true
    FileUtils.cp_r "#{Lizarb::APP_DIR}/app.code.env", "#{to}/app.code.env", verbose: true

    puts

    `cd #{to}; git init -b main; git add .; git commit -m "lizarb new app_1 (v#{Lizarb::VERSION})"`

    log "Liza Application initialized at `#{to}`"
  end

end

__END__

# hidden.gitignore.erb

# Ignore all files in all subdirectories
.gitignore/.bundle/
/tmp/
*.sqlite
*.rdb

# Procfile.yml.erb

<%= "# HEROKU EXAMPLE" %>

web: LIZA_MODE=demo bundle exec liza rack h=0.0.0.0 p=$PORT

# Gemfile.rb.erb

<%= "# frozen_string_literal: true" %>

source "https://rubygems.org"

ruby File.read(".ruby-version").strip

group :default do
  gem "lizarb", "~> <%= Lizarb::VERSION %>"
  # gem "lizarb", github: "rubyonrails-brasil/lizarb"
end

group :dev do
  # gems you only want to load if DevSystem is loaded
  # gem "pry", "~> 0.14.1"
end

group :happy do
  # gems you only want to load if HappySystem is loaded
end

group :net do
  # gems you only want to load if NetSystem is loaded
  # gem "redis", "~> 5.0"
  # gem "sqlite3", "~> 1.5"
end

group :web do
  # gems you only want to load if WebSystem is loaded
  # gem "rack", "~> 3.0"
  # gem "rackup", "~> 0.2.2"
  # gem "puma", "~> 5.6"
  # gem "htmlbeautifier", "~> 1.4"
end
