class DevSystem::TextShell < DevSystem::FileShell

  def self.append_line_after_last_including(path:, newline:, after:)
    log "Appending to #{path}"
    state = nil
    lines = File.readlines(path)
    File.open(path, "w") do |out|
      lines.each do |line|
        state = :entered_systems_region if state == nil && line =~ after
        state = :left_systems_region if state == :entered_systems_region && line !~ after
        
        if state == :left_systems_region
          out.write("#{newline}\n")
          log :high, (stick :light_green, newline.strip)
          state = :done
        end
        
        out.write(line)
        log :high, (stick :onyx, line.strip)
      end
    end
  end

end
