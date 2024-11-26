class PrimeSystem::PrimeBoxTest < Liza::BoxTest

  section :systemic

  test :subject_class do
    assert_equality subject_class, PrimeSystem::PrimeBox
  end

  test_sections(
  )

  test :settings do
    assert_equality subject_class.log_level, 4
  end

end
