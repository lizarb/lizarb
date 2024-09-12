class WebSystem::RequestCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == WebSystem::RequestCommand
  end

end
