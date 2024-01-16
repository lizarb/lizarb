class DevSystem::LogCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert_equality subject_class, DevSystem::LogCommand
  end

end
