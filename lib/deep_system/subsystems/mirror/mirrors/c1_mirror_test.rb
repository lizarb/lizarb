class DeepSystem::C1MirrorTest < DeepSystem::MirrorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DeepSystem::C1Mirror
    assert_equality subject.class, DeepSystem::C1Mirror
  end

end
