class LabSystem::KrokiRequestTest < WebSystem::SimpleRequestTest

  test :subject_class do
    assert_equality subject_class, LabSystem::KrokiRequest
  end

end
