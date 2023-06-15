class DevBox < Liza::DevBox

  configure :command do
    set :log_details, false
    
    short :b, :bench
    short :g, :generate
  end

  configure :generator do
    set :log_details, false

    # formatters
    formatter :html if defined? HtmlBeautifier

    # converters
    converter :html, :md     if defined? CommonMarker
    converter :html, :haml   if defined? Haml
    converter :js,   :coffee if defined? CoffeeScript
    converter :css,  :scss   if defined? SassC
  end

end
