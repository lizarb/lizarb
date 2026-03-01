class PrimeSystem::AgentCommandTest < DevSystem::SimpleCommandTest
  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, PrimeSystem::AgentCommand
    assert_equality subject.class, PrimeSystem::AgentCommand
  end

end
