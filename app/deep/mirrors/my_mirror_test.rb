class MyMirrorTest < DeepSystem::C1MirrorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, MyMirror
    assert_equality subject.class, MyMirror
  end

end
