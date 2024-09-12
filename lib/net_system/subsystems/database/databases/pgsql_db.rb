class NetSystem::PgsqlDb < NetSystem::Database
  set_client :pgsql

  def now
    Time.parse client.now[0]["now"]
  end

end
