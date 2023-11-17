class SqliteDbTest < NetSystem::SqliteDbTest

  test :subject_class do
    assert subject_class == SqliteDb
    # assert SqliteDb.current.class == SqliteDb
    # assert NetSystem::SqliteDb.current.class == SqliteDb
    # assert SqliteDb.current == NetSystem::SqliteDb.current
    # assert SqliteDb.current.client == NetSystem::SqliteDb.current.client
    # assert SqliteDb.current.client.conn == NetSystem::SqliteDb.current.client.conn
  end

end
