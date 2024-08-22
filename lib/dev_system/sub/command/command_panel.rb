class DevSystem::CommandPanel < Liza::Panel
  
  define_error(:parse) do |args|
    "could not parse #{args[0].inspect}"
  end

  define_error(:not_found) do |args|
    "command not found: #{args[0].inspect}"
  end

  define_error(:already_set) do |args|
    "input already set to #{@input.inspect}, but trying to set to #{args[0].inspect}"
  end

  def call args
    log :higher, "args = #{args.inspect}"

    return call_not_found args if args.none?

    env = build_env args
    find env
    forward env
    inform env
  # rescue Exception => e
  rescue Error => e
    rescue_from_panel(e, env)
  end

  #

  PARSE_REGEX = /(?<command_given>[A-Za-z0-9_]+)(?::(?<command_action>[a-z0-9_]+))?/

  # Hash command_arg command_given command_action
  def parse string
    md = string.to_s.match PARSE_REGEX
    raise_error :parse, string if md.nil?

    env = md.named_captures.map { [_1.to_sym, _2] }.to_h
    env[:command_arg] = string
    log :higher, "{#{env.map { ":#{_1}=>#{_2.to_s.inspect}" }.join(", ") }}"
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
    raise_error :not_found, env[:command_name]
  end

  def _find string
    k = Liza.const "#{string}_command"
    log :higher, k
    k
  rescue Liza::ConstNotFound
    raise_error :not_found, string
  end

  #

  def forward env
    log :higher,  "forwarding"
    env[:command_class].call env
  end

  #

  def inform env
    return if env[:simple] == nil
    return if env[:simple] == [""]

    env[:simple].shift if env[:simple][0] == ""

    puts if log? :lower

    args = [*env[:args], *env[:simple]].join(" ")

    log sticks :black, system.color, :b,
      ["LIZA"],
      ["HELPS",    :u],
      ["YOU",      :u, :i],
      ["REMEMBER", :i] \
        if log? :lower
    
    log stick system.color, "#{ $0.split("/").last } #{ env[:command_arg] } #{ args }" if log? :lower
  end

  #

  def call_not_found args
    Liza[:NotFoundCommand].call args
  end

  #

  def input name = nil
    return (@input || InputCommand) if name.nil?
    raise_error :already_set, name
    @input = _find "#{name}_input"
  end

  def pick_one title, options = ["Yes", "No"]
    if log_level? :lowest
      puts
      log "Pick One"
    end
    # input.pick_one title, options
    TtyInputCommand.pick_one title, options
  end

  def pick_many title, options
    if log_level? :lowest
      puts
      log "Pick Many"
    end
    # input.pick_many title, options
    TtyInputCommand.multi_select title, options
  end

end
