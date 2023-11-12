class DevSystem::CommandPanel < Liza::Panel
  class Error < StandardError; end
  class ParseError < Error; end
  class NotFoundError < Error; end
  class AlreadySet < Error; end

  def call args
    log :lower, "args = #{args.inspect}"

    return call_not_found args if args.none?

    env = build_env args
    find env
    forward env
    inform env
  rescue Exception => e
    rescue_from_panel(e, with: args)
  end

  #

  PARSE_REGEX = /(?<command_given>[A-Za-z0-9_]+)(?::(?<command_class_method>[a-z0-9_]+))?(?:#(?<command_instance_method>[a-z0-9_]+))?(?:\.(?<command_method>[a-z0-9_]+))?/

  # Hash command_name class_method instance_method method
  def parse string
    md = string.to_s.match PARSE_REGEX
    raise ParseError if md.nil?

    env = md.named_captures.map { [_1.to_sym, _2] }.to_h
    env[:command_arg] = string
    log :lower, "{#{env.map { ":#{_1}=>#{_2.to_s.inspect}" }.join(", ") }}"
    env
  end

  def build_env args
    env = parse args[0]
    env[:args] = Array(args[1..-1])
    env[:command_name] = short env[:command_given]
    env
  end

  #

  def find env
    raise "env[:command_name] is empty #{env}" if env[:command_name].empty?
    env[:command_class] = Liza.const "#{env[:command_name]}_command"
  rescue Liza::ConstNotFound
    raise NotFoundError, "command not found: #{env[:command_name].inspect}"
  end

  def _find string
    k = Liza.const "#{string}_command"
    log :lower, k
    k
  rescue Liza::ConstNotFound
    raise NotFoundError, "command not found: #{string.inspect}"
  end

  #

  def forward env
    command_class = env[:command_class]
    
    return forward_base_command env if command_class < BaseCommand
    return forward_command env if command_class < Command
  end

  def forward_base_command env
    log :lower,  "forwarding"
    env[:command_class].call env
  end

  def forward_command env
    case
    when env[:command_class_method]
      log :lower,  "#{env[:command_class]}.#{env[:command_class_method]}(#{env[:args]})"
      env[:command_class].public_send env[:command_class_method], env[:args]
    when env[:command_instance_method]
      log :lower,  "#{env[:command_class]}.new.#{env[:command_instance_method]}(#{env[:args]})"
      env[:command_class].new.public_send env[:command_instance_method], env[:args]
    when env[:command_method]
      if env[:command_class].respond_to?(env[:command_method])
        log :lower,  "#{env[:command_class]}.#{env[:command_method]}(#{env[:args]})"
        env[:command_class].public_send env[:command_method], env[:args]
      else
        log :lower,  "#{env[:command_class]}.new.#{env[:command_method]}(#{env[:args]})"
        env[:command_class].new.public_send env[:command_method], env[:args]
      end
    else
      log :lower,  "#{env[:command_class]}.call(#{env[:args]})"
      env[:command_class].call env[:args]
    end
  end

  #

  def inform env
    return if env[:simple] == nil
    return if env[:simple] == [""]

    env[:simple].shift if env[:simple][0] == ""

    puts if log? :higher

    args = [*env[:args], *env[:simple]].join(" ")

    log sticks :black, system.color, :b,
      ["LIZA"],
      ["HELPS",    :u],
      ["YOU",      :u, :i],
      ["REMEMBER", :i] \
        if log? :higher
    
    log stick system.color, "#{$0} #{env[:command_arg]} #{args}" if log? :higher
  end

  #

  def call_not_found args
    Liza[:NotFoundCommand].call args
  end

  #

  def input name = nil
    return (@input || InputCommand) if name.nil?
    raise AlreadySet, "input already set to #{@input.inspect}, but trying to set to #{name.inspect}", caller if @input
    @input = _find "#{name}_input"
  end

  def pick_one title, options = ["Yes", "No"]
    if log_level? :highest
      puts
      log "Pick One"
    end
    input.pick_one title, options
  end

  def pick_many title, options
    if log_level? :highest
      puts
      log "Pick Many"
    end
    # input.pick_many title, options
    TtyInputCommand.multi_select title, options
  end

end
