class NetSystem::MysqlDb < NetSystem::Database
  set_client :mysql

  def now
    client.now.first.values.first
  end

end
