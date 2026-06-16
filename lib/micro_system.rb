class MicroSystem < Liza::System
  class Error < Liza::Error; end

  #

  color :dark_coral

  has_subsystem :ship
end