class DevSystem::GemShellTest < DevSystem::ShellTest
  
  # 
  
  test :subject_class, :subject do
    assert_equality DevSystem::GemShell, subject_class
    assert_equality DevSystem::GemShell, subject.class
  end

  test :subject_class, :gemspec do
    assert_equality subject.gemspec.class, Gem::Specification
  end

  test :subject_class, :gemspecs do
    assert_equality subject.gemspecs.class, Array
  end

  test :subject_class, :gemfile_path do
    assert_equality subject.gemfile_path.class, Pathname
    assert subject.gemfile_path.to_s.end_with? "Gemfile"
  end

  test :subject_class, :gemfile_writable? do
    c = subject.gemfile_writable?.class
    assert c == TrueClass or c == FalseClass
  end
  
end
