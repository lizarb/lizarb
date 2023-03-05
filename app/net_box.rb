class NetBox < Liza::NetBox

  panel :client do
    # Set up your client panel per the DSL in http://guides.lizarb.org/panels/client.html

    set :redis_url, "redis://localhost:6379/15"
    set :sqlite_path, "tmp/app.#{Time.now.to_i}.sqlite" if App.mode == :code
    set :sqlite_path, "app.#{App.mode}.sqlite"

  end

  panel :database do
    # Set up your database panel per the DSL in http://guides.lizarb.org/panels/database.html

    define :redis, RedisDb
    define :sql, SqliteDb
    define :sqlite, SqliteDb

  end

end
