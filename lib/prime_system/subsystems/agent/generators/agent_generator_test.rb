class PrimeSystem::AgentGeneratorTest < DevSystem::ControllerGeneratorTest
  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, PrimeSystem::AgentGenerator
    assert_equality subject.class, PrimeSystem::AgentGenerator
  end

end
