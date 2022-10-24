class NetSystem
  class RedisClientTest < ClientTest

    def subject
      @subject ||= subject_class.new
    end

    test :subject_class do
      assert subject_class == Liza::RedisClient
    end

    test :subject do
      assert subject.conn.class == Redis
    end

    test :call do
      result = subject.call :keys
      assert result.class == Array
      assert result.count == 0
    end

    test :now do
      result = subject.now
      assert result.class == Array
      assert result.map(&:class) == [Integer, Integer]
    end

  end
end
