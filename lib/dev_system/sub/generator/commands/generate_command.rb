class DevSystem::GenerateCommand < DevSystem::SimpleCommand

  def call_default
    log :lower, "env.count is #{env.count}"

    DevBox[:generator].call env
  end

end
