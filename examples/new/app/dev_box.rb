class DevBox < Liza::DevBox

  configure :command do
    set :log_details, false
    
    short :b, :bench
    short :g, :generate

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    rescue_from CommandPanel::NotFoundError, with: NotFoundCommand
  end

  configure :generator do
    set :log_details, false

    # formatters
    formatter :html if defined? HtmlBeautifier

    # converters
    converter :html, :md     if defined? CommonMarker
    converter :html, :haml   if defined? Haml
    converter :js,   :coffee if defined? CoffeeScript
    converter :css,  :scss   if defined? SassC

    # rescue_from declarations are checked bottom to top

    rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    rescue_from GeneratorPanel::ParseError, with: NotFoundGenerator
  end

  configure :log do
    # handlers
    handler :output
    # handler :logger

    # rescue_from declarations are checked bottom to top

    rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    rescue_from(StandardError)  { |rescuer| binding.irb } if $coding
  end

  configure :terminal do
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

    rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    rescue_from(StandardError)  { |rescuer| binding.irb } if $coding
  end
end
