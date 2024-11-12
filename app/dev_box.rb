class DevBox < DevSystem::DevBox

  configure :bench do
    # BenchPanel.instance gives you read-access to this instance
    #
  end

  configure :command do
    # CommandPanel.instance gives you read-access to this instance
    shortcut :b, :bench
    shortcut :g, :generate
    shortcut :i, :irb
    shortcut :l, :log
    shortcut :p, :pry
    shortcut :s, :shell
    shortcut :t, :test

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    # uncomment below to override default setting to call NotFoundCommand
    # rescue_from(CommandPanel::NotFoundError) { |rescuer| binding.irb } if $coding
  end

  configure :generator do
    # GeneratorPanel.instance gives you read-access to this instance
    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    # uncomment below to override default setting to call NotFoundGenerator
    # rescue_from(GeneratorPanel::NotFoundError) { |rescuer| binding.irb } if $coding
  end

  configure :log do
    # LogPanel.instance gives you read-access to this instance
    # handlers
    handler :output   if not $coding
    handler :color_output if $coding

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding
  end

  configure :shell do
    # ShellPanel.instance gives you read-access to this instance
    # converters
    converter :html, :md
    converter :html, :haml
    converter :js,   :coffee
    converter :css,  :scss
    
    # formatters
    formatter :html
    formatter :html, :xml
  end

end
