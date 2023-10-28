class DevBox < DevSystem::DevBox

  # Configure your command panel
  
  configure :command do
    short :b, :bench
    short :g, :generate
    short :i, :irb
    short :p, :pry
    short :s, :shell
    short :t, :test

    # input (pick one)
    # input :highline
    input :tty

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    rescue_from CommandPanel::NotFoundError, with: NotFoundCommand
  end

  # Configure your generator panel
  
  configure :generator do
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

  # Configure your shell panel

  configure :shell do
    # set :log_level, ENV["dev.shell.log_level"]

    # formatters
    formatter :html

    # converters
    converter :html, :md
    converter :html, :haml
    converter :js,   :coffee
    converter :css,  :scss
  end
  
end
