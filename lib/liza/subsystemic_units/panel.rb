class Liza::Panel < Liza::Unit

  #

  part :panel_errors

  #

  set :box, Liza::Box
  set :controller, Liza::Controller

  #

  def self.box
    system.box
  end

  def box
    system.box
  end

  def self.controller
    @controller ||= system.const token
  end

  def controller
    self.class.controller
  end

  def self.division
    controller.division
  end

  def division
    controller.division
  end

  def self.token
    @token ||= last_namespace.gsub(/Panel$/, '').snakecase.to_sym
  end

  def self.subsystem
    controller
  end

  def subsystem
    controller
  end

  # color

  def self.color
    system.color
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
