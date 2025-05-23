class NetSystem::RedisDbClientTest < NetSystem::DbClientTest

  def subject
    @subject ||= subject_class.new
  end

  test :subject_class do
    assert subject_class == NetSystem::RedisDbClient
  end

  test :subject do
    assert subject.conn.class == Redis
  end

  test :call do
    result = subject.call :keys
    assert result.class == Array
    assert result.count == 0
  end if ENV["DBTEST"]

  test :now do
    result = subject.now
    assert result.class == Array
    assert result.map(&:class) == [Integer, Integer]
  end if ENV["DBTEST"]

end
