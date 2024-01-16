class WebSystem::WebBoxTest < Liza::BoxTest

  test :subject_class do
    assert subject_class == WebSystem::WebBox
  end

  test :panels do
    assert subject_class[:request].is_a? WebSystem::RequestPanel
  end

end
