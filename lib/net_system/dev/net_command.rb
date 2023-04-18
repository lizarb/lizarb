class NetSystem::NetCommand < Liza::Command

  def self.call args
    log :higher, "Called #{self} with args #{args}"

    ruby_time   = Time.now
    redis_time  = NetBox[:database].redis.new.now
    sqlite_time = NetBox[:database].sqlite.new.now
    # redis_time  = ::RedisDb.current.now
    # sqlite_time = ::SqliteDb.current.now

      puts <<-OUTPUT.bold

          Time for Ruby:    #{ruby_time.to_s.light_red}
          Time for Redis:   #{redis_time.to_s.light_red}
          Time for Sqlite:  #{sqlite_time.to_s.light_red}

      OUTPUT
  end

end
