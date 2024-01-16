class WebSystem::RackTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == WebSystem::Rack
  end

  # test :call do
  #   todo "write this"
  # end

end
