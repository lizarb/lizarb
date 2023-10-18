class NetSystem::RecordTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == NetSystem::Record
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
