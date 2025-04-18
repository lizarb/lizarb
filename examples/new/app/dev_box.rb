class DevBox < DevSystem::DevBox

  configure :command do
    # CommandPanel.instance gives you read-access to this instance
    shortcut :b, :bench
    shortcut :g, :generate
    shortcut :i, :irb
    shortcut :l, :log
    shortcut :p, :pry
    shortcut :s, :shell
    shortcut :t, :test
  end

  configure :generator do
    # GeneratorPanel.instance gives you read-access to this instance
    shortcut :c, :command
    shortcut :s, :shell
  end

  configure :log do
    # LogPanel.instance gives you read-access to this instance
    sidebar_size 40

    # handlers
    handler :output   if not $coding
    handler :color_output if $coding
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

    # renderers
    renderer :erb
  end

end
