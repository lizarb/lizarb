class WorkSystem < Liza::System
  class Error < Liza::Error; end

  #

  color :saffron

  panel :event
  panel :publisher
  panel :subscriber

end