class WorkSystem::PublisherGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, WorkSystem::PublisherGenerator
    assert_equality subject.class, WorkSystem::PublisherGenerator
  end

end
