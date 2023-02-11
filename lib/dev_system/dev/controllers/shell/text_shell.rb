class DevSystem::TextShell < DevSystem::FileShell
    
  set :create_dir, true
  
  def self.read path
    log "Reading #{path}"
    _raise_if_blank path
    _raise_if_not_exists path

    File.read path
  end
  
  def self.write path, content, create_dir: nil
    log "Writing #{content.to_s.size} characters (#{content.encoding}) to #{path}"
    _raise_if_blank path

    create_dir = get :create_dir if create_dir.nil?
    DevSystem::DirShell.create File.dirname path if create_dir

    File.write path, content
  end

end
