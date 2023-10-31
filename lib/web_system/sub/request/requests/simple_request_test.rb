class WebSystem::SimpleRequestTest < WebSystem::RequestTest

  test :subject_class do
    assert subject_class == WebSystem::SimpleRequest
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
