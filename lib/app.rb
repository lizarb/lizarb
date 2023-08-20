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

  # parts

  def self.connect_part unit_class, key, part_class, system
    t = Time.now
    string = "CONNECTING PART #{unit_class.to_s.rjust 25}.part :#{key}"
    logv string

    part_class ||= if system.nil?
                Liza.const "#{key}_part"
              else
                Liza.const("#{system}_system")
                    .const "#{key}_part"
              end

    if part_class.insertion
      unit_class.class_exec(&part_class.insertion)
    end

    if part_class.extension
      part_class.const_set :Extension, Class.new(Liza::PartExtension)
      part_class::Extension.class_exec(&part_class.extension)
    end
    logv "#{string} takes #{t.diff}s"
  end

end
