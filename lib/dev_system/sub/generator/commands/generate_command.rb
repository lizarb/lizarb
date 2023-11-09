class DevSystem::GenerateCommand < DevSystem::BaseCommand

  def call_default
    log :lower, "env.count is #{env.count}"

    DevBox[:generator].call env[:args]
  end

end
