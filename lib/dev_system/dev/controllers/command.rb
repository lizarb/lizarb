class DevSystem::Command < Liza::Controller

  def self.call args
    log ":call #{args}"
    new.call args
  end

  def call args
    log "#call #{args}"
    raise NotImplementedError
  end

end
