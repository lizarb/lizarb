class NetSystem::PgsqlDbTest < NetSystem::DatabaseTest

  def subject
    @subject ||= begin
      hash = NetBox[:client].get(:pgsql_hash).dup
      hash[:dbname] = "postgres"
      client = NetSystem::PgsqlDbClient.new(hash)
      subject_class.new(client:)
    end
  end

  test :subject_class do
    assert_equality subject_class, NetSystem::PgsqlDb
  end

  test :subject do
    assert_equality subject.client.class, NetSystem::PgsqlDbClient
  end

  test :now do
    t = subject.now
    assert! t.is_a? Time
    assert_equality t.yday, Time.now.yday
  end if ENV["DBTEST"]

  # test :call do
  #   todo "write this"
  # end

end
