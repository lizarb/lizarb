class SqliteDbTest < Liza::SqliteDbTest

  test :subject_class do
    assert subject_class == SqliteDb
    assert SqliteDb.current.class == SqliteDb
    assert Liza::SqliteDb.current.class == SqliteDb
    assert SqliteDb.current == Liza::SqliteDb.current
    assert SqliteDb.current.client == Liza::SqliteDb.current.client
    assert SqliteDb.current.client.conn == Liza::SqliteDb.current.client.conn
  end

end
