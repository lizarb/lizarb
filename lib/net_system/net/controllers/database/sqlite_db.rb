class NetSystem
  class SqliteDb < Database
    set_adapter :sqlite

    def now
      array = adapter.now
      Time.parse array[1][0]
    end

  end
end
