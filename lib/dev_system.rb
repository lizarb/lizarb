class DevSystem < Liza::System
  class Error < Error; end

  #

  color :green

  has_subsystem :bench
  has_subsystem :command
  has_subsystem :generator
  has_subsystem :log
  has_subsystem :shell

end
