class DeepSystem::SmalltalkCompilerTest < DeepSystem::CompilerTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DeepSystem::SmalltalkCompiler
    assert_equality subject.class, DeepSystem::SmalltalkCompiler
  end

end
