class NetSystem::RecordPanelTest < Liza::PanelTest

  test :subject_class do
    assert_equality subject_class, NetSystem::RecordPanel
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
