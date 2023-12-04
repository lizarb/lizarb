class DevBox < DevSystem::DevBox

  # Configure your bench panel

  configure :bench do
    
  end

  # Configure your command panel

  configure :command do
    short :b, :bench
    short :g, :generate
    short :i, :irb
    short :l, :log
    short :p, :pry
    short :s, :shell
    short :t, :test

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    # uncomment below to override default setting to call NotFoundCommand
    # rescue_from(CommandPanel::NotFoundError) { |rescuer| binding.irb } if $coding
  end

  # Configure your generator panel

  configure :generator do
    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    # uncomment below to override default setting to call NotFoundGenerator
    # rescue_from(GeneratorPanel::NotFoundError) { |rescuer| binding.irb } if $coding
  end

  # Configure your log panel

  configure :log do
    # handlers
    handler :output

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding
  end

  # Configure your shell panel

  configure :shell do
    # formatters
    formatter :html
    formatter :html, :xml

    # converters
    converter :html, :md
    converter :html, :haml
    converter :js,   :coffee
    converter :css,  :scss
  end

end
