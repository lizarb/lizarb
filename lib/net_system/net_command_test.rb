class NetSystem::NetCommandTest < Liza::CommandTest

  test :subject_class do
    assert subject_class == NetSystem::NetCommand
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :red
  end

end
