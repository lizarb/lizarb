class NetSystem::DatabaseCommand < DevSystem::Command

  def self.call args
    log "args = #{args.inspect}"

    ruby_time   = Time.now
    redis_time  = NetBox[:database].redis.new.now
    mongo_time  = NetBox[:database].mongo.new.now
    sqlite_time = NetBox[:database].sqlite.new.now
    mysql_time  = NetBox[:database].mysql.new.now
    pgsql_time  = NetBox[:database].pgsql.new.now
    # redis_time  = ::RedisDb.current.now
    # mongo_time  = ::MongoDb.current.now
    # sqlite_time = ::SqliteDb.current.now
    # mysql_time  = ::MysqlDb.current.now
    # pgsql_time  = ::PgsqlDb.current.now

    log "Time for Ruby:    #{_red ruby_time}".bold
    log "Time for Redis:   #{_red redis_time}".bold
    log "Time for Mongo:   #{_red mongo_time}".bold
    log "Time for Sqlite:  #{_red sqlite_time}".bold
    log "Time for Mysql:   #{_red mysql_time}".bold
    log "Time for Pgsql:   #{_red pgsql_time}".bold


  end

  def self._red s
    s.to_s.light_red
  end

end
