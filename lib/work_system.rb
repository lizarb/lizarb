class WorkSystem < Liza::System
  class Error < Liza::Error; end

  #

  color :light_saffron

  has_subsystem :event
  has_subsystem :publisher
  has_subsystem :subscriber

end