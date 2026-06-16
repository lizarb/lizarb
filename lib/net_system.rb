class NetSystem < Liza::System
  class Error < Error; end

  color :light_ruby
  
  has_subsystem :client
  has_subsystem :database
  has_subsystem :filebase
  has_subsystem :record
  has_subsystem :socket

end