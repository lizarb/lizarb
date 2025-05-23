class NetSystem::Database < Liza::Controller

  def self.inherited sub
    super

    return if sub.name.nil?
    return if sub.name.end_with? "Db"
    raise "please rename #{sub.name} to #{sub.name}Db"
  end

  attr_reader :client

  def initialize client: get(:client).new
    @client = client
  end

  def self.set_client client_id
    set :client, Liza.const("#{client_id}_db_client")
  end

  def self.current
    Thread.current[last_namespace] ||= begin
      log "Connecting to #{last_namespace}"
      new
    end
  end

  def self.call(...); current.call(...); end
  def call(...); @client.call(...); end

end
