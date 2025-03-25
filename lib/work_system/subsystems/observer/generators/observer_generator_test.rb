class WorkSystem::ObserverGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, WorkSystem::ObserverGenerator
    assert_equality subject.class, WorkSystem::ObserverGenerator
  end

end
