class NetSystem::PgsqlClientTest < NetSystem::ClientTest

  test :subject_class do
    assert_equality subject_class, NetSystem::PgsqlClient
  end

  test :subject do
    assert_equality subject.conn.class, PG::Connection
  end

  test :call do
    result = subject.call "SELECT version();"
    assert_equality result.class,    PG::Result
    assert_equality result[0].class, Hash
    assert_equality result[0].keys,  ["version"]
  end if ENV["DBTEST"]

  test :now do
    result = subject.now
    assert_equality result.class,    PG::Result
    assert_equality result[0].class, Hash
    assert_equality result[0].keys,  ["now"]
  end if ENV["DBTEST"]

end
