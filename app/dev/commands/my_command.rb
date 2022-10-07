class MyCommand < AppCommand

  def self.call args
    log :higher, "Called #{self}.#{__method__} with args #{args}"
  end

end
