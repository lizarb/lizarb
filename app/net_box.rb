class NetBox < Liza::NetBox

  configure :client do
    # Configure your client panel per the DSL in http://guides.lizarb.org/panels/client.html

    set :redis_url, "redis://localhost:6379/15"
    set :mongo_hash,  host: "localhost",
                      port: 27017,
                      connect: :direct,
                      database: "app_1_#{App.mode}"
    set :sqlite_path, "tmp/app.#{Time.now.to_i}.sqlite" if $coding
    set :sqlite_path, "app.#{App.mode}.sqlite"
    set :mysql_hash,  host:     "localhost",
                      port:     3306,
                      username: "root",
                      password: "123123123",
                      database: "app_1_#{App.mode}"
    set :pgsql_hash,  host:     "localhost",
                      port:     5432,
                      user:     "postgres",
                      password: "postgres",
                      dbname:   "app_1_#{App.mode}"

  end

  configure :database do
    # Configure your database panel per the DSL in http://guides.lizarb.org/panels/database.html

    define :redis, RedisDb
    define :mongo, MongoDb
    define :sql, SqliteDb
    define :sqlite, SqliteDb
    define :mysql, MysqlDb
    define :pgsql, PgsqlDb

  end

end
