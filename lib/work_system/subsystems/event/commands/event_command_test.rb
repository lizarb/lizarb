class WorkSystem::EventCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, WorkSystem::EventCommand
    assert_equality subject.class, WorkSystem::EventCommand
  end

end
