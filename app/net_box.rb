class NetBox < Liza::NetBox

  configure :client do
    # Configure your client panel per the DSL in http://guides.lizarb.org/panels/client.html

    set :redis_url, "redis://localhost:6379/15"
    set :sqlite_path, "tmp/app.#{Time.now.to_i}.sqlite" if $code_mode
    set :sqlite_path, "app.#{App.mode}.sqlite"

  end

  configure :database do
    # Configure your database panel per the DSL in http://guides.lizarb.org/panels/database.html

    define :redis, RedisDb
    define :sql, SqliteDb
    define :sqlite, SqliteDb

  end

end
