class DevSystem::NotFoundGenerator < DevSystem::Generator

  def self.call args
    # 1. LOG

    log "args = #{args.inspect}"
    puts

    # 2. FIND generators

    generators = Liza::Generator.descendants
    generators -= ignored_generators

    generators.reject! { _1.name =~ /Record/ } unless defined? NetSystem
    generators.reject! { _1.name =~ /Request/ } unless defined? WebSystem
    generators.reject! { _1 <= DevSystem::FormatterGenerator }
    generators.reject! { _1 <= DevSystem::ConverterGenerator }

    # 3. LIST generators

    keys = generators.map { _1.last_namespace.snakecase[0..-11] }.uniq.sort

    log "This app has #{keys.count} generators you can use."
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
    ].uniq.compact
  end

end
