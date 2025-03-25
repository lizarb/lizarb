class WorkSystem::EventGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, WorkSystem::EventGenerator
    assert_equality subject.class, WorkSystem::EventGenerator
  end

end
