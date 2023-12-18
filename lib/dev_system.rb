class DevSystem < Liza::System
  class Error < Error; end

  #

  color :green

  sub :bench
  sub :command
  sub :generator
  sub :log
  sub :shell
  
end
