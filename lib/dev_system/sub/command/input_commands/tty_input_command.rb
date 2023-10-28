class DevSystem::TtyInputCommand < DevSystem::InputCommand

  def self.prompt
    require "tty-prompt"
    @prompt ||= TTY::Prompt.new symbols: {marker: ">", radio_on: "x", radio_off: " "}
  end

  def self.pick_one title, options = ["Yes", "No"]
    prompt.select title, options, filter: true, show_help: :always, per_page: 20
  rescue TTY::Reader::InputInterrupt
    puts
    puts
    log "Control-C"
    exit
  end

  #

  def self.multi_select title, choices
    raise "choices must be a hash" unless choices.is_a? Hash
    return choices if choices.empty?
    
    options = {
      enum: ")",
      per_page: 20,
      help: "(space to select, enter to finish)",
      show_help: :always,
      default: 1..choices.count
    }
    prompt.multi_select title, choices, options
  rescue TTY::Reader::InputInterrupt
    puts
    puts
    log "Control-C"
    exit
  end
    

end
