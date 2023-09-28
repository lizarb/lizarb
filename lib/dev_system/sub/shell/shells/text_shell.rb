class DevSystem::TextShell < DevSystem::FileShell
    
  set :create_dir, true
  
  def self.read path, log_level: self.log_level
    log log_level, "Reading #{path}"
    _raise_if_blank path
    _raise_if_not_exists path

    File.read path
  end
  
  def self.write path, content, create_dir: nil, log_level: self.log_level
    log log_level, "Writing #{content.to_s.size} characters (#{content.encoding}) to #{path}"
    _raise_if_blank path

    create_dir = get :create_dir if create_dir.nil?
    DevSystem::DirShell.create File.dirname(path), log_level: log_level if create_dir

    File.write path, content
  end

  def self.append_line_after_last_including(path:, newline:, after:)
    log "appending to #{path}"
    state = nil
    lines = File.readlines(path)
    File.open(path, "w") do |out|
      lines.each do |line|
        state = :entered_systems_region if state == nil && line =~ after
        state = :left_systems_region if state == :entered_systems_region && line !~ after
        
        if state == :left_systems_region
          out.write("#{newline}\n")
          log newline.strip.green if log_append?
          state = :done
        end
        
        out.write(line)
        log line.strip.light_black if log_append?
      end
    end
  end

  def self.log_append?
    true
  end

end
