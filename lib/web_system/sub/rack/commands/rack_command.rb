class WebSystem::RackCommand < Liza::Command

  def call args
    log "args = #{args.inspect}"

    server = nil
    host = nil
    port = nil

    if args.any? && !args[0].include?("=")
      server = args.shift
    end

    args.each do |arg|
      host = arg.split("=")[1] if arg.start_with? "h="
      port = arg.split("=")[1] if arg.start_with? "p="
    end

    log({server:, host:, port:})

    rack_panel.call server, host, port
  end

  def rack_panel
    @rack_panel ||= WebBox[:rack]
  end

end
