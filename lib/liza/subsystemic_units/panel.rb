class Liza::Panel < Liza::Unit

  section :subsystem

  set :box, Liza::Box
  set :controller, Liza::Controller

  #

  def self.instance
    x = self
    x = x.ancestors.take_while { _1.last_namespace == x.last_namespace }.last
    x = x.last_namespace.to_s.sub('Panel', '').snakecase.to_sym
    box.configuration[x]
  end

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

    self
  end

end
