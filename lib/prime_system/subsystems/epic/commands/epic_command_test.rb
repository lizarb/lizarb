class PrimeSystem::EpicCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, PrimeSystem::EpicCommand
    assert_equality subject.class, PrimeSystem::EpicCommand
  end

end
