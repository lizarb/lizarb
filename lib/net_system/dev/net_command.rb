class NetSystem::NetCommand < Liza::Command

  def self.call args
    log :higher, "Called #{self} with args #{args}"

    ruby_time   = Time.now
    redis_time  = ::NetBox.databases.redis.now
    sqlite_time = ::NetBox.databases.sqlite.now
    # redis_time  = ::RedisDb.current.now
    # sqlite_time = ::SqliteDb.current.now

      puts <<-OUTPUT.bold

          Time for Ruby:    #{ruby_time.to_s.light_red}
          Time for Redis:   #{redis_time.to_s.light_red}
          Time for Sqlite:  #{sqlite_time.to_s.light_red}

      OUTPUT
    Liza::DevCommand.call []
  end

end
