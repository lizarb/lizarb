class PostRecordTest < Liza::RecordTest

  test :subject_class do
    assert subject_class == PostRecord
    assert subject_class.db == SqliteDb
  end

end
