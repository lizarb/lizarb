class DevSystem::PalletShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::PalletShell
    assert_equality subject.class, DevSystem::PalletShell
  end

  test :subject_class, :colors do
    assert_equality 245,     subject_class.colors.count
    assert_equality [Array], subject_class.colors.map(&:class).uniq
  end
  
end
