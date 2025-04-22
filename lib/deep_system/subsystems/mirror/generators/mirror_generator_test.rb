class DeepSystem::MirrorGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DeepSystem::MirrorGenerator
    assert_equality subject.class, DeepSystem::MirrorGenerator
  end

end
