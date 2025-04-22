class MyNiceSystem::CalculatorMirrorTest < DeepSystem::C1MirrorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, MyNiceSystem::CalculatorMirror
    assert_equality subject.class, MyNiceSystem::CalculatorMirror
  end

end
