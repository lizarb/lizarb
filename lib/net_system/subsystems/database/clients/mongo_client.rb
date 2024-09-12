class NetSystem::MongoClient < NetSystem::Client
  require "mongo"

  # https://www.mongodb.com/
  # https://github.com/mongodb/mongo-ruby-driver
  def initialize hash={}
    self.class.call({})
    t = Time.now
    hash = NetBox[:client].get(:mongo_hash) if hash.empty?
    uri = "mongodb://#{hash[:host]}:#{hash[:port]}/#{hash[:database]}"
    @conn = Mongo::Client.new(uri)
  ensure
    log "#{t.diff}s | Connecting to #{hash}"
  end

  attr_reader :conn

  def call args
    t = Time.now
    raise NotImplementedError
  ensure
    log "#{t.diff}s | #{cmd_name} | #{args}"
  end

  def now
    t0 = Time.now
    server_status = @conn.database.command(serverStatus: 1)
    t = server_status.first['localTime']
    Time.at t.to_i
  ensure
    log "#{t0.diff}s | now | []"
  end

end
