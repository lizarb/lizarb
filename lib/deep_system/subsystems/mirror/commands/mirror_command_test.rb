class DeepSystem::MirrorCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DeepSystem::MirrorCommand
    assert_equality subject.class, DeepSystem::MirrorCommand
  end

end
