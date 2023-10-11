class NetSystem::NetBox < Liza::Box

  # Preconfigure your client panel
  
  configure :client do
    # set :log_level, ENV["net.client.log_level"]
  end

  # Preconfigure your database panel

  configure :database do
    # set :log_level, ENV["net.database.log_level"]
  end

  # Preconfigure your record panel

  configure :record do
    # set :log_level, ENV["net.record.log_level"]

  end
  
end
