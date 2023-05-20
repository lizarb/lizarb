class DevSystem::NotFoundGenerator < DevSystem::Generator

  def self.call args
    # 1. LOG

    log "args = #{args.inspect}"
    puts

    # 2. FIND generators

    App.load_all
    generators = Liza::Generator.descendants
    generators -= ignored_generators

    # 3. LIST generators

    keys = generators.map { _1.last_namespace.snakecase[0..-11] }.uniq.sort

    log "Liza comes with #{keys.count} generators you can use."
    log "Here they are:"
    puts

    keys.each do
      log "liza generate #{_1}"
    end
  end

  def self.ignored_generators
    [
      self,
      DevSystem::NotFoundGenerator,
      DevSystem::NewGenerator,
      DevSystem::ControllerGenerator,
      DevSystem::RecordGenerator,
      DevSystem::RequestGenerator,
    ].uniq.compact
  end

end
