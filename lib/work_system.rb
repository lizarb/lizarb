class WorkSystem < Liza::System
  class Error < Liza::Error; end

  #

  color :saffron
  
  panel :event

  panel :observer
  panel :publisher
end