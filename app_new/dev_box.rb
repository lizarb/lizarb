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

  configure :terminal do
    set :log_details, false

    # default (pick one)
    default :irb
    # default :pry

    # input (pick one)
    # input :highline # gem "highline"
    input :tty # gem "tty-prompt"

    # pallet (pick one)
    # pallet :solarized
    # pallet :nord
  end
end
