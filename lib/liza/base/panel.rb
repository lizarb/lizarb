class Liza::Panel < Liza::Unit

  def self.on_connected box_klass
    set :box, box_klass
  end

  def self.box
    get :box
  end

  def box
    self.class.box
  end

  def self.log_color
    (box || system).log_color
  end

  #

  attr_reader :key

  def initialize key
    @key = key
    @blocks = []
    @unstarted = true
    @short = {}
  end

  #

  def short a, b = nil
    if b
      @short[a.to_s] = b.to_s
    else
      @short[a.to_s] || a.to_s
    end
  end

  #

  def push block
    @unstarted = true
    @blocks.push block
  end

  def started
    return self unless defined? @unstarted
    remove_instance_variable :@unstarted

    @blocks.each { |bl| instance_eval(&bl) }
    @blocks.clear

    self
  end

end
