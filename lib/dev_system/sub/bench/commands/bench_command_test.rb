class DevSystem::BenchCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert subject_class == DevSystem::BenchCommand
  end

end
