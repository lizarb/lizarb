class NetSystem::PgsqlClient < NetSystem::Client

  # https://www.postgresql.org/
  # https://github.com/ged/ruby-pg
  def initialize hash={}
    hash = NetBox[:client].get(:pgsql_hash) if hash.empty?
    log "Connecting to #{hash}"
    @conn = PG::Connection.new(hash)
  end

  attr_reader :conn

  def call sql, *args
    t = Time.now
    result = @conn.exec sql, args

    result
  ensure
    log "#{t.diff}s | #{sql} | #{args}"
  end

  def now
    call "SELECT NOW();"
  end

end
