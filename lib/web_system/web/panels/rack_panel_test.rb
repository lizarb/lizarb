class WebSystem::RackPanelTest < Liza::PanelTest

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :blue
  end

  # test :call do
  #   todo "write this"
  # end

end
