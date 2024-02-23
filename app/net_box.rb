class NetBox < NetSystem::NetBox

  # Configure your client panel

  configure :client do
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

  # Configure your database panel

  configure :database do

  end

  # Configure your record panel

  configure :record do

  end
  
end
