class DevSystem::GenerateCommand < DevSystem::SimpleCommand

  def call_default
    log :higher, "env.count is #{env.count}"

    DevBox.generate env
  end

end
