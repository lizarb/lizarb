class RedisDbTest < Liza::RedisDbTest

  test :subject_class do
    assert subject_class == RedisDb
    assert RedisDb.current.class == RedisDb
    assert Liza::RedisDb.current.class == RedisDb
    assert RedisDb.current == Liza::RedisDb.current
    assert RedisDb.current.client == Liza::RedisDb.current.client
    assert RedisDb.current.client.conn == Liza::RedisDb.current.client.conn
  end

end
