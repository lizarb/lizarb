class DeepSystem::CompilerCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DeepSystem::CompilerCommand
    assert_equality subject.class, DeepSystem::CompilerCommand
  end

end
