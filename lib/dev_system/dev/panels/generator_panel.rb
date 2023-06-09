class DevSystem::GeneratorPanel < Liza::Panel
  class Error < StandardError; end
  class ParseError < Error; end
  class FormatterError < Error; end

  #

  def call args
    log "args = #{args}"
    
    return call_not_found args if args.none?

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
  rescue ParseError
    call_not_found args
  end

  def _call_log string
    log "#{string}" if get :log_details
  end

  #

  PARSE_REGEX = /(?<generator>[a-z_]+)(?::(?<class_method>[a-z_]+))?(?:#(?<instance_method>[a-z_]+))?(?:\.(?<method>[a-z_]+))?/

  # OpenStruct generator class_method instance_method method
  def parse string
    md = string.to_s.match PARSE_REGEX
    raise ParseError if md.nil?
    hash = md.named_captures
    log "{#{hash.map { ":#{_1} => #{_2.to_s.inspect}" }.join(", ") }}" if get :log_details
    OpenStruct.new hash
  end

  #

  def find string
    k = Liza.const "#{string}_generator"
  rescue Liza::ConstNotFound
    k = Liza::NotFoundGenerator
  ensure
    log k.to_s if get :log_details
    k
  end

  #

  def call_not_found args
    Liza[:NotFoundGenerator].call args
  end

  #

  def formatter format, generator_key = format, options = {}
    generator = options[:generator] || Liza.const("#{format}_formatter_generator")

    formatters[generator_key] = {
      format: format,
      generator: generator,
      options: options
    }
  end

  def formatters
    @formatters ||= {}
  end

  def format? format
    formatters.key? format.to_sym
  end

  def format! format, string
    format = format.to_sym
    if format? format
      log "formatter found" if get :log_details
      formatters[format][:generator].format string
    else
      log "formatter not found" if get :log_details
      raise FormatterError, "no formatter for #{format.inspect}"
    end
  end

  def format format, string, options = {}
    format = format.to_sym
    if format? format
      log "formatter found" if get :log_details
      formatters[format][:generator].format string, options
    else
      log "formatter not found" if get :log_details
      string
    end
  end

end
