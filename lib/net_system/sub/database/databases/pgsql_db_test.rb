class NetSystem::PgsqlDbTest < NetSystem::DatabaseTest

  test :subject_class do
    assert_equality subject_class, NetSystem::PgsqlDb
  end

  test :subject do
    assert_equality subject.client.class, NetSystem::PgsqlClient
  end

  test :now do
    t = subject.now
    assert! t.is_a? Time
    assert_equality t.yday, Time.now.yday
  end

  # test :call do
  #   todo "write this"
  # end

end
