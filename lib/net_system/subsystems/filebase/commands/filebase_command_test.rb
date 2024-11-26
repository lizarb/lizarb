class NetSystem::FilebaseCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, NetSystem::FilebaseCommand
    assert_equality subject.class, NetSystem::FilebaseCommand
  end

end
