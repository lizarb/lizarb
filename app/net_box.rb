class NetBox < NetSystem::NetBox

  configure :client do
    # ClientPanel.instance gives you read-access to this instance
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
    # DatabasePanel.instance gives you read-access to this instance
  end
  
  configure :filebase do
    # FilebasePanel.instance gives you read-access to this instance
  end

  configure :record do
    # RecordPanel.instance gives you read-access to this instance
  end

  configure :socket do
    # SocketPanel.instance gives you read-access to this instance
  end

end