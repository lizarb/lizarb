class DevBox < DevSystem::DevBox

  configure :command do
    # CommandPanel.instance gives you read-access to this instance
    short :b, :bench
    short :g, :generate
    short :i, :irb
    short :l, :log
    short :p, :pry
    short :s, :shell
    short :t, :test
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
  end

end
