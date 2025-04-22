class DeepSystem::CompilerGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DeepSystem::CompilerGenerator
    assert_equality subject.class, DeepSystem::CompilerGenerator
  end

end
