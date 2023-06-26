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

    TextShell.write "#{to}/.gitignore", render_controller("hidden.gitignore")
    # TextShell.write "#{to}/Procfile", render_controller("Procfile.yml")
    TextShell.write "#{to}/.tool-versions", render_controller("toolversions.txt")

    FileUtils.cp_r "#{Lizarb::APP_DIR}/README.md",
                   "#{to}/README.md",
                   verbose: true
    # FileUtils.cp_r "#{Lizarb::APP_DIR}/web_files",
    #                "#{to}/web_files",
    #                verbose: true

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
