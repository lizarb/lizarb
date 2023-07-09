class NetSystem::NetBox < Liza::Box

  # Configure your client panel per the DSL in http://guides.lizarb.org/panels/client.html
  configure :client do
    # set :log_level, ENV["net.client.log_level"]
  end

  # Configure your database panel per the DSL in http://guides.lizarb.org/panels/database.html
  configure :database do
    # set :log_level, ENV["net.database.log_level"]
  end

end
