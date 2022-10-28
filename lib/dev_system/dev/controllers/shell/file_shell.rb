class DevSystem
  class FileShell < Shell
    require "fileutils"

    def self.create_folder folder, write_log = true
      log "Creating folder #{folder}" if write_log
      FileUtils.mkdir_p folder
    end

    def self.write folder, filename, content
      create_folder folder, false
      fname = "#{folder}/#{filename}"
      log "Writing #{fname} with #{content.size} bytes"
      File.write fname, content
    end

    def self.touch folder, filename
      create_folder folder, false
      fname = "#{folder}/#{filename}"
      log "Touching #{fname}"
      FileUtils.touch fname
    end

    def self.gitkeep folder
      touch folder, ".gitkeep"
    end

  end
end
