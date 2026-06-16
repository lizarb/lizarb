class PrimeSystem < Liza::System

  section :default

  color :topaz

  section :info

  #

  has_subsystem :agent
  has_subsystem :epic
  has_subsystem :insight

end