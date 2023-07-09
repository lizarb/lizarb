class NetSystem::NetCommand < Liza::Command

  def self.call args
    log "args = #{args.inspect}"

    ruby_time   = Time.now
    redis_time  = NetBox[:database].redis.new.now
    sqlite_time = NetBox[:database].sqlite.new.now
    # redis_time  = ::RedisDb.current.now
    # sqlite_time = ::SqliteDb.current.now


    log "Time for Ruby:    #{_red ruby_time}".bold
    log "Time for Redis:   #{_red redis_time}".bold
    log "Time for Sqlite:  #{_red sqlite_time}".bold
  end

  def self._red s
    s.to_s.light_red
  end

end
