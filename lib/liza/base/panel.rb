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

  def initialize name
    @name = name
  end

  def log log_level = :normal, string
    raise "invalid log_level `#{log_level}`" unless LOG_LEVELS.keys.include? log_level
    return unless log_level? log_level

    source = box.to_s

    x = source.size
    source = source.bold.colorize log_color

    y = source.size
    source = "#{source}.#{@name}".ljust(LOG_JUST+y-x)

    string = "#{source} #{string}"
    
    DevBox.logs.call string
  end

end
