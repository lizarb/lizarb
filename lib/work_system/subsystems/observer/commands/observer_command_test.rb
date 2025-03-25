class WorkSystem::ObserverCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, WorkSystem::ObserverCommand
    assert_equality subject.class, WorkSystem::ObserverCommand
  end

end
