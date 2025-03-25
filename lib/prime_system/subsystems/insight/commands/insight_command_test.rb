class PrimeSystem::InsightCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, PrimeSystem::InsightCommand
    assert_equality subject.class, PrimeSystem::InsightCommand
  end

end
