class UserRecordTest < Liza::RecordTest

  test :subject_class do
    assert subject_class == UserRecord
    assert subject_class.db == SqliteDb
  end

end
