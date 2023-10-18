class WebSystem::RackTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == WebSystem::Rack
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  # test :call do
  #   todo "write this"
  # end

end
