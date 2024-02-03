class DevSystem::NewGenerator < DevSystem::SimpleGenerator
  
  def call_default
    log "args = #{args.inspect}"
    # setup

    name! "project"

    from = "#{Lizarb.liz_dir}/examples/new"
    log "from: #{from}"
    to = "#{Dir.pwd}/#{@name}"

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

    FileUtils.cp_r "#{Lizarb.liz_dir}/README.md",
                   "#{to}/README.md",
                   verbose: true
    # FileUtils.cp_r "#{Lizarb.app_dir}/web_files",
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

  # liza g new:script script_name

  def call_script
    raise Error, "You can only generate a script inside a project" if !App.project? or App.global?
    name_with_period! "script"

    @systems = ["dev"]

    create_file "scripts/#{@name}", :script_1, :rb
  end

  # liza g new:sfa sfa_name

  def call_sfa
    name_with_period! "sfa"

    @systems = ["dev"]

    create_file @name, :sfa_1, :rb
  end

  # helper methods

  def name! name
    @name = command.simple_arg_ask_snakecase 0, "Name your new #{name}:"
    log "@name = #{@name.inspect}"
  end

  def name_with_period! name
    @name = command.simple_arg_ask_snakecase 0, "Name your new #{name}:", regexp: /^[a-zA-Z_\.]*$/
    log "@name = #{@name.inspect}"
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

# view script_1.rb.erb
#!/usr/bin/env ruby

require "lizarb/script"
Lizarb.script :dev, app: "app"

# YOUR CODE HERE

# use Shell instead of DevSystem::Shell
DevSystem::MainShell.easy!

puts
puts stick " MainShell ".center(100, "-"), :b, :black, :green
puts

log "MainShell is a wrapper for main: #{self}"

# DevSystem::DevBox.command ["shell"]
DevBox.command ["shell"]

# view sfa_1.rb.erb
#!/usr/bin/env ruby

require "lizarb/sfa"
Lizarb.sfa :dev, pwd: __dir__
puts "#{$boot_time.diff}s to boot" if defined? $log_boot_high

# YOUR CODE HERE

# use Shell instead of DevSystem::Shell
DevSystem::MainShell.easy!

puts
puts stick " MainShell ".center(100, "-"), :b, :black, :green
puts

log "MainShell is a wrapper for main: #{self}"

# DevSystem::DevBox.command ["shell"]
DevBox.command ["shell"]
