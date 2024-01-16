class WebSystem::RequestTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == WebSystem::Request
  end

  # test :call do
  #   todo "write this"
  # end

end
