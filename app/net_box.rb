class NetBox < NetSystem::NetBox

  configure :client do
    # ClientPanel.instance gives you read-access to this instance
    set :redis_hash,  host:     "localhost",
                      port:     6379,
                      # password: "",
                      # protocol: "redis",
                      database: ($coding ? 0 : 1)
    set :mongo_hash,  host: "localhost",
                      port: 27017,
                      # password: "",
                      # protocol: "mongodb",
                      database: "app_1_#{App.mode}"
    set :sqlite_hash, path:     "app.#{App.mode}.sqlite"
    set :sqlite_hash, path:     "tmp/app.#{Time.now.to_i}.sqlite" if $coding
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