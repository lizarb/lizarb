class WorkSystem::SubscriberGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, WorkSystem::SubscriberGenerator
    assert_equality subject.class, WorkSystem::SubscriberGenerator
  end

end
