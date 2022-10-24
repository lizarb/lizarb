class NetSystem
  class RedisClient < Client

    # https://redis.io/
    # https://github.com/redis/redis-rb
    def initialize *args
      args = [url: Liza.const(:net_box).clients.get(:redis_url)] if args.empty?
      log "Connecting to #{args}"
      @conn = Redis.new *args
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
end
