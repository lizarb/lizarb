class NetSystem::MongoClient < NetSystem::Client

  # https://www.mongodb.com/
  # https://github.com/mongodb/mongo-ruby-driver
  def initialize *args
    t = Time.now
    hash = NetBox[:client].get(:mongo_hash)  # if args.empty?

    uri = uri = "mongodb://#{hash[:host]}:#{hash[:port]}/#{hash[:database]}"

    @conn = Mongo::Client.new(uri)
  ensure
    log "#{t.diff}s | Connecting to #{args}"
  end

  attr_reader :conn

  def call args
    t = Time.now
    raise NotImplementedError
  ensure
    log "#{t.diff}s | #{cmd_name} | #{args}"
  end

  def now
    server_status = @conn.database.command(serverStatus: 1)
    t = server_status.first['localTime']
    Time.at t.to_i
  end

end
