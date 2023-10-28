class DevSystem::CommandPanel < Liza::Panel
  class Error < StandardError; end
  class ParseError < Error; end
  class NotFoundError < Error; end
  class AlreadySet < Error; end

  def call args
    log :lower, "args = #{args.inspect}"

    return call_not_found args if args.none?

    struct = parse args[0]
    struct.command = short struct.command
    command = find struct.command

    case
    when struct.class_method
      _call_log "#{command}.#{struct.class_method}(#{args[1..-1]})"
      command.public_send struct.class_method, args[1..-1]
    when struct.instance_method
      _call_log "#{command}.new.#{struct.instance_method}(#{args[1..-1]})"
      command.new.public_send struct.instance_method, args[1..-1]
    when struct.method
      if command.respond_to?(struct.method)
        _call_log "#{command}.#{struct.method}(#{args[1..-1]})"
        command.public_send struct.method, args[1..-1]
      else
        _call_log "#{command}.new.#{struct.method}(#{args[1..-1]})"
        command.new.public_send struct.method, args[1..-1]
      end
    else
      _call_log "#{command}.call(#{args[1..-1]})"
      command.call args[1..-1]
    end
  rescue Exception => e
    rescue_from_panel(e, with: args)
  end

  def _call_log string
    log :lower, "#{string}"
  end

  #

  PARSE_REGEX = /(?<command>[A-Za-z0-9_]+)(?::(?<class_method>[a-z0-9_]+))?(?:#(?<instance_method>[a-z0-9_]+))?(?:\.(?<method>[a-z0-9_]+))?/

  # OpenStruct command class_method instance_method method
  def parse string
    md = string.to_s.match PARSE_REGEX
    raise ParseError if md.nil?
    hash = md.named_captures
    log :lower, "{#{hash.map { ":#{_1}=>#{_2.to_s.inspect}" }.join(", ") }}"
    OpenStruct.new hash
  end

  #

  def find string
    k = Liza.const "#{string}_command"
    log :lower, k
    k
  rescue Liza::ConstNotFound
    raise NotFoundError, "command not found: #{string.inspect}"
  end

  #

  def call_not_found args
    Liza[:NotFoundCommand].call args
  end

  #

  def input name = nil
    return (@input || InputCommand) if name.nil?
    raise AlreadySet, "input already set to #{@input.inspect}, but trying to set to #{name.inspect}", caller if @input
    @input = find "#{name}_input"
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
