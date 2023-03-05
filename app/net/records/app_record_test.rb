class AppRecordTest < Liza::RecordTest

  test :subject_class do
    assert subject_class == AppRecord
    assert subject_class.db == SqliteDb
  end

end
