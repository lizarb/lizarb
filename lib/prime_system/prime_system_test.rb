class PrimeSystem::PrimeSystemTest < Liza::SystemTest

  section :systemic

  test :subject_class do
    assert_equality subject_class, PrimeSystem::PrimeSystem
  end

end
