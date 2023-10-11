class DevBox < DevSystem::DevBox

  # Configure your command panel
  
  configure :command do
    set :log_details, false
    
    short :b, :bench
    short :g, :generate

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    rescue_from CommandPanel::NotFoundError, with: NotFoundCommand
  end

  # Configure your generator panel
  
  configure :generator do
    set :log_details, false

    # formatters
    # formatter :html

    # converters
    # converter :html, :md
    # converter :html, :haml
    # converter :js,   :coffee
    # converter :css,  :scss

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    rescue_from GeneratorPanel::ParseError, with: NotFoundGenerator
  end

  # Configure your log panel
  
  configure :log do
    # handlers
    handler :output
    # handler :logger

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding
  end

  # Configure your terminal panel
  
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

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding
  end
end
