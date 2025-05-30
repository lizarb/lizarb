class DevSystem::GemspecShell < DevSystem::Shell
  
  # 

  def gemspec
    Gem::Specification.load "lizarb.gemspec"
  end

  def gemspecs
    Dir["*.gemspec"].map { _1.split("/").last.split(".").first }
  end
    
  def gemfile_path
    Pathname ENV["BUNDLE_GEMFILE"]
  end

  def gemfile_writable?
    gemfile_path.to_s.start_with? App.root.to_s
  end

end
