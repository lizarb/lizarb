class MyNiceSystem::SomethingNewMirrorTest < DeepSystem::C1MirrorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, MyNiceSystem::SomethingNewMirror
    assert_equality subject.class, MyNiceSystem::SomethingNewMirror
  end

end
