class NetSystem::ClientTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == NetSystem::Client
  end

end
