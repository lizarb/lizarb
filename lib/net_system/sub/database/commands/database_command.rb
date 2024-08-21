class NetSystem::DatabaseCommand < DevSystem::SimpleCommand

  def call_default
    ruby_time   = Time.now
    redis_time  = RedisDb.current.now
    mongo_time  = MongoDb.current.now
    sqlite_time = SqliteDb.current.now
    mysql_time  = MysqlDb.current.now
    pgsql_time  = PgsqlDb.current.now

    log "Time for Ruby:    #{_red ruby_time}"
    log "Time for Redis:   #{_red redis_time}"
    log "Time for Mongo:   #{_red mongo_time}"
    log "Time for Sqlite:  #{_red sqlite_time}"
    log "Time for Mysql:   #{_red mysql_time}"
    log "Time for Pgsql:   #{_red pgsql_time}"
  end

  def _red s
    stick NetSystem.color, s.to_s
  end

end
