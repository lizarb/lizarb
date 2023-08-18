class NetSystem::DatabaseCommandTest < Liza::CommandTest

  test :subject_class do
    assert subject_class == NetSystem::DatabaseCommand
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

end
