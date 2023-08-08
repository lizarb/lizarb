class NetSystem::SqliteClient < NetSystem::Client

  # https://www.sqlite.org/
  # https://github.com/sparklemotion/sqlite3-ruby
  def initialize *args
    t = Time.now
    args = [NetBox[:client].get(:sqlite_path)] if args.empty?
    @conn = SQLite3::Database.new(*args)
  ensure
    log "#{t.diff}s | Connecting to #{args}"
  end

  attr_reader :conn

  def call sql, *args
    t = Time.now
    result = @conn.execute2 sql, *args

    result
  ensure
    log "#{t.diff}s | #{sql} | #{args}"
  end

  def now
    call "SELECT strftime('%Y-%m-%dT%H:%M:%S.%f', 'now', 'localtime');"
  end

end
