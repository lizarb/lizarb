class App
  class Error < StandardError; end
  class SystemNotFound < Error; end

  #

  def self.log s
    puts s.bold
  end

  def self.logv s
    log s if $VERBOSE
  end

  # called from exe/lizarb
  def self.call argv
    puts
    args = argv.dup
    argv.clear
    DevBox.command args
    puts
  end

  def self.root
    Pathname Dir.pwd
  end

  # loaders

  @loaders = []
  @mutex = Mutex.new

  def self.loaders
    @loaders
  end

  def self.reload &block
    @mutex.synchronize do
      @loaders.map &:reload
      yield if block_given?
    end

    true
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

  def self.require_system key
    t = Time.now
    logv "App.system :#{key}"
    require key
    logv "App.system :#{key} takes #{t.diff}s"
  rescue LoadError => e
    def e.backtrace; []; end
    raise SystemNotFound, "FILE #{key}.rb not found on $LOAD_PATH", []
  end

  # parts

  def self.connect_part part_klass, key, system
    t = Time.now
    string = "CONNECTING PART #{part_klass.to_s.rjust 25}.part :#{key}"
    logv string

    klass = if system.nil?
              Liza.const "#{key}_part"
            else
              Liza.const("#{system}_system")
                  .const "#{key}_part"
            end

    if klass.insertion
      part_klass.class_exec(&klass.insertion)
    end

    if klass.extension
      klass.const_set :Extension, Class.new(Liza::PartExtension)
      klass::Extension.class_exec(&klass.extension)
    end
    logv "#{string} takes #{t.diff}s"
  end

  # systems

  def self.connect_system key, system_class, logs
    t = Time.now
    puts if logs

    color_system_class = system_class.to_s.colorize system_class.log_color

    log "CONNECTING SYSTEM                     #{color_system_class}" if logs
    index = 0
    system_class.registrar.each do |string, target_block|
      reg_type, _sep, reg_target = string.to_s.lpartition "_"

      index += 1

      target_klass = Liza.const reg_target

      if reg_type == "insertion"
        target_klass.class_exec(&target_block)
      else
        raise "TODO: decide and implement system extension"
      end
      log "CONNECTING SYSTEM-PART                #{color_system_class}.#{reg_type.to_s.ljust 11} to #{target_klass.to_s.ljust 30} at #{target_block.source_location * ":"}  " if logs
    end
    log "CONNECTING SYSTEM         #{t.diff}s for #{  color_system_class.ljust_blanks 35  } to connect to #{index} system parts"
  end

  def self.connect_box key, system_class, logs
    t = Time.now

    color_system_class = system_class.to_s.colorize system_class.log_color

    if system_class.box?
      box_class = system_class.box
    else
      log "        NO BOX FOR                    #{color_system_class}" if logs
      return
    end
    
    color_box_class = box_class.to_s.colorize system_class.log_color

    log "CHECKING BOX                          #{color_box_class}" if logs
    index = 0
    system_class.subs.keys.each do |sub_key|
      # if you have a sub-system, you must have a panel and a controller of the same name
      panel_class = system_class.const "#{sub_key}_panel"
      controller_class = system_class.const sub_key

      index += 1
      log "CHECKING BOX-PANEL                    #{  "#{color_box_class}[:#{sub_key}]".ljust_blanks(35) } is an instance of #{panel_class.last_namespace.ljust_blanks 15} and it configures #{controller_class.last_namespace.ljust_blanks 10} subclasses" if logs
    end
    log "CHECKING BOX              #{t.diff}s for #{color_box_class.ljust_blanks 35} to connect to #{index} panels" if logs
  end

end
