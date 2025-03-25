class PrimeSystem::InsightGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, PrimeSystem::InsightGenerator
    assert_equality subject.class, PrimeSystem::InsightGenerator
  end

end
