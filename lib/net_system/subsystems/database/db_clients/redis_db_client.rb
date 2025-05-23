class NetSystem::RedisDbClient < NetSystem::DbClient
  require "redis"

  # https://redis.io/
  # https://github.com/redis/redis-rb
  def initialize *args
    self.class.call({})
    t = Time.now
    if args.empty?
      h = NetBox[:client].get(:redis_hash)
      host = h[:host]
      port = h[:port]
      password = h[:password]
      protocol = h[:protocol] || "redis"
      database = h[:database]

      redis_url =
        if password.to_s.size.positive?
          "#{protocol}://:#{password}@#{host}:#{port}/#{database}"
        else
          "#{protocol}://#{host}:#{port}/#{database}"
        end

      args = [url: redis_url]
    end
    @conn = Redis.new(*args)
  ensure
    log "#{t.diff}s | Connecting to #{args}"
  end

  attr_reader :conn

  def call cmd_name, *args
    t = Time.now
    result = @conn.send cmd_name, *args

    result
  ensure
    log "#{t.diff}s | #{cmd_name} | #{args}"
  end

  def now
    call :time
  end

end
