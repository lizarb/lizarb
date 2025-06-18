class NetSystem::SocketGeneratorTest < DevSystem::ControllerGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, NetSystem::SocketGenerator
    assert_equality subject.class, NetSystem::SocketGenerator
  end

end
