class NetSystem
  class NetBox < Liza::Box
    has_panel :adapter, :adapters
    has_controller :adapter, :adapters

    # Set up your adapter panel per the DSL in http://guides.lizarb.org/panels/adapter.html
    adapters do
      # set :log_level, ENV["net.adapter.log_level"]
    end

    has_panel :database, :databases
    has_controller :database, :databases

    # Set up your database panel per the DSL in http://guides.lizarb.org/panels/database.html
    databases do
      # set :log_level, ENV["net.database.log_level"]
    end

  end
end
