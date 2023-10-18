class NetSystem::DatabaseCommandTest < Liza::CommandTest

  test :subject_class do
    assert subject_class == NetSystem::DatabaseCommand
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
