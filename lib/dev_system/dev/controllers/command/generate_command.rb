class DevSystem::GenerateCommand < DevSystem::Command

  def call args
    log "#call #{args}"

    DevBox[:generator].call args
  end

end
