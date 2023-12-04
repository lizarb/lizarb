class NetSystem::MongoClientTest < NetSystem::ClientTest

  test :subject_class do
    assert_equality subject_class, NetSystem::MongoClient
  end

  test  do
    assert_equality subject.conn.class, Mongo::Client
  end

  # test :call do
  #   #
  # end

  test :now do
    result = subject.now
    assert_equality result.class, Time
  end if ENV["DBTEST"]

end
