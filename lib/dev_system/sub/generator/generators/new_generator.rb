class DevSystem::NewGenerator < DevSystem::SimpleGenerator

  def call_default
    args = env[:args]
    log "args = #{args.inspect}"
    # setup

    name = args.shift || "app_1"

    from = "#{Lizarb::APP_DIR}/examples/new"
    log "from: #{from}"
    to = "#{Dir.pwd}/#{name}"

    return log "Directory #{to.light_green} already exists." if Dir.exist? to

    log "Liza Application initializing at `#{to}`"

    # app

    FileUtils.cp_r from, to, verbose: true

    # extra

    puts

    FileShell.gitkeep "#{to}/lib"
    FileShell.gitkeep "#{to}/tmp"

    TextShell.write "#{to}/.gitignore", render(:gitignore, format: :gitignore)
    # TextShell.write "#{to}/Procfile", render(:Procfile, format: :yml)
    TextShell.write "#{to}/.tool-versions", render(:toolversions, format: :txt)

    FileUtils.cp_r "#{Lizarb::APP_DIR}/README.md",
                   "#{to}/README.md",
                   verbose: true
    # FileUtils.cp_r "#{Lizarb::APP_DIR}/web_files",
    #                "#{to}/web_files",
    #                verbose: true

    puts

    KernelShell.call_backticks \
      "cd #{to}; liza generate gemfile +confirm",
      log_level: :normal

    KernelShell.call_backticks \
      "cd #{to}; BUNDLE_GEMFILE=Gemfile bundle install",
      log_level: :normal

    KernelShell.call_backticks \
      "cd #{to}; git init -b main; git add .; git commit -m 'lizarb new app_1 (v#{Lizarb::VERSION})'",
      log_level: :normal

    log "Liza Application initialized at `#{to}`"
  end
end

__END__

# view gitignore.gitignore.erb
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
