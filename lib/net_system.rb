class NetSystem < Liza::System
  class Error < Error; end

  color :ruby
  
  sub :client
  sub :database
  sub :record

end
