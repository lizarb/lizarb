class DevSystem < Liza::System
  class Error < Error; end

  #

  set :log_color, :green
  color :light_green

  sub :bench
  sub :command
  sub :generator
  sub :log
  sub :shell
  sub :terminal
  
end
