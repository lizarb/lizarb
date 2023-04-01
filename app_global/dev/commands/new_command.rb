class NewCommand < Liza::Command

  def self.call args
    log :higher, "Called #{self}.#{__method__} with args #{args}"

    Liza::GenerateCommand.call ["new", *args]
  end

end
