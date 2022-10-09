class NetSystem
  class RedisDb < Database
    set_adapter :redis

    def now
      array = adapter.now
      Time.at array[0]
    end

  end
end
