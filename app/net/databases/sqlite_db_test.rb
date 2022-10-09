class SqliteDbTest < Liza::SqliteDbTest

  test :subject_class do
    assert subject_class == SqliteDb
    assert SqliteDb.current.class == SqliteDb
    assert Liza::SqliteDb.current.class == SqliteDb
    assert SqliteDb.current == Liza::SqliteDb.current
    assert SqliteDb.current.adapter == Liza::SqliteDb.current.adapter
    assert SqliteDb.current.adapter.conn == Liza::SqliteDb.current.adapter.conn
  end

end
