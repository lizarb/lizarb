class NetSystem::MongoDb < NetSystem::Database
  set_client :mongo

  def now
    client.now
  end

end
