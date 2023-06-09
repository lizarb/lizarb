class DevBox < Liza::DevBox

  configure :bench do
    #
  end

  configure :command do
    set :log_details, false
    
    short :b, :bench
    short :g, :generate
  end

  configure :generator do
    set :log_details, false

    # formatters
    formatter :html if defined? HtmlBeautifier
  end

end
