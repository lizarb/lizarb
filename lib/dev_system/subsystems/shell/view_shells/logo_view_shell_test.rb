class DevSystem::LogoViewShellTest < DevSystem::ViewShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::LogoViewShell
    assert_equality subject.class, DevSystem::LogoViewShell
  end

  test :get_svg do
    content = subject.get_svg
    assert_equality content[0..26], "<svg\n    data-name=\"LizaRB\""
  end

end
