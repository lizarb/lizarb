class NetSystem < Liza::System
  set :log_color, :red
  
  sub :client
  sub :database

end
