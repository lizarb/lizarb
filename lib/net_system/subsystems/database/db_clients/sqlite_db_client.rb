class NetSystem::SqliteDbClient < NetSystem::DbClient
  require "sqlite3"

  # https://www.sqlite.org/
  # https://github.com/sparklemotion/sqlite3-ruby
  def initialize(*args)
    connect(*args)
  end

  def connect(*args)
    t = Time.now
    cl.call({})
    if args.empty?
      h = NetBox[:client].get(:sqlite_hash)
      args = [h[:path]]
    end
    @conn = SQLite3::Database.new(*args)
  ensure
    log "#{Lizarb.time_diff t}s | Connecting to #{args}"
  end

  attr_reader :conn

  def call sql, *args
    t = Time.now
    result = @conn.execute2 sql, *args

    result
  ensure
    log "#{Lizarb.time_diff t}s | #{sql} | #{args}"
  end

  def now
    call "SELECT strftime('%Y-%m-%dT%H:%M:%S.%f', 'now', 'localtime');"
  end

end
