class WebSystem::RequestCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert subject_class == WebSystem::RequestCommand
  end

end
