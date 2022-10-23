class DevSystem
  class AppGenerator < Generator

    def self.call args
      log :higher, "Called #{self}.#{__method__} with args #{args}"

      # setup

      name = args.shift || "app_1"

      from = "#{Lizarb::APP_DIR}/app_new"
      to = name

      return log "Directory #{to.light_green} already exists." if Dir.exist? to

      log "Liza Application initializing at `#{to}`"

      # init

      require "fileutils"
      FileUtils.cp_r from, to, verbose: true

      `cd #{to}; git init .`

      # extra

      puts

      FileUtils.mkdir_p "#{to}/lib", verbose: true
      FileUtils.touch "#{to}/lib/.gitkeep", verbose: true
      FileUtils.mkdir_p "#{to}/tmp", verbose: true
      FileUtils.touch "#{to}/tmp/.gitkeep", verbose: true

      FileUtils.mkdir_p "#{to}/app", verbose: true

      # systems

      App.systems.keys.each { |system_name| copy to, system_name }

      FileUtils.rm "#{to}/app/dev/commands/new_command.rb"
      FileUtils.rm "#{to}/app/dev/commands/new_command_test.rb"

      FileUtils.cp_r "#{Lizarb::APP_DIR}/.ruby-version", "#{to}/.ruby-version", verbose: true
      FileUtils.cp_r "#{Lizarb::APP_DIR}/README.md", "#{to}/README.md", verbose: true
      FileUtils.cp_r "#{Lizarb::APP_DIR}/app.rb", "#{to}/app.rb", verbose: true
      FileUtils.cp_r "#{Lizarb::APP_DIR}/app.env", "#{to}/app.env", verbose: true
      FileUtils.cp_r "#{Lizarb::APP_DIR}/app.code.env", "#{to}/app.code.env", verbose: true

      puts

      log "Liza Application initialized at `#{to}`"
    end

    def self.copy name, system_name
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
