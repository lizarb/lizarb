# DevSystem::MainShell is a functional wrapper for advanced use cases related to main.
class DevSystem::MainShell < DevSystem::Shell

  def self.main
    $main
  end

  def self.easy!
    easy_constants!
    easy_log!
  end

  def self.easy_constants!
    puts
    log "Object.const_missing now delegates to Liza.const_missing"
    puts
    proc = Liza.method(:const_missing)
    main.define_singleton_method :const_missing, &proc
  end

  def self.easy_log!
    m = main
    def m.log(...)=       DevSystem::MainShell.log(...)
    def m.log_array(...)= DevSystem::MainShell.log_array(...)
    def m.log_hash(...)=  DevSystem::MainShell.log_hash(...)
    def m.stick(...)=     DevSystem::MainShell.stick(...)
  end
  
end
