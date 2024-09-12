class DevSystem::BenchCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == DevSystem::BenchCommand
  end

end
