class NetSystem::DatabasePanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == NetSystem::DatabasePanel
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  # test :call do
  #   todo "write this"
  # end

end
