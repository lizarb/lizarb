class RedisDbTest < NetSystem::RedisDbTest

  test :subject_class do
    assert subject_class == RedisDb
    assert RedisDb.current.class == RedisDb
    assert NetSystem::RedisDb.current.class == RedisDb
    assert RedisDb.current == NetSystem::RedisDb.current
    assert RedisDb.current.client == NetSystem::RedisDb.current.client
    assert RedisDb.current.client.conn == NetSystem::RedisDb.current.client.conn
  end

end
