class DevSystem < Liza::System
  class Error < Error; end

  #

  color :light_green

  sub :bench
  sub :command
  sub :generator
  sub :log
  sub :shell
  sub :terminal
  
end
