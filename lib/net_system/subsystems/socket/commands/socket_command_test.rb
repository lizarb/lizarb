class NetSystem::SocketCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, NetSystem::SocketCommand
    assert_equality subject.class, NetSystem::SocketCommand
  end

end
