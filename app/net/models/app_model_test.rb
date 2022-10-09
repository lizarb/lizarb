class AppModelTest < Liza::ModelTest

  test :subject_class do
    assert subject_class == AppModel
    assert subject_class.db == SqliteDb.current
  end

end
