class Liza::Unit

  # Define a section
  def self.section(name)
    @current_section = name.to_sym
  end

  # Retrieve the sections
  def self.sections
    @sections ||= Hash.new { |h, k| h[k] = { constants: [], class_methods: [], instance_methods: [] } }
  end

  # Hook into singleton method definition to capture class methods under the current section
  def self.singleton_method_added(method_name)
    sections[@current_section || :default][:class_methods] << method_name
  end

  singleton_method_added :section
  singleton_method_added :sections

  # Hook into method definition to capture instance methods under the current section
  def self.method_added(method_name)
    sections[@current_section || :default][:instance_methods] << method_name
  end

  # Hook into constant definition to capture constants under the current section
  def self.const_added(name)
    super
    # ensures dynamic constants are not captured
    return unless const_defined? name
    # ensures constants defined in the System class are not captured
    return if self < Liza::System
    sections[@current_section || :default][:constants] << name
  end

  # Alias for class_methods_defined
  def self.methods_defined() = class_methods_defined

  # Retrieves all defined class methods.
  # @return [Array<Symbol>] an array of all defined class method names
  def self.class_methods_defined() = sections.values.map { _1[:class_methods] }.flatten

  # Retrieves all defined instance methods.
  # @return [Array<Symbol>] an array of all defined instance method names
  def self.instance_methods_defined() = sections.values.map { _1[:instance_methods] }.flatten

  # Retrieves all defined constants.
  # @return [Array<Symbol>] an array of all defined constant names
  def self.constants_defined() = sections.values.map { _1[:constants] }.flatten

  # ERROR
  
  class Error < Liza::Error; end

  # PART

  # Inserts a part into the unit.
  # @param key [Symbol] the key of the part
  # @param insertion [Symbol] the insertion method
  def self.part(key, insertion = :default)
    part_class = Liza.const "#{key}_part"
    insertion = part_class.insertion(insertion)

    section "#{key}_part"
    class_exec(&insertion)
  end

  # CONST MISSING

  def self.const_missing name
    Liza.const name
  rescue Liza::ConstNotFound
    if Lizarb.ruby_supports_raise_cause?
      raise NameError, "uninitialized constant #{name}", caller[1..], cause: nil
    else
      raise NameError, "uninitialized constant #{name}", caller
    end
  end

  section :setting

  def self.settings
    @settings ||= {}
  end

  def self.get key
    if settings.has_key? key
      settings[key] = settings[key].call if settings[key].is_a? Proc
      return settings[key]
    end

    found = nil

    for klass in ancestors
      break unless klass.respond_to? :settings

      if klass.settings.has_key? key
        found = klass.settings[key]

        break
      end
    end

    found = settings[key] = found.dup if found.is_a? Enumerable
    found = settings[key] = found.call if found.is_a? Proc

    found
  end

  def self.set key, value
    settings[key] = value
    value
  end

  def self.add list, key = nil, value
    if key
      fetch(list) { Hash.new }[key] = value
    else
      fetch(list) { Set.new } << value
    end
  end

  def self.fetch key, &block
    x = get key
    x ||= set key, instance_eval(&block)
    x
  end

  def settings
    @settings ||= {}
  end

  def get key
    if settings.has_key? key
      settings[key] = settings[key].call if settings[key].is_a? Proc
      return settings[key]
    end

    self.class.get key
  end

  def set key, value
    settings[key] = value
  end

  def add list, key = nil, value
    if key
      fetch(list) { Hash.new }[key] = value
    else
      fetch(list) { Set.new } << value
    end
  end

  def fetch key, &block
    x = get key
    x ||= set key, instance_eval(&block)
    x
  end

  section :associating

  def self.namespace
    return @namespace if defined? @namespace

    @namespace ||= Object unless to_s.include? "::"
    @namespace ||= Liza if to_s.start_with? "Liza::"
    @namespace ||= system
    @namespace
  end

  def self.subclasses_select system:
    subclasses.select { _1.system? system }
  end

  def self.descendants_select system:
    descendants.select { _1.system? system }
  end

  def self.subunits
    Lizarb.eager_load!
    subclasses.select { _1.name&.start_with?(/[A-Z]/) }
  end

  def self.system? system
    system = Liza.const "#{system}_system" if system.is_a? Symbol
    system == get(:system)
  end

  # TEST

  def self.test_class
    if first_namespace == "Liza"
      Liza.const_get "#{last_namespace}Test"
    elsif self < Liza::System
      const "#{last_namespace}Test"
    else
      Object.const_get "#{name}Test"
    end
  end

  # CONTROLLER

  def self.division
    Liza::Controller
  end

  # SYSTEM

  def self.system
    if name&.include? "::"
      return System if first_namespace == "Liza"
      Object.const_get first_namespace
    else
      superclass.system
    end
  end

  singleton_class.send :public, :system

  def system
    self.class.system
  end

  public :system

  section :erroring

  def self.errors
    fetch(:errors) { {} }
  end

  def self.define_error(error_key, &block)
    self.const_set :Error, Class.new(StandardError) unless defined? Error

    error_class = Error
    error_class = Class.new error_class
    error_class = self.const_set "#{error_key.to_s.camelcase}Error", error_class
    
    errors[error_key] = [error_class, block]
  end

  def self.raise_error(error_key, *args, kaller: caller)
    error, message_block = errors[error_key]
    raise error, message_block.call(args), kaller
  end

  def raise_error(error_key, *args, kaller: caller)
    error, message_block = self.class.errors[error_key]
    raise error, message_block.call(args), kaller
  end

  section :logging

  # LOG

  def self.log_levels()=App::LOG_LEVELS
  def log_levels()= App::LOG_LEVELS

  def self.log(
    log_level = App::DEFAULT_LOG_LEVEL,
    object,
    unit: self,
    method_name: nil,
    sidebar: nil,
    kaller: caller
  )
    log_level = log_levels[log_level] if log_level.is_a? Symbol
    raise "invalid log_level `#{log_level}`" unless log_levels.values.include? log_level
    return unless log_level? log_level

    unit_class = unit.is_a?(Class) ? unit : unit.class
    object_class = object.is_a?(Class) ? object : object.class

    env = {}
    env[:type] = :log
    env[:unit] = unit
    env[:unit_class] = unit_class
    env[:method_name] = method_name
    env[:sidebar] = sidebar
    env[:message_log_level] = log_level
    env[:unit_log_level] = unit.log_level
    env[:caller] = kaller
    env[:object] = object
    env[:object_class] = object_class

    DevBox.logg env
  end

  def log(
    log_level = App::DEFAULT_LOG_LEVEL,
    object,
    unit: self,
    method_name: nil,
    sidebar: nil,
    kaller: caller
  )
    log_level = log_levels[log_level] if log_level.is_a? Symbol
    raise "invalid log_level `#{log_level}`" unless log_levels.values.include? log_level
    return unless log_level? log_level

    unit_class = unit.is_a?(Class) ? unit : unit.class
    object_class = object.is_a?(Class) ? object : object.class

    env = {}
    env[:type] = :log
    env[:unit] = unit
    env[:unit_class] = unit_class
    env[:method_name] = method_name
    env[:sidebar] = sidebar
    env[:message_log_level] = log_level
    env[:unit_log_level] = unit.log_level
    env[:caller] = kaller
    env[:object] = object
    env[:object_class] = object_class

    DevBox.logg env
  end

  def self.stick(*args)
    StickLog.new(*args)
  end

  def stick(*args)
    StickLog.new(*args)
  end

  def self.sticks(*args)
    StickLog.bundle(*args)
  end

  def sticks(*args)
    StickLog.bundle(*args)
  end

  #

  def self.log_level new_value = nil
    if new_value
      new_value = log_levels[new_value] if new_value.is_a? Symbol
      raise "invalid log_level `#{new_value}`" unless log_levels.values.include? new_value
      set :log_level, new_value
    else
      get :log_level
    end
  end

  def log_level new_value = nil
    if new_value
      new_value = log_levels[new_value] if new_value.is_a? Symbol
      raise "invalid log_level `#{new_value}`" unless log_levels.values.include? new_value
      set :log_level, new_value
    else
      get :log_level
    end
  end

  #

  def self.log_hash log_level = :normal, hash, prefix: "", kaller: caller[1..-1]
    prefix = prefix.to_s
    size = hash.keys.map(&:to_s).map(&:size).max
    
    hash.each do |k,v|
      log log_level, "#{prefix}#{k.to_s.ljust size} = #{v.to_s.inspect}", kaller: kaller
    end
  end

  def log_hash log_level = :normal, hash, prefix: "", kaller: caller[1..-1]
    prefix = prefix.to_s
    size = hash.keys.map(&:to_s).map(&:size).max
    
    hash.each do |k,v|
      log log_level, "#{prefix}#{k.to_s.ljust size} = #{v.to_s.inspect}", kaller: kaller
    end
  end

  #

  def self.log_array log_level = :normal, array, prefix: "", kaller: caller[1..-1]
    prefix = prefix.to_s
    size = array.size.to_s.size+1
    
    array.each.with_index do |v, i|
      log log_level, "#{prefix}#{i.to_s.ljust size} = #{v.inspect}", kaller: kaller
    end
  end

  def log_array log_level = :normal, array, prefix: "", kaller: caller[1..-1]
    prefix = prefix.to_s
    size = array.size.to_s.size+1
    
    array.each.with_index do |v, i|
      log log_level, "#{prefix}#{i.to_s.ljust size} = #{v.inspect}", kaller: kaller
    end
  end

  #

  def self.log?(...)= log_level?(...)
  def log?(...)= log_level?(...)

  def self.log_level? log_level = App::DEFAULT_LOG_LEVEL
    log_level = log_levels[log_level] if log_level.is_a? Symbol
    log_level <= self.log_level
  end

  def log_level? log_level = App::DEFAULT_LOG_LEVEL
    log_level = log_levels[log_level] if log_level.is_a? Symbol
    log_level <= self.log_level
  end

  section :sleep

  def self.sleep(seconds)
    log :lower, "Sleeping for #{seconds}s... #{ "| #{caller[0]}" if log? :low }"
    Kernel.sleep seconds
  end

  def sleep(seconds)
    log :lower, "Sleeping for #{seconds}s... #{ caller[0] if log? :low }"
    Kernel.sleep seconds
  end

  section :rendering

  define_error(:renderer_not_found) do |args|
    "ERB \"#{args[0]}.#{args[1]}.erb\" not found"
  end

  define_error(:render_stack_is_empty) do |args|
    <<~STRING
