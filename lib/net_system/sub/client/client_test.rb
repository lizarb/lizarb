class NetSystem::ClientTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == NetSystem::Client
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
