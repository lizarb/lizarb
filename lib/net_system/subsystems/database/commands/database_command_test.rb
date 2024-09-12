class NetSystem::DatabaseCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == NetSystem::DatabaseCommand
  end

end
