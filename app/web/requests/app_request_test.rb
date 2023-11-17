class AppRequestTest < WebSystem::RequestTest

  test :subject_class do
    assert subject_class == AppRequest
  end

end
