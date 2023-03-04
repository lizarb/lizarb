class Liza::Panel < Liza::Unit
  inherited_explicitly_sets_system

  def self.on_connected box_klass
    set :box, box_klass
  end

  def self.box
    get :box
  end

  def box
    self.class.box
  end

  def initialize key
    @key = key
    @blocks = []
    @unstarted = true
  end

  def push block
    @unstarted = true
    @blocks.push block
  end

  def started
    return self unless defined? @unstarted
    remove_instance_variable :@unstarted

    @blocks.each { |bl| instance_eval &bl }
    @blocks.clear

    self
  end
  
  def log log_level = :normal, string
    raise "invalid log_level `#{log_level}`" unless LOG_LEVELS.keys.include? log_level
    return unless log_level? log_level

    source = box.to_s

    x = source.size
    source = source.bold.colorize log_color

    y = source.size
    source = "#{source}[:#{@key}]".ljust(LOG_JUST+y-x)

    string = "#{source} #{string}"
    
    DevBox[:log].call string
  end

end
