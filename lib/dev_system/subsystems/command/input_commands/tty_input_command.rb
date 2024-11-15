class DevSystem::TtyInputCommand < DevSystem::InputCommand
  require "tty-prompt"

  def self.prompt
    call({})
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

  def self.pick_color title = "Pick a color", string: nil
    options = ColorShell.colors.map { [(stick _2, "#{string} # #{_1}", :b), _1] }.to_h

    prompt.select \
      title,
      options,
      filter: true, show_help: :always, per_page: 28
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
      per_page: 30,
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
