class WorkSystem < Liza::System
  class Error < Liza::Error; end

  #

  color :light_saffron

  panel :event
  panel :publisher
  panel :subscriber

end