class NetSystem
  class NetBox < Liza::Box
    has_panel :client, :clients
    has_controller :client, :clients

    begin
      raise "remove the deprecation warning below" unless ["1.0.0", "1.1.0"].include? Lizarb::VERSION

      def self.adapters
        raise "please rename this method to `clients`"
      end
    end

    # Set up your client panel per the DSL in http://guides.lizarb.org/panels/client.html
    clients do
      # set :log_level, ENV["net.client.log_level"]
    end

    has_panel :database, :databases
    has_controller :database, :databases

    # Set up your database panel per the DSL in http://guides.lizarb.org/panels/database.html
    databases do
      # set :log_level, ENV["net.database.log_level"]
    end

  end
end
