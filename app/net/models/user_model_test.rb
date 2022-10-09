class UserModelTest < Liza::ModelTest

  test :subject_class do
    assert subject_class == UserModel
    assert subject_class.db == SqliteDb.current
  end

end
