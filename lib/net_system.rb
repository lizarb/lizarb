class NetSystem < Liza::System
  class Error < Error; end

  color :light_ruby
  
  panel :client
  panel :database
  panel :filebase
  panel :record
  panel :socket

end