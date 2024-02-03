class DevSystem::GeneratorPanel < Liza::Panel
  class Error < StandardError; end
  class NotFoundError < Error; end

  #

  def call env
    log :high, "env.count is #{env.count}"
    parse env
    find env
    forward env
    inform env
    save env
  rescue Exception => e
    rescue_from_panel(e, with: env)
  end

  #

  def parse env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
    raise NotFoundError, "generator not found" if env[:args].none?

    generator_name, generator_coil = env[:args].first.split(":").map(&:to_sym)

    env[:generator_name_original] = generator_name
    env[:generator_name] = short(generator_name).to_sym
    env[:generator_coil_original] = generator_coil
    env[:generator_coil] = generator_coil
    log :lower, "generator:coil is #{env[:generator_name]}:#{env[:generator_coil]}"
  end

  #

  def find env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
    begin
      k = Liza.const "#{env[:generator_name]}_generator"
      log :higher, k
      env[:generator_class] = k
    rescue Liza::ConstNotFound
      raise NotFoundError, "generator #{env[:generator_name].inspect} not found"
    end
  end

  #

  def forward env
    generator_class = env[:generator_class]

    return forward_base_generator env if generator_class < BaseGenerator
    return forward_generator env if generator_class < Generator
  end

  def forward_base_generator env
    log :higher,  "forwarding"
    env[:args].shift
    env[:generator_class].call env
  end

  def forward_generator env
    method_name = env[:generator_coil]
    method_name = :call if method_name == :default

    args = env[:args][1..-1]
    log :higher,  "#{env[:generator_class]}.#{method_name}(#{args})"
    env[:generator_class].public_send method_name, args
  end

  #

  def inform env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
    env[:generator] or return log :higher, "not implemented"
    env[:generator].inform
  end

  #

  def save env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
    env[:generator] or return log :higher, "not implemented"
    env[:generator].save
  end

end
