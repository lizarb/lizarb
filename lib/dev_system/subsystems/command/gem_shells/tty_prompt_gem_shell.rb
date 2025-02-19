class DevSystem::TtyPromptGemShell < DevSystem::GemShell
  require "tty-prompt"

  def self.prompt
    call({})
    @prompt ||= TTY::Prompt.new symbols: {marker: ">", radio_on: "x", radio_off: " "}
  end

  def self.ask(...)
    prompt.ask(...)
  rescue Exception => e
    rescue_input_interrupt e
  end

  def self.select(...)
    prompt.select(...)
  rescue Exception => e
    rescue_input_interrupt e
  end

  def self.yes?(...)
    prompt.yes?(...)
  rescue Exception => e
    rescue_input_interrupt e
  end

  def self.rescue_input_interrupt(e)
    log :higher, "#{e.class}: #{e.message}"
    raise e unless defined? TTY
    raise e unless e.is_a? TTY::Reader::InputInterrupt
    puts
    puts
    log "Control-C"
    exit
  end

end
