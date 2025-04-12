class WorkSystem::SubscribeCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, WorkSystem::SubscribeCommand
    assert_equality subject.class, WorkSystem::SubscribeCommand
  end

end
