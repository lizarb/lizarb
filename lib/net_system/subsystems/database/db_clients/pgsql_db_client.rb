class NetSystem::PgsqlDbClient < NetSystem::DbClient
  require "pg"

  # https://www.postgresql.org/
  # https://github.com/ged/ruby-pg
  def initialize(hash={})
    connect(hash)
  end

  def connect(hash)
    t = Time.now
    cl.call({})
    hash = NetBox[:client].get(:pgsql_hash) if hash.empty?
    @conn = PG::Connection.new(hash)
  ensure
    log "#{Lizarb.time_diff t}s | Connecting to #{hash}"
  end

  attr_reader :conn

  def call sql, *args
    t = Time.now
    result = @conn.exec sql, args

    result
  ensure
    log "#{Lizarb.time_diff t}s | #{sql} | #{args}"
  end

  def now
    call "SELECT NOW();"
  end

end
