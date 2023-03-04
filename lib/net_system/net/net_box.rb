class NetSystem::NetBox < Liza::Box

  # Set up your client panel per the DSL in http://guides.lizarb.org/panels/client.html
  panel :client do
    # set :log_level, ENV["net.client.log_level"]
  end

  # Set up your database panel per the DSL in http://guides.lizarb.org/panels/database.html
  panel :database do
    # set :log_level, ENV["net.database.log_level"]
  end

  has_controller :client, :client
  has_controller :database, :database
end
