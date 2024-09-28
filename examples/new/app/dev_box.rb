class DevBox < DevSystem::DevBox

  # Configure your command panel

  configure :command do
    short :b, :bench
    short :g, :generate
    short :i, :irb
    short :l, :log
    short :p, :pry
    short :s, :shell
    short :t, :test
  end

  # Configure your log panel

  configure :log do
    sidebar_size 40

    # handlers
    handler :output   if not $coding
    handler :color_output if $coding
  end

  # Configure your shell panel

  configure :shell do
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
