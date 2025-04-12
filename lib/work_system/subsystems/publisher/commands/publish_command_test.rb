class WorkSystem::PublishCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, WorkSystem::PublishCommand
    assert_equality subject.class, WorkSystem::PublishCommand
  end

end
