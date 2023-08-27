class NetSystem < Liza::System
  class Error < Error; end

  set :log_color, :red
  
  sub :client
  sub :database

end
