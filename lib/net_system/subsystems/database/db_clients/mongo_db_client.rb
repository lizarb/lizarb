class NetSystem::MongoDbClient < NetSystem::DbClient
  require "mongo"

  # https://www.mongodb.com/
  # https://github.com/mongodb/mongo-ruby-driver
  def initialize(hash={})
    connect(hash)
  end

  def connect(hash)
    t = Time.now
    cl.call({})
    hash = NetBox[:client].get(:mongo_hash) if hash.empty?
    host = hash[:host]
    port = hash[:port]
    username = hash[:username]
    password = hash[:password]
    protocol = hash[:protocol] || "mongodb"
    database = hash[:database]

    uri =
      if password.to_s.size.positive?
        "#{protocol}://#{username}:#{password}@#{host}:#{port}/#{database}"
      else
        "#{protocol}://#{host}:#{port}/#{database}"
      end

    @conn = Mongo::Client.new(uri)
  ensure
    log "#{time_diff t}s | Connecting to #{hash}"
  end

  attr_reader :conn

  def call args
    t = Time.now
    raise NotImplementedError
  ensure
    log "#{time_diff t}s | #{cmd_name} | #{args}"
  end

  def now
    t0 = Time.now
    server_status = @conn.database.command(serverStatus: 1)
    t = server_status.first['localTime']
    Time.at t.to_i
  ensure
    log "#{time_diff t0}s | now | []"
  end

end
