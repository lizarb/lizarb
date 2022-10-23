class NewCommand < AppCommand

  def self.call args
    log :higher, "Called #{self}.#{__method__} with args #{args}"

    Liza::GenerateCommand.call ["app", *args]
  end

end
