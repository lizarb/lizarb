class NetSystem < Liza::System
  class Error < Error; end

  color :ruby
  
  panel :client
  panel :database
  panel :record

end
