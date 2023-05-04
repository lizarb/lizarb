class DevBox < Liza::DevBox

  configure :bench do
    #
  end

  configure :command do
    short :b, :bench
    short :g, :generate
  end

end
