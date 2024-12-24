class DevSystem::UnitShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::UnitShell
    assert_equality subject.class, DevSystem::UnitShell
  end

  test :get_subunits_recursive do
    actual = subject_class.get_subunits_recursive(Unit).keys.map(&:to_s).sort
    expected = %w[Liza::System Liza::Box Liza::Panel Liza::Test Liza::Controller Liza::Part].sort
    assert_equality actual, expected

    actual = subject_class.get_subunits_recursive(Liza::System).map(&:to_s).sort
    expected = %w[DevSystem HappySystem NetSystem WebSystem WorkSystem MicroSystem DeskSystem CryptoSystem MediaSystem ArtSystem DeepSystem PrimeSystem LabSystem EcoSystem].sort
    assert_equality actual, expected

    actual = subject_class.get_subunits_recursive(DevSystem::DevBox).map(&:to_s).sort
    expected = %w[DevBox].sort
    assert_equality actual, expected
  end

end
