class NetSystem::RedisClient < NetSystem::Client
  require "redis"

  # https://redis.io/
  # https://github.com/redis/redis-rb
  def initialize *args
    self.class.call({})
    t = Time.now
    args = [url: NetBox[:client].get(:redis_url)] if args.empty?
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
