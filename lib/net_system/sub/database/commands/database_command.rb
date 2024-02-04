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

    log "Time for Ruby:    #{_red ruby_time}"
    log "Time for Redis:   #{_red redis_time}"
    log "Time for Mongo:   #{_red mongo_time}"
    log "Time for Sqlite:  #{_red sqlite_time}"
    log "Time for Mysql:   #{_red mysql_time}"
    log "Time for Pgsql:   #{_red pgsql_time}"
  end

  def self._red s
    stick :light_red, s
  end

end
