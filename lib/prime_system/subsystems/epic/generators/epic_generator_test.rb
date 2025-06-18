class PrimeSystem::EpicGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, PrimeSystem::EpicGenerator
    assert_equality subject.class, PrimeSystem::EpicGenerator
  end

end
