class NetSystem::DatabaseCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert subject_class == NetSystem::DatabaseCommand
  end

end
