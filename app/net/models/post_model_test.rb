class PostModelTest < Liza::ModelTest

  test :subject_class do
    assert subject_class == PostModel
    assert subject_class.db == SqliteDb.current
  end

end
