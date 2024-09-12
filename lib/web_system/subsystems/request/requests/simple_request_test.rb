class WebSystem::SimpleRequestTest < WebSystem::RequestTest

  test :subject_class do
    assert subject_class == WebSystem::SimpleRequest
  end

end
