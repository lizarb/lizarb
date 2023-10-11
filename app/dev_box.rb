class DevBox < DevSystem::DevBox

  # Configure your bench panel

  configure :bench do
    # set :log_level, ENV["dev.bench.log_level"]
  end

  # Configure your command panel

  configure :command do
    # set :log_level, ENV["dev.command.log_level"]
    set :log_details, false

    short :b, :bench
    short :g, :generate
    short :t, :terminal

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    rescue_from CommandPanel::NotFoundError, with: NotFoundCommand
  end

  # Configure your generator panel

  configure :generator do
    # set :log_level, ENV["dev.generator.log_level"]
    set :log_details, false

    # formatters
    formatter :html if defined? HtmlBeautifier

    # converters
    converter :html, :md     if defined? CommonMarker
    converter :html, :haml   if defined? Haml
    converter :js,   :coffee if defined? CoffeeScript
    converter :css,  :scss   if defined? SassC

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    rescue_from GeneratorPanel::ParseError, with: NotFoundGenerator
  end

  # Configure your log panel

  configure :log do
    # set :log_level, ENV["dev.log.log_level"]

    # handlers
    handler :output
    # handler :logger

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding
  end

  # Configure your shell panel

  configure :shell do
    # set :log_level, ENV["dev.shell.log_level"]
  end

  # Configure your terminal panel

  configure :terminal do
    # set :log_level, ENV["dev.terminal.log_level"]
    set :log_details, false
    
    # default (pick one)
    default :irb
    # default :pry

    # input (pick one)
    # input :highline # gem "highline"
    input :tty # gem "tty-prompt"

    # pallet (pick one)
    # pallet :solarized
    # pallet :nord

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding
  end

end
