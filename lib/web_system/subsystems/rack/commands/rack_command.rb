class WebSystem::RackCommand < DevSystem::SimpleCommand

  def call_default
    t = Time.now
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

    menv = {server:, host:, port:}

    log menv

    rack_panel.call menv
  ensure
    log "#{ t.diff }s | server closed on port #{ port }"
  end

  def rack_panel
    @rack_panel ||= WebBox[:rack]
  end

end
