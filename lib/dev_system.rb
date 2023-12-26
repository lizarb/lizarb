class DevSystem < Liza::System
  class Error < Error; end

  #

  color :green

  panel :bench
  panel :command
  panel :generator
  panel :log
  panel :shell
  
end
