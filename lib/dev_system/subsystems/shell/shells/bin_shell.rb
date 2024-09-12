class DevSystem::BinShell < DevSystem::FileShell

  set :create_dir, true

  def self.read path
    log "Reading #{path}"
    _raise_if_blank path
    _raise_if_not_exists path

    File.binread path
  end

  def self.write path, content, create_dir: nil
    log "Writing #{content&.size.to_i} bytes (#{content.encoding}) to #{path}"
    _raise_if_blank path

    create_dir = get :create_dir if create_dir.nil?
    DevSystem::DirShell.create File.dirname path if create_dir
    
    File.binwrite path, content
  end
end
