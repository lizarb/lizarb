class PrimeSystem::PumlConverterShellTest < DevSystem::ConverterShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, PrimeSystem::PumlConverterShell
    assert_equality subject.class, PrimeSystem::PumlConverterShell
  end

end
