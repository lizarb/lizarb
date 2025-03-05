class DevSystem::NewGenerator < DevSystem::SimpleGenerator
  
  # liza g new name
  
  def call_default
    call_project
  end
  
  # liza g new:project name
  
  def call_project
    log "args = #{args.inspect}"
    # setup

    name! "project"

    from = "#{Lizarb.liz_dir}/examples/new"
    log "from: #{from}"
    to = "#{Dir.pwd}/#{@name}"

    return log "Directory #{stick :light_green, to} already exists." if Dir.exist? to

    log stick :b, :black, system.color, "Liza Application initializing at `#{to}`"

    # app

    FileShell.copy from, to

    # extra

    puts

    FileShell.gitkeep "#{to}/lib"
    FileShell.gitkeep "#{to}/tmp"

    TextShell.write "#{to}/.gitignore", render(:gitignore, format: :gitignore)
    # TextShell.write "#{to}/Procfile", render(:Procfile, format: :yml)
    TextShell.write "#{to}/.tool-versions", render(:toolversions, format: :txt)

    FileShell.copy "#{Lizarb.liz_dir}/README.md", "#{to}/README.md"
    # FileShell.copy "#{Lizarb.app_dir}/web_files", "#{to}/web_files"
    
    puts

    log stick :b, :black, system.color, "Liza Application initialized at `#{to}`"

    log stick :b, :black, system.color, "Generating Gemfile..."

    KernelShell.call_system \
      "liza generate gemfile #{@name}/Gemfile +confirm",
      log_level: :normal

    log stick :b, :black, system.color, "Gemfile generated at `#{to}/Gemfile`"

    # bundle install

    log stick :b, :black, system.color, "Installing Gems..."
    log stick :b, :white, system.color, "This may take a few minutes, depending on where you are..."

    KernelShell.call_backticks \
      "cd #{to}; BUNDLE_GEMFILE=Gemfile bundle install",
      log_level: :normal
    
    log stick :b, :black, system.color, "Gems installed at `#{to}`"

    # git

    log stick :b, :black, system.color, "Initializing Git..."

    KernelShell.call_backticks \
      "cd #{to}; git init -b main; git add .; git commit -m 'lizarb new #{@name} (v#{Lizarb::VERSION})'",
      log_level: :normal

    log stick :b, :black, system.color, "Liza Application initialized at `#{to}`"
  end

  # liza g new:script name

  def call_script
    if !App.project? or App.global?
      call_script_independent
    else
      call_script_dependent
    end
    
  end

  # liza g new:script_dependent name

  def call_script_dependent
    name_with_period! "script"

    @systems = ["dev"]

    create_file "scripts/#{@name}", :script_dependent, :rb
  end

  # liza g new:script_independent name

  def call_script_independent
    name_with_period! "script"

    @systems = ["dev"]

    create_file @name, :script_independent, :rb
  end

  # helper methods

  def name! name
    @name = command.simple_arg_ask_snakecase 1, "Name your new #{name}:"
    log "@name = #{@name.inspect}"
  end

  def name_with_period! name
    @name = command.simple_arg_ask_snakecase 1, "Name your new #{name}:", regexp: /^[a-zA-Z_\.]*$/
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

# view script_dependent.rb.erb
#!/usr/bin/env ruby

require "lizarb"
Lizarb.init_script_dependent! :dev, app: "app"

# YOUR CODE HERE

# use Shell instead of DevSystem::Shell
DevSystem::MainShell.easy!

puts
puts stick " MainShell ".center(100, "-"), :b, :black, :green
puts

log "MainShell is a wrapper for main: #{self}"

# DevSystem::DevBox.command ["shell"]
DevBox.command ["shell"]

# view script_independent.rb.erb
#!/usr/bin/env ruby

require "lizarb"
Lizarb.init_script_independent! :dev, pwd: __dir__
puts "#{$boot_time.diff}s to boot" if $log_boot_high

# YOUR CODE HERE

# use Shell instead of DevSystem::Shell
DevSystem::MainShell.easy!

puts
puts stick " MainShell ".center(100, "-"), :b, :black, :green
puts

log "MainShell is a wrapper for main: #{self}"

# DevSystem::DevBox.command ["shell"]
DevBox.command ["shell"]
