class WebSystem::RackPanelTest < Liza::PanelTest

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  # test :call do
  #   todo "write this"
  # end

end
