class DevSystem::LogPanel < Liza::Panel

  def call(menv)
    menv[:instance] ||= menv[:unit_class] != menv[:unit]
    menv[:method_name] ||= method_name_for menv
    menv[:method_name] = menv[:method_name].to_s

    # NOTE: this is an intentional redundancy with Unit#log_level?
    # The unit determines the lowest log level it wants to log
    # Therefore, a message of higher log level will not be logged
    return unless menv[:message_log_level] <= menv[:unit_log_level]

    return if handlers.empty?

    find menv
    parse menv

    handlers.values.each do |handler|
      handler.call menv
    rescue Exception => e
      log stick :light_yellow, "#{e.class} #{e.message.inspect} on #{e.backtrace[0]}"
    end
  end

  def find(menv)
    menv[:object_log] = Liza.const "#{menv[:object_class].last_namespace}_log"
  rescue Liza::ConstNotFound
    menv[:object_log] = StickLogLog
  end

  def parse(menv)
    menv[:object_log].call menv
  end

  def handler(*keys)
    handler_keys.concat keys
  end

  def handler_keys
    @handler_keys ||= []
  end

  def handlers
    @handlers ||= handler_keys.map do |k|
      [k, Liza.const("#{k}_handler_log")]
    end.to_h
  end

  def sidebar_size sidebar_size = nil
    if sidebar_size
      @sidebar_size = sidebar_size
    else
      @sidebar_size
    end
  end

  # NOTE: improve logs performance and readability

  def method_name_for(menv)
    menv[:caller].each do |s|
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

  def method_name_for(menv)
    menv[:caller].each do |s|
      m = s.match(/'(.*)'/)
      t = m[1]

        # next if t.include? " in <class:"
        # return t.split(" ").last if t.include? " in "
      t = t.split(".").last.split("#").last

      next if t == "log"
      next if t == "each"
      next if t == "map"
      next if t == "with_index"
      next if t == "instance_exec"
      next if t.start_with? "_"

      return t
    rescue => e
      puts e
      puts
      puts "  caller:"
      puts menv[:caller]
      puts
      puts "  s:"
      puts s
    end

    raise "there's something wrong with kaller"
  end if Lizarb.ruby_version >= "3.4"

end
