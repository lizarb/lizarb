class DeepSystem::C99CompilerTest < DeepSystem::CompilerTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DeepSystem::C99Compiler
    assert_equality subject.class, DeepSystem::C99Compiler
  end

end
