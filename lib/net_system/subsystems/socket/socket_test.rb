class NetSystem::SocketTest < Liza::ControllerTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, NetSystem::Socket
    assert_equality subject.class, NetSystem::Socket
  end

  test_sections(
    :subsystem=>{
      :constants=>[],
      :class_methods=>[:call],
      :instance_methods=>[]
    }
  )

  test :settings do
    assert_equality subject_class.log_level, 4
  end

end
