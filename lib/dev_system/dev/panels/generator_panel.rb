class DevSystem::GeneratorPanel < Liza::Panel

  #

  def call args
    log "args = #{args}"
    struct = parse args[0]
    struct.generator = short struct.generator
    generator = find struct.generator

    case
    when struct.class_method
      _call_log "#{generator}.#{struct.class_method}(#{args[1..-1]})"
      generator.public_send struct.class_method, args[1..-1]
    when struct.instance_method
      _call_log "#{generator}.new.#{struct.instance_method}(#{args[1..-1]})"
      generator.new.public_send struct.instance_method, args[1..-1]
    when struct.method
      if generator.respond_to?(struct.method)
        _call_log "#{generator}.#{struct.method}(#{args[1..-1]})"
        generator.public_send struct.method, args[1..-1]
      else
        _call_log "#{generator}.new.#{struct.method}(#{args[1..-1]})"
        generator.new.public_send struct.method, args[1..-1]
      end
    else
      _call_log "#{generator}.call(#{args[1..-1]})"
      generator.call args[1..-1]
    end
  end

  def _call_log string
    log "#{string}" if get :log_details?
  end

  #

  PARSE_REGEX = /(?<generator>[a-z_]+)(?::(?<class_method>[a-z_]+))?(?:#(?<instance_method>[a-z_]+))?(?:\.(?<method>[a-z_]+))?/

  # OpenStruct generator class_method instance_method method
  def parse string
    md = string.to_s.match PARSE_REGEX
    raise ParseError if md.nil?
    hash = md.named_captures
    log "{#{hash.map { ":#{_1} => #{_2.to_s.inspect}" }.join(", ") }}" if get :log_details?
    OpenStruct.new hash
  end

  #

  def find string
    k = Liza.const "#{string}_generator"
  rescue Liza::ConstNotFound
    k = Liza::NotFoundGenerator
  ensure
    log k.to_s if get :log_details?
    k
  end

end
