class DevSystem::LogPanel < Liza::Panel

  def call env
    env[:instance] ||= env[:unit_class] == env[:unit]
    env[:method_name] ||= method_name_for env
  
    handlers.values.each do |handler|
      handler.call env
    rescue Exception => e
      log "#{e.class} #{e.message.inspect} on #{e.backtrace[0]}".yellow
    end
  end

  def handler key
    handlers[key] ||= DevSystem.const("#{key}_log")
  end

  def handlers
    @handlers ||= {}
  end

  # NOTE: improve logs performance and readability

  def method_name_for env
    env[:caller].each do |s|
      t = s.match(/`(.*)'/)[1]

      next if t.include? " in <class:"
      return t.split(" ").last if t.include? " in "

      next if t == "log"
      next if t == "each"
      next if t == "map"
      next if t == "with_index"
      next if t == "instance_exec"
      next if t.start_with? "_"
      return t
    end

    raise "there's something wrong with kaller"
  end

end
