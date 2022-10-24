class NetSystem
  class SqliteClientTest < ClientTest

    def subject
      @subject ||= subject_class.new ":memory:"
    end

    test :subject_class do
      assert subject_class == Liza::SqliteClient
    end

    test :subject do
      assert subject.conn.class == SQLite3::Database
    end

    test :call do
      result = subject.call "SELECT name, sql FROM sqlite_master WHERE type = 'table';"
      assert result == [["name", "sql"]]
    end

    test :now do
      result = subject.now
      assert result.class == Array
      assert result[0] == ["strftime('%Y-%m-%dT%H:%M:%S.%f', 'now', 'localtime')"]
      assert result[1][0].class == String
    end

  end
end
