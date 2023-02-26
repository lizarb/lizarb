class WebSystem::RackCommand < Liza::Command

  def self.call args
    log "args #{args}"

    strategy = nil
    host = nil
    port = nil

    if args.any? && !args[0].include?("=")
      strategy = args.shift
    end

    args.each do |arg|
      host = arg.split("=")[1] if arg.start_with? "h="
      port = arg.split("=")[1] if arg.start_with? "p="
    end

    log({strategy:, host:, port:})

    Liza.const(:web_box).rack.call strategy, host, port
  end

end
