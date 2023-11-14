class DevBox < DevSystem::DevBox

  # Configure your bench panel

  configure :bench do
    # set :log_level, ENV["dev.bench.log_level"]
  end

  # Configure your command panel

  configure :command do
    # set :log_level, ENV["dev.command.log_level"]

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

    rescue_from CommandPanel::NotFoundError, with: NotFoundCommand
  end

  # Configure your generator panel

  configure :generator do
    # set :log_level, ENV["dev.generator.log_level"]

    # rescue_from declarations are checked bottom to top

    # rescue_from(Exception)      { |rescuer| binding.irb } if $coding
    # rescue_from(StandardError)  { |rescuer| binding.irb } if $coding

    rescue_from GeneratorPanel::NotFoundError, with: NotFoundGenerator
  end

  # Configure your log panel

  configure :log do
    # set :log_level, ENV["dev.log.log_level"]

    # handlers
    handler :output

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
