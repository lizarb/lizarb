class DevSystem::InputShell < DevSystem::Shell

  # Liza lazily requires gems required in Controllers
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

  def self.pick_one title, options = ["Yes", "No"], default: nil
    prompt.select title, options, filter: true, show_help: :always, per_page: 20, default: default
  rescue Exception => e
    rescue_input_interrupt e
  end

  def self.pick_color title = "Pick a color", string: nil
    options = ColorShell.colors.map { [(stick _2, "#{string} # #{_1}", :b), _1] }.to_h

    prompt.select \
      title,
      options,
      filter: true, show_help: :always, per_page: 28
  rescue Exception => e
    rescue_input_interrupt e
  end

  def self.pick_log_level(title = "Which log level?", default: )
    choices = {
      "lowest"  => 1,
      "lower"   => 2,
      "low"     => 3,
      "normal"  => 4,
      "high"    => 5,
      "higher"  => 6,
      "highest" => 7,
    }
    answer = pick_one title, choices.keys, default: default
    choices[answer]
  end

  def self.pick_writeable_domains(title)
    domains = AppShell.get_writable_domains
    pick_domains title, domains: domains
  end

  def self.pick_domains(domains, default, title)
    choices = domains.map do
      color = _2.color rescue :white
      [(stick color, _2.to_s).to_s, _1]
    end.to_h
    multi_select title, choices, selected: default
  end

  def self.multi_select title, choices, selected: :all
    raise ArgumentError, "choices must be a hash", caller unless choices.is_a? Hash
    return choices if choices.empty?
    
    default = 1..choices.count if selected == :all
    default = [] if selected == :none
    default = selected.map { choices.values.index(_1) + 1 } if selected.is_a? Array

    options = {
      enum: ")",
      per_page: 30,
      help: "(space to select, enter to finish)",
      show_help: :always,
      default: default
    }
    prompt.multi_select title, choices, options
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