You called render without ERB keys,
but the render stack is empty.
Did you forget to add ERB keys?
    STRING
  end

  define_error(:render_stack_is_full) do |args|
    <<~STRING
You called render with too many ERB keys.
Did you accidentally fall into an infinite loop?
    STRING
  end

  def render!(
    *keys,
    format: nil,
    converted: false,
    formatted: false
  )
    render(
      *keys,
      format: format,
      converted: converted,
      formatted: formatted,
      allow_missing: false
    )
  end

  def render(
    *keys,
    format: nil,
    converted: false,
    formatted: false,
    allow_missing: true
  )
    original_render_format = @render_format
    format = @render_format ||= @format if format.nil?
    raise "@render_format or @format must be set, or format keyword-argument must be given" if format.nil?
    @render_format = format = format.to_sym

    log_rendering = log_level? :high
    
    if keys.any?
      log_render_in keys, kaller: caller if log_rendering

      erbs = self.class.erbs_for format, keys, allow_missing: allow_missing
      erbs.to_a.reverse.each do |key, erb|
        t_diff = Lizarb.time_diff Time.now
        if true
          s = erb.result binding, self
          log_render_out "#{erb.name}.#{erb.format}", s.length, t_diff, kaller: caller if log_rendering
        end

        if converted and DevBox[:shell].convert? erb.format, format
          convert_env = {format_from: erb.format, format_to: format, convert_in: s}
          DevBox.convert(convert_env)
          s = convert_env[:convert_out]
          log_render_convert "#{erb.name}.#{format}", s.length, t_diff, kaller: caller if log_rendering
        end

        if formatted and DevBox[:shell].format? erb.format
          format_env = {format: format, format_in: s}
          DevBox.format(format_env)
          s = format_env[:format_out]
          log_render_format "#{erb.name}.#{format}", s.length, t_diff, kaller: caller if log_rendering
        end

        render_stack.push s

        raise_error :render_stack_is_full, kaller: caller if render_stack.size > 10
      end

      @render_format = original_render_format
      render_stack.pop
    elsif render_stack.any?
      @render_format = original_render_format
      render_stack.pop
    else
      raise_error :render_stack_is_empty, kaller: caller
    end
  end

  def render_stack
    @render_stack ||= []
  end

  def log_render_in keys, kaller: 
    if render_stack.any?
      log "render → #{keys.join " "}", kaller: kaller
    else
      log "render #{"→ " * keys.size}#{keys.join " "}", kaller: kaller
    end
  end

  def log_render_out key, length, t, kaller: 
    if render_stack.any?
      log "render #{"← #{key}".ljust_blanks 25} #{length.to_s.rjust_blanks 4} characters in #{t}s", kaller: kaller
    else
      log "render #{"← #{key}".ljust_blanks 25} #{length.to_s.rjust_blanks 4} characters in #{t}s", kaller: kaller
    end
  end

  def log_render_convert key, length, t, kaller: 
    log "convert  #{"#{key}".ljust_blanks 23} #{length.to_s.rjust_blanks 4} characters in #{t}s", kaller: kaller
  end

  def log_render_format key, length, t, kaller: 
    log "format  #{"#{key}".ljust_blanks 23} #{length.to_s.rjust_blanks 4} characters in #{t}s", kaller: kaller
  end

  # class level methods

  def self.erbs_defined
    @erbs_defined ||= ErbShell.load(self.source_location_radical)
  end

  def self.erbs_available ref = Liza::Unit
    @erbs_available ||= begin
      h = {}

      ancestors.take_while do |ancestor|
        ancestor != ref
      end.reverse.each do |ancestor|
        ancestor.erbs_defined.each do |erb|
          h[erb.key] = erb
        end
      end

      h.values
    end
  end

  def self.renderable_names
    erbs_available.map(&:name).uniq
  end

  def self.renderable_formats_for name_string
    erbs_available.select { _1.name == name_string }
  end

  def self.erbs_for format, names, allow_missing:
    @erbs_for ||= {}
    k = "#{format}-#{names.join("-")}"
    @erbs_for[k] ||= _erbs_for format, names, allow_missing:
  end

  def self._erbs_for format, names, allow_missing:
    ret = {}

    log_erb = log_level? :high

    converters = DevBox[:shell].converters_to[format] || []
    converters_from = converters.map { _1[:from] }
    format_with_converters_from = [format, *converters_from]
    log "names #{stick :light_green, names.join(" ")} | formats #{stick :light_green, format_with_converters_from.join(" ")}" if log_erb

    names.each do |name|
      name_string = name.to_s
      log stick :onyx, "      #{name_string}#{".*.erb # filtering name  "} #{renderable_names.join(" ")}" if log_erb
      
      name_candidates = renderable_formats_for name_string
      if name_candidates.none?

        if allow_missing
          log stick :light_yellow, "      #{name_string}.#{format}.erb not found, but allow_missing: true" if log_erb
          found = Liza::Unit.erbs_defined.first
        else
          log stick :light_red, "    #{name}.#{format}.erb not found, and allow_missing: false"
          raise_error :renderer_not_found, name, format
        end

      else

        log stick :onyx, "      #{name_string}#{".*.erb # filtering format "}#{name_candidates.map(&:format).join(" ")}" if log_erb

        found = name_candidates.find do |erb|
          erb_format_sym = erb.format.to_sym
          format_with_converters_from.include? erb_format_sym
        end

        if found
          log stick :light_green, "      #{found.key} found" if log_erb
        else
          if allow_missing
            log stick :light_yellow, "    #{name}.#{format}.erb not found, but allow_missing: true" if log_erb
            found = Liza::Unit.erbs_defined.first
          else
            log stick :light_red, "    #{name}.#{format}.erb not found, and allow_missing: false"
            raise_error :renderer_not_found, name, format
          end
        end

      end

      ret[name] = found
    end

    ret
  end

  section :default
  
  def self.reload!
    Lizarb.reload
  end

  def reload!
    Lizarb.reload
  end

  ##
  # :call-seq:
  #   Unit.cl -> Class
  #
  # Returns the class itself.
  def self.cl() = self
  
  ##
  # :call-seq:
  #   unit_instance.cl -> Class
  #
  # Returns the class of the current instance.
  def cl() = self.class

  ##
  # :call-seq:
  #   Unit.time_diff(t[, digits]) -> String
  #
  # Returns a time difference string with a fixed decimal precision. 
  #
  # - +t+: A time-like object to compare to the current time.
  # - +digits+: Integer specifying the decimal precision (defaults to 4).
  #
  # Raises ArgumentError if +digits+ is not a positive Integer.
  #
  def self.time_diff(t1, t2 = Time.now, digits = 4)
    Lizarb.time_diff(t1, t2, digits)
  end

  ##
  # :call-seq:
  #   unit_instance.time_diff(t[, digits]) -> String
  #
  # Convenience instance method delegating to +Unit.time_diff+.
  # Returns the time difference string with the specified decimal precision.
  #
  def time_diff(t, digits = 4)= self.class.time_diff t, digits

  set :log_level, App.log_level
  set :division, Liza::Controller
  
end

__END__

# view render.txt.erb
<%= render if render_stack.any? -%>
