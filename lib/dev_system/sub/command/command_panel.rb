class DevSystem::CommandPanel < Liza::Panel
  class Error < StandardError; end
  class ParseError < Error; end

  def call args
    log "args = #{args.inspect}" if get :log_details

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
  rescue ParseError
    call_not_found args
  end

  def _call_log string
    log "#{string}" if get :log_details
  end

  #

  PARSE_REGEX = /(?<command>[A-Za-z_]+)(?::(?<class_method>[a-z_]+))?(?:#(?<instance_method>[a-z_]+))?(?:\.(?<method>[a-z_]+))?/

  # OpenStruct command class_method instance_method method
  def parse string
    md = string.to_s.match PARSE_REGEX
    raise ParseError if md.nil?
    hash = md.named_captures
    log "{#{hash.map { ":#{_1}=>#{_2.to_s.inspect}" }.join(", ") }}" if get :log_details
    OpenStruct.new hash
  end

  #

  def find string
    k = Liza.const "#{string}_command"
  rescue Liza::ConstNotFound
    k = Liza::NotFoundCommand
  ensure
    log k.to_s if get :log_details
    k
  end

  #

  def call_not_found args
    Liza[:NotFoundCommand].call args
  end

end
