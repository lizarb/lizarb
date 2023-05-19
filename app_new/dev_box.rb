class DevBox < Liza::DevBox

  configure :bench do
    #
  end

  configure :command do
    set :log_details?, true
    
    short :b, :bench
    short :g, :generate
  end

end
