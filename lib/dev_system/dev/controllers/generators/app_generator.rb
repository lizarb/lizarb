class DevSystem
  class AppGenerator < Generator

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

      require "fileutils"
      FileUtils.cp_r from, to, verbose: true

      `cd #{to}; git init -b main`

      # extra

      puts

      FileShell.gitkeep "#{to}/lib"
      FileShell.gitkeep "#{to}/tmp"

      DirShell.create "#{to}/app"

      # systems

      # App.systems.keys.each { |system_name| copy to, system_name }
      copy to, :dev

      FileUtils.rm "#{to}/app/dev/commands/new_command.rb"
      FileUtils.rm "#{to}/app/dev/commands/new_command_test.rb"

      `rm -rf #{to}/app/dev/generators/record_generator*`
      `rm -rf #{to}/app/dev/generators/request_generator*`

      FileUtils.cp_r "#{Lizarb::APP_DIR}/.ruby-version", "#{to}/.ruby-version", verbose: true
      FileUtils.cp_r "#{Lizarb::APP_DIR}/README.md", "#{to}/README.md", verbose: true
      TextShell.write "#{to}/app.rb", render("app.rb")
      FileUtils.cp_r "#{Lizarb::APP_DIR}/app.env", "#{to}/app.env", verbose: true
      FileUtils.cp_r "#{Lizarb::APP_DIR}/app.code.env", "#{to}/app.code.env", verbose: true

      puts

      log "Liza Application initialized at `#{to}`"
    end

    def copy name, system_name
      from = "#{Lizarb::APP_DIR}/app/#{system_name}_box.rb"
      to = "#{name}/app"
      if File.exist? from
        FileUtils.cp_r from, to, verbose: true
      else
        puts "file not found #{from}"
      end

      from = "#{Lizarb::APP_DIR}/app/#{system_name}"
      to = "#{name}/app"
      if File.exist? from
        FileUtils.cp_r from, to, verbose: true
      else
        puts "file not found #{from}"
      end
    end

  end
end

__END__

# app.rb.erb
App.call ARGV do

  # Systems help you organize your application's dependencies and RAM memory usage.
  # Learn more: http://guides.lizarb.org/systems.html

  system :dev

  # Modes help you organize your application's behavior and settings.
  # Learn more: http://guides.lizarb.org/modes.html

  mode :code
  mode :demo

end
