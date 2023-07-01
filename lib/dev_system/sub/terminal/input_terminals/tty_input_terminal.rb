class DevSystem::TtyInputTerminal < DevSystem::Terminal

  def self.prompt
    @prompt ||= TTY::Prompt.new symbols: {marker: ">", radio_on: "x", radio_off: " "}
  end

  def self.pick_one title, options = ["Yes", "No"]
    log "#{title} #{options.inspect}"
    prompt.select title, options, filter: true, show_help: :always
  end

end
