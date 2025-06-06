class NetSystem::MysqlDbClientTest < NetSystem::DbClientTest

  test :subject_class do
    assert_equality subject_class, NetSystem::MysqlDbClient
  end

  test :subject do
    assert_equality subject.conn.class, Mysql2::Client
  end

  test :call do
    result = subject.call "SELECT NOW();"
    assert_equality result.class, Mysql2::Result
    assert_equality result.first.keys, ["NOW()"]
  end if ENV["DBTEST"]

  test :now do
    result = subject.now
    assert_equality result.class, Mysql2::Result
    assert_equality result.first.keys, ["UTC_TIMESTAMP()"]
  end if ENV["DBTEST"]

end
