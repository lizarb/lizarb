class RedisDbTest < Liza::RedisDbTest

  test :subject_class do
    assert subject_class == RedisDb
    assert RedisDb.current.class == RedisDb
    assert Liza::RedisDb.current.class == RedisDb
    assert RedisDb.current == Liza::RedisDb.current
    assert RedisDb.current.adapter == Liza::RedisDb.current.adapter
    assert RedisDb.current.adapter.conn == Liza::RedisDb.current.adapter.conn
  end

end
