class DevSystem < Liza::System
  class Error < Liza::Error; end

  #

  set :log_color, :green

  sub :bench
  sub :command
  sub :generator
  sub :log
  sub :shell
  sub :terminal
  
end
