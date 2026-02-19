class DevBox < DevSystem::DevBox

  configure :bench do
    # Bench.panel gives you read-access to this instance
    #
  end

  configure :command do
    # Command.panel gives you read-access to this instance
    shortcut :b, :bench
    shortcut :g, :generate
    shortcut :i, :irb
    shortcut :l, :log
    shortcut :p, :pry
    shortcut :sh, :shell
    shortcut :t, :test
  end

  configure :generator do
    # Generator.panel gives you read-access to this instance

    shortcut :c, :command
    shortcut :sh, :shell
  end

  configure :log do
    # Log.panel gives you read-access to this instance

    handler :output   if not $coding
    handler :color_output if $coding
  end

  configure :shell do
    # Shell.panel gives you read-access to this instance
    # converters
    converter :html, :md
    converter :html, :haml
    converter :js,   :coffee
    converter :css,  :scss

    # formatters
    formatter :html
    formatter :html, :xml

    # renderers
    renderer :erb
  end

end
