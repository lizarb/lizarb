class DevSystem::GeneratorPanel < Liza::Panel

  #

  def call args
    log "#call(#{args})"
    struct = parse args[0]
    struct.generator = short struct.generator
    generator = find struct.generator

    case
    when struct.class_method
      log "#{generator}.#{struct.class_method}(#{args[1..-1]})"
      generator.public_send struct.class_method, args[1..-1]
    when struct.instance_method
      log "#{generator}.new.#{struct.instance_method}(#{args[1..-1]})"
      generator.new.public_send struct.instance_method, args[1..-1]
    when struct.method
      if generator.respond_to?(struct.method)
        log "#{generator}.#{struct.method}(#{args[1..-1]})"
        generator.public_send struct.method, args[1..-1]
      else
        log "#{generator}.new.#{struct.method}(#{args[1..-1]})"
        generator.new.public_send struct.method, args[1..-1]
      end
    else
      log "#{generator}.call(#{args[1..-1]})"
      generator.call args[1..-1]
    end
  end

  #

  PARSE_REGEX = /(?<generator>[a-z_]+)(?::(?<class_method>[a-z_]+))?(?:#(?<instance_method>[a-z_]+))?(?:\.(?<method>[a-z_]+))?/

  # OpenStruct generator class_method instance_method method
  def parse string
    md = string.to_s.match PARSE_REGEX
    raise ParseError if md.nil?
    hash = md.named_captures
    log "Parsing #{string.inspect} resulted in {#{hash.map { ":#{_1} => #{_2.to_s.inspect}" }.join(", ") }}"
    OpenStruct.new hash
  end

  #

  def find string
    k = Liza.const "#{string}_generator"
  rescue Liza::ConstNotFound
    k = Liza::NotFoundGenerator
  ensure
    log k.to_s
    k
  end

end
