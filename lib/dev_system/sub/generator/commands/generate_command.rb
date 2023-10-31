class DevSystem::GenerateCommand < DevSystem::Command

  def call args
    log :lower, "args = #{args}"

    DevBox[:generator].call args
  end

end
