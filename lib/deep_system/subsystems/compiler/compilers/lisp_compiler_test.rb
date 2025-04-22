class DeepSystem::LispCompilerTest < DeepSystem::CompilerTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DeepSystem::LispCompiler
    assert_equality subject.class, DeepSystem::LispCompiler
  end

end
