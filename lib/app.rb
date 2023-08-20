class App
  class Error < StandardError; end
  class SystemNotFound < Error; end

  #

  def self.log s
    puts s
  end

  def self.logv s
    log s if $VERBOSE
  end

  # called from exe/lizarb
  def self.call argv
    puts
    args = argv.dup
    argv.clear
    Liza[:DevBox].command args
    puts
  end

  def self.root
    Pathname Dir.pwd
  end

  # modes

  @modes = []

  def self.mode mode = nil
    return $MODE if mode.nil?
    @modes << mode.to_sym
  end

  def self.modes
    @modes
  end

  # systems

  @systems = {}

  def self.system key
    raise "locked" if @locked
    @systems[key] = nil
  end

  def self.systems
    @systems
  end

end
