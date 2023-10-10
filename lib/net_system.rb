class NetSystem < Liza::System
  class Error < Error; end

  set :log_color, :red
  color :ruby
  
  sub :client
  sub :database
  sub :record

end
