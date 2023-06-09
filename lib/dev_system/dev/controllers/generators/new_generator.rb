class DevSystem::NewGenerator < DevSystem::Generator
  def self.call(args)
    log "args = #{args.inspect}"
    new.call args
  end

  def call(args)
    log "args = #{args.inspect}"
    # setup

    name = args.shift || "app_1"

    from = "#{Lizarb::APP_DIR}/app_new"
    to = name

    return log "Directory #{to.light_green} already exists." if Dir.exist? to

    log "Liza Application initializing at `#{to}`"

    # init

    DirShell.create to

    # app

    FileUtils.cp_r from, "#{to}/app", verbose: true
    FileUtils.cp_r "#{from}.rb", "#{to}/app.rb", verbose: true

    # extra

    puts

    FileShell.gitkeep "#{to}/lib"
    FileShell.gitkeep "#{to}/tmp"

    TextShell.write "#{to}/.gitignore", render("hidden.gitignore")
    TextShell.write "#{to}/Gemfile", render("Gemfile.rb")
    # TextShell.write "#{to}/Procfile", render("Procfile.yml")
    TextShell.write "#{to}/.tool-versions", render("toolversions.txt")

    FileUtils.cp_r "#{Lizarb::APP_DIR}/README.md",
                   "#{to}/README.md",
                   verbose: true
    # FileUtils.cp_r "#{Lizarb::APP_DIR}/web_files",
    #                "#{to}/web_files",
    #                verbose: true
    @env_name = nil
    TextShell.write "#{to}/app.env",      render("env.env")
    @env_name = :code
    TextShell.write "#{to}/app.code.env", render("env.env")
    @env_name = :demo
    TextShell.write "#{to}/app.demo.env", render("env.env")

    puts

    `cd #{to}; git init -b main; git add .; git commit -m "lizarb new app_1 (v#{Lizarb::VERSION})"`

    log "Liza Application initialized at `#{to}`"
  end
end

__END__

# view hidden.gitignore.erb
# Ignore all files in all subdirectories
.gitignore
/.bundle/
/tmp/
*.sqlite
*.rdb

# view toolversions.txt.erb
ruby <%= RUBY_VERSION %>

# view Procfile.yml.erb
# HEROKU EXAMPLE

web: MODE=demo bundle exec liza rack h=0.0.0.0 p=$PORT

# view Gemfile.rb.erb
# frozen_string_literal: true

source "https://rubygems.org"

group :default do
  gem "lizarb", "~> <%= Lizarb::VERSION %>"
  # gem "lizarb", github: "rubyonrails-brasil/lizarb"
end

group :dev do
  # gems you only want to load if DevSystem is loaded

  # Generator gems
  gem "htmlbeautifier", "~> 1.4"
  
  # Terminal gems
  gem "pry", "~> 0.14.1"
end

# view env.env.erb
#
<% if @env_name == :code -%>
# ENV VARIABLES FOR MODE=code (default)
#
# MODE=code lizarb commands
# lizarb commands
<% elsif @env_name == :demo -%>
# ENV VARIABLES FOR MODE=demo
#
# MODE=demo lizarb commands
<% else -%>
# ENV VARIABLES FOR ALL MODES
#
# MODE=code lizarb commands
# MODE=demo lizarb commands
# lizarb commands
<% end -%>
#

# app variables

# dev variables
