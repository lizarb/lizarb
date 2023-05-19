class DevSystem::NotFoundGenerator < DevSystem::Generator

  def self.call args
    # 1. LOG

    log "args = #{args.inspect}"
    puts

    # 2. FIND generators

    App.load_all
    generators = Liza::Generator.descendants

    log "Liza comes with #{generators.count} generators you can use."
    puts

    log "Here they are:"
    puts

    # 3. LIST generators

    keys = generators.map { |k| k.last_namespace.snakecase[0..-11] }.sort
    keys.reject! { |s| s == "not_found" }
    keys.each { |s| log "liza generate #{s}" }
  end

end
